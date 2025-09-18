
import 'package:bloc/bloc.dart';
import 'package:user_panel/auth/data/datasources/auth_remote_datasource.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  String _fullName = '';
  String _phoneNumber = '';
  String _address = ''; 
  String _email = '';
  String _password = '';
  String get fullName => _fullName;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get email => _email;
  String get password => _password;

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterPersonalData>((event, emit) {
      _fullName = event.fullName;
      _phoneNumber = event.phoneNumber;
      _address = event.address;
    });

    on<RegisterCredentialsData>((event, emit) {
      _email = event.email;
      _password = event.password;
      emit(SubmitionConfirmationAlertState());
    });

    on<RegisterSubmit>((event, emit)async {
      emit(RegisterLoading());
      try {
        bool response = await AuthRemoteDataSource().signUpUser(userName: _fullName, phoneNumber: _phoneNumber, address: _address, email: _email, password: _password);
        if (response) {
          emit(RegisterSuccess());
        }else{
          emit(RegisterFailure('Registration Failed'));
        }
      } catch (e) {
        emit(RegisterFailure('Registration Failed: $e'));
      }
    });
  }
}
