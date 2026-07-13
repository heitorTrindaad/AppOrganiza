import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
// Importe os repositórios de Perfil e Transação aqui

class HomeCubit extends Cubit<HomeState> {
  // Simulação das dependências dos repositórios
  // final PerfilRepository perfilRepo;
  // final TransacaoRepository transacaoRepo;

  HomeCubit(/* this.perfilRepo, this.transacaoRepo */) : super(HomeInitial());

  Future<void> carregarDashboard() async {
    emit(HomeLoading());

    try {
      // Aqui faríamos as chamadas reais aos repositórios do SQLite
      // Exemplo simulado:
      await Future.delayed(const Duration(seconds: 1)); // delay fake

      const double saldoSimulado = 3450.00;
      const double salarioSimulado = 5000.00;
      const int horasMesSimuladas = 160;

      // Cálculo do Mindful Money
      final valorHora = salarioSimulado / horasMesSimuladas;
      final horasDeVida = (saldoSimulado / valorHora).floor();

      emit(
        HomeSucesso(
          saldoAtual: saldoSimulado,
          valorHora: valorHora,
          horasDeVida: horasDeVida,
        ),
      );
    } catch (e) {
      emit(HomeErro("Não conseguimos carregar seu resumo no momento."));
    }
  }
}
