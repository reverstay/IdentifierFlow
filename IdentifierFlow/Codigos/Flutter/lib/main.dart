import 'package:IdenfierFlow/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Supabase
  await Supabase.initialize(
    url: 'https://jlhianbfukqnhuqwoapr.supabase.co', // Substitua pela URL do seu Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpsaGlhbmJmdWtxbmh1cXdvYXByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczOTA2MTA0MSwiZXhwIjoyMDU0NjM3MDQxfQ.VAhlm66w4yaPpOoKw6hI24BOcmbHosh2tluv_2KL094', // Substitua pela sua chave pública (anon)
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage() // Mantendo sua estrutura original
    );
  }
}
