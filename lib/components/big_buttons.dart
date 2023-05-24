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
    return RawKeyboardListener(
        onKey: (keyEvent) {
          if (keyEvent.runtimeType == RawKeyUpEvent &&
              keyEvent.logicalKey == LogicalKeyboardKey.select) {
            handlePress(context);
          }
        },
        focusNode: FocusNode(),
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textColor: Colors.black,
          focusColor: Colors.amber,
          color: Colors.redAccent,
          onPressed: () => handlePress(context),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: imgUrl != null
                ? SvgPicture.network(imgUrl!)
                : Text(
                    text,
                    style: GoogleFonts.robotoCondensed().copyWith(
                        fontSize: ResponsiveSizer.of(context).fontSize(6)),
                  ),
          ),
        ));
  }

  handlePress(context) {
    GoRouter.of(context).go('/play', extra: {'url': url});
  }
}
