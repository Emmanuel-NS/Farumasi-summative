import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']),
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserEntity> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null
          ? UserEntity.empty
          : firebaseUser.toUser;
      return user;
    });
  }

  @override
  UserEntity get currentUser {
    return _firebaseAuth.currentUser?.toUser ?? UserEntity.empty;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null) {
        await credential.user?.updateDisplayName(displayName);
      }

      // Save user to Firestore
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'displayName': displayName ?? '',
          'role': 'patient',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Send email verification
        await credential.user?.sendEmailVerification();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpFailure(e.message ?? 'An unknown error occurred');
    } catch (e) {
      throw SignUpFailure(e.toString());
    }
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null && !credential.user!.emailVerified) {
        // Automatically send a new verification email if they try to log in and aren't verified
        // You can comment this out if you prefer them to request it manually
        await credential.user?.sendEmailVerification();
        throw LogInWithEmailAndPasswordFailure(
          'Please verify your email to log in. A new verification link has been sent.',
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure(
        e.message ?? 'An unknown error occurred',
      );
    } catch (e) {
      if (e is LogInWithEmailAndPasswordFailure) rethrow;
      throw LogInWithEmailAndPasswordFailure(e.toString());
    }
  }

  @override
  Future<void> logInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in flow
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      // Save user to Firestore if new
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        if (!userDoc.exists) {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'uid': userCredential.user!.uid,
                'email': userCredential.user!.email ?? googleUser.email,
                'displayName':
                    userCredential.user!.displayName ??
                    googleUser.displayName ??
                    '',
                'photoUrl': userCredential.user!.photoURL,
                'role': 'patient',
                'createdAt': FieldValue.serverTimestamp(),
              });
        }
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure(e.message ?? 'An unknown error occurred');
    } catch (e) {
      // Revert await if needed, analyzer said `not a subtype of Future`.
      // Let's remove await below if this block is replaced.
      throw LogInWithGoogleFailure(e.toString());
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ResetPasswordFailure(e.message ?? 'Could not send reset email');
    } catch (e) {
      throw ResetPasswordFailure(e.toString());
    }
  }
}

extension on firebase_auth.User {
  UserEntity get toUser {
    return UserEntity(
      id: uid,
      email: email ?? '',
      displayName: displayName,
      photoUrl: photoURL,
    );
  }
}
