// lib/services/auth_service.dart

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  /// Register a new user with email and password.
  /// Back4App uses 'username' as the login field; we set it equal to email.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    try {
      final user = ParseUser(email, password, email);
      final response = await user.signUp();

      if (response.success) {
        return {'success': true, 'user': response.result};
      } else {
        return {
          'success': false,
          'message': response.error?.message ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Login with email and password.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = ParseUser(email, password, null);
      final response = await user.login();

      if (response.success) {
        return {'success': true, 'user': response.result};
      } else {
        return {
          'success': false,
          'message': response.error?.message ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Logout the current session.
  Future<bool> logout() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        final response = await user.logout();
        return response.success;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns the currently logged-in user, or null.
  Future<ParseUser?> getCurrentUser() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user != null) {
        // Validate session is still active on the server
        final response = await ParseUser.getCurrentUserFromServer(
          user.sessionToken!,
        );
        if (response?.success == true) return response!.result as ParseUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Returns whether a user is currently logged in (fast, local check).
  Future<bool> isLoggedIn() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      return user?.sessionToken != null;
    } catch (e) {
      return false;
    }
  }
}
