-- =========================================
-- Base Voyageur (MySQL)
-- =========================================

DROP DATABASE IF EXISTS Voyageur;
CREATE DATABASE Voyageur;
USE Voyageur;

-- =========================================
-- Création des tables
-- =========================================

-- Table Voyageur
CREATE TABLE IF NOT EXISTS Voyageur (
    idVoyageur INT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    ville VARCHAR(50),
    region VARCHAR(50)
) ENGINE=InnoDB;

-- Table Logement
CREATE TABLE IF NOT EXISTS Logement (
    code VARCHAR(5) PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    capacite INT,
    type VARCHAR(20),
    lieu VARCHAR(50)
) ENGINE=InnoDB;

-- Table Sejour
CREATE TABLE IF NOT EXISTS Sejour (
    idSejour INT PRIMARY KEY,
    idVoyageur INT NOT NULL,
    codeLogement VARCHAR(5) NOT NULL,
    debut INT,
    fin INT,
    CONSTRAINT fk_sejour_voyageur
      FOREIGN KEY (idVoyageur) REFERENCES Voyageur(idVoyageur),
    CONSTRAINT fk_sejour_logement
      FOREIGN KEY (codeLogement) REFERENCES Logement(code)
) ENGINE=InnoDB;

-- Table Activite
CREATE TABLE IF NOT EXISTS Activite (
    codeLogement VARCHAR(5) NOT NULL,
    codeActivite VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (codeLogement, codeActivite),
    CONSTRAINT fk_activite_logement
      FOREIGN KEY (codeLogement) REFERENCES Logement(code)
) ENGINE=InnoDB;

-- =========================================
-- Insertion des données
-- =========================================

-- Voyageurs
INSERT INTO Voyageur VALUES (10, 'Fogg', 'Phileas', 'Ajaccio', 'Corse');
INSERT INTO Voyageur VALUES (20, 'Bouvier', 'Nicolas', 'Aurillac', 'Auvergne');
INSERT INTO Voyageur VALUES (30, 'David-Néel', 'Alexandra', 'Lhassa', 'Tibet');
INSERT INTO Voyageur VALUES (40, 'Stevenson', 'Robert Louis', 'Vannes', 'Bretagne');

-- Logements
INSERT INTO Logement VALUES ('ca', 'Causses', 45, 'Auberge', 'Cévennes');
INSERT INTO Logement VALUES ('ge', 'Génépi', 134, 'Hôtel', 'Alpes');
INSERT INTO Logement VALUES ('pi', 'U Pinzutu', 10, 'Gîte', 'Corse');
INSERT INTO Logement VALUES ('ta', 'Tabriz', 34, 'Hôtel', 'Bretagne');

-- Séjours
INSERT INTO Sejour VALUES (1, 10, 'pi', 20, 20);
INSERT INTO Sejour VALUES (2, 20, 'ta', 21, 22);
INSERT INTO Sejour VALUES (3, 30, 'ge', 2, 3);
INSERT INTO Sejour VALUES (4, 20, 'pi', 19, 23);
INSERT INTO Sejour VALUES (5, 20, 'ge', 22, 24);
INSERT INTO Sejour VALUES (6, 10, 'pi', 10, 12);
INSERT INTO Sejour VALUES (7, 30, 'ca', 13, 18);

-- Activités
INSERT INTO Activite VALUES ('ca', 'Randonnée', 'Sorties d’une journée en groupe');
INSERT INTO Activite VALUES ('ge', 'Piscine', 'Nage loisir non encadrée');
INSERT INTO Activite VALUES ('ge', 'Ski', 'Sur piste uniquement');
INSERT INTO Activite VALUES ('pi', 'Plongée', 'Baptêmes et préparation des brevets');
INSERT INTO Activite VALUES ('pi', 'Voile', 'Pratique du dériveur et du catamaran');

-- =========================================
-- Commandes SQL (TP)
-- =========================================

-- Sélections simples (SELECT / FROM / WHERE)
-- 1. Afficher tous les voyageurs.
SELECT * FROM Voyageur;

-- 2. Afficher le nom et la région de tous les voyageurs vivant en Corse.
SELECT nom, region FROM Voyageur WHERE region = 'Corse';

-- 3. Afficher les logements situés dans les Alpes.
SELECT * FROM Logement WHERE lieu = 'Alpes';

-- 4. Afficher le nom et le type des logements ayant une capacité supérieure à 30.
SELECT nom, type FROM Logement WHERE capacite > 30;

-- 5. Afficher les logements dont le type est Hôtel ou Gîte.
SELECT * FROM Logement WHERE type IN ('Hôtel', 'Gîte');

-- 6. Afficher les voyageurs dont la région n’est pas Bretagne.
SELECT * FROM Voyageur WHERE region <> 'Bretagne';

-- 7. Afficher les séjours commençant avant le jour 20.
SELECT * FROM Sejour WHERE debut < 20;

-- 8. Afficher les activités dont la description contient le mot dériveur.
SELECT * FROM Activite WHERE description LIKE '%dériveur%';

-- =========================================
-- Tri et limitation (ORDER BY / LIMIT)
-- =========================================

-- 9. Afficher les voyageurs triés par nom alphabétique
SELECT *
FROM Voyageur
ORDER BY nom ASC;

-- 10. Afficher les logements triés par capacité décroissante
SELECT *
FROM Logement
ORDER BY capacite DESC;

-- 11. Afficher les 2 logements ayant la plus grande capacité
SELECT *
FROM Logement
ORDER BY capacite DESC
LIMIT 2;

-- =========================================
-- Conjonction, disjonction et négation (AND / OR / NOT)
-- =========================================

-- 12. Afficher les voyageurs habitant Corse ou Bretagne
SELECT *
FROM Voyageur
WHERE region = 'Corse' OR region = 'Bretagne';

-- (équivalent plus clean)
-- WHERE region IN ('Corse', 'Bretagne');

-- 13. Afficher les logements situés en Corse et de type Gîte
SELECT *
FROM Logement
WHERE lieu = 'Corse' AND type = 'Gîte';

-- 14. Afficher les logements non situés en Alpes
SELECT *
FROM Logement
WHERE NOT (lieu = 'Alpes');

-- (équivalent)
-- WHERE lieu <> 'Alpes';

-- 15. Afficher les séjours ayant un début > 15 et une fin < 23
SELECT *
FROM Sejour
WHERE debut > 15 AND fin < 23;

-- =========================================
-- Jointures entre tables
-- =========================================

-- 16. Nom des voyageurs + nom du logement de chacun de leurs séjours
SELECT v.nom, l.nom AS nomLogement
FROM Sejour s
JOIN Voyageur v ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON s.codeLogement = l.code;

-- 17. Voyageurs ayant séjourné en Corse
SELECT DISTINCT v.*
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
JOIN Logement l ON s.codeLogement = l.code
WHERE l.lieu = 'Corse';

-- 18. Voyageurs ayant séjourné dans les Alpes
SELECT DISTINCT v.*
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
JOIN Logement l ON s.codeLogement = l.code
WHERE l.lieu = 'Alpes';

-- 19. Type et lieu des logements visités par Nicolas Bouvier
SELECT DISTINCT l.type, l.lieu
FROM Sejour s
JOIN Voyageur v ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON s.codeLogement = l.code
WHERE v.nom = 'Bouvier' AND v.prenom = 'Nicolas';

-- 20. Activités proposées dans les logements où Phileas Fogg a séjourné
SELECT DISTINCT a.codeActivite, a.description
FROM Sejour s
JOIN Voyageur v ON s.idVoyageur = v.idVoyageur
JOIN Activite a ON s.codeLogement = a.codeLogement
WHERE v.nom = 'Fogg' AND v.prenom = 'Phileas';

-- 21. Séjours avec nom du voyageur + lieu du logement associé
SELECT s.idSejour, v.nom, v.prenom, l.lieu
FROM Sejour s
JOIN Voyageur v ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON s.codeLogement = l.code;

-- 22. Nom des voyageurs ayant effectué au moins un séjour + id du séjour
SELECT v.nom, v.prenom, s.idSejour
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur;

-- 23. Nom des voyageurs + nom des logements uniquement pour les séjours existants
SELECT v.nom, v.prenom, l.nom AS nomLogement
FROM Sejour s
JOIN Voyageur v ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON s.codeLogement = l.code;

-- 24. Tous les voyageurs + leurs séjours s’ils existent
SELECT v.idVoyageur, v.nom, v.prenom, s.idSejour, s.debut, s.fin, s.codeLogement
FROM Voyageur v
LEFT JOIN Sejour s ON v.idVoyageur = s.idVoyageur;

-- 25. Voyageurs n’ayant effectué aucun séjour
SELECT v.*
FROM Voyageur v
LEFT JOIN Sejour s ON v.idVoyageur = s.idVoyageur
WHERE s.idSejour IS NULL;

-- 26. Tous les logements + activités proposées (si elles existent)
SELECT l.code, l.nom AS nomLogement, a.codeActivite, a.description
FROM Logement l
LEFT JOIN Activite a ON l.code = a.codeLogement;

-- 27. Tous les séjours, même si le logement associé n’existe pas
SELECT s.*, l.nom AS nomLogement, l.lieu
FROM Sejour s
LEFT JOIN Logement l ON s.codeLogement = l.code;

-- 28. Tous les voyageurs et tous les séjours, y compris ceux sans correspondance

SELECT v.idVoyageur, v.nom, v.prenom, s.idSejour, s.codeLogement, s.debut, s.fin
FROM Voyageur v
LEFT JOIN Sejour s ON v.idVoyageur = s.idVoyageur
UNION
SELECT v.idVoyageur, v.nom, v.prenom, s.idSejour, s.codeLogement, s.debut, s.fin
FROM Sejour s
LEFT JOIN Voyageur v ON s.idVoyageur = v.idVoyageur;

-- 29. Logements qui ne proposent aucune activité
SELECT l.*
FROM Logement l
LEFT JOIN Activite a ON l.code = a.codeLogement
WHERE a.codeActivite IS NULL;

-- 30. Voyageurs qui n’ont jamais séjourné dans aucun logement
SELECT v.*
FROM Voyageur v
LEFT JOIN Sejour s ON v.idVoyageur = s.idVoyageur
WHERE s.idSejour IS NULL;

-- 31. Afficher le nom des logements et les activités associées (NULL si aucune)
SELECT DISTINCT l.nom AS logement, a.codeActivite
FROM Logement l
LEFT JOIN Activite a ON l.code = a.codeLogement;

-- =========================================
-- Conditions sur plusieurs tables (jointures + filtres)
-- =========================================

-- 32. Voyageurs ayant fait un séjour dans un logement de capacité > 30
SELECT DISTINCT v.*
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
JOIN Logement l ON s.codeLogement = l.code
WHERE l.capacite > 30;

-- 33. Logements qui n’ont aucune activité
SELECT l.*
FROM Logement l
LEFT JOIN Activite a ON l.code = a.codeLogement
WHERE a.codeActivite IS NULL;

-- 34. Voyageurs n’ayant jamais séjourné dans un hôtel
SELECT v.*
FROM Voyageur v
WHERE NOT EXISTS (
  SELECT 1
  FROM Sejour s
  JOIN Logement l ON s.codeLogement = l.code
  WHERE s.idVoyageur = v.idVoyageur
    AND l.type = 'Hôtel'
);

-- 35. Logements où plusieurs voyageurs différents ont séjourné
SELECT l.*
FROM Logement l
JOIN Sejour s ON l.code = s.codeLogement
GROUP BY l.code, l.nom, l.capacite, l.type, l.lieu
HAVING COUNT(DISTINCT s.idVoyageur) > 1;

-- =========================================
-- Agrégats (COUNT, AVG, MAX, MIN, SUM, GROUP BY, HAVING)
-- =========================================

-- 36. Nombre total de voyageurs
SELECT COUNT(*) AS totalVoyageurs
FROM Voyageur;

-- 37. Nombre de logements par type
SELECT type, COUNT(*) AS nbLogements
FROM Logement
GROUP BY type;

-- 38. Nombre de séjours effectués par chaque voyageur
SELECT v.idVoyageur, v.nom, v.prenom, COUNT(s.idSejour) AS nbSejours
FROM Voyageur v
LEFT JOIN Sejour s ON v.idVoyageur = s.idVoyageur
GROUP BY v.idVoyageur, v.nom, v.prenom;

-- 39. Nombre d’activités proposées par chaque logement
SELECT l.code, l.nom, COUNT(a.codeActivite) AS nbActivites
FROM Logement l
LEFT JOIN Activite a ON l.code = a.codeLogement
GROUP BY l.code, l.nom;

-- 40. Capacité moyenne des logements
SELECT AVG(capacite) AS capaciteMoyenne
FROM Logement;

-- 41. Logement ayant la capacité maximale
SELECT *
FROM Logement
WHERE capacite = (SELECT MAX(capacite) FROM Logement);

-- 42. Voyageurs ayant fait au moins 2 séjours
SELECT v.idVoyageur, v.nom, v.prenom
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
GROUP BY v.idVoyageur, v.nom, v.prenom
HAVING COUNT(s.idSejour) >= 2;

-- 43. Combien de séjours ont eu lieu en Corse
SELECT COUNT(*) AS nbSejoursCorse
FROM Sejour s
JOIN Logement l ON s.codeLogement = l.code
WHERE l.lieu = 'Corse';

-- =========================================
-- Sous-requêtes (EXISTS / IN / NOT IN / ANY / ALL)
-- =========================================

-- 44. Voyageurs ayant fait un séjour dans les Alpes (EXISTS)
SELECT v.*
FROM Voyageur v
WHERE EXISTS (
  SELECT 1
  FROM Sejour s
  JOIN Logement l ON s.codeLogement = l.code
  WHERE s.idVoyageur = v.idVoyageur
    AND l.lieu = 'Alpes'
);

-- 45. Voyageurs n’ayant jamais fait de séjour en Corse (NOT EXISTS)
SELECT v.*
FROM Voyageur v
WHERE NOT EXISTS (
  SELECT 1
  FROM Sejour s
  JOIN Logement l ON s.codeLogement = l.code
  WHERE s.idVoyageur = v.idVoyageur
    AND l.lieu = 'Corse'
);

-- 46. Logements où ont séjourné des voyageurs de la même région que le logement (IN)
SELECT l.*
FROM Logement l
WHERE l.lieu IN (
  SELECT DISTINCT v.region
  FROM Voyageur v
  JOIN Sejour s ON v.idVoyageur = s.idVoyageur
  WHERE s.codeLogement = l.code
);

-- 47. Logements qui n’ont pas d’activités (NOT IN)
SELECT l.*
FROM Logement l
WHERE l.code NOT IN (
  SELECT DISTINCT a.codeLogement
  FROM Activite a
);

-- 48. Voyageurs dont le nombre de séjours est supérieur à la moyenne
SELECT v.*
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
GROUP BY v.idVoyageur, v.nom, v.prenom, v.ville, v.region
HAVING COUNT(s.idSejour) >
(
  SELECT AVG(nb)
  FROM (
    SELECT COUNT(*) AS nb
    FROM Sejour
    GROUP BY idVoyageur
  ) t
);

-- =========================================
-- Opérations ensemblistes (UNION / INTERSECT / EXCEPT)
-- =========================================

-- 49. Régions des voyageurs OU lieux de logement (UNION)
SELECT region AS valeur
FROM Voyageur
UNION
SELECT lieu AS valeur
FROM Logement;

-- 50. Régions communes aux voyageurs et aux lieux de logement (INTERSECT simulé)
SELECT DISTINCT v.region AS valeur
FROM Voyageur v
JOIN Logement l ON l.lieu = v.region;

-- 51. Régions présentes chez les voyageurs mais absentes dans les lieux de logement (EXCEPT simulé)
SELECT DISTINCT v.region
FROM Voyageur v
LEFT JOIN Logement l ON l.lieu = v.region
WHERE l.lieu IS NULL;

-- 52. Voyageurs + nombre total de jours passés en séjour (fin - debut)
SELECT v.idVoyageur, v.nom, v.prenom,
       COALESCE(SUM(s.fin - s.debut), 0) AS joursTotal
FROM Voyageur v
LEFT JOIN Sejour s ON v.idVoyageur = s.idVoyageur
GROUP BY v.idVoyageur, v.nom, v.prenom;

-- 53. Voyageurs + activités qu’ils ont pu pratiquer (Voyageur → Sejour → Logement → Activite)
SELECT DISTINCT v.idVoyageur, v.nom, v.prenom, a.codeActivite, a.description
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
JOIN Activite a ON s.codeLogement = a.codeLogement;

-- 54. Logements ayant toutes les activités disponibles dans la base

SELECT l.code, l.nom
FROM Logement l
JOIN Activite a ON l.code = a.codeLogement
GROUP BY l.code, l.nom
HAVING COUNT(DISTINCT a.codeActivite) = (
  SELECT COUNT(DISTINCT codeActivite) FROM Activite
);

-- 55. Voyageurs qui ont séjourné dans toutes les régions existantes
SELECT v.idVoyageur, v.nom, v.prenom
FROM Voyageur v
JOIN Sejour s ON v.idVoyageur = s.idVoyageur
JOIN Logement l ON s.codeLogement = l.code
GROUP BY v.idVoyageur, v.nom, v.prenom
HAVING COUNT(DISTINCT l.lieu) = (SELECT COUNT(DISTINCT lieu) FROM Logement);

