import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'package:provider/provider.dart';
import 'components/add_category_form.dart';
import 'components/category_header.dart';
import 'components/category_list_section.dart';
import '../../core/data/data_provider.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                      //width: double.infinity,
                      //padding: EdgeInsets.all(defaultPadding),
                    height: 60,
                      decoration: BoxDecoration(
                        color: drawerColor,
                        borderRadius: const BorderRadius.all(Radius.circular(0)),
                      ),
                      child: CategoryHeader()),
 //                 SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {
                            //         context.read<DataProvider>().getAllCategory(showSnack: true);
                            //       },
                            //       icon: Icon(
                            //         Icons.refresh,
                            //         color: fnColor,
                            //       ),
                            //     ),
                            //     Gap(20),
                            //     ElevatedButton.icon(
                            //       style: TextButton.styleFrom(
                            //         backgroundColor: sbColor,
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: defaultPadding * 1.5,
                            //           vertical: defaultPadding,
                            //         ),
                            //       ),
                            //       onPressed: () {
                            //         showAddCategoryForm(context, null);
                            //       },
                            //       icon: Icon(
                            //         Icons.add,
                            //         color: fnColor,
                            //       ),
                            //       label: Text(
                            //         "Add New",
                            //         style: TextStyle(color: fnColor),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            Gap(defaultPadding),
                            SizedBox(
                              height: constraints.maxHeight - 75, // Subtracting space for header and buttons
                              width: constraints.maxWidth,
                              child: CategoryListSection(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}
