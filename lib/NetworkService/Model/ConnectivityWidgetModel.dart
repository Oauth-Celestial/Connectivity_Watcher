import 'package:flutter/material.dart';

/// widget : -  your no interenet widget if not passed default is set
/// backgroundColor :- change color of default no internet widget
/// displayImage : - change default icon to your image
/// titleStyle :- change deafult style of title
/// descriptionStyle :-  change default description style
class NoInternetWidget {
  Widget? widget;
  Color? backgroundColor;
  Widget? displayImage;
  TextStyle? titleStyle;
  TextStyle? descriptionStyle;

  NoInternetWidget(
      {this.widget,
      this.backgroundColor,
      this.displayImage,
      this.titleStyle,
      this.descriptionStyle});
}
