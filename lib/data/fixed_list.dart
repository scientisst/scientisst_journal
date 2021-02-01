import 'dart:collection';

class FixedList<T> extends ListBase<T> {
  final int length;
  final List<T> _list;

  FixedList(this.length, {T defaultValue})
      : _list = List<T>.filled(length, defaultValue, growable: true);

  FixedList.from(List<T> list)
      : _list = List.from(list, growable: true),
        length = list.length;

  void add(dynamic value) {
    _list.removeAt(0);
    _list.add(value);
  }

  set length(int l) {
    //this._list.length = l;
  }

  T operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, T value) {
    _list[index] = value;
  }
}
