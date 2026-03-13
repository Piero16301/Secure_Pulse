// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/la_aplicacion_esta_iniciada.dart';
import './step/toco_el_icono_de_agregar.dart';
import './step/escribo_en_el_campo.dart';
import './step/toco_el_texto.dart';
import './step/marco_la_casilla_del_item.dart';
import './step/toco_el_icono_de_filtro.dart';
import './step/veo_el_texto.dart';
import './step/no_veo_el_texto.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Filtrado de tareas por estado''', () {
    testWidgets('''Filtrar tareas pendientes y resueltas''', (tester) async {
      await laAplicacionEstaIniciada(tester);
      await tocoElIconoDeAgregar(tester);
      await escriboEnElCampo(tester, 'Vulnerabilidad SQL', 'Título');
      await escriboEnElCampo(tester, 'Falta parametrizar', 'Descripción');
      await tocoElTexto(tester, 'Guardar');
      await tocoElIconoDeAgregar(tester);
      await escriboEnElCampo(tester, 'Token expuesto', 'Título');
      await escriboEnElCampo(tester, 'Token en repo', 'Descripción');
      await tocoElTexto(tester, 'Guardar');
      await marcoLaCasillaDelItem(tester, 'Vulnerabilidad SQL');
      await tocoElIconoDeFiltro(tester);
      await tocoElTexto(tester, 'Resueltos');
      await veoElTexto(tester, 'Vulnerabilidad SQL');
      await noVeoElTexto(tester, 'Token expuesto');
      await tocoElIconoDeFiltro(tester);
      await tocoElTexto(tester, 'Pendientes');
      await veoElTexto(tester, 'Token expuesto');
      await noVeoElTexto(tester, 'Vulnerabilidad SQL');
    });
  });
}
