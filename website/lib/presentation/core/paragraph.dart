import 'package:flutter/material.dart';

abstract class Paragraph extends StatelessWidget {
  const Paragraph(this.text, {Key? key}) : super(key: key);

  final String text;
  TextStyle? getTextStyle(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SelectableText(
        text,
        style: getTextStyle(context),
      ),
    );
  }
}

class ParagraphTitle extends Paragraph {
  const ParagraphTitle(String text, {Key? key}) : super(text, key: key);

  @override
  TextStyle? getTextStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineSmall!
      .copyWith(fontWeight: FontWeight.bold);
}

class ParagraphSubtitle extends Paragraph {
  const ParagraphSubtitle(String text, {Key? key}) : super(text, key: key);

  @override
  TextStyle? getTextStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .titleLarge!
      .copyWith(fontWeight: FontWeight.normal);
}

class ParagraphText extends Paragraph {
  const ParagraphText(String text, {Key? key}) : super(text, key: key);

  @override
  TextStyle? getTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.0);
}
