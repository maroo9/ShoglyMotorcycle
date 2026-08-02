import 'package:flutter/material.dart';

class RaisedEndFloatLocation extends FloatingActionButtonLocation {
  const RaisedEndFloatLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        scaffoldGeometry.minInsets.bottom -
        96;

    return Offset(fabX, fabY);
  }
}