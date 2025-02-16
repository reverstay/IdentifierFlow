import 'package:bcrypt/bcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      // Tabelas de autenticação: admin, director e receptionist
      for (String table in ["admin", "director", "receptionist"]) {
        final response = await supabase
            .from(table)
            .select('*')
            .eq('username', username)
            .maybeSingle();

        if (response != null) {
          String storedHash = response["password_hash"];

          // Verifica a senha utilizando bcrypt
          bool passwordIsValid = BCrypt.checkpw(password, storedHash);

          if (passwordIsValid) {
            // Se for director, busque o nome da organização usando organization_id
            if (table == "director") {
              final orgResponse = await supabase
                  .from("organization")
                  .select("name")
                  .eq("id", response["organization_id"])
                  .maybeSingle();
              if (orgResponse != null) {
                response["organization"] = orgResponse["name"];
              } else {
                response["organization"] = "Organização não encontrada";
              }
            }
            // Se for receptionist, busque primeiro o diretor e depois a organização
            else if (table == "receptionist") {
              final directorResponse = await supabase
                  .from("director")
                  .select("organization_id")
                  .eq("id", response["director_id"])
                  .maybeSingle();
              if (directorResponse != null) {
                final orgResponse = await supabase
                    .from("organization")
                    .select("name")
                    .eq("id", directorResponse["organization_id"])
                    .maybeSingle();
                if (orgResponse != null) {
                  response["organization"] = orgResponse["name"];
                } else {
                  response["organization"] = "Organização não encontrada";
                }
              } else {
                response["organization"] = "Diretor não encontrado";
              }
            }
            // Para admin não há associação direta à organização
            return {
              "success": true,
              "message": "Login bem-sucedido!",
              "user": response,
              "role": table,
            };
          } else {
            return {"success": false, "message": "Usuário ou senha incorretos"};
          }
        }
      }
      return {"success": false, "message": "Usuário não encontrado"};
    } catch (e) {
      return {"success": false, "message": "Erro ao conectar ao Supabase: $e"};
    }
  }
}
