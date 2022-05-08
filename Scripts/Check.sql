-- MOSTRAR
SELECT * FROM user_constraints where table_name = 'ASIGNACION';
-- DELETE
ALTER TABLE table_name 
DROP CONSTRAINT check_constraint_name;

--- CHECK CONSTRAINT 1
ALTER TABLE Asignacion ADD CONSTRAINT 
CHK_Asignacion CHECK (Zona>=36 AND Nota>=61);
