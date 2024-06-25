import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/widets/custom_snackbar.dart';
import 'package:hookup4u2/common/widets/hookup_circularbar.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:hookup4u2/features/user/profile/bloc/profile_bloc.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_cubit.dart';
import 'package:hookup4u2/features/user/ui/widgets/profile_setup_success_dialog.dart';

// ignore: depend_on_referenced_packages
import '../../../../common/constants/colors.dart';
import '../../../../common/utils/upload_media.dart';
import '../../../../common/widets/custom_button.dart';

class UserProfilePic extends StatefulWidget {
  const UserProfilePic({super.key});

  @override
  State<UserProfilePic> createState() => _UserProfilePicState();
}

class _UserProfilePicState extends State<UserProfilePic> {
  String? imgUrl = '';

  File? changeImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.showSnackBarSimple(state.message, context);
          }
          if (state is ProfilePicUploaded) {
            final cubitState = context.read<ProfileCubit>().state;
            context.read<ProfileBloc>().add(
                  ProfileUpdate(ProfileDto(
                    userName: cubitState.userName,
                    userDob: cubitState.userDob,
                    showMe: cubitState.showMe,
                    profileUrl: state.imageUrl,
                  )),
                );
          }
          if (state is ProfileUpdated) {
            Future.delayed(const Duration(seconds: 2), () {
              context.read<RegistrationBloc>().add(
                    AlreadyRegistered(profile: state.profile),
                  );
            });

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return const ProfileSetupSuccessDialog();
                });
          }
        },
        builder: (context, state) {
          final isLoading =
              state is ProfilePicUploading || state is ProfileUploading;

          return BlocBuilder<ProfileCubit, ProfileDto>(
            builder: (context, state) {
              final cubitState = state;
              if (isLoading) {
                return const Center(
                  child: Hookup4uBar(),
                );
              }

              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 50, top: 120),
                            child: Text(
                              "Add your Image".tr().toString(),
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          alignment: Alignment.center,
                          child: Container(
                              width: 250,
                              height: 250,
                              margin: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: changeImageFile == null
                                  ? IconButton(
                                      color: primaryColor,
                                      iconSize: 60,
                                      icon: const Icon(Icons.add_a_photo),
                                      onPressed: () async {
                                        final file = await UploadMedia.getImage(
                                            context: context,
                                            checkType: 'profile');
                                        if (file != null) {
                                          if (mounted) {
                                            setState(() {
                                              changeImageFile = file;
                                            });
                                          }
                                        }
                                      },
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.file(
                                        File(changeImageFile!.path),
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.fill,
                                      ))),
                        ),
                      ),
                      changeImageFile != null
                          ? CustomButton(
                              active: true,
                              color: textColor,
                              onTap: () async {
                                final file = await UploadMedia.getImage(
                                    context: context, checkType: 'profile');
                                if (file != null) {
                                  if (mounted) {
                                    setState(() {
                                      changeImageFile = file;
                                    });
                                  }
                                }
                              },
                              text: "CHANGE IMAGE".tr().toString(),
                            )
                          : const SizedBox.shrink(),
                      CustomButton(
                        active: true,
                        color: textColor,
                        onTap: () async {
                          if (changeImageFile != null) {
                            context
                                .read<ProfileBloc>()
                                .add(ProfilePicUpload(changeImageFile!));
                          } else {
                            context.read<ProfileBloc>().add(
                                  ProfileUpdate(ProfileDto(
                                    userName: cubitState.userName,
                                    userDob: cubitState.userDob,
                                    showMe: cubitState.showMe,
                                    profileUrl: null,
                                  )),
                                );
                          }
                        },
                        text: 'CONTINUE'.tr().toString(),
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
}
