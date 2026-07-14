import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/transacao_model.dart';
import '../../data/repositories/transacao_repository_impl.dart';
import 'transacao_state.dart';

class TransacaoCubit extends Cubit<TransacaoState> {
  final TransacaoRepositoryImpl _repository;

  TransacaoCubit(this._repository) : super(TransacaoInitial());

  Future<void> registrarTransacao({
    required double valor,
    required TipoTransacao tipo,
    required String categoria,
    String? descricao,
    EstadoEmocional? estadoEmocional,
  }) async {
    emit(TransacaoLoading());
    try {
      final novaTransacao = TransacaoModel(
        valor: valor,
        tipo: tipo,
        categoria: categoria,
        descricao: descricao,
        dataRegistro: DateTime.now(),
        estadoEmocional: estadoEmocional,
      );

      await _repository.inserirTransacao(novaTransacao);
      emit(TransacaoSucesso());
    } catch (e) {
      emit(
        TransacaoErro("Não foi possível registrar o valor: ${e.toString()}"),
      );
    }
  }
}
