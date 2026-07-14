import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width : 128,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFC2E8FF),width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(.12),
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Image(image: AssetImage("assets/images/logo.png") , fit: BoxFit.fill,),
    );
  }
}
