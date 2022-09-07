import 'dart:math';

extension ListExtension<T> on List<T> {
  T getRandom() => this[Random().nextInt(length)];
}
