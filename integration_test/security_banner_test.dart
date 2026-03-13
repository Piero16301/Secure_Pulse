// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/la_aplicacion_esta_iniciada.dart';
import './step/toco_el_icono_de_seguridad.dart';
import './step/veo_el_texto.dart';
import './step/veo_el_banner_rojo_de_error.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Pantalla de Seguridad MobSF''', () {
    testWidgets('''Mostrar banner rojo cuando el estado del escaneo es FAIL''',
        (tester) async {
      await laAplicacionEstaIniciada(tester);
      await tocoElIconoDeSeguridad(tester);
      await veoElTexto(tester, 'ESTADO: FAIL');
      await veoElBannerRojoDeError(tester);
    });
  });
}
