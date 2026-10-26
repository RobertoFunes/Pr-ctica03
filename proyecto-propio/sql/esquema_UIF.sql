CREATE TABLE contribuyente (
    rfc VARCHAR(13) NOT NULL,
    calle VARCHAR(100) NOT NULL,
    codigo_postal CHAR(5) NOT NULL,
    actividad_economica VARCHAR(100) NOT NULL,
    e_firma VARCHAR(50) NOT NULL UNIQUE,
	CONSTRAINT llave_primaria PRIMARY KEY (rfc)
);

CREATE TABLE persona_fisica (
	rfc VARCHAR(13) PRIMARY KEY,
	curp VARCHAR(18) UNIQUE NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	ingresos DECIMAL(20,2) NOT NULL,
	CONSTRAINT llave_foranea_pf FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE persona_moral(
	rfc VARCHAR(13) PRIMARY KEY,
	representante_legal VARCHAR(50) NOT NULL,
	razon_social VARCHAR(50) NOT NULL,
	fecha_constitucion DATE NOT NULL,
	CONSTRAINT llave_foranea_pm FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE telefono (
	rfc VARCHAR(13)NOT NULL,
	numero VARCHAR(10) NOT NULL,
	CONSTRAINT primaria_contribuyente PRIMARY KEY (rfc, numero),
	CONSTRAINT foranea_contribuyente FOREIGN KEY (rfc) 
	REFERENCES contribuyente(rfc)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE lista_bloqueados (
    id_bloqueo INT NOT NULL,
    rfc VARCHAR(13) UNIQUE NOT NULL,
    fecha_bloqueo DATE NOT NULL,
    motivo VARCHAR(50),
    CONSTRAINT llave_primaria_lista PRIMARY KEY (id_bloqueo),
    CONSTRAINT fk_bloqueados_contribuyente FOREIGN KEY (rfc)
    REFERENCES contribuyente (rfc) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cuenta_bancaria (
    numero_cuenta VARCHAR(16) UNIQUE NOT NULL,
    rfc VARCHAR(13) NOT NULL,
    fecha_apertura DATE NOT NULL,
    saldo DECIMAL(20,2) NOT NULL,
    CONSTRAINT llave_primaria_cuenta PRIMARY KEY (numero_cuenta),
    CONSTRAINT llave_foranea_cuenta FOREIGN KEY (rfc)
    REFERENCES contribuyente (rfc) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bien (
    id_bien INT NOT NULL,
    tipo_bien VARCHAR(50) NOT NULL,
    valor_comercial DECIMAL(20,2) NOT NULL,
    CONSTRAINT llave_primaria_bien PRIMARY KEY (id_bien)
);

CREATE TABLE entidad_reportante (
    id_notario INT NOT NULL,
    nombre_institucion VARCHAR(50) NOT NULL,
    sector_economico VARCHAR(50) NOT NULL,
    CONSTRAINT llave_primaria_ PRIMARY KEY (id_notario)
);

CREATE TABLE operacion_vulnerable (
    id_operacion INT NOT NULL,
    rfc VARCHAR(13) NOT NULL,
    id_bien INT NOT NULL,
    id_notario INT NOT NULL,
    valor_pactado DECIMAL(20,2) NOT NULL,
    fecha_operacion DATE NOT NULL,
    CONSTRAINT primaria_operacion PRIMARY KEY (id_operacion),
    CONSTRAINT foranea_operacion FOREIGN KEY (rfc)
	REFERENCES contribuyente (rfc)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT foranea_operacion_bien FOREIGN KEY (id_bien)
    REFERENCES bien (id_bien)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT foranea_operacion_entidad FOREIGN KEY (id_notario)
    REFERENCES entidad_reportante (id_notario)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE reporte_uif (
    id_notario INT NOT NULL,
    id_reporte INT NOT NULL,
    tipo_reporte VARCHAR(50) NOT NULL,
    fecha_recepcion DATE NOT NULL,
    monto_total DECIMAL(20,2) NOT NULL,
    CONSTRAINT primaria_reporte PRIMARY KEY (id_reporte),
    CONSTRAINT foranea_reporte FOREIGN KEY (id_notario)
    REFERENCES entidad_reportante (id_notario)
   	ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE desglose (
    id_reporte INT NOT NULL,
    numero_renglon INT NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    monto DECIMAL(20,2) NOT NULL,
    divisa VARCHAR(10) DEFAULT 'MXN',
    CONSTRAINT primaria_desglose PRIMARY KEY (id_reporte, numero_renglon),
    CONSTRAINT foranea_desglose FOREIGN KEY (id_reporte)
	REFERENCES reporte_uif (id_reporte)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE transaccion (
    id_transaccion INT NOT NULL,
    cuenta_origen VARCHAR(16) NOT NULL,
    cuenta_destino VARCHAR(16) NOT NULL,
    monto DECIMAL(20,2) NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    CONSTRAINT primaria_transaccion PRIMARY KEY (id_transaccion),
    CONSTRAINT foranea_origen FOREIGN KEY (cuenta_origen)
        REFERENCES cuenta_bancaria (numero_cuenta)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT foranea_destino FOREIGN KEY (cuenta_destino)
        REFERENCES cuenta_bancaria (numero_cuenta)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE alerta (
    id_alerta INT NOT NULL,
    id_transaccion INT NOT NULL,
    fecha_alerta TIMESTAMP NOT NULL,
    nivel_riesgo VARCHAR(20) NOT NULL,
    CONSTRAINT primaria_alerta PRIMARY KEY (id_alerta),
    CONSTRAINT foranea_transaccion FOREIGN KEY (id_transaccion)
        REFERENCES transaccion (id_transaccion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE expediente (
    num_expediente INT NOT NULL UNIQUE,
    id_alerta INT NOT NULL,
    fecha_apertura DATE NOT NULL,
    fiscal_asignado VARCHAR(40) NOT NULL,
    CONSTRAINT primaria_expediente PRIMARY KEY (num_expediente),
    CONSTRAINT foranea_expediente FOREIGN KEY (id_alerta)
        REFERENCES alerta(id_alerta)
        ON DELETE RESTRICT ON UPDATE CASCADE
);