Feature: Pantalla de Seguridad MobSF

  Scenario: Mostrar banner rojo cuando el estado del escaneo es FAIL
    Given la aplicacion esta iniciada
    When toco el icono de seguridad
    Then veo el texto {'ESTADO: FAIL'}
    And veo el banner rojo de error