class User {
  String _username;
  String _tokenType;
  String _accessToken;
  String _baseUrl;
  String _password;
  User(this._username, this._tokenType, this._accessToken, this._baseUrl,
      this._password);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._tokenType = obj["token_type"];
    this._accessToken = obj["access_token"];
    this._baseUrl = obj["baseUrl"];
    this._password = obj["password"];
  }

  set username(String username) {
    this._username = username;
  }

  set password(String password) {
    this._password = password;
  }

  set url(String url) {
    this._baseUrl = url;
  }

  String get username => _username;
  String get tokenType => _tokenType;
  String get accessToken => _accessToken;
  String get baseUrl => _baseUrl;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["tokenType"] = _tokenType;
    map["accessToken"] = _accessToken;
    map["baseUrl"] = _baseUrl;
    map["password"] = _password;
    return map;
  }
}
