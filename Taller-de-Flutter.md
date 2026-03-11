# Taller de Flutter (intermedio): **SecurePulse** — App con patrones GoF + BDD + escaneo con MobSF

## Introducción

Vas a construir **SecurePulse**, una app Flutter pequeña pero “real”: lista/seguimiento de ítems (p. ej. *hallazgos*, *tareas de hardening* o *checks de seguridad*), con arquitectura guiada por **patrones GoF**, pruebas **BDD** (Gherkin) y un flujo de **seguridad** donde generas un APK y lo analizas con **MobSF**, consumiendo un resumen del reporte vía API para mostrarlo dentro de la app. MobSF es un framework open-source para análisis estático/dinámico de apps móviles. ([GitHub][1])

## Objetivo general (SMART)

En 1 taller, implementar una app Flutter con **arquitectura modular** basada en patrones GoF, **suite BDD ejecutable** sobre `integration_test`, y un **pipeline local** (o CI) que ejecute **MobSF** sobre el APK y exponga un **resumen** que la app pueda mostrar.

## Objetivos específicos

* Modelar dominio + UI con separación clara (presentación / aplicación / datos).
* Aplicar al menos **5 patrones GoF** (con intención y trade-offs).
* Escribir escenarios Gherkin y ejecutarlos con una herramienta BDD en Flutter.
* Construir APK en modo release/debug (según tu flujo) y correr análisis en MobSF.
* Consumir un resultado (JSON) del escaneo y presentarlo en una pantalla “Security”.

## Arquitectura y Flujo de la App

```
UI (Screens/Widgets)
   |
ViewModel/Controller  <-- Observer (notificaciones de estado)
   |
UseCases (Aplicación) <-- Command (acciones: crear/cerrar item)
   |
Repository (Contrato) <-- Strategy (fuente local/remota)
   |
DataSources
  - Local (archivo/SQLite) 
  - Remote (MobSF API) <-- Adapter (API -> modelo interno)
```

Flujo principal:

1. Usuario crea/edita “ítems” → 2) Persistencia local → 3) Corre BDD → 4) Genera APK → 5) MobSF analiza → 6) App muestra resumen “último escaneo”.

---

## Roadmap de Pasos (6)

1. **Definir dominio + UI base** y trazar la arquitectura (sin “sobre-ingeniería”).
2. **Patrones GoF en la capa de aplicación/datos** (Repository + Strategy + Factory).
3. **Patrones GoF en UI/estado** (Observer + Decorator/Adapter según caso).
4. **BDD en Flutter**: escenarios Gherkin y ejecución con `integration_test`.
5. **MobSF**: correr análisis y obtener reportes por API.
6. **Integración final**: pantalla Security + checklist de demo + rúbrica.

---

# Pasos detallados

## Paso 1: **Modelar el dominio y levantar la UI base**

* **Objetivo del paso:** Tener la app corriendo con un flujo CRUD mínimo (listar + crear + marcar como “resuelto”).
* **Conexión con la app:** Este dominio será el “hilo conductor” para patrones, BDD y seguridad.
* **Progresión del tema (básico → intermedio):**

  * Básico: entidades (`Item`, `Status`), pantalla lista, pantalla detalle.
  * Intermedio: separar *UI* de *casos de uso* (sin meter lógica en widgets).
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: setState local | Opción B: ViewModel/Controller simple (recomendada: **B**, para facilitar Observer/BDD).
* **Guía de implementación (sin solución completa):**

  * Carpetas sugeridas: `lib/ui`, `lib/domain`, `lib/application`, `lib/data`
  * `application/` define casos de uso: `CreateItem`, `ToggleResolved`, `ListItems`
* **Consultas sugeridas (docs oficiales/keywords):**

  * Búscalo como: “Flutter navigation 2.0 basics” (o Navigator clásico) en la doc de Flutter
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué lógica *no* debería vivir en el Widget?”
* **Checkpoint (lo que debes ver ahora):**

  * Puedes crear un ítem, verlo en lista, y cambiar su estado.
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): Validar título no vacío. **Criterio:** no permite guardar vacío.
  * Reto 2 (medio): Filtro por estado. **Criterio:** toggle “Pendientes / Resueltos”.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: “se pierde el estado al navegar” | Pista: “mueve estado a un controlador compartido”.
* **Extensión opcional:** Campo “severidad” (Low/Med/High) para cada ítem.

---

## Paso 2: **Aplicar Repository + Strategy + Factory en datos**

* **Objetivo del paso:** Persistir ítems con un contrato estable y poder cambiar el backend sin romper el resto.
* **Conexión con la app:** Base para integrar “fuente local” + luego “fuente MobSF” como lectura remota.
* **Progresión del tema (básico → intermedio):**

  * Básico: **Repository** como interfaz (`ItemsRepository`).
  * Intermedio: **Strategy** para elegir implementación (local vs mock vs remota) + **Factory** para construir dependencias por entorno.
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: implementación directa en UI | Opción B: `ItemsRepository` + `LocalItemsDataSource` (recomendada: **B**, reduce acoplamiento).
* **Guía de implementación (sin solución completa):**

  * `domain/items_repository.dart` (contrato)
  * `data/local_items_repository.dart` (implementación)
  * `data/repo_factory.dart` (Factory por flavor/env)
  * *Snippet (máx 10 líneas, idea):*

    ```dart
    abstract class ItemsRepository { Future<List<Item>> list(); }
    class RepoFactory {
      static ItemsRepository create({required Env env}) =>
        env == Env.dev ? LocalItemsRepository() : LocalItemsRepository();
    }
    ```
* **Consultas sugeridas (docs oficiales/keywords):**

  * Búscalo como: “dependency injection Flutter patterns” (sin casarte aún con un framework)
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué gana tu equipo si mañana cambias archivo → SQLite?”
* **Checkpoint:**

  * Al cerrar y abrir, los ítems siguen ahí (persistencia local funcionando).
* **Retos:**

  * Reto 1 (fácil): Agregar “borrar ítem”. **Criterio:** desaparece y no vuelve al reiniciar.
  * Reto 2 (medio): Implementación “InMemoryItemsRepository” para tests. **Criterio:** conmutas repos sin tocar UI.
* **Errores comunes & pistas:**

  * Síntoma: “todo depende de clases concretas” | Pista: “haz que la UI conozca solo interfaces”.
* **Extensión opcional:** “Exportar” lista a JSON (archivo local).

---

## Paso 3: **Observer para estado + Decorator/Adapter para enriquecer comportamiento**

* **Objetivo del paso:** Estado observable y composición limpia de features.
* **Conexión con la app:** Hará más fácil BDD (esperar estados), y preparar integración de seguridad.
* **Progresión (básico → intermedio):**

  * Básico: **Observer** (notificar cambios: loading/success/error).
  * Intermedio: **Decorator** para añadir “logging/telemetría” o “caching” sin tocar repos principal **o** **Adapter** para transformar formatos externos.
* **Decisiones de diseño (elige y justifica):**

  * Opción A: `ChangeNotifier` | Opción B: streams (recomendada: **A** si quieres simple y claro para el taller).
* **Guía de implementación:**

  * `ItemsController extends ChangeNotifier` con estados.
  * Decorator ejemplo: `LoggingItemsRepository(ItemsRepository inner)`
* **Consultas sugeridas:**

  * Búscalo como: “ChangeNotifier notifyListeners best practices” en Flutter
* **Preguntas catalizadoras:**

  * “¿Qué se rompe si mezclas IO + UI rebuilds sin control?”
* **Checkpoint:**

  * UI muestra spinner mientras carga y maneja error visible.
* **Retos:**

  * Reto 1 (fácil): Snackbar en error. **Criterio:** error siempre visible.
  * Reto 2 (medio): Decorator de cache en memoria. **Criterio:** segunda carga es instantánea.
* **Errores comunes & pistas:**

  * Síntoma: “setState called after dispose” | Pista: “revisa ciclo de vida y quién es dueño del controller”.
* **Extensión opcional:** Métrica simple: contador de acciones (create/toggle/delete).

---

## Paso 4: **BDD (Gherkin) ejecutable sobre integration_test**

* **Objetivo del paso:** Tener features Gherkin que prueben flujos reales de la app.
* **Conexión con la app:** Asegura que los patrones no solo “se ven bonitos”, sino que mantienen comportamiento correcto.
* **Progresión (básico → intermedio):**

  * Básico: escribir `.feature` con Given/When/Then.
  * Intermedio: mapear step-definitions a acciones sobre la UI (tap, enterText, expect).
* **Decisiones de diseño (elige y justifica):**

  * Opción A: `flutter_gherkin` | Opción B: `gherkin_integration_test` (recomendada: **B**, encaja directo con `integration_test`). ([Dart packages][2])
* **Guía de implementación (sin solución completa):**

  * Estructura sugerida:

    * `integration_test/bdd/features/create_item.feature`
    * `integration_test/bdd/steps/*.dart`
  * En pasos, usa `WidgetTester`/finders de Flutter.
* **Consultas sugeridas (docs oficiales/keywords):**

  * Búscalo como: “Flutter integration_test setup” en la doc de Flutter ([docs.flutter.dev][3])
  * Búscalo como: “gherkin_integration_test usage” en pub.dev ([Dart packages][2])
* **Preguntas catalizadoras:**

  * “¿Qué escenario describe mejor valor de negocio que un test unitario no cubre?”
* **Checkpoint:**

  * Ejecutas integración y pasa un feature: crear ítem → aparece en lista.
* **Retos:**

  * Reto 1 (fácil): Escenario de validación (no guardar vacío). **Criterio:** falla si permite vacío.
  * Reto 2 (medio): Escenario de filtro (pendientes/resueltos). **Criterio:** conteo coincide con UI.
* **Errores comunes & pistas:**

  * Síntoma: “tests flakey (a veces pasan, a veces no)” | Pista: “espera animaciones/frames y evita dependencias de tiempo fijo”.
* **Extensión opcional:** Tags en Gherkin (`@smoke`, `@regression`) y ejecución selectiva.

---

## Paso 5: **Ejecutar MobSF y obtener un resumen por API**

* **Objetivo del paso:** Analizar el APK con MobSF y extraer un resultado consumible (JSON) para el pipeline/app.
* **Conexión con la app:** La app mostrará “Último escaneo” (fecha, score/flags principales, hallazgos top).
* **Progresión (básico → intermedio):**

  * Básico: correr MobSF y escanear un APK manualmente.
  * Intermedio: automatizar vía **REST API** (subir/scan/report) y guardar un JSON reducido.
* **Decisiones de diseño (elige y justifica):**

  * Opción A: usar UI web de MobSF | Opción B: REST API (recomendada: **B**, repetible para CI). ([MobSF][4])
* **Guía de implementación (sin solución completa):**

  * 1. Genera APK (tu flujo habitual).
  * 2. MobSF: sube archivo → solicita scan → descarga reporte (JSON/PDF según necesidad).
  * 3. Reduce el reporte a `security_summary.json` (solo campos que mostrarás).
* **Consultas sugeridas (docs oficiales/keywords):**

  * Búscalo como: “MobSF documentation setup” en la doc de MobSF ([MobSF][4])
  * Búscalo como: “MobSF API upload scan report” en API docs ([mobsf.live][5])
* **Preguntas catalizadoras:**

  * “¿Qué hallazgos son accionables para el equipo vs ruido?”
* **Checkpoint:**

  * Tienes un `security_summary.json` generado desde un scan real.
* **Retos:**

  * Reto 1 (fácil): Guardar fecha + hash del APK en el resumen. **Criterio:** aparece en el JSON.
  * Reto 2 (medio): “Fail condition”: si cierto hallazgo crítico aparece, marca `status=fail`. **Criterio:** el resumen refleja fail/pass.
* **Errores comunes & pistas:**

  * Síntoma: “API responde 4xx/CSRF/auth” | Pista: “revisa headers/token y endpoint exacto del API docs”.
* **Extensión opcional:** Exportar además un PDF para auditoría.

---

## Paso 6: **Integrar el resumen de MobSF en la app (Adapter + pantalla Security)**

* **Objetivo del paso:** Mostrar en la app el “Último escaneo”: estado, fecha y 3–5 hallazgos destacados.
* **Conexión con la app:** Cierra el loop: desarrollo → BDD → seguridad → UI.
* **Progresión (básico → intermedio):**

  * Básico: leer `security_summary.json` local (asset o archivo).
  * Intermedio: **Adapter** para mapear JSON → `SecuritySummary` + repositorio dedicado `SecurityRepository`.
* **Decisiones de diseño (elige y justifica):**

  * Opción A: parseo directo en pantalla | Opción B: `SecurityRepository` + Adapter (recomendada: **B**, mantiene consistencia con tu arquitectura).
* **Guía de implementación:**

  * `domain/security_summary.dart`
  * `data/security_repository.dart`
  * `data/mobsf_summary_adapter.dart` (Adapter)
  * Pantalla `SecurityScreen` con estado: loading/success/error.
* **Consultas sugeridas:**

  * Búscalo como: “Flutter load json from assets” y “dart json decode model mapping”
* **Preguntas catalizadoras:**

  * “¿Qué info mínima necesita un PM para decidir ‘ship/no ship’?”
* **Checkpoint:**

  * Ves “Último escaneo: PASS/FAIL” + fecha + lista corta de hallazgos.
* **Retos:**

  * Reto 1 (fácil): Mostrar badge por severidad. **Criterio:** colores/etiquetas coherentes.
  * Reto 2 (medio): BDD scenario que valide que, con `status=fail`, aparece un banner rojo. **Criterio:** test pasa.
* **Errores comunes & pistas:**

  * Síntoma: “No se actualiza cuando cambia el archivo” | Pista: “define un botón ‘Refrescar’ y vuelve a cargar desde repos”.
* **Extensión opcional:** Historial de los últimos N escaneos.

---

# Integración final & Demo

**Ensamblaje (checklist):**

* [ ] App corre y hace CRUD de ítems.
* [ ] Repositorio desacoplado (Factory + Strategy).
* [ ] Estado observable (Observer).
* [ ] Decorator/Adapter aplicado con intención clara.
* [ ] BDD: al menos 2 features ejecutables.
* [ ] MobSF: scan ejecutado y `security_summary.json` generado.
* [ ] Pantalla Security muestra PASS/FAIL + hallazgos.

**Guion corto de demo (2–4 min):**

1. Crear ítem y marcar como resuelto.
2. Ejecutar BDD (mostrar salida verde).
3. Mostrar `security_summary.json` generado por MobSF.
4. Abrir pantalla Security y explicar 2 hallazgos y decisión de “ship/no ship”.

---

# Rúbrica de evaluación (0–5)

* **Funcionalidad (0–5):** 5 = CRUD completo + Security screen + flujo estable.
* **Calidad técnica (0–5):** 5 = patrones aplicados con justificación, bajo acoplamiento, nombres claros.
* **UX (0–5):** 5 = estados loading/error, feedback visible, navegación consistente.
* **Pruebas (0–5):** 5 = features BDD reproducibles, sin flakiness notable, cubren flujos clave.

---

# Material de apoyo

* Flutter: **Integration tests** (`integration_test`). ([docs.flutter.dev][3])
* MobSF: documentación oficial. ([MobSF][4])
* MobSF: REST API docs (para automatizar scans/reportes). ([mobsf.live][5])
* Pub.dev: `gherkin_integration_test`. ([Dart packages][2])
* Pub.dev: `flutter_gherkin` (referencia histórica/alternativa). ([Dart packages][6])

**Glosario breve**

* **GoF**: patrones de diseño clásicos (Factory, Strategy, Observer, Decorator, Adapter…).
* **BDD**: pruebas orientadas a comportamiento (Gherkin: Given/When/Then).
* **MobSF**: framework para análisis de seguridad de apps móviles (estático/dinámico). ([GitHub][1])

[1]: https://github.com/MobSF/Mobile-Security-Framework-MobSF "MobSF/Mobile-Security-Framework-MobSF"
[2]: https://pub.dev/documentation/gherkin_integration_test/latest/ "gherkin_integration_test - Dart API docs"
[3]: https://docs.flutter.dev/testing/integration-tests "Check app functionality with an integration test"
[4]: https://mobsf.github.io/docs/ "MobSF Documentation - Mobile Security Framework"
[5]: https://mobsf.live/api_docs "API Docs"
[6]: https://pub.dev/documentation/flutter_gherkin/latest/ "flutter_gherkin - Dart API docs"