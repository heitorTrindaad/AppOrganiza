import 'package:app_organiza/modules/transacoes/data/repositories/transacao_repository_impl.dart';
import 'package:flutter/material.dart';
import '../../data/models/transacao_model.dart';

class TransacaoFormPage extends StatefulWidget {
  final TransacaoRepositoryImpl repository;

  const TransacaoFormPage({super.key, required this.repository});

  @override
  State<TransacaoFormPage> createState() => _TransacaoFormPageState();
}

class _TransacaoFormPageState extends State<TransacaoFormPage> {
  final _valorController = TextEditingController();
  final _descController = TextEditingController();
  String _tipo = 'SAIDA';

  // Boa prática: limpar os controllers quando a tela fecha
  @override
  void dispose() {
    _valorController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Transação")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: "Valor (R$)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            DropdownButton<String>(
              value: _tipo,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'ENTRADA', child: Text("Entrada")),
                DropdownMenuItem(value: 'SAIDA', child: Text("Saída")),
              ],
              // Corrigido: Aqui estava o erro de lógica anterior
              onChanged: (val) => setState(() => _tipo = val!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final valor = double.tryParse(_valorController.text) ?? 0.0;
                
                final novaTransacao = TransacaoModel(
                  valor: valor,
                  tipo: _tipo,
                  categoria: 'Geral', 
                  descricao: _descController.text,
                  dataRegistro: DateTime.now(),
                );

                await widget.repository.inserirTransacao(novaTransacao);
                
                // Corrigido: O uso do mounted evita erros se a tela fechar rápido
                if (mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Salvar Transação"),
            )
          ],
        ),
      ),
    );
  }
}