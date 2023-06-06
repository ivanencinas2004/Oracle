CREATE OR REPLACE TYPE tFamilia AS OBJECT (
  idFamilia NUMBER,
  familia VARCHAR2(100)
);

CREATE TABLE FAMILIA (
  objeto tFamilia,
  CONSTRAINT PK_FAMILIA PRIMARY KEY (objeto.idFamilia)
);

INSERT INTO FAMILIA VALUES (tFamilia(1, 'Aves'));
INSERT INTO FAMILIA VALUES (tFamilia(2, 'Mamíferos'));
INSERT INTO FAMILIA VALUES (tFamilia(3, 'Peces'));


SELECT * FROM FAMILIA;
CREATE TYPE tNombres AS VARRAY(20) OF VARCHAR2(50);

CREATE OR REPLACE TYPE tNombres AS TABLE OF VARCHAR2(50);

CREATE OR REPLACE TYPE tAnimal AS OBJECT (
  idAnimal NUMBER,
  idFamilia NUMBER,
  Animal VARCHAR2(100),
  nombres tNombres,
  MEMBER FUNCTION ejemplares RETURN VARCHAR2
);


CREATE OR REPLACE TYPE BODY tAnimal AS
  MEMBER FUNCTION ejemplares RETURN VARCHAR2 IS
    cantidad NUMBER := self.nombres.COUNT;
    especie VARCHAR2(100) := self.Animal;
  BEGIN
    RETURN 'Hay ' || cantidad || ' animales de la especie ' || especie;
  END;
END;

DECLARE
  animal tAnimal := tAnimal(1, 1, 'Cigüeña Blanca', tNombres('N1', 'N2', 'N3'));
  resultado VARCHAR2(200);
BEGIN
  resultado := animal.ejemplares;
  DBMS_OUTPUT.PUT_LINE(resultado);
END;

-- Crear la tabla Animal
CREATE TABLE Animal (
  objeto tAnimal,
  idAnimal NUMBER,
  idFamilia NUMBER,
  CONSTRAINT PK_Animal PRIMARY KEY (idAnimal),
  CONSTRAINT FK_Animal_Familia FOREIGN KEY (objeto.idFamilia) REFERENCES Familia(objeto.idFamilia)
);


-- Insertar tres aves
INSERT INTO Animal VALUES (tAnimal(1, 1, 'Garza Real', tNombres('Calíope', 'Izaro')), 1, 1);
INSERT INTO Animal VALUES (tAnimal(2, 1, 'Cigüeña Blanca', tNombres('Perica', 'Clara', 'Miranda')), 2, 1);
INSERT INTO Animal VALUES (tAnimal(3, 1, 'Gorrión', tNombres('Coco', 'Roco', 'Loco', 'Peco', 'Rico')), 3, 1);

-- Insertar tres mamíferos
INSERT INTO Animal VALUES (tAnimal(4, 2, 'Zorro', tNombres('Lucas', 'Mario')), 4, 2);
INSERT INTO Animal VALUES (tAnimal(5, 2, 'Lobo', tNombres('Pedro', 'Pablo')), 5, 2);
INSERT INTO Animal VALUES (tAnimal(6, 2, 'Ciervo', tNombres('Bravo', 'Listo', 'Rojo', 'Astuto')), 6, 2);

-- Insertar tres peces
INSERT INTO Animal VALUES (tAnimal(7, 3, 'Pez globo', tNombres('Nemo', 'Bubbles', 'Fugu')), 7, 3);
INSERT INTO Animal VALUES (tAnimal(8, 3, 'Pez payaso', tNombres('Marlin', 'Coral', 'Bubby')), 8, 3);
INSERT INTO Animal VALUES (tAnimal(9, 3, 'Ángel llama', tNombres('Spike', 'Aurelia', 'Celestia')), 9, 3);

SELECT * FROM ANIMAL;


SELECT a.objeto.Animal AS Animal, f.objeto.idFamilia AS Familia, a.objeto.ejemplares() AS Ejemplares
FROM Animal a
JOIN Familia f ON a.objeto.idFamilia = f.objeto.idFamilia;


