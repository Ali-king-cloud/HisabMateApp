
import 'package:material_ui/material_ui.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: "Track Expenses Easily",
      description:
      "Easily record shared bills with friends, roommates, and family. Keep a clear log of money lent or borrowed, and see real-time balances of who owes who. Simplify your group expenses and maintain accurate records with HisabMate.",
    ),
    OnboardingItem(
      title: "Manage Debts & Repayments",
      description:
      "Keep track of full or partial repayments effortlessly. HisabMate automatically calculates remaining balances so you never lose track of what's paid and what's pending.",
    ),
    OnboardingItem(
      title: "Borrowed Items & Reminders",
      description:
      "Never lose personal belongings again. Track books, chargers, and tools lent or borrowed with expected return dates and helpful reminders.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleButtonPress() {
    if (_currentPage < _items.length - 1) {

      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 24),

            // Top Image / Illustration Card
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,

                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            height: 220,
                            margin: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: const Center(
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 80,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Bottom Content
            Expanded(
              flex: 4,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),

                child: Column(
                  children: [

                    // Title
                    Text(
                      _items[_currentPage].title,

                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),

                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      _items[_currentPage].description,

                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),

                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    // Page Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        _items.length,

                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),

                          margin: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),

                          height: 8.0,
                          width: _currentPage == index ? 24.0 : 8.0,

                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF10B981)
                                : const Color(0xFFCBD5E1),

                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Next / Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: _handleButtonPress,

                        child: Text(
                          _currentPage == _items.length - 1
                              ? "Get Started"
                              : "Next",

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onboarding Item Model
class OnboardingItem {

  final String title;
  final String description;

  OnboardingItem({
    required this.title,
    required this.description,
  });
}
