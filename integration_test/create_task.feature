Feature: Gestión de tareas

  Scenario: Crear una nueva tarea exitosamente
    Given la aplicacion esta iniciada
    When toco el icono de agregar
    And escribo {'Tarea 1'} en el campo {'Título'}
    And escribo {'Descripción de la tarea'} en el campo {'Descripción'}
    And toco el texto {'Guardar'}
    Then veo el texto {'Tarea 1'}

  Scenario: Intentar crear una tarea sin titulo muestra error
    Given la aplicacion esta iniciada
    When toco el icono de agregar
    And toco el texto {'Guardar'}
    Then veo el texto {'El título no puede estar vacío'}