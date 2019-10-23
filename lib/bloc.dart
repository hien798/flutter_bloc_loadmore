import 'package:rxdart/rxdart.dart';

class Bloc {
  final _model = Model();
  final _streamController = BehaviorSubject<Model>();

  Observable<Model> get mainStream => _streamController.stream;

  Bloc() {
    _streamController.add(_model);
    loadData(false);
  }

  int getChildCount() {
    int count =
    _model.isLastPage ? _model.listItem.length : _model.listItem.length + 4;
    return count;
  }

  void loadData(bool isLoadMore, {int numOfItem = 10}) {
    if (_model.isLastPage) {
      print('Hết rồi má ơi');
      return;
    }
    _streamController.add(_model);
    Future.delayed(Duration(seconds: 3), () {
      print('nổ data nè');
      _model.length += numOfItem;
      _model.currentPage += 1;
      if (numOfItem < 10) {
        _model.isLastPage = true;
      }
      for (int i = 0; i < numOfItem; i++) {
        _model.listItem.add('$i');
      }
      _streamController.add(_model);
    });
  }
}

class Model {
  bool isLastPage = false;
  List<String> listItem = [];
  int length = 0;
  int currentPage = 0;
}
