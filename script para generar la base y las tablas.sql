-- Database: TiendaMediosTransporte

-- DROP DATABASE "TiendaMediosTransporte";

CREATE DATABASE "TiendaMediosTransporte"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;


--Tablas para productos

--Tabla catalogo para las marcas de todos los medios de transporte
CREATE TABLE Marca(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64) NOT NULL
);

--Tabla catalogo para los asignar el tipo de marcha de carros y motos
CREATE TABLE TipoCambios(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64) NOT NULL
);

--Tabla padre de los medios de transporte
CREATE TABLE MedioTransporte(
	Id SERIAL PRIMARY KEY,
	IdMarca INT REFERENCES Marca(Id) NOT NULL,
	CantidadPasajeros INT NOT NULL,
	UnidadesEnStock INT NOT NULL,
	PesoKg INT NOT NULL,
	TamannoMetros INT NOT NULL,
	Precio MONEY NOT NULL,
	Modelo VARCHAR(64) NOT NULL,
	Anno DATE NOT NULL,
	Color VARCHAR(64) NOT NULL,
	Activo BOOLEAN NOT NULL
);

--Tabla hija para las bicicletas
CREATE TABLE Bicicleta(
	PRIMARY KEY(Id),
	Marco INT NOT NULL,
	Horquilla INT NOT NULL
) INHERITS (MedioTransporte);

--Tabla hija para las motocicletas
CREATE TABLE Motocicleta(
	PRIMARY KEY(Id),
	IdTipoCambios INT REFERENCES TipoCambios(Id) NOT NULL
	CantMarchas INT NOT NULL,
)INHERITS (MedioTransporte);

--Tabla hija para los automoviles
CREATE TABLE Automovil(
	PRIMARY KEY(Id),
	IdTipoCambios INT REFERENCES TipoCambios(Id) NOT NULL
	Cilindraje INT NOT NULL,
)INHERITS (MedioTransporte);

--Tabla hija para los helicopteros
CREATE TABLE Helicoptero(
	PRIMARY KEY(Id),
	CantMotores INT NOT NULL,
	CantHelices INT NOT NULL
)INHERITS (MedioTransporte);


--Tablas para clientes

--Tabla de clientes con sus campos
CREATE TABLE Cliente(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64) NOT NULL,
	Apellido VARCHAR(64) NOT NULL,
	Cedula VARCHAR(64) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Activo BOOLEAN NOT NULL,
	esVIP BOOLEAN NOT NULL,
	Gustos TEXT []
);


--Tabla para registrar los regalos, el cliente y su fecha
CREATE TABLE Regalo(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64) NOT NULL,
	Activo BOOLEAN
);

--Tabla de todos los regalos que se le han enviado al cliente.
CREATE TABLE RegaloxCliente(
	Id SERIAL PRIMARY KEY,
	IdRegalo INT REFERENCES Regalo(Id) NOT NULL,
	IdCliente INT REFERENCES Cliente(Id) NOT NULL,
	FechaCompra DATE NOT NULL
);


--Tablas para la facturación

--Tabla de factura
CREATE TABLE Factura(
	Id SERIAL PRIMARY KEY,
	IdCliente INT REFERENCES Cliente(Id) NOT NULL,
	FechaCompra DATE NOT NULL,
	Activo BOOLEAN NOT NULL,
);



--Hay que revisar esta tabla
--Tabla para llevar un registro de lso productos vendidos
CREATE TABLE ProductoXFactura(
	Id SERIAL PRIMARY KEY,
	IdFactura INT REFERENCES Factura(Id) NOT NULL,
	--Acá deberían de ir los objetos vendidos (¿como ponerlos?)
)
