//color_for_compare_widget.dart

import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class ColorForCompareWidget extends StatefulWidget {
  final Color? color; // Make this parameter nullable

  const ColorForCompareWidget({super.key, this.color}); // Optional parameter

  @override
  State<ColorForCompareWidget> createState() => _ColorForCompareWidgetState();
}

class _ColorForCompareWidgetState extends State<ColorForCompareWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the color through the widget property
    final displayColor = widget.color ?? Colors.transparent; // Use widget.color
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              color: displayColor,
            ),
          ),
        ),
      ),
    );
  }
}
