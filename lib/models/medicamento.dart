
class Medicamento {

  int _id;
  String _imagem;
  String _nome;
  String _tipo;
  String _frequencia;
  String _stock;
  String _nomeUtilizador;
  int _estado;


  Medicamento(this._imagem,this._nome, this._tipo,this._frequencia,this._stock,this._nomeUtilizador,this._estado);

  Medicamento.withId(this._id,this._imagem, this._nome, this._tipo,this._frequencia,this._stock,this._nomeUtilizador,this._estado);

  int get id => _id;
  String get imagem => _imagem;
  String get nome => _nome;
  String get tipo => _tipo;
  String get frequencia => _frequencia;
  String get stock =>_stock;
  String get nomeUtilizador =>_nomeUtilizador;
  int get estado =>_estado;

//  set id(int newid) {
//      this._id = newid;
//  }
  set estado(int newEstado) {
      this._estado = newEstado;
  }
  set imagem(String newImagem) {
      this._imagem = newImagem;
  }
  set nome(String newNome) {
    if (newNome.length <= 255) {
      this._nome = newNome;
    }
  }
  set nomeUtilizador(String newNomeU) {
    if (newNomeU.length <= 255) {
      this._nomeUtilizador = newNomeU;
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
    map['imagem'] = _imagem;
    map['tipo'] = _tipo;
    map['frequencia'] = _frequencia;
    map['stock']=_stock;
    map['nomeUtilizador']=_nomeUtilizador;
    map['estado']=_estado;


    return map;
  }

  // Extract a Note object from a Map object
  Medicamento.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._imagem = map['imagem'];
    this._nome = map['nome'];
    this._tipo = map['tipo'];
    this._frequencia = map['frequencia'];
    this._stock=map['stock'];
    this._nomeUtilizador=map['nomeUtilizador'];
    this._estado= map['estado'];
  }
}









