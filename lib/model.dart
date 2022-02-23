class Models {
  int id;
  String _image;
  var _xC;
  var _yC;
  String _pin;

  Models(this._image, this._xC, this._yC,this._pin);

  Models.map(dynamic obj) {
    this._image = obj["image"];
    this._xC = obj["xc"];
    this._yC = obj["yC"];
    this._pin = obj["pin"];
  }

  String get image => _image;
  String get xc => _xC;
  String get yc => _yC;
  String get pin => _pin;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["image"] = _image;
    map["xc"] = _xC;
    map["yc"] = _yC;
    map["pin"] = _pin;
    return map;
  }

  void setId(int id) {
    this.id = id;
  }
}
