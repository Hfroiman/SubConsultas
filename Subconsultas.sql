-- Actividad 2.4
-- #
-- Consulta
-- 1
-- La patente, apellidos y nombres del agente que labró la multa y monto de aquellas multas que superan el monto promedio.

SELECT m.Patente, a.Apellidos, a.Nombres, m.Monto FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente WHERE m.Monto> (SELECT AVG(m.Monto) FROM Multas m)

SELECT AVG(m.Monto) FROM Multas m ---Promedio monto

-- 2
-- Las multas que sean más costosas que la multa más costosa por 'No respetar señal de stop'.

SELECT * FROM Multas m WHERE m.Monto>(SELECT top 1 m.Monto FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.Descripcion='No respetar señal de stop' ORDER BY m.Monto desc)

SELECT top 1 m.Monto FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.Descripcion='No respetar señal de stop' ORDER BY m.Monto desc--33500 Monto de infraccion max

-- 3
-- Los apellidos y nombres de los agentes que no hayan labrado multas en los dos primeros meses de 2023.

SELECT a.Apellidos, a.Nombres FROM Agentes a where a.IdAgente not in (SELECT distinct a.IdAgente FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente WHERE year(m.FechaHora)=2023 and MONTH(m.FechaHora)=1 or year(m.FechaHora)=2023 and MONTH(m.FechaHora)=2)

SELECT distinct a.Apellidos, a.Nombres FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente WHERE year(m.FechaHora)=2023 and MONTH(m.FechaHora)=1 or year(m.FechaHora)=2023 and MONTH(m.FechaHora)=2 
--Agentes que labraron las multas

-- 4
-- Los apellidos y nombres de los agentes que no hayan labrado multas por 'Exceso de velocidad'.

SELECT a.Apellidos, a.Nombres FROM Agentes a where a.IdAgente not in (SELECT distinct a.IdAgente FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.Descripcion='Exceso de velocidad')

SELECT distinct a.IdAgente FROM Agentes a INNER JOIN Multas m on a.IdAgente=m.IdAgente INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.Descripcion='Exceso de velocidad'


-- 5
-- Los legajos, apellidos y nombre de los agentes que hayan labrado multas de todos los tipos de infracciones existentes.

SELECT a.Legajo, a.Apellidos, a.Nombres from Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion INNER JOIN Agentes a on a.IdAgente=m.IdAgente GROUP BY a.Legajo, a.Apellidos, a.Nombres HAVING COUNT(distinct ti.IdTipoInfraccion)=(SELECT COUNT(distinct ti.IdTipoInfraccion) FROM TipoInfracciones ti)

SELECT COUNT(distinct ti.IdTipoInfraccion) FROM TipoInfracciones ti -- Cant de Infracciones.

-- 6
-- Los legajos, apellidos y nombres de los agentes que hayan labrado más cantidad de multas que la cantidad de multas generadas por un radar (multas con IDAgente con valor NULL)


SELECT COUNT(IdMulta) FROM Multas WHERE IdAgente IS NULL --- Cant de multas hechas por RADAR

-- 7
-- Por cada agente, listar legajo, apellidos, nombres, cantidad de multas realizadas durante el día y cantidad de multas realizadas durante la noche.

-- NOTA: El turno noche ocurre pasadas las 20:00 y antes de las 05:00.
-- 8
-- Por cada patente, el total acumulado de pagos realizados con medios de pago no electrónicos y el total acumulado de pagos realizados con algún medio de pago electrónicos.
-- 9
-- La cantidad de agentes que hicieron igual cantidad de multas por la noche que durante el día.
-- 10
-- Las patentes que, en total, hayan abonado más en concepto de pagos con medios no electrónicos que pagos con medios electrónicos. Pero debe haber abonado tanto con medios de pago electrónicos como con medios de pago no electrónicos.
-- 11
-- Los legajos, apellidos y nombres de agentes que hicieron más de dos multas durante el día y ninguna multa durante la noche.
-- 12
-- La cantidad de agentes que hayan registrado más multas que la cantidad de multas generadas por un radar (multas con IDAgente con valor NULL)