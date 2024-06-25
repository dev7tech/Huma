import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/utils/crousle_slider.dart';
import 'package:hookup4u2/common/widets/custom_button.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:hookup4u2/features/user/profile/bloc/profile_bloc.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_cubit.dart';
import 'package:hookup4u2/features/user/ui/widgets/user_profile/add_media_btn.dart';
import 'package:hookup4u2/features/user/ui/widgets/user_profile/edit_info_btn.dart';
import 'package:hookup4u2/features/user/ui/widgets/user_profile/settings_btn.dart';
import 'package:hookup4u2/features/user/ui/widgets/user_profile/user_info.dart';
import 'package:hookup4u2/features/user/user.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/adds.dart';
import '../../../../common/constants/colors.dart';
import '../../../../common/providers/theme_provider.dart';
import '../../../../common/utils/upload_media.dart';
import '../../../../common/widets/custom_snackbar.dart';
import '../../../../common/widets/image_widget.dart';
import '../../../payment/ui/payments_detail.dart';

class ProfilePage extends StatefulWidget {
  // final bool isPuchased;
  final bool isPurchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  const ProfilePage(
      {super.key,
      required this.isPurchased,
      required this.items,
      required this.purchases});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final PageController pageController = PageController();

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profile =
        context.select((RegistrationBloc bloc) => bloc.state.profile);

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          CustomSnackbar.showSnackBarSimple(state.message, context);
        }
        if (state is ProfileMediaUploaded) {
          CustomSnackbar.showSnackBarSimple(
            "Media uploaded successfully".tr().toString(),
            context,
          );
          final dto = ProfileDto.fromProfile(profile).copyWith(imgs: [
            state.imageUrl,
            ...profile.imgs,
          ]);
          context.read<ProfileBloc>().add(ProfileUpdate(dto));
        }
        if (state is ProfilePicUploaded) {
          CustomSnackbar.showSnackBarSimple(
              "Profile pic updated".tr().toString(), context);

          final dto = ProfileDto.fromProfile(profile)
              .copyWith(profileUrl: state.imageUrl);
          context.read<ProfileBloc>().add(ProfileUpdate(dto));
        }
        if (state is ProfileUpdated) {
          context.read<RegistrationBloc>().add(
                UpdateRegisteredProfile(state.profile),
              );
        }
      },
      child: _UserProfileView(
        profile: profile,
        isPurchased: widget.isPurchased,
        items: widget.items,
        purchases: widget.purchases,
      ),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView(
      {required this.profile,
      required this.isPurchased,
      required this.items,
      required this.purchases});

  final Profile profile;
  final bool isPurchased;
  final Map items;
  final List<PurchaseDetails> purchases;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).primaryColor),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: "abc",
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: secondaryColor,
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          child: Stack(
                            children: <Widget>[
                              InkWell(
                                onTap: () => showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Info(
                                        profile,
                                        profile,
                                        false,
                                      );
                                    }),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      80,
                                    ),
                                    child: CustomCNImage(
                                      height: 150,
                                      width: 150,
                                      imageUrl: profile.mainProfileUrl,
                                      main: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  return Align(
                                    alignment: Alignment.bottomRight,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      color: primaryColor,
                                      child: state is ProfilePicUploading
                                          ? const CircularProgressIndicator()
                                          : IconButton(
                                              alignment: Alignment.center,
                                              icon: const Icon(
                                                Icons.photo_camera,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                final file =
                                                    await UploadMedia.getImage(
                                                        context: context,
                                                        checkType: 'profile');

                                                if (file == null) return;

                                                context.read<ProfileBloc>().add(
                                                    ProfilePicUpload(file));
                                              },
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    profile.parsedName,
                    style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .40,
                    child: Stack(
                      children: <Widget>[
                        const AddMediaBtn(),
                        SettingsBtn(
                          profile: profile,
                          isPurchased: isPurchased,
                          items: items,
                        ),
                        const EditInfoBtn(),
                        const Padding(
                          padding: EdgeInsets.only(top: 180),
                          child: SizedBox(
                            height: 120,
                            child: CustomPaint(
                              // painter: CurvePainter(),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CarouselSlider(
                          adds: adds,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomButton(
                      text: isPurchased
                          ? "Check Payment Details".tr().toString()
                          : "Subscribe Plan".tr().toString(),
                      onTap: () async {
                        if (isPurchased) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    PaymentDetails(purchases)),
                          );
                        } else {
                          // TODO: update with profile
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //       builder: (context) => Products(profile, null, widget.items)),
                          // );
                        }
                      },
                      color: textColor,
                      active: true)
                ]),
          ),
        ),
      ),
    );
  }
}
