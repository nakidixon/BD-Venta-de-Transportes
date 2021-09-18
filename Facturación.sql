--Archivo de facturación

--Función que genera una factura
CREATE OR REPLACE FUNCTION CrearFactura(
	inIdCliente INT
	) 
RETURNS INT
AS
$$
BEGIN 
	
	--Valida si el ciente existe en su tabla
	IF NOT EXISTS(SELECT Id FROM Cliente WHERE Id = inIdCliente)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Se inserta la nueva factura, con el id del cliente y la fecha actual 
	INSERT INTO Factura(IdCliente, FechaCompra, Activo)
	VALUES(inIdCliente, current_date, TRUE);
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función para añadir los productos a la factura
CREATE OR REPLACE FUNCTION AgregarProductoFactura(
	inIdFactura INT,
	inIdProducto INT,
	inCantidad INT
	) 
RETURNS INT
AS
$$
BEGIN 
	
	--Valida si la factura y el producto existen
	IF NOT EXISTS(SELECT Id FROM Factura WHERE Id = inIdFactura)
	   OR NOT EXISTS (SELECT Id FROM MedioTransporte WHERE Id = inIdProducto)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;

	--Valida si hay cantidad de vehiculos suficientes y que el vehículo este activo
	IF (((SELECT UnidadesEnStock FROM MedioTransporte WHERE Id = inIdProducto) < inCantidad)
	   OR NOT(SELECT Activo FROM MedioTransporte WHERE Id = inIdProducto))
	
			--Retorna código de error, unidades insuficientes
		THEN RETURN 4000;
	END IF;
	
	--Se inserta el nuevo producto en la facturación, como un arreglo de enteros
	UPDATE Factura
	SET Productos = Productos || ARRAY[[inIdProducto, inCantidad]]
	WHERE Id = inIdFactura
	AND Activo = TRUE;
	
	--Se actualiza la nueva cantidad de estos productos en stock
	UPDATE MedioTransporte
	SET UnidadesEnStock = UnidadesEnStock - inCantidad
	WHERE Id = inIdProducto;
	
	--Si todo salió bien, retorna código de éxito
	RETURN 0;
END
$$ LANGUAGE plpgsql;


--Función que retorna el monto total de la factura
CREATE OR REPLACE FUNCTION CalcularMontoFactura(inIdFactura INT) 
RETURNS MONEY
AS
$$
DECLARE monto MONEY:= 0;	--Declaración de algunas variables necesarias
		idproducto INT;
		cantidad INT;
		longitud INT;
		i INT := 1;
BEGIN 
	
	--Valida si la factura y el producto existen
	IF NOT EXISTS(SELECT Id FROM Factura WHERE Id = inIdFactura)
		
		--Retorna código de error
		THEN RETURN 50005;
	END IF;
	
	--Captura el largo del arreglo Productos en la variable longitud
	SELECT array_length(Productos, 1) FROM Factura WHERE Id = 1 INTO longitud;
	
	
	--Ciclo while, para ir calculando el monto
	while (i<=longitud) loop
		
		--Obtiene el id del producto y la cantidad comprada, desde cada vector del arreglo
		SELECT Productos[i][1] FROM Factura WHERE Id = inIdFactura INTO idproducto;
		SELECT Productos[i][2] FROM Factura WHERE Id = inIdFactura INTO cantidad;
		
		--Va sumando el monto con el calculo de precio y la cantidad de unidades y lo guarda en monto
		SELECT monto + ((SELECT Precio FROM MedioTransporte WHERE Id = idproducto)*cantidad) INTO monto;
		
		--Suma el indice, para cumplir la condicón de parada
		SELECT  i + 1 INTO i;
	end loop;
	
	--Si todo salió bien, retorna el monto
	RETURN monto;
END
$$ LANGUAGE plpgsql;