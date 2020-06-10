class User {
  String _username;
  String _token_type;
  String _access_token;
  String _user_id;
  String _base_url;
  String _password;
  bool _save_password;
  User(this._username, this._token_type, this._access_token, this._user_id,
      this._base_url, this._save_password, this._password);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._token_type = obj["token_type"];
    this._access_token = obj["access_token"];
    this._user_id = obj["user_data"]["user_id"];
    this._base_url = obj["baseUrl"];
    this._save_password = obj["savePassword"];
    this._password = obj["password"];
  }

  String get username => _username;
  String get tokenType => _token_type;
  String get accessToken => _access_token;
  String get userId => _user_id;
  String get baseUrl => _base_url;
  String get password => _password;
  bool get savePassword => _save_password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["tokenType"] = _token_type;
    map["accessToken"] = _access_token;
    map["userId"] = _user_id;
    map["baseUrl"] = _base_url;
    map["password"] = _password;
    map["savePassword"] = _save_password ? 1 : 0;
    return map;
  }
}
