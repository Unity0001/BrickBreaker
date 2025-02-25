import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {

  final playerX;
  final playerWidht; 

  MyPlayer({this.playerX, this.playerWidht});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 0.9),
      child: ClipRRect(  
        borderRadius: BorderRadius.circular(10),    
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * playerWidht / 2,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}