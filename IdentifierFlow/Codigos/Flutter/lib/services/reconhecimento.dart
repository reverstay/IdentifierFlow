import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'detector_view.dart';
import 'painters/face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {
final String deviceType; // "entrada" ou "saida"
final String organizationName; // Nome da organização para ser incluído no nome da foto

const FaceDetectorView({
Key? key,
required this.deviceType,
required this.organizationName,
}) : super(key: key);

@override
State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
final FaceDetector _faceDetector = FaceDetector(
options: FaceDetectorOptions(
enableContours: true,
enableLandmarks: true,
),
);

bool _canProcess = true;
bool _isBusy = false;
CustomPaint? _customPaint;
String? _text;
var _cameraLensDirection = CameraLensDirection.front;
bool _photoTaken = false; // Evita múltiplas capturas seguidas

// Variável para armazenar o CameraController recebido pelo callback
CameraController? _cameraController;

@override
void dispose() {
_canProcess = false;
_faceDetector.close();
_cameraController?.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return DetectorView(
title: 'Face Detector',
customPaint: _customPaint,
text: _text,
onImage: _processImage,
initialCameraLensDirection: _cameraLensDirection,
onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
// Recebe o CameraController assim que a câmera for inicializada
onCameraInitialized: (controller) {
_cameraController = controller;
},
);
}

Future<void> _processImage(InputImage inputImage) async {
if (!_canProcess || _isBusy) return;
_isBusy = true;
setState(() {
_text = '';
});

final faces = await _faceDetector.processImage(inputImage);

if (inputImage.metadata?.size != null &&
inputImage.metadata?.rotation != null) {
final painter = FaceDetectorPainter(
faces,
inputImage.metadata!.size,
inputImage.metadata!.rotation,
_cameraLensDirection,
// Callback acionado quando uma face é detectada
() async {
print("Rosto detectado!");
if (!_photoTaken) {
_photoTaken = true; // Evita múltiplas capturas rápidas
await _capturarEEnviarFoto();
Future.delayed(Duration(seconds: 3), () {
_photoTaken = false; // Permite nova captura após um tempo
});
}
},
);

_customPaint = CustomPaint(painter: painter);
} else {
String text = 'Faces found: ${faces.length}\n\n';
for (final face in faces) {
text += 'face: ${face.boundingBox}\n\n';
}
_text = text;
_customPaint = null;
}

_isBusy = false;
if (mounted) {
setState(() {});
}
}

/// Função para capturar uma foto a partir do feed da câmera e enviá-la ao Supabase Storage.
/// O nome da imagem será formado com o prefixo (entrada_ ou saida_), seguido do nome da organização,
/// e um timestamp para garantir a unicidade do nome.
Future<void> _capturarEEnviarFoto() async {
if (_cameraController == null || !_cameraController!.value.isInitialized) {
print("CameraController não disponível ou não inicializado.");
return;
}

try {
// Captura a foto utilizando o CameraController
XFile file = await _cameraController!.takePicture();
// Gera o nome do arquivo no formato: "entrada_nomeOrganizacao_timestamp.jpg"
String fileName =
"${widget.deviceType}_${widget.organizationName}_${DateTime.now().millisecondsSinceEpoch}.jpg";
final supabase = Supabase.instance.client;

// Upload da imagem para o Supabase Storage
await supabase.storage.from("imagens").upload(fileName, File(file.path));

// Obtém a URL pública da imagem (opcional)
final String publicUrl =
supabase.storage.from("imagens").getPublicUrl(fileName);

print("Imagem enviada com sucesso: $publicUrl");
} catch (e) {
print("Erro ao capturar ou enviar imagem: $e");
}
}
}
