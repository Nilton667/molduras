import 'package:flutter/material.dart';

class CustomMenuIconButton extends StatelessWidget {
  const CustomMenuIconButton({
    Key? key,
    required this.icon,
    this.iconSize = 18,
    this.iconColor = Colors.white,
    required this.title,
    required this.titleStyle,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final Color iconColor;

  final String title;
  final TextStyle titleStyle;

  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF1a2226),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: titleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
