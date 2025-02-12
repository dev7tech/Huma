import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/home/bloc/search_user_bloc.dart';
import 'package:hookup4u2/features/user/user.dart';
import '../../../../common/constants/colors.dart';

class MatchedPage extends StatefulWidget {
  final String name;
  final Profile currentUser;

  const MatchedPage({super.key, required this.name, required this.currentUser});

  @override
  MAtchState createState() => MAtchState();
}

class MAtchState extends State<MatchedPage> {
  AssetImage? image;

  @override
  void initState() {
    image = const AssetImage('asset/connected3.gif');
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      // TODO: Update to profile
      context
          .read<SearchUserBloc>()
          .add(LoadUserEvent(currentUser: widget.currentUser));
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: Theme.of(context).primaryColor,
            elevation: 0,
            child: Text(
              "It's a match\n With ${widget.name} ".tr().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none),
            ),
          ),
          Center(
              child: Image.asset(
            image!.assetName,
          )),
        ],
      ),
    );
  }
}
