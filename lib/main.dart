import 'package:app_organiza/modules/home/presentation/controllers/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Importe o seu Cubit aqui
import 'modules/home/presentation/controllers/home_cubit.dart';
import 'modules/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MindfulMoneyApp());
}

class MindfulMoneyApp extends StatelessWidget {
  const MindfulMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolvemos tudo com o BlocProvider
    return BlocProvider(
      create: (context) => HomeCubit(), // Criamos o Cubit aqui
      child: MaterialApp(
        title: 'Mindful Money',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(), // Agora a HomePage consegue enxergar o Cubit
      ),
    );
  }
}
