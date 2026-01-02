// import 'package:flutter/material.dart';
// import 'package:vegiffyy_vendor/models/Product/product_model.dart';
// import 'package:vegiffyy_vendor/views/Product/product_edit_screen.dart';


// class ProductViewScreen extends StatelessWidget {
//   final ProductModel product;
//   const ProductViewScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final r = product.recommendedItem;

//     return Scaffold(
//       appBar: AppBar(title: Text(r['name'])),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Image.network(r['image']),
//           Text("₹${r['price']}", style: const TextStyle(fontSize: 22)),
//           Text("Discount: ${r['discount']}%"),
//           Text("Prep Time: ${r['preparationTime']} mins"),
//           Wrap(
//             children: (r['tags'] ?? [])
//                 .map<Widget>((t) => Chip(label: Text(t)))
//                 .toList(),
//           ),
//           ElevatedButton(
//             child: const Text("Edit"),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ProductEditScreen(product: product),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
















import 'package:flutter/material.dart';
import 'package:vegiffyy_vendor/models/Product/product_model.dart';
import 'package:vegiffyy_vendor/views/Product/product_edit_screen.dart';

class ProductViewScreen extends StatelessWidget {
  final ProductModel product;
  const ProductViewScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final r = product.recommendedItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(r['name'] ?? "Product Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductEditScreen(product: product),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              r['image'] ?? "",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 60),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  r['name'] ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _statusChip(r['status']),
            ],
          ),

          const SizedBox(height: 12),

          /// PRICE SECTION
          _section("Pricing"),
          _kv("Price", "₹${r['price'] ?? 0}"),
          _kv("Half Plate", "₹${r['halfPlatePrice'] ?? 0}"),
          _kv("Full Plate", "₹${r['fullPlatePrice'] ?? 0}"),
          if ((r['discount'] ?? 0) > 0)
            _kv("Discount", "${r['discount']}%"),

          const SizedBox(height: 16),

          /// DETAILS
          _section("Product Details"),
          _kv("Preparation Time",
              "${r['preparationTime'] ?? 0} mins"),
          _kv(
            "Category",
            r['category'] is Map
                ? r['category']['categoryName'] ?? "-"
                : "-",
          ),
          _kv(
            "Product Types",
            (product.type ?? []).join(", "),
          ),
          _kv(
            "Status",
            r['status'] ?? "inactive",
          ),

          const SizedBox(height: 16),

          /// TAGS
          _section("Tags"),
          (r['tags'] != null && r['tags'].isNotEmpty)
              ? Wrap(
                  spacing: 8,
                  children: r['tags']
                      .map<Widget>(
                        (t) => Chip(label: Text(t)),
                      )
                      .toList(),
                )
              : const Text(
                  "No tags added",
                  style: TextStyle(color: Colors.grey),
                ),

          const SizedBox(height: 16),

          /// DESCRIPTION
          _section("Description"),
          Text(
            r['content'] ?? "No description available",
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 24),

          /// IDS
          _section("Reference IDs"),
          _kv("Product ID", product.productId),
          _kv("Recommended ID", r['_id']),

          const SizedBox(height: 30),

          /// EDIT BUTTON
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text("Edit Product"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductEditScreen(product: product),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== UI HELPERS =====

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(color: Colors.grey)),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget _statusChip(String? status) {
    final active = status == "active";
    return Chip(
      backgroundColor:
          active ? Colors.green.shade100 : Colors.red.shade100,
      label: Text(
        active ? "Active" : "Inactive",
        style: TextStyle(
          color: active ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
