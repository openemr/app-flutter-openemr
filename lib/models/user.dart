class User {
  String _username;
  String _token_type;
  String _access_token;
  String _base_url;
  String _password;
  User(this._username, this._token_type, this._access_token, this._base_url,
      this._password);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._token_type = obj["token_type"];
    this._access_token = obj["access_token"];
    this._base_url = obj["baseUrl"];
    this._password = obj["password"];
  }

  set username(String username) {
    this._username = username;
  }

  set password(String password) {
    this._password = password;
  }

  set url(String url) {
    this._base_url = url;
  }

  String get username => _username;
  String get tokenType => _token_type;
  String get accessToken => _access_token;
  String get baseUrl => _base_url;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["tokenType"] = _token_type;
    map["accessToken"] = _access_token;
    map["baseUrl"] = _base_url;
    map["password"] = _password;
    return map;
  }
}
