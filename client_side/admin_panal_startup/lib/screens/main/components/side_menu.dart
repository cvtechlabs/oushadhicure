import 'package:admin/utility/extensions.dart';
import 'package:admin/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "  Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Dashboard');
            },
          ),
          DrawerListTile(
            title: "  Category",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Category');
            },
          ),
          DrawerListTile(
            title: "  Sub Category",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('SubCategory');
            },
          ),
          DrawerListTile(
            title: "  Brands",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Brands');
            },
          ),
          DrawerListTile(
            title: "  Variant Type",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('VariantType');
            },
          ),
          DrawerListTile(
            title: "  Variants",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Variants');
            },
          ),
          DrawerListTile(
            title: "  Orders",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Order');
            },
          ),
          DrawerListTile(
            title: "  Coupons",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Coupon');
            },
          ),
          DrawerListTile(
            title: "  Posters",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Poster');
            },
          ),
          DrawerListTile(
            title: "  Notifications",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              context.mainScreenProvider.navigateToScreen('Notifications');
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 1.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(cbColor, BlendMode.srcIn),
        height: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: mnColor),
      ),
    );
  }
}
