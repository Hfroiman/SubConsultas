-- Actividad 2.4
-- #
-- Consulta
-- 1
-- La patente, apellidos y nombres del agente que labró la multa y monto de aquellas multas que superan el monto promedio.


SELECT AVG(m.monto) FROM Multas m
SELECT m.Patente, a.Apellidos, a.Nombres, m.monto FROM Agentes a INNER JOIN Multas m on a.idagente=m.idagente where m.monto>(SELECT AVG(m.monto) FROM Multas m)


-- 2
-- Las multas que sean más costosas que la multa más costosa por 'No respetar señal de stop'.


SELECT MAX(m.monto) FROM Multas m INNER JOIN TipoInfracciones ti on m.idtipoinfraccion=ti.idtipoinfraccion WHERE ti.descripcion = 'No respetar señal de stop'

SELECT * FROM Multas m WHERE m.monto>(SELECT MAX(m.monto) FROM Multas m INNER JOIN TipoInfracciones ti on m.idtipoinfraccion=ti.idtipoinfraccion WHERE ti.descripcion = 'No respetar señal de stop')


-- 3
-- Los apellidos y nombres de los agentes que no hayan labrado multas en los dos primeros meses de 2023.


SELECT m.IdAgente FROM Multas m INNER JOIN Agentes a on m.IdAgente=a.IdAgente WHERE year(m.FechaHora)=2023 AND MONTH(m.FechaHora) between 01 and 02 

SELECT a.Apellidos, a.Nombres FROM Agentes a Where A.IdAgente not in (SELECT a.IdAgente FROM Multas m INNER JOIN Agentes a on m.IdAgente=a.IdAgente WHERE year(m.FechaHora)=2023 AND MONTH(m.FechaHora) between 01 and 02)


-- 4
-- Los apellidos y nombres de los agentes que no hayan labrado multas por 'Exceso de velocidad'.


SELECT distinct m.IdAgente FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.descripcion= 'Exceso de velocidad'

SELECT a.Apellidos, a.Nombres FROM Agentes a WHERE a.idagente not in(SELECT distinct m.IdAgente FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.descripcion= 'Exceso de velocidad')


-- 5
-- Los legajos, apellidos y nombre de los agentes que hayan labrado multas de todos los tipos de infracciones existentes.


SELECT a.Legajo, a.Apellidos, a.Nombres ,COUNT(distinct ti.descripcion) FROM TipoInfracciones ti INNER JOIN Multas m on ti.IdTipoInfraccion=m.IdTipoInfraccion INNER JOIN Agentes a on m.IdAgente=a.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres

SELECT COUNT(distinct Descripcion) FROM TipoInfracciones 

SELECT T.Legajo, T.Apellidos, T.Nombres FROM (SELECT a.Legajo, a.Apellidos, a.Nombres ,COUNT(distinct ti.descripcion) cant FROM TipoInfracciones ti INNER JOIN Multas m on ti.IdTipoInfraccion=m.IdTipoInfraccion INNER JOIN Agentes a on m.IdAgente=a.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres) T WHERE T.cant=(SELECT COUNT(Descripcion) FROM TipoInfracciones)


-- 6
-- Los legajos, apellidos y nombres de los agentes que hayan labrado más cantidad de multas que la cantidad de multas generadas por un radar (multas con IDAgente con valor NULL)


SELECT COUNT(m.IdMulta) FROM Multas  m WHERE m.idAgente is NULL
SELECT a.Legajo, a.Apellidos, a.Nombres, COUNT(m.IdAgente) FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres HAVING COUNT(m.IdAgente) > (SELECT COUNT(m.IdMulta) FROM Multas  m WHERE m.idAgente is NULL)


-- 7
-- Por cada agente, listar legajo, apellidos, nombres, cantidad de multas realizadas durante el día y cantidad de multas realizadas durante la noche.
-- NOTA: El turno noche ocurre pasadas las 20:00 y antes de las 05:00.
-- DATEPART ( DATEPART([hour], fecha_contacto) )

SELECT  a.Legajo, a.Apellidos, a.Nombres, 
(SELECT COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)>05 AND m.IdAgente=a.IdAgente OR DATEPART([HOUR], m.FechaHora)<20 AND m.IdAgente=a.IdAgente) Kdia,
(SELECT COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)>20 AND m.IdAgente=a.IdAgente OR DATEPART([HOUR], m.FechaHora)<05 AND m.IdAgente=a.IdAgente) Knoche 
FROM Agentes a


SELECT COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)>20 AND m.IdAgente=10 OR DATEPART([HOUR], m.FechaHora)<05 AND m.IdAgente=10

-- 8
-- Por cada patente, el total acumulado de pagos realizados con medios de pago no electrónicos y el total acumulado de pagos realizados con algún medio de pago electrónicos.


SELECT m.Patente, sum(p.Importe) PagosElectronicos,
(SELECT sum(p.Importe)PagoElectr FROM Pagos p INNER JOIN MediosPago mp on p.IDMedioPago=mp.IDMedioPago INNER JOIN Multas mu on p.IDMulta=mu.IdMulta WHERE mp.MedioPagoElectronico=0 AND mu.Pagada=0 and mu.Patente=m.Patente)PagosNoElectronicos
FROM Pagos p INNER JOIN MediosPago mp on p.IDMedioPago=mp.IDMedioPago INNER JOIN Multas m on p.IDMulta=m.IdMulta WHERE mp.MedioPagoElectronico=1 AND m.Pagada=0 GROUP BY m.Patente



SELECT sum(p.Importe)PagoElectr FROM Pagos p INNER JOIN MediosPago mp on p.IDMedioPago=mp.IDMedioPago INNER JOIN Multas mu on p.IDMulta=mu.IdMulta WHERE mp.MedioPagoElectronico=0 and mu.Patente=m.Patente


-- 9
-- La cantidad de agentes que hicieron igual cantidad de multas por la noche que durante el día.

SELECT m.IdAgente, COUNT(m.IdMulta) Qdia,
(SELECT COUNT(mu.IdMulta) FROM Multas mu WHERE DATEPART([HOUR], mu.FechaHora)>20 AND mu.IdAgente=m.IdAgente OR DATEPART([HOUR], mu.FechaHora)<05 AND mu.IdAgente=m.IdAgente GROUP BY mu.IdAgente) Qnoche
FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)<20 OR DATEPART([HOUR], m.FechaHora)>05 GROUP BY m.IdAgente


-- 10
-- Las patentes que, en total, hayan abonado más en concepto de pagos con medios no electrónicos que pagos con medios electrónicos. Pero debe haber abonado tanto con medios de pago electrónicos como con medios de pago no electrónicos.

SELECT sb.Patente FROM(SELECT m.Patente, sum(p.Importe) PagosElectronicos,
(SELECT sum(p.Importe)PagoElectr FROM Pagos p INNER JOIN MediosPago mp on p.IDMedioPago=mp.IDMedioPago INNER JOIN Multas mu on p.IDMulta=mu.IdMulta WHERE mp.MedioPagoElectronico=0 AND mu.Pagada=0 and mu.Patente=m.Patente)PagosNoElectronicos
FROM Pagos p INNER JOIN MediosPago mp on p.IDMedioPago=mp.IDMedioPago INNER JOIN Multas m on p.IDMulta=m.IdMulta WHERE mp.MedioPagoElectronico=1 AND m.Pagada=0 GROUP BY m.Patente) Sb 
WHERE sb.PagosNoElectronicos>sb.PagosElectronicos GROUP BY sb.Patente

-- 11
-- Los legajos, apellidos y nombres de agentes que hicieron más de dos multas durante el día y ninguna multa durante la noche.

SELECT a.Legajo, a.apellidos, a.nombres FROM Agentes a WHERE
(SELECT COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)<20 and m.IdAgente=a.IdAgente OR DATEPART([HOUR], m.FechaHora)>05 and m.IdAgente=a.IdAgente group BY m.IdAgente)>2 AND  
(SELECT COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)>20 and m.IdAgente=a.IdAgente OR DATEPART([HOUR], m.FechaHora)<05 and m.IdAgente=a.IdAgente group BY m.IdAgente) is NULL


SELECT m.IdAgente ,COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)<20 OR DATEPART([HOUR], m.FechaHora)>05 GROUP BY m.IdAgente
SELECT m.IdAgente ,COUNT(m.IdMulta) FROM Multas m WHERE DATEPART([HOUR], m.FechaHora)>20 OR DATEPART([HOUR], m.FechaHora)<05 GROUP BY m.IdAgente

-- 12
-- La cantidad de agentes que hayan registrado más multas que la cantidad de multas generadas por un radar (multas con IDAgente con valor NULL)

