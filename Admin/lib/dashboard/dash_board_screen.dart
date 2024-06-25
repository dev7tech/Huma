import 'package:flutter/material.dart';
import 'package:hookup4u_admin/subscription/subscription_settings.dart';
import 'package:hookup4u_admin/providers/selected_item_provider.dart';
import 'package:hookup4u_admin/report/reported_user_list.dart';
import 'package:hookup4u_admin/login/change_password.dart';
import 'package:hookup4u_admin/login/language_set_screen.dart';
import 'package:hookup4u_admin/users/users_list.dart';
import 'package:provider/provider.dart';
import '../subscription/package.dart';
import 'components/dashboard_content.dart';
import 'components/drawer_menu.dart';
import '../constants/constants.dart';
import '../constants/responsive.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: const DrawerMenu(fromAppbar: true),
      appBar: Responsive.isMobile(context) || Responsive.isTablet(context)
          ? AppBar(
              iconTheme: IconThemeData(color: primaryColor),
              elevation: 0,
              backgroundColor: bgColor.withOpacity(0.4),
            )
          : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: DrawerMenu(
                  fromAppbar: false,
                ),
              ),
            Expanded(
              flex: 5,
              child: _getSelectedContent(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _getSelectedContent(BuildContext context) {
    final selectedMenuItem =
        Provider.of<SelectedMenuItemProvider>(context).selectedMenuItem;

    Widget selectedContent;

    switch (selectedMenuItem) {
      case 'Users':
        selectedContent = const Users();
        break;
      case 'Packages':
        selectedContent = const Package();
        break;
      case 'Dash':
        selectedContent = const DashboardContent();
        break;
      case 'SubscriptionSettings':
        selectedContent = const SubscriptionSettings();
        break;

      case 'Changepassword':
        selectedContent = const ChangeIdPassword();
        break;
      case 'Reportuser':
        selectedContent = const ReportedUserList();
        break;
      case 'Settings':
        selectedContent = const SettingsPage();
        break;

      default:
        selectedContent = const DashboardContent();
    }

    return selectedContent;
  }
}
