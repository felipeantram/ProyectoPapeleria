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
  `nombreCompleto` varchar(50) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(15) NOT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `codigoAdmin` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idAdmin`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `codigoAdmin` (`codigoAdmin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.administrador: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.articulo
CREATE TABLE IF NOT EXISTS `articulo` (
  `idArticulo` int(11) NOT NULL AUTO_INCREMENT,
  `precioArticulo` decimal(10,2) DEFAULT NULL,
  `nomArt` varchar(50) DEFAULT NULL,
  `stock` varchar(50) DEFAULT NULL,
  `unidad` int(11) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `idClasificacion` int(11) DEFAULT NULL,
  `idMarca` int(11) DEFAULT NULL,
  PRIMARY KEY (`idArticulo`),
  KEY `fkIdClasificacion` (`idClasificacion`),
  KEY `fkIdMarca` (`idMarca`),
  CONSTRAINT `fkIdClasificacion` FOREIGN KEY (`idClasificacion`) REFERENCES `clasificacion` (`idClasificacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkIdMarca` FOREIGN KEY (`idMarca`) REFERENCES `marca` (`idMarca`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.articulo: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.articuloproveedor
CREATE TABLE IF NOT EXISTS `articuloproveedor` (
  `idArticuloProveedor` smallint(6) NOT NULL AUTO_INCREMENT,
  `fechaSurt` date DEFAULT NULL,
  `cantidad` decimal(10,2) DEFAULT NULL,
  `costoSurt` decimal(10,2) DEFAULT NULL,
  `idArticulo` int(11) DEFAULT NULL,
  `RFC` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idArticuloProveedor`),
  KEY `fkArticuloProveedor` (`idArticulo`),
  KEY `fkRFCProveedor` (`RFC`),
  CONSTRAINT `fkArticuloProveedor` FOREIGN KEY (`idArticulo`) REFERENCES `articulo` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkRFCProveedor` FOREIGN KEY (`RFC`) REFERENCES `proveedor` (`RFC`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.articuloproveedor: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.clasificacion
CREATE TABLE IF NOT EXISTS `clasificacion` (
  `idClasificacion` int(5) NOT NULL AUTO_INCREMENT,
  `nombreClasificacion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idClasificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.clasificacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(10) NOT NULL AUTO_INCREMENT,
  `nombreCompleto` varchar(50) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(15) NOT NULL,
  `telefono` int(10) NOT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `correo` (`correo`),
  KEY `fkDomicilioCliente` (`idDomicilio`),
  CONSTRAINT `fkDomicilioCliente` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.cliente: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.domicilio
CREATE TABLE IF NOT EXISTS `domicilio` (
  `idDomicilio` int(4) NOT NULL AUTO_INCREMENT,
  `calle` varchar(30) DEFAULT NULL,
  `numero` varchar(5) DEFAULT NULL,
  `colonia` varchar(30) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idDomicilio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.domicilio: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.empleado
CREATE TABLE IF NOT EXISTS `empleado` (
  `idEmp` int(10) NOT NULL AUTO_INCREMENT,
  `nombreCompleto` varchar(70) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contraseña` varchar(15) NOT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `sueldo` decimal(10,2) DEFAULT NULL,
  `idDomicilio` int(4) DEFAULT NULL,
  PRIMARY KEY (`idEmp`),
  UNIQUE KEY `correo` (`correo`),
  KEY `fkDomicilioEmpleado` (`idDomicilio`),
  CONSTRAINT `fkDomicilioEmpleado` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.empleado: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.marca
CREATE TABLE IF NOT EXISTS `marca` (
  `idMarca` int(5) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idMarca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.marca: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.proveedor
CREATE TABLE IF NOT EXISTS `proveedor` (
  `RFC` varchar(50) NOT NULL,
  `razonSocial` varchar(100) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`RFC`),
  KEY `fkDomicilioProveedor` (`idDomicilio`),
  CONSTRAINT `fkDomicilioProveedor` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.proveedor: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.venta
CREATE TABLE IF NOT EXISTS `venta` (
  `idVenta` smallint(6) NOT NULL AUTO_INCREMENT,
  `totalVenta` decimal(10,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `idEmp` int(10) DEFAULT NULL,
  `idCliente` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `fkidEmp` (`idEmp`),
  KEY `fkIdCliente` (`idCliente`),
  CONSTRAINT `fkIdCliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkidEmp` FOREIGN KEY (`idEmp`) REFERENCES `empleado` (`idEmp`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.venta: ~0 rows (aproximadamente)

-- Volcando estructura para tabla el_triunfo.ventaarticulo
CREATE TABLE IF NOT EXISTS `ventaarticulo` (
  `idVentaArticulo` smallint(6) NOT NULL AUTO_INCREMENT,
  `nomArt` varchar(50) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `importe` decimal(10,2) DEFAULT NULL,
  `idVenta` smallint(6) DEFAULT NULL,
  `idArticulo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVentaArticulo`),
  KEY `fkIdVenta` (`idVenta`),
  KEY `fkIdArticulo` (`idArticulo`),
  CONSTRAINT `fkIdArticulo` FOREIGN KEY (`idArticulo`) REFERENCES `articulo` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkIdVenta` FOREIGN KEY (`idVenta`) REFERENCES `venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Volcando datos para la tabla el_triunfo.ventaarticulo: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
