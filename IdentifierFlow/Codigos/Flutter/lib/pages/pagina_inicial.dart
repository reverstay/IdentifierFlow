import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:IdenfierFlow/pages/login_page.dart';
import 'package:IdenfierFlow/services/reconhecimento.dart'; // Certifique-se de que o FaceDetectorView receba o deviceType
import '../components/my_buttom.dart';

class PaginaInicial extends StatefulWidget {
  final String organizationName;
  final int organizationId; // ID da organização para atualizar no Supabase

  const PaginaInicial({
    Key? key,
    required this.organizationName,
    required this.organizationId,
  }) : super(key: key);

  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  String selectedDeviceType = "entrada"; // valor padrão

  // Função para atualizar a tabela "devices" no Supabase
  Future<void> atualizarDevice() async {
    try {
      final supabase = Supabase.instance.client;

      if (widget.organizationId <= 0) {
        throw Exception("ID da organização inválido.");
      }

      final int deviceType = selectedDeviceType == "entrada" ? 1 : 2;

      final response = await supabase.from("devices").upsert({
        "organization_id": widget.organizationId,
        "device_type": deviceType,
      });

      if (response.error != null) {
        throw Exception("Erro ao atualizar dispositivo: ${response.error!.message}");
      }

      print("Dispositivo atualizado com sucesso: Tipo $deviceType (Org ID: ${widget.organizationId})");
    } catch (error) {
      print("Erro ao atualizar dispositivo: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final h = screenWidth * 0.01;
    final v = screenWidth * 0.01;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.organizationName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    onTap: () {
                      // Implemente a ação de logout, se necessário.
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6 * h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20 * v, 0, 20 * v),
                  child: Text(
                    'Bem-vindo ao IdentifierFlow!',
                    style: TextStyle(
                      fontSize: 6 * h,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6 * h),
                  child: Text(
                    'Selecione o tipo de dispositivo:',
                    style: TextStyle(fontSize: 4 * h),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Botões de rádio para selecionar o tipo de dispositivo:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: "entrada",
                      groupValue: selectedDeviceType,
                      onChanged: (value) {
                        setState(() {
                          selectedDeviceType = value!;
                        });
                      },
                    ),
                    const Text("Entrada"),
                    Radio<String>(
                      value: "saida",
                      groupValue: selectedDeviceType,
                      onChanged: (value) {
                        setState(() {
                          selectedDeviceType = value!;
                        });
                      },
                    ),
                    const Text("Saída"),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6 * h, 80 * v, 6 * h, 0),
                  child: MyButton(
                    text: 'INICIAR RECONHECIMENTO',
                    onTap: () async {
                      // Atualiza (ou insere) o dispositivo no Supabase
                      await atualizarDevice();
                      // Navega para a página de reconhecimento, passando o deviceType selecionado
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceDetectorView(
                            deviceType: selectedDeviceType, organizationName: widget.organizationName ,
                          ),
                        ),
                      );
                    },
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
