CREATE TABLE infraestructura (
    id_instalacion VARCHAR(12) NOT NULL,
    id_zona INTEGER NOT NULL,
    institucion_responsable VARCHAR(40) NOT NULL,
    presupuesto DECIMAL(20,2) NOT NULL,
    ultima_inspeccion DATE NOT NULL,
    estado_operabilidad VARCHAR(10) NOT NULL,
    CONSTRAINT primaria_infraestructura PRIMARY KEY (id_instalacion),
    CONSTRAINT operabilidad CHECK (estado_operabilidad IN ('OPTIMO', 'REGULAR', 'CRITICO')),
    CONSTRAINT foranea_zona FOREIGN KEY (id_zona) REFERENCES dim_zonas (id_zonas)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE instalacion_medica (
    id_instalacion VARCHAR(12) NOT NULL,
    salas_disponibles INTEGER NOT NULL,
    capacidad_pacientes INTEGER NOT NULL,
	nivel_especializacion VARCHAR(10) NOT NULL,
    CONSTRAINT primaria_instalacion_medica PRIMARY KEY (id_instalacion),
    CONSTRAINT med_nivel CHECK (nivel_especializacion IN ('PRIMER', 'SEGUNDO', 'TERCER')),
    CONSTRAINT foranea_medica_infraestructura FOREIGN KEY (id_instalacion)
        REFERENCES infraestructura (id_instalacion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE estacion_agua_potable (
    id_instalacion VARCHAR(12) NOT NULL,
    tipo_instalacion VARCHAR(30) NOT NULL,
    mateiral_tuberia VARCHAR(20) NOT NULL,
    numero_bombas_activas INTEGER NOT NULL,
	capacidad_suministro INTEGER NOT NULL,
    CONSTRAINT primaria_estacion PRIMARY KEY (id_instalacion),
    CONSTRAINT agua_tipo CHECK (tipo_instalacion IN ('POZO', 'REBOMBEO', 'POTABILIZADORA', 'TANQUE')),
    CONSTRAINT foranea_agua_infraestructura FOREIGN KEY (id_instalacion)
        REFERENCES infraestructura (id_instalacion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE instalacion_electrica (
    id_instalacion VARCHAR(12) NOT NULL,
    tipo_estacion VARCHAR(30) NOT NULL,
    capacidad_suministro DECIMAL (8,2) NOT NULL,
    numero_transformadores INTEGER NOT NULL,
    CONSTRAINT primaria_instalacion PRIMARY KEY (id_instalacion),
    CONSTRAINT elec_tipo CHECK (tipo_estacion IN ('SUBESTACION', 'PLANTA_GENERACION', 'LINEA_TRANSMISION')),
    CONSTRAINT foranea_electrica FOREIGN KEY (id_instalacion)
        REFERENCES infraestructura (id_instalacion)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reporte_ia (
    id_reporte INTEGER NOT NULL,
    id_instalacion VARCHAR(12) NOT NULL,
    anomalia_detectada VARCHAR(50) NOT NULL,
    accion_recomendada VARCHAR(200) NOT NULL,
    marca_tiempo TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    version_modelo VARCHAR(20) NOT NULL,
    CONSTRAINT primaria_reporte_ia PRIMARY KEY (id_reporte),
    CONSTRAINT foranea_reporte FOREIGN KEY (id_instalacion)
        REFERENCES infraestructura (id_instalacion)
        ON DELETE CASCADE ON UPDATE CASCADE
);