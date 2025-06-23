import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{
  final supbase = Supabase.instance.client;

  Future<void> nativeGoogleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '340407306537-up0ej4ogma415mpja5meagasund0bc76.apps.googleusercontent.com';
    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = '340407306537-1aj1kmet7lmk6ogtsjau4d8aoq9aa1gs.apps.googleusercontent.com';
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    try{
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // User cancelled the sign-in
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception("Access token or ID token is null");
      }


      final res =await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      print(res.user?.email);

      Get.offAllNamed('/layout'); // Adjust the route as needed
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    }
  }

  Future<void> signOut() async {
    try {
      await supbase.auth.signOut();
      Get.offAllNamed('/login'); // Adjust the route as needed
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


}