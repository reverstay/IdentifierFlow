import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? h;
  final double? v;

  const MyButton({
    super.key,
    this.onTap,
    required this.text,
    this.h = 16.0, // Valor padrão para evitar erro caso não seja passado
    this.v = 12.0, // Valor padrão para garantir espaçamento adequado
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: h!, vertical: v!),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 1*h!,
            ),
          ),
        ),
      ),
    );
  }
}
