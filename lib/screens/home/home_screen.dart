import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';
import 'add_visitor_screen.dart';
import 'visitors_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _visitorService = VisitorService();
  final _userService = UserService();

  User? _currentUser;
  AppUser? _userData;
  int _insideCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    // Reload user to ensure displayName is populated
    _currentUser?.reload().then((_) {
      if (mounted) {
        setState(() {
          _currentUser = _authService.currentUser;
        });
      }
    }).catchError((e) {
      // Silently fail, we'll use what we have
    });
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (_currentUser == null) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      AppUser? fetchedUser;
      
      try {
        // Try to fetch user data from Firestore with timeout
        fetchedUser = await _userService.getUser(_currentUser!.uid).timeout(
          const Duration(seconds: 3),
          onTimeout: () => null,
        );
      } catch (e) {
        // Silently fail - we'll use fallback data
      }

      // Use fetched data or create fallback from Firebase Auth
      // Make sure to reload user first to get latest displayName
      await _currentUser?.reload().catchError((_) {});
      
      final userData = fetchedUser ?? AppUser(
        id: _currentUser!.uid,
        email: _currentUser!.email ?? 'No email',
        name: _currentUser!.displayName ?? 'User',
        role: 'guard',
        createdAt: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }

      // Load visitor count in background (don't wait for it)
      _loadVisitorCount();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadVisitorCount() async {
    try {
      final visitors = await _visitorService.getInsideVisitors().timeout(
        const Duration(seconds: 3),
        onTimeout: () => [],
      );
      if (mounted) {
        setState(() => _insideCount = visitors.length);
      }
    } catch (e) {
      // Silently fail
    }
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
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              (_userData?.name ?? 'U').substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userData?.name ?? 'User',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimaryColor,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _userData?.email ?? 'No email',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      // ignore: deprecated_member_use
                      Divider(color: AppTheme.textSecondaryColor.withOpacity(0.2)),
                      const SizedBox(height: AppTheme.spacingMedium),
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Role: ',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _userData?.role == 'admin'
                                  // ignore: deprecated_member_use
                                  ? AppTheme.primaryColor.withOpacity(0.2)
                                  // ignore: deprecated_member_use
                                  : Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              (_userData?.role ?? 'guard').toUpperCase(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _userData?.role == 'admin'
                                        ? AppTheme.primaryColor
                                        : Colors.blue,
                                  ),
                            ),
                          ),
                        ],
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
