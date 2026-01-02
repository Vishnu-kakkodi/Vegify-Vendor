// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vegiffyy_vendor/providers/auth_provider.dart';
// import 'package:vegiffyy_vendor/providers/theme_provider.dart';
// import 'package:vegiffyy_vendor/utils/responsive.dart';
// import 'package:vegiffyy_vendor/views/auth/forgot_password_sheet.dart';
// import 'package:vegiffyy_vendor/views/auth/vendor_register_flow.dart';
// import 'otp_screen.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final theme = Theme.of(context);
//     final isDesktop = Responsive.isDesktop(context);
//     final isTablet = Responsive.isTablet(context);
//     final isWide = isDesktop || isTablet;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (auth.currentStep == AuthStep.otp &&
//           ModalRoute.of(context)?.isCurrent == true) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const OtpScreen()),
//         );
//       }
//     });

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     theme.colorScheme.primary,
//                     theme.colorScheme.primary.withOpacity(0.7),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 Icons.restaurant_menu,
//                 color: theme.colorScheme.onPrimary,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               'Vegiffyy Vendor',
//               style: theme.textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: -0.5,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               icon: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 transitionBuilder: (child, animation) => RotationTransition(
//                   turns: animation,
//                   child: child,
//                 ),
//                 child: Icon(
//                   theme.brightness == Brightness.dark
//                       ? Icons.light_mode_rounded
//                       : Icons.dark_mode_rounded,
//                   key: ValueKey(theme.brightness),
//                 ),
//               ),
//               onPressed: () {
//                 context.read<ThemeProvider>().toggleTheme();
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 700),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(32),
//                 side: BorderSide(
//                   color: theme.colorScheme.outlineVariant.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(32),
//                 child: isWide
//                     ? Row(
//                         children: [
//                           Expanded(flex: 5, child: _LoginForm(auth: auth)),
//                         ],
//                       )
//                     : Column(
//                         children: [
//                           Expanded(flex: 6, child: _LoginForm(auth: auth)),
//                         ],
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _LoginForm extends StatefulWidget {
//   final AuthProvider auth;

//   const _LoginForm({required this.auth});

//   @override
//   State<_LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<_LoginForm> {
//   bool _obscurePassword = true;
//   final _emailFocusNode = FocusNode();
//   final _passwordFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isLoading = widget.auth.status == AuthStatus.loading;

//     return Container(
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Progress Steps
//               _ProgressSteps(currentStep: 1),
//               const SizedBox(height: 36),

//               // Email Field
//               _AnimatedTextField(
//                 controller: widget.auth.emailController,
//                 focusNode: _emailFocusNode,
//                 label: 'Email Address',
//                 hint: 'vendor@example.com',
//                 icon: Icons.email_outlined,
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 20),

//               // Password Field
//               _AnimatedTextField(
//                 controller: widget.auth.passwordController,
//                 focusNode: _passwordFocusNode,
//                 label: 'Password',
//                 hint: 'Enter your password',
//                 icon: Icons.lock_outline_rounded,
//                 obscureText: _obscurePassword,
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscurePassword
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                   ),
//                   onPressed: () {
//                     setState(() => _obscurePassword = !_obscurePassword);
//                   },
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.info_outline_rounded,
//                     size: 14,
//                     color: theme.colorScheme.onSurfaceVariant,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     'Minimum 6 characters required',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: theme.colorScheme.onSurfaceVariant,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),

//               // Login Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: FilledButton(
//                   onPressed: isLoading ? null : () => widget.auth.login(),
//                   style: FilledButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: isLoading
//                       ? SizedBox(
//                           height: 24,
//                           width: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.5,
//                             color: theme.colorScheme.onPrimary,
//                           ),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               'Login to Dashboard',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Icon(
//                               Icons.arrow_forward_rounded,
//                               size: 20,
//                             ),
//                           ],
//                         ),
//                 ),
//               ),

//               // Error Message
//               if (widget.auth.status == AuthStatus.error &&
//                   widget.auth.errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.errorContainer,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: theme.colorScheme.error.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.error_outline_rounded,
//                           color: theme.colorScheme.error,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.auth.errorMessage!,
//                             style: TextStyle(
//                               color: theme.colorScheme.error,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 20),

//               // Forgot Password
//               Align(
//                 alignment: Alignment.center,
//                 child: TextButton(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent,
//                       builder: (_) => const ForgotPasswordSheet(),
//                     );
//                   },
//                   style: TextButton.styleFrom(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   ),
//                   child: Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Sign Up Link
//               Center(
//                 child: Wrap(
//                   alignment: WrapAlignment.center,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account? ",
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => VendorRegisterFlow()));
//                       },
//                       style: TextButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 4),
//                       ),
//                       child: Text(
//                         'Become a Partner',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AnimatedTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String label;
//   final String hint;
//   final IconData icon;
//   final bool obscureText;
//   final Widget? suffixIcon;
//   final TextInputType? keyboardType;

//   const _AnimatedTextField({
//     required this.controller,
//     required this.focusNode,
//     required this.label,
//     required this.hint,
//     required this.icon,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.keyboardType,
//   });

//   @override
//   State<_AnimatedTextField> createState() => _AnimatedTextFieldState();
// }

// class _AnimatedTextFieldState extends State<_AnimatedTextField> {
//   bool _isFocused = false;

//   @override
//   void initState() {
//     super.initState();
//     widget.focusNode.addListener(() {
//       setState(() => _isFocused = widget.focusNode.hasFocus);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: theme.textTheme.labelLarge?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: _isFocused
//                 ? theme.colorScheme.primary
//                 : theme.colorScheme.onSurface,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _isFocused
//                 ? [
//                     BoxShadow(
//                       color: theme.colorScheme.primary.withOpacity(0.1),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             obscureText: widget.obscureText,
//             keyboardType: widget.keyboardType,
//             style: theme.textTheme.bodyLarge,
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               prefixIcon: Icon(
//                 widget.icon,
//                 color: _isFocused
//                     ? theme.colorScheme.primary
//                     : theme.colorScheme.onSurfaceVariant,
//               ),
//               suffixIcon: widget.suffixIcon,
//               filled: true,
//               fillColor: _isFocused
//                   ? theme.colorScheme.primaryContainer.withOpacity(0.1)
//                   : theme.colorScheme.surfaceVariant.withOpacity(0.3),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: theme.colorScheme.outlineVariant.withOpacity(0.2),
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: theme.colorScheme.primary,
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ProgressSteps extends StatelessWidget {
//   final int currentStep;

//   const _ProgressSteps({required this.currentStep});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Row(
//       children: [
//         _StepIndicator(
//           number: 1,
//           label: 'Login',
//           isActive: currentStep >= 1,
//           isCompleted: currentStep > 1,
//         ),
//         Expanded(
//           child: Container(
//             height: 2,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: currentStep > 1
//                   ? theme.colorScheme.primary
//                   : theme.colorScheme.outlineVariant.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ),
//         _StepIndicator(
//           number: 2,
//           label: 'Verify OTP',
//           isActive: currentStep >= 2,
//           isCompleted: currentStep > 2,
//         ),
//       ],
//     );
//   }
// }

// class _StepIndicator extends StatelessWidget {
//   final int number;
//   final String label;
//   final bool isActive;
//   final bool isCompleted;

//   const _StepIndicator({
//     required this.number,
//     required this.label,
//     required this.isActive,
//     required this.isCompleted,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Row(
//       children: [
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: isActive
//                 ? theme.colorScheme.primary
//                 : theme.colorScheme.surfaceVariant,
//             shape: BoxShape.circle,
//             boxShadow: isActive
//                 ? [
//                     BoxShadow(
//                       color: theme.colorScheme.primary.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Center(
//             child: isCompleted
//                 ? Icon(
//                     Icons.check_rounded,
//                     color: theme.colorScheme.onPrimary,
//                     size: 20,
//                   )
//                 : Text(
//                     number.toString(),
//                     style: TextStyle(
//                       color: isActive
//                           ? theme.colorScheme.onPrimary
//                           : theme.colorScheme.onSurfaceVariant,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                     ),
//                   ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: theme.textTheme.bodyMedium?.copyWith(
//             fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//             color: isActive
//                 ? theme.colorScheme.onSurface
//                 : theme.colorScheme.onSurfaceVariant,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FeatureBadge extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const _FeatureBadge({
//     required this.icon,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: theme.colorScheme.outlineVariant.withOpacity(0.3),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 16,
//             color: theme.colorScheme.primary,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: theme.textTheme.labelSmall?.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





















import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegiffyy_vendor/providers/auth_provider.dart';
import 'package:vegiffyy_vendor/providers/theme_provider.dart';
import 'package:vegiffyy_vendor/utils/responsive.dart';
import 'package:vegiffyy_vendor/views/auth/forgot_password_sheet.dart';
import 'package:vegiffyy_vendor/views/auth/vendor_register_flow.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.currentStep == AuthStep.otp &&
          ModalRoute.of(context)?.isCurrent == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 16,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 460,
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: IntrinsicHeight(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant.withOpacity(.2),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: _LoginForm(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 18,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Vegiffyy Vendor',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            theme.brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
        ),
      ],
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool _obscurePassword = true;
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isLoading = auth.status == AuthStatus.loading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER (compact)
        Text(
          'Welcome Back 👋',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Login to continue to your dashboard',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        /// STEPS
        const _ProgressSteps(currentStep: 1),

        const SizedBox(height: 20),

        /// EMAIL
        _AnimatedField(
          controller: auth.emailController,
          focusNode: _emailFocus,
          label: 'Email Address',
          hint: 'vendor@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 14),

        /// PASSWORD
        _AnimatedField(
          controller: auth.passwordController,
          focusNode: _passwordFocus,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Minimum 6 characters',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        /// LOGIN BUTTON
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? null : auth.login,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
          ),
        ),

        /// ERROR
        if (auth.status == AuthStatus.error &&
            auth.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              auth.errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        const SizedBox(height: 12),

        /// FORGOT
        Center(
          child: TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ForgotPasswordSheet(),
              );
            },
            child: const Text('Forgot Password?'),
          ),
        ),

        const SizedBox(height: 8),

        /// REGISTER
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text("Don't have an account? "),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VendorRegisterFlow(),
                    ),
                  );
                },
                child: const Text(
                  'Become a Partner',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _AnimatedField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(.35),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressSteps extends StatelessWidget {
  final int currentStep;
  const _ProgressSteps({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _StepCircle('1', 'Login', true),
        Expanded(
          child: Container(
            height: 2,
            color: theme.colorScheme.primary,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        _StepCircle('2', 'OTP', false),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String number;
  final String label;
  final bool active;

  const _StepCircle(this.number, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor:
              active ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
          child: Text(
            number,
            style: TextStyle(
              color: active
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
