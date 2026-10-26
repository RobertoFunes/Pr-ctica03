**1. Evidencias obligatorias del ejercicio 6.2:**

Después de haber terminado el esquema.sql tomamos una captura de pantalla de el resultado de la ejecución sin errores en pgAdmin.



!\[Prueba de ejecución sin errores](/evidencias/Ejecucion\_sin\_errores.png)



Y tomamos capturas de las tablas creadas:



!\[Tablas creadas](../evidencias/Listado\_Tablas.png)



a) Prueba de protección de datos 1: Intentaremos insertar una cuenta bancaria asignada a un RFC que no declaramos en la tabla de contribuyente, lo cual debe de provocar un error porque rompe con la integridad referencial, es decir, garantiza que no añada cosas por error a una entidad, contribuyente en este caso que no existe.



!\[Captura de código sql](../evidencias/error\_integridad\_referencial.png)



b) Prueba de protección de datos 2: 

Con un registro válido crearemos el registro de un contribuyente y luego registraremos a otro contribuyente usando el mismo RFC, así se comprueba que la base de datos no registra a dos contribuyentes con la misma llave primaria, garantizando la regla de unicidad.



!\[Captura de código sql](../evidencias/error\_unicidad.png)



c) Prueba de protección de datos 3:

Crearemos un registro en la tabla de entidad reportante en un espacio que tiene restricción de no nulidad, por lo que al introducir datos incompletos comprobaremos que la base de datos respeta las restricciones establecidas con DDL.



!\[Captura de código sql](../evidencias/error\_restricciones.png)

