
class Eventos {

  int _id;
  int _idH;
  int _idM;
  DateTime _data;

  Eventos(this._idH, this._idM,this._data);
  Eventos.withId(this._id, this._idH, this._idM,this._data);

  int get id => _id;
  int get idH => _idH;
  int get idM => _idM;
  DateTime get data=>_data;

  set id(int newid){
    this.id=newid;
  }
  set idM(int newidM){
    this._idM=newidM;
  }
  set idH(int newidH){
    this._idH=newidH;
  }
  set data(DateTime newdata){
    this._data=newdata;
  }
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['idH'] = _idH;
    map['idM'] = _idM;
    map['data'] = _data.toIso8601String();
    return map;
  }

  // Extract a Note object from a Map object
  Eventos.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._idM = map['idM'];
    this._idH = map['idH'];
    this._data = DateTime.parse(map['data']);
  }
}









