-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         11.5.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para el_triunfo
CREATE DATABASE IF NOT EXISTS `el_triunfo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci */;
USE `el_triunfo`;

-- Volcando estructura para tabla el_triunfo.administrador
CREATE TABLE IF NOT EXISTS `administrador` (
  `idAdmin` int(11) NOT NULL AUTO_INCREMENT,
  `idUsuario` int(11) DEFAULT NULL,
  `codigoAdmin` varchar(10) NOT NULL,
  PRIMARY KEY (`idAdmin`),
  UNIQUE KEY `codigoAdmin` (`codigoAdmin`),
  UNIQUE KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `fkAdminUsuario` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.administrador: ~1 rows (aproximadamente)
INSERT INTO `administrador` (`idAdmin`, `idUsuario`, `codigoAdmin`) VALUES
	(1, 1, 'ADM001');

-- Volcando estructura para tabla el_triunfo.articulo
CREATE TABLE IF NOT EXISTS `articulo` (
  `idArticulo` int(11) NOT NULL AUTO_INCREMENT,
  `nomArt` varchar(50) NOT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `precioArticulo` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `unidad` varchar(20) DEFAULT NULL,
  `idClasificacion` int(11) DEFAULT NULL,
  `idMarca` int(11) DEFAULT NULL,
  PRIMARY KEY (`idArticulo`),
  KEY `fkClasificacionArticulo` (`idClasificacion`),
  KEY `fkMarcaArticulo` (`idMarca`),
  CONSTRAINT `fkClasificacionArticulo` FOREIGN KEY (`idClasificacion`) REFERENCES `clasificacion` (`idClasificacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkMarcaArticulo` FOREIGN KEY (`idMarca`) REFERENCES `marca` (`idMarca`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.articulo: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.cargo
CREATE TABLE IF NOT EXISTS `cargo` (
  `idCargo` int(11) NOT NULL AUTO_INCREMENT,
  `nombreCargo` varchar(50) NOT NULL,
  `sueldoBase` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idCargo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.cargo: ~3 rows (aproximadamente)
INSERT INTO `cargo` (`idCargo`, `nombreCargo`, `sueldoBase`) VALUES
	(1, 'Cajero', 8500.00),
	(2, 'Administrador General', 12000.00),
	(3, 'Vendedor', 7800.00);

-- Volcando estructura para tabla el_triunfo.clasificacion
CREATE TABLE IF NOT EXISTS `clasificacion` (
  `idClasificacion` int(11) NOT NULL AUTO_INCREMENT,
  `nombreClasificacion` varchar(50) NOT NULL,
  PRIMARY KEY (`idClasificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.clasificacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `idUsuario` int(11) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `idUsuario` (`idUsuario`),
  KEY `fkDomicilioCliente` (`idDomicilio`),
  CONSTRAINT `fkClienteUsuario` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkDomicilioCliente` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.cliente: ~1 rows (aproximadamente)
INSERT INTO `cliente` (`idCliente`, `idUsuario`, `telefono`, `idDomicilio`) VALUES
	(1, 3, '2294567890', 3);

-- Volcando estructura para tabla el_triunfo.cortecaja
CREATE TABLE IF NOT EXISTS `cortecaja` (
  `idCorte` int(11) NOT NULL AUTO_INCREMENT,
  `fechaInicio` datetime NOT NULL,
  `fechaCierre` datetime DEFAULT NULL,
  `idEmp` int(11) DEFAULT NULL,
  `montoInicial` decimal(10,2) DEFAULT 0.00,
  `ventasTotales` decimal(10,2) DEFAULT 0.00,
  `ingresos` decimal(10,2) DEFAULT 0.00,
  `egresos` decimal(10,2) DEFAULT 0.00,
  `montoFinal` decimal(10,2) DEFAULT 0.00,
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`idCorte`),
  KEY `fkCorteEmpleado` (`idEmp`),
  CONSTRAINT `fkCorteEmpleado` FOREIGN KEY (`idEmp`) REFERENCES `empleado` (`idEmp`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.cortecaja: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.detallecorte
CREATE TABLE IF NOT EXISTS `detallecorte` (
  `idDetalleCorte` int(11) NOT NULL AUTO_INCREMENT,
  `idCorte` int(11) NOT NULL,
  `idTipoPago` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idDetalleCorte`),
  KEY `fkDetCorte` (`idCorte`),
  KEY `fkDetCorteTipo` (`idTipoPago`),
  CONSTRAINT `fkDetCorte` FOREIGN KEY (`idCorte`) REFERENCES `cortecaja` (`idCorte`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkDetCorteTipo` FOREIGN KEY (`idTipoPago`) REFERENCES `tipopago` (`idTipoPago`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.detallecorte: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.detallepedido
CREATE TABLE IF NOT EXISTS `detallepedido` (
  `idDetallePedido` int(11) NOT NULL AUTO_INCREMENT,
  `idPedido` int(11) DEFAULT NULL,
  `idArticulo` int(11) DEFAULT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `costoUnitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) GENERATED ALWAYS AS (`cantidad` * `costoUnitario`) STORED,
  PRIMARY KEY (`idDetallePedido`),
  KEY `fkDetPedido` (`idPedido`),
  KEY `fkDetArticulo` (`idArticulo`),
  CONSTRAINT `fkDetArticulo` FOREIGN KEY (`idArticulo`) REFERENCES `articulo` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkDetPedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.detallepedido: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.domicilio
CREATE TABLE IF NOT EXISTS `domicilio` (
  `idDomicilio` int(11) NOT NULL AUTO_INCREMENT,
  `calle` varchar(50) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `colonia` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idDomicilio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.domicilio: ~3 rows (aproximadamente)
INSERT INTO `domicilio` (`idDomicilio`, `calle`, `numero`, `colonia`, `ciudad`, `estado`, `cp`) VALUES
	(1, 'Calle 10', '123', 'Centro', 'Veracruz', 'Veracruz', '91700'),
	(2, 'Av. Reforma', '45', 'Centro', 'Veracruz', 'Veracruz', '91710'),
	(3, 'Av. Principal', '200', 'Las Flores', 'Veracruz', 'Veracruz', '91720');

-- Volcando estructura para tabla el_triunfo.empleado
CREATE TABLE IF NOT EXISTS `empleado` (
  `idEmp` int(11) NOT NULL AUTO_INCREMENT,
  `idUsuario` int(11) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  `idCargo` int(11) DEFAULT NULL,
  `sueldo` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idEmp`),
  UNIQUE KEY `idUsuario` (`idUsuario`),
  KEY `fkDomicilioEmpleado` (`idDomicilio`),
  KEY `fkCargoEmpleado` (`idCargo`),
  CONSTRAINT `fkCargoEmpleado` FOREIGN KEY (`idCargo`) REFERENCES `cargo` (`idCargo`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fkDomicilioEmpleado` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fkEmpleadoUsuario` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.empleado: ~1 rows (aproximadamente)
INSERT INTO `empleado` (`idEmp`, `idUsuario`, `idDomicilio`, `idCargo`, `sueldo`) VALUES
	(1, 2, 2, 1, 8500.00);

-- Volcando estructura para tabla el_triunfo.marca
CREATE TABLE IF NOT EXISTS `marca` (
  `idMarca` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idMarca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.marca: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.pago
CREATE TABLE IF NOT EXISTS `pago` (
  `idPago` int(11) NOT NULL AUTO_INCREMENT,
  `idVenta` int(11) NOT NULL,
  `idTipoPago` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `fechaPago` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`idPago`),
  KEY `fkPagoVenta` (`idVenta`),
  KEY `fkPagoTipo` (`idTipoPago`),
  CONSTRAINT `fkPagoTipo` FOREIGN KEY (`idTipoPago`) REFERENCES `tipopago` (`idTipoPago`) ON UPDATE CASCADE,
  CONSTRAINT `fkPagoVenta` FOREIGN KEY (`idVenta`) REFERENCES `venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.pago: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.pedido
CREATE TABLE IF NOT EXISTS `pedido` (
  `idPedido` int(11) NOT NULL AUTO_INCREMENT,
  `fechaPedido` date NOT NULL,
  `totalPedido` decimal(10,2) DEFAULT NULL,
  `RFC` varchar(20) DEFAULT NULL,
  `idEmp` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `fkPedidoProveedor` (`RFC`),
  KEY `fkPedidoEmpleado` (`idEmp`),
  CONSTRAINT `fkPedidoEmpleado` FOREIGN KEY (`idEmp`) REFERENCES `empleado` (`idEmp`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fkPedidoProveedor` FOREIGN KEY (`RFC`) REFERENCES `proveedor` (`RFC`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.pedido: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.proveedor
CREATE TABLE IF NOT EXISTS `proveedor` (
  `RFC` varchar(20) NOT NULL,
  `razonSocial` varchar(100) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`RFC`),
  KEY `fkDomicilioProveedor` (`idDomicilio`),
  CONSTRAINT `fkDomicilioProveedor` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.proveedor: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.tipopago
CREATE TABLE IF NOT EXISTS `tipopago` (
  `idTipoPago` int(11) NOT NULL AUTO_INCREMENT,
  `nombreTipo` varchar(30) NOT NULL,
  PRIMARY KEY (`idTipoPago`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.tipopago: ~3 rows (aproximadamente)
INSERT INTO `tipopago` (`idTipoPago`, `nombreTipo`) VALUES
	(1, 'Efectivo'),
	(2, 'Tarjeta'),
	(3, 'Transferencia');

-- Volcando estructura para tabla el_triunfo.usuario
CREATE TABLE IF NOT EXISTS `usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombreCompleto` varchar(70) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contraseña` varchar(100) NOT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `tipoUsuario` enum('Administrador','Empleado','Cliente') NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.usuario: ~3 rows (aproximadamente)
INSERT INTO `usuario` (`idUsuario`, `nombreCompleto`, `correo`, `contraseña`, `direccion`, `tipoUsuario`, `activo`) VALUES
	(1, 'Felipe de Jesus Antonio Ramirez', 'antram@gmail.com', 'admin1953', 'Calle 10 #123', 'Administrador', 1),
	(2, 'Diana Laura Santiago Hernandez', 'diaherza@gmail.com', 'empl4396', 'Av. Reforma 45', 'Empleado', 1),
	(3, 'Rodrigo Santiago Revilla', 'RodrigoSantiago@gmail.com', '12345', NULL, 'Cliente', 1);

-- Volcando estructura para tabla el_triunfo.venta
CREATE TABLE IF NOT EXISTS `venta` (
  `idVenta` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `totalVenta` decimal(10,2) DEFAULT NULL,
  `idEmp` int(11) DEFAULT NULL,
  `idCliente` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `fkVentaEmpleado` (`idEmp`),
  KEY `fkVentaCliente` (`idCliente`),
  CONSTRAINT `fkVentaCliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fkVentaEmpleado` FOREIGN KEY (`idEmp`) REFERENCES `empleado` (`idEmp`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.venta: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.ventaarticulo
CREATE TABLE IF NOT EXISTS `ventaarticulo` (
  `idVentaArticulo` int(11) NOT NULL AUTO_INCREMENT,
  `idVenta` int(11) DEFAULT NULL,
  `idArticulo` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `importe` decimal(10,2) GENERATED ALWAYS AS (`cantidad` * `precio`) STORED,
  PRIMARY KEY (`idVentaArticulo`),
  KEY `fkVentaArtVenta` (`idVenta`),
  KEY `fkVentaArtArticulo` (`idArticulo`),
  CONSTRAINT `fkVentaArtArticulo` FOREIGN KEY (`idArticulo`) REFERENCES `articulo` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkVentaArtVenta` FOREIGN KEY (`idVenta`) REFERENCES `venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.ventaarticulo: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
