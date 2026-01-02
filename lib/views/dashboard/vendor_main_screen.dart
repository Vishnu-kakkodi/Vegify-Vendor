
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:vegiffyy_vendor/navigation/vendor_navigation_provider.dart';
import 'package:vegiffyy_vendor/navigation/vendor_section.dart';
import 'package:vegiffyy_vendor/views/About/about_us_screen.dart';
import 'package:vegiffyy_vendor/views/Account/account_management_screen.dart';
import 'package:vegiffyy_vendor/views/Booking/booking_list_screen.dart';
import 'package:vegiffyy_vendor/views/Booking/completed_booking.dart';
import 'package:vegiffyy_vendor/views/Booking/pending_booking.dart';
import 'package:vegiffyy_vendor/views/Category/add_category_screen.dart';
import 'package:vegiffyy_vendor/views/Category/category_list_screen.dart';
import 'package:vegiffyy_vendor/views/Commission/commission_report_screen.dart';
import 'package:vegiffyy_vendor/views/Notification/vendor_notifications_screen.dart';
import 'package:vegiffyy_vendor/views/Plan/vendor_joining_fee_screen.dart';
import 'package:vegiffyy_vendor/views/Plan/vendor_my_plans_screen.dart';
import 'package:vegiffyy_vendor/views/Product/create_product_screen.dart';
import 'package:vegiffyy_vendor/views/Product/product_list_screen.dart';
import 'package:vegiffyy_vendor/views/Profile/vendor_profile_screen.dart';
import 'package:vegiffyy_vendor/views/Support/vendor_support_screen.dart';
import 'package:vegiffyy_vendor/views/Users/vendor_users_screen.dart';
import 'package:vegiffyy_vendor/views/Wallet/my_wallet_screen.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../auth/login_screen.dart';
import 'vendor_dashboard_screen.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  bool _isActive = false;
  bool _loadingStatus = true;
  bool _updatingStatus = false;

  int _notificationCount = 0;
  bool _loadingNotifications = true;


  int _bottomIndexFromSection(VendorSection section) {
  switch (section) {
    case VendorSection.dashboard:
      return 0;
    case VendorSection.allOrders:
    case VendorSection.pendingOrders:
    case VendorSection.completedOrders:
      return 1;
    case VendorSection.profile:
      return 2;
    default:
      return 0;
  }
}

VendorSection _sectionFromBottomIndex(int index) {
  switch (index) {
    case 0:
      return VendorSection.dashboard;
    case 1:
      return VendorSection.allOrders;
    case 2:
      return VendorSection.profile;
    default:
      return VendorSection.dashboard;
  }
}


  // 🔹 FETCH STATUS
  Future<void> _fetchVendorStatus(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.vegiffyy.com/api/vendor/vendorstatus/$vendorId'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _isActive = data['status'] == 'active');
      }
    } catch (_) {}
    finally {
      setState(() => _loadingStatus = false);
    }
  }

  // 🔹 UPDATE STATUS
  Future<void> _updateVendorStatus(String vendorId, bool value) async {
    setState(() => _updatingStatus = true);

    try {
      await http.put(
        Uri.parse('https://api.vegiffyy.com/api/vendor/vendorstatus/$vendorId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': value ? 'active' : 'inactive'}),
      );
      setState(() => _isActive = value);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    } finally {
      setState(() => _updatingStatus = false);
    }
  }

  // 🔹 FETCH NOTIFICATION COUNT
  Future<void> _fetchNotificationCount(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.vegiffyy.com/api/vendor/notification/$vendorId'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _notificationCount = data['count'] ?? 0);
      }
    } catch (_) {}
    finally {
      setState(() => _loadingNotifications = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final vendorId = context.read<AuthProvider>().vendor?.id;

    if (vendorId != null && _loadingStatus) {
      _fetchVendorStatus(vendorId);
    }

    if (vendorId != null && _loadingNotifications) {
      _fetchNotificationCount(vendorId);
    }
  }

  // 🔹 LOGOUT
  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );

    if (ok == true) {
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  // 🔹 BODY SWITCH
  Widget _buildBody(VendorSection section) {
    switch (section) {
      case VendorSection.dashboard:
        return const VendorDashboardScreen();

      case VendorSection.notifications:
        return VendorNotificationsScreen(
          vendorId: context.read<AuthProvider>().vendor!.id,
        );

      case VendorSection.addCategory:
        return const AddCategoryScreen();

      case VendorSection.allCategories:
          return const CategoryListScreen();


      case VendorSection.addProduct:
              return const CreateProductScreen();


      case VendorSection.allProducts:
        return const ProductListScreen();

      case VendorSection.allOrders:
        return const BookingListScreen();

      case VendorSection.pendingOrders:
        return const PendingBooking();

      case VendorSection.completedOrders:
        return const CompletedBooking();

      case VendorSection.wallet:
        return const MyWalletScreen();

      case VendorSection.payJoining:
        return const VendorJoiningFeeScreen();

      case VendorSection.myPaidPlan:
        return const VendorMyPlansScreen();

      case VendorSection.profile:
          return const VendorProfileScreen();

      case VendorSection.commission:
        return const CommissionReportScreen();

      case VendorSection.account:
        return const AccountManagementScreen();

      case VendorSection.users:
                     return const VendorUsersScreen();


      case VendorSection.support:
              return const VendorSupportScreen();


      case VendorSection.about:
        return const AboutUsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<VendorNavigationProvider>();
    final vendor = context.watch<AuthProvider>().vendor;

    return Scaffold(
      drawer: _VendorDrawer(
        selectedSection: nav.current,
        onSelectSection: (s) {
          context.read<VendorNavigationProvider>().setSection(s);
          Navigator.pop(context);
        },
        onLogout: _confirmLogout,
      ),
appBar: AppBar(
  elevation: 1,
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  titleSpacing: 0,
  title: Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          vendor?.restaurantName ?? 'Vendor Dashboard',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _isActive ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _isActive ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 12,
                color: _isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
  actions: [
    // 🔔 Notifications
    Padding(
      padding: const EdgeInsets.only(right: 6),
      child: IconButton(
        tooltip: 'Notifications',
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_outlined, color: Colors.black87),
            if (_notificationCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$_notificationCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onPressed: () {
          context
              .read<VendorNavigationProvider>()
              .setSection(VendorSection.notifications);
        },
      ),
    ),

    // 🔄 Active Switch
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          if (_loadingStatus || _updatingStatus)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Switch(
              value: _isActive,
              activeColor: Colors.green,
              onChanged: (v) {
                if (vendor?.id != null) {
                  _updateVendorStatus(vendor!.id, v);
                }
              },
            ),
          const SizedBox(width: 6),
          Text(
            _isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isActive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    ),
  ],
),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildBody(nav.current),
      ),
        bottomNavigationBar: _buildBottomBar(context),

    );
  }

  Widget _buildBottomBar(BuildContext context) {
  final nav = context.watch<VendorNavigationProvider>();
  final theme = Theme.of(context);
  final isMobile = MediaQuery.of(context).size.width < 600;

  if (!isMobile) return const SizedBox.shrink();

  return BottomNavigationBar(
    currentIndex: _bottomIndexFromSection(nav.current),
    onTap: (index) {
      context
          .read<VendorNavigationProvider>()
          .setSection(_sectionFromBottomIndex(index));
    },
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Orders',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  );
}

}



/* ===================== DRAWER ===================== */

class _VendorDrawer extends StatelessWidget {
  final VendorSection selectedSection;
  final ValueChanged<VendorSection> onSelectSection;
  final VoidCallback onLogout;

  const _VendorDrawer({
    required this.selectedSection,
    required this.onSelectSection,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final vendor = context.watch<AuthProvider>().vendor;
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          // ===================== TOP HEADER =====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.green.shade100),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Title
                Row(
                  children: [
                    Icon(Icons.eco, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      "Vegiffyy Green\nPartner",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Vendor Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendor?.restaurantName ?? 'Restaurant',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vendor?.email ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (vendor?.mobile != null)
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  vendor!.mobile!,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===================== MENU =====================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _item(Icons.dashboard, 'Dashboard', VendorSection.dashboard),
                _item(Icons.notifications, 'Notifications', VendorSection.notifications),

                ExpansionTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categories'),
                  children: [
                    _sub('Add Category', VendorSection.addCategory),
                    _sub('All Categories', VendorSection.allCategories),
                  ],
                ),

                ExpansionTile(
                  leading: const Icon(Icons.fastfood),
                  title: const Text('Products'),
                  children: [
                    _sub('Add Product', VendorSection.addProduct),
                    _sub('All Products', VendorSection.allProducts),
                  ],
                ),

                ExpansionTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Orders'),
                  children: [
                    _sub('All Orders', VendorSection.allOrders),
                    _sub('Pending Orders', VendorSection.pendingOrders),
                    _sub('Completed Orders', VendorSection.completedOrders),
                  ],
                ),

                _item(Icons.account_balance_wallet, 'My Wallet', VendorSection.wallet),

                ExpansionTile(
                  leading: const Icon(Icons.currency_rupee),
                  title: const Text('Pay Joining Fee'),
                  children: [
                    _sub('Pay', VendorSection.payJoining),
                    _sub('My Paid Plan', VendorSection.myPaidPlan),
                  ],
                ),

                _item(Icons.person, 'My Profile', VendorSection.profile),
                _item(Icons.percent, 'My Commission', VendorSection.commission),
                _item(Icons.settings, 'My Account', VendorSection.account),
                _item(Icons.group, 'Users', VendorSection.users),
                _item(Icons.support_agent, 'Support', VendorSection.support),
                _item(Icons.info_outline, 'About Us', VendorSection.about),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: onLogout,
                ),
              ],
            ),
          ),

          // ===================== FOOTER =====================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.green.shade100),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Need Help?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Contact Support: vendor@vegiffyy.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.help_outline, size: 20),
                    SizedBox(width: 16),
                    Icon(Icons.headset_mic_outlined, size: 20),
                    SizedBox(width: 16),
                    Icon(Icons.info_outline, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== HELPERS =====================

  Widget _item(IconData icon, String title, VendorSection section) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onSelectSection(section),
    );
  }

  Widget _sub(String title, VendorSection section) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48),
      title: Text(title),
      onTap: () => onSelectSection(section),
    );
  }
}


