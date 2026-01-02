import 'package:flutter/material.dart';

class BasicDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;

  const BasicDetailsScreen({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _commissionController = TextEditingController();
  final _discountController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    _restaurantNameController.text = widget.formData['restaurantName'] ?? '';
    _descriptionController.text = widget.formData['description'] ?? '';
    _locationNameController.text = widget.formData['locationName'] ?? '';
    _emailController.text = widget.formData['email'] ?? '';
    _mobileController.text = widget.formData['mobile'] ?? '';
    _gstNumberController.text = widget.formData['gstNumber'] ?? '';
    _referralCodeController.text = widget.formData['referralCode'] ?? '';
    _passwordController.text = widget.formData['password'] ?? '';
    _confirmPasswordController.text = widget.formData['confirmPassword'] ?? '';
    _commissionController.text = widget.formData['commission'] ?? '';
    _discountController.text = widget.formData['discount'] ?? '';
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _gstNumberController.dispose();
    _referralCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _commissionController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  String? _validateGST(String? value) {
    if (value == null || value.isEmpty) {
      return null; // GST is optional
    }
    // if (value.length != 15) {
    //   return 'GST number must be 15 characters';
    // }
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    // if (!gstRegex.hasMatch(value)) {
    //   return 'Enter a valid GST number';
    // }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      widget.formData['restaurantName'] = _restaurantNameController.text;
      widget.formData['description'] = _descriptionController.text;
      widget.formData['locationName'] = _locationNameController.text;
      widget.formData['email'] = _emailController.text;
      widget.formData['mobile'] = _mobileController.text;
      widget.formData['gstNumber'] = _gstNumberController.text;
      widget.formData['referralCode'] = _referralCodeController.text;
      widget.formData['password'] = _passwordController.text;
      widget.formData['confirmPassword'] = _confirmPasswordController.text;
      widget.formData['commission'] = _commissionController.text;
      widget.formData['discount'] = _discountController.text;

      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s start with your restaurant details',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          _buildTextField(
            controller: _restaurantNameController,
            label: 'Restaurant Name',
            icon: Icons.restaurant,
            validator: (v) => v?.isEmpty ?? true ? 'Restaurant name is required' : null,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            icon: Icons.description,
            maxLines: 3,
            validator: (v) => v?.isEmpty ?? true ? 'Description is required' : null,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _locationNameController,
            label: 'Location Name',
            icon: Icons.location_on,
            validator: (v) => v?.isEmpty ?? true ? 'Location name is required' : null,
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _mobileController,
            label: 'Mobile Number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: _validateMobile,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _gstNumberController,
            label: 'GST Number (Optional)',
            icon: Icons.business,
            validator: _validateGST,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _referralCodeController,
            label: 'Referral Code (Optional)',
            icon: Icons.card_giftcard,
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          const Text(
            'Account Security',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock,
            obscureText: _obscurePassword,
            validator: _validatePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            validator: _validateConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          const Text(
            'Business Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _commissionController,
                  label: 'Commission %',
                  icon: Icons.percent,
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _discountController,
                  label: 'Discount %',
                  icon: Icons.local_offer,
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          ElevatedButton(
            onPressed: _handleNext,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Continue to Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
      ),
    );
  }
}