import 'dart:convert';
import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('LLM-as-a-Verifier - Phase 2 Unit Tests', () {
    test('parseHypothesesJson parses markdown fenced and clean JSON', () {
      final jsonRaw = '''```json
{
  "findings": [
    {
      "id": "1",
      "module": "M03",
      "claim": "Thiếu kiểm thử WIP Isolation khi PM xóa tài liệu",
      "target_rule": "WIP Isolation"
    },
    {
      "id": "2",
      "module": "M05",
      "claim": "Thiếu kiểm thử chữ ký số SmartCA giả mạo",
      "target_rule": "Digital Signature"
    }
  ]
}
```''';

      final result = AIService.parseHypothesesJson(jsonRaw);
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].module, 'M03');
      expect(result[0].claim, contains('WIP Isolation'));
      expect(result[1].targetRule, 'Digital Signature');
    });

    test('parseVerdictsJson parses verdicts from response', () {
      final jsonRaw = '''
{
  "verdicts": [
    {
      "id": "1",
      "is_verified": true,
      "quote": "Chỉ có Creator mới có quyền xóa file trong WIP",
      "explanation": "Tài liệu SRS quy định rõ chỉ Creator có quyền"
    },
    {
      "id": "2",
      "is_verified": false,
      "quote": "",
      "explanation": "Không tìm thấy căn cứ trong SRS"
    }
  ]
}
''';

      final verdicts = AIService.parseVerdictsJson(jsonRaw);
      expect(verdicts.length, 2);
      expect(verdicts[0]['id'], '1');
      expect(verdicts[0]['is_verified'], isTrue);
      expect(verdicts[1]['is_verified'], isFalse);
    });

    test('filterVerifiedFindings rejects hallucinated quotes and unverified claims', () {
      final hypotheses = [
        const QualitativeHypothesis(
          id: '1',
          module: 'M03',
          claim: 'Thiếu kiểm thử WIP Isolation',
        ),
        const QualitativeHypothesis(
          id: '2',
          module: 'M04',
          claim: 'Thiếu kiểm thử tải mô hình BIM 3D lớn',
        ),
        const QualitativeHypothesis(
          id: '3',
          module: 'M05',
          claim: 'Thiếu kiểm thử lỗi SmartCA',
        ),
      ];

      final rawVerdicts = [
        // 1: is_verified == true, quote EXISTS in source -> SHOULD KEEP
        {
          'id': '1',
          'is_verified': true,
          'quote': 'Only Creator can delete files in WIP area',
          'explanation': 'SRS quy định rõ',
        },
        // 2: is_verified == true, but quote is INVENTED (hallucinated) -> MUST REJECT!
        {
          'id': '2',
          'is_verified': true,
          'quote': 'BIM files over 500MB must fail with code E4001', // NOT IN SOURCE!
          'explanation': 'AI tự bịa ra quote này',
        },
        // 3: is_verified == false -> MUST REJECT!
        {
          'id': '3',
          'is_verified': false,
          'quote': '',
          'explanation': 'Không có căn cứ',
        },
      ];

      final sourceTexts = [
        'Document Management module specification. Only Creator can delete files in WIP area. Published files cannot be modified directly.',
        'Test cases list for M01 to M10.',
      ];

      final verified = AIService.filterVerifiedFindings(
        hypotheses: hypotheses,
        rawVerdicts: rawVerdicts,
        sourceTexts: sourceTexts,
      );

      expect(verified.length, 1);
      expect(verified.first.id, '1');
      expect(verified.first.module, 'M03');
      expect(verified.first.quote, 'Only Creator can delete files in WIP area');
      expect(verified.any((v) => v.id == '2'), isFalse); // Bị loại vì quote bịa!
      expect(verified.any((v) => v.id == '3'), isFalse); // Bị loại vì is_verified false!
    });

    test('runLlmVerifierPipeline executes 2 passes with MockClient and filters output', () async {
      var callIndex = 0;
      final mockClient = MockClient((request) async {
        callIndex++;
        if (callIndex == 1) {
          // Pass 1: Generator response
          final genResponse = {
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'text': jsonEncode({
                        'findings': [
                          {
                            'id': 'h1',
                            'module': 'M03',
                            'claim': 'WIP Isolation violation',
                          },
                          {
                            'id': 'h2',
                            'module': 'M08',
                            'claim': 'Dashboard permissions violation',
                          }
                        ]
                      })
                    }
                  ]
                }
              }
            ]
          };
          return http.Response(jsonEncode(genResponse), 200);
        } else {
          // Pass 2: Verifier response
          final verResponse = {
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'text': jsonEncode({
                        'verdicts': [
                          {
                            'id': 'h1',
                            'is_verified': true,
                            'quote': 'Creator only in WIP',
                            'explanation': 'Valid rule in SRS',
                          },
                          {
                            'id': 'h2',
                            'is_verified': true,
                            'quote': 'Invented dashboard quote that does not exist',
                            'explanation': 'Hallucinated',
                          }
                        ]
                      })
                    }
                  ]
                }
              }
            ]
          };
          return http.Response(jsonEncode(verResponse), 200);
        }
      });

      final aiService = AIService(
        apiKey: 'AIzaSyFakeKeyForTest123456789012345678',
        provider: AIProvider.gemini,
        client: mockClient,
      );

      final sources = [
        'SRS Section: Creator only in WIP for modifying or deleting files.',
      ];

      final results = await aiService.runLlmVerifierPipeline(
        srsContent: 'SRS Content',
        testCasesContent: 'Test cases',
        rawSources: sources,
      );

      expect(results.length, 1);
      expect(results.first.id, 'h1');
      expect(results.first.quote, 'Creator only in WIP');
      expect(results.first.module, 'M03');
    });

    test('parseGeneratorResultJson parses project metadata and 6-axis findings', () {
      const rawJson = '''```json
{
  "project_info": {
    "topic": "CDE System for BIM Management",
    "description": "Nền tảng quản lý môi trường dữ liệu chung cho ngành xây dựng",
    "tech_stack": ["Flutter", "PostgreSQL", "Supabase", "Azure"],
    "features": ["Quản lý tài liệu WIP", "Phê duyệt Shared", "Chữ ký số"]
  },
  "findings": [
    {
      "id": "ax1",
      "axis": "Tech Mismatch",
      "module": "Database",
      "claim": "SRS ghi PostgreSQL nhưng Excel test Azure SQL Database",
      "target_rule": "Tech Mismatch",
      "quote": "PostgreSQL (Supabase)"
    },
    {
      "id": "ax2",
      "axis": "Feature Omission",
      "module": "Chữ ký số",
      "claim": "Chức năng chữ ký số trong SRS không có test case nào",
      "target_rule": "Feature Omission"
    }
  ]
}
```''';

      final result = AIService.parseGeneratorResultJson(rawJson);
      expect(result.projectInfo.topic, 'CDE System for BIM Management');
      expect(result.projectInfo.description, contains('quản lý môi trường dữ liệu chung'));
      expect(result.projectInfo.techStack, containsAll(['Flutter', 'PostgreSQL', 'Supabase', 'Azure']));
      expect(result.projectInfo.features.length, 3);
      expect(result.hypotheses.length, 2);
      expect(result.hypotheses.first.axis, 'Tech Mismatch');
      expect(result.hypotheses.first.targetRule, 'Tech Mismatch');
    });

    test('filterVerifiedFindings retains 6-axis tags and blocks 100% fabricated quotes', () {
      final hypotheses = [
        const QualitativeHypothesis(
          id: '1',
          axis: 'Tech Mismatch',
          module: 'Database',
          claim: 'Mâu thuẫn cơ sở dữ liệu giữa SRS và Test Report',
        ),
        const QualitativeHypothesis(
          id: '2',
          axis: 'Logic Violation',
          module: 'WIP Area',
          claim: 'Quy tắc WIP cho phép PM can thiệp trái phép',
        ),
      ];

      final rawVerdicts = [
        {
          'id': '1',
          'is_verified': true,
          'quote': 'Database: PostgreSQL (Supabase)',
          'explanation': 'Khớp thật trong mục 2.3 của SRS',
        },
        {
          'id': '2',
          'is_verified': true,
          'quote': 'PM has supreme privilege to wipe all files instantly without audit log',
          'explanation': 'Quote bịa hoàn toàn không có trong tài liệu',
        },
      ];

      final realDocText = [
        'SRS Document: Database: PostgreSQL (Supabase) is selected for data persistence.',
        'Test Report: Environment deployed on AWS EC2.',
      ];

      final verified = AIService.filterVerifiedFindings(
        hypotheses: hypotheses,
        rawVerdicts: rawVerdicts,
        sourceTexts: realDocText,
      );

      expect(verified.length, 1);
      expect(verified.first.id, '1');
      expect(verified.first.axis, 'Tech Mismatch');
      expect(verified.first.quote, 'Database: PostgreSQL (Supabase)');
      // Quote bịa của ca #2 bị loại bỏ hoàn toàn
      expect(verified.any((v) => v.id == '2'), isFalse);
    });
  });
}
