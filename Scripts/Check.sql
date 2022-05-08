-- MOSTRAR
SELECT * FROM user_constraints where table_name = 'ASIGNACION';
-- DELETE
ALTER TABLE table_name 
DROP CONSTRAINT check_constraint_name;

--- CHECK CONSTRAINT 1
ALTER TABLE Asignacion ADD CONSTRAINT 
CHK_Asignacion CHECK (Zona>=36 AND Nota>=61);


-- TRIGGER
drop trigger trig_check1;
create or replace trigger trig_check1
 before insert
 on Asignacion
 for each row
 begin

  if (:new.Zona<=35 OR :new.Nota<=60) then
   insert into Asignacion values(:new.Carnet,:new.Codigo,:new.Seccion,:new.Ano,:new.Ciclo,:new.Zona,:new.Nota);

  end if;
 end trig_check1;

-- FUNC
DROP PROCEDURE fn_check1;
CREATE OR REPLACE FUNCTION fn_check1(pCodigo IN Asignacion.codigo%TYPE, pCarnet IN Asignacion.carnet%TYPE) RETURN Asignacion.ciclo%TYPE IS
--Declaración de variables locales
vPre 	INTEGER;
vAsig 	INTEGER;
BEGIN
--Declaración de Sentencia
	SELECT count(*) INTO vPre FROM prerrequisito pre WHERE pre.pensum_codigo = pCodigo;

	SELECT count(*) INTO vAsig FROM asignacion a 
		INNER JOIN prerrequisito pre on pre.pensum_codigo = a.codigo
	WHERE a.codigo=pCodigo AND carnet=pCarnet;

	IF  vPre = vAsig then
		RETURN 'true';
	END IF;

	return 'false';
--Sentencias de control de excepción
END fn_check1;































































SELECT * FROM CARRERA;
SELECT * FROM PENSUM;

SELECT c.codigo, c.nombre, p.numcreditos FROM ASIGNACION a
    INNER JOIN curso c ON c.codigo = a.codigo
    INNER JOIN prerrequisito pre ON pre.pensum_codigo = a.codigo
    INNER JOIN pensum p ON p.codigo = a.codigo
    INNER JOIN carrera ca on ca.carrera = '1';
    
    SELECT e.nombre, AVG(a.nota) as promedio, SUM(p.numcreditos) as creditos FROM asignacion a
    INNER JOIN estudiante e ON e.carnet = a.carnet
    INNER JOIN pensum p ON p.codigo = a.codigo
    INNER JOIN carrera c ON c.carrera = p.carrera
    INNER JOIN curso cu on a.codigo = cu.codigo
    WHERE c.carrera = '6' AND  a.carnet = '201800937'
    group by e.nombre;
    

(select count(*) from prerrequisito pre 
where pre.pensum_codigo = '722');

SELECT * FROM PRERREQUISITO WHERE pensum_codigo='722';

select count(*) from asignacion a 
    INNER JOIN prerrequisito pre on pre.pensum_codigo = a.codigo
where a.codigo='721' and carnet='201800937';

ALTER TABLE Asignacion ADD CONSTRAINT 
CHK_Asignacion CHECK (Zona>=36 AND Nota>=61
AND
( select count(*) from prerrequisito pre 
where pre.pensum_codigo = '724')= (
select count(*) from asignacion a 
    INNER JOIN prerrequisito pre on pre.pensum_codigo = a.codigo
where a.codigo='724' and carnet='201800937'
)
);
SELECT * FROM prerrequisito;


-- MOSTRAR
SELECT * FROM user_constraints where table_name = 'ASIGNACION';
-- DELETE
ALTER TABLE ASIGNACION 
DROP CONSTRAINT CHK_Asignacion;

ALTER TABLE Asignacion ADD CONSTRAINT 
CHK_Asignacion CHECK ( 
( select count(*) from prerrequisito pre 
where pre.pensum_codigo = '724')
);

