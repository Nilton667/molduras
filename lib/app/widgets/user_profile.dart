import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key, required this.userName}) : super(key: key);
  final String userName;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 9,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
