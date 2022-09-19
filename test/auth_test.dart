import 'package:dstnotes/services/auth/auth_exceptions.dart';
import 'package:dstnotes/services/auth/auth_provider.dart';
import 'package:dstnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('MockAuthProvider', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begining with', () {
      expect(provider._isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider._user, null);
    });

    test('Should be able to be initialize in less 2 seconds', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to logIn function', () async {
      final badEmail =
          provider.createUser(email: "dst@gmail.com", password: "anyPass");
      expect(badEmail, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword =
          provider.createUser(email: "someone@gmail.com", password: "dst1252");
      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
          email: "anyEmail@gmail.com", password: "anyPass");

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get email verification', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(email: "anyEmail@gmail.com", password: "anyPass");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialize => _isInitialized;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == "dst@gmail.com") throw UserNotFoundAuthException();
    if (password == "dst1252") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
