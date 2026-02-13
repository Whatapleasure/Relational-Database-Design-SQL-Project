-- REINITIALISATION DE L'ENSEMBLE DES STRUCTURES CREES

-- DESTRUCTION DES TABLES
DROP TABLE Tarif;
DROP TABLE Location;
DROP TABLE Vehicule;
DROP TABLE Modeles;
DROP TABLE Types;
DROP TABLE Formules;

-- DESTRUCTION DES SEQUENCES

DROP SEQUENCE seqTypes;
DROP SEQUENCE seqVehicule;
DROP SEQUENCE seqTarif;
DROP SEQUENCE seqLocation;

-- DESTRUCTION DES FONCTIONS/PROCEDURES

DROP PROCEDURE AjouterVehicule;
DROP PROCEDURE LouerVehicule;
DROP PROCEDURE VehiculesDisponibles;
DROP PROCEDURE RetournerVehicule;
DROP FUNCTION ChiffreAffaires;
DROP FUNCTION FormuleAvantageuse;

-- CREATION DES TABLES

CREATE TABLE Types(
    IdType NUMBER(1) CHECK (IdType > 0),
    Type VARCHAR2(15) NOT NULL,
    PRIMARY KEY (IdType)
);

CREATE TABLE Modeles(
    Modele VARCHAR2(10),
    Marque VARCHAR2(10) NOT NULL,
    IdType NUMBER(1) NOT NULL CHECK (IdType > 0),
    PRIMARY KEY (Modele),
    FOREIGN KEY (IdType) REFERENCES Types(IdType)
);


CREATE TABLE Vehicule(
    NumVehicule NUMBER(2) CHECK (NumVehicule > 0),
    Modele VARCHAR2(10) NOT NULL,
    Matricule CHAR(7) NOT NULL,
    DateMatricule DATE NOT NULL,
    Kilometrage NUMBER(7) DEFAULT 0 NOT NULL CHECK (Kilometrage >= 0),
    Situation VARCHAR2(15) DEFAULT 'disponible' NOT NULL CHECK (Situation = 'disponible' OR Situation = 'non disponible'), -- Situation est par défaut 'disponible', et ne peut prendre comme valeur que 'disponible' et 'non disponible'
    UNIQUE (Matricule),
    PRIMARY KEY (NumVehicule),
    FOREIGN KEY (Modele) REFERENCES Modeles(Modele)
);

CREATE TABLE Formules(
    Formule VARCHAR2(15),
    NbJours NUMBER(2) NOT NULL CHECK (NbJours > 0),
    KmMax NUMBER(4) NOT NULL CHECK (KmMax > 0),
    PRIMARY KEY (Formule)
);

CREATE TABLE Tarif(
    IdType NUMBER(1) CHECK (IdType > 0),
    Formule VARCHAR2(15),
    Prix NUMBER(4) NOT NULL CHECK (Prix > 0),
    PrixKmSupp NUMBER(3,2) DEFAULT 0.4 NOT NULL CHECK (PrixKmSupp > 0), -- PrixKmSupp est par défaut égal à 0.4 (anecdotique cependant)
    PRIMARY KEY (IdType, Formule),
    FOREIGN KEY (IdType) REFERENCES Types(IdType),
    FOREIGN KEY (Formule) REFERENCES Formules(Formule)
);

CREATE TABLE Location(
    NumLocation NUMBER(5) CHECK (NumLocation > 0),
    NumVehicule NUMBER(2) NOT NULL CHECK (NumVehicule > 0),
    Formule VARCHAR2(15) NOT NULL,
    DateDepart DATE NOT NULL,
    DateRetour DATE NOT NULL,
    NbKm NUMBER(5) CHECK (NbKm > 0), -- N'est pas NOT NULL car prise en compte du cas où le véhicule est loué mais pas rendu
    Montant NUMBER(5) CHECK (Montant > 0), -- N'est pas NOT NULL car prise en compte du cas où le véhicule est loué mais pas rendu
    PRIMARY KEY (NumLocation),
    FOREIGN KEY (NumVehicule) REFERENCES Vehicule(NumVehicule),
    FOREIGN KEY (Formule) REFERENCES Formules(Formule),
    CHECK (DateRetour >= DateDepart),
    CHECK ((NbKm IS NULL AND Montant IS NULL) OR (NbKm IS NOT NULL AND Montant IS NOT NULL))
);

-- CREATION DES SEQUENCES

CREATE SEQUENCE seqTypes;
CREATE SEQUENCE seqVehicule;
CREATE SEQUENCE seqTarif;
CREATE SEQUENCE seqLocation;

-- AJOUT DES DONNEES

-- AJOUT DES DONNEES DE TYPES

INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, 'Citadine');
INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, 'Berline');
INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, 'Monospace');
INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, 'SUV');
INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, '3m3');
INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, '9m3');
INSERT INTO Types(IdType, Type) VALUES (seqTypes.NEXTVAL, '14m3');

-- AJOUT DES DONNEES DE MODELES

INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('CLIO', 'RENAULT', 1);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('SCENIC', 'RENAULT', 3);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('208', 'PEUGEOT', 1);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('508', 'PEUGEOT', 2);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('PICASSO', 'CITROEN', 3);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('C3', 'CITROEN', 1);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('A4', 'AUDI', 2);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('TIGUAN', 'VW', 4);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('5008', 'PEUGEOT', 4);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('KANGOO', 'RENAULT', 5);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('VITO', 'MERCEDES', 6);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('TRANSIT', 'FORD', 6);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('DUCATO', 'FIAT', 7);
INSERT INTO Modeles(Modele, Marque, IdType) VALUES ('MASTER', 'RENAULT', 7);

-- AJOUT DES DONNEES DE FORMULES

INSERT INTO Formules(Formule, NbJours, KmMax) VALUES ('jour', 1, 100);
INSERT INTO Formules(Formule, NbJours, KmMax) VALUES ('fin-semaine', 2, 200);
INSERT INTO Formules(Formule, NbJours, KmMax) VALUES ('semaine', 7, 500);
INSERT INTO Formules(Formule, NbJours, KmMax) VALUES ('mois', 30, 1500);

-- AJOUT DES DONNEES DE TARIF

INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (1, 'jour', 39, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (1, 'fin-semaine', 69, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (1, 'semaine', 199, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (1, 'mois', 499, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (2, 'jour', 59, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (2, 'fin-semaine', 99, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (2, 'semaine', 299, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (2, 'mois', 799, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (3, 'jour', 69, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (3, 'fin-semaine', 129, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (3, 'semaine', 499, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (3, 'mois', 1099, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (4, 'jour', 69, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (4, 'fin-semaine', 129, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (4, 'semaine', 499, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (4, 'mois', 1099, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (5, 'jour', 39, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (5, 'fin-semaine', 79, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (5, 'semaine', 199, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (5, 'mois', 599, 0.3);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (6, 'jour', 49, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (6, 'fin-semaine', 99, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (6, 'semaine', 259, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (6, 'mois', 899, 0.4);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (7, 'jour', 79, 0.45);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (7, 'fin-semaine', 159, 0.45);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (7, 'semaine', 359, 0.45);
INSERT INTO Tarif(IdType, Formule, Prix, PrixKmSupp) VALUES (7, 'mois', 1199, 0.45);

-- CREATION DES FONCTIONS/PROCEDURES

-- CREATION DE AJOUTERVEHICULE

CREATE PROCEDURE AjouterVehicule (
    Model IN VARCHAR2,
    Mat IN CHAR,
    DateMat IN DATE,
    Km IN NUMBER
)
IS
    ModeleExists NUMBER;
    MatriculeExists NUMBER;
    PARAMETER_NULL EXCEPTION;
    PARAMETER_KM_OUT_OF_RANGE EXCEPTION;
    PARAMETER_MODEL_INCORRECT EXCEPTION;
BEGIN
    IF Model IS NULL OR Mat IS NULL OR DateMat IS NULL OR Km IS NULL THEN -- Verifie si aucun paramètre est nul dans les données, lancement d'erreur sinon
        RAISE PARAMETER_NULL;
    END IF;
    IF Km < 0 THEN -- Verifie si le kilometrage n'est pas négatif, lancement d'erreur sinon
        RAISE PARAMETER_KM_OUT_OF_RANGE;
    END IF;
    SELECT COUNT(*) INTO ModeleExists FROM Modeles WHERE Modele = Model; -- Verifie si le modele existe bel et bien dans les données, lancement d'erreur sinon
    IF ModeleExists = 0 THEN
        RAISE PARAMETER_MODEL_INCORRECT;
    END IF;
    SELECT COUNT(*) INTO MatriculeExists FROM Vehicule WHERE Matricule = Mat; -- Verifie si le véhicule lié au matricule existe déjà dans la table ou non
    IF MatriculeExists = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Le matricule existe déjà. Modification des valeurs du véhicule');
        UPDATE Vehicule SET Modele = Model, DateMatricule = DateMat, Kilometrage = Km WHERE Matricule = Mat; -- Si c'est le cas, on change juste ses valeurs
    ELSE
        INSERT INTO Vehicule(NumVehicule, Modele, Matricule, DateMatricule, Kilometrage) VALUES (seqVehicule.NEXTVAL, Model, Mat, DateMat, Km); -- Sinon, on l'ajoute
    END IF;
    COMMIT;
EXCEPTION
    WHEN PARAMETER_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Aucun paramètre ne doit être nul');
    WHEN PARAMETER_KM_OUT_OF_RANGE THEN
        DBMS_OUTPUT.PUT_LINE('Le kilometrage ' || Km || ' ne peut pas être négatif');
    WHEN PARAMETER_MODEL_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('Le modèle ' || Model || ' est inconnu');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || sqlcode || sqlerrm);
END;
/

-- CREATION DE LOUERVEHICULE

CREATE PROCEDURE LouerVehicule(
    NumVeh IN NUMBER,
    Formul IN VARCHAR2,
    Depart IN DATE
)
IS
    NumVehExist NUMBER;
    FormulExist NUMBER;
    Disponibilite Vehicule.Situation%TYPE;
    Retour Location.DateRetour%TYPE;
    Duree Formules.NBJours%TYPE;
    PARAMETER_NULL EXCEPTION;
    PARAMETER_NUMVEH_INCORRECT EXCEPTION;
    PARAMETER_FORMUL_INCORRECT EXCEPTION;
    PARAMETER_DEPART_OUT_OF_RANGE EXCEPTION;
    VEHICULE_IS_NOT_AVAILABLE EXCEPTION;
BEGIN
    IF NumVeh IS NULL OR Formul IS NULL or Depart IS NULL THEN -- Verifie si aucun paramètre est nul, lancement d'erreur sinon
        RAISE PARAMETER_NULL;
    END IF;
    SELECT COUNT(*) INTO NumVehExist FROM Vehicule WHERE NumVehicule = NumVeh; -- Verifie si le numéro de véhicule existe bel et bien dans les données, lancement d'erreur sinon
    IF NumVehExist != 1 THEN
        RAISE PARAMETER_NUMVEH_INCORRECT;
    END IF;
    SELECT COUNT(*) INTO FormulExist FROM Formules WHERE Formule = Formul; -- Verifie si la formule existe bel et bien dans les données, lancement d'erreur sinon
    IF FormulExist != 1 THEN
        RAISE PARAMETER_FORMUL_INCORRECT;
    END IF;
    IF Depart < SYSDATE THEN -- Verifie si la date donnée est supérieur au moment actuel, lancement d'erreur sinon
        RAISE PARAMETER_DEPART_OUT_OF_RANGE;
    END IF;
    SELECT Situation INTO Disponibilite FROM Vehicule WHERE NumVehicule = NumVeh; -- Verifie si le véhicule de numéro NumVeh est disponible, lancement d'erreur sinon 
    IF Disponibilite != 'disponible' THEN
        RAISE VEHICULE_IS_NOT_AVAILABLE;
    END IF;
    SELECT NbJours INTO Duree FROM Formules WHERE Formule = Formul; -- Récupération de la durée de la formule pour le calcul du retour
    Retour := Depart + Duree; -- Calcul du retour
    UPDATE Vehicule SET Situation = 'non disponible' WHERE NumVehicule = NumVeh; -- Mise à non disponible le véhicule loué
    INSERT INTO Location(NumLocation, NumVehicule, Formule, DateDepart, DateRetour) VALUES (seqLocation.NEXTVAL, NumVeh, Formul, Depart, Retour); -- Insert le véhicule loué et les données liés dans la table Location
    COMMIT; -- Confirmation de la mise à jour des données
EXCEPTION
    WHEN PARAMETER_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Aucun paramètre ne doit être nul');
    WHEN PARAMETER_NUMVEH_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('Le véhicule numéro ' || NumVeh || ' existe pas');
    WHEN PARAMETER_FORMUL_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('La formule ' || Formul || ' est pas reconnu');
    WHEN PARAMETER_DEPART_OUT_OF_RANGE THEN
        DBMS_OUTPUT.PUT_LINE('Le date de depart ' || Depart || ' ne peut pas être antérieur à aujourdhui');
    WHEN VEHICULE_IS_NOT_AVAILABLE THEN
         DBMS_OUTPUT.PUT_LINE('Le véhicule numéro ' || NumVeh || ' est actuellement indisponible');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || sqlcode || sqlerrm);
END;
/

-- CREATION DE VEHICULESDISPONIBLES

CREATE PROCEDURE VehiculesDisponibles(
    Typ IN VARCHAR2
)
IS
    TypeExist NUMBER;
    ListeVehiculeDispo VARCHAR2(200);
    NumVeh Vehicule.NumVehicule%TYPE;
    TYPE CurType IS REF CURSOR; -- Creation du type CurType qui est un curseur
    C CurType; -- C est donc un Curseur
    PARAMETER_NULL EXCEPTION;
    PARAMETER_TYP_INCORRECT EXCEPTION;
    VEHICULE_NOT_FOUND EXCEPTION;
BEGIN
    IF Typ IS NULL THEN -- Verifie si aucun paramètre est nul, lancement d'erreur sinon
        RAISE PARAMETER_NULL;
    END IF;
    SELECT COUNT(*) INTO TypeExist FROM Types WHERE Type = Typ; -- Verifie si que Typ existe bel et bien dans les données, lancement d'erreur sinon
    IF TypeExist != 1 THEN
        RAISE PARAMETER_TYP_INCORRECT;
    END IF;
    ListeVehiculeDispo := 'SELECT NumVehicule FROM Vehicule JOIN Modeles USING (Modele) JOIN Types USING (IdType) WHERE Type = ''' || Typ || ''' AND Situation = ''disponible'''; -- Création de la requête qui sera implémenté dans le curseur C, qui retourne l'ensemble des véhicules disponibles
    OPEN C FOR ListeVehiculeDispo; -- Activation du curseur -> C est lié à la requête SQL précédemment crée, l'exécute, et conserve les résultats
    FETCH C INTO NumVeh; -- Accès à la première valeur conservé par le curseur
    IF C%NOTFOUND THEN -- Si on ne trouve pas de première valeur, on annonce qu'aucun véhicule est disponible.
        RAISE VEHICULE_NOT_FOUND;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Liste des voitures de type ' || Typ || ' disponibles :'); -- Sinon, on annonce une liste qui sera formé à l'aide d'une boucle
        LOOP
            DBMS_OUTPUT.PUT_LINE(NumVeh); -- Affichage des numéros de véhicules
            FETCH C INTO NumVeh; -- On passe à la valeur suivante du curseur
            EXIT WHEN C%NOTFOUND; -- Si cette valeur suivante n'existe pas, on quitte la boucle
        END LOOP;
    END IF;
    CLOSE C;
EXCEPTION
    WHEN PARAMETER_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Typ ne doit être nul');
    WHEN PARAMETER_TYP_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('Le type ' || Typ || ' est pas reconnu');
    WHEN VEHICULE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pas de véhicule disponible dans le type ' || Typ ||  ' demandé');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || sqlcode || sqlerrm);
END;
/

-- CREATION DE RETOURNERVEHICULE

CREATE PROCEDURE RetournerVehicule(
    NumVeh IN NUMBER,
    Retour IN DATE,
    Km IN NUMBER
)
IS
    NumVehExist NUMBER;
    Depart Location.DateDepart%TYPE;
    KmM Formules.KmMax%TYPE;
    Prixx Tarif.Prix%TYPE;
    PrixKmSup Tarif.PrixKmSupp%TYPE;
    PARAMETER_NULL EXCEPTION;
    PARAMETER_KM_OUT_OF_RANGE EXCEPTION;
    PARAMETER_NUMVEH_INCORRECT EXCEPTION;
    PARAMETER_DEPART_OUT_OF_RANGE_1 EXCEPTION;
BEGIN
    IF NumVeh IS NULL OR Retour IS NULL or Km IS NULL THEN -- Verifie si aucun paramètre est nul, lancement d'erreur sinon
        RAISE PARAMETER_NULL;
    END IF;
    IF Km < 0 THEN -- Verifie si Km 
        RAISE PARAMETER_KM_OUT_OF_RANGE;
    END IF;
    SELECT COUNT(*) INTO NumVehExist FROM Location WHERE NumVehicule = NumVeh AND Montant IS NULL; -- Verifie si le véhicule de numéro NumVeh existe, et s'il est en location (si le montant est null, alors il encore en cours de location de fait), lancement d'erreur sinon
    IF NumVehExist != 1 THEN
        RAISE PARAMETER_NUMVEH_INCORRECT;
    END IF;
    SELECT DateDepart, KmMax, Prix, PrixKmSupp INTO Depart, KmM, Prixx, PrixKmSup FROM Location JOIN Formules USING (Formule) JOIN Vehicule USING (NumVehicule) JOIN Modeles USING (Modele) JOIN Tarif USING (IdType, Formule) WHERE NumVehicule = NumVeh AND Montant IS NULL;
    IF Depart > Retour THEN -- Verifie si la date de retour est supérieur à la date de départ, lancement d'erreur sinon
        RAISE PARAMETER_DEPART_OUT_OF_RANGE_1;
    END IF;
    UPDATE Vehicule SET Kilometrage = Kilometrage + Km, Situation = 'disponible' WHERE NumVehicule = NumVeh; -- Remet le véhicule comme disponible, et mise à jour de son kilométrage
    UPDATE Location SET DateRetour = Retour, NbKm = Km, Montant = Prixx + PrixKmSup * GREATEST(0, Km - KmM) WHERE NumVehicule = NumVeh AND Montant IS NULL; -- Mise à jour de la location du véhicule avec la date de rendu et le montant à payer
    COMMIT; -- Confirmation de la mise à jour des données
EXCEPTION
    WHEN PARAMETER_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Aucun paramètre ne doit être nul');
    WHEN PARAMETER_KM_OUT_OF_RANGE THEN
        DBMS_OUTPUT.PUT_LINE('Le kilometrage ' || Km || ' ne peut pas être négatif');
    WHEN PARAMETER_NUMVEH_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('Le véhicule numéro ' || NumVeh || ' existe pas');
    WHEN PARAMETER_DEPART_OUT_OF_RANGE_1 THEN
        DBMS_OUTPUT.PUT_LINE('Le date de retour ' || Retour || ' ne peut pas être antérieur à la date de départ ' || Depart);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || sqlcode || sqlerrm);
END;
/

-- CREATION DE CHIFFREAFFAIRES

CREATE FUNCTION ChiffreAffaires(
    Formul IN VARCHAR2,
    Typ IN VARCHAR2
)
RETURN NUMBER
IS
    FormulExist NUMBER;
    TypExist NUMBER;
    CA NUMBER;
    PARAMETER_FORMUL_INCORRECT EXCEPTION;
    PARAMETER_TYP_INCORRECT EXCEPTION;
BEGIN
    IF Formul IS NOT NULL THEN -- On verifie, dans le cas où une formule est donnée, qu'elle existe bel et bien dans les données, lancement d'erreur sinon
        SELECT COUNT(*) INTO FormulExist FROM Formules WHERE Formule = Formul;
        IF FormulExist != 1 THEN
            RAISE PARAMETER_FORMUL_INCORRECT;
        END IF;
    END IF;
    IF Typ IS NOT NULL THEN -- On verifie, dans le cas où un type est donné, qu'il existe bel et bien dans les données, lancement d'erreur sinon
        SELECT COUNT(*) INTO TypExist FROM Types WHERE Type = Typ;
        IF TypExist != 1 THEN
            RAISE PARAMETER_TYP_INCORRECT;
        END IF;
    END IF;
    SELECT SUM(Montant) INTO CA FROM Location JOIN Vehicule USING (NumVehicule) JOIN Modeles USING (Modele) JOIN Types USING (IdType) WHERE Type = NVL(Typ, Type) AND Formule = NVL(Formul, Formule) AND Montant IS NOT NULL; -- Calculation des recettes en fonction de la formule et du type données. Si la formule et/ou le type ne sont pas données, alors on considère l'ensemble des formules/types.
    RETURN CA;
EXCEPTION
    WHEN PARAMETER_FORMUL_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('La formule ' || Formul || ' est pas reconnu');
        RETURN('-1');
     WHEN PARAMETER_TYP_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('Le type ' || Typ || ' est pas reconnu');
        RETURN('-2');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || sqlcode || sqlerrm);
        RETURN('-3');
END;
/

-- CREATION DE FORMULEAVANTAGEUSE

CREATE FUNCTION FormuleAvantageuse (
    Duree IN NUMBER,
    Typ IN VARCHAR2,
    Km IN NUMBER
)
RETURN VARCHAR2
IS
    DureeMax Formules.NbJours%TYPE;
    TypeSelected Types.IdType%TYPE;
    TarifFinal NUMBER;
    FormuleFinal Formules.Formule%TYPE;
    PARAMETER_NULL EXCEPTION;
    PARAMETER_KM_OUT_OF_RANGE EXCEPTION;
    PARAMETER_DUREE_OUT_OF_RANGE EXCEPTION;
    PARAMETER_TYP_INCORRECT EXCEPTION;
    PRAGMA EXCEPTION_INIT(PARAMETER_TYP_INCORRECT, 100);
BEGIN
    IF Duree IS NULL OR Typ IS NULL OR Km IS NULL THEN -- Verifie si aucun paramètre est nul, lancement d'erreur sinon
        RAISE PARAMETER_NULL;
    END IF;
    IF Km <= 0 THEN -- Verifie que le kilométrage n'est pas négatif, lancement d'erreur sinon
        RAISE PARAMETER_KM_OUT_OF_RANGE;
    END IF;
    SELECT MAX(NbJours) INTO DureeMax FROM Formules;  -- Verifie s'il existe bien une formule qui puisse prendre en compte la durée souhaitée, comprise ainsi entre 0 et la duree maximale parmi l'ensemble des formules, lancement d'erreur sinon
    IF Duree <= 0 OR Duree > DureeMax THEN
        RAISE PARAMETER_DUREE_OUT_OF_RANGE;
    END IF;
    SELECT IdType INTO TypeSelected FROM Types WHERE Type = Typ; -- Verifie si le type du véhicule souhaité existe, lancement d'erreur lié à EXCEPTION_INIT sinon
    SELECT Prix + PrixKmSupp * GREATEST(0, Km - KmMax) AS TarifCalcule, Formule INTO TarifFinal, FormuleFinal FROM Tarif JOIN Formules USING (Formule) WHERE TypeSelected = IdType AND Duree <= NbJours AND ROWNUM = 1 ORDER BY TarifCalcule DESC; -- Selectionne la formule la plus avantageuse
    RETURN('Formule : ' || FormuleFinal || ' | Tarif : ' || TarifFinal); -- Retour de la formule trouvée
EXCEPTION
    WHEN PARAMETER_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Aucun paramètre ne doit être nul');
        RETURN('-1');
    WHEN PARAMETER_KM_OUT_OF_RANGE THEN
        DBMS_OUTPUT.PUT_LINE('Le kilometrage ' || Km || ' ne peut pas être nul ou négatif');
        RETURN('-2');
    WHEN PARAMETER_DUREE_OUT_OF_RANGE THEN
        DBMS_OUTPUT.PUT_LINE('La durée ' || Duree || ' est incorrecte. Elle doit être comprise entre 1 et ' || DureeMax);
        RETURN('-3');
    WHEN PARAMETER_TYP_INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('Le type ' || Typ || ' est pas reconnu');
        RETURN('-4');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || sqlcode || sqlerrm);
        RETURN('-5');
END;
/

-- TEST DES PROCEDURES/FONCTIONS

-- TEST DE AJOUTERVEHICULE

EXECUTE AjouterVehicule('CLIO','GA001AG','01/09/2021',1400);
EXECUTE AjouterVehicule('208','GA002AG','01/09/2021',1500);
EXECUTE AjouterVehicule('C3','GB003BG','15/09/2021',1000);
EXECUTE AjouterVehicule('A4','GB004BG','15/09/2021',500);
EXECUTE AjouterVehicule('508','GC006CG','01/10/2021',900);
EXECUTE AjouterVehicule('PICASSO','GF007FG','15/10/2021',300);
EXECUTE AjouterVehicule('SCENIC','GF008FG','15/10/2021',400);
EXECUTE AjouterVehicule('5008','GF009FG','15/10/2021',1000);
EXECUTE AjouterVehicule('KANGOO','GA010AG','01/09/2021',2000);
EXECUTE AjouterVehicule('TRANSIT','GA011AG','01/09/2021',2500);
-- La ligne suivante doit indiquer qu'on fait une modification d'un véhicule existant (Matricule en double)
EXECUTE AjouterVehicule('MASTER','GA011AG','11/09/2021',1500); 
-- La ligne suivante doit lever une erreur car le Kilométrage est négatif
EXECUTE AjouterVehicule('DUCATO','GB013BG','15/09/2021',-1000);
-- La ligne suivante doit lever une erreur car le modèle est inexistant
EXECUTE AjouterVehicule('PASSAT','GC005CG','01/10/2021',1200);
-- La ligne suivante doit lever une erreur car une des valeurs est NULL (ou absente)
EXECUTE AjouterVehicule('208','GF005FG',NULL,1200);

-- TEST DE LOUERVEHICULE

EXECUTE LouerVehicule(1,'jour',SYSDATE);
EXECUTE LouerVehicule(2,'mois',SYSDATE+1);
EXECUTE LouerVehicule(4,'jour',SYSDATE);
EXECUTE LouerVehicule(6,'fin-semaine',SYSDATE+2);
EXECUTE LouerVehicule(7,'semaine',SYSDATE);
EXECUTE LouerVehicule(10,'fin-semaine',SYSDATE+1);
-- La ligne suivante doit que le Véhicule est déjà en location (non disponible)
EXECUTE LouerVehicule(2,'semaine',SYSDATE+1);
-- La ligne suivante doit afficher que le Véhicule n'existe pas
EXECUTE LouerVehicule(11,'semaine',SYSDATE);
-- La ligne suivante doit afficher que le Formule n'existe pas 
EXECUTE LouerVehicule(3,'week-end',SYSDATE);
-- La ligne suivante doit afficher qu'un des paramètres est nul
EXECUTE LouerVehicule(NULL,'semaine',SYSDATE);
-- La ligne suivante doit afficher que la date émise est fausse
EXECUTE LouerVehicule(3,'semaine',SYSDATE-1);

-- TEST DE VEHICULESDISPONIBLES

-- liste des v�hicules de type 'Citadine' disponibles
EXECUTE VehiculesDisponibles('Citadine');
 -- La ligne suivante doit lever une erreur car il n'y a pas de véhicule disponible pour le type '14m3'
EXECUTE VehiculesDisponibles('14m3');
-- La ligne suivante doit afficher que le Type Utilitaire est inconnu
EXECUTE VehiculesDisponibles('Utilitaire');

-- TEST DE RETOURNERVEHICULE

EXECUTE RetournerVehicule(1,SYSDATE+3,120);
EXECUTE RetournerVehicule(4,SYSDATE+1,100);
EXECUTE RetournerVehicule(7,SYSDATE+7,900);
--  La ligne suivante doit afficher qu'il n'y a pas de location pour ce véhicule
EXECUTE RetournerVehicule(1,SYSDATE+1,100);
--  La ligne suivante doit afficher que le Véhicule n'existe pas
EXECUTE RetournerVehicule(11,SYSDATE+1,110); 
--  La ligne suivante doit afficher que la date de retour ne peut pas être inférieure à la date de départ
EXECUTE RetournerVehicule(6,SYSDATE+1,500);
--  La ligne suivante doit provoquer une erreur car Km est négatif ou nul
EXECUTE RetournerVehicule(6,SYSDATE+4,-500);

-- TEST DE CHIFFREAFFAIRES

-- Test de ChiffreAffaires
-- Résultat de CA - Jour - Citadine = 45
SELECT ChiffreAffaires('jour','Citadine') FROM Dual; 
-- Résultat de CA - NULL - Monospace = 659
SELECT ChiffreAffaires(null,'Monospace') FROM Dual; 
-- Résultat de CA - Jour - NULL = 104
SELECT ChiffreAffaires('jour',null) FROM Dual;
-- Résultat de CA - NULL - NULL = 763
SELECT ChiffreAffaires(null,null) FROM Dual; 
-- Doit provoquer une erreur car la formule est inconnue (-1)
SELECT ChiffreAffaires('week-end','Berline') FROM Dual;
-- Doit provoquer une erreur car le type est inconnu (-2)
SELECT ChiffreAffaires('semaine', 'Utilitaire') FROM Dual;

-- TEST DE FORMULEAVANTAGEUSE

-- La ligne suivante doit afficher que la formule "semaine" au Tarif de 199 Euros est la plus avantageuse
SELECT FormuleAvantageuse(3,'Citadine',500) FROM Dual;
-- ligne suivante doit afficher que le Type est inconnu
SELECT FormuleAvantageuse(3,'4x4',500) FROM Dual;
-- La ligne suivante doit afficher qu'un des paramètres ne peut pas être NULL
SELECT FormuleAvantageuse(3,'4x4',NULL) FROM Dual;
-- La ligne suivante doit afficher que le paramètre de la durée est mauvais
SELECT FormuleAvantageuse(32,'Citadine',500) FROM Dual;
-- La ligne suivante doit afficher que le paramètre du kilométrage est mauvais
SELECT FormuleAvantageuse(3,'Citadine',-500) FROM Dual;