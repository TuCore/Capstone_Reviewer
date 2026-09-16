import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/review_audit_result.dart';

class ReviewState {
  final ReviewAuditResult? result;
  final String? rawContent;
  final int selectedTabIndex;
  final bool isExporting;
  final String? exportPath;
  final String? filterStatus; // null = all, PASS, WARNING, MISSING

  const ReviewState({
    this.result,
    this.rawContent,
    this.selectedTabIndex = 0,
    this.isExporting = false,
    this.exportPath,
    this.filterStatus,
  });

  bool get isParsed => result != null;

  ReviewState copyWith({
    ReviewAuditResult? result,
    String? rawContent,
    int? selectedTabIndex,
    bool? isExporting,
    String? exportPath,
    String? filterStatus,
  }) {
    return ReviewState(
      result: result ?? this.result,
      rawContent: rawContent ?? this.rawContent,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isExporting: isExporting ?? this.isExporting,
      exportPath: exportPath ?? this.exportPath,
      filterStatus: filterStatus,
    );
  }
}

class ReviewController extends Notifier<ReviewState> {
  @override
  ReviewState build() => const ReviewState();

  void parseResult(String aiResponse) {
    var parsed = ReviewAuditResult.tryParse(aiResponse);
    state = ReviewState(
      result: parsed,
      rawContent: aiResponse,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  void setFilterStatus(String? status) {
    state = state.copyWith(filterStatus: status);
  }

  void setExporting(bool value) {
    state = state.copyWith(isExporting: value);
  }
}

final reviewControllerProvider =
    NotifierProvider<ReviewController, ReviewState>(() {
  return ReviewController();
});
