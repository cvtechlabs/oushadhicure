import 'dart:io';
import 'package:admin/utility/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductImageCard extends StatelessWidget {
  final String labelText;
  final String? imageUrlForUpdateImage;
  final File? imageFile;
  final VoidCallback onTap;
  final VoidCallback? onRemoveImage;

  const ProductImageCard({
    Key? key,
    required this.labelText,
    this.imageFile,
    required this.onTap,
    this.imageUrlForUpdateImage,
    this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          child: Container(
            height: 130,
            width: size.width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(bRadius),
              color: secondaryColor,
            ),
            child: GestureDetector(
              onTap: onTap,
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
                        fit: BoxFit.scaleDown,
                      )
                          : Image.file(
                        imageFile!,
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  else if (imageUrlForUpdateImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(bRadius),
                      child: Image.network(
                        imageUrlForUpdateImage ?? '',
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  else
                    Icon(Icons.camera_alt, size: 50, color: bgColor),
                  SizedBox(height: 8),
                  Text(
                    labelText,
                    style: TextStyle(
                      fontSize: 14,
                      color: bgColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if ( imageFile != null && onRemoveImage != null)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close,color: Colors.red,),
              onPressed: onRemoveImage,
            ),
          ),
      ],
    );
  }
}
