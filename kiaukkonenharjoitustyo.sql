DROP DATABASE IF EXISTS lounasruokapalvelu;
CREATE DATABASE lounasruokapalvelu DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE `lounasruokapalvelu` ;

-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`maksaja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`maksaja` (
  `maksajaid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `etunimi` VARCHAR(45) NOT NULL,
  `sukunimi` VARCHAR(45) NOT NULL,
  `puhelinnumero` VARCHAR(20) NOT NULL,
  `sposti` VARCHAR(45) NULL DEFAULT NULL,
  `katuosoite` VARCHAR(45) NOT NULL,
  `postinumero` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`maksajaid`),
  UNIQUE INDEX `maksajaid_UNIQUE` (`maksajaid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`asiakas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`asiakas` (
  `asiakasid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `etunimi` VARCHAR(45),
  `sukunimi` VARCHAR(45) NOT NULL,
  `puhelinnumero` VARCHAR(20) NOT NULL,
  `varapuhelinnro` VARCHAR(20) NOT NULL,
  `katuosoite` VARCHAR(45) NOT NULL,
  `asuinkerros` INT NOT NULL,
  `hissi` TINYINT(1) NULL DEFAULT NULL,
  `ovikoodi` VARCHAR(45) NULL DEFAULT NULL,
  `avain` VARCHAR(45) NULL DEFAULT NULL,
  `vastuuhlo` VARCHAR(45) NULL DEFAULT NULL,
  `maksajaid` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`asiakasid`),
  INDEX `fk_ASIAKAS_MAKSAJA1_idx` (`maksajaid` ASC) VISIBLE,
  CONSTRAINT `fk_ASIAKAS_MAKSAJA1`
    FOREIGN KEY (`maksajaid`)
    REFERENCES `lounasruokapalvelu`.`maksaja` (`maksajaid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`erityisruokavalio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`erityisruokavalio` (
  `erityisruokavalioid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `erityisruokavalionimi` VARCHAR(45) NOT NULL,
  `kuvaus` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`erityisruokavalioid`),
  UNIQUE INDEX `erityisruokavalioid_UNIQUE` (`erityisruokavalioid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`asiakkaanvalio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`asiakkaanvalio` (
  `asiakasid` INT UNSIGNED NOT NULL,
  `alkupvm` DATE NULL DEFAULT NULL,
  `loppupvm` DATE NULL DEFAULT NULL,
  `erityisruokavalioid` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`asiakasid`, `erityisruokavalioid`),
  INDEX `fk_ASIAKKAANVALIO_ASIAKAS1_idx` (`asiakasid` ASC) VISIBLE,
  INDEX `fk_ASIAKKAANVALIO_ERITYISRUOKAVALIO1_idx` (`erityisruokavalioid` ASC) VISIBLE,
  CONSTRAINT `fk_ASIAKKAANVALIO_ASIAKAS1`
    FOREIGN KEY (`asiakasid`)
    REFERENCES `lounasruokapalvelu`.`asiakas` (`asiakasid`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_ASIAKKAANVALIO_ERITYISRUOKAVALIO1`
    FOREIGN KEY (`erityisruokavalioid`)
    REFERENCES `lounasruokapalvelu`.`erityisruokavalio` (`erityisruokavalioid`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`ruoka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`ruoka` (
  `ruokalajinro` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ruokanimi` VARCHAR(45) NOT NULL,
  `hinta` DECIMAL(4,2) UNSIGNED NOT NULL,
  `arvosana` DECIMAL(2,1) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`ruokalajinro`),
  UNIQUE INDEX `ruokalajinro_UNIQUE` (`ruokalajinro` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`paivanruoka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`paivanruoka` (
  `paivanruokaid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pvm` DATE NOT NULL,
  `ruokalajinro` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`paivanruokaid`),
  UNIQUE INDEX `paivanruokaid_UNIQUE` (`paivanruokaid` ASC) VISIBLE,
  INDEX `fk_PAIVANRUOKA_RUOKA1_idx` (`ruokalajinro` ASC) VISIBLE,
  CONSTRAINT `fk_PAIVANRUOKA_RUOKA1`
    FOREIGN KEY (`ruokalajinro`)
    REFERENCES `lounasruokapalvelu`.`ruoka` (`ruokalajinro`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lounasruokapalvelu`.`tilaustuote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lounasruokapalvelu`.`tilaustuote` (
  `tilaustuoteid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `lkm` INT NOT NULL,
  `asiakasid` INT UNSIGNED NOT NULL,
  `paivanruokaid` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`tilaustuoteid`),
  UNIQUE INDEX `tilaustuoteid_UNIQUE` (`tilaustuoteid` ASC) VISIBLE,
  INDEX `fk_TILAUSTUOTE_ASIAKAS1_idx` (`asiakasid` ASC) VISIBLE,
  INDEX `fk_TILAUSTUOTE_PAIVANRUOKA1_idx` (`paivanruokaid` ASC) VISIBLE,
  CONSTRAINT `fk_TILAUSTUOTE_ASIAKAS1`
    FOREIGN KEY (`asiakasid`)
    REFERENCES `lounasruokapalvelu`.`asiakas` (`asiakasid`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_TILAUSTUOTE_PAIVANRUOKA1`
    FOREIGN KEY (`paivanruokaid`)
    REFERENCES `lounasruokapalvelu`.`paivanruoka` (`paivanruokaid`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- rajoitteita, joita oon tosin jo aiemmin 
-- tauluja luodessa määritelly suurimman osan:

ALTER TABLE maksaja 
ADD CHECK (sposti like '%@%');

ALTER TABLE tilaustuote
ALTER lkm SET DEFAULT 1;

ALTER TABLE asiakas
ADD UNIQUE (asiakasid);

ALTER TABLE asiakas
MODIFY etunimi VARCHAR(45) NOT NULL;

-- näkymät 2 kpl:

CREATE VIEW tilaukset AS 
SELECT DATE_FORMAT(pvm, '%d/%m/%Y') AS 'pvm', 
SUM(lkm) AS 'lkm', ruokanimi FROM tilaustuote tt
JOIN paivanruoka pr ON tt.paivanruokaid=pr.paivanruokaid
JOIN ruoka r ON r.ruokalajinro=pr.ruokalajinro 
GROUP BY pr.paivanruokaid ORDER BY pvm;

CREATE VIEW asiakkaidenvaliot AS
SELECT sukunimi, etunimi, erityisruokavalionimi as ruokavalio, alkupvm, loppupvm
FROM asiakas a JOIN asiakkaanvalio av ON a.asiakasid=av.asiakasid
JOIN erityisruokavalio er on er.erityisruokavalioid=av.erityisruokavalioid
order by 1,2,3,4;

-- datarivien lisäykset:

INSERT INTO maksaja (etunimi, sukunimi, puhelinnumero, sposti, 
katuosoite, postinumero) 
VALUES 
('Matti', 'Mäki', '0449584857', NULL, 'Rantatie 5', '00200'),
('Mirva', 'Aaltokangas', '0402451228', 'mirva.aaltokangas@kunta.fi', 'Keskustie 1', '00100'),
('Ari-Pekka', 'Aho', '0458473365', 'ahoaripekka@gmail.com', 'Kesäraitti 53', '20300'),
('Jaana', 'Särki-Nuutinen', '0409374212', 'jaana.s.sarkinuutinen@gmail.com', 'Sammalkatu 37 B 23', '00260'),
('Raija', 'Laiho', '0456233034', NULL, 'Koulukatu 7 D 2', '00380'),
('Mikko', 'Eskelinen', '0500448395', 'eskelinenmikko@outlook.com', 'Välitie 8 A 76', '00790'),
('Veli', 'Rahkamo-Soinio', '0446390846', 'rahkamosoinioveli62@gmail.com', 'Pajatie 4', '00910');

INSERT INTO asiakas (etunimi, sukunimi, puhelinnumero,
varapuhelinnro, katuosoite, asuinkerros, hissi, ovikoodi,
avain, vastuuhlo, maksajaid) 
VALUES 
('Aili', 'Mäki', '0451234567','0449584857', 'Mäkikatu 13', 1, NULL, NULL, NULL, 'Milla', 1),
('Kaija', 'Tanskanen', '0448021243', '0402451228', 'Hakatie 23 A 19', 3, 1, '1989', NULL, 'Milla', 4),
('Ari-Pekka', 'Aho', '0458473365', '0451739774', 'Kesäraitti 53', 1, NULL, NULL, 'P1', 'Marja', 3),
('Teuvo', 'Lipponen', '0403092845', '0402451228', 'Puistotie 3 A 2', 2, 0, NULL, 'S1', 'Jouni', 2),
('Helle', 'Eskelinen', '0402045032', '05004483945', 'Kotipolku 2', 1, NULL, NULL, NULL, 'Jouni', 6),
('Ensio', 'Kuusela', '0449321882', '0402451228', 'Lehtokuja 17 B 61', 4, 1, '1054', 'P2', 'Milla', 2),
('Raija', 'Laiho', '0456233034', '0401387049', 'Koulukatu 7 D 2', 1, NULL, NULL, NULL, 'Marja', 5),
('Olavi', 'Rahkamo', '0442048905', '0446390846', 'Asemakatu 32 C 49', 6, 1, '4537', NULL, 'Milla', 7);

INSERT INTO erityisruokavalio(erityisruokavalionimi, kuvaus) 
VALUES
('laktoositon', NULL),
('kihti', 'ei runsaasti puriineja ts. ei ruotoineen, nahkoineen syötävää kalaa tai siipikarjaa, 
sisäelimiä, palkokasveja, sieniä, parsaa, vehnänalkioita'),
('joditon', 'ei seuraavia: jodioitu suola, nestemäiset maitovalmisteet, kananmunan keltuainen, merikala, äyriäiset'),
('pähkinätön', NULL),
('gluteeniton', NULL),
('pehmeä','helposti haarukalla hienonnettavissa oleva ruoka ja leipä pehmeää'),
('sileärakenteinen', 'täysin sileä sosemainen ruoka, helppo niellä'),
('vegaani',' ei mitään eläinkunnan tuotteita tai sen johdannaisia');

INSERT INTO asiakkaanvalio(asiakasid, alkupvm, loppupvm, erityisruokavalioid)
VALUES
(1, NULL, NULL, 5),
(2, NULL, NULL, 8),
(3, NULL, NULL, 2),
(3, NULL, NULL, 1),
(4, NULL, NULL, 4),
(4, NULL, NULL, 1),
(6, '2021-02-07', '2021-02-21', 7),
(7, '2021-03-01', '2021-03-22', 3),
(7, NULL, NULL, 6);

INSERT INTO ruoka(ruokanimi, hinta, arvosana)
VALUES
('jauhelihakeitto', 5.50, NULL),
('mandariinirahka', 3.00, NULL),
('perunamuusi ja lihapullat', 7.00, 4.2),
('ciabatta', 1.50, 4.5),
('pitsa', 6.00, 4.9),
('marjakiisseli', 2.50, NULL),
('kanafilee ja riisi', 7.00, NULL),
('ruispala', 1.50, NULL),
('puutarhurin lohi ja yrttiperunat', 6.50, 4.3);

INSERT INTO paivanruoka(pvm, ruokalajinro)
VALUES
('2022-03-04', 1),
('2022-03-04', 2),
('2022-03-04', 4),
('2022-03-04', 7),
('2022-03-03', 3),
('2022-03-03', 5),
('2022-03-03', 6),
('2022-03-03', 8),
('2022-03-28', 4),
('2022-03-28', 9),
('2022-03-28', 6);

INSERT INTO tilaustuote(lkm, asiakasid, paivanruokaid)
VALUES
(2, 6, 8),
(2, 7, 11),
(2, 5, 2),
(2, 6, 6),
(2, 3, 3);

INSERT INTO tilaustuote(asiakasid, paivanruokaid)
VALUES
(8, 1),
(7, 1),
(3, 3),
(2, 7),
(3, 5),
(2, 4),
(1, 9),
(4, 10);

-- indeksit:

CREATE INDEX ruuantoimittaja ON asiakas(vastuuhlo);
CREATE INDEX paivamaaranmukaan ON paivanruoka(pvm);

-- hakulauseet:

-- taulut:

SELECT * FROM maksaja;
SELECT * FROM asiakas;
SELECT * FROM erityisruokavalio;
SELECT * FROM asiakkaanvalio;
SELECT * FROM ruoka;
SELECT * FROM paivanruoka;
SELECT * FROM tilaustuote;

-- näkymät:

SELECT * FROM asiakkaidenvaliot;
SELECT * FROM tilaukset;