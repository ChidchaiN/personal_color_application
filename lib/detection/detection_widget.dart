import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mini_project_your_color/color_for_compare/color_for_compare_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image/image.dart' as img; // Import the image package
import 'dart:convert';
import 'dart:math';

class DetectionWidget extends StatefulWidget {
  final String? imagePath; // Add a variable to hold the image path

  const DetectionWidget({super.key, this.imagePath});

  @override
  State<DetectionWidget> createState() => _DetectionWidgetState();
}

class _DetectionWidgetState extends State<DetectionWidget> {
  Color selectedColor = Colors.white;
  String matchedToneResult = "No match found";
  List<Map<String, int>> matchedToneColors = [];
  List<String> matchedTones = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Function to pick color using the Color Picker dialog
  void _pickColor(BuildContext context) async {
    Color? newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = selectedColor; // Temporary color variable
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                tempColor = color; // Update temporary color
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context)
                    .pop(tempColor); // Return the selected color
              },
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      setState(() {
        selectedColor = newColor; // Update the state with the selected color
      });
    }
  }

  Future<void> _getColorFromImage(TapDownDetails details) async {
    if (widget.imagePath == null) return;

    // Load the image
    final imageFile = File(widget.imagePath!);
    final bytes = await imageFile.readAsBytes();
    final img.Image image = img.decodeImage(bytes)!;

    // Calculate the position in the image where the user tapped
    final offset = details.localPosition;

    // Ensure the tap is within the bounds of the image
    if (offset.dx >= 0 &&
        offset.dy >= 0 &&
        offset.dx < image.width &&
        offset.dy < image.height) {
      // Get the pixel color at the tapped position
      final pixel = image.getPixel(offset.dx.toInt(), offset.dy.toInt());

      // Extract red, green, blue, and alpha components
      final int red = pixel.r.toInt();
      final int green = pixel.g.toInt();
      final int blue = pixel.b.toInt();

      setState(() {
        selectedColor =
            Color.fromARGB(255, red, green, blue); // Update the selected color
      });

      // Compare the detected color with stored tones and display the result
      List<String> matchedTones = await _compareWithStoredTones(selectedColor);
      setState(() {
        matchedTones = matchedTones;
      });
    } else {
      print('Tapped out of bounds: x=${offset.dx}, y=${offset.dy}');
    }
  }

// Function to check if two colors are within a tolerance range
// Function to calculate Euclidean distance between two colors
  double colorDistance(int r1, int g1, int b1, int r2, int g2, int b2) {
    return sqrt(pow((r1 - r2), 2) + pow((g1 - g2), 2) + pow((b1 - b2), 2));
  }

  Future<List<String>> _compareWithStoredTones(Color detectedColor) async {
    final String response =
        await DefaultAssetBundle.of(context).loadString('assets/tones.json');
    final Map<String, dynamic> tonesData = jsonDecode(response);

    List<dynamic> coolTones = tonesData['cool_tones'];
    List<dynamic> warmTones = tonesData['warm_tones'];

    int detectedR = detectedColor.red;
    int detectedG = detectedColor.green;
    int detectedB = detectedColor.blue;

    const double threshold = 100.0;
    List<Map<String, dynamic>> matches = [];

    // Compare with cool tones
    for (var tone in coolTones) {
      double distance = colorDistance(
          tone['r'], tone['g'], tone['b'], detectedR, detectedG, detectedB);
      if (distance <= threshold) {
        matches.add({
          "color": {"r": tone['r'], "g": tone['g'], "b": tone['b']},
          "tone": "Cool Tone",
          "distance": distance,
        });
      }
    }

    // If no match found in cool tones, check warm tones
    for (var tone in warmTones) {
      double distance = colorDistance(
          tone['r'], tone['g'], tone['b'], detectedR, detectedG, detectedB);
      if (distance <= threshold) {
        matches.add({
          "color": {"r": tone['r'], "g": tone['g'], "b": tone['b']},
          "tone": "Warm Tone",
          "distance": distance,
        });
      }
    }

    // Sort matches by distance
    matches.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Take the top 10 matches
    matchedToneColors = matches.take(10).map((match) {
      // Ensure the match has the required structure
      Map<String, dynamic> colorMap = match['color'];
      return {
        'r': colorMap['r'] as int,
        'g': colorMap['g'] as int,
        'b': colorMap['b'] as int,
      };
    }).toList();

    matchedTones =
        matches.take(10).map((match) => match['tone'] as String).toList();

    return matchedTones.isNotEmpty ? matchedTones : ["No match found"];
  }

  String rgbToHex(int r, int g, int b) {
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the captured image with gesture detection
              if (widget.imagePath != null)
                GestureDetector(
                  onTapDown:
                      _getColorFromImage, // Capture color from tapped position
                  child: Image.file(
                    File(widget.imagePath!),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your skin tone:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(
                width: 300.0,
                child: Divider(
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Your color containers
                  GestureDetector(
                    onTap: () => _pickColor(context), // Show color picker
                    child: Container(
                      width: 380.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: selectedColor, // Use selected color
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${rgbToHex(selectedColor.red, selectedColor.green, selectedColor.blue)}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.black, // Ensure text is visible
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Tone:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(
                width: 300.0,
                child: Divider(
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              // Displaying a scrollable list of color containers
              if (matchedToneColors
                  .isNotEmpty) // Check if there are any matched tones
                Expanded(
                  // Use Expanded to take up available space
                  child: SingleChildScrollView(
                    // Wrap with SingleChildScrollView
                    child: Column(
                      children:
                          List.generate(matchedToneColors.length, (index) {
                        final color = Color.fromRGBO(
                          matchedToneColors[index]['r'] ?? 0,
                          matchedToneColors[index]['g'] ?? 0,
                          matchedToneColors[index]['b'] ?? 0,
                          1,
                        );

                        return GestureDetector(
                          onTap: () {
                            // Navigate to ColorForCompareWidget with the selected color
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ColorForCompareWidget(color: color),
                              ),
                            );
                          },
                          child: Container(
                            width: 380,
                            height: 100,
                            margin: EdgeInsets.only(
                                bottom: 10), // Add margin between containers
                            decoration: BoxDecoration(
                              color: color, // Use color from matched tone
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${rgbToHex(matchedToneColors[index]['r'] ?? 0, matchedToneColors[index]['g'] ?? 0, matchedToneColors[index]['b'] ?? 0)}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Colors
                                            .black, // Ensure text is visible
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  matchedTones[
                                      index], // Show matched tone (Cool/Warm)
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              else // Fallback message if no colors matched
                Text(
                  'No colors matched.',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
