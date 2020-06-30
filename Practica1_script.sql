---1. Generar el script que crea cada una de las tablas que conforman la base de
---datos propuesta por el Comité Olímpico.

CREATE TABLE PROFESION
(
    cod_prof integer NOT NULL,
    nombre character varying(50) NOT NULL,
    PRIMARY KEY (cod_prof),
    CONSTRAINT nombre UNIQUE (nombre)
);

CREATE TABLE PAIS
(
    cod_pais integer NOT NULL,
    nombre character varying(50) NOT NULL,
    PRIMARY KEY (cod_pais),
    CONSTRAINT nombre_PAIS UNIQUE (nombre)
);

CREATE TABLE PUESTO
(
    cod_puesto integer NOT NULL,
    nombre character varying(50) NOT NULL,
    PRIMARY KEY (cod_puesto),
    CONSTRAINT nombre_PUESTO UNIQUE (nombre)
);

CREATE TABLE DEPARTAMENTO
(
    cod_depto integer NOT NULL,
    nombre character varying(50) NOT NULL,
    PRIMARY KEY (cod_depto),
    CONSTRAINT nombre_DEPARTAMENTO UNIQUE (nombre)
);

CREATE TABLE MIEMBRO
(
    cod_miembro integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    edad integer NOT NULL,
    telefono integer,
    residencia character varying(100),
    PAIS_cod_pais integer NOT NULL,
    PROFESION_cod_prof integer NOT NULL,
    PRIMARY KEY (cod_miembro),
    CONSTRAINT PAIS_cod_pais FOREIGN KEY (PAIS_cod_pais)
        REFERENCES PAIS (cod_pais),
    CONSTRAINT PROFESION_cod_prof FOREIGN KEY (PROFESION_cod_prof)
        REFERENCES PROFESION (cod_prof)
);

CREATE TABLE PUESTO_MIEMBRO
(
    fecha_inicio date NOT NULL,
    fecha_fin date,
    MIEMBRO_cod_miembro integer NOT NULL,
    PUESTO_cod_puesto integer NOT NULL,
    DEPARTAMENTO_cod_depto integer NOT NULL,
    PRIMARY KEY (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto),
    CONSTRAINT DEPARTAMENTO_cod_depto FOREIGN KEY (DEPARTAMENTO_cod_depto)
        REFERENCES DEPARTAMENTO (cod_depto),
    CONSTRAINT MIEMBRO_cod_miembro FOREIGN KEY (MIEMBRO_cod_miembro)
        REFERENCES MIEMBRO (cod_miembro),
    CONSTRAINT PUESTO_cod_puesto FOREIGN KEY (PUESTO_cod_puesto)
        REFERENCES PUESTO (cod_puesto)
);

CREATE TABLE TIPO_MEDALLA
(
    cod_tipo integer NOT NULL,
    medalla character varying(20) NOT NULL,
    PRIMARY KEY (cod_tipo),
    CONSTRAINT medalla_TIPOMEDALLA UNIQUE (medalla)
);

CREATE TABLE MEDALLERO
(
    cantidad_medallas integer NOT NULL,
    PAIS_cod_pais integer NOT NULL,
    TIPO_MEDALLA_cod_tipo integer NOT NULL,
    PRIMARY KEY (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo),
    CONSTRAINT PAIS_cod_pais FOREIGN KEY (PAIS_cod_pais)
        REFERENCES PAIS (cod_pais),
    CONSTRAINT TIPO_MEDALLA_cod_tipo FOREIGN KEY (TIPO_MEDALLA_cod_tipo)
        REFERENCES TIPO_MEDALLA (cod_tipo)
);

CREATE TABLE DISCIPLINA
(
    cod_disciplina integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(150),
    PRIMARY KEY (cod_disciplina)
);

CREATE TABLE ATLETA
(
    cod_atleta integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    edad integer NOT NULL,
    Participaciones character varying(100) NOT NULL,
    DISCIPLINA_cod_disciplina integer NOT NULL,
    PAIS_cod_pais integer NOT NULL,
    PRIMARY KEY (cod_atleta),
    CONSTRAINT DISCIPLINA_cod_disciplina FOREIGN KEY (DISCIPLINA_cod_disciplina)
        REFERENCES DISCIPLINA (cod_disciplina),
    CONSTRAINT PAIS_cod_pais FOREIGN KEY (PAIS_cod_pais)
        REFERENCES PAIS (cod_pais)
);

CREATE TABLE CATEGORIA
(
    cod_categoria integer NOT NULL,
    categoria character varying(50) NOT NULL,
    PRIMARY KEY (cod_categoria)
);

CREATE TABLE TIPO_PARTICIPACION
(
    cod_participacion integer NOT NULL,
    tipo_participacion character varying(100) NOT NULL,
    PRIMARY KEY (cod_participacion)
);

CREATE TABLE EVENTO
(
    cod_evento integer NOT NULL,
    fecha date NOT NULL,
    ubicacion character varying(50) NOT NULL,
    hora date NOT NULL,
    DISCIPLINA_cod_disciplina integer NOT NULL,
    TIPO_PARTICIPACION_cod_participacion integer NOT NULL,
    CATEGORIA_cod_categoria integer NOT NULL,
	PRIMARY KEY (cod_evento),
    CONSTRAINT CATEGORIA_cod_categoria FOREIGN KEY (CATEGORIA_cod_categoria)
        REFERENCES CATEGORIA (cod_categoria),
    CONSTRAINT DISCIPLINA_cod_disciplina FOREIGN KEY (DISCIPLINA_cod_disciplina)
        REFERENCES DISCIPLINA (cod_disciplina),
    CONSTRAINT TIPO_PARTICIPACION_cod_participacion FOREIGN KEY (TIPO_PARTICIPACION_cod_participacion)
        REFERENCES TIPO_PARTICIPACION (cod_participacion)
);

CREATE TABLE EVENTO_ATLETA
(
    ATLETA_cod_atleta integer NOT NULL,
    EVENTO_cod_evento integer NOT NULL,
    PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
    CONSTRAINT ATLETA_cod_atleta FOREIGN KEY (ATLETA_cod_atleta)
        REFERENCES ATLETA (cod_atleta),
    CONSTRAINT EVENTO_cod_evento FOREIGN KEY (EVENTO_cod_evento)
        REFERENCES EVENTO (cod_evento)
);

CREATE TABLE TELEVISORA
(
    cod_televisora integer NOT NULL,
    nombre character varying(50) NOT NULL,
    PRIMARY KEY (cod_televisora)
);

CREATE TABLE COSTO_EVENTO
(
    EVENTO_cod_evento integer NOT NULL,
    TELEVISORA_cod_televisora integer NOT NULL,
    Tarifa numeric NOT NULL,
    PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    CONSTRAINT EVENTO_cod_evento FOREIGN KEY (EVENTO_cod_evento)
        REFERENCES EVENTO (cod_evento),
    CONSTRAINT TELEVISORA_cod_televisora FOREIGN KEY (TELEVISORA_cod_televisora)
        REFERENCES TELEVISORA (cod_televisora)
);

---2. En la tabla “Evento” se decidió que la fecha y hora se trabajaría en una sola
--columna.
--		Eliminar las columnas fecha y hora

		ALTER TABLE EVENTO
		DROP COLUMN fecha,
		DROP COLUMN hora;
		
--		Crear una columna llamada “fecha_hora” con el tipo de dato que
--		corresponda según el DBMS.

		ALTER TABLE EVENTO
		ADD COLUMN fecha_hora TIMESTAMP NOT NULL;
		
--3. Todos los eventos de las olimpiadas deben ser programados del 24 de julio
--de 2020 a partir de las 9:00:00 hasta el 09 de agosto de 2020 hasta las
--20:00:00.
--		Generar el Script que únicamente permita registrar los eventos entre estas
--		fechas y horarios.

		ALTER TABLE EVENTO
--		ALTER TABLE EVENTO DROP CONSTRAINT chk_datehora;
		ADD CONSTRAINT chk_datehora CHECK (fecha_hora<'2020-08-09 20:00:00' AND fecha_hora>'2020-07-24 9:00:00' );
		
--4. Se decidió que las ubicación de los eventos se registrarán previamente en
--una tabla y que en la tabla “Evento” sólo se almacenara la llave foránea
--según el código del registro de la ubicación, para esto debe realizar lo
--siguiente:
--		a. Crear la tabla llamada “Sede” que tendrá los campos:
--			i. Código: será tipo entero y será la llave primaria.
--			ii. Sede: será tipo varchar(50) y será obligatoria.

		CREATE TABLE SEDE(
			codigo INTEGER NOT NULL,
			sede character varying(50) NOT NULL,
			PRIMARY KEY(codigo)
		);
--		b. Cambiar el tipo de dato de la columna Ubicación de la tabla Evento
--		por un tipo entero.

		ALTER TABLE EVENTO
		ALTER COLUMN ubicacion TYPE INTEGER USING ubicacion::INTEGER;

--		c. Crear una llave foránea en la columna Ubicación de la tabla Evento y
--		referenciarla a la columna código de la tabla Sede, la que fue creada
--		en el paso anterior.
		
		ALTER TABLE EVENTO
		ADD CONSTRAINT SEDE_codigo FOREIGN KEY(ubicacion) REFERENCES SEDE (codigo);
		

--5. Se revisó la información de los miembros que se tienen actualmente y antes
--de que se ingresen a la base de datos el Comité desea que a los miembros
--que no tengan número telefónico se le ingrese el número por Default 0 al
--momento de ser cargados a la base de datos.

		ALTER TABLE MIEMBRO
		ALTER COLUMN telefono SET DEFAULT '0';
		
--6. Generar el script necesario para hacer la inserción de datos a las tablas
--requeridas.

	INSERT INTO PAIS (cod_pais, nombre)
	VALUES ('1', 'Guatemala'), ('2', 'Francia'), ('3', 'Argentina'),
	('4', 'Alemania'), ('5', 'Italia'), ('6', 'Brasil'), ('7', 'Estados Unidos');
--	SELECT * FROM PAIS;

	INSERT INTO PROFESION (cod_prof, nombre)
	VALUES ('1', 'Medico'), ('2', 'Arquitecto'), ('3', 'Ingeniero'),
	('4', 'Secretaria'), ('5', 'Auditor');
--	SELECT * FROM PROFESION;
	
	INSERT INTO MIEMBRO (cod_miembro, nombre,apellido,edad,telefono,residencia,PAIS_cod_pais, PROFESION_cod_prof)
	VALUES ('1', 'Scott', 'Mitchell','32',default,'1092 Highland Drive Manitowoc, WI 54220 ','7','3'),
	('2', 'Fanette','Poulin','25','25075853','49, boulevard Aristide Briand 76120 LEGRAND-QUEVILLY','2','4'), ('3', 'Laura','Cunha Silva','55',default, 'Rua Onze, 86 UberabaMG','6','5'),
('4', 'Juan Jose','Lopez','38','36985247','26 calle 4-10 zona 11','1','2'), 
('5', 'Arcangela','Panicucci','39','391664921','Via Santa Teresa, 114
90010-Geraci Siculo PA','5','1'), 
('6', 'Jeuel','Villalpando','31',default,'Acuña de Figeroa 6106
80101 Playa Pascual','3','5');
--SELECT * FROM MIEMBRO;
--DELETE FROM MIEMBRO;

	INSERT INTO DISCIPLINA (cod_disciplina, nombre,descripcion)
	VALUES ('1', 'Atletismo','Saltos de longitud y triples, de altura y con pértiga
o garrocha; las pruebas de lanzamiento de
martillo, jabalina y disco'), 
('2', 'Badminton',default), ('3', 'Ciclismo',default),
	('4', 'Judo','Es un arte marcial que se originó en Japón
alrededor de 1880'), ('5', 'Lucha',default), ('6', 'Tenis de Mesa',default), ('7', 'Boxeo',default), 
('8','Natacion','Está presente como deporte en los Juegos desde
la primera edición de la era moderna, en Atenas,
Grecia, en 1896, donde se disputo en aguas
abiertas.'),('9','Esgrima',default),('10','Vela',default);
--SELECT * FROM DISCIPLINA;

	INSERT INTO TIPO_MEDALLA(cod_tipo,medalla)
	VALUES ('1','Oro'),('2','Plata'),('3','Bronce'),('4','Platino');
--	SELECT * FROM TIPO_MEDALLA;

	INSERT INTO CATEGORIA(cod_categoria,categoria)
	VALUES ('1','Clasificatorio'), ('2','Eliminatorio'),('3','Final');
--	SELECT * FROM CATEGORIA;

	INSERT INTO TIPO_PARTICIPACION(cod_participacion,tipo_participacion)
	VALUES ('1','Individual'),('2','Parejas'),('3','Equipos');
--	SELECT * FROM TIPO_PARTICIPACION;

	INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas)
	VALUES ('5','1','3'), ('2','1','5'),('6','3','4'),('4','4','3'),('7','3','10'),
	('3','2','8'),('1','1','2'),('1','4','5'),('5','2','7');
--	SELECT * FROM MEDALLERO;

	INSERT INTO SEDE (codigo,sede)
	VALUES ('1','Gimnasio Metropolitano de Tokio'),('2', 'Jardín del Palacio Imperial de Tokio'),
	('3','Gimnasio Nacional Yoyogi'), ('4','Nippon Budokan'),('5','Estadio Olímpico');
--	SELECT * FROM SEDE;
	
	INSERT INTO EVENTO (cod_evento,fecha_hora,ubicacion,DISCIPLINA_cod_disciplina,TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria)
	VALUES ('1','24/07/2020 11:00:00','3','2','2','1'), ('2','26/07/2020 10:30:00','1','6','1','3'), ('3','30/07/2020 18:45:00','5','7','1','2'),
	('4','01/08/2020 12:15:00','2','1','1','1'), ('5','08/08/2020 19:35:00','4','10','3','1');
--	SELECT * FROM EVENTO;
	
--7. Elabore el script que elimine las restricciones “UNIQUE” de las columnas
--antes mencionadas.

	ALTER TABLE PAIS
	DROP CONSTRAINT pais_pkey CASCADE;
	
	ALTER TABLE TIPO_MEDALLA
	DROP CONSTRAINT tipo_medalla_pkey CASCADE;
	
	ALTER TABLE DEPARTAMENTO
	DROP CONSTRAINT departamento_pkey CASCADE;

--8. Después de un análisis más profundo se decidió que los Atletas pueden
--participar en varias disciplinas y no sólo en una como está reflejado
--actualmente en las tablas, por lo que se pide que realice lo siguiente.
--	a. Script que elimine la llave foránea de “cod_disciplina” que se
--	encuentra en la tabla “Atleta”.

		ALTER TABLE ATLETA
		DROP CONSTRAINT DISCIPLINA_cod_disciplina CASCADE;
		
--	b. Script que cree una tabla con el nombre “Disciplina_Atleta” que
--	contendrá los siguiente campos:
--		i. Cod_atleta (llave foránea de la tabla Atleta)
--		ii. Cod_disciplina (llave foránea de la tablaDisciplina)
		
--La llave primaria será la unión de las llaves foráneas “cod_atleta” y
--“cod_disciplina”.

	CREATE TABLE DISCIPLINA_ATLETA(
			cod_atleta INTEGER NOT NULL,
			cod_disciplina INTEGER NOT NULL,
			PRIMARY KEY(cod_atleta, cod_disciplina),
			CONSTRAINT ATLETA_cod_atleta FOREIGN KEY(cod_atleta) REFERENCES ATLETA(cod_atleta),
			CONSTRAINT DISCIPLINA_cod_disciplina FOREIGN KEY(cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina)
			); 
			
--9. En la tabla “Costo_Evento” se determinó que la columna “tarifa” no debe
--ser entero sino un decimal con 2 cifras de precisión.
--Generar el script correspondiente para modificar el tipo de dato que se le
--pide.
		ALTER TABLE COSTO_EVENTO
		ALTER COLUMN Tarifa TYPE NUMERIC(2,2);
		
--10.Generar el Script que borre de la tabla “Tipo_Medalla”, el registro siguiente:
--4,platino:

		DELETE FROM TIPO_MEDALLA WHERE cod_tipo='4';
--	SELECT * FROM TIPO_MEDALLA;

--11. La fecha de las olimpiadas está cerca y los preparativos siguen, pero de
--último momento se dieron problemas con las televisoras encargadas de
--transmitir los eventos, ya que no hay tiempo de solucionar los problemas
--que se dieron, se decidió no transmitir el evento a través de las televisoras
--por lo que el Comité Olímpico pide generar el script que elimine la tabla
--“TELEVISORAS” y “COSTO_EVENTO”.

		DROP TABLE TELEVISORA CASCADE;
		DROP TABLE COSTO_EVENTO CASCADE;
		
--12. El comité olímpico quiere replantear las disciplinas que van a llevarse a cabo,
--por lo cual pide generar el script que elimine todos los registros contenidos
--en la tabla “DISCIPLINA”.		
--SELECT * FROM DISCIPLINA;
	
		ALTER TABLE DISCIPLINA
		DROP CONSTRAINT disciplina_pkey CASCADE;
		DELETE FROM DISCIPLINA;
		
--13. Los miembros que no tenían registrado su número de teléfono en sus
--perfiles fueron notificados, por lo que se acercaron a las instalaciones de
--Comité para actualizar sus datos.
--SELECT * FROM MIEMBRO;
	UPDATE MIEMBRO 
	SET telefono ='55464601' WHERE nombre='Laura';
	UPDATE MIEMBRO 
	SET telefono ='91514243' WHERE nombre='Jeuel';
	UPDATE MIEMBRO 
	SET telefono ='920686670' WHERE nombre='Scott';	
	
--14. El Comité decidió que necesita la fotografía en la información de los atletas
--para su perfil, por lo que se debe agregar la columna “Fotografía” a la tabla
--Atleta, debido a que es un cambio de última hora este campo deberá ser
--opcional.
--Utilice el tipo de dato que crea conveniente según el DBMS y explique el por
--qué utilizó este tipo de dato.	


	ALTER TABLE ATLETA
	ADD COLUMN Fotografia OID;

--15. Todoslos atletas que se registren deben cumplir con ser menores a 25 años.
--De lo contrario no se debe poder registrar a un atleta en la base de datos.

		ALTER TABLE public.ATLETA
		ADD CONSTRAINT chk_edad CHECK (edad<'25' );
		
--		INSERT INTO ATLETA (cod_atleta,nombre,apellido,edad,Participaciones,DISCIPLINA_cod_disciplina,PAIS_cod_pais)
--		VALUES ('0','prueba','prueba','20','x','1','2');
		
		