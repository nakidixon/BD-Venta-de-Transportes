-CRUD de Clientes, Regalos, Facturas y sus tablas intermedias
--INSERTS

--Función para insertar Cliente
CREATE FUNCTION InsertarCliente(
	inNombre VARCHAR, 
	inApellido VARCHAR,
	inCedula VARCHAR,
	inFechaNacimiento DATE
	) 
RETURNS INT
AS
$$
BEGIN 
	INSERT INTO Cliente (nombre, apellido, cedula, fechaNacimiento,
						   activo,esVIP,gustos)
	VALUES(inNombre, inApellido, inCedula, inFechaNacimiento, TRUE, 
		   FALSE, '{}');
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;

--Funcion para insertar el objeto regalo

CREATE FUNCTION InsertarRegalo(
	inNombre VARCHAR
	) 
RETURNS INT
AS
$$
BEGIN 
	INSERT INTO Regalo (nombre)
	VALUES(inNombre);
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--FALTA Insert de tabla de RegaloxCliente


--Funcion para eliminar clientes
CREATE FUNCTION EliminarCliente(inIdCliente INT)
RETURNS INT 
AS 
$$
BEGIN
	--Consulta si el id del cliente ingresado, si exista en el inventario
	IF NOT EXISTS(SELECT Id FROM Cliente WHERE Id = inIdCliente)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se realiza un borrado lógico del producto, cambio el estado del campo activo
	UPDATE Cliente
	SET Activo = FALSE
	WHERE Id = inIdPCliente;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Funcion para eliminar regalos
CREATE FUNCTION EliminarRegalo(inIdRegalo INT)
RETURNS INT 
AS 
$$
BEGIN
	--Consulta si el id del regalo ingresado, si exista en el inventario
	IF NOT EXISTS(SELECT Id FROM Regalo WHERE Id = inIdRegalo)
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	--Se realiza un borrado lógico del producto, cambio el estado del campo activo
	UPDATE Regalo
	SET Activo = FALSE
	WHERE Id = inIdRegalo;
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Funcion para actualizar clientes

CREATE OR REPLACE FUNCTION ActualizarCliente(
	inIdCliente INT,
	inNombre VARCHAR DEFAULT NULL,
	inApellido VARCHAR DEFAULT NULL,
	inCedula VARCHAR DEFAULT NULL,
	inFechaNacimiento  DATE DEFAULT NULL,
	inEsVIP BOOL DEFAULT NULL,
	inGustos TEXT [] DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del cliente ingresado, si exista en el inventario
	IF NOT EXISTS(SELECT Id FROM Cliente WHERE Id = inIdCliente)
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Actualiza los campos con las variables entrantes, cuando son nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE Cliente 
	SET Nombre = COALESCE(inNombre, Nombre),
		Apellido = COALESCE(inApellido, Apellido),
		Cedula = COALESCE(inCedula, Cedula),
		FechaNacimiento = COALESCE(inFechaNacimiento, FechaNacimiento),
		esVIP = COALESCE(inEsVIP, esVIP),
		gustos = COALESCE(inGustos, Gustos)
	WHERE Id = inIdCliente
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;



--Funcion para actualizar clientes
-Función que se encarga de actualizar los campos propios de la tabla regalo
CREATE OR REPLACE FUNCTION ActualizarRegalo(
	inIdRegalo INT,
	inNombre VARCHAR DEFAULT NULL
	)
RETURNS INT 
AS 
$$
BEGIN
	
	--Consulta si el id del regalo ingresado existe en el inventario
	IF NOT EXISTS(SELECT Id FROM Regalo WHERE Id = inIdRegalo)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Actualiza el nombre del regalo y cuando es nulos le coloca
	--el valor que ya tenían anteriormente
	UPDATE Regalo
	SET Nombre = COALESCE(inNombre, Nombre)
	WHERE Id = inIdRegalo
		  AND Activo = TRUE;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;