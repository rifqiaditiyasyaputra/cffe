import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';
import 'admin_menu_management.dart';
import 'admin_orders_management.dart';
import '../customer/main_navigation.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final outOfStockCount = menuProvider.allItems.where((i) => !i.isAvailable).length;

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryCoffee,
        title: Text('Panel Operasional Admin', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            onPressed: () {
              authProvider.toggleAdminMode(false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
            label: const Text('Mode Pelanggan', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Overview Cards Grid
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildStatCard('Total Pesanan', '${orderProvider.orders.length}', Icons.receipt, Colors.blue),
                  _buildStatCard('Antrean Aktif', '${orderProvider.activeQueueCount}', Icons.hourglass_top, Colors.orange),
                  _buildStatCard('Stok Habis', '$outOfStockCount Menu', Icons.warning_amber, Colors.red),
                  _buildStatCard('Total Omset', formatRupiah(orderProvider.totalRevenue), Icons.payments, Colors.green),
                ],
              ),
            ),

            // Tab Navigation
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.primaryCoffee,
                labelColor: AppTheme.primaryCoffee,
                unselectedLabelColor: AppTheme.textMuted,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
                tabs: const [
                  Tab(text: 'Kelola Pesanan'),
                  Tab(text: 'Kelola Menu & Stok'),
                  Tab(text: 'Ringkasan Meja'),
                ],
              ),
            ),

            // Tab View Body
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const AdminOrdersManagement(),
                  const AdminMenuManagement(),
                  _buildTablesSummaryView(orderProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCoffee.withOpacity(0.04),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 18,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesSummaryView(OrderProvider orderProvider) {
    final activeOrders = orderProvider.orders.where((o) => o.orderType == 'Makan di Tempat' && o.tableNumber != null).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Meja Kafe', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final tableNo = (index + 1).toString().padLeft(2, '0');
              final orderAtTable = activeOrders.firstWhere(
                (o) => o.tableNumber == tableNo,
                orElse: () => OrderModel(
                  id: '',
                  queueNumber: '',
                  items: [],
                  subtotal: 0,
                  taxAndService: 0,
                  total: 0,
                  orderType: '',
                  paymentMethod: '',
                  createdAt: DateTime.now(),
                ),
              );

              final bool isOccupied = orderAtTable.id.isNotEmpty;

              return Container(
                decoration: BoxDecoration(
                  color: isOccupied ? AppTheme.accentCaramel.withOpacity(0.15) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOccupied ? AppTheme.accentCaramel : AppTheme.borderLight,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      color: isOccupied ? AppTheme.accentCaramel : AppTheme.primaryCoffee,
                    ),
                    const SizedBox(height: 4),
                    Text('Meja $tableNo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      isOccupied ? 'Antrean ${orderAtTable.queueNumber}' : 'Kosong',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isOccupied ? AppTheme.accentCaramel : AppTheme.accentGreen,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
