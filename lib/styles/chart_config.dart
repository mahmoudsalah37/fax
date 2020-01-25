import 'package:charts_flutter/flutter.dart';

class ChartConfig {
  var config = LayoutConfig(
      bottomMarginSpec: MarginSpec.fixedPixel(100),
      leftMarginSpec: MarginSpec.defaultSpec,
      rightMarginSpec: MarginSpec.defaultSpec,
      topMarginSpec: MarginSpec.fixedPixel(100));

  LayoutConfig get layoutConfig => config;
}
