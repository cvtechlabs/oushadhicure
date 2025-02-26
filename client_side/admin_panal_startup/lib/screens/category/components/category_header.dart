import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/core/data/data_provider.dart';
import 'package:provider/provider.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tHeight, // Set the height
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Category Master",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: h1Color, // Text color set to red
              ),
            ),
          ),
          Spacer(flex: 2),
          // Expanded(
          //   child: SearchField(
          //     onChange: (val) {
          //       context.read<DataProvider>().filterCategories(val);
          //       //context.dataProvider.filterCategories(val);
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ProfileCard(),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 30
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text(
              "Satheesh",
              style: TextStyle(color: tlColor), // Text color set to red
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: tlColor, // Icon color set to red
          ),
        ],
      ),
    );
  }
}

// class SearchField extends StatelessWidget {
//   final Function(String) onChange;
//
//   const SearchField({
//     Key? key,
//     required this.onChange,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       style: TextStyle(color: fnColor), // Text color set to red
//       decoration: InputDecoration(
//         hintText: "Search",
//         hintStyle: TextStyle(color: fnColor), // Hint text color set to red
//         fillColor: secondaryColor,
//         filled: true,
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: const BorderRadius.all(Radius.circular(bRadius)),
//         ),
//         suffixIcon: InkWell(
//           onTap: () {},
//           child: Container(
//             padding: EdgeInsets.all(defaultPadding),
//             margin: EdgeInsets.symmetric(horizontal: defaultPadding),
//             decoration: BoxDecoration(
//               color: primaryColor,
//               borderRadius: const BorderRadius.all(Radius.circular(bRadius)),
//             ),
//             child: SvgPicture.asset(
//               "assets/icons/Search.svg",
//               color: fnColor, // SVG picture color set to red
//             ),
//           ),
//         ),
//       ),
//       onChanged: (value) {
//         onChange(value);
//       },
//     );
//   }
// }
