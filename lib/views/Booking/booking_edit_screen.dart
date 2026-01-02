

import 'package:flutter/material.dart';
import 'package:vegiffyy_vendor/helper/vendor_storage_helper.dart';
import 'package:vegiffyy_vendor/models/Booking/booking_model.dart';
import 'package:vegiffyy_vendor/services/Booking/booking_service.dart';

class BookingEditScreen extends StatefulWidget {
  final BookingModel booking;
  const BookingEditScreen({super.key, required this.booking});

  @override
  State<BookingEditScreen> createState() => _BookingEditScreenState();
}

class _BookingEditScreenState extends State<BookingEditScreen> {
  late String status;
  final prepController = TextEditingController();
    String? vendorId;


  /// ✅ SINGLE SOURCE OF TRUTH
  final List<String> allowedStatuses = const [
    "Pending",
    "Accepted",
    "Rejected",
  ];

  @override
  void initState() {
    super.initState();

      _loadVendor();


    /// ✅ SAFE NORMALIZATION
    status = allowedStatuses.contains(widget.booking.status)
        ? widget.booking.status
        : "Pending";

    if (widget.booking.preparationTime != null) {
      prepController.text = widget.booking.preparationTime.toString();
    }
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

}

  Future<void> submit() async {
    final vendor = vendorId.toString();

    final Map<String, dynamic> body = {
      "orderStatus": status,
    };

    if (status == "Accepted") {
      if (prepController.text.isEmpty) {
        _error("Enter preparation time");
        return;
      }
      body["preparationTime"] = prepController.text;
    }

    try {
      await BookingService.updateStatus(
        widget.booking.id,
        vendor,
        body,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Order updated successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _error("Failed to update order");
    }
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Order"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderInfo(),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(
                labelText: "Order Status",
                border: OutlineInputBorder(),
              ),
              items: allowedStatuses
                  .map(
                    (s) => DropdownMenuItem<String>(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => status = v!),
            ),

            if (status == "Accepted") ...[
              const SizedBox(height: 16),
              TextField(
                controller: prepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Preparation Time (minutes)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Update Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderInfo() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt),
        title: Text("₹${widget.booking.total}"),
        subtitle: Text("Customer: ${widget.booking.userName}"),
        trailing: Chip(
          label: Text(widget.booking.status),
        ),
      ),
    );
  }
}
