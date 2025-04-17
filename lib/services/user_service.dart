import 'package:firebase_database/firebase_database.dart';
import 'package:pitch_planner/models/user.dart';
import 'package:pitch_planner/services/user_preferences.dart';


class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal() {
    _database = FirebaseDatabase.instance.ref();
  }

  late final DatabaseReference _database;

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final normalizedEmail = email.toLowerCase();
      
      // Create new user reference
      final newUserRef = _database.child('users').push();
      final userId = newUserRef.key!;
      
      final userData = {
        'name': name,
        'email': normalizedEmail,
        'password': password,
        'phone': phone,
        'createdAt': ServerValue.timestamp,
      };

      await newUserRef.set(userData);
      
      // Save user ID to preferences
      await UserPreferences.setUserId(userId);
      await UserPreferences.saveUser({...userData, 'id': userId});

      return {
        'success': true,
        'message': 'Registration successful',
        'userId': userId
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration failed: $e'
      };
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.toLowerCase();
      
      final snapshot = await _database
          .child('users')
          .orderByChild('email')
          .equalTo(normalizedEmail)
          .get();

      if (!snapshot.exists || snapshot.value == null) {
        return {
          'success': false,
          'message': 'User not found'
        };
      }

      // Properly cast the Firebase response
      final Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
      final String userId = usersMap.keys.first.toString();
      final Map<dynamic, dynamic> userData = usersMap[userId] as Map<dynamic, dynamic>;

      if (userData['password'] != password) {
        return {
          'success': false,
          'message': 'Invalid password'
        };
      }

      // Convert to the correct type for SharedPreferences
      final Map<String, dynamic> userDataMap = {
        'id': userId,
        'name': userData['name']?.toString() ?? '',
        'email': userData['email']?.toString() ?? '',
        'phone': userData['phone']?.toString() ?? '',
        'createdAt': userData['createdAt'] ?? 0,
      };

      // Save user data to preferences
      await UserPreferences.setUserId(userId);
      await UserPreferences.saveUser(userDataMap);

      return {
        'success': true,
        'message': 'Login successful',
        'userId': userId,
        'user': userDataMap
      };
    } catch (e) {
      print("Login error: $e");
      return {
        'success': false,
        'message': 'Login failed: $e'
      };
    }
  }

  Future<User> getUserById(String userId) async {
    try {
      final snapshot = await _database
          .child('users')
          .child(userId)
          .get();

      if (!snapshot.exists) {
        throw Exception('User not found');
      }

      final userData = Map<String, dynamic>.from(snapshot.value as Map);
      
      return User(
        id: userId,
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? '',
        password: userData['password'] ?? '',
        createdAt: userData['createdAt'] ?? 0,
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _database
          .child('users')
          .child(user.id)
          .update({
            'name': user.name,
            'email': user.email,
            'phone': user.phone,
          });
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
} 