import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vegiffyy_vendor/helper/vendor_storage_helper.dart';

import 'vendor_joining_success_screen.dart';

class VendorJoiningFeeScreen extends StatefulWidget {
  const VendorJoiningFeeScreen({super.key});

  @override
  State<VendorJoiningFeeScreen> createState() =>
      _VendorJoiningFeeScreenState();
}

class _VendorJoiningFeeScreenState extends State<VendorJoiningFeeScreen> {
   String? vendorId;
  final String baseUrl = "https://api.vegiffyy.com/api";

  final int GST_RATE = 18;

  bool loading = false;
  bool plansLoading = true;
  String error = "";

  List<Map<String, dynamic>> plans = [];
  Map<String, dynamic>? selectedPlan;
  Map<String, dynamic>? vendor;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
              _loadVendor();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);


  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
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

         fetchVendor();
    fetchPlans();


}

  /* ===================== API ===================== */

  Future<void> fetchVendor() async {
    try {
      final res =
          await http.get(Uri.parse("$baseUrl/vendor/profile/$vendorId"));
      final body = jsonDecode(res.body);

      if (body['success'] == true) {
        vendor = body['data'];
      }
    } catch (_) {}
    setState(() {});
  }

  Future<void> fetchPlans() async {
    try {
      final res =
          await http.get(Uri.parse("$baseUrl/admin/vendorplans"));
      final body = jsonDecode(res.body);

      if (body['success'] == true) {
        plans = List<Map<String, dynamic>>.from(body['data']);
        if (plans.isNotEmpty) {
          selectedPlan = plans.first;
        }
      }
    } catch (_) {
      error = "Failed to load plans";
    }

    setState(() => plansLoading = false);
  }

  /* ===================== GST ===================== */

  Map<String, int> gstCalc(num price) {
    final base = price.round();
    final gst = ((base * GST_RATE) / 100).round();
    return {
      "base": base,
      "gst": gst,
      "total": base + gst,
    };
  }

  /* ===================== PAYMENT ===================== */

  void startPayment() {
    if (selectedPlan == null) return;

    final gst = gstCalc(selectedPlan!['price']);

    final options = {
      'key': 'rzp_test_BxtRNvflG06PTV',
      'amount': gst['total']! * 100,
      'name': 'Vegiffyy Vendor Program',
      'description': selectedPlan!['name'],
      'prefill': {
        'contact': vendor?['mobile'] ?? '',
        'email': vendor?['email'] ?? '',
        'name': vendor?['restaurantName'] ?? 'Vendor',
      },
      'theme': {'color': '#10B981'}
    };

    _razorpay.open(options);
  }

  void _onSuccess(PaymentSuccessResponse response) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/vendor/pay/$vendorId"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "planId": selectedPlan!['_id'],
          "transactionId": response.paymentId,
        }),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VendorJoiningSuccessScreen(
              plan: selectedPlan!,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => error = "Payment verification failed");
    }
  }

  void _onError(PaymentFailureResponse response) {
    setState(() => error = response.message ?? "Payment failed");
  }

  /* ===================== UI ===================== */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FDF9),
      appBar: AppBar(
        title: const Text("Activate Restaurant"),
        backgroundColor: Colors.green,
      ),
      body: plansLoading
          ? const Center(child: CircularProgressIndicator())
          : _body(),
    );
  }

  Widget _body() {
    if (plans.isEmpty) {
      return const Center(child: Text("No plans available"));
    }

    final gst = selectedPlan != null
        ? gstCalc(selectedPlan!['price'])
        : {"base": 0, "gst": 0, "total": 0};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _vendorCard(),
        const SizedBox(height: 16),

        /// PLANS
        ...plans.map(_planCard),

        const SizedBox(height: 16),

        /// PAYMENT SUMMARY
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _row("Plan Price", "₹${gst['base']}"),
                _row("GST (18%)", "₹${gst['gst']}"),
                const Divider(),
                _row(
                  "Total",
                  "₹${gst['total']}",
                  bold: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// PAY BUTTON
        ElevatedButton(
          onPressed: loading ? null : startPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Pay & Activate",
            style: TextStyle(fontSize: 18),
          ),
        ),

        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          )
      ],
    );
  }

  Widget _vendorCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.store, color: Colors.green),
        title: Text(vendor?['restaurantName'] ?? "Your Restaurant"),
        subtitle: Text(vendor?['locationName'] ?? ""),
      ),
    );
  }

  Widget _planCard(Map<String, dynamic> plan) {
    final selected = selectedPlan?['_id'] == plan['_id'];

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = plan),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: selected ? Colors.green.shade50 : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan['name'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("₹${plan['price']} • ${plan['validity']} days"),
                    const SizedBox(height: 8),
                    ...List<String>.from(plan['benefits'] ?? [])
                        .take(3)
                        .map((b) => Row(
                              children: const [
                                Icon(Icons.check,
                                    size: 16, color: Colors.green),
                              ],
                            ))
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: Colors.green)
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String t, String v, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(t),
        Text(v,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
