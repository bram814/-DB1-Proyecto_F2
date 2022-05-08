CREATE TABLE Carrera (
    Carrera INTEGER NOT NULL,
    Nombre  VARCHAR2(50) NOT NULL
);

ALTER TABLE Carrera ADD CONSTRAINT carrera_PK PRIMARY KEY ( Carrera );

CREATE TABLE Estudiante (
    Carnet          INTEGER NOT NULL,
    Nombre          VARCHAR2(50) NOT NULL,
    IngresoFamiliar NUMBER(10, 2) NOT NULL,
    FechaNacimiento DATE NOT NULL
);

ALTER TABLE Estudiante ADD CONSTRAINT estudiante_PK PRIMARY KEY ( Carnet );

CREATE TABLE Inscrito (
    Carrera          INTEGER NOT NULL,
    Carnet           INTEGER NOT NULL,
    FechaInscripcion DATE NOT NULL
);

ALTER TABLE Inscrito ADD CONSTRAINT inscrito_PK PRIMARY KEY ( Carrera, Carnet );

ALTER TABLE Inscrito ADD CONSTRAINT inscrito_carrera_FK FOREIGN KEY ( Carrera )
REFERENCES Carrera ( Carrera );

ALTER TABLE Inscrito ADD CONSTRAINT inscrito_estudiante_FK FOREIGN KEY ( Carnet )
REFERENCES Estudiante ( Carnet );



CREATE TABLE Plan (
    Plan              VARCHAR2(10) NOT NULL,
    Carrera           INTEGER NOT NULL,
    Nombre            VARCHAR2(50) NOT NULL,
    AnoInicial        VARCHAR2(4) NOT NULL,
    CicloInicial      VARCHAR2(50) NOT NULL,
    AnoFinal          VARCHAR2(4) NOT NULL,
    CicloFinal        VARCHAR2(50) NOT NULL,
    NumCreditosCierre INTEGER NOT NULL
    
);

ALTER TABLE Plan ADD CONSTRAINT plan_PK PRIMARY KEY ( Plan, Carrera );

CREATE TABLE Curso (
    Codigo INTEGER NOT NULL,
    Nombre VARCHAR2(50) NOT NULL
);

ALTER TABLE Curso ADD CONSTRAINT curso_PK PRIMARY KEY ( Codigo );

ALTER TABLE Plan ADD CONSTRAINT plan_carrera_FK FOREIGN KEY ( Carrera )
REFERENCES Carrera ( Carrera );
       

CREATE TABLE pensum (
	Codigo         INTEGER NOT NULL,
    Plan           VARCHAR2(10) NOT NULL,
    Carrera        INTEGER NOT NULL,
	Obligatoriedad NUMBER NOT NULL,
    NumCreditos    INTEGER NOT NULL,
    NotaAprobacion INTEGER NOT NULL,
    ZonaMinima     INTEGER NOT NULL,
    CredPrerreq    INTEGER NOT NULL
    
);

ALTER TABLE Pensum ADD CONSTRAINT pensum_PK PRIMARY KEY ( Plan, Carrera, Codigo );

ALTER TABLE Pensum ADD CONSTRAINT pensum_curso_FK FOREIGN KEY ( Codigo )
        REFERENCES Curso ( Codigo );

ALTER TABLE Pensum ADD CONSTRAINT pensum_plan_FK FOREIGN KEY ( Plan, Carrera )
REFERENCES Plan ( Plan, Carrera );

                         
CREATE TABLE Prerrequisito (
    Pensum_Plan    VARCHAR2(10) NOT NULL,
    Pensum_Carrera INTEGER NOT NULL,
    Pensum_Codigo  INTEGER NOT NULL,
    Curso_Prerreq  INTEGER NOT NULL
);

ALTER TABLE Prerrequisito ADD CONSTRAINT prerrequisito_PK 
PRIMARY KEY ( Pensum_Plan, Pensum_Carrera, Pensum_Codigo, Curso_Prerreq );

ALTER TABLE Prerrequisito
ADD CONSTRAINT prerrequisito_curso_FK FOREIGN KEY ( Curso_Prerreq )
REFERENCES Curso ( Codigo );

ALTER TABLE Prerrequisito
ADD CONSTRAINT prerrequisito_pensum_FK FOREIGN KEY ( Pensum_Plan, Pensum_Carrera, Pensum_Codigo )
REFERENCES Pensum ( Plan, Carrera, Codigo );


CREATE TABLE Catedratico (
    Catedratico   INTEGER NOT NULL,
    Nombre        VARCHAR2(50) NOT NULL,
    SueldoMensual NUMBER(10, 2) NOT NULL
);

ALTER TABLE Catedratico ADD CONSTRAINT catedratico_PK PRIMARY KEY ( Catedratico );

CREATE TABLE Seccion (
    Seccion     VARCHAR2(2) NOT NULL,
    Ano         VARCHAR2(4) NOT NULL,
    Ciclo       VARCHAR2(50) NOT NULL,
    Codigo      INTEGER NOT NULL,
	Catedratico INTEGER NOT NULL
);

ALTER TABLE Seccion ADD CONSTRAINT seccion_PK PRIMARY KEY ( Seccion, Ano, Ciclo, Codigo );

ALTER TABLE Seccion ADD CONSTRAINT seccion_catedratico_FK FOREIGN KEY ( Catedratico )
REFERENCES Catedratico ( Catedratico );

ALTER TABLE Seccion ADD CONSTRAINT seccion_curso_FK FOREIGN KEY ( Codigo )
REFERENCES Curso ( Codigo );
       
       

CREATE TABLE Asignacion (
    Carnet 	INTEGER NOT NULL,
	Codigo  INTEGER NOT NULL,
    Seccion VARCHAR2(2) NOT NULL,
    Ano     VARCHAR2(4) NOT NULL,
    Ciclo   VARCHAR2(50) NOT NULL,
	Zona    INTEGER NOT NULL,
    Nota    INTEGER NOT NULL
);

ALTER TABLE Asignacion ADD CONSTRAINT asignacion_PK 
PRIMARY KEY ( Carnet, Codigo, Seccion, Ano, Ciclo );

ALTER TABLE Asignacion
ADD CONSTRAINT asignacion_estudiante_FK FOREIGN KEY ( Carnet )
REFERENCES Estudiante ( Carnet );

ALTER TABLE Asignacion
ADD CONSTRAINT asignacion_seccion_FK 
	FOREIGN KEY ( Seccion, Ano, Ciclo, Codigo )
	REFERENCES Seccion ( Seccion, Ano, Ciclo, Codigo );
                            

CREATE TABLE Dia (
    Dia    INTEGER NOT NULL,
    Nombre VARCHAR2(50) NOT NULL
);

ALTER TABLE Dia ADD CONSTRAINT dia_PK PRIMARY KEY ( Dia );

CREATE TABLE Periodo (
    Periodo    INTEGER NOT NULL,
    HoraInicio DATE NOT NULL,
    HoraFinal  DATE NOT NULL
);

ALTER TABLE Periodo ADD CONSTRAINT periodo_PK PRIMARY KEY ( Periodo );

CREATE TABLE Salon (
    Edificio  VARCHAR2(10) NOT NULL,
    Salon     VARCHAR2(10) NOT NULL,
    Capacidad INTEGER NOT NULL
);

ALTER TABLE Salon ADD CONSTRAINT salon_PK PRIMARY KEY ( Edificio, Salon );

CREATE TABLE Horario (
	Seccion_Codigo  INTEGER NOT NULL,    
	Seccion_Seccion VARCHAR2(2) NOT NULL,
	Seccion_Ano     VARCHAR2(4) NOT NULL,
    Seccion_Ciclo   VARCHAR2(50) NOT NULL,
	Periodo         INTEGER NOT NULL,
    Dia             INTEGER NOT NULL,
    Edificio        VARCHAR2(10) NOT NULL,
    Salon           VARCHAR2(10) NOT NULL
);

ALTER TABLE Horario ADD CONSTRAINT horario_PK 
PRIMARY KEY ( Seccion_Codigo, Seccion_Seccion, Seccion_Ano, Seccion_Ciclo, Periodo, Dia );

ALTER TABLE Horario
ADD CONSTRAINT horario_dia_FK FOREIGN KEY ( Dia )
REFERENCES Dia ( Dia );

ALTER TABLE Horario
ADD CONSTRAINT horario_periodo_FK FOREIGN KEY ( Periodo )
REFERENCES periodo ( Periodo );

ALTER TABLE Horario
ADD CONSTRAINT horario_salon_FK FOREIGN KEY ( Edificio, Salon )
REFERENCES Salon ( Edificio, Salon );

ALTER TABLE horario ADD CONSTRAINT horario_seccion_FK 
FOREIGN KEY ( Seccion_Seccion, Seccion_Ano, Seccion_Ciclo, Seccion_Codigo )
REFERENCES Seccion ( Seccion, Ano, Ciclo, Codigo );


-- ELIMINAR BASE
DROP TABLE ASIGNACION;
DROP TABLE HORARIO;

DROP TABLE SECCION;
DROP TABLE PRERREQUISITO;
DROP TABLE PENSUM;
DROP TABLE PLAN;
DROP TABLE INSCRITO;

DROP TABLE CATEDRATICO;
DROP TABLE CARRERA;
DROP TABLE CURSO;
DROP TABLE ESTUDIANTE;
DROP TABLE DIA;
DROP TABLE SALON; 
DROP TABLE PERIODO; 