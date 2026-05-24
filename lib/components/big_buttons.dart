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
  final Color? color;
  final Function()? onPressed;

  const BigButton({
    super.key,
    required this.text,
    required this.url,
    this.imgUrl,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => {
        if (onPressed != null) {onPressed!()!} else {handlePress(context)},
      },
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: color ?? Colors.redAccent,
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(imageUrl: imgUrl!),
                          ),
                    Text(
                      text,
                      style: 
                      GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: text.length < 10
                            ? ResponsiveSizer.of(context).fontSize(2)
                            : ResponsiveSizer.of(context).fontSize(0.5),
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: ResponsiveSizer.of(context).fontSize(4),
                ),
              ),
      ),
    );
  }

  void handlePress(context) {
    GoRouter.of(context).push('/play', extra: {'url': url});
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.btnText,
  });
  final Function() onPressed;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return SizedBox(
      height: buttonHeight(context, isLandscape),
      width: buttonWidth(context, isLandscape),
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
          // child: BigButton(text: btnText, url: url)
          child: MaterialButton(
            focusColor: Colors.amber,
            color: Colors.red.shade100,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () => onPressed(),
            child: Text(btnText),
          ),
        ),
      ),
    );
  }
}

class UiNavButton extends StatelessWidget {
  final String url;
  final String text;
  final Color? color;

  const UiNavButton({
    super.key,
    required this.url,
    required this.text,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;

    return SizedBox(
      height: buttonHeight(context, isLandscape),
      width: buttonHeight(context, isLandscape),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: KeyboardListener(
          onKeyEvent: (key) {
            if (key.runtimeType == RawKeyUpEvent) {
              if (key.logicalKey == LogicalKeyboardKey.select) {
                GoRouter.of(context).push(url);
              }
            }
          },
          focusNode: FocusNode(skipTraversal: true),
          child: BigButton(
            url:url,
            onPressed: () => GoRouter.of(context).push(url),
            text: text,
            color: color,
          ),
        ),
      ),
    );
  }
}
