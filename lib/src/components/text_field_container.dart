import 'package:Shrine/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final num percentOfWidth;
  final num borderWidth;

  const TextFieldContainer({
    Key key,
    this.child,
    this.percentOfWidth = 0.7,
    this.borderWidth = 3.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final kInnerDecoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(32),
    );

    final kGradientBoxDecoration = BoxDecoration(
      gradient: LinearGradient(colors: [kSecondaryLightColor, kPrimaryDarkColor]),
      borderRadius: BorderRadius.circular(32),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: size.width * percentOfWidth,
        decoration: kInnerDecoration,
        child: child,
      ),
      decoration: kGradientBoxDecoration,
    );
  }
}


class DoubleRoundTextField extends StatelessWidget {
  final String text1;
  final String text2;
  final num height1;
  final num height2;

  const DoubleRoundTextField({
    Key key,
    this.text1,
    this.text2, this.height1 = 10.0, this.height2 = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFieldContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height1),
            child: Text(
              text1,
              textAlign: TextAlign.center,
            ),
          ),
          percentOfWidth: 0.42,
          borderWidth: 2.0,
        ),
        SizedBox(
          width: 18,
        ),
        TextFieldContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height2),
            child: Text(
              text2,
              textAlign: TextAlign.center,
            ),
          ),
          percentOfWidth: 0.42,
          borderWidth: 2.0,
        ),
      ],
    );
  }
}
