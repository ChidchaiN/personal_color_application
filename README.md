# Personal Color Styling App

## Overview

The Personal Color Styling App is a Flutter-based mobile application that allows users to analyze their skin tone using the smartphone camera and provides personalized color styling suggestions based on the detected tone.

## Features

- Image Capture: Capture images using the device's camera.
- Color Detection: Detect and analyze skin tone colors from the captured image.
- Color Matching: Compare detected colors with stored color tones (cool and warm) to suggest suitable color styles.
- User-Friendly Interface: Easy navigation and interaction with the app.

## Installation

To set up the project locally, follow these steps:

1. **Clone the Repository**:

2. **Install Flutter**:
Make sure you have Flutter installed on your machine. You can download it from [flutter.dev](https://flutter.dev/docs/get-started/install).

3. **Dependencies**:
Install the required dependencies:

4. **Run the Application**:
Connect your mobile device or start an emulator, and run the app:


## Core Methods

### 1. `_getColorFromImage(TapDownDetails details)`

This method captures the color from the image based on the user's tap position. It retrieves the pixel color at the tapped coordinates and updates the selected color.

### 2. `_compareWithStoredTones(Color detectedColor)`

This method compares the detected color with predefined cool and warm tones stored in a JSON file. It calculates the Euclidean distance between the colors to find matches.

### 3. `colorDistance(int r1, int g1, int b1, int r2, int g2, int b2)`

This utility function calculates the distance between two colors using the Euclidean distance formula.

### 4. `_pickColor(BuildContext context)`

This method opens a color picker dialog allowing users to select a color manually. The selected color is then displayed in the app.

## Image Section

![1727459898624](https://github.com/user-attachments/assets/555dd482-1fba-4aeb-9e96-9b9f5c820cb0)

![1727459898615](https://github.com/user-attachments/assets/ebdf76f6-17c3-4e75-9217-dc85b4dc640d)

![1727459898607](https://github.com/user-attachments/assets/04bba715-0804-421e-9207-3257f1a95b99)

![1727459898598](https://github.com/user-attachments/assets/2f7e0ce4-d273-4c0a-82b7-282b7f88fc1d)

### Example of Image Processing
The following snippet illustrates how the image is processed to extract color information:

```dart
// Load the image
final imageFile = File(widget.imagePath!);
final bytes = await imageFile.readAsBytes();
final img.Image image = img.decodeImage(bytes)!;

// Calculate the position in the image where the user tapped
final offset = details.localPosition;
```

## Assets

-   **Tones JSON File**: Ensure you have a `tones.json` file in the `assets` directory containing the color tones to compare against.

## Contribution

Feel free to contribute by creating issues or submitting pull requests.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.


You can copy and paste this into your README.md file. Feel free to modify any sections as necessary!
