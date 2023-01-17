import 'package:flutter/material.dart';
import 'package:listtextfield/listtextfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ListTextField Demo',
      home: ListTextFieldDemo(),
    );
  }
}

class ListTextFieldDemo extends StatefulWidget {
  const ListTextFieldDemo({super.key});

  @override
  State<ListTextFieldDemo> createState() => _ListTextFieldDemoState();
}

class _ListTextFieldDemoState extends State<ListTextFieldDemo> {
  final _controller = ListTextEditingController(',');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Text Field')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email addresses'),
            ListTextField(
              controller: _controller,
              itemBuilder: (_, value) {
                return Chip(
                  label: Text(value),
                  onDeleted: () => _controller.removeItem(value),
                );
              },
              itemSpacing: 8,
              itemLineSpacing: 4,
              validator: (value) {
                final emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (emailValid) {
                  return null;
                } else {
                  return 'Enter a valid email address';
                }
              },
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
            ),
          ],
        ),
      ),
    );
  }
}
