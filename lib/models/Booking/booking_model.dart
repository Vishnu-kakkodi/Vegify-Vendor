class BookingModel {
  final String id;
  final String userName;
  final String email;
  final String phone;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double subTotal;
  final double total;
  final double deliveryCharge;
  final double discount;
  final int totalItems;
  final int? preparationTime;
  final DateTime createdAt;
  final Map raw;

  BookingModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phone,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subTotal,
    required this.total,
    required this.deliveryCharge,
    required this.discount,
    required this.totalItems,
    required this.preparationTime,
    required this.createdAt,
    required this.raw,
  });

  factory BookingModel.fromJson(Map json) {
    return BookingModel(
      id: json['_id'],
      userName:
          "${json['userId']?['firstName'] ?? ''} ${json['userId']?['lastName'] ?? ''}",
      email: json['userId']?['email'] ?? 'N/A',
      phone: json['userId']?['phoneNumber'] ?? 'N/A',
      status: json['orderStatus'],
      paymentMethod: json['paymentMethod'] ?? 'N/A',
      paymentStatus: json['paymentStatus'] ?? 'N/A',
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      total: (json['totalPayable'] ?? 0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? 0).toDouble(),
      discount: (json['couponDiscount'] ?? 0).toDouble(),
      totalItems: json['totalItems'] ?? 0,
      preparationTime: json['preparationTime'],
      createdAt: DateTime.parse(json['createdAt']),
      raw: json,
    );
  }
}
