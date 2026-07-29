import 'package:flutter/material.dart';
import 'package:involt/core/presentation/theme/app_colors.dart';
import 'package:involt/core/data/database.dart';
import 'package:involt/main.dart'; // To access MainNavigationScreen

class SplashScreen extends StatefulWidget {
  final AppDatabase db;
  const SplashScreen({super.key, required this.db});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerPosition;
  late Animation<double> _fullFillIntensity;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller (5 seconds loop for better timing)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // 1. Shimmer Position (Electric Burst) - 0% to 45% of total time
    _shimmerPosition = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 2.0), weight: 45),
      TweenSequenceItem(tween: ConstantTween(2.0), weight: 55),
    ]).animate(_animationController);

    // 2. Full Yellow Fill (Power Up) - Starts after the burst
    _fullFillIntensity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 40,
      ), // Wait for burst to reach half
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 15,
      ), // Powering up
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 25,
      ), // FULL ON - HOLD
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 10,
      ), // Shutting down
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10), // Pause
    ]).animate(_animationController);

    // Initial fade-in for the whole screen
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _fadeController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inMilliseconds < 5000) {
      await Future.delayed(
        Duration(milliseconds: 5000 - elapsed.inMilliseconds),
      );
    }
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MainNavigationScreen(db: widget.db),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1200),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onyx, // DARK MODE PREVALECE
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // REAL LOGO
              Image.asset('assets/logo.png', width: 140, height: 140),
              const SizedBox(height: 40),

              // Animated InVolt Text (ELECTRIC SHADER)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final fillIntensity = _fullFillIntensity.value;
                  final shimmerPos = _shimmerPosition.value;

                  // The "Burst" color is bright yellow/white
                  // The "Full" color is the brand electric yellow
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          // Base color interpolates from grey (offline) to yellow (powered)
                          Color.lerp(
                            Colors.white10,
                            Colors.yellow,
                            fillIntensity,
                          )!,
                          Color.lerp(
                            Colors.white10,
                            Colors.yellow,
                            fillIntensity,
                          )!,
                          Colors.yellowAccent, // Electric glow
                          Colors.white, // Spark core
                          Colors.yellowAccent, // Electric glow
                          Color.lerp(
                            Colors.white10,
                            Colors.yellow,
                            fillIntensity,
                          )!,
                          Color.lerp(
                            Colors.white10,
                            Colors.yellow,
                            fillIntensity,
                          )!,
                        ],
                        stops: [
                          0.0,
                          (shimmerPos - 0.5).clamp(0.0, 1.0),
                          (shimmerPos - 0.2).clamp(0.0, 1.0),
                          shimmerPos.clamp(0.0, 1.0),
                          (shimmerPos + 0.2).clamp(0.0, 1.0),
                          (shimmerPos + 0.5).clamp(0.0, 1.0),
                          1.0,
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'QARWAQIRU MICHAY',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
              Text(
                'SISTEMA DE GESTIÓN ELÉCTRICA',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                'Desarrollado por',
                style: TextStyle(
                  color: Colors.white10,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'INFIRA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
