
// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:vegiffyy_vendor/helper/pdf_form.dart';

// /// ===============================
// /// MAIN ENTRY SCREEN
// /// ===============================
// class VendorRegisterFlow extends StatefulWidget {
//   const VendorRegisterFlow({super.key});

//   @override
//   State<VendorRegisterFlow> createState() => _VendorRegisterFlowState();
// }

// class _VendorRegisterFlowState extends State<VendorRegisterFlow> {
//   int step = 0;

//   final form = <String, dynamic>{
//     "restaurantName": "",
//     "description": "",
//     "locationName": "",
//     "email": "",
//     "mobile": "",
//     "gstNumber": "",
//     "referralCode": "",
//     "password": "",
//     "lat": "",
//     "lng": "",
//     "commission": "",
//     "discount": "",
//   };

//   final files = <String, File?>{
//     "image": null,
//     "gstCertificate": null,
//     "fssaiLicense": null,
//     "panCard": null,
//     "aadharCardFront": null,
//     "aadharCardBack": null,
//   };

//   bool loading = false;
//   double progress = 0;

//   void next() => setState(() => step++);
//   void back() => setState(() => step--);

//   @override
//   Widget build(BuildContext context) {
//     Widget screen;

//     switch (step) {
//       case 0:
//         screen = _BasicDetails(form: form, onNext: next);
//         break;
//       case 1:
//         screen = _LocationScreen(form: form, onNext: next, onBack: back);
//         break;
//       case 2:
//         screen = _UploadDocuments(files: files, onNext: next, onBack: back);
//         break;
//       case 3:
//         screen = _DownloadForms(onNext: next, onBack: back);
//         break;
//       default:
//         screen = _ReviewAndSubmit(
//           form: form,
//           files: files,
//           loading: loading,
//           progress: progress,
//           onBack: back,
//           onSubmit: submit,
//         );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Register Restaurant")),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: screen,
//       ),
//     );
//   }

//   /// ===============================
//   /// FINAL SUBMIT API
//   /// ===============================
//   Future<void> submit() async {
//     setState(() {
//       loading = true;
//       progress = 0;
//     });

//     try {
//       final uri = Uri.parse("https://api.vegiffyy.com/api/restaurant");
//       final req = http.MultipartRequest("POST", uri);

//       form.forEach((k, v) {
//         if (v.toString().isNotEmpty) {
//           req.fields[k] = v.toString();
//         }
//       });

//       for (final entry in files.entries) {
//         if (entry.value != null) {
//           req.files.add(
//             await http.MultipartFile.fromPath(entry.key, entry.value!.path),
//           );
//         }
//       }

//       final streamed = await req.send();
//       final response = await http.Response.fromStream(streamed);

//       setState(() => loading = false);

//       final data = jsonDecode(response.body);

//       if (data["success"] == true && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("🎉 Restaurant Registered")),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data["message"] ?? "Failed")),
//         );
//       }
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Something went wrong")),
//       );
//     }
//   }
// }

// /// ===============================
// /// STEP 1 – BASIC DETAILS
// /// ===============================
// class _BasicDetails extends StatelessWidget {
//   final Map<String, dynamic> form;
//   final VoidCallback onNext;

//   const _BasicDetails({required this.form, required this.onNext});

//   InputDecoration deco(String label) =>
//       InputDecoration(labelText: label, border: const OutlineInputBorder());

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: ListView(
//         children: [
//           TextField(decoration: deco("Restaurant Name"), onChanged: (v) => form["restaurantName"] = v),
//           const SizedBox(height: 12),
//           TextField(decoration: deco("Location Name"), onChanged: (v) => form["locationName"] = v),
//           const SizedBox(height: 12),
//           TextField(decoration: deco("Email"), onChanged: (v) => form["email"] = v),
//           const SizedBox(height: 12),
//           TextField(decoration: deco("Mobile"), keyboardType: TextInputType.phone, onChanged: (v) => form["mobile"] = v),
//           const SizedBox(height: 12),
//           TextField(decoration: deco("Password"), obscureText: true, onChanged: (v) => form["password"] = v),
//           const SizedBox(height: 12),
//           TextField(decoration: deco("Commission %"), keyboardType: TextInputType.number, onChanged: (v) => form["commission"] = v),
//           const SizedBox(height: 12),
//           TextField(decoration: deco("Discount %"), keyboardType: TextInputType.number, onChanged: (v) => form["discount"] = v),
//           const SizedBox(height: 24),
//           ElevatedButton(onPressed: onNext, child: const Text("Next"))
//         ],
//       ),
//     );
//   }
// }

// /// ===============================
// /// STEP 2 – LOCATION (AUTO FILL)
// /// ===============================
// class _LocationScreen extends StatefulWidget {
//   final Map<String, dynamic> form;
//   final VoidCallback onNext;
//   final VoidCallback onBack;

//   const _LocationScreen({
//     required this.form,
//     required this.onNext,
//     required this.onBack,
//   });

//   @override
//   State<_LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<_LocationScreen> {
//   late TextEditingController latController;
//   late TextEditingController lngController;
//   bool fetching = false;

//   @override
//   void initState() {
//     super.initState();
//     latController = TextEditingController(text: widget.form["lat"]);
//     lngController = TextEditingController(text: widget.form["lng"]);
//   }

//   Future<void> getLocation() async {
//     setState(() => fetching = true);

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location permission denied")),
//       );
//       setState(() => fetching = false);
//       return;
//     }

//     final pos = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     latController.text = pos.latitude.toString();
//     lngController.text = pos.longitude.toString();

//     widget.form["lat"] = latController.text;
//     widget.form["lng"] = lngController.text;

//     setState(() => fetching = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           ElevatedButton.icon(
//             onPressed: fetching ? null : getLocation,
//             icon: const Icon(Icons.my_location),
//             label: Text(fetching ? "Fetching..." : "Get Current Location"),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: latController,
//             decoration: const InputDecoration(labelText: "Latitude", border: OutlineInputBorder()),
//             onChanged: (v) => widget.form["lat"] = v,
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: lngController,
//             decoration: const InputDecoration(labelText: "Longitude", border: OutlineInputBorder()),
//             onChanged: (v) => widget.form["lng"] = v,
//           ),
//           const Spacer(),
//           Row(
//             children: [
//               Expanded(child: OutlinedButton(onPressed: widget.onBack, child: const Text("Back"))),
//               const SizedBox(width: 12),
//               Expanded(child: ElevatedButton(onPressed: widget.onNext, child: const Text("Next"))),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// /// ===============================
// /// STEP 3 – DOCUMENT UPLOAD
// /// ===============================
// class _UploadDocuments extends StatefulWidget {
//   final Map<String, File?> files;
//   final VoidCallback onNext;
//   final VoidCallback onBack;

//   const _UploadDocuments({required this.files, required this.onNext, required this.onBack});

//   @override
//   State<_UploadDocuments> createState() => _UploadDocumentsState();
// }

// class _UploadDocumentsState extends State<_UploadDocuments> {
//   Future<void> pick(String key) async {
//     final res = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
//     );

//     if (res != null && res.files.single.path != null) {
//       setState(() {
//         widget.files[key] = File(res.files.single.path!);
//       });
//     }
//   }

//   Widget tile(String label, String key, bool required) {
//     final file = widget.files[key];
//     return Card(
//       child: ListTile(
//         title: Text(label + (required ? " *" : "")),
//         subtitle: Text(file != null ? file.path.split('/').last : "Not uploaded"),
//         trailing: IconButton(
//           icon: const Icon(Icons.upload),
//           onPressed: () => pick(key),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         tile("Restaurant Image", "image", true),
//         tile("GST Certificate", "gstCertificate", false),
//         tile("FSSAI License", "fssaiLicense", true),
//         tile("PAN Card", "panCard", true),
//         tile("Aadhar Front", "aadharCardFront", true),
//         tile("Aadhar Back", "aadharCardBack", false),
//         const SizedBox(height: 24),
//         Row(
//           children: [
//             Expanded(child: OutlinedButton(onPressed: widget.onBack, child: const Text("Back"))),
//             const SizedBox(width: 12),
//             Expanded(child: ElevatedButton(onPressed: widget.onNext, child: const Text("Next"))),
//           ],
//         ),
//       ],
//     );
//   }
// }

// /// ===============================
// /// STEP 4 – DOWNLOAD FORMS
// /// ===============================
// class _DownloadForms extends StatelessWidget {
//   final VoidCallback onNext;
//   final VoidCallback onBack;

//   const _DownloadForms({required this.onNext, required this.onBack});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
// ElevatedButton.icon(
//   onPressed: () {
//     downloadAndOpenPdf(
//       assetPath: 'assets/pdfs/declaration.pdf',
//       fileName: 'Vegiffyy_Declaration.pdf',
//     );
//   },
//   icon: const Icon(Icons.download),
//   label: const Text("Download Declaration"),
// ),
//           const SizedBox(height: 12),
// ElevatedButton.icon(
//   onPressed: () {
//     downloadAndOpenPdf(
//       assetPath: 'assets/pdfs/vendor_agreement.pdf',
//       fileName: 'Vegiffyy_Vendor_Agreement.pdf',
//     );
//   },
//   icon: const Icon(Icons.description),
//   label: const Text("Download Vendor Agreement"),
// ),
//           const Spacer(),
//           Row(
//             children: [
//               Expanded(child: OutlinedButton(onPressed: onBack, child: const Text("Back"))),
//               const SizedBox(width: 12),
//               Expanded(child: ElevatedButton(onPressed: onNext, child: const Text("Next"))),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// /// ===============================
// /// STEP 5 – REVIEW & SUBMIT
// /// ===============================
// class _ReviewAndSubmit extends StatelessWidget {
//   final Map<String, dynamic> form;
//   final Map<String, File?> files;
//   final bool loading;
//   final double progress;
//   final VoidCallback onBack;
//   final VoidCallback onSubmit;

//   const _ReviewAndSubmit({
//     required this.form,
//     required this.files,
//     required this.loading,
//     required this.progress,
//     required this.onBack,
//     required this.onSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: form.entries
//                   .map((e) => ListTile(title: Text(e.key), subtitle: Text(e.value.toString())))
//                   .toList(),
//             ),
//           ),
//           if (loading) const LinearProgressIndicator(),
//           Row(
//             children: [
//               Expanded(child: OutlinedButton(onPressed: onBack, child: const Text("Back"))),
//               const SizedBox(width: 12),
//               Expanded(child: ElevatedButton(onPressed: onSubmit, child: const Text("Register"))),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }




























import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegiffyy_vendor/views/auth/basic_details_screen.dart';
import 'package:vegiffyy_vendor/views/auth/download_forms_screen.dart';
import 'package:vegiffyy_vendor/views/auth/location_screen.dart';
import 'package:vegiffyy_vendor/views/auth/review_submit_screen.dart';
import 'package:vegiffyy_vendor/views/auth/upload_documents_screen.dart';


class VendorRegisterFlow extends StatefulWidget {
  const VendorRegisterFlow({super.key});

  @override
  State<VendorRegisterFlow> createState() => _VendorRegisterFlowState();
}

class _VendorRegisterFlowState extends State<VendorRegisterFlow> {
  int _currentStep = 0;
  
  final Map<String, dynamic> formData = {
    "restaurantName": "",
    "description": "",
    "locationName": "",
    "email": "",
    "mobile": "",
    "gstNumber": "",
    "referralCode": "",
    "password": "",
    "confirmPassword": "",
    "lat": "",
    "lng": "",
    "commission": "",
    "discount": "",
  };

  final Map<String, File?> files = {
    "image": null,
    "gstCertificate": null,
    "fssaiLicense": null,
    "panCard": null,
    "aadharCardFront": null,
    "aadharCardBack": null,
  };

  final List<String> _stepTitles = [
    'Basic Details',
    'Location',
    'Documents',
    'Forms',
    'Review'
  ];

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentStep > 0) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Discard Registration?'),
          content: const Text(
            'Are you sure you want to go back? All your progress will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('DISCARD'),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    
    // First step - show exit confirmation
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Exit Registration?'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('EXIT'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register Restaurant',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Step ${_currentStep + 1} of 5 - ${_stepTitles[_currentStep]}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 5,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return BasicDetailsScreen(
          key: const ValueKey(0),
          formData: formData,
          onNext: _nextStep,
        );
      case 1:
        return LocationScreen(
          key: const ValueKey(1),
          formData: formData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 2:
        return UploadDocumentsScreen(
          key: const ValueKey(2),
          files: files,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 3:
        return DownloadFormsScreen(
          key: const ValueKey(3),
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 4:
        return ReviewSubmitScreen(
          key: const ValueKey(4),
          formData: formData,
          files: files,
          onBack: _previousStep,
        );
      default:
        return const SizedBox();
    }
  }
}