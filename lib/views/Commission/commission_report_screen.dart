import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vegiffyy_vendor/helper/vendor_storage_helper.dart';

class CommissionReportScreen extends StatefulWidget {
  const CommissionReportScreen({super.key});

  @override
  State<CommissionReportScreen> createState() =>
      _CommissionReportScreenState();
}

class _CommissionReportScreenState extends State<CommissionReportScreen> {
            String? vendorId;

  final String baseUrl = "https://api.vegiffyy.com/api/vendor";

  bool loading = true;
  String? error;

  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];

  String search = "";
  DateTime? startDate;
  DateTime? endDate;

  Map<String, dynamic> summary = {
    "totalOrders": 0,
    "totalSales": 0.0,
    "totalCommission": 0.0,
    "totalVendorEarning": 0.0,
    "avgCommission": 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadVendor();
  }


        void _loadVendor() {
  final vendor = VendorPreferences.getVendor();

  if (vendor == null) {
    // Safety fallback (auto logout / redirect)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session expired. Please login again")),
      );
      Navigator.pop(context);
    });
    return;
  }

  vendorId = vendor.id;

          fetchOrders();


}

  /* ================= API ================= */

  Future<void> fetchOrders() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      final res = await http.get(
        Uri.parse("$baseUrl/restaurantorders/$vendorId"),
      );

      if (res.statusCode != 200) {
        throw "Failed to fetch orders";
      }

      final body = jsonDecode(res.body);

      if (body['success'] == true) {
        final delivered = body['data']
            .where((o) =>
                o['orderStatus'] == "Delivered" ||
                o['orderStatus'] == "delivered")
            .toList();

        orders = delivered.map<Map<String, dynamic>>((order) {
          final commissionPercent =
              order['restaurantId']?['commission'] ?? 15;

          final subTotal = (order['subTotal'] ?? 0).toDouble();
          final totalPayable = (order['totalPayable'] ?? 0).toDouble();
          final commissionAmount =
              (subTotal * commissionPercent) / 100;
          final vendorEarning = totalPayable - commissionAmount;

          return {
            "orderId": order['_id'],
            "date": DateTime.parse(order['createdAt']),
            "dateTime":
                DateFormat('dd MMM yyyy, hh:mm a').format(
                    DateTime.parse(order['createdAt'])),
            "customer":
                "${order['userId']?['firstName'] ?? ''} ${order['userId']?['lastName'] ?? ''}",
            "phone": order['userId']?['phoneNumber'] ?? "N/A",
            "restaurant":
                order['restaurantId']?['restaurantName'] ?? "N/A",
            "subTotal": subTotal,
            "delivery": (order['deliveryCharge'] ?? 0).toDouble(),
            "discount": (order['couponDiscount'] ?? 0).toDouble(),
            "total": totalPayable,
            "commissionPercent": commissionPercent,
            "commissionAmount":
                double.parse(commissionAmount.toStringAsFixed(2)),
            "vendorEarning":
                double.parse(vendorEarning.toStringAsFixed(2)),
          };
        }).toList();

        applyFilters();
      }
    } catch (e) {
      error = e.toString();
    }

    setState(() => loading = false);
  }

  /* ================= FILTERS ================= */

  void applyFilters() {
    filteredOrders = orders.where((o) {
      final matchesSearch = search.isEmpty ||
          o['orderId'].toLowerCase().contains(search.toLowerCase()) ||
          o['customer'].toLowerCase().contains(search.toLowerCase()) ||
          o['phone'].contains(search) ||
          o['restaurant']
              .toLowerCase()
              .contains(search.toLowerCase());

      final matchesDate = (startDate == null || endDate == null)
          ? true
          : o['date'].isAfter(startDate!) &&
              o['date']
                  .isBefore(endDate!.add(const Duration(days: 1)));

      return matchesSearch && matchesDate;
    }).toList();

    calculateSummary();
    setState(() {});
  }

  void calculateSummary() {
    final totalOrders = filteredOrders.length;

    final totalSales = filteredOrders.fold<double>(
        0, (s, o) => s + o['total']);

    final totalCommission = filteredOrders.fold<double>(
        0, (s, o) => s + o['commissionAmount']);

    final totalVendor = filteredOrders.fold<double>(
        0, (s, o) => s + o['vendorEarning']);

    summary = {
      "totalOrders": totalOrders,
      "totalSales": totalSales,
      "totalCommission": totalCommission,
      "totalVendorEarning": totalVendor,
      "avgCommission": totalSales > 0
          ? double.parse(
              ((totalCommission / totalSales) * 100).toStringAsFixed(2))
          : 0.0,
    };
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commission Report")),
      backgroundColor: Colors.grey.shade100,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _summaryCards(),
                    const SizedBox(height: 16),
                    _filters(),
                    const SizedBox(height: 16),
                    _ordersList(),
                  ],
                ),
    );
  }

  Widget _summaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      children: [
        _card("Orders", summary['totalOrders'].toString(),
            Colors.blue),
        _card("Total Sales",
            "₹${summary['totalSales'].toStringAsFixed(2)}",
            Colors.green),
        _card("Commission",
            "₹${summary['totalCommission'].toStringAsFixed(2)}",
            Colors.red),
        _card("Vendor Earning",
            "₹${summary['totalVendorEarning'].toStringAsFixed(2)}",
            Colors.purple),
        _card("Avg %", "${summary['avgCommission']}%",
            Colors.orange),
      ],
    );
  }

  Widget _card(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey)),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _filters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search orders...",
              ),
              onChanged: (v) {
                search = v;
                applyFilters();
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: const Text("Last 7 Days"),
                    onPressed: () {
                      endDate = DateTime.now();
                      startDate =
                          DateTime.now().subtract(const Duration(days: 6));
                      applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    child: const Text("This Month"),
                    onPressed: () {
                      final now = DateTime.now();
                      startDate = DateTime(now.year, now.month, 1);
                      endDate = DateTime(now.year, now.month + 1, 0);
                      applyFilters();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _ordersList() {
    if (filteredOrders.isEmpty) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(24),
        child: Text("No delivered orders found"),
      ));
    }

    return Column(
      children: filteredOrders.map(_orderCard).toList(),
    );
  }

  Widget _orderCard(Map o) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text("₹${o['total'].toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            "${o['customer']} • ${o['dateTime']}\nCommission: ₹${o['commissionAmount']}"),
        trailing: IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () => _showCalculation(o),
        ),
      ),
    );
  }

  /* ================= MODAL ================= */

  void _showCalculation(Map o) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            Text("Commission Calculation",
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            _row("Subtotal", o['subTotal']),
            _row("Commission %",
                "${o['commissionPercent']}%"),
            _row("Commission Amount", o['commissionAmount']),
            _row("Total Payable", o['total']),
            _row("Vendor Earning", o['vendorEarning'],
                highlight: true),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"))
          ],
        ),
      ),
    );
  }

  Widget _row(String label, dynamic value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value is String ? value : "₹${value.toString()}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: highlight ? Colors.green : null),
          )
        ],
      ),
    );
  }
}
