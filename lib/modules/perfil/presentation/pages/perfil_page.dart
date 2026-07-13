import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/perfil_cubit.dart';
import '../controllers/perfil_state.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _salarioController = TextEditingController();
  final _horasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Off-white acolhedor
      body: BlocConsumer<PerfilCubit, PerfilState>(
        listener: (context, state) {
          if (state is PerfilSucesso) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil atualizado com consciência!'),
              ),
            );
          }
          if (state is PerfilErro) {
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Olá,\nVamos definir sua base.",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Quanto custa seu tempo hoje?",
                  style: TextStyle(fontSize: 18, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 48),

                // Campo Salário
                _buildInputField(
                  label: "Seu salário mensal (Líquido)",
                  controller: _salarioController,
                  icon: Icons.account_balance_wallet_outlined,
                  prefix: "R\$ ",
                ),

                const SizedBox(height: 24),

                // Campo Horas
                _buildInputField(
                  label: "Horas trabalhadas por mês",
                  controller: _horasController,
                  icon: Icons.timer_outlined,
                  helper: "Ex: 160h (40h semanais)",
                ),

                const SizedBox(height: 60),

                // Botão Salvar
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: state is PerfilLoading
                        ? null
                        : () => context.read<PerfilCubit>().salvarPerfil(
                            double.tryParse(_salarioController.text) ?? 0,
                            int.tryParse(_horasController.text) ?? 0,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB2AC88), // Verde Sálvia
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: state is PerfilLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Ativar Consciência Financeira",
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? prefix,
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: prefix,
            helperText: helper,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: const Color(0xFFB2AC88)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }
}
