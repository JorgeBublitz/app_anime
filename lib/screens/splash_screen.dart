// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import '../colors/app_colors.dart';
import '../api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;
  bool _mostrarCarregando = false;
  bool _erroCarregamento = false;

  @override
  void initState() {
    super.initState();
    _animar();
    _carregarDados();
  }

  void _animar() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.2;
      });
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _mostrarCarregando = true;
      });
    });
  }

  Future<void> _carregarDados() async {
    final conectado = await Connectivity().checkConnectivity();
    if (conectado == ConnectivityResult.none) {
      setState(() {
        _erroCarregamento = true;
        _mostrarCarregando = false;
      });
      return;
    }

    try {
      final dados = await Future.wait([
        topAnimes().timeout(const Duration(seconds: 10)),
        topMangas().timeout(const Duration(seconds: 10)),
      ]);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(animes: dados[0], mangas: dados[1]),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _erroCarregamento = true;
          _mostrarCarregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cor5,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 900),
          opacity: _opacity,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.5, end: _scale),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/splash.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:
                      _erroCarregamento
                          ? _erroWidget()
                          : _mostrarCarregando
                          ? const CircularProgressIndicator(
                            key: ValueKey('carregando'),
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                          : const SizedBox(key: ValueKey('vazio'), height: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _erroWidget() {
    return Column(
      key: const ValueKey('erro'),
      children: [
        const Text(
          'Sem conexão com a internet',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _erroCarregamento = false;
              _mostrarCarregando = true;
            });
            _carregarDados();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.cor5,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Tentar novamente',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
