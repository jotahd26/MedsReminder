
class Medicamento {

  int _id;
  String _nome;
  String _tipo;
  String _frequencia;
  String _stock;


  Medicamento(this._nome, this._tipo,this._frequencia,this._stock);

  Medicamento.withId(this._id, this._nome, this._tipo,this._frequencia,this._stock);

  int get id => _id;

  String get nome => _nome;

  String get tipo => _tipo;

  String get frequencia => _frequencia;

  String get stock =>_stock;

//  set id(int newid) {
//      this._id = newid;
//  }
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
  set stock(String newStock) {
      this._stock = newStock;
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
    map['stock']=_stock;

    return map;
  }

  // Extract a Note object from a Map object
  Medicamento.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._tipo = map['tipo'];
    this._frequencia = map['frequencia'];
    this._stock=map['stock'];
  }
}









