// lib/models/dashboard_models.dart

/// ---------- COMMON NUM PARSER ----------
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

/// ---------- STATS & SALES ----------

class DashboardStats {
  final int totalOrders;
  final int completedOrders;
  final double orderAmount;
  final int totalProducts;

  DashboardStats({
    required this.totalOrders,
    required this.completedOrders,
    required this.orderAmount,
    required this.totalProducts,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalOrders: _toInt(json['totalOrders']),
      completedOrders: _toInt(json['completedOrders']),
      orderAmount: _toDouble(json['orderAmount']),
      totalProducts: _toInt(json['totalProducts']),
    );
  }
}

class SalesEntry {
  final String name;
  final double sales;

  SalesEntry({
    required this.name,
    required this.sales,
  });

  factory SalesEntry.fromJson(Map<String, dynamic> json) {
    return SalesEntry(
      name: json['name']?.toString() ?? '',
      sales: _toDouble(json['sales']),
    );
  }
}

/// ---------- USER / ADDRESS ----------

class OrderUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;

  OrderUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  /// Supports:
  /// - string: "68ef35a7..."  (dashboard API)
  /// - object: {...}          (restaurantorders API)
  factory OrderUser.fromJson(dynamic json) {
    if (json == null) return OrderUser();

    if (json is String) {
      return OrderUser(id: json);
    }

    if (json is Map<String, dynamic>) {
      return OrderUser(
        id: json['_id']?.toString() ?? json['id']?.toString(),
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
        email: json['email']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
      );
    }

    return OrderUser();
  }
}

class OrderAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? addressType;

  OrderAddress({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.addressType,
  });

  factory OrderAddress.fromJson(dynamic json) {
    if (json == null) return OrderAddress();

    if (json is String) {
      return OrderAddress(street: json);
    }

    if (json is Map<String, dynamic>) {
      return OrderAddress(
        street: json['street']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        country: json['country']?.toString(),
        postalCode: json['postalCode']?.toString(),
        addressType: json['addressType']?.toString(),
      );
    }

    return OrderAddress();
  }
}

/// ---------- ORDER PRODUCT ----------

class OrderProduct {
  final String? restaurantProductId;
  final String? recommendedId;
  final int quantity;
  final bool isHalfPlate;
  final bool isFullPlate;
  final String name;
  final double price;
  final String? image;

  OrderProduct({
    this.restaurantProductId,
    this.recommendedId,
    required this.quantity,
    required this.isHalfPlate,
    required this.isFullPlate,
    required this.name,
    required this.price,
    this.image,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      restaurantProductId: json['restaurantProductId']?.toString(),
      recommendedId: json['recommendedId']?.toString(),
      quantity: _toInt(json['quantity']),
      isHalfPlate: (json['isHalfPlate'] ?? false) as bool,
      isFullPlate: (json['isFullPlate'] ?? false) as bool,
      name: json['name']?.toString() ?? '',
      price: _toDouble(json['price']),
      image: json['image']?.toString(),
    );
  }
}

/// ---------- ORDER ----------

class OrderModel {
  final String id;
  final OrderUser? user;
  final OrderAddress? deliveryAddress;
  final String paymentMethod;
  final double platformCharge;
  final String paymentStatus;
  final double gstAmount;
  final String orderStatus;
  final String? deliveryStatus;
  final List<OrderProduct> products;
  final int totalItems;
  final double subTotal;
  final double deliveryCharge;
  final double couponDiscount;
  final double totalPayable;
  final DateTime? createdAt;
  final String? paymentType;

  OrderModel({
    required this.id,
    this.user,
    this.deliveryAddress,
    required this.paymentMethod,
    required this.platformCharge,
    required this.paymentStatus,
    required this.gstAmount,
    required this.orderStatus,
    this.deliveryStatus,
    required this.products,
    required this.totalItems,
    required this.subTotal,
    required this.deliveryCharge,
    required this.couponDiscount,
    required this.totalPayable,
    this.createdAt,
    this.paymentType,
  });

  bool get isPending =>
      orderStatus.toLowerCase() == 'pending' ||
      paymentStatus.toLowerCase() == 'pending';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productsJson = (json['products'] as List?) ?? [];

    return OrderModel(
      id: json['_id']?.toString() ?? '',
      user: OrderUser.fromJson(json['userId']),
      deliveryAddress: OrderAddress.fromJson(json['deliveryAddress']),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      platformCharge: _toDouble(json['platformCharge']),
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      gstAmount: _toDouble(json['gstAmount']),
      orderStatus: json['orderStatus']?.toString() ?? '',
      deliveryStatus: json['deliveryStatus']?.toString(),
      products: productsJson
          .whereType<Map<String, dynamic>>()
          .map((e) => OrderProduct.fromJson(e))
          .toList(),
      totalItems: _toInt(json['totalItems']),
      subTotal: _toDouble(json['subTotal']),
      deliveryCharge: _toDouble(json['deliveryCharge']),
      couponDiscount: _toDouble(json['couponDiscount']),
      totalPayable: _toDouble(json['totalPayable']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      paymentType: json['paymentType']?.toString(),
    );
  }
}

/// ---------- PRODUCTS ----------

class RecommendedItemCategory {
  final String? id;
  final String? categoryName;

  RecommendedItemCategory({this.id, this.categoryName});

  factory RecommendedItemCategory.fromJson(Map<String, dynamic> json) {
    return RecommendedItemCategory(
      id: json['_id']?.toString(),
      categoryName: json['categoryName']?.toString(),
    );
  }
}

class RecommendedItem {
  final String id;
  final String name;
  final double price;
  final double halfPlatePrice;
  final double fullPlatePrice;
  final double discount;
  final List<String> tags;
  final String content;
  final String image;
  final RecommendedItemCategory? category;
  final String status;
  final String preparationTime;

  RecommendedItem({
    required this.id,
    required this.name,
    required this.price,
    required this.halfPlatePrice,
    required this.fullPlatePrice,
    required this.discount,
    required this.tags,
    required this.content,
    required this.image,
    required this.category,
    required this.status,
    required this.preparationTime,
  });

  factory RecommendedItem.fromJson(Map<String, dynamic> json) {
    return RecommendedItem(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _toDouble(json['price']),
      halfPlatePrice: _toDouble(json['halfPlatePrice']),
      fullPlatePrice: _toDouble(json['fullPlatePrice']),
      discount: _toDouble(json['discount']),
      tags: (json['tags'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      content: json['content']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      category: json['category'] is Map<String, dynamic>
          ? RecommendedItemCategory.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
      status: json['status']?.toString() ?? '',
      preparationTime: json['preparationTime']?.toString() ?? '',
    );
  }
}

class RestaurantProduct {
  final String productId;
  final String restaurantName;
  final String locationName;
  final RecommendedItem recommendedItem;

  RestaurantProduct({
    required this.productId,
    required this.restaurantName,
    required this.locationName,
    required this.recommendedItem,
  });

  factory RestaurantProduct.fromJson(Map<String, dynamic> json) {
    return RestaurantProduct(
      productId: json['productId']?.toString() ?? '',
      restaurantName: json['restaurantName']?.toString() ?? '',
      locationName: json['locationName']?.toString() ?? '',
      recommendedItem: RecommendedItem.fromJson(
        (json['recommendedItem'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }

  String get displayName => recommendedItem.name;
  double get displayPrice => recommendedItem.price;
  String get categoryName =>
      recommendedItem.category?.categoryName ?? 'General';
  String get imageUrl => recommendedItem.image;
}

/// ---------- DASHBOARD RESPONSE ----------

class DashboardResponse {
  final DashboardStats stats;
  final Map<String, List<SalesEntry>> salesByTimeframe;
  final List<OrderModel> orders;
  final List<OrderModel> pendingOrders;

  DashboardResponse({
    required this.stats,
    required this.salesByTimeframe,
    required this.orders,
    required this.pendingOrders,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    final stats =
        DashboardStats.fromJson((json['stats'] as Map<String, dynamic>? ?? {}));

    final salesDataMap = <String, List<SalesEntry>>{};
    final salesDataJson = json['salesData'] as Map<String, dynamic>? ?? {};
    for (final entry in salesDataJson.entries) {
      final listJson = (entry.value as List?) ?? [];
      salesDataMap[entry.key] = listJson
          .whereType<Map<String, dynamic>>()
          .map((e) => SalesEntry.fromJson(e))
          .toList();
    }

    final ordersJson = (json['orders'] as List?) ?? [];
    final pendingJson = (json['pendingOrders'] as List?) ?? [];

    return DashboardResponse(
      stats: stats,
      salesByTimeframe: salesDataMap,
      orders: ordersJson
          .whereType<Map<String, dynamic>>()
          .map((e) => OrderModel.fromJson(e))
          .toList(),
      pendingOrders: pendingJson
          .whereType<Map<String, dynamic>>()
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }
}
