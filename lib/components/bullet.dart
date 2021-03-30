import 'package:flutter/material.dart';

class Bullet extends StatelessWidget {
  const Bullet(
    this.data, {
    Key key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : super(key: key);

  final String data;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Bullet circle.
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),

        SizedBox(width: 7),

        // Bullet text
        Text(
          data,
          key: key,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        )
      ],
    );
  }
}

// class Bullet extends Text {
//   const Bullet(
//     String data, {
//     Key key,
//     TextStyle style,
//     TextAlign textAlign,
//     TextDirection textDirection,
//     Locale locale,
//     bool softWrap,
//     TextOverflow overflow,
//     double textScaleFactor,
//     int maxLines,
//     String semanticsLabel,
//   }) : super(
//           ' \u2022 ${data}',
//           key: key,
//           style: style,
//           textAlign: textAlign,
//           textDirection: textDirection,
//           locale: locale,
//           softWrap: softWrap,
//           overflow: overflow,
//           textScaleFactor: textScaleFactor,
//           maxLines: maxLines,
//           semanticsLabel: semanticsLabel,
//         );
// }
