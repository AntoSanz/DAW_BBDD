--APARTADO 1
/*
Listar por las ventas de medicamentos con receta realizadas por los m�dicos de cada centro de salud. 
Las columnas que visualizaremos son: poblaci�n del m�dico, centro de salud del m�dico, nombre medicamento, nombre laboratorio, fecha venta, unidades, precio unitario, total venta(unidades*precio unitario). 
S�lo listaremos aquellos medicamentos cuyas ventas se hayan realizado entre las fecha : 
01/10/2021 y 31/12/2021, y que el nombre de medicamento contenga las palabras: medicamento antibi�tico en cualquier lugar. 
Se ordenar� por poblaci�n, dentro de �sta por centro salud , por nombre medicamento y por fecha venta.
*/

SELECT 
    m_medicos.poblacion ,
    m_medicos.centro_salud, 
    m_medicamentos.nombre_med, 
    m_laboratorios.nombre_lab, 
    m_ventas_med.fecha_venta, 
    m_ventas_med.unidades,
    m_medicamentos.precio_unit, 
    (m_ventas_med.unidades * m_medicamentos.precio_unit) as TOTAL_VENTA 
FROM m_medicos 
    INNER JOIN m_ventas_recetas ON m_ventas_recetas.dnim = m_medicos.dnim
    INNER JOIN m_ventas_med ON m_ventas_recetas.id_venta = m_ventas_med.id_venta
    INNER JOIN m_medicamentos ON m_ventas_med.id_med = m_medicamentos.id_med
    INNER JOIN m_laboratorios ON m_medicamentos.id_lab = m_laboratorios.id_lab
WHERE m_ventas_med.fecha_venta >= CAST('01/10/2021' AS date) 
    AND m_ventas_med.fecha_venta <= CAST('31/12/2021' AS date) 
    AND UPPER(m_medicamentos.nombre_med) LIKE UPPER('MEDICAMENTO %ANTIBI_TICO%');
    

--APARTADO 2
/*
VERSI�N 1
 Listado del nombre de los medicamento y las cantidades en stock de aquellos medicamentos cuya presentaci�n sea jarabe y el nombre de su laboratorio contenga la palabra regional.
*/
    
SELECT 
    m_medicamentos.nombre_med, 
    SUM(m_medicamentos.stock) "STOCK", 
    m_presentaciones.nombre_pres 
FROM m_medicamentos
    INNER JOIN m_presentaciones ON m_medicamentos.id_pres = m_presentaciones.id_pres
    INNER JOIN m_laboratorios ON m_medicamentos.id_lab = m_medicamentos.id_lab
WHERE m_presentaciones.nombre_pres LIKE 'JAR_BE'
    AND UPPER(m_laboratorios.nombre_lab) LIKE UPPER('%REGIONAL%')
GROUP BY m_medicamentos.nombre_med,  m_presentaciones.nombre_pres;
    
/*
VERSION 2
S�lo saldr�n los medicamentos de los que hayan realizado m�s de una venta
*/
SELECT 
    m_medicamentos.nombre_med, 
    SUM(m_medicamentos.stock) "STOCK", 
    m_presentaciones.nombre_pres
FROM m_medicamentos
    INNER JOIN m_presentaciones ON m_medicamentos.id_pres = m_presentaciones.id_pres
    INNER JOIN m_laboratorios ON m_medicamentos.id_lab = m_medicamentos.id_lab
    INNER JOIN m_ventas_med ON m_ventas_med.id_med = m_medicamentos.id_med
WHERE m_presentaciones.nombre_pres LIKE 'JAR_BE'
    AND UPPER(m_laboratorios.nombre_lab) LIKE UPPER('%REGIONAL%')
    AND m_ventas_med.unidades > 1
GROUP BY m_medicamentos.nombre_med,  m_presentaciones.nombre_pres ;
        
   
--APARTADO 3
/*
VERSION 1
 Se quiere visualizar el nombre de cada familia , el n�mero de medicamentos vendidos y el total de las ventas (unidades * precio unitario) de esa familia. 
 Ordenado por nombre de la familia.
*/
        
SELECT 
    m_familias.nombre_fam, 
    SUM(m_ventas_med.unidades) "NRO_MEDICAMENTOS_VENDIDOS", 
    SUM(m_ventas_med.unidades * m_medicamentos.precio_unit) "TOTAL_VENTAS"  
FROM m_ventas_med
    INNER JOIN m_medicamentos ON m_ventas_med.id_med = m_medicamentos.id_med
    INNER JOIN m_familias ON m_medicamentos.id_fam = m_familias.id_fam
GROUP BY m_familias.nombre_fam 
ORDER BY m_familias.nombre_fam ;

    
/*
VERSI�N 2
Que s�lo salgan las familias en el que el n� total de medicamentos vendidos sea mayor de 15
*/
    
SELECT 
    m_familias.nombre_fam, 
    SUM(m_ventas_med.unidades) "NRO_MEDICAMENTOS_VENDIDOS", 
    SUM(m_ventas_med.unidades * m_medicamentos.precio_unit) "TOTAL_VENTAS"  
FROM m_ventas_med
    INNER JOIN m_medicamentos ON m_ventas_med.id_med = m_medicamentos.id_med
    INNER JOIN m_familias ON m_medicamentos.id_fam = m_familias.id_fam
GROUP BY m_familias.nombre_fam
HAVING  SUM(m_ventas_med.unidades) > 15
ORDER BY m_familias.nombre_fam;

/*
VERSI�N 3
Que s�lo salgan las familias en las que la media de sus ventas sea mayor que la media de todas las ventas de todos los medicamentos.
*/  
--Calcular la media de las ventas
SELECT 
    AVG(m_ventas_med.unidades * m_medicamentos.precio_unit) MEDIA_VENTAS 
FROM m_ventas_med
    INNER JOIN m_medicamentos ON m_ventas_med.id_med = m_medicamentos.id_med;

--Mostrar los valores que esten por encima de esa media    
SELECT 
    m_familias.nombre_fam, 
    SUM(m_ventas_med.unidades) "NRO_MEDICAMENTOS_VENDIDOS", 
    SUM(m_ventas_med.unidades * m_medicamentos.precio_unit) "TOTAL_VENTAS"  
FROM m_ventas_med
    INNER JOIN m_medicamentos ON m_ventas_med.id_med = m_medicamentos.id_med
    INNER JOIN m_familias ON m_medicamentos.id_fam = m_familias.id_fam
GROUP BY m_familias.nombre_fam
HAVING  SUM(m_ventas_med.unidades * m_medicamentos.precio_unit) > AVG(m_ventas_med.unidades * m_medicamentos.precio_unit)
ORDER BY m_familias.nombre_fam;

--APARTADO 4
/*
Visualizar de cada familia: 
nombre de la familia, nombre del medicamento dentro de cada familia del que haya menor n�mero de unidades en stock y el stock. 
Ordenado por el nombre de la familia.
*/

SELECT 
    F.NOMBRE_FAM, 
    M.NOMBRE_MED, 
    M.STOCK
FROM M_FAMILIAS F, M_MEDICAMENTOS M
WHERE F.ID_FAM = M.ID_FAM
AND M.STOCK = (SELECT MIN(STOCK)
				FROM M_MEDICAMENTOS
				WHERE ID_FAM = F.ID_FAM)
ORDER BY F.NOMBRE_FAM;

--APARTADO 5
/*Se listar� el apellido y nombre del paciente, poblaci�n, la suma de las unidades vendidas de medicamentos, 
total de sus ventas (unidades * precio venta) y fecha de la �ltima venta . 
S�lo de tendr�n en cuenta aquellos medicamentos que se hayan vendido m�s de 2 veces.
*/
    
SELECT 
    p.apellidos, 
    p.nombre, 
    p.poblacion, 
    SUM(vm.unidades) AS "SUMA UNIDADES MED. VENDIDOS", 
    SUM(vm.unidades*m.precio_unit) AS "TOTAL_COMPRADO", 
    MAX(vm.fecha_venta) "FECHA DE SU ULTIMA COMPRA"
FROM m_ventas_recetas VR
    INNER JOIN  m_pacientes P ON vr.dnip = p.dnip
    INNER JOIN m_ventas_med VM ON vm.id_venta = vr.id_venta
    INNER JOIN m_medicamentos M ON VM.id_med = M.id_med
GROUP BY p.apellidos, p.nombre, p.poblacion
HAVING COUNT(vm.unidades) >= 2;


--APARTADO 6
/*
Realiza un listado que nos indique el n� de productos que nos vende cada laboratorio. 
Saldr�n todos los laboratorios, aunque no nos venda ninguno. El listado saldr� del siguiente modo:
DESDE POBLACI�N EL LABORATORIO NOMBRE_LAB NOS VENDE 999 MEDICAMENTOS
*/
 
 SELECT 'DESDE ' ||lab.poblacion|| ' EL LABORATORIO ' || lab.nombre_lab || ' NOS VENDE ' ||SUM(NVL(vmed.unidades, 0)) || ' MEDICAMENTOS' AS LABORATORIOS 
 FROM m_laboratorios LAB
     LEFT OUTER JOIN m_medicamentos MED ON med.id_lab = lab.id_lab
     LEFT OUTER JOIN m_ventas_med VMED ON vmed.id_med = med.id_med 
GROUP BY lab.poblacion, lab.nombre_lab;    