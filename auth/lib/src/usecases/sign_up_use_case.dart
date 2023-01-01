// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:async/async.dart';
import 'package:auth/src/domain/sign_up_service_contract.dart';
import 'package:auth/src/domain/token.dart';

class SignInUseCase {
  final ISignUpService _signUpService;

  SignInUseCase(
    this._signUpService,
  );

  Future<Result<Token>> execute(String name , String email, String password) async {
    return await _signUpService.signUp(name, email, password);
  }
}
