import '../../data/models/MetaSonhoModel.dart';

abstract class MetasState {}

class MetasInitial extends MetasState {}

class MetasLoading extends MetasState {}

class MetasSucesso extends MetasState {
  final List<MetaSonhoModel> metas;
  MetasSucesso(this.metas);
}

class MetasErro extends MetasState {
  final String mensagem;
  MetasErro(this.mensagem);
}