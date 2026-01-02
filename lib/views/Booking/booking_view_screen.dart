import 'package:flutter/material.dart';
import 'package:vegiffyy_vendor/models/Booking/booking_model.dart';

class BookingViewScreen extends StatelessWidget {
  final BookingModel booking;
  const BookingViewScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final products = (booking.raw['products'] ?? []) as List;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${booking.id.substring(0, 6)}"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _orderSummaryCard(),
          const SizedBox(height: 16),

          _customerCard(),
          const SizedBox(height: 16),

          _productsSection(products),
          const SizedBox(height: 16),

          _priceBreakdownCard(),
        ],
      ),
    );
  }

  // ===================== ORDER SUMMARY =====================

  Widget _orderSummaryCard() {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.receipt_long),
        title: Text(
          "Order Status",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          booking.status,
          style: TextStyle(
            color: _statusColor(booking.status),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          "₹${booking.total}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ===================== CUSTOMER =====================

  Widget _customerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _infoRow(Icons.person, booking.userName),
            _infoRow(Icons.phone, booking.phone),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ===================== PRODUCTS =====================

  Widget _productsSection(List products) {
    if (products.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: const [
              Icon(Icons.inventory_2, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text("No products found"),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ordered Items",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...products.map((p) => _productTile(p)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _productTile(dynamic p) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          p['image'] ?? "",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported),
        ),
      ),
      title: Text(
        p['name'],
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Quantity: ${p['quantity']}"),
      trailing: Text(
        "₹${p['price'] ?? ''}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // ===================== PRICE =====================

  Widget _priceBreakdownCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _priceRow("Subtotal", booking.subTotal),
            _priceRow("Delivery", booking.deliveryCharge),
            _priceRow("Discount", booking.discount),
            const Divider(),
            _priceRow(
              "Total",
              booking.total,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, dynamic value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== STATUS COLOR =====================

  Color _statusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Accepted":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
