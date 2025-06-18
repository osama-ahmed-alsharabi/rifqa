import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';

void main() => runApp(const HotelDashboardApp());

class HotelDashboardApp extends StatelessWidget {
  const HotelDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لوحة تحكم الفندق',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Tajawal', // Use an Arabic-friendly font
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
        title: const Text(
          'لوحة تحكم الفندق',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // Align to right for RTL
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Stats Cards
            _buildStatsRow(),
            const SizedBox(height: 24),

            // Recent Bookings
            _buildSectionTitle('الحجوزات الحديثة'),
            const SizedBox(height: 16),
            _buildBookingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Align to right
      children: [
        Text(
          'صباح الخير،',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const Text(
          'مدير الفندق',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('إجمالي الضيوف', '128', Icons.people, Colors.blue),
          _buildStatCard('معدل الإشغال', '82%', Icons.hotel, Colors.green),
          _buildStatCard('وصل اليوم', '24', Icons.login, Colors.orange),
          _buildStatCard(
              'الإيرادات', '12.8 ألف', Icons.attach_money, Colors.purple),
        ].reversed.toList(), // Reverse for RTL layout
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 16), // Adjusted for RTL
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Align to right
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildBookingsList() {
    final bookings = [
      {'name': 'محمد أحمد', 'room': '201', 'status': 'داخل الفندق'},
      {'name': 'فاطمة خالد', 'room': '305', 'status': 'في الانتظار'},
      {'name': 'عمر سعيد', 'room': '102', 'status': 'مغادرة'},
      {'name': 'نورة حسن', 'room': '404', 'status': 'داخل الفندق'},
    ];

    return Column(
      children: bookings.map((booking) {
        Color statusColor = Colors.grey;
        if (booking['status'] == 'داخل الفندق') statusColor = Colors.green;
        if (booking['status'] == 'في الانتظار') statusColor = Colors.orange;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(booking['name']!, textAlign: TextAlign.right),
            subtitle:
                Text('غرفة ${booking['room']}', textAlign: TextAlign.right),
            trailing: Chip(
              label: Text(booking['status']!,
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: statusColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}
