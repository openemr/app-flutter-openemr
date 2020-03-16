import 'package:openemr/data/rest_ds.dart';
import 'package:openemr/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password, String url) {
    api.login(username, password, url).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((Object error) => _view.onLoginError(error.toString()));
  }
}