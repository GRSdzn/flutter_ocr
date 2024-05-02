// кнопка включения/выключения фонарика
import 'package:flutter/material.dart';

class FlashToggleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const FlashToggleButton({
    required this.onPressed,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // style: ButtonStyle(),
      style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Установка радиуса на 10 пикселей
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(18),
          )),
      onPressed: onPressed,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
