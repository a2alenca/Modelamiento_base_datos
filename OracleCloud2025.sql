-- //ELIMINAR TODO
DROP TABLE ASIG_TURNO;
DROP TABLE ORD_MANTENSION;
DROP TABLE OPERARIOS;
DROP TABLE JEFE_TURNO;
DROP TABLE TEC_MANTENSION;
DROP TABLE EMPLEADO;
DROP TABLE AFP;
DROP TABLE SALUD;
DROP TABLE MAQUINA;
DROP TABLE TURNO;
DROP TABLE TIPO_MAQUINA;
DROP TABLE PLANTA;
DROP TABLE COMUNA;
DROP TABLE REGION;
DROP SEQUENCE SEC_REGION;

--// BORRAR SECUENCIA
DROP SEQUENCE SEC_REGION;

--// CREAR SECUENCIA
CREATE SEQUENCE SEC_REGION
START WITH 21
INCREMENT BY 1
NOCACHE;


-- // CREAR REGION
CREATE TABLE REGION (
    id_region    NUMBER(2) DEFAULT SEC_REGION.NEXTVAL NOT NULL,
    nombre_region VARCHAR2(50) NOT NULL
);

-- 
ALTER TABLE REGION ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region );
ALTER TABLE REGION ADD CONSTRAINT REGION_UN UNIQUE ( nombre_region );


-- // CREAR COMUNA

CREATE TABLE COMUNA (
    id_comuna    NUMBER(15) GENERATED ALWAYS AS IDENTITY ( START WITH 1050 INCREMENT BY 5 ) NOT NULL,
    nombre_comuna VARCHAR2(50) NOT NULL,
    region_id     NUMBER(2) NOT NULL
);

-- 
ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna );
ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_UN UNIQUE ( nombre_comuna );
ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY ( region_id )
    REFERENCES REGION ( id_region );


-- // CREAR PLANTA
CREATE TABLE PLANTA (
    id_planta  NUMBER(15) NOT NULL,
    nombre     VARCHAR2(100) NOT NULL,
    direccion  VARCHAR2(100) NOT NULL,
    comuna_id  NUMBER(15) NOT NULL
);

-- 
ALTER TABLE PLANTA ADD CONSTRAINT PLANTA_PK PRIMARY KEY ( id_planta );
ALTER TABLE PLANTA ADD CONSTRAINT PLANTA_UN UNIQUE ( nombre );
ALTER TABLE PLANTA ADD CONSTRAINT PLANTA_COMUNA_FK FOREIGN KEY ( comuna_id )
    REFERENCES COMUNA ( id_comuna );


-- // CREAR TIPO MAQUINA
CREATE TABLE TIPO_MAQUINA (
    id_tipo_maq VARCHAR2(15) NOT NULL,
    nombre      VARCHAR2(50) NOT NULL
);

-- 
ALTER TABLE TIPO_MAQUINA ADD CONSTRAINT TIPO_MAQUINA_PK PRIMARY KEY ( id_tipo_maq );
ALTER TABLE TIPO_MAQUINA ADD CONSTRAINT TIPO_MAQUINA_UN UNIQUE ( nombre );


-- // CREAR MAQUINA
CREATE TABLE MAQUINA (
    numero          VARCHAR2(15) NOT NULL,
    nombre          VARCHAR2(50) NOT NULL,
    estado          CHAR(1) DEFAULT 'S' NOT NULL, -- Valor por defecto S
    planta_id_planta NUMBER(15) NOT NULL,
    tipo_maquina_id_tipo_maq VARCHAR2(15) NOT NULL
);

-- 
ALTER TABLE MAQUINA ADD CONSTRAINT MAQUINA_PK PRIMARY KEY ( numero, planta_id_planta ); 
ALTER TABLE MAQUINA ADD CONSTRAINT MAQUINA_CK_ESTADO CHECK ( estado IN ( 'S', 'N' ) );
ALTER TABLE MAQUINA ADD CONSTRAINT MAQUINA_PLANTA_FK FOREIGN KEY ( planta_id_planta )
    REFERENCES PLANTA ( id_planta );
ALTER TABLE MAQUINA ADD CONSTRAINT MAQUINA_TIPO_MAQUINA_FK FOREIGN KEY ( tipo_maquina_id_tipo_maq )
    REFERENCES TIPO_MAQUINA ( id_tipo_maq );


-- // CREAR TURNO
CREATE TABLE TURNO (
    id_turno    VARCHAR2(15) NOT NULL,
    nombre      VARCHAR2(50) NOT NULL,
    h_inicio    CHAR(5) NOT NULL,
    h_termino   CHAR(5) NOT NULL
);

-- 
ALTER TABLE TURNO ADD CONSTRAINT TURNO_PK PRIMARY KEY ( id_turno );
ALTER TABLE TURNO ADD CONSTRAINT TURNO_UN UNIQUE ( nombre );


-- // CREAR AFP
CREATE TABLE AFP (
    id_afp  VARCHAR2(15) NOT NULL,
    nombre VARCHAR2(50) NOT NULL
);

-- 
ALTER TABLE AFP ADD CONSTRAINT AFP_PK PRIMARY KEY ( id_afp );
ALTER TABLE AFP ADD CONSTRAINT AFP_UN UNIQUE ( nombre );


-- // CREAR SALUD
CREATE TABLE SALUD (
    id_salud  VARCHAR2(15) NOT NULL,
    nombre VARCHAR2(50) NOT NULL
);

-- 
ALTER TABLE SALUD ADD CONSTRAINT SALUD_PK PRIMARY KEY ( id_salud );
ALTER TABLE SALUD ADD CONSTRAINT SALUD_UN UNIQUE ( nombre );


-- // CREAR EMPLEADOS
CREATE TABLE EMPLEADO (
    id_empleado   VARCHAR2(15) NOT NULL,
    rut           VARCHAR2(15) NOT NULL,
    nombres       VARCHAR2(100) NOT NULL,
    apellidos     VARCHAR2(100) NOT NULL,
    f_contratacion DATE NOT NULL,
    sueldo        VARCHAR2(12) NOT NULL,
    estado        CHAR(1) DEFAULT 'S' NOT NULL,
    empleado_id_empleado VARCHAR2(15), -- referencia a jefe
    salud_id_salud       VARCHAR2(15) NOT NULL,
    afp_id_afp           VARCHAR2(15) NOT NULL,
    planta_id_planta     NUMBER(15) NOT NULL
);

--
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY ( id_empleado );
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_UN_RUT UNIQUE ( rut );
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_CK_ESTADO CHECK ( estado IN ( 'S', 'N' ) );

ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_EMPLEADO_FK FOREIGN KEY ( empleado_id_empleado )
    REFERENCES EMPLEADO ( id_empleado ); -- FK a sí mismo (Jerarquía)

ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_SALUD_FK FOREIGN KEY ( salud_id_salud )
    REFERENCES SALUD ( id_salud );

ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_AFP_FK FOREIGN KEY ( afp_id_afp )
    REFERENCES AFP ( id_afp );

ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_PLANTA_FK FOREIGN KEY ( planta_id_planta )
    REFERENCES PLANTA ( id_planta );


-- // CREAR OPERARIOS
CREATE TABLE OPERARIOS (
    id_empleado   VARCHAR2(15) NOT NULL, -- PK y FK a EMPLEADO
    cat_proceso   VARCHAR2(30) NOT NULL,
    certificacion VARCHAR2(50),
    h_turno       VARCHAR2(2) DEFAULT '8' NOT NULL
);

-- 
ALTER TABLE OPERARIOS ADD CONSTRAINT OPERARIOS_PK PRIMARY KEY ( id_empleado );
ALTER TABLE OPERARIOS ADD CONSTRAINT OPERARIOS_EMPLEADO_FK FOREIGN KEY ( id_empleado )
    REFERENCES EMPLEADO ( id_empleado );


-- //CREAR JEFE TURNO
CREATE TABLE JEFE_TURNO (
    id_empleado           VARCHAR2(15) NOT NULL, 
    area_responsabilidad VARCHAR2(50) NOT NULL,
    max_operarios        VARCHAR2(4) NOT NULL,
    id_empleado1         VARCHAR2(15) 
    );

-- 
ALTER TABLE JEFE_TURNO ADD CONSTRAINT JEFE_TURNO_PK PRIMARY KEY ( id_empleado );
ALTER TABLE JEFE_TURNO ADD CONSTRAINT JEFE_TURNO_EMPLEADO_FK FOREIGN KEY ( id_empleado )
    REFERENCES EMPLEADO ( id_empleado );


-- // CREAR TEC MANTENSION
CREATE TABLE TEC_MANTENSION (
    id_empleado      VARCHAR2(15) NOT NULL, 
    especialidad     VARCHAR2(50) NOT NULL,
    n_certificacion VARCHAR2(10),
    t_respuesta      VARCHAR2(20) NOT NULL
);

-- Restricciones
ALTER TABLE TEC_MANTENSION ADD CONSTRAINT TEC_MANTENSION_PK PRIMARY KEY ( id_empleado );
ALTER TABLE TEC_MANTENSION ADD CONSTRAINT TEC_MANTENSION_EMPLEADO_FK FOREIGN KEY ( id_empleado )
    REFERENCES EMPLEADO ( id_empleado );


-- // CREAR ORDEN MANTENSION
CREATE TABLE ORD_MANTENSION (
    id_orden                     VARCHAR2(15) NOT NULL,
    f_programada                 DATE NOT NULL,
    f_ejecucion                  DATE, -- Opcional, si ya fue ejecutada
    descripcion                  VARCHAR2(200),
    tec_mantension_id_empleado VARCHAR2(15) NOT NULL,
    maquina_numero               VARCHAR2(15) NOT NULL,
    maquina_planta_id_planta     NUMBER(15) NOT NULL
);

-- 
ALTER TABLE ORD_MANTENSION ADD CONSTRAINT ORD_MANTENSION_PK PRIMARY KEY ( id_orden );
ALTER TABLE ORD_MANTENSION ADD CONSTRAINT ORD_MANTENSION_CK_FECHA CHECK ( f_ejecucion IS NULL OR f_ejecucion >= f_programada );

ALTER TABLE ORD_MANTENSION ADD CONSTRAINT ORD_MANTENSION_TEC_MANTENSION_FK FOREIGN KEY ( tec_mantension_id_empleado )
    REFERENCES TEC_MANTENSION ( id_empleado );

ALTER TABLE ORD_MANTENSION ADD CONSTRAINT ORD_MANTENSION_MAQUINA_FK FOREIGN KEY ( maquina_numero, maquina_planta_id_planta )
    REFERENCES MAQUINA ( numero, planta_id_planta );


-- // CREAR ASIGNAR TURNO
CREATE TABLE ASIG_TURNO (
    id_asignacion           VARCHAR2(15) NOT NULL,
    fecha                   DATE NOT NULL,
    rol                     VARCHAR2(50),
    turno_id_turno          VARCHAR2(15) NOT NULL,
    empleado_id_empleado    VARCHAR2(15) NOT NULL,
    maquina_numero          VARCHAR2(15) NOT NULL,
    maquina_planta_id_planta NUMBER(15) NOT NULL
);

-- 
ALTER TABLE ASIG_TURNO ADD CONSTRAINT ASIG_TURNO_PK PRIMARY KEY ( id_asignacion );
ALTER TABLE ASIG_TURNO ADD CONSTRAINT ASIG_TURNO_UN UNIQUE ( empleado_id_empleado, fecha );

ALTER TABLE ASIG_TURNO ADD CONSTRAINT ASIG_TURNO_TURNO_FK FOREIGN KEY ( turno_id_turno )
    REFERENCES TURNO ( id_turno );

ALTER TABLE ASIG_TURNO ADD CONSTRAINT ASIG_TURNO_EMPLEADO_FK FOREIGN KEY ( empleado_id_empleado )
    REFERENCES EMPLEADO ( id_empleado );

ALTER TABLE ASIG_TURNO ADD CONSTRAINT ASIG_TURNO_MAQUINA_FK FOREIGN KEY ( maquina_numero, maquina_planta_id_planta )
    REFERENCES MAQUINA ( numero, planta_id_planta );
    
    
-- // ADJUNTAMOS DATOS WORD TAREA


-- // PONEMOS DATOS EN REGION
INSERT INTO REGION (nombre_region) VALUES ('Región de Valparaíso'); -- id_region = 21 (SEC_REGION.NEXTVAL)
INSERT INTO REGION (nombre_region) VALUES ('Región Metropolitana'); -- id_region = 22 (SEC_REGION.NEXTVAL)

-- // PONEMOS DATOS EN COMUNA
INSERT INTO COMUNA (nombre_comuna, region_id) VALUES ('Quilpué', 21); 
INSERT INTO COMUNA (nombre_comuna, region_id) VALUES ('Maipú', 22);   

-- // PONEMOS DATOS EN TURNO
INSERT INTO TURNO (id_turno, nombre, h_inicio, h_termino) VALUES ('M0715', 'Mañana', '07:00', '15:00');
INSERT INTO TURNO (id_turno, nombre, h_inicio, h_termino) VALUES ('N2307', 'Noche', '23:00', '07:00');
INSERT INTO TURNO (id_turno, nombre, h_inicio, h_termino) VALUES ('T1523', 'Tarde', '15:00', '23:00');

-- // PONEMOS DATOS EN Planta
INSERT INTO PLANTA (id_planta, nombre, direccion, comuna_id) VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050);
INSERT INTO PLANTA (id_planta, nombre, direccion, comuna_id) VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055);

COMMIT;


--// informe 1


SELECT
    nombre AS TURNO,
    h_inicio AS ENTRADA,
    h_termino AS SALIDA
FROM
    TURNO
WHERE
    h_inicio > '20:00'
ORDER BY
    h_inicio DESC;
    
    
-- informe 2

SELECT
    nombre AS TURNO,
    h_inicio AS ENTRADA,
    h_termino AS SALIDA
FROM
    TURNO
WHERE
    h_inicio BETWEEN '06:00' AND '14:59'
ORDER BY
    h_inicio ASC;