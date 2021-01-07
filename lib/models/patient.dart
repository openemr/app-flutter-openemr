class Patient {
  String _id;
  String _pid;
  String _pubpid;
  String _title;
  String _fname;
  String _mname;
  String _lname;
  String _street;
  String _postalCode;
  String _city;
  String _state;
  String _countryCode;
  String _phoneContact;
  String _dob;
  String _sex;
  String _race;
  String _ethnicity;
  String _username;
  String _tokenType;
  String _accessToken;
  String _userId;

  String get pid => _pid;
  String get title => _title;
  String get fname => _fname;
  String get mname => _mname;
  String get lname => _lname;
  String get sex => _sex;

  Patient(
      this._accessToken,
      this._tokenType,
      this._userId,
      this._username,
      this._city,
      this._countryCode,
      this._dob,
      this._ethnicity,
      this._fname,
      this._id,
      this._lname,
      this._mname,
      this._phoneContact,
      this._pid,
      this._postalCode,
      this._pubpid,
      this._race,
      this._sex,
      this._state,
      this._street,
      this._title);

  Patient.map(dynamic obj) {
    this._accessToken = obj["access_token"];
    this._tokenType = obj["token_type"];
    this._userId = obj["user_id"];
    this._username = obj["username"];
    this._city = obj["city"];
    this._countryCode = obj["country_code"];
    this._dob = obj["DOB"];
    this._ethnicity = obj["ethnicity"];
    this._fname = obj["fname"];
    this._id = obj["id"];
    this._lname = obj["lname"];
    this._mname = obj["mname"];
    this._phoneContact = obj["phone_contact"];
    this._pid = obj["pid"];
    this._postalCode = obj["postal_code"];
    this._pubpid = obj["pubpid"];
    this._race = obj["race"];
    this._sex = obj["sex"];
    this._state = obj["state"];
    this._street = obj["street"];
    this._title = obj["title"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["access_token"] = _accessToken;
    map["token_type"] = _tokenType;
    map["user_id"] = _userId;
    map["username"] = _username;
    map["city"] = _city;
    map["country_code"] = _countryCode;
    map["DOB"] = _dob;
    map["ethnicity"] = _ethnicity;
    map["fname"] = _fname;
    map["id"] = _id;
    map["lname"] = _lname;
    map["mname"] = _mname;
    map["phone_contact"] = _phoneContact;
    map["pid"] = _pid;
    map["postal_code"] = _postalCode;
    map["pubpid"] = _pubpid;
    map["race"] = _race;
    map["sex"] = _sex;
    map["state"] = _state;
    map["street"] = _street;
    map["title"] = _title;
    return map;
  }
}
