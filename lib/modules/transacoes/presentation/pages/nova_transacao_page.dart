import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/transacal_model.dart';
import '../controllers/transacao_cubit.dart';
import '../controllers/transacao_state.dart';

class NovaTransacaoPage extends StatefulWidget {
  const NovaTransacaoPage({super.key});

  @override
  State<NovaTransacaoPage> createState() => _NovaTransacaoPageState();
}

class _NovaTransacaoPageState extends State<NovaTransacaoPage> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();

  TipoTransacao _tipoSelecionado = TipoTransacao.SAIDA;
  EstadoEmocional? _emocaoSelecionada;
  String _categoriaSelecionada = 'Alimentação';

  final List<String> _categorias = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Casa',
    'Saúde',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: const Text(
          "Novo Registro",
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
      ),
      body: BlocConsumer<TransacaoCubit, TransacaoState>(
        listener: (context, state) {
          if (state is TransacaoSucesso) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro salvo com sucesso!')),
            );
            Navigator.pop(context); // Volta para a tela anterior
          }
          if (state is TransacaoErro) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensagem),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle Entrada/Saída
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTipoBotao(
                      "Gastei",
                      TipoTransacao.SAIDA,
                      const Color(0xFFE2A499),
                    ),
                    const SizedBox(width: 16),
                    _buildTipoBotao(
                      "Recebi",
                      TipoTransacao.ENTRADA,
                      const Color(0xFFB2AC88),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Campo de Valor
                TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    prefixText: "R\$ ",
                    prefixStyle: const TextStyle(
                      fontSize: 40,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    hintText: "0.00",
                  ),
                ),
                const Divider(),
                const SizedBox(height: 24),

                // Categoria (Chips)
                const Text(
                  "Categoria",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: _categorias.map((cat) {
                    return ChoiceChip(
                      label: Text(cat),
                      selected: _categoriaSelecionada == cat,
                      selectedColor: const Color(0xFFE2E8F0),
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected)
                          setState(() => _categoriaSelecionada = cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Humor (Exibido apenas se for SAÍDA)
                if (_tipoSelecionado == TipoTransacao.SAIDA) ...[
                  const Text(
                    "Como você estava se sentindo?",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: EstadoEmocional.values.map((emocao) {
                      return ChoiceChip(
                        label: Text(emocao.name.toUpperCase()),
                        selected: _emocaoSelecionada == emocao,
                        selectedColor: const Color(0xFFFFE4E6),
                        backgroundColor: Colors.white,
                        onSelected: (selected) {
                          setState(
                            () => _emocaoSelecionada = selected ? emocao : null,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],

                // Botão Salvar
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: state is TransacaoLoading
                        ? null
                        : () {
                            final valor =
                                double.tryParse(_valorController.text) ?? 0.0;
                            if (valor > 0) {
                              context.read<TransacaoCubit>().registrarTransacao(
                                valor: valor,
                                tipo: _tipoSelecionado,
                                categoria: _categoriaSelecionada,
                                estadoEmocional:
                                    _tipoSelecionado == TipoTransacao.SAIDA
                                    ? _emocaoSelecionada
                                    : null,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1E293B,
                      ), // Dark blue/gray
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: state is TransacaoLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Salvar Registro",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget auxiliar para os botões de Gastei/Recebi
  Widget _buildTipoBotao(String texto, TipoTransacao tipo, Color corAtiva) {
    final isSelected = _tipoSelecionado == tipo;
    return GestureDetector(
      onTap: () => setState(() => _tipoSelecionado = tipo),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? corAtiva : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? corAtiva : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
