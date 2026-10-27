**1. Tablas, columnas y restricciones nuevas.**

Para integrar la propuesta dentro del proyecto asignado, creamos dos nuevas entidades: INFRAESTRUCTURA y REPORTE\_IA, la primera se trata de una entidad padre que acumula a tres subclases que representan la infraestructura crítica, cada una de las subclases cuentan con atributos diferentes, la segunda almacena las lecturas y reportes emitidos automáticamente por la IA sobre el estado y mantenimiento de estas infraestructuras críticas.



Tabla INFRAESTRUCTURA



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID\_Instalación|VARCHAR(12)|PK|
|ID\_Zona|INTEGER|FK|
|Institución Responsable|VARCHAR(40)|NOT NULL|
|Presupuesto|DECIMAL(20,2)|NOT NULL|
|Última inspección|DATE|NOT NULL|
|Estado de operabilidad|VARCHAR(10)|NOT NULL|



Tabla INSTALACIONES DE SERVICIO MÉDICO



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID\_Instalación|VARCHAR(12)|FK, PK|
|Salas médicas disponibles|INTEGER||
|Capacidad de pacientes|INTEGER||
|Nivel de especialización|VARCHAR(10)||



Tabla SERVICIO DE AGUA POTABLE



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID\_Instalación|VARCHAR(12)|FK, PK|
|Tipo de instalación|VARCHAR(30)|NOT NULL, CHECK|
|Material de tubería|VARCHAR(30)|NOT NULL|
|Número de bombas activas|INTEGER|NOT NULL|
|Capacidad de suministro en litros|INTEGER|NOT NULL|



Tabla ESTACIONES DE SERVICIO ELÉCTRICO



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID\_Instalación|VARCHAR(12)|FK|
|Tipo de estación|VARCHAR(30)|NOT NULL, CHECK|
|Número de transformadores|INTEGER|NOT NULL|
|Capacidad de suministro|DECIMAL(8,2)|NOT NULL, CHECK|



Para cubrir con los requisitos de IIA retomamos el issue que propuse en la práctica anterior, el cual consistía en añadir una IA que analizara los estados de mantenimiento y de operabilidad de las infraestructuras críticas y el lugar donde se guarda lo que el modelo produce es la entidad REPORTE\_IA, en el cual existen atributos que indican niveles de riesgo, urgencia de mantenimiento y posibles fallas para facilitar el monitoreo de las infraestructuras de cada zona.



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID\_reporte|INTEGER|PK|
|ID\_Instalación|VARCHAR(12)|FK|
|Anomalia detectada|VARCHAR(40)|NOT NULL|
|Acción recomendada|VARCHAR(200)|NOT NULL|
|Fecha de reporte|TIMESTAMP|NOT NULL|
|Versión del algoritmo|VARCHAR(20)|NOT NULL|





**2. Captura de ejecución de cambios.sql**



!\[Captura de ejecución exitosa de la integración de la modificación propuesta en el issue](../evidencias/Captura\_ejecucion\_sql.png)



**3. Consulta realizada después del cambio.**



!\[Consulta después de aplicar cambios](../evidencias/Consulta\_cambios.png)



**4. Justificación de reglas de transformación aplicadas y efectos en los datos existentes.**





ZONA ----- UBICA ----- INFRAESTRUCTURA ----- posee ----- REPORTE\_IA

&#x09;   (1:N) 			     (1:N)



En ambos casos observamos que la implementación del issue propuesto resulta en la creación de una entidad y una superclase conectadas entre sí en una relación (1:N), siguiendo las reglas de transformación el lado con cardinalidad muchos tiene la clave foránea de la entidad con cardilanidad 1, por lo tanto INFRAESTRUCTURA tendría el ID\_zona como llave foránea y a la vez REPORTE\_IA tendría ID\_Infraestructura como llave foránea.

Elegí tal como en el proyecto propio la estrategia de creación de tablas para todas las clases, es decir, se creó una tabla para la entidad padre INFRAESTRCTURA y las subclases: INSTALACIONES DE SERVICIOS MÉDICOS, INSTALACIONES DE AGUA POTABLE, INSTALACIONES DE SERVICIOS ELÉCTRICOS Y REPORTE\_IA, esta estrategia fue más fácil e implementar porque haber creado una sola tabla resultaría en un comando CREATE TABLE muy engorroso y confuso, mientras que seguir la tercer estrategia para entidades totalmente disjuntas crearía muchas tablas con valores repetidos. 



Efectos sobre los datos preexistentes: 

Las agregaciones hechas en la implementación de la propuesta no afectaron a los datos existentes del datawarehouse, únicamente se agregó una relación con dim\_zonas para poder ubicar las diferentes infraestructuras críticas, no se usó el comando ALTER TABLE mencionado en el documento de instrucciones de la práctica, lo que garantiza que ningún dato ajeno a la implementación fue modificado.

