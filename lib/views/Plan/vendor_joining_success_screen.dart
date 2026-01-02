import 'package:flutter/material.dart';

class VendorJoiningSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> plan;

  const VendorJoiningSuccessScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FDF9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified,
                  size: 80, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                "Payment Successful 🎉",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "${plan['name']} Activated",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text("${plan['validity']} days validity"),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/dashboard", (_) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text("Go to Dashboard"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
