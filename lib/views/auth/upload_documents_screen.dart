import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentsScreen extends StatefulWidget {
  final Map<String, File?> files;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const UploadDocumentsScreen({
    super.key,
    required this.files,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  final List<DocumentItem> _documents = [
    DocumentItem(
      key: 'image',
      title: 'Restaurant Image',
      description: 'A clear photo of your restaurant',
      icon: Icons.restaurant_menu,
      required: true,
    ),
    DocumentItem(
      key: 'fssaiLicense',
      title: 'FSSAI License',
      description: 'Food Safety & Standards License',
      icon: Icons.shield,
      required: true,
    ),
    DocumentItem(
      key: 'panCard',
      title: 'PAN Card',
      description: 'Permanent Account Number',
      icon: Icons.credit_card,
      required: true,
    ),
    DocumentItem(
      key: 'aadharCardFront',
      title: 'Aadhar Card (Front)',
      description: 'Front side of Aadhar card',
      icon: Icons.badge,
      required: true,
    ),
    DocumentItem(
      key: 'aadharCardBack',
      title: 'Aadhar Card (Back)',
      description: 'Back side of Aadhar card',
      icon: Icons.badge_outlined,
      required: false,
    ),
    DocumentItem(
      key: 'gstCertificate',
      title: 'GST Certificate',
      description: 'Goods & Services Tax Certificate',
      icon: Icons.article,
      required: false,
    ),
  ];

  bool _isUploading = false;

  Future<void> _pickFile(String key) async {
    try {
      setState(() => _isUploading = true);
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        
        // Check file size (max 10MB)
        if (fileSize > 10 * 1024 * 1024) {
          _showError('File size must be less than 10MB');
          setState(() => _isUploading = false);
          return;
        }

        setState(() {
          widget.files[key] = file;
          _isUploading = false;
        });
        
        _showSuccess('Document uploaded successfully');
      } else {
        setState(() => _isUploading = false);
      }
    } catch (e) {
      setState(() => _isUploading = false);
      _showError('Failed to pick file: ${e.toString()}');
    }
  }

  void _removeFile(String key) {
    setState(() {
      widget.files[key] = null;
    });
    _showSuccess('Document removed');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validateDocuments() {
    for (final doc in _documents) {
      if (doc.required && widget.files[doc.key] == null) {
        return false;
      }
    }
    return true;
  }

  void _handleNext() {
    if (_validateDocuments()) {
      widget.onNext();
    } else {
      _showError('Please upload all required documents');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadedCount = _documents
        .where((doc) => widget.files[doc.key] != null)
        .length;
    final requiredCount = _documents
        .where((doc) => doc.required)
        .length;
    final requiredUploaded = _documents
        .where((doc) => doc.required && widget.files[doc.key] != null)
        .length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Upload Documents',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please upload clear photos or PDFs of the following documents',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              
              // Progress card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upload Progress',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '$uploadedCount/${_documents.length} uploaded',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: uploadedCount / _documents.length,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$requiredUploaded/$requiredCount required documents uploaded',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Document list
              ..._documents.map((doc) => _buildDocumentCard(doc)),
              
              const SizedBox(height: 16),
              
              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Document Guidelines',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoPoint('All documents must be clear and readable'),
                    _buildInfoPoint('Accepted formats: JPG, PNG, PDF'),
                    _buildInfoPoint('Maximum file size: 10MB per document'),
                    _buildInfoPoint('Documents will be verified within 24-48 hours'),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Bottom buttons
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _validateDocuments() ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Continue to Forms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(DocumentItem doc) {
    final file = widget.files[doc.key];
    final isUploaded = file != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? Colors.green[300]! : Colors.grey[300]!,
          width: isUploaded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isUploaded 
              ? Colors.green[50] 
              : Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isUploaded ? Icons.check_circle : doc.icon,
            color: isUploaded ? Colors.green : Theme.of(context).primaryColor,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                doc.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (doc.required)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Required',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              doc.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (isUploaded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 14, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        file.path.split('/').last,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        trailing: isUploaded
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => _removeFile(doc.key),
                tooltip: 'Remove',
              )
            : ElevatedButton.icon(
                onPressed: _isUploading ? null : () => _pickFile(doc.key),
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Upload'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentItem {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final bool required;

  DocumentItem({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.required,
  });
}