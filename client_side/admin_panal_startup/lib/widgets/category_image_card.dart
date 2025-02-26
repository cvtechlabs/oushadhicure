import 'dart:io';
import 'package:admin/utility/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryImageCard extends StatelessWidget {
  final String labelText;
  final String? imageUrlForUpdateImage;
  final File? imageFile;
  final VoidCallback onTap;

  const CategoryImageCard({
    super.key,
    required this.labelText,
    this.imageFile,
    required this.onTap,
    this.imageUrlForUpdateImage,
  });

  @override
  Widget build(BuildContext context) {
    print(imageFile);
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 130,
          width: size.width * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ibRadius),
            color: secondaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(bRadius),
                  child: kIsWeb
                      ? Image.network(
                          imageFile?.path ?? '',
                          width: double.infinity,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          imageFile!,
                          width: double.infinity,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                )
              else if ( imageUrlForUpdateImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(bRadius),
                  child: Image.network(
                    imageUrlForUpdateImage ?? '',
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                )
              else
                Icon(Icons.camera_alt, size: 50, color: tlColor),
              SizedBox(height: 8),
              Text(
                labelText,
                style: TextStyle(
                  fontSize: 14,
                  color: tlColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
