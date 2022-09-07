class KeyboardAlphabet {
  const KeyboardAlphabet(this.number, this.top, this.middle, this.bottom);

  final KeyboardRow number;
  final KeyboardRow top;
  final KeyboardRow middle;
  final KeyboardRow bottom;

  List<String> get allWithoutNum => top.all + middle.all + bottom.all;
  List<String> get all => allWithoutNum + number.all;
}

class KeyboardRow {
  const KeyboardRow(this._leftHand, this._rightHand);

  final List<String> _leftHand;
  final List<String> _rightHand;

  List<String> get leftHand => _leftHand.map((e) => e.toUpperCase()).toList();
  List<String> get rightHand => _rightHand.map((e) => e.toUpperCase()).toList();
  List<String> get all => leftHand + rightHand;
}
