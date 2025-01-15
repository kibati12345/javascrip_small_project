import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(TrafficManagementApp());

class TrafficManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrafficDemo(),
    );
  }
}

class TrafficDemo extends StatefulWidget {
  @override
  _TrafficDemoState createState() => _TrafficDemoState();
}

class _TrafficDemoState extends State<TrafficDemo> {
  // Initial positions of the cars
  double car1X = 50.0;
  double car1Y = 150.0;
  double car2X = 150.0;
  double car2Y = 200.0;
  double parkedCarX = 200.0;
  double parkedCarY = 300.0; // This car doesn't move
  double myCarX = 100.0;
  double myCarY = 400.0;
  double car4X = 300.0;
  double car4Y = 100.0;

  // Speed variables
  final double car1Speed = 2.0; // Constant speed for Car 1
  final double car2Speed = 3.0; // Constant speed for Car 2
  final double car4Speed = 1.5; // Constant speed for Car 4
  double myCarSpeed = 0.0; // Dynamic speed for My Car

  // Directions for the arrows
  String car1Direction = "right";
  String car2Direction = "down";
  String car4Direction = "left";
  String myCarDirection = "up";

  // Data of the car "my car" is passing
  String passingCarDetails = "No car nearby";

  Timer? movementTimer;

  @override
  void initState() {
    super.initState();
    _startMovement(); // Start movement for predefined cars
  }

  @override
  void dispose() {
    movementTimer?.cancel();
    super.dispose();
  }

  // Function to start predefined car movements
  void _startMovement() {
    movementTimer = Timer.periodic(Duration(milliseconds: 50), (_) {
      setState(() {
        // Move Car 1 (to the right)
        car1X += car1Speed;
        if (car1X > MediaQuery.of(context).size.width) car1X = -50; // Loop back

        // Move Car 2 (downward)
        car2Y += car2Speed;
        if (car2Y > MediaQuery.of(context).size.height)
          car2Y = -50; // Loop back

        // Move Car 4 (to the left)
        car4X -= car4Speed;
        if (car4X < -50) car4X = MediaQuery.of(context).size.width; // Loop back
      });
    });
  }

  // Function to calculate speed for "My Car"
  double calculateSpeed(double deltaX, double deltaY) {
    return (deltaX.abs() + deltaY.abs()) / 2; // Arbitrary speed formula
  }

  // Function to move "My Car"
  void moveMyCar(double deltaX, double deltaY) {
    setState(() {
      myCarX += deltaX;
      myCarY += deltaY;
      myCarSpeed = calculateSpeed(deltaX, deltaY);
      myCarDirection = _getDirection(deltaX, deltaY);

      // Check proximity with other cars
      if ((myCarX - car1X).abs() < 50 && (myCarY - car1Y).abs() < 50) {
        passingCarDetails = "Passing Car 1: Speed: $car1Speed";
      } else if ((myCarX - car2X).abs() < 50 && (myCarY - car2Y).abs() < 50) {
        passingCarDetails = "Passing Car 2: Speed: $car2Speed";
      } else if ((myCarX - car4X).abs() < 50 && (myCarY - car4Y).abs() < 50) {
        passingCarDetails = "Passing Car 4: Speed: $car4Speed";
      } else if ((myCarX - parkedCarX).abs() < 50 &&
          (myCarY - parkedCarY).abs() < 50) {
        passingCarDetails = "Passing Parked Car: Stationary";
      } else {
        passingCarDetails = "No car nearby";
      }
    });
  }

  // Determine the direction of the car based on movement
  String _getDirection(double deltaX, double deltaY) {
    if (deltaX.abs() > deltaY.abs()) {
      return deltaX > 0 ? "right" : "left";
    } else {
      return deltaY > 0 ? "down" : "up";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traffic Management Demo"),
      ),
      body: Stack(
        children: [
          // Road Background
          Positioned.fill(
            child: CustomPaint(
              painter: RoadPainter(),
            ),
          ),

          // Car 1 (blue)
          Positioned(
            left: car1X,
            top: car1Y,
            child: _build3DCar(color: Colors.blue, direction: car1Direction),
          ),

          // Car 2 (red)
          Positioned(
            left: car2X,
            top: car2Y,
            child: _build3DCar(color: Colors.red, direction: car2Direction),
          ),

          // Parked Car (yellow)
          Positioned(
            left: parkedCarX,
            top: parkedCarY,
            child: _build3DCar(color: Colors.yellow, direction: "stationary"),
          ),

          // Car 4 (purple)
          Positioned(
            left: car4X,
            top: car4Y,
            child: _build3DCar(color: Colors.purple, direction: car4Direction),
          ),

          // My Car (green)
          Positioned(
            left: myCarX,
            top: myCarY,
            child: _build3DCar(color: Colors.green, direction: myCarDirection),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display car details at the bottom
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Text(
              passingCarDetails,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Control buttons for "My Car" only
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_upward),
                onPressed: () => moveMyCar(0, -10), // Move up
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => moveMyCar(-10, 0), // Move left
              ),
              IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () => moveMyCar(0, 10), // Move down
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => moveMyCar(10, 0), // Move right
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3D Car Widget with direction indicator
  Widget _build3DCar({required Color color, required String direction}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                offset: Offset(2, 4),
              ),
            ],
          ),
        ),
        // Directional arrow
        if (direction != "stationary")
          Positioned(
            top: direction == "up" ? 5 : null,
            bottom: direction == "down" ? 5 : null,
            left: direction == "left" ? 5 : null,
            right: direction == "right" ? 5 : null,
            child: Icon(
              direction == "up"
                  ? Icons.arrow_upward
                  : direction == "down"
                      ? Icons.arrow_downward
                      : direction == "left"
                          ? Icons.arrow_back
                          : Icons.arrow_forward,
              size: 16,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}

// Road painter to draw background
class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    // Draw road as a grey background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
