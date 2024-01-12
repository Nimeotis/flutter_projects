import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;

  Timer? waitingTimer;
  Timer? stoppableTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Test your \nreaction speed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: Color.fromARGB(0xFF,0x6D,0x6D,0x6D),
              child: SizedBox(
                height: 160, width: 300,
                child: Center(
                  child: Text(
                    millisecondsText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      switch (gameState) {
                        case GameState.readyToStart:
                          gameState = GameState.waiting;
                          millisecondsText = "";
                          _startWaitingTimer();
                          break;
                        case GameState.waiting:
                          gameState = GameState.canBeStopped;
                          break;
                        case GameState.canBeStopped:
                          gameState = GameState.readyToStart;
                          stoppableTimer?.cancel();
                          break;
                      }
                    }),
                    child: ColoredBox(
                      color: Colors.indigoAccent,
                      child: SizedBox(
                        height: 80,
                        width: 190,
                        child: Center(
                          child: Text(
                            _getButtonText(),
                            style: TextStyle(fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      backgroundColor: Color.fromARGB(0xFF,0x28,0x2E,0x3D),
    );
  }

  String _getButtonText()
  {
    switch (gameState){
      case GameState.readyToStart:
      return "Start";
      case GameState.waiting:
        return "Wait";
      case GameState.canBeStopped:
        return "Stop";
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000)+1000;
   waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }
  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick*16} ms";
      });
    });
  }
}

enum GameState { readyToStart, waiting, canBeStopped }