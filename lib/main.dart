import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/home_screen.dart';
import 'theme/app_theme.dart'; 
import '../theme/app_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const ProviderScope(child: CompetenciaApp()));
}

class CompetenciaApp extends StatelessWidget {
  const CompetenciaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Competencia de Lazadores de Becerros',
      theme: AppTheme.lightTheme, 
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
