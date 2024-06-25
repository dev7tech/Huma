// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_string_interpolations

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hookup4u2/common/widets/custom_snackbar.dart';
import 'package:hookup4u2/common/widets/hookup_circularbar.dart';
import 'package:hookup4u2/features/auth/auth.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants/colors.dart';
import '../../../../../common/providers/theme_provider.dart';
import '../../../../../common/widets/custom_button.dart';
import '../../bloc/phone_auth_bloc.dart';
import '../widgets/timer_widget.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  int start = 30;
  NumberFormat formatter = NumberFormat("00");

  late TextEditingController codeController;
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  @override
  void dispose() {
    controller.stopListen();
    codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initializeOtpInteraction();
    codeController = TextEditingController();

    super.initState();

    final authRepo = context.read<AuthRepo>();

    if (authRepo.isDevAvailable()) {
      context.read<PhoneAuthBloc>().add(VerifyOtpSent(
          otpCode: dotenv.env['DEV_OTP']!, phone: dotenv.env['DEV_PHONE']!));
    }
  }

  void _initializeOtpInteraction() {
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        .then((value) => debugPrint('signature - $value'));

    controller = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) =>
          debugPrint('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          debugPrint("code is $code");
          final exp = RegExp(r'(\d{6})');
          debugPrint("code is final  ${exp.stringMatch(code ?? '')}");
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final phoneNumber =
        context.select((PhoneAuthBloc bloc) => bloc.state.phone);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
        builder: (context, state) {
          final phoneVerified = state is PhoneAuthVerified;

          return BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
              // TODO: Add check for registration fail state
              if (state is RegistrationLoading || phoneVerified) {
                return SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 200),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "asset/auth/verified.jpg",
                              height: 60,
                              color: primaryColor,
                              colorBlendMode: BlendMode.color,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Phone Verified".tr().toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.black,
                                  fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hookup4uBar(),
                          SizedBox(width: 10),
                          // TODO: Add translation
                          Text('Loading Account'),
                        ],
                      )
                    ],
                  ),
                );
              }

              return Container(
                color: Theme.of(context).primaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 100),
                          width: 300,
                          child: Image.asset(
                            "asset/auth/verifyOtp.png",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 50),
                        child: RichText(
                          text: TextSpan(
                              text: "Enter the code sent to ".tr().toString(),
                              children: [
                                TextSpan(
                                    text: phoneNumber,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        textBaseline: TextBaseline.alphabetic,
                                        fontSize: 15)),
                              ],
                              style: TextStyle(
                                  fontFamily: 'Gellix',
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 15)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: PinCodeTextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                              fieldHeight: 50,
                              fieldWidth: 35,
                              inactiveFillColor: Colors.white,
                              inactiveColor: primaryColor,
                              selectedColor: Colors.green,
                              selectedFillColor: Colors.white,
                              activeFillColor: Colors.white,
                              activeColor: Colors.green),
                          //shape: PinCodeFieldShape.underline,
                          animationDuration: const Duration(milliseconds: 300),
                          //fieldHeight: 50,
                          //fieldWidth: 35,
                          onChanged: (value) {
                            codeController.text = value;
                          },
                          appContext: context,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
                        listener: (context, state) {
                          if (state is PhoneAuthLoading) {}
                          if (state is PhoneAuthCodeResent) {
                            // TODO: Add translation
                            CustomSnackbar.showSnackBarSimple(
                              "OTP resent to ${state.phone}",
                              context,
                            );
                          }
                        },
                        builder: (context, state) {
                          return TimerWidget(
                            start: start,
                            resendText:
                                "Didn't receive the code? \t".tr().toString(),
                            phoneNumber: phoneNumber,
                            onResendOtp: () {
                              context.read<PhoneAuthBloc>().add(
                                    ReSendOtpToPhone(phoneNumber: phoneNumber),
                                  );
                              _initializeOtpInteraction();
                            },
                            isSending: state is PhoneAuthResending,
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
                        builder: (context, state) {
                          if (state is PhoneAuthLoading) {
                            return const Hookup4uBar();
                          } else if (state is PhoneAuthVerified) {
                            return const SizedBox.shrink();
                          }
                          return CustomButton(
                            text: 'Verify'.tr().toString(),
                            color: textColor,
                            active: true,
                            onTap: state is PhoneAuthResending
                                ? null
                                : () {
                                    if (codeController.text.trim().isEmpty) {
                                      CustomSnackbar.showSnackBarSimple(
                                        "otp can not empty".tr().toString(),
                                        context,
                                      );
                                    } else {
                                      _verifyOtp(
                                          context: context,
                                          phoneNumber: phoneNumber);
                                    }
                                  },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _verifyOtp(
      {required String phoneNumber, required BuildContext context}) {
    // if (widget.updatePhoneNumber) {
    //   context.read<PhoneAuthBloc>().add(OnPhoneNumberupdateEvent(
    //       phoneNumber: phoneNumber,
    //       verificationId: widget.smsVerificationCode,
    //       token: codeController));
    //   debugPrint("coming under update number");
    // } else {
    context
        .read<PhoneAuthBloc>()
        .add(VerifyOtpSent(otpCode: codeController.text, phone: phoneNumber));
    // }
  }
}
