import '../provider/poster_provider.dart';
import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:admin/models/poster.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/widgets/category_image_card.dart';
import 'package:admin/widgets/custom_text_field.dart';

class PosterSubmitForm extends StatelessWidget {
  final Poster? poster;

  const PosterSubmitForm({super.key, this.poster});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.posterProvider.setDataForUpdatePoster(poster);
    return SingleChildScrollView(
      child: Form(
        key: context.posterProvider.addPosterFormKey,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(defaultPadding),
              Consumer<PosterProvider>(
                builder: (context, posterProvider, child) {
                  return CategoryImageCard(
                    labelText: "Poster",
                    imageFile: posterProvider.selectedImage,
                    imageUrlForUpdateImage: poster?.imageUrl,
                    onTap: () {
                      posterProvider.pickImage();
                    },
                  );
                },
              ),
              Gap(defaultPadding),
              CustomTextField(
                controller: context.posterProvider.posterNameCtrl,
                labelText: 'Poster Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a poster name';
                  }
                  return null;
                },
              ),
              Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: fnColor,
                      backgroundColor: cbColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: fnColor,
                      backgroundColor: sbColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.posterProvider.addPosterFormKey.currentState!.validate()) {
                        context.posterProvider.addPosterFormKey.currentState!.save();
                        context.posterProvider.submitPoster();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup
void showAddPosterForm(BuildContext context, Poster? poster) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(child: Text('Add Poster'.toUpperCase(), style: TextStyle(color: primaryColor))),
        content: PosterSubmitForm(poster: poster),
      );
    },
  );
}
