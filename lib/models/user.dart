class User {
  String _username;
  String _token_type;
  String _access_token;
  String _user_id;
  User(this._username, this._token_type, this._access_token, this._user_id);

  User.map(dynamic obj) {
    print(obj);
    this._username = obj["username"];
    this._token_type = obj["token_type"];
    this._access_token = obj["access_token"];
    this._user_id = obj["user_data"]["user_id"];
  }

  String get username => _username;
  String get tokenType => _token_type;
  String get accessToken => _access_token;
  String get userId => _user_id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["tokenType"] = _token_type;
    map["accessToken"] = _access_token;
    map["userId"] = _user_id;
    return map;
  }
}