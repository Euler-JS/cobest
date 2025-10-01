class InstallmentModel {
  final int? installmentNumber;
  final double? amount;
  final String? amountFormatted;
  final String? dueDate;
  final String? dueDateFormatted;
  final String? status;
  final String? statusText;

  InstallmentModel({
    this.installmentNumber,
    this.amount,
    this.amountFormatted,
    this.dueDate,
    this.dueDateFormatted,
    this.status,
    this.statusText,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      installmentNumber: json['installment_number'],
      amount: _parseDouble(json['amount']),
      amountFormatted: json['amount_formatted'],
      dueDate: json['due_date'],
      dueDateFormatted: json['due_date_formatted'],
      status: json['status'],
      statusText: json['status_text'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'installment_number': installmentNumber,
      'amount': amount,
      'amount_formatted': amountFormatted,
      'due_date': dueDate,
      'due_date_formatted': dueDateFormatted,
      'status': status,
      'status_text': statusText,
    };
  }
}

class OrderInstallmentDetailsModel {
  final int? orderId;
  final String? paymentMethod;
  final int? paymentPeriod;
  final double? installmentValue;
  final List<InstallmentModel>? installmentSchedule;

  OrderInstallmentDetailsModel({
    this.orderId,
    this.paymentMethod,
    this.paymentPeriod,
    this.installmentValue,
    this.installmentSchedule,
  });

  factory OrderInstallmentDetailsModel.fromJson(Map<String, dynamic> json) {
    var orderData = json['order'] ?? {};
    var scheduleList = orderData['installment_schedule'] as List?;
    
    return OrderInstallmentDetailsModel(
      orderId: orderData['id'],
      paymentMethod: orderData['payment_method'],
      paymentPeriod: orderData['payment_period'],
      installmentValue: _parseDouble(orderData['installment_value']),
      installmentSchedule: scheduleList?.map((item) => InstallmentModel.fromJson(item)).toList(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'payment_method': paymentMethod,
      'payment_period': paymentPeriod,
      'installment_value': installmentValue,
      'installment_schedule': installmentSchedule?.map((item) => item.toJson()).toList(),
    };
  }
}