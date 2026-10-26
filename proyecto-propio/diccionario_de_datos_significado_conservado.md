# Diccionario de Datos

**Tabla: `contribuyente`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`rfc`|`VARCHAR(13)`|`PRIMARY KEY`|Clave primaria. Registro Federal de Contribuyentes.|
|`calle`|`VARCHAR(100)`|`NOT NULL`|Calle y número del domicilio fiscal del contribuyente.|
|`codigo\\\_postal`|`CHAR(5)`|`NOT NULL`|Código postal a 5 dígitos del domicilio fiscal.|
|`actividad\\\_economica`|`VARCHAR(100)`|`NOT NULL`|Giro comercial o profesión principal registrada.|
|`e\\\_firma`|`VARCHAR(50)`|`NOT NULL, UNIQUE`|Cadena alfanumérica única de la firma electrónica.|

\---

**Tabla: Persona\_fisica**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`rfc`|`VARCHAR(13)`|`PRIMARY KEY, FK`|Clave primaria y foránea que conecta con `contribuyente`.|
|`curp`|`VARCHAR(18)`|`NOT NULL, UNIQUE`|Clave Única de Registro de Población.|
|`nombre`|`VARCHAR(50)`|`NOT NULL`|Nombre completo de la persona física.|
|`ingresos`|`DECIMAL(20,2)`|`NOT NULL`|Monto de ingresos declarados o estimados.|

\---

**Tabla: `persona\\\_moral`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`rfc`|`VARCHAR(13)`|`PRIMARY KEY, FK`|Clave primaria y foránea que conecta con `contribuyente`.|
|`representante\\\_legal`|`VARCHAR(50)`|`NOT NULL`|Nombre del representante legal de la empresa.|
|`razon\\\_social`|`VARCHAR(50)`|`NOT NULL`|Nombre oficial de la empresa o sociedad.|
|`fecha\\\_constitucion`|`DATE`|`NOT NULL`|Fecha de creación formal de la persona moral.|

\---

**Tabla: `telefono`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`rfc`|`VARCHAR(13)`|`PK, FK, NOT NULL`|Clave foránea del contribuyente (parte de la clave compuesta).|
|`numero`|`VARCHAR(10)`|`PK, NOT NULL`|Número telefónico de contacto (parte de la clave compuesta).|

\---

**Tabla: `lista\\\_bloqueados`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|id\_bloqueo|INT|PRIMARY KEY|Identificador único del acuerdo de bloqueo.|
|rfc|VARCHAR(13)|FK, UNIQUE, NOT NULL|RFC del contribuyente al que se le aplica la medida.|
|fecha\_bloqueo|DATE|NOT NULL|Fecha de emisión de la medida cautelar.|
|motivo|VARCHAR(50)|—|Descripción breve de la razón legal del bloqueo.|

\---

**Tabla: `cuenta\\\_bancaria`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`numero\\\_cuenta`|`VARCHAR(16)`|`PRIMARY KEY`|Número de cuenta o CLABE interbancaria.|
|`rfc`|`VARCHAR(13)`|`FK, NOT NULL`|RFC del titular de la cuenta bancaria.|
|`fecha\\\_apertura`|`DATE`|`NOT NULL`|Fecha en la que se abrió la cuenta bancaria.|
|`saldo`|`DECIMAL(20,2)`|`NOT NULL`|Saldo actual de la cuenta bancaria.|

\---

**Tabla: `bien`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_bien`|`INT`|`PRIMARY KEY`|Identificador único del bien (mueble o inmueble).|
|`tipo\\\_bien`|`VARCHAR(50)`|`NOT NULL`|Clasificación del bien (ej. Inmueble, Joyería, Vehículo).|
|`valor\\\_comercial`|`DECIMAL(20,2)`|`NOT NULL`|Valor estimado o de avalúo del bien.|

\---

**Tabla: `entidad\\\_reportante`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_notario`|`INT`|`PRIMARY KEY`|ID de la entidad, sujeto obligado o notaría.|
|`nombre\\\_institucion`|`VARCHAR(50)`|`NOT NULL`|Nombre comercial o razón social de la entidad reportante.|
|`sector\\\_economico`|`VARCHAR(50)`|`NOT NULL`|Sector al que pertenece (ej. Bancario, Juegos, Inmobiliario).|

\---

**Tabla: `operacion\\\_vulnerable`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_operacion`|`INT`|`PRIMARY KEY`|Folio único de la operación detectada.|
|`rfc`|`VARCHAR(13)`|`FK, NOT NULL`|RFC del contribuyente o beneficiario de la operación.|
|`id\\\_bien`|`INT`|`FK, NOT NULL`|Referencia al bien involucrado en la transacción.|
|`id\\\_notario`|`INT`|`FK, NOT NULL`|Referencia a la entidad que atestiguó la operación.|
|`valor\\\_pactado`|`DECIMAL(20,2)`|`NOT NULL`|Monto final por el que se realizó la operación.|
|`fecha\\\_operacion`|`DATE`|`NOT NULL`|Fecha en la que se concretó la operación vulnerable.|

\---

**Tabla: `reporte\\\_uif`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_reporte`|`INT`|`PRIMARY KEY`|Folio único del reporte enviado a la UIF.|
|`id\\\_notario`|`INT`|`FK, NOT NULL`|Entidad reportante que emite este documento.|
|`tipo\\\_reporte`|`VARCHAR(50)`|`NOT NULL`|Clasificación (ej. Reporte de Operación Sospechosa).|
|`fecha\\\_recepcion`|`DATE`|`NOT NULL`|Fecha de ingreso del reporte al sistema central.|
|`monto\\\_total`|`DECIMAL(20,2)`|`NOT NULL`|Suma económica total que ampara el reporte.|

\---

**Tabla: `desglose`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_reporte`|`INT`|`PK, FK, NOT NULL`|Clave foránea del reporte al que pertenece (clave compuesta).|
|`numero\\\_renglon`|`INT`|`PK, NOT NULL`|Número de partida o línea del reporte (clave compuesta).|
|`descripcion`|`VARCHAR(500)`|`NOT NULL`|Detalle narrativo de la línea del reporte.|
|`monto`|`DECIMAL(20,2)`|`NOT NULL`|Monto específico reportado en este renglón.|
|`divisa`|`VARCHAR(10)`|`DEFAULT 'MXN'`|Moneda en la que se transaccionó (USD, MXN, EUR).|

\---

**Tabla: `transaccion`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_transaccion`|`INT`|`PRIMARY KEY`|Folio único de la transferencia interbancaria.|
|`cuenta\\\_origen`|`VARCHAR(16)`|`FK, NOT NULL`|Cuenta bancaria de la que salen los fondos.|
|`cuenta\\\_destino`|`VARCHAR(16)`|`FK, NOT NULL`|Cuenta bancaria receptora de los fondos.|
|`monto`|`DECIMAL(20,2)`|`NOT NULL`|Monto transferido entre las cuentas.|
|`fecha\\\_hora`|`TIMESTAMP`|`NOT NULL`|Fecha y hora exacta en la que se procesó el envío.|

\---

**Tabla: `alerta`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`id\\\_alerta`|`INT`|`PRIMARY KEY`|Identificador único de la alerta disparada.|
|`id\\\_transaccion`|`INT`|`FK, NOT NULL`|Transacción financiera sospechosa que generó la alerta.|
|`fecha\\\_alerta`|`TIMESTAMP`|`NOT NULL`|Momento exacto en que el sistema detonó la prevención.|
|`nivel\\\_riesgo`|`VARCHAR(20)`|`NOT NULL`|Clasificación de riesgo (Bajo, Medio, Alto).|

\---

**Tabla: `expediente`**

|Columna|Tipo de Dato|Restricciones|Descripción|
|-|-|-|-|
|`num\\\_expediente`|`INT`|`PRIMARY KEY`|Folio oficial de la carpeta de investigación de la UIF.|
|`id\\\_alerta`|`INT`|`FK, NOT NULL`|Alerta original que motivó la apertura de la investigación.|
|`fecha\\\_apertura`|`DATE`|`NOT NULL`|Fecha en la que se formalizó la investigación judicial.|
|`fiscal\\\_asignado`|`VARCHAR(40)`|`NOT NULL`|Nombre del funcionario encargado de llevar el caso.|



**Conservación del significado:**



Durante la transformación de MR a código SQL, observamos que perdimos la categoría de unión BENEFICIARIO FINAL que nos ayudaba a describir en el EER a todo contribuyente (persona moral o física) que estuviera ligada con una operación vulnerable, pero esto no afecta el significado de la base de datos, pues la relación "operación vulnerable" esta conectada mediante una llave foránea (rfc) con la entidad padre CONTRIBUYENTE y así ya no se depende del uso de la categoría de unión usada en el EER. 

