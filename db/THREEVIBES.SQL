-- -----------------------------------------------------------------------------
--             G‚n‚ration d'une base de donn‚es pour
--                           PostgreSQL
--                        (14/5/2026 14:28:08)
-- -----------------------------------------------------------------------------
--      Nom de la base : MLR3
--      Projet : 
--      Auteur : Francky
--      Date de derniŠre modification : 14/5/2026 14:27:36
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--       TABLE : FONCTION
-- -----------------------------------------------------------------------------

CREATE TABLE FONCTION
   (
    NOMFONCTION varchar(128) NULL  ,
    CODEFONCTION char(5) NOT NULL  
,   CONSTRAINT PK_FONCTION PRIMARY KEY (CODEFONCTION)
   );

-- -----------------------------------------------------------------------------
--       TABLE : UTILISATEUR
-- -----------------------------------------------------------------------------

CREATE TABLE UTILISATEUR
   (
    CODEFONCTION char(5) NOT NULL  ,
    NOM varchar(128) NULL  ,
    PRENOMS varchar(128) NULL  ,
    NUMCIN char(12) NULL  ,
    DATECIN date NULL  ,
    LIEUCIN varchar(128) NULL  ,
    ADRESSE varchar(128) NULL  ,
    ROLE varchar(128) NULL  ,
    CODEUTILISATEUR char(5) NOT NULL  ,
    EMAIL varchar(128) NULL  ,
    MDP varchar(128) NULL  
,   CONSTRAINT PK_UTILISATEUR PRIMARY KEY (CODEUTILISATEUR)
   );

-- -----------------------------------------------------------------------------
--       TABLE : ANNONCE
-- -----------------------------------------------------------------------------

CREATE TABLE ANNONCE
   (
    CODECATEGORIE char(5) NULL  ,
    DATEANNONCE timestamp NULL  ,
    CONTENUANNONCE text NULL  ,
    CODEANNONCE char(5) NOT NULL  ,
    LATITUDE float8 NULL  ,
    LONGITUDE float8 NULL  
,   CONSTRAINT PK_ANNONCE PRIMARY KEY (CODEANNONCE)
   );

-- -----------------------------------------------------------------------------
--       TABLE : CATEGORIE
-- -----------------------------------------------------------------------------

CREATE TABLE CATEGORIE
   (
    NOMCATEGORIE varchar(128) NULL  ,
    CODECATEGORIE char(5) NOT NULL  
,   CONSTRAINT PK_CATEGORIE PRIMARY KEY (CODECATEGORIE)
   );

-- -----------------------------------------------------------------------------
--       TABLE : PIECE_JOINTE
-- -----------------------------------------------------------------------------

CREATE TABLE PIECE_JOINTE
   (
    LIEN text NOT NULL  
,   CONSTRAINT PK_PIECE_JOINTE PRIMARY KEY (LIEN)
   );

-- -----------------------------------------------------------------------------
--       TABLE : INSTRUCTION_DOSSIER
-- -----------------------------------------------------------------------------

CREATE TABLE INSTRUCTION_DOSSIER
   (
    NOMDOSSIER varchar(128) NULL  ,
    INSTRUCTIONS text NULL  ,
    CODEDOSSIER char(5) NOT NULL  
,   CONSTRAINT PK_INSTRUCTION_DOSSIER PRIMARY KEY (CODEDOSSIER)
   );

-- -----------------------------------------------------------------------------
--       TABLE : SIGNALEMENT
-- -----------------------------------------------------------------------------

CREATE TABLE SIGNALEMENT
   (
    CODEUTILISATEUR char(5) NOT NULL  ,
    DATESIGNALEMENT date NULL  ,
    DESCRIPTION text NULL  ,
    TYPESIGNALEMENT varchar(128) NULL  ,
    CODESIGNALEMENT char(5) NOT NULL  ,
    LATITUDE float8 NULL  ,
    LONGITUDE float8 NULL  
,   CONSTRAINT PK_SIGNALEMENT PRIMARY KEY (CODESIGNALEMENT)
   );

-- -----------------------------------------------------------------------------
--       TABLE : SUIVRE
-- -----------------------------------------------------------------------------

CREATE TABLE SUIVRE
   (
    CODEUTILISATEUR char(5) NOT NULL  ,
    CODESIGNALEMENT char(5) NOT NULL  ,
    ETATSUIVI varchar(128) NULL  ,
    DATESUIVI date NULL  
,   CONSTRAINT PK_SUIVRE PRIMARY KEY (CODEUTILISATEUR, CODESIGNALEMENT)
   );

-- -----------------------------------------------------------------------------
--       TABLE : DEMANDER
-- -----------------------------------------------------------------------------

CREATE TABLE DEMANDER
   (
    CODEUTILISATEUR char(5) NOT NULL  ,
    CODEANNONCE char(5) NOT NULL  
,   CONSTRAINT PK_DEMANDER PRIMARY KEY (CODEUTILISATEUR, CODEANNONCE)
   );

-- -----------------------------------------------------------------------------
--       TABLE : SPECIALISER
-- -----------------------------------------------------------------------------

CREATE TABLE SPECIALISER
   (
    CODEFONCTION char(5) NOT NULL  ,
    CODESIGNALEMENT char(5) NOT NULL  
,   CONSTRAINT PK_SPECIALISER PRIMARY KEY (CODEFONCTION, CODESIGNALEMENT)
   );

-- -----------------------------------------------------------------------------
--       TABLE : PJSIGNALEMENT
-- -----------------------------------------------------------------------------

CREATE TABLE PJSIGNALEMENT
   (
    CODESIGNALEMENT char(5) NOT NULL  ,
    LIEN text NOT NULL  
,   CONSTRAINT PK_PJSIGNALEMENT PRIMARY KEY (CODESIGNALEMENT, LIEN)
   );

-- -----------------------------------------------------------------------------
--       TABLE : PJANNONCE
-- -----------------------------------------------------------------------------

CREATE TABLE PJANNONCE
   (
    CODEANNONCE char(5) NOT NULL  ,
    LIEN text NOT NULL  
,   CONSTRAINT PK_PJANNONCE PRIMARY KEY (CODEANNONCE, LIEN)
   );


-- -----------------------------------------------------------------------------
--       CREATION DES REFERENCES DE TABLE
-- -----------------------------------------------------------------------------


ALTER TABLE UTILISATEUR ADD 
     CONSTRAINT FK_UTILISATEUR_FONCTION
          FOREIGN KEY (CODEFONCTION)
               REFERENCES FONCTION (CODEFONCTION);

ALTER TABLE ANNONCE ADD 
     CONSTRAINT FK_ANNONCE_CATEGORIE
          FOREIGN KEY (CODECATEGORIE)
               REFERENCES CATEGORIE (CODECATEGORIE);

ALTER TABLE SIGNALEMENT ADD 
     CONSTRAINT FK_SIGNALEMENT_UTILISATEUR
          FOREIGN KEY (CODEUTILISATEUR)
               REFERENCES UTILISATEUR (CODEUTILISATEUR);

ALTER TABLE SUIVRE ADD 
     CONSTRAINT FK_SUIVRE_UTILISATEUR
          FOREIGN KEY (CODEUTILISATEUR)
               REFERENCES UTILISATEUR (CODEUTILISATEUR);

ALTER TABLE SUIVRE ADD 
     CONSTRAINT FK_SUIVRE_SIGNALEMENT
          FOREIGN KEY (CODESIGNALEMENT)
               REFERENCES SIGNALEMENT (CODESIGNALEMENT);

ALTER TABLE DEMANDER ADD 
     CONSTRAINT FK_DEMANDER_UTILISATEUR
          FOREIGN KEY (CODEUTILISATEUR)
               REFERENCES UTILISATEUR (CODEUTILISATEUR);

ALTER TABLE DEMANDER ADD 
     CONSTRAINT FK_DEMANDER_ANNONCE
          FOREIGN KEY (CODEANNONCE)
               REFERENCES ANNONCE (CODEANNONCE);

ALTER TABLE SPECIALISER ADD 
     CONSTRAINT FK_SPECIALISER_FONCTION
          FOREIGN KEY (CODEFONCTION)
               REFERENCES FONCTION (CODEFONCTION);

ALTER TABLE SPECIALISER ADD 
     CONSTRAINT FK_SPECIALISER_SIGNALEMENT
          FOREIGN KEY (CODESIGNALEMENT)
               REFERENCES SIGNALEMENT (CODESIGNALEMENT);

ALTER TABLE PJSIGNALEMENT ADD 
     CONSTRAINT FK_PJSIGNALEMENT_SIGNALEMENT
          FOREIGN KEY (CODESIGNALEMENT)
               REFERENCES SIGNALEMENT (CODESIGNALEMENT);

ALTER TABLE PJSIGNALEMENT ADD 
     CONSTRAINT FK_PJSIGNALEMENT_PIECE_JOINTE
          FOREIGN KEY (LIEN)
               REFERENCES PIECE_JOINTE (LIEN);

ALTER TABLE PJANNONCE ADD 
     CONSTRAINT FK_PJANNONCE_ANNONCE
          FOREIGN KEY (CODEANNONCE)
               REFERENCES ANNONCE (CODEANNONCE);

ALTER TABLE PJANNONCE ADD 
     CONSTRAINT FK_PJANNONCE_PIECE_JOINTE
          FOREIGN KEY (LIEN)
               REFERENCES PIECE_JOINTE (LIEN);


-- -----------------------------------------------------------------------------
--                FIN DE GENERATION
-- -----------------------------------------------------------------------------