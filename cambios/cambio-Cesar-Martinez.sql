-- =============================================================================
-- INSTITUTO POLITÉCNICO NACIONAL - ESCOM
-- Asignatura: Bases de Datos
-- Práctica 3 - Ejercicio 8: Cambio de Esquema por Integrante
-- Estudiante: César Javier Martínez Ruíz (GitHub: @prdx919)
-- Issue de Referencia: #7 - "Actualización automática de datos"
-- Área de Especialidad: Ingeniería en Inteligencia Artificial
-- =============================================================================

-- 1. Tabla para control y auditoría de la ingesta automatizada programada (SSN)
CREATE TABLE IF NOT EXISTS control_ingesta_automatica (
    id_lote SERIAL PRIMARY KEY,
    fecha_inicio_ingesta TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_fin_ingesta TIMESTAMP WITH TIME ZONE,
    fuente_origen VARCHAR(150) DEFAULT 'Servicio Sismológico Nacional (SSN) API/RSS',
    total_registros_procesados INT DEFAULT 0,
    estado_proceso VARCHAR(30) DEFAULT 'EXITOSO' CHECK (estado_proceso IN ('INICIADO', 'EXITOSO', 'ERROR', 'PARCIAL'))
);

-- 2. Tabla para almacenar las predicciones y detección de anomalías generadas por el modelo de IA
--    Cumple con el requisito de IA: registra la predicción/anomalía, marca de tiempo, 
--    versión del modelo y referencia al hecho/sismo calificado.
CREATE TABLE IF NOT EXISTS predicciones_ia_sismos (
    id_prediccion SERIAL PRIMARY KEY,
    id_sismo INT NOT NULL,
    id_lote_ingesta INT,
    tipo_modelo VARCHAR(50) NOT NULL DEFAULT 'IsolationForest_XGBoost',
    es_anomalia BOOLEAN NOT NULL,
    score_anomalia DOUBLE PRECISION NOT NULL,
    clase_riesgo_predicha VARCHAR(20) NOT NULL CHECK (clase_riesgo_predicha IN ('BAJO', 'MODERADO', 'ALTO', 'CRITICO')),
    probabilidad_confianza DOUBLE PRECISION NOT NULL CHECK (probabilidad_confianza >= 0.0 AND probabilidad_confianza <= 1.0),
    version_modelo VARCHAR(50) NOT NULL,
    timestamp_prediccion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    detalles_inferencia JSONB,
    CONSTRAINT fk_prediccion_sismo FOREIGN KEY (id_sismo) 
        REFERENCES dim_sismos(id_sismo) ON DELETE CASCADE,
    CONSTRAINT fk_prediccion_lote FOREIGN KEY (id_lote_ingesta) 
        REFERENCES control_ingesta_automatica(id_lote) ON DELETE SET NULL
);

-- 3. Índices analíticos para optimizar consultas en tiempo real y gobernanza de modelos
CREATE INDEX IF NOT EXISTS idx_pred_ia_sismo ON predicciones_ia_sismos(id_sismo);
CREATE INDEX IF NOT EXISTS idx_pred_ia_anomalia ON predicciones_ia_sismos(es_anomalia) WHERE es_anomalia = TRUE;
CREATE INDEX IF NOT EXISTS idx_pred_ia_version ON predicciones_ia_sismos(version_modelo);
CREATE INDEX IF NOT EXISTS idx_pred_ia_timestamp ON predicciones_ia_sismos(timestamp_prediccion);

-- 4. Inserción de lote de ingesta automática simulada
INSERT INTO control_ingesta_automatica (
    fecha_inicio_ingesta, fecha_fin_ingesta, fuente_origen, total_registros_procesados, estado_proceso
) VALUES 
('2026-10-28 06:00:00-06', '2026-10-28 06:02:15-06', 'Servicio Sismológico Nacional (SSN) - Sincronización Diaria Automática', 5, 'EXITOSO');

-- 5. Inserción de inferencias generadas por el pipeline de IA sobre sismos reales de la base
INSERT INTO predicciones_ia_sismos (
    id_sismo, id_lote_ingesta, tipo_modelo, es_anomalia, score_anomalia, clase_riesgo_predicha, 
    probabilidad_confianza, version_modelo, timestamp_prediccion, detalles_inferencia
) VALUES
(0, 1, 'IsolationForest_XGBoost', TRUE, 0.9425, 'CRITICO', 0.975, 'seismic-detector-v2.1', '2026-10-28 06:02:16-06', '{"algoritmo": "IsolationForest+XGBoost", "features": ["magnitud", "profundidad", "aceleracion_pga"], "tiempo_inferencia_ms": 14.2}'),
(1, 1, 'IsolationForest_XGBoost', TRUE, 0.8812, 'ALTO', 0.920, 'seismic-detector-v2.1', '2026-10-28 06:02:17-06', '{"algoritmo": "IsolationForest+XGBoost", "features": ["magnitud", "profundidad", "aceleracion_pga"], "tiempo_inferencia_ms": 12.8}'),
(2, 1, 'IsolationForest_XGBoost', TRUE, 0.8650, 'ALTO', 0.895, 'seismic-detector-v2.1', '2026-10-28 06:02:18-06', '{"algoritmo": "IsolationForest+XGBoost", "features": ["magnitud", "profundidad", "aceleracion_pga"], "tiempo_inferencia_ms": 13.1}'),
(3, 1, 'IsolationForest_XGBoost', TRUE, 0.9120, 'CRITICO', 0.960, 'seismic-detector-v2.1', '2026-10-28 06:02:19-06', '{"algoritmo": "IsolationForest+XGBoost", "features": ["magnitud", "profundidad", "aceleracion_pga"], "tiempo_inferencia_ms": 11.9}'),
(4, 1, 'IsolationForest_XGBoost', TRUE, 0.9350, 'CRITICO', 0.982, 'seismic-detector-v2.1', '2026-10-28 06:02:20-06', '{"algoritmo": "IsolationForest+XGBoost", "features": ["magnitud", "profundidad", "aceleracion_pga"], "tiempo_inferencia_ms": 15.0}');
