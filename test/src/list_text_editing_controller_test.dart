import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listtextfield/listtextfield.dart';

void main() {
  const testSeparator = '-';
  final testItems = {'Water', 'Garri', 'Beans', 'Dodo'};
  const emptyStateValue = TextEditingValue(
      text: ' ', selection: TextSelection.collapsed(offset: 1));

  group('On initialisation', () {
    group('For new controller', () {
      final newController = ListTextEditingController(testSeparator);

      test('Items are empty', () {
        expect(newController.items.isEmpty, true);
      });

      test('Separator is same as specified', () {
        expect(newController.separator, testSeparator);
      });

      test('Typing field is empty', () {
        expect(newController.text, ' ');
      });
    });

    group('With items', () {
      final controller = ListTextEditingController(testSeparator, testItems);
      test('Starts with the set items', () {
        expect(controller.items, testItems);
      });
    });
  });

  group('Methods', () {
    const testItem = 'Test';

    group('add item', () {
      test('items contain item and is last', () {
        final controller = ListTextEditingController(testSeparator);
        controller.addItem(testItem);
        expect(controller.items.contains(testItem), true);
        expect(controller.items.last, testItem);
      });

      test('an item is not repeated in items', () {
        final controller = ListTextEditingController(testSeparator);
        controller.addItem(testItem);
        controller.addItem(testItem);
        controller.addItem(testItem);

        final appearances = controller.items.where(
          (element) => element == testItem,
        );
        expect(appearances.length, 1);
      });
      test('white space only cannot be added', () {
        final controller = ListTextEditingController(testSeparator);
        controller.addItem('');
        controller.addItem(' ');
        controller.addItem('   ');
        expect(controller.items.length, 0);
      });
    });

    group('remove item', () {
      test('item is removed', () {
        final controller = ListTextEditingController(testSeparator, testItems);
        controller.removeItem(testItems.first);

        expect(controller.items.contains(testItems.first), false);
      });
    });

    group('add all items', () {
      final controller = ListTextEditingController(testSeparator);
      test('all items are added', () {
        controller.addAllItems(testItems);

        expect(controller.items, testItems);
      });

      test('white space only cannot be added', () {
        final formerItems = List.from(controller.items);
        final whiteSpaceList = ['', ' ', '   '];
        controller.addAllItems(whiteSpaceList);
        expect(controller.items, formerItems);
      });

      test('items are not repeated', () {
        final listWithRepeatedItems = List<String>.from(testItems)
          ..addAll(testItems);
        controller.addAllItems(listWithRepeatedItems);
        expect(controller.items, testItems);
      });
    });

    group('clear', () {
      final controller = ListTextEditingController(testSeparator, testItems);
      controller.clear();
      test('current text is empty', () {
        expect(controller.value, emptyStateValue);
      });

      test('items is empty', () {
        expect(controller.items.isEmpty, true);
      });
    });

    group('clear typing field', () {
      final controller = ListTextEditingController(testSeparator, testItems);
      controller.clearTypingField();
      test('current text is empty', () {
        expect(controller.value, emptyStateValue);
      });

      test('items is unaffected', () {
        expect(controller.items, testItems);
      });
    });
  });
}
