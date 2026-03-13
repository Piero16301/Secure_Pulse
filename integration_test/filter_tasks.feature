Feature: Filtrado de tareas por estado

  Scenario: Filtrar tareas pendientes y resueltas
    Given la aplicacion esta iniciada
    
    # Se crea una tarea nueva
    When toco el icono de agregar
    And escribo {'Vulnerabilidad SQL'} en el campo {'Título'}
    And escribo {'Falta parametrizar'} en el campo {'Descripción'}
    And toco el texto {'Guardar'}
    
    # Se crea otra tarea nueva
    And toco el icono de agregar
    And escribo {'Token expuesto'} en el campo {'Título'}
    And escribo {'Token en repo'} en el campo {'Descripción'}
    And toco el texto {'Guardar'}

    # Se marca una tarea como resuelta
    And marco la casilla del item {'Vulnerabilidad SQL'}
    
    # Se prueba el filtro de Resueltos
    And toco el icono de filtro
    And toco el texto {'Resueltos'}
    Then veo el texto {'Vulnerabilidad SQL'}
    And no veo el texto {'Token expuesto'}

    # Se prueba el filtro de Pendientes
    When toco el icono de filtro
    And toco el texto {'Pendientes'}
    Then veo el texto {'Token expuesto'}
    And no veo el texto {'Vulnerabilidad SQL'}