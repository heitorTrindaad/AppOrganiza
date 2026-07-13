abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSucesso extends HomeState {
  final double saldoAtual;
  final double valorHora;
  final int horasDeVida; 

  HomeSucesso({
    required this.saldoAtual,
    required this.valorHora,
    required this.horasDeVida,
  });
}

class HomeErro extends HomeState {
  final String mensagem;
  HomeErro(this.mensagem);
}