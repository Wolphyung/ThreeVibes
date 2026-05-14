--
-- PostgreSQL database dump
--

-- Dumped from database version 16rc1
-- Dumped by pg_dump version 16.2

-- Started on 2026-05-14 18:16:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 172821)
-- Name: annonce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.annonce (
    codecategorie character(5),
    dateannonce timestamp without time zone,
    contenuannonce text,
    codeannonce character(5) NOT NULL,
    latitude double precision,
    longitude double precision
);


ALTER TABLE public.annonce OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 172828)
-- Name: categorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorie (
    nomcategorie character varying(128),
    codecategorie character(5) NOT NULL
);


ALTER TABLE public.categorie OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 172859)
-- Name: demander; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demander (
    codeutilisateur character(5) NOT NULL,
    codeannonce character(5) NOT NULL
);


ALTER TABLE public.demander OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 172809)
-- Name: fonction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fonction (
    nomfonction character varying(128),
    codefonction character(5) NOT NULL
);


ALTER TABLE public.fonction OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 172840)
-- Name: instruction_dossier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instruction_dossier (
    nomdossier character varying(128),
    instructions text,
    codedossier character(5) NOT NULL
);


ALTER TABLE public.instruction_dossier OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 172833)
-- Name: piece_jointe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.piece_jointe (
    lien text NOT NULL
);


ALTER TABLE public.piece_jointe OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 172876)
-- Name: pjannonce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pjannonce (
    codeannonce character(5) NOT NULL,
    lien text NOT NULL
);


ALTER TABLE public.pjannonce OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 172869)
-- Name: pjsignalement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pjsignalement (
    codesignalement character(5) NOT NULL,
    lien text NOT NULL
);


ALTER TABLE public.pjsignalement OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 172847)
-- Name: signalement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.signalement (
    codeutilisateur character(5) NOT NULL,
    datesignalement date,
    description text,
    typesignalement character varying(128),
    codesignalement character(5) NOT NULL,
    latitude double precision,
    longitude double precision
);


ALTER TABLE public.signalement OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 172864)
-- Name: specialiser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialiser (
    codefonction character(5) NOT NULL,
    codesignalement character(5) NOT NULL
);


ALTER TABLE public.specialiser OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 172948)
-- Name: suivre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suivre (
    codeutilisateur character(5) NOT NULL,
    codesignalement character(5) NOT NULL,
    etatsuivi character varying(128),
    datesuivi date,
    codesuivi character varying(5) NOT NULL
);


ALTER TABLE public.suivre OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 172814)
-- Name: utilisateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateur (
    codefonction character(5) NOT NULL,
    nom character varying(128),
    prenoms character varying(128),
    numcin character(12),
    datecin date,
    lieucin character varying(128),
    adresse character varying(128),
    role character varying(128),
    codeutilisateur character(5) NOT NULL,
    email character varying(128),
    mdp character varying(128)
);


ALTER TABLE public.utilisateur OWNER TO postgres;


ALTER TABLE ONLY public.annonce
    ADD CONSTRAINT pk_annonce PRIMARY KEY (codeannonce);


--
-- TOC entry 4738 (class 2606 OID 172832)
-- Name: categorie pk_categorie; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT pk_categorie PRIMARY KEY (codecategorie);


--
-- TOC entry 4746 (class 2606 OID 172863)
-- Name: demander pk_demander; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demander
    ADD CONSTRAINT pk_demander PRIMARY KEY (codeutilisateur, codeannonce);


--
-- TOC entry 4732 (class 2606 OID 172813)
-- Name: fonction pk_fonction; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fonction
    ADD CONSTRAINT pk_fonction PRIMARY KEY (codefonction);


--
-- TOC entry 4742 (class 2606 OID 172846)
-- Name: instruction_dossier pk_instruction_dossier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instruction_dossier
    ADD CONSTRAINT pk_instruction_dossier PRIMARY KEY (codedossier);


--
-- TOC entry 4740 (class 2606 OID 172839)
-- Name: piece_jointe pk_piece_jointe; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piece_jointe
    ADD CONSTRAINT pk_piece_jointe PRIMARY KEY (lien);


--
-- TOC entry 4752 (class 2606 OID 172882)
-- Name: pjannonce pk_pjannonce; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjannonce
    ADD CONSTRAINT pk_pjannonce PRIMARY KEY (codeannonce, lien);


--
-- TOC entry 4750 (class 2606 OID 172875)
-- Name: pjsignalement pk_pjsignalement; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjsignalement
    ADD CONSTRAINT pk_pjsignalement PRIMARY KEY (codesignalement, lien);


--
-- TOC entry 4744 (class 2606 OID 172853)
-- Name: signalement pk_signalement; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signalement
    ADD CONSTRAINT pk_signalement PRIMARY KEY (codesignalement);


--
-- TOC entry 4748 (class 2606 OID 172868)
-- Name: specialiser pk_specialiser; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialiser
    ADD CONSTRAINT pk_specialiser PRIMARY KEY (codefonction, codesignalement);


--
-- TOC entry 4734 (class 2606 OID 172820)
-- Name: utilisateur pk_utilisateur; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT pk_utilisateur PRIMARY KEY (codeutilisateur);


--
-- TOC entry 4754 (class 2606 OID 172962)
-- Name: suivre suivre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suivre
    ADD CONSTRAINT suivre_pkey PRIMARY KEY (codesuivi);


--
-- TOC entry 4756 (class 2606 OID 172888)
-- Name: annonce fk_annonce_categorie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.annonce
    ADD CONSTRAINT fk_annonce_categorie FOREIGN KEY (codecategorie) REFERENCES public.categorie(codecategorie);


--
-- TOC entry 4758 (class 2606 OID 172913)
-- Name: demander fk_demander_annonce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demander
    ADD CONSTRAINT fk_demander_annonce FOREIGN KEY (codeannonce) REFERENCES public.annonce(codeannonce);


--
-- TOC entry 4759 (class 2606 OID 172908)
-- Name: demander fk_demander_utilisateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demander
    ADD CONSTRAINT fk_demander_utilisateur FOREIGN KEY (codeutilisateur) REFERENCES public.utilisateur(codeutilisateur);


--
-- TOC entry 4764 (class 2606 OID 172938)
-- Name: pjannonce fk_pjannonce_annonce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjannonce
    ADD CONSTRAINT fk_pjannonce_annonce FOREIGN KEY (codeannonce) REFERENCES public.annonce(codeannonce);


--
-- TOC entry 4765 (class 2606 OID 172943)
-- Name: pjannonce fk_pjannonce_piece_jointe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjannonce
    ADD CONSTRAINT fk_pjannonce_piece_jointe FOREIGN KEY (lien) REFERENCES public.piece_jointe(lien);


--
-- TOC entry 4762 (class 2606 OID 172933)
-- Name: pjsignalement fk_pjsignalement_piece_jointe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjsignalement
    ADD CONSTRAINT fk_pjsignalement_piece_jointe FOREIGN KEY (lien) REFERENCES public.piece_jointe(lien);


--
-- TOC entry 4763 (class 2606 OID 172928)
-- Name: pjsignalement fk_pjsignalement_signalement; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjsignalement
    ADD CONSTRAINT fk_pjsignalement_signalement FOREIGN KEY (codesignalement) REFERENCES public.signalement(codesignalement);


--
-- TOC entry 4766 (class 2606 OID 172956)
-- Name: suivre fk_signalement; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suivre
    ADD CONSTRAINT fk_signalement FOREIGN KEY (codesignalement) REFERENCES public.signalement(codesignalement);


--
-- TOC entry 4757 (class 2606 OID 172893)
-- Name: signalement fk_signalement_utilisateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signalement
    ADD CONSTRAINT fk_signalement_utilisateur FOREIGN KEY (codeutilisateur) REFERENCES public.utilisateur(codeutilisateur);


--
-- TOC entry 4760 (class 2606 OID 172918)
-- Name: specialiser fk_specialiser_fonction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialiser
    ADD CONSTRAINT fk_specialiser_fonction FOREIGN KEY (codefonction) REFERENCES public.fonction(codefonction);


--
-- TOC entry 4761 (class 2606 OID 172923)
-- Name: specialiser fk_specialiser_signalement; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialiser
    ADD CONSTRAINT fk_specialiser_signalement FOREIGN KEY (codesignalement) REFERENCES public.signalement(codesignalement);


--
-- TOC entry 4767 (class 2606 OID 172951)
-- Name: suivre fk_utilisateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suivre
    ADD CONSTRAINT fk_utilisateur FOREIGN KEY (codeutilisateur) REFERENCES public.utilisateur(codeutilisateur);


--
-- TOC entry 4755 (class 2606 OID 172883)
-- Name: utilisateur fk_utilisateur_fonction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT fk_utilisateur_fonction FOREIGN KEY (codefonction) REFERENCES public.fonction(codefonction);


-- Completed on 2026-05-14 18:16:17

--
-- PostgreSQL database dump complete
--

