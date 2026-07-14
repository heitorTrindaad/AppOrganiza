import 'package:app_organiza/modules/home/presentation/controllers/home_cubit.dart';
import 'package:app_organiza/modules/home/presentation/controllers/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transacoes/data/models/transacao_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mindful Money")),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading)
            return const Center(child: CircularProgressIndicator());

          if (state is HomeError) return Center(child: Text(state.message));

          if (state is HomeLoaded) {
            return Column(
              children: [
                _buildHeaderSaldo(state.saldo),
                Expanded(child: _buildListaTransacoes(state.transacoes)),
              ],
            );
          }

          return const Center(child: Text("Bem-vindo!"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<HomeCubit>().carregarDados(), // Botão de teste
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildHeaderSaldo(double saldo) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Saldo: R\$ ${saldo.toStringAsFixed(2)}",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListaTransacoes(List<TransacaoModel> transacoes) {
    return ListView.builder(
      itemCount: transacoes.length,
      itemBuilder: (context, index) {
        final t = transacoes[index];
        return ListTile(
          title: Text(t.descricao ?? 'Sem descrição'),
          subtitle: Text(t.categoria),
          trailing: Text("R\$ ${t.valor.toStringAsFixed(2)}"),
        );
      },
    );
  }
}
