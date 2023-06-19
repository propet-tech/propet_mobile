import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomPagingController<T>
    extends PagingController<int, T> {
  CustomPagingController({required super.firstPageKey});

  void removeAt(int index) {
    if (itemList != null) {
      itemList!.removeAt(index);
      notifyListeners();
    }
  }
}
