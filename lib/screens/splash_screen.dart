import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../colors/app_colors.dart';
import '../api_service.dart';
import 'home_screen.dart';

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
    _iniciarAnimacoes();
    _carregarDados();
  }

  void _iniciarAnimacoes() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.2;
        });
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _mostrarCarregando = true;
        });
      }
    });
  }

  Future<void> _carregarDados() async {
    final conectividade = await Connectivity().checkConnectivity();

    if (conectividade == ConnectivityResult.none) {
      _mostrarErro();
      return;
    }

    try {
      final resultados = await Future.wait([
        ApiService.topAnimes().timeout(const Duration(seconds: 10)),
        ApiService.topMangas().timeout(const Duration(seconds: 10)),
      ]);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => HomeScreen(animes: resultados[0], mangas: resultados[1]),
        ),
      );
    } on TimeoutException catch (_) {
      _mostrarErro(mensagem: 'Tempo esgotado ao carregar dados.');
    } catch (e) {
      _mostrarErro(mensagem: 'Erro inesperado: $e');
    }
  }

  void _mostrarErro({String mensagem = 'Sem conexão com a internet'}) {
    if (mounted) {
      setState(() {
        _erroCarregamento = true;
        _mostrarCarregando = false;
      });
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
            builder:
                (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
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
          'Falha ao carregar os dados.',
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
