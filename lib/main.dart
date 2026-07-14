import 'package:app_organiza/modules/home/presentation/controllers/home_cubit.dart';
import 'package:app_organiza/modules/transacoes/data/repositories/transacao_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/home/presentation/pages/home_page.dart';
// IMPORTANTE: Importe o seu repositório aqui
import 'modules/transacoes/data/repositories/transacao_repository_impl.dart';
import 'dart:io'; // Importante para detectar se é Windows/Desktop
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart'; // O pacote FFI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Esta verificação é essencial para o SQLite funcionar no seu PC
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MindfulMoneyApp());
}

class MindfulMoneyApp extends StatelessWidget {
  const MindfulMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // AQUI ESTÁ A CORREÇÃO:
      // Criamos o Cubit e passamos o repositório como argumento
      create: (context) => HomeCubit(TransacaoRepository()),
      child: MaterialApp(
        title: 'Mindful Money',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
