import 'dart:io';
import 'package:google_generative_ai/package_generative_ai.dart';
import 'package:excel/excel.dart';

/// HƯỚNG DẪN CHẠY:
/// 1. Thay 'YOUR_API_KEY' bằng key thật của bạn.
/// 2. Tạo một file excel đơn giản 'test.xlsx' cùng thư mục chạy.
/// 3. Chạy lệnh: dart run test_scripts.dart
void main() async {
  print('--- 1. TEST GEMINI API ---');
  final apiKey = 'YOUR_API_KEY'; // TODO: Điền API Key của Gemini
  
  if (apiKey != 'YOUR_API_KEY') {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: apiKey,
      );
      
      final content = [Content.text('Chào bạn, bạn là trợ lý đánh giá Capstone Project phải không?')];
      final response = await model.generateContent(content);
      
      print('✅ Gọi Gemini thành công! (HTTP 200)');
      print('🤖 Trả lời: ${response.text}');
    } catch (e) {
      print('❌ Lỗi gọi Gemini: $e');
    }
  } else {
    print('⚠️ Bỏ qua test Gemini vì chưa điền API Key.');
  }

  print('\n--- 2. TEST EXCEL PARSER ---');
  final file = 'test.xlsx'; // TODO: Đảm bảo có file này
  if (File(file).existsSync()) {
    try {
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      print('✅ Đọc file Excel thành công!');
      for (var table in excel.tables.keys) {
        print('Sheet: $table');
        print('Số cột: ${excel.tables[table]?.maxColumns}');
        print('Số dòng: ${excel.tables[table]?.maxRows}');
        
        // In thử dòng đầu tiên (Header)
        if (excel.tables[table]?.rows.isNotEmpty ?? false) {
           var headers = excel.tables[table]!.rows.first.map((e) => e?.value).toList();
           print('Headers: $headers');
        }
      }
    } catch (e) {
      print('❌ Lỗi đọc Excel: $e');
    }
  } else {
    print('⚠️ Không tìm thấy file $file. Hãy tạo một file mẫu để test.');
  }
}
