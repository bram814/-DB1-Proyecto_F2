
/**  CONSULTA 1
 * Dar el nombre del estudiante, promedio, y número de créditos ganados, para los
 * estudiantes que han cerrado Ingeniería en Ciencias y Sistemas.
*/
SELECT e.nombre as nombre, TRUNC(AVG(a.nota),2) as promedio, SUM(p.numcreditos) as  creditos FROM asignacion a
    INNER JOIN estudiante e ON e.carnet = a.carnet
    INNER JOIN pensum p ON p.codigo = a.codigo
    INNER JOIN carrera c ON c.carrera = p.carrera
    INNER JOIN curso cu on a.codigo = cu.codigo
WHERE c.carrera = '6' 
group by e.nombre 
HAVING SUM(p.numcreditos) = 141;


/**  CONSULTA 2
 * Dar el nombre del estudiante nombre de la carrera, promedio y número de créditos
 * ganados, para los estudiantes que han cerrado en alguna carrera, estén inscritos en ella o
 * no.
*/
SELECT e.nombre as nombre, ca.nombre as carrera, TRUNC(AVG(a.nota),2) as promedio, sum(pe.numcreditos) as creditos
    FROM Asignacion a
        INNER JOIN estudiante e ON e.carnet = a.carnet
        INNER JOIN seccion se on se.codigo = a.codigo and se.ano = a.ano and se.ciclo = a.ciclo and se.seccion = a.seccion
        INNER JOIN inscrito ins on ins.carnet = a.carnet
        INNER JOIN carrera ca on ca.carrera = ins.carrera
        INNER JOIN plan pl on pl.carrera = ca.carrera
        INNER JOIN Pensum pe on pe.codigo = a.codigo and pe.plan = pl.plan and pe.carrera = ca.carrera
group by e.nombre, ca.nombre
HAVING sum(pe.numcreditos) = 141
order by ca.nombre;
/**  CONSULTA 3
 * Dar el nombre de los estudiantes que han ganado algún curso con alguno de los catedráticos
 * que han impartido alguno de los cursos de la carrera de sistemas en alguno de los planes
 * que se impartieron en el semestre pasado.
*/
select distinct s1.estudiante from (
    SELECT e.nombre as estudiante
        FROM seccion se
            INNER JOIN catedratico cat on cat.catedratico = se.catedratico
            INNER JOIN curso cur on  cur.codigo = se.codigo
            INNER JOIN pensum pe on pe.codigo = cur.codigo  
            INNER JOIN carrera c ON c.carrera = pe.carrera
            INNER JOIN asignacion a on a.codigo = cur.codigo AND a.seccion = se.seccion AND a.ciclo = se.ciclo
            INNER JOIN estudiante e on e.carnet = a.carnet
    where c.carrera = '6'
    group by cat.nombre, cur.nombre, e.nombre
    order by cat.nombre, cur.nombre, e.nombre
) s1;

/** CONSULTA 4
 * Para un estudiante determinado que cerrado en alguna carrera, dar el nombre de los
 * estudiantes que llevaron con él todos los cursos.
*/

select DISTINCT s3.compañero, es.nombre from (
    select  compañero from (
        select * from 
        (
            (
            select a.carnet, a.seccion, a.ano, a.ciclo, a.codigo, cur.nombre from asignacion a
                INNER JOIN seccion sec on sec.seccion = a.seccion and a.ano = sec.ano and a.codigo = sec.codigo and a.ciclo = sec.ciclo
                INNER JOIN curso cur on cur.codigo = sec.codigo and cur.codigo = a.codigo
                
            where a.carnet = '201800937'
            order by a.seccion, a.ano, a.ciclo
            
            ) s1
           JOIN 
           (
              select a.carnet as compañero, a.seccion, a.ano, a.ciclo, a.codigo from asignacion a
                INNER JOIN seccion sec on sec.seccion = a.seccion and a.ano = sec.ano and a.codigo = sec.codigo and a.ciclo = sec.ciclo
                INNER JOIN curso cur on cur.codigo = sec.codigo and cur.codigo = a.codigo
                
            where a.carnet <> '201800937'
            order by a.seccion, a.ano, a.ciclo
            
           ) s2
           on (s1.seccion = s2.seccion and s1.ano = s2.ano and s1.ciclo = s2.ciclo)
        )
    )
) s3 
INNER JOIN estudiante es on s3.compañero = es.carnet;

/** INCISO 6
 * Dar el nombre de los estudiantes que tienen un promedio superior al promedio de los
 * estudiantes de su carrera y su edad es menor que el promedio de edades de los estudiantes
 * de su carrera.
*/

--- CON WHERE SISTEMAS
select s2.nombre, avg(s1.nota) as promedio,TRUNC(TO_NUMBER(SYSDATE - s2.FECHANACIMIENTO) / 365.25) AS edad  from asignacion s1
    inner join estudiante s2 on s2.carnet = s1.carnet
    INNER JOIN INSCRITO s3 ON s3.CARNET  = s2.CARNET 
    WHERE (
        (
            TRUNC(TO_NUMBER(SYSDATE - s2.FECHANACIMIENTO) / 365.25)
        ) 
        < 
        (
            SELECT avg(TRUNC(TO_NUMBER(SYSDATE - e.FECHANACIMIENTO) / 365.25)) FROM ESTUDIANTE e)
        )
        AND s3.CARRERA ='6'

group by s2.nombre,TRUNC(TO_NUMBER(SYSDATE - s2.FECHANACIMIENTO) / 365.25)  
HAVING (avg(s1.NOTA) >(SELECT AVG(a.NOTA) FROM ASIGNACION a))
order by promedio desc ;

-- TOAS LAS CARRERAS
select s2.nombre, trunc(avg(s1.nota),2) as promedio,TRUNC(TO_NUMBER(SYSDATE - s2.FECHANACIMIENTO) / 365.25) AS edad  from asignacion s1
    inner join estudiante s2 on s2.carnet = s1.carnet
    ineer join
            (
                TRUNC(TO_NUMBER(SYSDATE - s2.FECHANACIMIENTO) / 365.25)
            )
            < 
            (
                SELECT avg(TRUNC(TO_NUMBER(SYSDATE - e.FECHANACIMIENTO) / 365.25)) FROM ESTUDIANTE e)
            )    

group by s2.nombre,TRUNC(TO_NUMBER(SYSDATE - s2.FECHANACIMIENTO) / 365.25) 
HAVING AVG(s1.Nota) > (SELECT AVG(a.NOTA) FROM ASIGNACION a)
order by promedio desc ;


/** INCISO 7
 * Insertar una nueva columna en la tabla catedráticos en la que se grabe el salario que ganan,
 * pero en letras. Pueden usar tablas auxiliares (no mayor a Q 99,000 sin centavos)
*/

insert into Catedratico values (53, 'Mario Duarte', 22540, number_to_words.N_TO_LETTERS(22540));
insert into Catedratico values (54, 'Lucas Danilo', 52325, number_to_words.N_TO_LETTERS(52325));
insert into Catedratico values (55, 'Ana Rivera', 125341, number_to_words.N_TO_LETTERS(125341));
insert into Catedratico values (56, 'Maria Ines', 147422, number_to_words.N_TO_LETTERS(147422));
insert into Catedratico values (57, 'Pedro Estrada', 65263, number_to_words.N_TO_LETTERS(65263));


/** INCISO 10
 * Para un estudiante, dar el código y nombre de los cursos que pueden asignarse el próximo
 * semestre, basado en que ya aprobó los respectivos prerrequisitos. 
*/

 select distinct s4.codigo, s4.nombre from (
    select * from (
        select * from (
            select distinct cu.codigo, cu.nombre, pre.curso_prerreq from carrera ca
                inner join inscrito i on ca.carrera = i.carrera
                inner join estudiante e on i.carnet = e.carnet
                inner join plan pl on pl.carrera = ca.carrera
                inner join pensum pe on pe.plan = pl.plan
                inner join curso cu on cu.codigo = pe.codigo
                inner join prerrequisito pre on pre.pensum_carrera = pe.carrera and pre.pensum_plan = pe.plan and pre.pensum_codigo = cu.codigo
            where e.carnet = '201507334'
        ) s1 where s1.codigo not in (
            select a.codigo from 
                asignacion a 
            where a.carnet = '201507334'
        )
    ) s2
    where s2.curso_prerreq in (
        select * from (
            select distinct cu.codigo from carrera ca
                inner join inscrito i on ca.carrera = i.carrera
                inner join estudiante e on i.carnet = e.carnet
                inner join plan pl on pl.carrera = ca.carrera
                inner join pensum pe on pe.plan = pl.plan
                inner join curso cu on cu.codigo = pe.codigo
                inner join prerrequisito pre on pre.pensum_carrera = pe.carrera and pre.pensum_plan = pe.plan and pre.pensum_codigo = cu.codigo
            where e.carnet = '201507334'
        ) s3 where s3.codigo in (
            select a.codigo from asignacion a
            where a.carnet = '201507334'
        )
    )
) s4;