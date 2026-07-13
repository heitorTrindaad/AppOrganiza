import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/MetaSonhoModel.dart';
import '../../data/repositories/MetaSonhoRepository.dart';
import 'metas_state.dart';

class MetasCubit extends Cubit<MetasState> {
  final MetaSonhoRepository _repository;

  MetasCubit(this._repository) : super(MetasInitial());

  // Busca todas as metas do banco de dados
  Future<void> carregarMetas() async {
    emit(MetasLoading());
    try {
      final metas = await _repository.obterTodasAsMetas();
      
      // Para cada meta, garantimos que o saldo (valor_poupado) está atualizado
      for (var meta in metas) {
        if (meta.id != null) {
          await _repository.atualizarSaldoDaMeta(meta.id!);
        }
      }
      
      // Busca a lista atualizada após a sincronização de saldo
      final metasAtualizadas = await _repository.obterTodasAsMetas();
      emit(MetasSucesso(metasAtualizadas));
    } catch (e) {
      emit(MetasErro("Erro ao carregar seus sonhos: ${e.toString()}"));
    }
  }

  // Cria uma nova meta (usado pelo botão de adicionar)
  Future<void> criarNovaMeta(String nome, double valorAlvo) async {
    try {
      final novaMeta = MetaSonhoModel(nomeSonho: nome, valorAlvo: valorAlvo);
      await _repository.criarMeta(novaMeta);
      await carregarMetas(); // Recarrega a tela automaticamente
    } catch (e) {
      emit(MetasErro("Não foi possível criar o sonho."));
    }
  }
}