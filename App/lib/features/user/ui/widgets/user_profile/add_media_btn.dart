import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/constants/colors.dart';
import 'package:hookup4u2/common/utils/upload_media.dart';
import 'package:hookup4u2/features/user/profile/bloc/profile_bloc.dart';

class AddMediaBtn extends StatelessWidget {
  const AddMediaBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((ProfileBloc bloc) => bloc.state);

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                splashColor: secondaryColor,
                backgroundColor: primaryColor,
                onPressed: state is ProfileMediaUploading
                    ? null
                    : () async {
                        final file = await UploadMedia.getImage(
                            context: context, checkType: 'addMedia');

                        if (file == null) return;

                        context
                            .read<ProfileBloc>()
                            .add(ProfileMediaUpload(file));
                      },
                child: state is ProfileMediaUploading
                    ? const CircularProgressIndicator()
                    : const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 32,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Add media".tr().toString(),
                style: TextStyle(color: secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
