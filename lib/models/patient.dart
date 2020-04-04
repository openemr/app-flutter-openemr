class Patient {
  String _id;
  String _pid;
  String _pubpid;
  String _title;
  String _fname;
  String _mname;
  String _lname;
  String _street;
  String _postal_code;
  String _city;
  String _state;
  String _country_code;
  String _phone_contact;
  String _dob;
  String _sex;
  String _race;
  String _ethnicity;
  String _username;
  String _token_type;
  String _access_token;
  String _user_id;

  String get id => _id;
  set id(String value) => _id = value;
  String get pid => _pid;
  set pid(String value) => _pid = value;
  String get pubpid => _pubpid;
  set pubpid(String value) => _pubpid = value;
  String get title => _title;
  set title(String value) => _title = value;
  String get fname => _fname;
  set fname(String value) => _fname = value;
  String get mname => _mname;
  set mname(String value) => _mname = value;
  String get lname => _lname;
  set lname(String value) => _lname = value;
  String get street => _street;
  set street(String value) => _street = value;
  String get postal_code => _postal_code;
  set postal_code(String value) => _postal_code = value;
  String get city => _city;
  set city(String value) => _city = value;
  String get state => _state;
  set state(String value) => _state = value;
  String get country_code => _country_code;
  set country_code(String value) => _country_code = value;
  String get phone_contact => _phone_contact;
  set phone_contact(String value) => _phone_contact = value;
  String get dob => _dob;
  set dob(String value) => _dob = value;
  String get sex => _sex;
  set sex(String value) => _sex = value;
  String get race => _race;
  set race(String value) => _race = value;
  String get ethnicity => _ethnicity;
  set ethnicity(String value) => _ethnicity = value;
  String get username => _username;
  set username(String value) => _username = value;
  String get token_type => _token_type;
  set token_type(String value) => _token_type = value;
  String get access_token => _access_token;
  set access_token(String value) => _access_token = value;
  String get user_id => _user_id;
  set user_id(String value) => _user_id = value;
  
  Patient(
      this._access_token,
      this._token_type,
      this._user_id,
      this._username,
      this._city,
      this._country_code,
      this._dob,
      this._ethnicity,
      this._fname,
      this._id,
      this._lname,
      this._mname,
      this._phone_contact,
      this._pid,
      this._postal_code,
      this._pubpid,
      this._race,
      this._sex,
      this._state,
      this._street,
      this._title);

  Patient.map(dynamic obj) {
    this._access_token = obj["access_token"];
    this._token_type = obj["token_type"];
    this._user_id = obj["user_id"];
    this._username = obj["username"];
    this._city = obj["city"];
    this._country_code = obj["country_code"];
    this._dob = obj["DOB"];
    this._ethnicity = obj["ethnicity"];
    this._fname = obj["fname"];
    this._id = obj["id"];
    this._lname = obj["lname"];
    this._mname = obj["mname"];
    this._phone_contact = obj["phone_contact"];
    this._pid = obj["pid"];
    this._postal_code = obj["postal_code"];
    this._pubpid = obj["pubpid"];
    this._race = obj["race"];
    this._sex = obj["sex"];
    this._state = obj["state"];
    this._street = obj["street"];
    this._title = obj["title"];
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["access_token"] = _access_token;
    map["token_type"] = _token_type;
    map["user_id"] = _user_id;
    map["username"] = _username;
    map["city"] = _city;
    map["country_code"] = _country_code;
    map["DOB"] = _dob;
    map["ethnicity"] = _ethnicity;
    map["fname"] = _fname;
    map["id"] = _id;
    map["lname"] = _lname;
    map["mname"] = _mname;
    map["phone_contact"] = _phone_contact;
    map["pid"] = _pid;
    map["postal_code"] = _postal_code;
    map["pubpid"] = _pubpid;
    map["race"] = _race;
    map["sex"] = _sex;
    map["state"] = _state;
    map["street"] = _street;
    map["title"] = _title;
    return map;
  }
}
