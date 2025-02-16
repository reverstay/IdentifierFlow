import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
      this.faces,
      this.imageSize,
      this.rotation,
      this.cameraLensDirection,
      this.onFaceDetected,
      );

  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final Function()? onFaceDetected;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.yellow;

    if (faces.isEmpty) return;

    // **Filtrar o rosto mais próximo (o maior na tela)**
    Face? closestFace;
    double maxArea = 0;

    for (final Face face in faces) {
      double area = face.boundingBox.width * face.boundingBox.height;
      if (area > maxArea) {
        maxArea = area;
        closestFace = face;
      }
    }

    if (closestFace != null) {
      final left = translateX(
        closestFace.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        closestFace.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        closestFace.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateY(
        closestFace.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      final double cornerLength = 20.0;

      final bool isFrontCamera = cameraLensDirection == CameraLensDirection.front;

      if (!isFrontCamera) {
        canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), paint1);
        canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), paint1);

        canvas.drawLine(Offset(right, top), Offset(right - cornerLength, top), paint1);
        canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), paint1);

        canvas.drawLine(Offset(left, bottom), Offset(left + cornerLength, bottom), paint1);
        canvas.drawLine(Offset(left, bottom), Offset(left, bottom - cornerLength), paint1);

        canvas.drawLine(Offset(right, bottom), Offset(right - cornerLength, bottom), paint1);
        canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLength), paint1);
      } else {
        canvas.drawLine(Offset(right, top), Offset(right + cornerLength, top), paint1);
        canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), paint1);

        canvas.drawLine(Offset(left, top), Offset(left - cornerLength, top), paint1);
        canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), paint1);

        canvas.drawLine(Offset(right, bottom), Offset(right + cornerLength, bottom), paint1);
        canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLength), paint1);

        canvas.drawLine(Offset(left, bottom), Offset(left - cornerLength, bottom), paint1);
        canvas.drawLine(Offset(left, bottom), Offset(left, bottom - cornerLength), paint1);
      }

      // **Chamar a função para capturar foto quando um rosto for detectado**
      if (onFaceDetected != null) {
        onFaceDetected!();
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

// Função para tirar uma foto e salvar no diretório temporário
Future<File> takePicture(CameraController controller) async {
  if (!controller.value.isInitialized) {
    throw Exception("Câmera não está inicializada");
  }

  final Directory tempDir = await getTemporaryDirectory();
  final String filePath = '${tempDir.path}/face_detected.jpg';

  try {
    final XFile file = await controller.takePicture();
    final File imageFile = File(filePath);
    await file.saveTo(imageFile.path);
    return imageFile;
  } catch (e) {
    throw Exception("Erro ao capturar a imagem: $e");
  }
}
