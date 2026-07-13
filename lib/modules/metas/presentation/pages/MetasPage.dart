import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/MetasCubit.dart';
import '../controllers/metasState.dart';
import '../../data/models/MetaSonhoModel.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  @override
  void initState() {
    super.initState();
    context.read<MetasCubit>().carregarMetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: const Text(
          "Meus Sonhos",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<MetasCubit, MetasState>(
        builder: (context, state) {
          if (state is MetasLoading || state is MetasInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFB2AC88)),
            );
          }

          if (state is MetasErro) {
            return Center(child: Text(state.mensagem));
          }

          if (state is MetasSucesso) {
            final metas = state.metas;

            if (metas.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount:
                  metas.length + 1, // +1 para o botão de adicionar no final
              itemBuilder: (context, index) {
                if (index == metas.length) {
                  return _buildAddButton(context);
                }
                return _buildMetaCard(metas[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMetaCard(MetaSonhoModel meta) {
    final progresso = meta.progresso; // Retorna de 0.0 a 1.0

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meta.nomeSonho,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                "${(progresso * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB2AC88),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Barra de Progresso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 12,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFB2AC88),
              ), // Verde Sálvia
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Salvo: R\$ ${meta.valorPoupado.toStringAsFixed(2)}",
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
              Text(
                "Alvo: R\$ ${meta.valorAlvo.toStringAsFixed(2)}",
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sailing_outlined,
              size: 80,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 24),
            const Text(
              "Nenhum sonho cultivado ainda.",
              style: TextStyle(fontSize: 18, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 32),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // Para rodar hoje e testar, vamos inserir um sonho fake direto ao clicar
        context.read<MetasCubit>().criarNovaMeta(
          "Reserva de Emergência",
          10000.0,
        );
      },
      icon: const Icon(Icons.add, color: Color(0xFF1E293B)),
      label: const Text(
        "Cultivar novo sonho",
        style: TextStyle(color: Color(0xFF1E293B)),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    );
  }
}
