
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/presentation/widget/settings_widget/delete_account/delete_account_statehandle.dart';
import 'package:user_panel/core/common/custom_actionbutton_widget.dart';
import 'package:user_panel/core/common/custom_formfield_widget.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import 'package:user_panel/core/validation/input_validation.dart';

import '../../../../../core/common/custom_appbar_widget.dart';
import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../provider/bloc/delete_account_bloc/delete_account_bloc.dart';

class MeidaQuaryHelper {
  static double width(BuildContext context)  => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;
}

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHight = MeidaQuaryHelper.height(context);
    double screenWidth = MeidaQuaryHelper.width(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: DeleteAccountBody(screenWidth: screenWidth,screenHight: screenHight,formKey: _formKey),
          ),
        )
        ),
    );
  }
}

class DeleteAccountBody extends StatefulWidget {
  const DeleteAccountBody({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHight;
  final GlobalKey<FormState> formKey;

  @override
  State<DeleteAccountBody> createState() => _DeleteAccountBodyState();
}

class _DeleteAccountBodyState extends State<DeleteAccountBody> with FormFieldMixin{
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:widget.screenWidth > 600 ? widget.screenWidth *.3 :  widget.screenWidth * 0.08,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Verification' ,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 28, fontWeight: FontWeight.bold, color: AppPalette.logoutClr),
          ),
          ConstantWidgets.hight10(context),
          Text( "To delete your account, please enter your password to verify your identity. If you’ve forgotten your password, you can use the 'Forgot Password' option to reset it. Once your credentials are confirmed, tap 'Delete Account' to proceed. Please note that this action is permanent and cannot be undone."
            ),
          ConstantWidgets.hight50(context),
          Form(
            key: widget.formKey,
            child: buildTextFormField(
                context: context,
                label: 'Password',
                hintText: "Enter Valid Password",
                prefixIcon: CupertinoIcons.lock,
                controller: _passwordController,
                isPasswordField: true,
                validate: ValidatorHelper.loginValidation),
          ),
          ConstantWidgets.hight30(context),
          BlocProvider(
            create: (context) => DeleteAccountBloc(),
            child: BlocListener<DeleteAccountBloc, DeleteAccountState>(
              listener: (context, state) {
                handleDeleteAccountState(context, state);
              },  child: Builder(
                builder: (context) {
                  final deleteAccountBloc = context.read<DeleteAccountBloc>();
                  return ButtonComponents.actionButton(
                    screenWidth: widget.screenWidth,
                    screenHeight: widget.screenHight,
                    buttonColor: AppPalette.redClr,
                    label: 'Delete Account?',
                    onTap: () async {
                      if (widget.formKey.currentState!.validate()) {
                        deleteAccountBloc.add(
                          DeleteAccountProceed(_passwordController.text.trim(),
                          ),
                        );
                      } else {
                        CustomeSnackBar.show(
                          context: context,
                          title: 'Submission Failed',
                          description:
                              'Please fill in all the required fields before proceeding..',
                          titleClr: AppPalette.redClr,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
