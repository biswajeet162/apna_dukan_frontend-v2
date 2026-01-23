import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../data/models/user_profile_response.dart';
import '../data/models/address_response.dart';
import '../domain/usecases/get_user_profile_usecase.dart';
import '../domain/usecases/get_user_addresses_usecase.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileResponse? _userProfile;
  List<AddressResponse> _addresses = [];
  bool _isLoading = true;
  String? _errorMessage;
  final AuthService _authService = AuthService(ServiceLocator().secureStorage);

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profileUseCase = GetUserProfileUseCase(
        ServiceLocator().profileRepository,
      );
      final addressesUseCase = GetUserAddressesUseCase(
        ServiceLocator().profileRepository,
      );

      final profileFuture = profileUseCase.call();
      final addressesFuture = addressesUseCase.call();

      final results = await Future.wait([
        profileFuture,
        addressesFuture,
      ]);

      setState(() {
        _userProfile = results[0] as UserProfileResponse;
        _addresses = results[1] as List<AddressResponse>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Call logout API
        final dio = ServiceLocator().dioClient.dio;
        try {
          await dio.post(ApiEndpoints.logout);
        } catch (e) {
          // Even if API call fails, clear local storage
          print('Logout API error: $e');
        }

        // Clear local storage
        await _authService.logout();

        // Navigate to login
        if (mounted) {
          context.go(AppRoutes.login);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during logout: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfileData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProfileData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info Card
                        _buildUserInfoCard(),
                        const SizedBox(height: 24),
                        // Addresses Section
                        if (_addresses.isNotEmpty) ...[
                          _buildAddressesSection(),
                          const SizedBox(height: 24),
                        ],
                        // Logout Button
                        _buildLogoutButton(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildUserInfoCard() {
    if (_userProfile == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userProfile!.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userProfile!.role,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            // User ID
            _buildInfoRow(
              icon: Icons.badge,
              label: 'User ID',
              value: _userProfile!.userId,
            ),
            const SizedBox(height: 12),
            // Email
            if (_userProfile!.email != null && _userProfile!.email!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.email,
                label: 'Email',
                value: _userProfile!.email!,
                verified: _userProfile!.emailVerified,
              ),
            if (_userProfile!.email != null && _userProfile!.email!.isNotEmpty)
              const SizedBox(height: 12),
            // Phone
            if (_userProfile!.phone != null && _userProfile!.phone!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.phone,
                label: 'Phone',
                value: _userProfile!.phone!,
                verified: _userProfile!.phoneVerified,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool verified = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (verified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Addresses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(AppRoutes.addresses);
              },
              child: const Text('Manage'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._addresses.map((address) => _buildAddressCard(address)),
      ],
    );
  }

  Widget _buildAddressCard(AddressResponse address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: address.isDefault
            ? BorderSide(color: Colors.green[700]!, width: 2)
            : BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getAddressTypeIcon(address.type),
                      size: 20,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      address.type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address.phone,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              address.fullAddress,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAddressTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'HOME':
        return Icons.home;
      case 'WORK':
        return Icons.work;
      case 'OTHER':
        return Icons.location_on;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
