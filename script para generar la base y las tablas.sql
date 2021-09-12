-- Database: TareaObjetoRelacion

-- DROP DATABASE "TareaObjetoRelacion";

CREATE DATABASE "TareaObjetoRelacion"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Costa Rica.1252'
    LC_CTYPE = 'Spanish_Costa Rica.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	

CREATE TABLE TipoCambios(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64) NOT NULL
);


CREATE TABLE MedioTransporte(
	Id SERIAL PRIMARY KEY,
	Marca VARCHAR(64) NOT NULL,
	Pasajeros INT NOT NULL,
	PesoKg INT NOT NULL,
	TamannoMetros INT NOT NULL,
	Precio MONEY NOT NULL,
	Modelo VARCHAR(64) NOT NULL,
	Anno DATE NOT NULL,
	Color VARCHAR(64) NOT NULL
);

CREATE TABLE Bicicleta(
	PRIMARY KEY(Id),
	Marco INT NOT NULL,
	Horquilla INT NOT NULL
) INHERITS (MedioTransporte);



CREATE TABLE Motocicleta(
	PRIMARY KEY(Id),
	CantMarchas INT NOT NULL,
	IdTipoCambios INT REFERENCES TipoCambios(Id) NOT NULL
)INHERITS (MedioTransporte);



CREATE TABLE Automovil(
	PRIMARY KEY(Id),
	Cilindraje INT NOT NULL,
	IdTipoCambios INT REFERENCES TipoCambios(Id) NOT NULL
)INHERITS (MedioTransporte);



CREATE TABLE Helicoptero(
	PRIMARY KEY(Id),
	CantMotores INT NOT NULL,
	CantHelices INT NOT NULL
)INHERITS (MedioTransporte);


CREATE TABLE Inventario(
	Id SERIAL PRIMARY KEY,
	Numero INT NOT NULL
);

CREATE TABLE ProductoXInventario(
	Id SERIAL PRIMARY KEY,
	IdInventario INT REFERENCES Inventario(Id) NOT NULL,
	IdProducto INT REFERENCES MedioTransporte(Id) NOT NULL,
	Vendido BIT NOT NULL
);

CREATE TABLE Cliente(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64) NOT NULL,
	Apellido VARCHAR(64) NOT NULL,
	Cedula VARCHAR(64) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Activo BIT NOT NULL
);

CREATE TABLE ClienteVIP(
	PRIMARY KEY(Id),
	FechaIngresoVIP DATE NOT NULL,
	Gustos TEXT []
)INHERITS (Cliente);

CREATE TABLE Regalo(
	Id SERIAL PRIMARY KEY,
	IdCliente INT REFERENCES ClienteVIP(Id) NOT NULL,
	Fecha DATE NOT NULL
);


CREATE TABLE Item(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(64)
);

CREATE TABLE ItemXRegalo(
	Id SERIAL PRIMARY KEY,
	IdRegalo INT REFERENCES Regalo(Id) NOT NULL,
	IdItem INT REFERENCES Item(Id) NOT NULL
);


CREATE TABLE Factura(
	Id SERIAL PRIMARY KEY,
	IdCliente INT REFERENCES Cliente(Id) NOT NULL,
	FechaCompra DATE NOT NULL,
	Activo BIT NOT NULL
);

CREATE TABLE ProductoXFactura(
	Id SERIAL PRIMARY KEY,
	IdFactura INT REFERENCES Factura(Id) NOT NULL,
	IdProducto INT REFERENCES ProductoXInventario(Id) NOT NULL
)