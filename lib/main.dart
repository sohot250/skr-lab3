import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isPressed = false;
  bool isPlaying = false;
  final confettiCtrl = ConfettiController();
  double rating = 0;

  @override
  void initState() {
    super.initState();

    confettiCtrl.addListener(() {
      setState(() {
        isPlaying = confettiCtrl.state == ConfettiControllerState.playing;
      });
    });

    controller = AnimationController(vsync: this);
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        controller.reset();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Lottie.asset('assets/delivery.json'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(fontSize: 28),
                ),
                icon: const Icon(Icons.delivery_dining, size: 42),
                label: const Text('Order Pizza'),
                onPressed: showDoneDialog),
            const SizedBox(height: 10),
            GestureDetector(
              onTapDown: (_) {
                setState(() => isPressed = true);
              },
              onTapUp: (_) {
                setState(() => isPressed = false);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    //กำหนดความ blur
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 100,
                      width: 300,
                      //กำหนดกล่องสี่เหลี่ยมสีขาวโปร่งใส
                      decoration: BoxDecoration(
                        //แบบกำหนดสี color
                        color: Colors.white.withOpacity(isPressed ? 0.4 : 0.3),
                        //แบบไล่เฉดสี
                        // gradient: const LinearGradient(
                        //     colors: [Colors.white60, Colors.white10],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 2, color: Colors.white30),
                      ),
                      child: Column(
                        children: [
                          Text('Rating: $rating',
                              style: const TextStyle(fontSize: 40)),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            updateOnDrag: true,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) => setState(() {
                              this.rating = rating;
                            }),
                          ),
                        ],
                      ),
                      // child: const Center(
                      //   child: Text('Order Pizza',
                      //       style:
                      //           TextStyle(fontSize: 40, color: Colors.white54)),
                      // ),
                    ),
                  )),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text(isPlaying ? 'Stop 😍' : 'Celebrate 🥳'),
              onPressed: () {
                if (isPlaying) {
                  confettiCtrl.stop();
                } else {
                  confettiCtrl.play();
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 80),
                textStyle: const TextStyle(fontSize: 28),
              ),
            ),
            ConfettiWidget(
              confettiController: confettiCtrl, shouldLoop: true,

              /// set direction
              // blastDirection: -pi / 2, //up
              // blastDirection: 0, //right
              // blastDirection: pi / 2, //down
              // blastDirection: pi, //left
              blastDirectionality: BlastDirectionality.explosive, //all

              /// set emission count
              emissionFrequency: 0.5, // 0.0 -> 1.0
              numberOfParticles: 20,

              /// set intensity
              minBlastForce: 10,
              maxBlastForce: 100,

              /// set speed
              gravity: 1.0, // 0.0 -> 1.0

              /// set shape or size
              createParticlePath: (size) {
                final path = Path();

                path.addOval(Rect.fromCircle(center: Offset.zero, radius: 6));
                return path;
              },

              /// set colors
              colors: const [
                Colors.red,
                Colors.green,
                Colors.yellow,
                Colors.blue,
                Colors.purpleAccent,
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDoneDialog() => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/done.json',
                  repeat: false,
                  controller: controller, onLoaded: (composition) {
                controller.duration = composition.duration;
                controller.forward();
              }),
              const Text('Enjoy your order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
            ],
          )));
}
