import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vegiffyy_vendor/models/Profile/vendor_model.dart';
import 'package:vegiffyy_vendor/providers/Profile/vendor_provider.dart';
import 'package:vegiffyy_vendor/services/Profile/vendor_service.dart';

class EditVendorProfileScreen extends StatefulWidget {
  final VendorModel vendor;

  const EditVendorProfileScreen({super.key, required this.vendor});

  @override
  State<EditVendorProfileScreen> createState() =>
      _EditVendorProfileScreenState();
}

class _EditVendorProfileScreenState extends State<EditVendorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = VendorService();

  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController gstCtrl;
  late TextEditingController ratingCtrl;

  String status = 'active';
  bool loading = false;

  XFile? restaurantImage;
  XFile? declarationDoc;
  XFile? agreementDoc;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.vendor.restaurantName);
    descCtrl = TextEditingController(text: widget.vendor.description);
    locationCtrl = TextEditingController(text: widget.vendor.locationName);
    gstCtrl = TextEditingController(text: widget.vendor.gstNumber ?? '');
    ratingCtrl =
        TextEditingController(text: widget.vendor.rating.toString());
    status = widget.vendor.status;
  }

  Future<void> _pickImage(bool isRestaurant) async {
    final img =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img != null) {
      setState(() {
        if (isRestaurant) {
          restaurantImage = img;
        }
      });
    }
  }

  Future<void> _pickDocument(bool isDeclaration) async {
    final doc =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (doc != null) {
      setState(() {
        if (isDeclaration) {
          declarationDoc = doc;
        } else {
          agreementDoc = doc;
        }
      });
    }
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => loading = true);

  //   try {
  //     /// UPDATE PROFILE DATA
  //     await _service.updateProfile(widget.vendor.id, {
  //       "restaurantName": nameCtrl.text.trim(),
  //       "description": descCtrl.text.trim(),
  //       "locationName": locationCtrl.text.trim(),
  //       "gstNumber": gstCtrl.text.trim(),
  //       "rating": ratingCtrl.text.trim(),
  //       "status": status,
  //     });

  //     /// UPLOAD IMAGE
  //     if (restaurantImage != null) {
  //       await _service.updateProfile(widget.vendor.id, {});
  //     }

  //     /// UPLOAD DOCUMENTS
  //     final docs = <String, String>{};
  //     if (declarationDoc != null) {
  //       docs['declarationForm'] = declarationDoc!.path;
  //     }
  //     if (agreementDoc != null) {
  //       docs['vendorAgreement'] = agreementDoc!.path;
  //     }

  //     if (docs.isNotEmpty) {
  //       await _service.uploadDocuments(widget.vendor.id, docs);
  //     }

  //     if (!mounted) return;
  //     await context.read<VendorProvider>().load(widget.vendor.id);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Profile updated successfully")),
  //     );

  //     Navigator.pop(context);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   } finally {
  //     setState(() => loading = false);
  //   }
  // }


  Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => loading = true);

  try {
    /// UPDATE PROFILE + IMAGE TOGETHER
    await _service.updateProfile(
      widget.vendor.id,
      {
        "restaurantName": nameCtrl.text.trim(),
        "description": descCtrl.text.trim(),
        "locationName": locationCtrl.text.trim(),
        "gstNumber": gstCtrl.text.trim(),
        "rating": ratingCtrl.text.trim(),
        "status": status,
      },
      restaurantImage != null ? File(restaurantImage!.path) : null,
    );

    /// UPLOAD DOCUMENTS
    final docs = <String, String>{};
    if (declarationDoc != null) {
      docs['declarationForm'] = declarationDoc!.path;
    }
    if (agreementDoc != null) {
      docs['vendorAgreement'] = agreementDoc!.path;
    }

    if (docs.isNotEmpty) {
      await _service.uploadDocuments(widget.vendor.id, docs);
    }

    if (!mounted) return;
    await context.read<VendorProvider>().load(widget.vendor.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Restaurant Profile"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// IMAGE
            Center(
              child: GestureDetector(
                onTap: () => _pickImage(true),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: restaurantImage != null
                          ? FileImage(File(restaurantImage!.path))
                          : (widget.vendor.imageUrl != null
                              ? NetworkImage(widget.vendor.imageUrl!)
                              : null) as ImageProvider?,
                      child: widget.vendor.imageUrl == null &&
                              restaurantImage == null
                          ? const Icon(Icons.store, size: 40)
                          : null,
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.camera_alt, size: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _field("Restaurant Name", nameCtrl),
            _field("Location Name", locationCtrl),
            _field("GST Number", gstCtrl, required: false),
            _field("Rating", ratingCtrl,
                keyboard: TextInputType.number),

            const SizedBox(height: 12),

            /// STATUS
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "active", child: Text("Active")),
                DropdownMenuItem(value: "pending", child: Text("Pending")),
                DropdownMenuItem(value: "inactive", child: Text("Inactive")),
              ],
              onChanged: (v) => setState(() => status = v!),
            ),

            const SizedBox(height: 16),

            /// DESCRIPTION
            TextFormField(
              controller: descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// DOCUMENT UPLOAD
            const Text(
              "Business Documents",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _docTile(
              "Declaration Form",
              declarationDoc,
              () => _pickDocument(true),
            ),
            _docTile(
              "Vendor Agreement",
              agreementDoc,
              () => _pickDocument(false),
            ),

            const SizedBox(height: 32),

            /// SUBMIT
            ElevatedButton(
              onPressed: loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {bool required = true,
      TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: (v) =>
            required && (v == null || v.isEmpty) ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _docTile(String title, XFile? file, VoidCallback onPick) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(title),
        subtitle: file != null ? Text(file.name) : const Text("Not uploaded"),
        trailing: IconButton(
          icon: const Icon(Icons.upload),
          onPressed: onPick,
        ),
      ),
    );
  }
}
