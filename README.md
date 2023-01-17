<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Provides you a textfield and accompanying controller that users can visually type separated lists into, such as a list of email recipients. 

## Features
- Textfield that creates a list as you type
- Handy controller than can be used with other text fields for more customisation.
- Remove from list with normal backspace. 

## Getting started

Add the package to your project pubspec.yaml
```yaml 
    listtextfield: any
```

Import the package in the project file 
```dart
    import "package:listtextfield/listtextfield.dart";
```

## Usage
Create a `ListTextEditingController` with the list separator users should type. 
```dart
 final _controller = ListTextEditingController(',');
```

You may also initialise your controller with some items in the list, by providing the optional set of strings. 
```dart
 final _controller = ListTextEditingController(',', {'InitialItem1', 'InitialItem2',});
```

Add a `ListTextField` widget to your widget tree and supply the controller
```dart
 Widget build(BuildContext context){
    return Column(
        children: [
            ListTextField(
                controller: _controller, 
                itemBuilder: (ctx, item){
                    // Build how items in the list should appear
                    return Chip(
                    label: Text(value),
                    onDeleted: () => _controller.removeItem(value),
                    );
                }
            ),
        ],
    );
 }
```

You can access the typed list by calling `items` on the controller
```dart
    final myItems = _controller.items; 
```

See example for more information
## Additional information
PRs are welcome.
Find an issue? Report it. 

MajorE 👽♦️