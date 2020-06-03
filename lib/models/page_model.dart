import 'package:flutter/cupertino.dart';

class PageModel with ChangeNotifier {
  Widget _viewPage;
  PageModel(this._viewPage);

  Widget getViewPage() => _viewPage;

  setViewPage(v) {
    _viewPage = v;
    notifyListeners();
  }
}
