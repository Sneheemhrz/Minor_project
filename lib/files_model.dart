class FilesModel{
  int id;
  String _image;

  FilesModel(this._image);

  FilesModel.map(dynamic obj) {
    this._image = obj["images"];

  }

  String get image => _image;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["images"] = _image;

    return map;
  }

  void setId(int id) {
    this.id = id;
  }
}