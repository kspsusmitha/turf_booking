import 'package:firebase_database/firebase_database.dart';


class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal() {
    _database = FirebaseDatabase.instance;
    _usersRef = _database.ref().child('users');
  }

  late final FirebaseDatabase _database;
  late final DatabaseReference _usersRef;

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final normalizedEmail = email.toLowerCase();

      // Create new user
      final newUserRef = _usersRef.push();
      final userData = {
        'name': name,
        'email': normalizedEmail,
        'password': password,
        'phone': phone,
        'createdAt': ServerValue.timestamp,
      };
      
      await newUserRef.set(userData);

      return {
        'success': true,
        'message': 'Registration successful',
        'user': {
          'id': newUserRef.key,
          'name': name,
          'email': normalizedEmail,
          'phone': phone,
        }
      };
    } catch (e) {
      print('Error registering user: $e');
      return {
        'success': false,
        'message': 'Registration failed. Please try again.'
      };
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.toLowerCase();
      
      // Get all users and find matching email
      final usersSnapshot = await _usersRef.get();
      
      if (!usersSnapshot.exists) {
        return {
          'success': false,
          'message': 'User not found'
        };
      }

      // Convert snapshot to Map
      final usersMap = usersSnapshot.value as Map<dynamic, dynamic>;
      
      // Find user with matching email
      String? userId;
      Map<dynamic, dynamic>? matchedUser;
      
      usersMap.forEach((key, value) {
        if (value['email'] == normalizedEmail) {
          userId = key;
          matchedUser = value;
        }
      });

      if (matchedUser == null) {
        return {
          'success': false,
          'message': 'User not found'
        };
      }

      // Check password
      if (matchedUser!['password'] == password) {
        return {
          'success': true,
          'message': 'Login successful',
          'user': {
            'id': userId,
            'name': matchedUser!['name'],
            'email': matchedUser!['email'],
            'phone': matchedUser!['phone'],
          }
        };
      }

      return {
        'success': false,
        'message': 'Invalid password'
      };
    } catch (e) {
      print('Error logging in user: $e');
      return {
        'success': false,
        'message': 'Login failed. Please try again.'
      };
    }
  }
} 