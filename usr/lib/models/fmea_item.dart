class FmeaItem {
  String id;
  String processName; // نام فرآیند
  String failureMode; // حالت خرابی
  String failureEffect; // اثر خرابی
  int severity; // شدت (S)
  int occurrence; // وقوع (O)
  int detection; // تشخیص (D)
  String recommendedAction; // اقدام پیشنهادی

  FmeaItem({
    required this.id,
    required this.processName,
    required this.failureMode,
    required this.failureEffect,
    required this.severity,
    required this.occurrence,
    required this.detection,
    this.recommendedAction = '',
  });

  // محاسبه نمره اولویت ریسک
  int get rpn => severity * occurrence * detection;
}
