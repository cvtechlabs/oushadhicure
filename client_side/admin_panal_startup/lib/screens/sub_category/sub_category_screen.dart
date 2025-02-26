import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'package:provider/provider.dart';
import 'components/add_sub_category_form.dart';
import 'components/sub_category_header.dart';
import 'components/sub_category_list_section.dart';
import '../../core/data/data_provider.dart';

class SubCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: SafeArea(
        child: Column(
          children: [
            SubCategoryHeader(),
            Gap(defaultPadding),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Expanded(
                            //   child: Text(
                            //     "My Sub Categories",
                            //     style: Theme.of(context).textTheme.titleMedium,
                            //   ),
                            // ),
                            IconButton(
                                onPressed: () {
                                  context.read<DataProvider>().getAllSubCategory(showSnack: true);
                                },
                                icon: Icon(Icons.refresh)),
                            Gap(20),
                            ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor : sbColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding * 1.5,
                                  vertical: defaultPadding,
                                ),
                              ),
                              onPressed: () {
                                showAddSubCategoryForm(context, null);
                              },
                              icon: Icon(Icons.add),
                              label: Text("Add New"),
                            ),
                          ],
                        ),
                        Gap(defaultPadding),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SubCategoryListSection(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}