
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Telefono VARCHAR(20),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Direccion VARCHAR(200),
    Ciudad VARCHAR(50),
    Pais VARCHAR(50)
);
CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Telefono VARCHAR(20),
    FechaContratacion DATE,
    Puesto VARCHAR(50),
    Salario DECIMAL(10,2),
    Departamento VARCHAR(50)
);

CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY(1,1),
    ClienteID INT NOT NULL,
	EmpleadoID INT NOT NULL,
    FechaVenta DATETIME DEFAULT GETDATE(),
    Total DECIMAL(12,2) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Completada',
    MetodoPago VARCHAR(50),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
	FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);


-- Tabla Categorias (nueva)
CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255)
);

-- Tabla Subcategorias (nueva)
CREATE TABLE Subcategorias (
    SubcategoriaID INT PRIMARY KEY IDENTITY(1,1),
    CategoriaID INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);

-- Tabla Marcas (nueva)
CREATE TABLE Marcas (
    MarcaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    PaisOrigen VARCHAR(50)
);

-- Tabla Productos (modificada)

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    NombreProducto VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255),
    PrecioUnitario DECIMAL(10,2) NOT NULL,
	SubcategoriaID INT,  -- Antes era Categoria directa
    MarcaID INT,         -- Nuevo campo
    Stock INT DEFAULT 0,
	Activo BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE()
	FOREIGN KEY (SubcategoriaID) REFERENCES Subcategorias(SubcategoriaID),
    FOREIGN KEY (MarcaID) REFERENCES Marcas(MarcaID)
);
CREATE TABLE DetalleVentas (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    VentaID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Descuento DECIMAL(10,2) DEFAULT 0,
    Subtotal AS (Cantidad * PrecioUnitario - Descuento),
    FOREIGN KEY (VentaID) REFERENCES Ventas(VentaID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);


/*
-------------INSERCIÓN DE DATOS---------
*/


INSERT INTO Clientes (Nombre, Apellido, Email, Telefono, Direccion, Ciudad, Pais)
VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '555-1001', 'Calle 123', 'Ciudad de México', 'México'),
('María', 'Gómez', 'maria.gomez@email.com', '555-1002', 'Avenida 456', 'Bogotá', 'Colombia'),
('Carlos', 'López', 'carlos.lopez@email.com', '555-1003', 'Carrera 789', 'Lima', 'Perú'),
('Ana', 'Martínez', 'ana.martinez@email.com', '555-1004', 'Boulevard 012', 'Santiago', 'Chile'),
('Pedro', 'Rodríguez', 'pedro.rodriguez@email.com', '555-1005', 'Avenida 345', 'Buenos Aires', 'Argentina');

-- Poblar Categorias
INSERT INTO Categorias (Nombre, Descripcion) VALUES
('Electrónicos', 'Dispositivos electrónicos y accesorios'),
('Muebles', 'Mobiliario para oficina y hogar'),
('Oficina', 'Artículos de papelería y suministros');

-- Poblar Subcategorias
INSERT INTO Subcategorias (CategoriaID, Nombre) VALUES
(1, 'Computadoras'), (1, 'Smartphones'), (1, 'Monitores'),
(2, 'Sillas'), (2, 'Mesas'), (3, 'Material Escritorio');

-- Poblar Marcas
INSERT INTO Marcas (Nombre, PaisOrigen) VALUES
('TechMaster', 'EE.UU.'), ('DuraFurn', 'México'), 
('OfficePro', 'Canadá'), ('VisionPlus', 'China');

INSERT INTO Productos (NombreProducto, Descripcion, PrecioUnitario, SubcategoriaID,MarcaID, Stock)
VALUES
('Laptop Elite', 'Laptop de 15 pulgadas, 16GB RAM', 1200.00, 1,1, 50),
('Smartphone X', 'Teléfono inteligente 128GB', 800.00, 1,2, 100),
('Mesa Ejecutiva', 'Mesa de oficina de roble', 450.00, 2,2, 20),
('Silla Ergonómica', 'Silla de oficina ajustable', 250.00,3,3, 30),
('Monitor 27"', 'Monitor Full HD IPS', 300.00, 1,4,40);

INSERT INTO Empleados (Nombre, Apellido, Email, Telefono, FechaContratacion, Puesto, Salario, Departamento)
VALUES
('Laura', 'Sánchez', 'laura.sanchez@empresa.com', '555-2001', '2020-01-15', 'Vendedor', 2500.00, 'Ventas'),
('Roberto', 'Fernández', 'roberto.fernandez@empresa.com', '555-2002', '2019-05-20', 'Gerente', 4000.00, 'Ventas'),
('Sofía', 'Díaz', 'sofia.diaz@empresa.com', '555-2003', '2021-03-10', 'Vendedor', 2300.00, 'Ventas'),
('Jorge', 'Hernández', 'jorge.hernandez@empresa.com', '555-2004', '2022-02-18', 'Asistente', 2000.00, 'Administración'),
('Diana', 'Ramírez', 'diana.ramirez@empresa.com', '555-2005', '2020-11-05', 'Vendedor', 2600.00, 'Ventas');

INSERT INTO Ventas (ClienteID, EmpleadoID, FechaVenta, Total, Estado, MetodoPago)
VALUES
(1, 1, CONVERT(DATETIME, '2023-01-10 09:30:00', 120), 1650.00, 'Completada', 'Tarjeta'),
(2, 3, CONVERT(DATETIME, '2023-01-12 14:15:00', 120), 800.00, 'Completada', 'Efectivo'),
(3, 1, CONVERT(DATETIME, '2023-01-15 11:00:00', 120), 700.00, 'Completada', 'Transferencia'),
(4, 5, CONVERT(DATETIME, '2023-01-18 16:45:00', 120), 1450.00, 'Completada', 'Tarjeta'),
(5, 3, CONVERT(DATETIME, '2023-01-20 10:30:00', 120), 300.00, 'Pendiente', 'Efectivo');

INSERT INTO DetalleVentas (VentaID, ProductoID, Cantidad, PrecioUnitario, Descuento)
VALUES
(1,1, 1, 1200.00, 0),    -- Venta 1: 1 Laptop Elite
(1,5, 1, 300.00, 150.00), -- Venta 1: 1 Monitor con descuento
(2,2, 1, 800.00, 0),      -- Venta 2: 1 Smartphone X
(2,3, 1, 450.00, 0),      -- Venta 3: 1 Mesa Ejecutiva
(3,4, 1, 250.00, 0),      -- Venta 3: 1 Silla Ergonómica
(4,1, 1, 1200.00, 0),     -- Venta 4: 1 Laptop Elite
(4,4, 1, 250.00, 0),      -- Venta 4: 1 Silla Ergonómica
(5,5, 1, 300.00, 0);      -- Venta 5: 1 Monitor 27"


/*
--------------CONSULTAS BASICAS------------
*/


SELECT VentaID, ClienteID, Total, FechaVenta 
FROM Ventas 
ORDER BY VentaID;

SELECT ProductoID, NombreProducto, PrecioUnitario 
FROM Productos 
ORDER BY ProductoID;

SELECT ProductoID, NombreProducto, PrecioUnitario 
FROM Productos 
ORDER BY ProductoID;

SELECT p.NombreProducto, 
       dv.Cantidad, dv.PrecioUnitario, dv.Descuento, dv.Subtotal
FROM DetalleVentas dv
JOIN Productos p ON dv.ProductoID = p.ProductoID
ORDER BY dv.VentaID, dv.DetalleID;

/*
ALTER TABLE Ventas
ADD EmpleadoID INT,
CONSTRAINT FK_Ventas_Empleados FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID);
*/