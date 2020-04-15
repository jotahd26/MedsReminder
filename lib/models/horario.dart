
class Horario {

  int _id;
  String _hora;
  int _idMedicamento;

  Horario(this._hora, this._idMedicamento);

  Horario.withId(this._id, this._hora, this._idMedicamento);

  int get id => _id;

  String get hora => _hora;

  int get idMedicamento => _idMedicamento;

  set id(int newid){
    this.id=newid;
  }
  set hora(String newHora) {
    if (newHora.length <= 255) {
      this._hora = newHora;
    }
  }
  set idMedicamento(int newidMedicamento) {
      this._idMedicamento = newidMedicamento;
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['hora'] = _hora;
    map['idMedicamento'] = _idMedicamento;

    return map;
  }

  // Extract a Note object from a Map object
  Horario.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._hora = map['hora'];
    this._idMedicamento = map['idMedicamento'];
  }
}









