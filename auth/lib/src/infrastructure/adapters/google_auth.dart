import 'package:async/async.dart';
import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infrastructure/api/auth_api_contract.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth implements IAuthService {
  final IAuthApi _authApi;
  final GoogleSignIn _googleSignIn;   //No final word in the video
  GoogleSignInAccount? _currentUser;

  GoogleAuth(this._authApi, [GoogleSignIn? googleSignIn])   // No ? in GoogleSignIn line in the video
      : _googleSignIn = googleSignIn ??     //  Video has this._googleSignIn
            GoogleSignIn(
              scopes: ['email', 'profile'],
            );   

  @override
  Future<Result<Token>> signIn() async {
    await _handleGoogleSignIn();
    if (_currentUser == null) {
      return Result.error('Failed to signIn With Google');
    } else {
      Credential credential = Credential(
        authType: AuthType.google,
        email: _currentUser!.email,
        name: _currentUser
            ?.displayName, // No ! and ? on both  email and display names in the video
      );
      try {
        var result = await _authApi.signIn(credential);
        return Result.value(Token(result.asValue!.value));
      } catch (err) {
        return Result<Token>.error(err);
      }
    }
  }

  @override
  Future<void> signOut() async {
    _googleSignIn.disconnect();
  }

  _handleGoogleSignIn() async {
    try {
      _currentUser = (await _googleSignIn.signIn())!;
    } catch (error) {
      return;
    }
  }
}
