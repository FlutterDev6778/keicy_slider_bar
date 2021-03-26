library keicy_slider_bar;

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:clip_shadow/clip_shadow.dart';

class KeicySlideBar extends StatelessWidget {
  KeicySlideBar({
    Key key,
    @required this.width,
    this.min = 0,
    this.max = 100,
    this.values = const [50],
    this.handlerWidth,
    this.handlerHeight,
    this.handlerWidget = const Icon(Icons.chevron_right, size: 25),
    this.rightHandlerWidget = const Icon(Icons.chevron_left, size: 25),
    this.inactiveTrackBarHeight = 3,
    this.activeTrackBarHeight = 3,
    this.inactiveDisabledTrackBarColor = Colors.grey,
    this.activeDisabledTrackBarColor = Colors.blue,
    this.trackBarBorderRadius = 0,
    this.inActiveTrackBarBorderColor = Colors.grey,
    this.activeTrackBarBorderColor = Colors.transparent,
    this.activeTrackBarDraggable = true,
    this.disabled = false,
    this.tooltipDisabled = false,
    this.alwaysShowTooltip = false,
    this.tooltipTextStyle = const TextStyle(fontSize: 17, color: Colors.white),
    this.tooltipBorderRadius = 10,
    this.tooltipColor = Colors.blue,
    this.tooltipBoxShadow = const BoxShadow(
      color: Colors.grey,
      blurRadius: 2,
      spreadRadius: 0,
      offset: Offset(2, 2),
    ),
    this.leftPrefix,
    this.rightSuffix,
    this.tooltipFormat,
    this.tooltipDirection = FlutterSliderTooltipDirection.top,
    this.tooltipPositionOffset = -10,
    this.selectByTap = true,
    this.onDragCompleted,
    this.minimumDistance = 1,
    this.maximumDistance = 0,
    this.enableCenterTooltip = false,
    this.rtl = false,
  }) : super(key: key);
  final double width;
  final double min;
  final double max;
  List<double> values;
  final double handlerWidth;
  final double handlerHeight;
  final Widget handlerWidget;
  final Widget rightHandlerWidget;
  final double inactiveTrackBarHeight;
  final double activeTrackBarHeight;
  final Color inactiveDisabledTrackBarColor;
  final Color activeDisabledTrackBarColor;
  final bool activeTrackBarDraggable;
  final double trackBarBorderRadius;
  final Color inActiveTrackBarBorderColor;
  final Color activeTrackBarBorderColor;
  final bool disabled;
  final bool tooltipDisabled;
  final bool alwaysShowTooltip;
  final TextStyle tooltipTextStyle;
  final double tooltipBorderRadius;
  final Color tooltipColor;
  final BoxShadow tooltipBoxShadow;
  final Widget leftPrefix;
  final Widget rightSuffix;
  final Function(String) tooltipFormat;
  final dynamic tooltipDirection;
  final double tooltipPositionOffset;
  final bool selectByTap;
  final double minimumDistance;
  final double maximumDistance;
  final Function onDragCompleted;
  final bool enableCenterTooltip;
  final bool rtl;

  GlobalKey _sliderGlobalKey = GlobalKey();
  GlobalKey _centerGlobalKey = GlobalKey();
  void moveCenterTooltip(
      BuildContext context, KeicySlideBarProvider KeicySlideBarProvider, CenterTooltipPositionProvider centerTooltipPositionProvider) {
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (context == null) return;
      try {
        RenderBox sliderRenderBox = _sliderGlobalKey.currentContext.findRenderObject();
        RenderBox centerRenderBox = _centerGlobalKey.currentContext.findRenderObject();
        double range = sliderRenderBox.size.width - centerRenderBox.size.width;
        double position = 0;
        if (KeicySlideBarProvider.values.length == 1) {
          position = KeicySlideBarProvider.values[0] / (max - min);
        } else {
          position = (KeicySlideBarProvider.values[0] - min + (KeicySlideBarProvider.values[1] - KeicySlideBarProvider.values[0]) / 2) / (max - min);
        }
        if (position > 1)
          position = 1;
        else if (position < 0) position = 0;
        centerTooltipPositionProvider.setPositionX(position * range);
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeicySlideBarProvider(values)),
        ChangeNotifierProvider(create: (_) => CenterTooltipPositionProvider()),
      ],
      child: Consumer<KeicySlideBarProvider>(builder: (context, keicySlideBarProvider, _) {
        return Container(
          width: width,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              (enableCenterTooltip)
                  ? Consumer<CenterTooltipPositionProvider>(
                      builder: (context, centerTooltipPositionProvider, _) {
                        moveCenterTooltip(context, keicySlideBarProvider, centerTooltipPositionProvider);
                        EdgeInsetsGeometry padding;
                        if (centerTooltipPositionProvider.positionX != null && rtl) {
                          padding = EdgeInsets.only(right: centerTooltipPositionProvider.positionX);
                        } else if (centerTooltipPositionProvider.positionX != null && !rtl) {
                          padding = EdgeInsets.only(left: centerTooltipPositionProvider.positionX);
                        }
                        return Container(
                          padding: padding,
                          alignment: (rtl) ? Alignment.centerRight : Alignment.centerLeft,
                          child: Column(
                            key: _centerGlobalKey,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(tooltipBorderRadius),
                                  color: tooltipColor,
                                  boxShadow: [tooltipBoxShadow],
                                ),
                                child: (tooltipFormat != null)
                                    ? (keicySlideBarProvider.values.length == 2)
                                        ? Text(
                                            "${(tooltipFormat(keicySlideBarProvider.values[0].toString())).toString()} - ${(tooltipFormat(keicySlideBarProvider.values[1].toString())).toString()}",
                                            style: tooltipTextStyle,
                                          )
                                        : Text(
                                            "${(tooltipFormat(keicySlideBarProvider.values[0].toString())).toString()}",
                                            style: tooltipTextStyle,
                                          )
                                    : (keicySlideBarProvider.values.length == 2)
                                        ? Text(
                                            "${keicySlideBarProvider.values[0].toString()} - ${keicySlideBarProvider.values[1].toString()}",
                                            style: tooltipTextStyle,
                                          )
                                        : Text(
                                            "${keicySlideBarProvider.values[0].toString()}",
                                            style: tooltipTextStyle,
                                          ),
                              ),
                              Container(
                                child: ClipShadow(
                                  boxShadow: [tooltipBoxShadow],
                                  clipper: CustomTriangleClipper(),
                                  child: ClipPath(
                                    clipper: CustomTriangleClipper(),
                                    child: Container(
                                      width: 18,
                                      height: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : SizedBox(),
              FlutterSlider(
                key: _sliderGlobalKey,
                values: keicySlideBarProvider.values,
                rangeSlider: (keicySlideBarProvider.values.length == 2) ? true : false,
                rtl: rtl,
                max: max,
                min: min,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  keicySlideBarProvider.setValues([lowerValue, upperValue]);
                },
                disabled: disabled,
                onDragCompleted: onDragCompleted,
                handlerWidth: handlerWidth,
                handlerHeight: handlerHeight,
                handler: FlutterSliderHandler(child: handlerWidget),
                rightHandler: FlutterSliderHandler(child: rightHandlerWidget),
                selectByTap: selectByTap,
                minimumDistance: minimumDistance,
                maximumDistance: maximumDistance,
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBarHeight: inactiveTrackBarHeight,
                  activeTrackBarHeight: activeTrackBarHeight,
                  inactiveDisabledTrackBarColor: inactiveDisabledTrackBarColor,
                  activeDisabledTrackBarColor: activeDisabledTrackBarColor,
                  activeTrackBarDraggable: activeTrackBarDraggable,
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(trackBarBorderRadius),
                    color: inactiveDisabledTrackBarColor,
                    border: Border.all(width: 1, color: inActiveTrackBarBorderColor),
                  ),
                  activeTrackBar: BoxDecoration(
                    color: activeDisabledTrackBarColor,
                    borderRadius: BorderRadius.circular(trackBarBorderRadius),
                    border: Border.all(width: 1, color: activeTrackBarBorderColor),
                  ),
                ),
                tooltip: FlutterSliderTooltip(
                  disabled: tooltipDisabled,
                  alwaysShowTooltip: alwaysShowTooltip,
                  textStyle: tooltipTextStyle,
                  boxStyle: FlutterSliderTooltipBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(tooltipBorderRadius),
                      color: tooltipColor,
                      boxShadow: [tooltipBoxShadow],
                    ),
                  ),
                  leftPrefix: leftPrefix,
                  rightSuffix: rightSuffix,
                  format: tooltipFormat,
                  direction: tooltipDirection,
                  positionOffset: FlutterSliderTooltipPositionOffset(top: tooltipPositionOffset),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class KeicySlideBarProvider extends ChangeNotifier {
  static KeicySlideBarProvider of(BuildContext context, {bool listen = false}) => Provider.of<KeicySlideBarProvider>(context, listen: listen);
  KeicySlideBarProvider(this._values);

  List<double> _values;
  List<double> get values => _values;
  void setValues(List<double> values) {
    if (_values.length == 1) {
      _values = [values[0]];
    } else {
      _values = values;
    }
    notifyListeners();
  }
}

class CenterTooltipPositionProvider extends ChangeNotifier {
  static CenterTooltipPositionProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<CenterTooltipPositionProvider>(context, listen: listen);
  double _positionX;
  double get positionX => _positionX;
  void setPositionX(double positionX) {
    if (_positionX != positionX) {
      _positionX = positionX;
      notifyListeners();
    }
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
