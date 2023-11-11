import 'package:flutter/material.dart';
class NoInternetWidget {
  /// widget : -  your no interenet widget if not passed default is set
  Widget? widget;

  /// backgroundColor :- change color of default no internet widget
  Color? backgroundColor;

  /// displayImage : - change default icon to your image
  Widget? displayImage;

  /// titleStyle :- change deafult style of title
  TextStyle? titleStyle;

  /// descriptionStyle :-  change default description style
  TextStyle? descriptionStyle;

  NoInternetWidget(
      {this.widget,
      this.backgroundColor,
      this.displayImage,
      this.titleStyle,
      this.descriptionStyle});
}
