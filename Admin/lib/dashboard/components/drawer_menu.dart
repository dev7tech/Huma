// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u_admin/login/login.dart';
import 'package:provider/provider.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../constants/constants.dart';
import '../../constants/custom_dailog.dart';
import '../../providers/selected_item_provider.dart';
import 'drawer_list_tile.dart';

class DrawerMenu extends StatelessWidget {
  final bool fromAppbar;
  const DrawerMenu({Key? key, required this.fromAppbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          // Navigate to the sign in screen when the user Signs Out
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Drawer(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(appPadding),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/hookup4u-Logo-BP.png",
                    height: 70,
                    width: 70,
                  ),
                  Text(
                    "Hookup4u Admin",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            DrawerListTile(
                title: 'Dash Board',
                icon: Icons.dashboard_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'Dash',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Dash');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            DrawerListTile(
                title: 'Users',
                icon: Icons.group_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'Users',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Users');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            DrawerListTile(
                title: 'Packages',
                icon: Icons.format_list_bulleted_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'Packages',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Packages');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            DrawerListTile(
                title: 'Subscription Settings',
                icon: Icons.settings_suggest_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'SubscriptionSettings',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('SubscriptionSettings');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            DrawerListTile(
                title: 'Change Password',
                icon: Icons.lock_open_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'Changepassword',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Changepassword');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            DrawerListTile(
                title: 'Reported User',
                icon: Icons.flag_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'Reportuser',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Reportuser');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
              child: Divider(
                color: Colors.black26,
                thickness: 0.1,
              ),
            ),
            DrawerListTile(
                title: 'Settings',
                icon: Icons.settings_outlined,
                isSelected: Provider.of<SelectedMenuItemProvider>(context)
                        .selectedMenuItem ==
                    'Settings',
                tap: () {
                  Provider.of<SelectedMenuItemProvider>(context, listen: false)
                      .setSelectedMenuItem('Settings');
                  if (fromAppbar) {
                    Navigator.pop(context);
                  }
                }),
            DrawerListTile(
                title: 'Logout',
                icon: Icons.logout_outlined,
                isSelected: false,
                tap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlertDialog(
                          text: 'Are you sure you want to logout?',
                          onYesTap: () async {
                            // Signing out the user
                            context.read<AuthBloc>().add(SignOutRequested());
                            Provider.of<SelectedMenuItemProvider>(context,
                                    listen: false)
                                .setSelectedMenuItem('Dash');
                          },
                          onNoTap: () => Navigator.pop(context));
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
