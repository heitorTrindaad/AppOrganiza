abstract class TransacaoState {}

class TransacaoInitial extends TransacaoState {}

class TransacaoLoading extends TransacaoState {}

class TransacaoSucesso extends TransacaoState {}

class TransacaoErro extends TransacaoState {
  final String mensagem;
  TransacaoErro(this.mensagem);
}