-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-09-13 20:41:39 CLST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



DROP TABLE AFP CASCADE CONSTRAINTS 
;

DROP TABLE ATENCION CASCADE CONSTRAINTS 
;

DROP TABLE COMUNA CASCADE CONSTRAINTS 
;

DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS 
;

DROP TABLE EXAMEN_LABORATORIO CASCADE CONSTRAINTS 
;

DROP TABLE MEDICO CASCADE CONSTRAINTS 
;

DROP TABLE PACIENTE CASCADE CONSTRAINTS 
;

DROP TABLE PAGO CASCADE CONSTRAINTS 
;

DROP TABLE REGION CASCADE CONSTRAINTS 
;

DROP TABLE SALUD CASCADE CONSTRAINTS 
;

DROP TABLE SOLICITUD_EXAMEN CASCADE CONSTRAINTS 
;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE AFP 
    ( 
     id_afp VARCHAR2 (3)  NOT NULL 
    ) 
;

ALTER TABLE AFP 
    ADD CONSTRAINT AFP_PK PRIMARY KEY ( id_afp ) ;

CREATE TABLE ATENCION 
    ( 
     id_atencion          VARCHAR2 (15)  NOT NULL , 
     f_atencion           DATE  NOT NULL , 
     h_atencion           DATE  NOT NULL , 
     diagnostico          VARCHAR2 (200)  NOT NULL , 
     T_atencion           VARCHAR2 (15)  NOT NULL , 
     PAGO_id_pago         VARCHAR2 (15)  NOT NULL , 
     MEDICO_rut_medico    VARCHAR2 (15) , 
     PACIENTE_PACIENTE_ID NUMBER  NOT NULL 
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT CK_ATENCION_T_ATENCION 
    CHECK (T_atencion IN ('"general"', '"preventiva"', '"urgencia"')) 
;
CREATE UNIQUE INDEX ATENCION__IDX ON ATENCION 
    ( 
     PAGO_id_pago ASC 
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_PK PRIMARY KEY ( id_atencion ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna        VARCHAR2 (3)  NOT NULL , 
     nombre           VARCHAR2 (100)  NOT NULL , 
     REGION_id_region VARCHAR2 (3)  NOT NULL , 
     COMUNA_ID        NUMBER  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( COMUNA_ID ) ;

CREATE TABLE ESPECIALIDAD 
    ( 
     id_especialidad VARCHAR2 (3)  NOT NULL , 
     nombre          VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT ESPECIALIDAD_PK PRIMARY KEY ( id_especialidad ) ;

CREATE TABLE EXAMEN_LABORATORIO 
    ( 
     id_examen   VARCHAR2 (15)  NOT NULL , 
     nombre      VARCHAR2 (50)  NOT NULL , 
     t_muestra   VARCHAR2 (50)  NOT NULL , 
     condiciones VARCHAR2 (200) 
    ) 
;

ALTER TABLE EXAMEN_LABORATORIO 
    ADD CONSTRAINT EXAMEN_LABORATORIO_PK PRIMARY KEY ( id_examen ) ;

CREATE TABLE MEDICO 
    ( 
     rut_medico                   VARCHAR2 (15)  NOT NULL , 
     nombre                       VARCHAR2 (100)  NOT NULL , 
     f_ingreso                    DATE  NOT NULL , 
     unidad                       VARCHAR2 (20)  NOT NULL , 
     id_supervisor                VARCHAR2 (15) , 
     ESPECIALIDAD_id_especialidad VARCHAR2 (3)  NOT NULL , 
     AFP_id_afp                   VARCHAR2 (3)  NOT NULL , 
     SALUD_id_salud               VARCHAR2 (3)  NOT NULL , 
     MEDICO_rut_medico            VARCHAR2 (15) 
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_PK PRIMARY KEY ( rut_medico ) ;

CREATE TABLE PACIENTE 
    ( 
     rut_paciente     VARCHAR2 (15)  NOT NULL , 
     nombre           VARCHAR2 (100)  NOT NULL , 
     sexo             VARCHAR2 (1)  NOT NULL , 
     f_nacimiento     DATE  NOT NULL , 
     direccion        VARCHAR2 (200)  NOT NULL , 
     contacto         VARCHAR2 (15) , 
     t_usuario        VARCHAR2 (100)  NOT NULL , 
     PACIENTE_ID      NUMBER  NOT NULL , 
     COMUNA_COMUNA_ID NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT CK_PACIENTE_T_USUARIO 
    CHECK (t_usuario IN ('"estudiante"', '"externo"', '"funcionario"')) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_PK PRIMARY KEY ( PACIENTE_ID ) ;

CREATE TABLE PAGO 
    ( 
     id_pago              VARCHAR2 (15)  NOT NULL , 
     monto                VARCHAR2 (30)  NOT NULL , 
     t_pago               VARCHAR2 (10)  NOT NULL , 
     ATENCION_id_atencion VARCHAR2 (15)  NOT NULL 
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT CK_PAGO_T_PAGO 
    CHECK (t_pago IN ('"convenio"', '"efectivo"', '"tarjeta"')) 
;
CREATE UNIQUE INDEX PAGO__IDX ON PAGO 
    ( 
     ATENCION_id_atencion ASC 
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_PK PRIMARY KEY ( id_pago ) ;

CREATE TABLE REGION 
    ( 
     id_region VARCHAR2 (3)  NOT NULL , 
     nombre    VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE SALUD 
    ( 
     id_salud VARCHAR2 (3)  NOT NULL , 
     t_salud  VARCHAR2 (6)  NOT NULL 
    ) 
;

ALTER TABLE SALUD 
    ADD CONSTRAINT SALUD_PK PRIMARY KEY ( id_salud ) ;

CREATE TABLE SOLICITUD_EXAMEN 
    ( 
     id_solicitud                 VARCHAR2 (15)  NOT NULL , 
     ATENCION_id_atencion         VARCHAR2 (15) , 
     EXAMEN_LABORATORIO_id_examen VARCHAR2 (15)  NOT NULL 
    ) 
;

ALTER TABLE SOLICITUD_EXAMEN 
    ADD CONSTRAINT SOLICITUD_EXAMEN_PK PRIMARY KEY ( id_solicitud ) ;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_MEDICO_FK FOREIGN KEY 
    ( 
     MEDICO_rut_medico
    ) 
    REFERENCES MEDICO 
    ( 
     rut_medico
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_PACIENTE_FK FOREIGN KEY 
    ( 
     PACIENTE_PACIENTE_ID
    ) 
    REFERENCES PACIENTE 
    ( 
     PACIENTE_ID
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_PAGO_FK FOREIGN KEY 
    ( 
     PAGO_id_pago
    ) 
    REFERENCES PAGO 
    ( 
     id_pago
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY 
    ( 
     REGION_id_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_AFP_FK FOREIGN KEY 
    ( 
     AFP_id_afp
    ) 
    REFERENCES AFP 
    ( 
     id_afp
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_ESPECIALIDAD_FK FOREIGN KEY 
    ( 
     ESPECIALIDAD_id_especialidad
    ) 
    REFERENCES ESPECIALIDAD 
    ( 
     id_especialidad
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_MEDICO_FK FOREIGN KEY 
    ( 
     MEDICO_rut_medico
    ) 
    REFERENCES MEDICO 
    ( 
     rut_medico
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_SALUD_FK FOREIGN KEY 
    ( 
     SALUD_id_salud
    ) 
    REFERENCES SALUD 
    ( 
     id_salud
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_COMUNA_ID
    ) 
    REFERENCES COMUNA 
    ( 
     COMUNA_ID
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_ATENCION_FK FOREIGN KEY 
    ( 
     ATENCION_id_atencion
    ) 
    REFERENCES ATENCION 
    ( 
     id_atencion
    ) 
;

ALTER TABLE SOLICITUD_EXAMEN 
    ADD CONSTRAINT SOL_EX_ATEN_FK FOREIGN KEY 
    ( 
     ATENCION_id_atencion
    ) 
    REFERENCES ATENCION 
    ( 
     id_atencion
    ) 
;

ALTER TABLE SOLICITUD_EXAMEN 
    ADD CONSTRAINT SOL_EX_EXAm_LABORATORIO_FK FOREIGN KEY 
    ( 
     EXAMEN_LABORATORIO_id_examen
    ) 
    REFERENCES EXAMEN_LABORATORIO 
    ( 
     id_examen
    ) 
;

CREATE SEQUENCE COMUNA_COMUNA_ID_SEQ 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER COMUNA_COMUNA_ID_TRG 
BEFORE INSERT ON COMUNA 
FOR EACH ROW 
WHEN (NEW.COMUNA_ID IS NULL) 
BEGIN 
    :NEW.COMUNA_ID := COMUNA_COMUNA_ID_SEQ.NEXTVAL; 
END;
/

CREATE SEQUENCE PACIENTE_PACIENTE_ID_SEQ 
START WITH 1 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER PACIENTE_PACIENTE_ID_TRG 
BEFORE INSERT ON PACIENTE 
FOR EACH ROW 
WHEN (NEW.PACIENTE_ID IS NULL) 
BEGIN 
    :NEW.PACIENTE_ID := PACIENTE_PACIENTE_ID_SEQ.NEXTVAL; 
END;
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             2
-- ALTER TABLE                             26
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          2
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
