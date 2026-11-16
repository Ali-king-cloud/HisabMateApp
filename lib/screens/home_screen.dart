
import 'package:flutter/material.dart';
import 'shared_expenses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const green = Color(0xFF079F78);
  static const red = Color(0xFFE94349);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet,
                      color: green, size: 30),
                  const SizedBox(width: 6),
                  const Text(
                    'HisabMate',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.receipt_long),
                  const SizedBox(width: 18),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            // Greeting
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Ahmad',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Hello from HisabMate',
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: summaryCard(
                      'To Receive',
                      'PKR 25,000',
                      'Green',
                      green,
                      Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: summaryCard(
                      'To Pay',
                      'PKR 18,500',
                      'Red',
                      red,
                      Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Recent Activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SharedExpensesScreen(),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            // Activity List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  activityCard(
                    'Okasha',
                    'Shopping, Rent',
                    'PKR 25,000',
                    'Paid',
                    green,
                  ),
                  activityCard(
                    'Ali Ibrahim',
                    'Shopping, Borrow',
                    'PKR 9,500',
                    'Status',
                    const Color(0xFF4846B9),
                  ),
                  activityCard(
                    'Talha',
                    'Shared Expense',
                    'PKR 2,500',
                    'Pending',
                    const Color(0xFFF39A22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: green,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const SharedExpensesScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navIcon(Icons.home, green),
              navIcon(Icons.people_outline, Colors.grey),
              const SizedBox(width: 45),
              navIcon(Icons.notifications_none, Colors.grey),
              navIcon(Icons.person_outline, Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Summary Card
  static Widget summaryCard(
      String title,
      String amount,
      String label,
      Color color,
      IconData icon,
      ) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
              Icon(icon, color: Colors.white, size: 18),
            ],
          ),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12)),
          const SizedBox(height: 4),
          Text(amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  // Navigation Icon
  static Widget navIcon(IconData icon, Color color) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: color, size: 23),
    );
  }
}

// Activity Card
Widget activityCard(
    String name,
    String subtitle,
    String amount,
    String status,
    Color color,
    ) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFE9EAF5),
          child: Icon(Icons.person, color: Color(0xFF292B65)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(status,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10)),
            ),
          ],
        ),
      ],
    ),
  );
}
