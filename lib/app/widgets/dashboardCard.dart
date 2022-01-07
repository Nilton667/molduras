import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboardcard extends StatelessWidget {
  Dashboardcard({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final Color color;
  final IconData icon;
  final String label;
  final int value;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          //height: 100,
          width: Get.width,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset.zero,
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: 100,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                  color: color,
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
