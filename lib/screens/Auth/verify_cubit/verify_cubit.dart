import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_management_app/data_layer/data_layer.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/services/setup.dart';

part 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  final api = ApiNetworking();

  VerifyCubit() : super(VerifyInitial());

  verifyMethod({
    required String email,
    required String otp,
  }) async {
    try {
      emit(LoadingState());
      final userAuth = await api.verifyOTP(email: email, otp: otp);
      if (userAuth != null) {
        await locator.get<DataLayer>().saveAuth(authData: userAuth);
        emit(SuccessState());
      } else {
        emit(ErrorState(message: 'Invalid OTP. Please try again.'));
      }
    } catch (error) {
      emit(ErrorState(message: 'An error occurred during verification.'));
    }
  }
}
