import 'package:app_organiza/modules/transacoes/data/models/transacao_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final double saldo;
  final List<TransacaoModel> transacoes;

  HomeLoaded(this.saldo, this.transacoes);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
