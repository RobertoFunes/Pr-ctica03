--Prueba de integridad referencial
INSERT INTO cuenta_bancaria (numero_cuenta, rfc, fecha_apertura, saldo)
VALUES ('1234567890123456', 'RFCINVENTADO9', '2026-10-25', 15000.50);

--Prueba de unicidad
INSERT INTO contribuyente (rfc, calle, codigo_postal, actividad_economica, e_firma)
VALUES ('GARG850101XYZ', 'Av. Reforma 222', '06600', 'Servicios Financieros', 'FIRMADEPRUEBA1');

INSERT INTO contribuyente (rfc, calle, codigo_postal, actividad_economica, e_firma)
VALUES ('GARG850101XYZ', 'Calle Juárez 10', '01000', 'Comercio', 'OTRAFIRMA2');

--Prueba de restricción 
INSERT INTO entidad_reportante (id_notario, nombre_institucion, sector_economico)
VALUES (101, NULL, 'Notaría Pública');