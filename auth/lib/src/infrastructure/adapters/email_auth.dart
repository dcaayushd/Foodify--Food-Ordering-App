import 'package:async/async.dart';
import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/sign_up_service_contract.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infrastructure/api/auth_api_contract.dart';

class EmailAuth implements IAuthService, ISignUpService {
  final IAuthApi _api;
  Credential? _credential; // The ? is not in the video

  EmailAuth(this._api);

  void credential({
    required String email,
    required String password,
  }) {
    _credential = Credential(
      authType: AuthType.email,
      email: email,
      password: password,
    );
  }

  @override
  Future<Result<Token>> signIn() async {
    assert(_credential != null);
    try {
      var result = await _api.signIn(_credential!); // Null check is not implemented in the video
      return Result.value(Token(result.asValue!.value));
    } catch (err) {
      return Result<Token>.error(err);
    }
    ////This gives an error
    // var result = await _api.signIn(_credential);
    // if (result.isError) {
    //   return result.asError;
    // } else {
    //   return Result.value(Token(result.asValue!.value)); // null check is not implemented in the video
    // }
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<Result<Token>> signUp(
    String name,
    String email,
    String password,
  ) async {
    Credential credential = Credential(
      authType: AuthType.email,
      email: email,
      name: name,
      password: password,
    );
    try {
      var result = await _api.signIn(credential);
      return Result.value(Token(result.asValue!.value));
    } catch (err) {
      return Result<Token>.error(err);
    }
  }
}
