import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text('User Management', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
            Text('12,480 TOTAL MEMBERS', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert_rounded, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildUserCard(
                  name: 'Alex Rivera',
                  email: 'alex.rivera@example.com',
                  role: 'Pro',
                  status: 'Active',
                  joined: 'Oct 12, 2023',
                  avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLCHOdeHwvgphGgxaYkoCtweml8hhTjG-iAgfSvWOw6hn6cDcUnipCseW-QsSO2uG0Sk66b6yMvWMy84wygR6GO4OaNYKqsq-Ey8_1-w0tSpL0YOPWLd9P3214bcntDN-T6ezkWUiB-O8U_PCWbIACXgXCRHtnmTz1zID5fg_FPT0pig1SlJDwLyRe51tVohyVRrnMoY_0uLW0pre202JP_ye-wCj0z6V4YtjENZOc3cjkTHeov29h1WUbQsWwDR-cwqtmgYjzi0w',
                ),
                _buildUserCard(
                  name: 'Sarah Jenkins',
                  email: 'sarah.j@noble.dev',
                  role: 'Free',
                  status: 'Suspended',
                  joined: 'Sep 28, 2023',
                  avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBms4LkU5vzs7nfTgox2bu4smsyPHFC1BXktN22nbFkShGTKMKM55QsjQpxjBa_qD7QeaI3YFZBq0GARZ07JrwDfF5aPHd1N9UbKCRGV95uiU8GpUGqzYulg6k3IQwkQkDXGOu37uvKr4eg2mD2Cwr-xgS7c89AQSdtr5MHhmA8Xx9y-6_OHDtQvaiNNR6x6V9iySYz6rXDnPcTM1Mhk0B3QJXuzqcy4bvOR3UoBzsu92ig_O1p3W-MggwhhHyx8wjiSQjT3BG6pLE',
                ),
                _buildUserCard(
                  name: 'Michael Chen',
                  email: 'm.chen@outlook.com',
                  role: 'Pro',
                  status: 'Active',
                  joined: 'Aug 15, 2023',
                  avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZZYiPC7dbI1U1o7MwIxx_ypFo4VWT5w5yQwFnUJfr6af8PcmjvZaohRbepaJg0y5RitJNnGuCf0ebcNA8QCSXYzB1AzuCg98qU9U1K1rnhOMAmDQ_Pv1P8zo--uWgpIV6sOebxLUSLgpDypA9_sYk4mY5sgpgptITjzNzpmQXwP4snR5nOsXp8I-hfDgw0SFaExTzbis71tvvXJtjYOGJUvu2e_W3mD5TQGwBopzByNKs4X7lIE-hE0p00c87v2udkF3BUTMlpKs',
                ),
                _buildUserCard(
                  name: 'James Wilson',
                  email: 'jwilson@corp.com',
                  role: 'Free',
                  status: 'Active',
                  joined: 'Jul 02, 2023',
                  avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuANVONnivNu53NAzS3mtCu2K-mfv-HJI7EGjyS3J5h-1E-mXqDwMy2h9nw3QPAUO2oMcjT9Qp1mFG5n9sfasMECD7gMGmDVq1hqeCGrMLnjq4Q373VhXvaa01pe1uf8DjygyAt2J-9mSpCGB5BrOypyM-vWjx1ddsqOttU-Q-tjz5_JVVR5MrXx-oFedox2Y5pW1-xbqvVa3W78bB8ZnXp1kPMEHS0WHYqc4upl_4qRJ4cRTDgtWzRvH3cGYGvpuN5DRb4zDO85SKE',
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Column(
                    children: [
                      SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(height: 8),
                      Text('LOADING MORE USERS', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: const TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
            hintText: 'Search name, email or ID...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
            suffixIcon: Icon(Icons.tune_rounded, color: Colors.grey, size: 18),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildChip('All Users', isActive: true),
          const SizedBox(width: 8),
          _buildChip('Active'),
          const SizedBox(width: 8),
          _buildChip('Pro Plan'),
          const SizedBox(width: 8),
          _buildChip('Suspended'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColors.primary : AppColors.lightGrey),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required String name,
    required String email,
    required String role,
    required String status,
    required String joined,
    required String avatar,
  }) {
    bool isSuspended = status == 'Suspended';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.background,
                backgroundImage: NetworkImage(avatar),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_horiz_rounded, color: Colors.grey), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildTag(role, role == 'Pro' ? AppColors.primary : Colors.grey),
                  const SizedBox(width: 8),
                  _buildTag(status, isSuspended ? Colors.redAccent : const Color(0xFF10B981)),
                ],
              ),
              Text('Joined $joined', style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildActionBtn(Icons.visibility_rounded, 'Profile')),
              const SizedBox(width: 8),
              Expanded(child: _buildActionBtn(Icons.lock_reset_rounded, 'Password')),
              const SizedBox(width: 8),
              Expanded(child: _buildActionBtn(Icons.settings_rounded, 'Manage')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
        ],
      ),
    );
  }
}
