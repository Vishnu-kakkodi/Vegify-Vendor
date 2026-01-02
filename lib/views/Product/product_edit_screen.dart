// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vegiffyy_vendor/models/Product/product_model.dart';
// import 'package:vegiffyy_vendor/services/Product/product_service.dart';

// class ProductEditScreen extends StatefulWidget {
//   final ProductModel product;
//   const ProductEditScreen({super.key, required this.product});

//   @override
//   State<ProductEditScreen> createState() => _ProductEditScreenState();
// }

// class _ProductEditScreenState extends State<ProductEditScreen> {
//   late Map<String, dynamic> r;

//   @override
//   void initState() {
//     super.initState();
//     r = Map<String, dynamic>.from(widget.product.recommendedItem);
//   }

//   Future<void> submit() async {
//     await ProductService.updateProduct(
//       productId: widget.product.productId,
//       recommendedId: r['_id'],
//       recommendedData: r,
//       type: widget.product.type,
//     );
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Product")),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           TextField(
//             controller: TextEditingController(text: r['name']),
//             onChanged: (v) => r['name'] = v,
//             decoration: const InputDecoration(labelText: "Name"),
//           ),
//           TextField(
//             controller: TextEditingController(text: r['price'].toString()),
//             onChanged: (v) => r['price'] = double.parse(v),
//             decoration: const InputDecoration(labelText: "Price"),
//           ),
//           SwitchListTile(
//             title: const Text("Active"),
//             value: r['status'] == "active",
//             onChanged: (v) =>
//                 setState(() => r['status'] = v ? "active" : "inactive"),
//           ),
//           ElevatedButton(
//             onPressed: submit,
//             child: const Text("Update"),
//           ),
//         ],
//       ),
//     );
//   }
// }



















import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vegiffyy_vendor/models/Product/product_model.dart';
import 'package:vegiffyy_vendor/services/Product/product_service.dart';

class ProductEditScreen extends StatefulWidget {
  final ProductModel product;
  const ProductEditScreen({super.key, required this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late Map<String, dynamic> r;

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController halfPriceCtrl;
  late TextEditingController fullPriceCtrl;
  late TextEditingController discountCtrl;
  late TextEditingController descCtrl;
  late TextEditingController prepCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController tagsCtrl;

  File? newImage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    r = Map<String, dynamic>.from(widget.product.recommendedItem);

    nameCtrl = TextEditingController(text: r['name'] ?? "");
    priceCtrl = TextEditingController(text: r['price']?.toString() ?? "");
    halfPriceCtrl =
        TextEditingController(text: r['halfPlatePrice']?.toString() ?? "");
    fullPriceCtrl =
        TextEditingController(text: r['fullPlatePrice']?.toString() ?? "");
    discountCtrl =
        TextEditingController(text: r['discount']?.toString() ?? "0");
    descCtrl = TextEditingController(text: r['content'] ?? "");
    prepCtrl =
        TextEditingController(text: r['preparationTime']?.toString() ?? "");

    typeCtrl = TextEditingController(
      text: widget.product.type?.join(", ") ?? "",
    );

    tagsCtrl = TextEditingController(
      text: (r['tags'] is List) ? r['tags'].join(", ") : "",
    );
  }

  Future<void> pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => newImage = File(img.path));
    }
  }

  Future<void> submit() async {
    setState(() => loading = true);

    final updated = {
      "name": nameCtrl.text.trim(),
      "price": double.tryParse(priceCtrl.text) ?? 0,
      "halfPlatePrice": double.tryParse(halfPriceCtrl.text) ?? 0,
      "fullPlatePrice": double.tryParse(fullPriceCtrl.text) ?? 0,
      "discount": double.tryParse(discountCtrl.text) ?? 0,
      "content": descCtrl.text.trim(),
      "preparationTime": prepCtrl.text.trim(),
      "status": r['status'] ?? "inactive",
      "tags": tagsCtrl.text
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    };

    await ProductService.updateProduct(
      productId: widget.product.productId,
      recommendedId: r['_id'],
      recommendedData: updated,
      type: typeCtrl.text
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      image: newImage,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// IDS
          Text(
            "Product ID: ${widget.product.productId}\nRecommended ID: ${r['_id']}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          /// BASIC INFO
          _section("Basic Information"),
          _field("Product Name *", nameCtrl),
          _field("Price (₹) *", priceCtrl, number: true),
          _field("Half Plate Price (₹)", halfPriceCtrl, number: true),
          _field("Full Plate Price (₹)", fullPriceCtrl, number: true),
          _field("Discount (%)", discountCtrl, number: true),
          _field("Description", descCtrl, maxLines: 3),
          _field("Preparation Time (minutes)", prepCtrl, number: true),

          const SizedBox(height: 20),

          /// PRODUCT DETAILS
          _section("Product Details"),

          /// STATUS
          SwitchListTile(
            title: const Text("Product Status"),
            subtitle: Text(
              r['status'] == "active" ? "Active" : "Inactive",
            ),
            value: r['status'] == "active",
            onChanged: (v) =>
                setState(() => r['status'] = v ? "active" : "inactive"),
          ),

          _field("Product Types * (Veg, Non-Veg)", typeCtrl),
          _field("Tags", tagsCtrl),

          const SizedBox(height: 20),

          /// IMAGE
          _section("Product Image"),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: newImage != null
                    ? Image.file(newImage!,
                        width: 80, height: 80, fit: BoxFit.cover)
                    : Image.network(
                        r['image'] ?? "",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Update Image"),
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// SUBMIT
          ElevatedButton(
            onPressed: loading ? null : submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Update Product"),
          ),
        ],
      ),
    );
  }

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          t,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget _field(
    String label,
    TextEditingController c, {
    bool number = false,
    int maxLines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          keyboardType:
              number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
}
