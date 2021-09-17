--CRUD para los productos
--Nota: primero se deben ingresar los datos de las tablas catálogos (Marca y TipoCambios)

--Funciones para insertar productos

--Función para insertar bicicletas
CREATE FUNCTION InsertarBicicleta(
	inIdMarca INT, 
	inCantPasajeros INT,
	inUnidadesStock INT,
	inPeso INT,
	inTamanno INT,
	inPrecio MONEY,
	inModelo VARCHAR,
	inAnno DATE,
	inColor VARCHAR,
	inMarco INT,
	inHorquilla INT
	) 
RETURNS INT
AS
$$
BEGIN 
	
	--Valida si existe la marca ingresada en la tabla de Marca
	IF NOT EXISTS(SELECT Id FROM Marca WHERE Id = inIdMarca)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se inserta la bicicleta
	INSERT INTO Bicicleta (IdMarca, CantidadPasajeros, UnidadesEnStock,
						   PesoKg, TamannoMetros, Precio, Modelo, Anno, 
						   Color, Activo, Marco, Horquilla)
	VALUES(inIdMarca, inCantPasajeros, inUnidadesStock, inPeso, inTamanno, 
		   inPrecio, inModelo, inAnno, inColor, TRUE,inMarco, inHorquilla);
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función para insertar helicopteros
CREATE FUNCTION InsertarHelicoptero(
	inIdMarca INT, 
	inCantPasajeros INT,
	inUnidadesStock INT,
	inPeso INT,
	inTamanno INT,
	inPrecio MONEY,
	inModelo VARCHAR,
	inAnno DATE,
	inColor VARCHAR,
	inCantidadMotores INT,
	inCantidadHelices INT
	) 
RETURNS INT
AS
$$
BEGIN 
	
	--Valida si existe la marca ingresada en la tabla de Marca
	IF NOT EXISTS(SELECT Id FROM Marca WHERE Id = inIdMarca)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se inserta el helicoptero
	INSERT INTO Helicoptero (IdMarca, CantidadPasajeros, UnidadesEnStock,
						   PesoKg, TamannoMetros, Precio, Modelo, Anno, 
						   Color, Activo, CantMotores, CantHelices)
	VALUES(inIdMarca, inCantPasajeros, inUnidadesStock, inPeso, inTamanno, 
		   inPrecio, inModelo, inAnno, inColor, TRUE, inCantidadMotores, inCantidadHelices);
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función para insertar motos
CREATE FUNCTION InsertarMotocicleta(
	inIdMarca INT, 
	inCantPasajeros INT,
	inUnidadesStock INT,
	inPeso INT,
	inTamanno INT,
	inPrecio MONEY,
	inModelo VARCHAR,
	inAnno DATE,
	inColor VARCHAR,
	inCantidadMarchas INT,
	inIdTipoCambios INT
	) 
RETURNS INT
AS
$$
BEGIN 
	
	--Valida si existe la marca y el tipo de cambios ingresados en sus respectivas tablas
	IF (NOT EXISTS(SELECT Id FROM Marca WHERE Id = inIdMarca) OR 
	   NOT EXISTS (SELECT Id FROM TipoCambios WHERE Id = inIdTipoCambios))
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se inserta la motocicleta
	INSERT INTO Motocicleta (IdMarca, CantidadPasajeros, UnidadesEnStock,
						   PesoKg, TamannoMetros, Precio, Modelo, Anno, 
						   Color, Activo, CantMarchas, IdTipoCambios)
	VALUES(inIdMarca, inCantPasajeros, inUnidadesStock, inPeso, inTamanno, 
		   inPrecio, inModelo, inAnno, inColor, TRUE, inCantidadMarchas, inIdTipoCambios);
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función para insertar los autos
CREATE FUNCTION InsertarAutomovil(
	inIdMarca INT, 
	inCantPasajeros INT,
	inUnidadesStock INT,
	inPeso INT,
	inTamanno INT,
	inPrecio MONEY,
	inModelo VARCHAR,
	inAnno DATE,
	inColor VARCHAR,
	inCilindraje INT,
	inIdTipoCambios INT
	) 
RETURNS INT
AS
$$
BEGIN 
	
	--Valida si existe la marca y el tipo de cambios ingresados en sus respectivas tablas
	IF (NOT EXISTS(SELECT Id FROM Marca WHERE Id = inIdMarca) OR 
	   NOT EXISTS (SELECT Id FROM TipoCambios WHERE Id = inIdTipoCambios))
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se inserta el auto
	INSERT INTO Automovil (IdMarca, CantidadPasajeros, UnidadesEnStock,
						   PesoKg, TamannoMetros, Precio, Modelo, Anno, 
						   Color, Activo, Cilindraje, IdTipoCambios)
	VALUES(inIdMarca, inCantPasajeros, inUnidadesStock, inPeso, inTamanno, 
		   inPrecio, inModelo, inAnno, inColor, TRUE, inCilindraje, inIdTipoCambios);
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Funciones para eliminar productos

--Función que realiza el delete del CRUD para los productos
CREATE FUNCTION EliminarProductos(inIdProducto INT)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del producto ingresado, si exista en el inventario
	IF NOT EXISTS(SELECT Id FROM MedioTransporte WHERE Id = inIdProducto)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se realiza un borrado lógico del producto, cambio el estado del campo activo
	UPDATE MedioTransporte
	SET Activo = FALSE
	WHERE Id = inIdProducto;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Funciones para consultar productos, las consultas pueden o no recibir un IdProducto si se desea filtrar la busqueda

--Función que lista las bicicletas, retorna a partir de una tabla declara en la función 
CREATE OR REPLACE FUNCTION ConsultarBicicletas(inIdProducto INT DEFAULT NULL)
RETURNS TABLE (Id INT, Marca VARCHAR, Pasajeros INT, UnidadesStock INT, 
			   PesoKg INT, Tamanno INT, Precio MONEY, Modelo VARCHAR, Anno DATE,
			   Color VARCHAR, Activo BOOLEAN, Marco INT, Horquilla INT)
AS 
$$
BEGIN

	--Retorna el query de la consulta, procesa el join y lo devuelve por medio de la tabla declarada arriba
	RETURN QUERY SELECT B.Id, M.Nombre, B.CantidadPasajeros, B.UnidadesEnStock,
						B.PesoKg, B.TamannoMetros, B.Precio, B.Modelo, B.Anno, B.Color,
						B.Activo, B.Marco, B.Horquilla
				 FROM Bicicleta B
				 INNER JOIN Marca M ON M.Id = B.IdMarca
				 WHERE B.ID= COALESCE(inIdProducto,B.Id) 	--Permite que se filtre la búsqueda por el IdProducto
				 	   AND B.Activo = TRUE;					--Sino se ingresa Id, retorna todas las tuplas activas
END
$$ LANGUAGE plpgsql;


--Función que lista los helicopteros, retorna a partir de una tabla declara en la función 
CREATE OR REPLACE FUNCTION ConsultarHelicopteros(inIdProducto INT DEFAULT NULL)
RETURNS TABLE (Id INT, Marca VARCHAR, Pasajeros INT, UnidadesStock INT, 
			   PesoKg INT, Tamanno INT, Precio MONEY, Modelo VARCHAR, Anno DATE,
			   Color VARCHAR, Activo BOOLEAN, CantMotores INT, CantHelices INT)
AS 
$$
BEGIN

	--Retorna el query de la consulta, procesa el join y lo devuelve por medio de la tabla declarada arriba
	RETURN QUERY SELECT H.Id, M.Nombre, H.CantidadPasajeros, H.UnidadesEnStock,
						H.PesoKg, H.TamannoMetros, H.Precio, H.Modelo, H.Anno, H.Color,
						H.Activo, H.CantMotores, H.CantHelices
				 FROM Helicoptero H
				 INNER JOIN Marca M ON M.Id = H.IdMarca
				 WHERE H.ID= COALESCE(inIdProducto, H.Id)	--Permite que se filtre la búsqueda por el IdProducto
				 	   AND H.Activo = TRUE;					--Sino se ingresa Id, retorna todas las tuplas activas
END
$$ LANGUAGE plpgsql;


--Función que lista las motos, retorna a partir de una tabla declara en la función 
CREATE OR REPLACE FUNCTION ConsultarMotocicletas(inIdProducto INT DEFAULT NULL)
RETURNS TABLE (Id INT, Marca VARCHAR, Pasajeros INT, UnidadesStock INT, 
			   PesoKg INT, Tamanno INT, Precio MONEY, Modelo VARCHAR, Anno DATE,
			   Color VARCHAR, Activo BOOLEAN, CantMarchas INT, TipoCambios VARCHAR)
AS 
$$
BEGIN

	--Retorna el query de la consulta, procesa los joins y lo devuelve por medio de la tabla declarada arriba
	RETURN QUERY SELECT M.Id, Ma.Nombre, M.CantidadPasajeros, M.UnidadesEnStock,
						M.PesoKg, M.TamannoMetros, M.Precio, M.Modelo, M.Anno, M.Color,
						M.Activo, M.CantMarchas, T.Nombre
				 FROM Motocicleta M
				 INNER JOIN Marca Ma ON Ma.Id = M.IdMarca
				 INNER JOIN TipoCambios T ON T.Id = M.IdTipoCambios
				 WHERE M.ID= COALESCE(inIdProducto, M.Id)	--Permite que se filtre la búsqueda por el IdProducto
				 	   AND M.Activo=TRUE;					--Sino se ingresa Id, retorna todas las tuplas activas															
END
$$ LANGUAGE plpgsql;


--Función que lista los automoviles, retorna a partir de una tabla declara en la función 
CREATE OR REPLACE FUNCTION ConsultarAutomoviles(inIdProducto INT DEFAULT NULL)
RETURNS TABLE (Id INT, Marca VARCHAR, Pasajeros INT, UnidadesStock INT, 
			   PesoKg INT, Tamanno INT, Precio MONEY, Modelo VARCHAR, Anno DATE,
			   Color VARCHAR, Activo BOOLEAN, Cilindraje INT, TipoCambios VARCHAR)
AS 
$$
BEGIN

	--Retorna el query de la consulta, procesa el join y lo devuelve por medio de la tabla declarada arriba
	RETURN QUERY SELECT A.Id, M.Nombre, A.CantidadPasajeros, A.UnidadesEnStock,
						A.PesoKg, A.TamannoMetros, A.Precio, A.Modelo, A.Anno, A.Color,
						A.Activo, A.Cilindraje, T.Nombre
				 FROM Automovil A
				 INNER JOIN Marca M ON M.Id = A.IdMarca
				 INNER JOIN TipoCambios T ON T.Id = A.IdTipoCambios
				 WHERE A.ID= COALESCE(inIdProducto, A.Id)	--Permite que se filtre la búsqueda por el IdProducto
						AND A.Activo = TRUE;				--Sino se ingresa Id, retorna todas las tuplas activas
END
$$ LANGUAGE plpgsql;


--Funciones para actualizar los productos

--Función que realiza la actualización de los atributos de los productos 
--que comparten mediante la tabla padre
CREATE OR REPLACE FUNCTION ActualizarProductoGeneral(
	inIdProducto INT,
	inIdMarca INT DEFAULT NULL,
	inCantPasajeros INT DEFAULT NULL,
	inStock INT DEFAULT NULL,
	inPeso INT DEFAULT NULL,
	inTamano INT DEFAULT NULL,
	inPrecio MONEY DEFAULT NULL,
	inModelo VARCHAR DEFAULT NULL,
	inAnno DATE DEFAULT NULL,
	inColor VARCHAR DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del producto ingresado, si exista en el inventario
	IF NOT EXISTS(SELECT Id FROM MedioTransporte WHERE Id = inIdProducto)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Valida si relamente existe el id de marca entrante
	IF ((inIdMarca IS NOT NULL) AND NOT EXISTS (SELECT Id FROM Marca
									WHERE Id = inIdMarca))
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
		
	
	--Actualiza los campos con las variables entrantes, cuando son nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE MedioTransporte 
	SET IdMarca = COALESCE(inIdMarca, IdMarca),
		CantidadPasajeros = COALESCE(inCantPasajeros, CantidadPasajeros),
		UnidadesEnStock = COALESCE(inStock, UnidadesEnStock),
		PesoKg = COALESCE(inPeso, PesoKg),
		TamannoMetros = COALESCE(inTamano, TamannoMetros),
		Precio = COALESCE(inPrecio, Precio),
		Modelo = COALESCE(inModelo, Modelo),
		Anno = COALESCE(inAnno, Anno),
		Color = COALESCE(inColor, Color)
	WHERE Id = inIdProducto
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;

--Este es un ejemplo de como llamar a esta función de actualización general
--SELECT actualizarproductogeneral('3', '1', '23', '12', NULL, '3', '1251000', 'Jet', '2016-07-02', NULL);


--Función que se encarga de actualizar los campos propios de la tabla bicicleta
CREATE OR REPLACE FUNCTION ActualizarBicicleta(
	inIdBicicleta INT,
	inNumeroMarco INT DEFAULT NULL,
	inNumeroHorquilla INT DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del producto ingresado si existe en el inventario
	IF NOT EXISTS(SELECT Id FROM Bicicleta WHERE Id = inIdBicicleta)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
			
	--Actualiza los campos con las variables entrantes, cuando son nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE Bicicleta
	SET Marco = COALESCE(inNumeroMarco, Marco),
		Horquilla = COALESCE(inNumeroHorquilla, Horquilla)
	WHERE Id = inIdBicicleta
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función que se encarga de actualizar los campos propios de la tabla helicoptero
CREATE OR REPLACE FUNCTION ActualizarHelicoptero(
	inIdHelicoptero INT,
	inCantMotores INT DEFAULT NULL,
	inCantHelices INT DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del producto ingresado existe en el inventario
	IF NOT EXISTS(SELECT Id FROM Helicoptero WHERE Id = inIdHelicoptero)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
			
	--Actualiza los campos con las variables entrantes, cuando son nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE Helicoptero
	SET CantMotores = COALESCE(inCantMotores, CantMotores),
		CantHelices = COALESCE(inCantHelices, CantHelices)
	WHERE Id = inIdHelicoptero
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función que se encarga de actualizar los campos propios de la tabla automovil
CREATE OR REPLACE FUNCTION ActualizarAutomovil(
	inIdAutoMovil INT,
	inCilindraje INT DEFAULT NULL,
	inIdTipoCambios INT DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del producto ingresado existe en el inventario
	IF NOT EXISTS(SELECT Id FROM Automovil WHERE Id = inIdAutoMovil)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Valida si existe la caja de cambios en su tabla catalogo
	IF ((inIdTipoCambios IS NOT NULL) AND NOT EXISTS (SELECT Id FROM Tipocambios
									WHERE Id = inIdTipoCambios))
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Actualiza los campos con las variables entrantes, cuando son nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE Automovil
	SET Cilindraje = COALESCE(inCilindraje, Cilindraje),
		IdTipoCambios = COALESCE(inIdTipoCambios, IdTipoCambios)
	WHERE Id = inIdAutomovil
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función que se encarga de actualizar los campos propios de la tabla motocicleta
CREATE OR REPLACE FUNCTION ActualizarMotocicleta(
	inIdMotocicleta INT,
	inCantMarchas INT DEFAULT NULL,
	inIdTipoCambios INT DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del producto ingresado existe en el inventario
	IF NOT EXISTS(SELECT Id FROM Motocicleta WHERE Id = inIdMotocicleta)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Valida si existe la caja de cambios en su tabla catalogo
	IF ((inIdTipoCambios IS NOT NULL) AND NOT EXISTS (SELECT Id FROM Tipocambios
									WHERE Id = inIdTipoCambios))
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Actualiza los campos con las variables entrantes, cuando son nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE Motocicleta
	SET CantMarchas = COALESCE(inCantMarchas, CantMarchas),
		IdTipoCambios = COALESCE(inIdTipoCambios, IdTipoCambios)
	WHERE Id = inIdMotocicleta
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;
