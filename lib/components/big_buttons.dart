import 'package:cached_network_image/cached_network_image.dart';
import 'package:dadtv/helpers/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class BigButton extends StatelessWidget {
  final String text;
  final String url;
  final String? imgUrl;

  const BigButton(
      {super.key, required this.text, required this.url, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => handlePress(context),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.redAccent,
      textColor: Colors.black,
      focusColor: Colors.amber,
      child: Center(
        child: imgUrl != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    imgUrl!.contains('svg')
                        ? SvgPicture.network(imgUrl!)
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: imgUrl!,
                            ),
                          ),
                    Text(
                      text,
                      style: GoogleFonts.robotoCondensed().copyWith(
                        color: Colors.white,
                          fontSize: ResponsiveSizer.of(context).fontSize(2)),
                    )
                  ],
                ),
              )
            : Text(
                text,
                style: GoogleFonts.robotoCondensed().copyWith(
                    fontSize: ResponsiveSizer.of(context).fontSize(4)),
              ),
      ),
    );
  }

  handlePress(context) {
    GoRouter.of(context).go('/play', extra: {'url': url});
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key, required this.onPressed, required this.btnText});
  final Function() onPressed;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width / 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawKeyboardListener(
          focusNode: FocusNode(skipTraversal: true),
          onKey: (key) {
            if (key.runtimeType == RawKeyUpEvent) {
              if (key.logicalKey == LogicalKeyboardKey.select) {
                onPressed();
              }
            }
          },
          child: MaterialButton(
            focusColor: Colors.amber,
            color: Colors.red.shade100,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () => onPressed(),
            child: Text(btnText),
          ),
        ),
      ),
    );
  }
}
