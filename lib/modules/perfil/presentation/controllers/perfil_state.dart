abstract class PerfilState {}

class PerfilInitial extends PerfilState {}
class PerfilLoading extends PerfilState {}
class PerfilSucesso extends PerfilState {}
class PerfilErro extends PerfilState {
  final String mensagem;
  PerfilErro(this.mensagem);
}