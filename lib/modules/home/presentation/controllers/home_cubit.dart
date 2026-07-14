import 'package:app_organiza/modules/home/presentation/controllers/home_state.dart';
import 'package:app_organiza/modules/transacoes/data/repositories/transacao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransacaoRepository repository; // Injetado via construtor

  HomeCubit(this.repository) : super(HomeInitial());

  Future<void> carregarDados() async {
    emit(HomeLoading());
    try {
      final saldo = await repository.obterSaldoGeral();
      final transacoes = await repository.obterTodas();
      emit(HomeLoaded(saldo, transacoes));
    } catch (e) {
      emit(HomeError("Erro ao carregar dados: ${e.toString()}"));
    }
  }
}
