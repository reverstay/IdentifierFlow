import 'package:flutter/material.dart';
import 'package:IdenfierFlow/components/my_buttom.dart';
import 'package:IdenfierFlow/components/my_textfield.dart';
import 'package:IdenfierFlow/services/auth_service.dart';
import 'package:IdenfierFlow/pages/pagina_inicial.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    debugPrint("LoginPage: signUserIn iniciado");

    final screenWidth = MediaQuery.of(context).size.width;
    final h = screenWidth * 0.01;
    final v = screenWidth * 0.01;

    // Exibe um loading
    debugPrint("LoginPage: exibindo loading");
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final authService = AuthService();
    debugPrint(
        "LoginPage: chamando authService.loginUser com username: ${emailController.text} e senha: ${passwordController.text}");

    final result = await authService.loginUser(
      emailController.text,
      passwordController.text,
    );

    debugPrint("LoginPage: resultado do login: $result");
    Navigator.pop(context); // Fecha o loading

    if (result["success"]) {
      debugPrint("LoginPage: Login bem-sucedido!");

      // Extração do nome e ID da organização
      String organizationName;
      int organizationId = 0; // Inicializa com valor seguro

      if (result["user"] != null) {
        var user = result["user"];

        // Verifica se há um `organization_id` válido e o converte para int
        if (user.containsKey("organization_id")) {
          try {
            organizationId = int.parse(user["organization_id"].toString());
          } catch (e) {
            debugPrint("Erro ao converter organization_id para int: $e");
            organizationId = 0; // Evita falha na conversão
          }
        }

        // Obtém o nome da organização
        if (user.containsKey("organization")) {
          organizationName = user["organization"];
        } else {
          organizationName = "Organização Desconhecida";
        }
      } else if (result["role"] == "admin") {
        organizationName = "Administrador";
        organizationId = 0; // Admin pode não ter organização associada
      } else {
        organizationName = "Minha Organização";
      }

      debugPrint("LoginPage: Organização definida: $organizationName");
      debugPrint("LoginPage: Organization ID: $organizationId");

      // Redireciona para a página inicial, garantindo que organizationId seja válido
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaInicial(
            organizationName: organizationName,
            organizationId: organizationId,
          ),
        ),
      );
    } else {
      debugPrint("LoginPage: Login falhou: ${result["message"]}");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2 * v),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Text(
                    'Falha ao acessar',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 3.5 * h,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6 * h, vertical: 10 * v),
                child: Column(
                  children: [
                    Text(
                      result["message"],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5 * h, 0, 5 * h, 5 * v),
                child: MyButton(
                  onTap: () {
                    debugPrint("LoginPage: Botão 'Tentar novamente' pressionado");
                    Navigator.pop(context);
                  },
                  text: 'Tentar novamente',
                  h: 3 * h,
                  v: 1 * v,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void genericErrorMessage(String message) {
    debugPrint("LoginPage: Erro genérico: $message");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint("LoginPage: Botão OK pressionado na mensagem de erro genérico");
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("LoginPage: build iniciado");
    final screenWidth = MediaQuery.of(context).size.width;
    final h = screenWidth * 0.01;
    final v = screenWidth * 0.01;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20 * v, 0, 5 * v),
                  child: Image.asset(
                    'lib/icons/IdentifierFlow_logo.png',
                    width: 35 * h,
                    height: 35 * v,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10 * v),
                  child: Text(
                    'IdentifierFlow',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 6 * h,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6 * h, 2 * v, 6 * h, 2 * v),
                  child: MyTextField(
                    controller: emailController,
                    hintText: 'Nome do usuário',
                    obscureText: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6 * h, 2 * v, 6 * h, 10 * v),
                  child: MyTextField(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6 * h, 0, 6 * h, 0),
                  child: MyButton(
                    onTap: () {
                      debugPrint("LoginPage: Botão 'Acessar' pressionado");
                      signUserIn();
                    },
                    text: 'Acessar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
