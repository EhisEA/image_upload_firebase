import 'package:flutter/cupertino.dart';

enum ViewState { Busy, Idle }

class BaseViewModel extends ChangeNotifier {
  bool _disposed = false;
  bool get isDisposed => _disposed;

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  bool get isBusy => _state == ViewState.Busy;

  ViewState _secondaryState = ViewState.Idle;

  ViewState get secondaryState => _secondaryState;
  bool get isSecondaryBusy => _secondaryState == ViewState.Busy;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  setBusy(ViewState currentState) {
    _state = currentState;
    if (!_disposed) notifyListeners();
  }

  setSecondaryBusy(ViewState currentState) {
    _secondaryState = currentState;
    if (!_disposed) notifyListeners();
  }
}
