import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';
import 'add_visitor_screen.dart';
import 'visitors_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _visitorService = VisitorService();
  final _userService = UserService();

  late User? _currentUser;
  late AppUser? _userData;
  int _insideCount = 0;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _loadUserData();
    _loadInsideCount();
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      final userData = await _userService.getUser(_currentUser!.uid);
      setState(() => _userData = userData);
    }
  }

  Future<void> _loadInsideCount() async {
    final visitors = await _visitorService.getInsideVisitors();
    setState(() => _insideCount = visitors.length);
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Visitor Entry'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${_userData?.name ?? 'User'}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        'Role: ${_userData?.role.toUpperCase() ?? 'GUARD'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Stats Section
              Text(
                'Statistics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCard(
                        label: 'Inside',
                        count: _insideCount.toString(),
                        color: AppTheme.successColor,
                      ),
                      _StatCard(
                        label: 'Today\'s Visits',
                        count: '0',
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.person_add,
                      label: 'Add Visitor',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddVisitorScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.list,
                      label: 'View All',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const VisitorsListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
    );
  }
}
