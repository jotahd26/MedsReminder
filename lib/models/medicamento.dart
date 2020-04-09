
class Medicamento {

  int _id;
  String _nome;
  String _tipo;
  String _frequencia;

  Medicamento(this._nome, this._tipo,this._frequencia);

  Medicamento.withId(this._id, this._nome, this._tipo,this._frequencia);

  int get id => _id;

  String get nome => _nome;

  String get tipo => _tipo;

  String get frequencia => _frequencia;

  set nome(String newNome) {
    if (newNome.length <= 255) {
      this._nome = newNome;
    }
  }
  set frequencia(String newFrequencia) {
    if (newFrequencia.length <= 255) {
      this._frequencia = newFrequencia;
    }
  }
  set tipo(String newTipo) {
    if (newTipo.length <= 255) {
      this._tipo = newTipo;
    }
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['tipo'] = _tipo;
    map['frequencia'] = _frequencia;

    return map;
  }

  // Extract a Note object from a Map object
  Medicamento.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._tipo = map['tipo'];
    this._frequencia = map['frequencia'];
  }
}









