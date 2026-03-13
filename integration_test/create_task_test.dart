// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/la_aplicacion_esta_iniciada.dart';
import './step/toco_el_icono_de_agregar.dart';
import './step/escribo_en_el_campo.dart';
import './step/toco_el_texto.dart';
import './step/veo_el_texto.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Gestión de tareas''', () {
    testWidgets('''Crear una nueva tarea exitosamente''', (tester) async {
      await laAplicacionEstaIniciada(tester);
      await tocoElIconoDeAgregar(tester);
      await escriboEnElCampo(tester, 'Tarea 1', 'Título');
      await escriboEnElCampo(tester, 'Descripción de la tarea', 'Descripción');
      await tocoElTexto(tester, 'Guardar');
      await veoElTexto(tester, 'Tarea 1');
    });
    testWidgets('''Intentar crear una tarea sin titulo muestra error''',
        (tester) async {
      await laAplicacionEstaIniciada(tester);
      await tocoElIconoDeAgregar(tester);
      await tocoElTexto(tester, 'Guardar');
      await veoElTexto(tester, 'El título no puede estar vacío');
    });
  });
}
