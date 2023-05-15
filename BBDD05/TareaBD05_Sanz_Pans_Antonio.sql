--EJERCICIO 1
UPDATE m_ventas_recetas SET dnim='22222222B', dnip='10000000A' WHERE id_venta=25;
UPDATE m_ventas_recetas SET dnim='11111111A', dnip='20000000B' WHERE id_venta=28;
COMMIT;

--EJERCICIO 2
INSERT  INTO m_medicos (DNIM, APELLIDOS, NOMBRE, CENTRO_SALUD, POBLACION, PROVINCIA, TELEFONO) 
        VALUES ('11111112B', 'Sanz Herv�s', 'Maria', 'Centro Salud 1', 'Ciudad Real','Ciudad Real', 926212121);

INSERT  INTO m_medicos (DNIM, APELLIDOS, NOMBRE, CENTRO_SALUD, POBLACION, PROVINCIA) 
        VALUES ('11111113B', 'RAMOS CRUZ', 'JUAN', 'Centro Salud 3', 'DAIMIEL', 'CIUDAD REAL');

INSERT  INTO m_medicos (DNIM, APELLIDOS, NOMBRE, POBLACION, EMAIL) 
        VALUES ('11111114B', 'LAOS MIS', 'PEDRO', 'PUERTOLLANO', 'PLM@gmail.com');
        
INSERT  INTO m_medicos (DNIM, APELLIDOS, NOMBRE, PROVINCIA, MOVIL) 
        VALUES ('11111115B', 'Lagos Cort�s', 'Marina', 'TOLEDO',  622622622);
COMMIT; 

--EJERCICIO 3
INSERT INTO m_laboratorios (ID_LAB, NOMBRE_LAB, DIRECCION, POBLACION, PROVINCIA, TELEFONO, FAX, EMAIL)
        VALUES (
            5, 
            'FARMAREAL', 
            'AVENIDA UNIVERSIDAD', 
            (SELECT poblacion from m_laboratorios where id_lab = 3 ), 
            (SELECT poblacion from m_laboratorios where id_lab = 3 ), 
            926212121,
            926222222,
            'info@farmareal.com'
        );
COMMIT;

--EJERCICIO 4
/* Elimina de la tabla M_FAMILIAS el registro cuyo ID_FAM es 2 */
DELETE FROM m_familias WHERE m_familias.id_fam = 2;
COMMIT;

/* Elimina de la tabla M_PRESENTACIONES los registros de presentaciones que no est�n en ning�n medicamento. */
DELETE FROM m_presentaciones
WHERE id_pres NOT IN 
   (SELECT DISTINCT id_pres FROM m_medicamentos);
COMMIT;

/* Elimina de la tabla M_FAMILIAS los registros de las familias que no est�n en ning�n medicamento. */
DELETE FROM m_familias
WHERE id_fam NOT IN (SELECT DISTINCT id_fam FROM m_medicamentos);
COMMIT;

--EJERCICIO 5
/*A todos los medicamentos de las familias de Antiinflamatorios y Vacunas, se les aumentar� el stock en 10 unidades.*/
UPDATE m_medicamentos SET stock = (stock + 10) WHERE id_fam IN (2, 4);
COMMIT;

--EJERCICIO 6
/*En la tabla M_MEDICAMENTOS, actualiza el campo PRECIO_UNIT increment�ndolo un 10% a los medicamentos
que hayan vendido mas de 10 unidades en el a�o 2020*/
UPDATE m_medicamentos
SET precio_unit = precio_unit * 1.1
WHERE id_med IN (
  SELECT id_med
  FROM m_ventas_med
  WHERE fecha_venta >= TO_DATE('01/01/2020', 'DD/MM/YYYY')
  AND fecha_venta < TO_DATE('01/01/2021', 'DD/MM/YYYY')
  GROUP BY id_med
  HAVING SUM(unidades) > 10
);
COMMIT;

--EJERCICIO 7
/*Crear una tabla llamada M_TOTAL_VENTAS*/
CREATE TABLE M_TOTAL_VENTAS (
  ID_MED NUMBER(4) REFERENCES M_MEDICAMENTOS(ID_MED),
  UNIDADES_VENDIDAS NUMBER(6),
  TOTAL_VENTAS NUMBER(9,2)
);
COMMIT;

/*Insertar los datos en la tabla*/
INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(1, 13, 13*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 1));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(2, 7, 7*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 2));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(3, 2, 2*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 3));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(4, 1, 1*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 4));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(5, 4, 4*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 5));
INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(6, 6, 6*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 6));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(7, 7, 7*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 7));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(8, 4, 4*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 8));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(9, 4, 4*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 9));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(12, 6, 6*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 12));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(14, 11, 11*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 14));

INSERT INTO m_total_ventas (ID_MED, UNIDADES_VENDIDAS, TOTAL_VENTAS)
VALUES(16, 3, 3*(SELECT PRECIO_UNIT FROM m_medicamentos WHERE m_medicamentos.id_med = 16));

COMMIT;

--EJERCICIO 8
/*Actualizar la columna STOCK de M_MEDICAMENTOS.
Sumar todas las unidades vendidas de ese medicamento y restarlas al STOCK*/
UPDATE M_MEDICAMENTOS
SET STOCK = STOCK - (
  SELECT UNIDADES_VENDIDAS FROM M_TOTAL_VENTAS WHERE M_TOTAL_VENTAS.ID_MED = M_MEDICAMENTOS.ID_MED
);

COMMIT;