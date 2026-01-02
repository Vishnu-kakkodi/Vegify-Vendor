// lib/Providers/dashboard_provider.dart
import 'package:flutter/foundation.dart';
import 'package:vegiffyy_vendor/models/dashboard_models.dart';
import 'package:vegiffyy_vendor/services/dashboard_service.dart';

enum DashboardStatus { idle, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service;

  DashboardProvider({DashboardService? service})
      : _service = service ?? DashboardService();

  DashboardStatus _status = DashboardStatus.idle;
  DashboardStatus get status => _status;

  DashboardStats? _stats;
  DashboardStats? get stats => _stats;

  Map<String, List<SalesEntry>> _salesByTimeframe = {};
  Map<String, List<SalesEntry>> get salesByTimeframe => _salesByTimeframe;

  String _selectedTimeframe = 'Today';
  String get selectedTimeframe => _selectedTimeframe;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  List<OrderModel> _pendingOrders = [];
  List<OrderModel> get pendingOrders => _pendingOrders;

  List<OrderModel> _bufferOrders = [];
  List<OrderModel> get bufferOrders => _bufferOrders;

  OrderModel? _currentBufferOrder;
  OrderModel? get currentBufferOrder => _currentBufferOrder;

  List<RestaurantProduct> _products = [];
  List<RestaurantProduct> get products => _products;

  bool _showBuffer = false;
  bool get showBuffer => _showBuffer;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == DashboardStatus.loading;

  List<SalesEntry> get currentSales =>
      _salesByTimeframe[_selectedTimeframe] ?? const [];

  // --------------------------- PUBLIC METHODS ---------------------------

  Future<void> loadAll(String vendorId) async {
    _status = DashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Dashboard
      final dash = await _service.fetchDashboard(vendorId);
      _stats = dash.stats;
      _salesByTimeframe = dash.salesByTimeframe;
      _orders = dash.orders;

      // pendingOrders from /vendor/dashboard (if any)
      _pendingOrders = dash.pendingOrders;

      // Restaurant orders for buffer (Pending only)
      final restaurantOrders =
          await _service.fetchRestaurantOrders(vendorId);

      _bufferOrders = restaurantOrders
          .where((o) => o.orderStatus.toLowerCase() == 'pending')
          .toList();

      if (_bufferOrders.isNotEmpty) {
        _showBuffer = true;
        _currentBufferOrder = _bufferOrders.first;
      } else {
        _showBuffer = false;
        _currentBufferOrder = null;
      }

      // Restaurant products
      _products = await _service.fetchRestaurantProducts(vendorId);

      _status = DashboardStatus.loaded;
    } catch (e) {
      _status = DashboardStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> loadPendingOrders(String vendorId) async {
  try {
    debugPrint('📡 Fetching pending orders...');
      _products = await _service.fetchRestaurantProducts(vendorId);

    // pendingOrders = _products;
    notifyListeners();
  } catch (e) {
    debugPrint('❌ Pending API failed: $e');
  }
}


  void changeTimeframe(String timeframe) {
    _selectedTimeframe = timeframe;
    notifyListeners();
  }

  void openBuffer() {
    _showBuffer = true;
    notifyListeners();
  }

  void closeBuffer() {
    _showBuffer = false;
    _currentBufferOrder = null;
    notifyListeners();
  }

  void selectBufferOrder(OrderModel order) {
    _currentBufferOrder = order;
    _showBuffer = true;
    notifyListeners();
  }

  void nextBufferOrder() {
    if (_bufferOrders.isEmpty || _currentBufferOrder == null) return;
    final index = _bufferOrders.indexOf(_currentBufferOrder!);
    final nextIndex = (index + 1) % _bufferOrders.length;
    _currentBufferOrder = _bufferOrders[nextIndex];
    notifyListeners();
  }

  Future<void> acceptOrder(String vendorId, String orderId) async {
    final success = await _service.acceptOrder(orderId, vendorId);
    if (!success) return;

    // Update local state
    _bufferOrders.removeWhere((o) => o.id == orderId);
    _pendingOrders.removeWhere((o) => o.id == orderId);

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = OrderModel(
        id: old.id,
        user: old.user,
        deliveryAddress: old.deliveryAddress,
        paymentMethod: old.paymentMethod,
        platformCharge: old.platformCharge,
        paymentStatus: old.paymentStatus,
        gstAmount: old.gstAmount,
        orderStatus: 'Accepted',
        deliveryStatus: old.deliveryStatus,
        products: old.products,
        totalItems: old.totalItems,
        subTotal: old.subTotal,
        deliveryCharge: old.deliveryCharge,
        couponDiscount: old.couponDiscount,
        totalPayable: old.totalPayable,
        createdAt: old.createdAt,
        paymentType: old.paymentType,
      );
    }

    if (_bufferOrders.isEmpty) {
      _showBuffer = false;
      _currentBufferOrder = null;
    } else {
      _currentBufferOrder = _bufferOrders.first;
    }

    notifyListeners();
  }

  Future<void> rejectOrder(String vendorId, String orderId) async {
    final success = await _service.rejectOrder(orderId, vendorId);
    if (!success) return;

    _bufferOrders.removeWhere((o) => o.id == orderId);
    _pendingOrders.removeWhere((o) => o.id == orderId);

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = OrderModel(
        id: old.id,
        user: old.user,
        deliveryAddress: old.deliveryAddress,
        paymentMethod: old.paymentMethod,
        platformCharge: old.platformCharge,
        paymentStatus: old.paymentStatus,
        gstAmount: old.gstAmount,
        orderStatus: 'Rejected',
        deliveryStatus: old.deliveryStatus,
        products: old.products,
        totalItems: old.totalItems,
        subTotal: old.subTotal,
        deliveryCharge: old.deliveryCharge,
        couponDiscount: old.couponDiscount,
        totalPayable: old.totalPayable,
        createdAt: old.createdAt,
        paymentType: old.paymentType,
      );
    }

    if (_bufferOrders.isEmpty) {
      _showBuffer = false;
      _currentBufferOrder = null;
    } else {
      _currentBufferOrder = _bufferOrders.first;
    }

    notifyListeners();
  }
}
