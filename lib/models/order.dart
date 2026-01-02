import 'package:vegiffyy_vendor/models/Booking/booking_model.dart';

class Order {
  final String? id;
  final DateTime? createdAt;
  final String? paymentMethod;
  final String? paymentStatus;

  final double? subTotal;
  final double? totalPayable;
  final double? deliveryCharge;
  final double? gstAmount;
  final double? gstOnDelivery;
  final double? packingCharges;
  final double? platformCharge;
  final double? couponDiscount;
  final double? amountSavedOnOrder;

  final int? totalItems;

  final List<OrderProduct> products;
  final OrderRestaurant restaurant;
  final DeliveryAddress? deliveryAddress;

  Order({
    required this.id,
    required this.createdAt,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subTotal,
    required this.totalPayable,
    required this.deliveryCharge,
    required this.gstAmount,
    required this.gstOnDelivery,
    required this.packingCharges,
    required this.platformCharge,
    required this.couponDiscount,
    required this.amountSavedOnOrder,
    required this.totalItems,
    required this.products,
    required this.restaurant,
    required this.deliveryAddress,
  });

  /// 🔁 Adapter from BookingModel
  factory Order.fromBooking(BookingModel b) {
    final raw = b.raw;

    return Order(
      id: b.id,
      createdAt: DateTime.tryParse(raw['createdAt'] ?? ''),
      paymentMethod: raw['paymentMethod'],
      paymentStatus: raw['paymentStatus'],
      subTotal: (b.subTotal ?? 0).toDouble(),
      totalPayable: (b.total ?? 0).toDouble(),
      deliveryCharge: (b.deliveryCharge ?? 0).toDouble(),
      gstAmount: raw['gstAmount']?.toDouble(),
      gstOnDelivery: raw['gstOnDelivery']?.toDouble(),
      packingCharges: raw['packingCharges']?.toDouble(),
      platformCharge: raw['platformCharge']?.toDouble(),
      couponDiscount: raw['discount']?.toDouble(),
      amountSavedOnOrder: raw['amountSavedOnOrder']?.toDouble(),
      totalItems: raw['totalItems'],
      products: (raw['products'] as List)
          .map((p) => OrderProduct.fromJson(p))
          .toList(),
      restaurant: OrderRestaurant(
        restaurantName: raw['restaurantName'],
        locationName: raw['locationName'],
      ),
      deliveryAddress: raw['deliveryAddress'] != null
          ? DeliveryAddress.fromJson(raw['deliveryAddress'])
          : null,
    );
  }
}


class OrderProduct {
  final String? name;
  final String? image;
  final int? quantity;
  final double? price;
  final double? basePrice;
  final bool? isHalfPlate;
  final bool? isFullPlate;

  OrderProduct({
    this.name,
    this.image,
    this.quantity,
    this.price,
    this.basePrice,
    this.isHalfPlate,
    this.isFullPlate,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      name: json['name'],
      image: json['image'],
      quantity: json['quantity'],
      price: json['price']?.toDouble(),
      basePrice: json['basePrice']?.toDouble(),
      isHalfPlate: json['isHalfPlate'],
      isFullPlate: json['isFullPlate'],
    );
  }
}



class OrderRestaurant {
  final String? restaurantName;
  final String? locationName;

  OrderRestaurant({
    this.restaurantName,
    this.locationName,
  });
}



class DeliveryAddress {
  final String? street;
  final String? city;

  DeliveryAddress({this.street, this.city});

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      street: json['street'],
      city: json['city'],
    );
  }
}
