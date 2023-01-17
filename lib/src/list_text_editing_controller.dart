import 'package:flutter/material.dart';

typedef Validator = String? Function(String value);

class ListTextEditingController extends TextEditingController {
  final String separator;
  final itemsNotifier = SetValueNotifier<String>({});

  ListTextEditingController(this.separator, [Set<String>? items])
      : assert(
          separator.length == 1,
          'Separator must be a single character. Cannot use $separator',
        ),
        super(text: ' ') {
    addListener(_listener);
    if (items != null) itemsNotifier.addAll(items);
  }

  late Validator _validator;
  String? _error;
  String _lastText = '';

  List<String> get items => itemsNotifier.value.toList();
  String? get error => _error;

  void connect(Validator? validator) {
    _validator = validator ?? (_) => null;
  }

  bool removeItem(String item) {
    final result = itemsNotifier.remove(item);
    return result;
  }

  bool addItem(String item) {
    if (item.trim().isEmpty) return false;
    final result = itemsNotifier.add(item);
    return result;
  }

  void addAllItems(Iterable<String> items) {
    final result = itemsNotifier.addAll(
      items.where((element) => element.trim().isNotEmpty),
    );
    return result;
  }

  @override
  void clear() {
    itemsNotifier.clear();
    clearTypingField();
  }

  void clearTypingField() {
    value = const TextEditingValue(
      text: ' ',
      selection: TextSelection.collapsed(offset: 1),
    );
  }

  void _listener() {
    if (text.isEmpty) {
      if (items.isNotEmpty) {
        final lastInput = itemsNotifier.value.last;
        value = TextEditingValue(
          text: lastInput,
          selection: TextSelection.collapsed(offset: lastInput.length),
        );
        itemsNotifier.remove(text);
      } else {
        clearTypingField();
      }
    } else if (text.contains(separator) && text != _lastText) {
      final items = text.split(separator);
      final errorItems = [];

      for (String item in items) {
        final newItem = item.trim();
        if (newItem.isEmpty) break;
        final error = _validator(newItem);
        if (error == null) {
          addItem(newItem);
        } else {
          _error = error;
          errorItems.add(newItem);
        }
      }
      if (errorItems.isNotEmpty) {
        _lastText = errorItems.join(' ');
      } else {
        _lastText = ' ';
      }

      /// water, foodmoe, housing, healthcaremoe
      value = TextEditingValue(
        text: _lastText,
        selection: TextSelection.collapsed(offset: _lastText.length),
      );
    }
  }

  @override
  void dispose() {
    removeListener(_listener);
    super.dispose();
  }
}

class SetValueNotifier<T> extends ValueNotifier<Set<T>> {
  SetValueNotifier(
    Set<T> initialValue,
  ) : super(initialValue);

  bool add(T item) {
    final r = value.add(item);
    notifyListeners();
    return r;
  }

  bool remove(T item) {
    final r = value.remove(item);
    notifyListeners();
    return r;
  }

  void addAll(Iterable<T> items) {
    value.addAll(items);
    notifyListeners();
  }

  void clear() {
    value.clear();
    notifyListeners();
  }
}
