-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         11.5.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.6.0.6765
-- --------------------------------------------------------
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET NAMES utf8 */
;
/*!50503 SET NAMES utf8mb4 */
;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */
;
/*!40103 SET TIME_ZONE='+00:00' */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;
-- Volcando estructura de base de datos para el_triunfo
CREATE DATABASE IF NOT EXISTS `el_triunfo`
/*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci */
;
USE `el_triunfo`;
-- Volcando estructura para tabla el_triunfo.articulo
CREATE TABLE IF NOT EXISTS `articulo` (
  `idArticulo` int(11) NOT NULL,
  `precioArticulo` decimal(6, 2) DEFAULT NULL,
  `nomArt` varchar(50) DEFAULT NULL,
  `stock` varchar(50) DEFAULT NULL,
  `unidad` int(11) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `idClasificacion` int(11) DEFAULT NULL,
  `idMarca` int(11) DEFAULT NULL,
  PRIMARY KEY (`idArticulo`),
  KEY `idClasificacion1` (`idClasificacion`),
  KEY `idMarca1` (`idMarca`),
  CONSTRAINT `idClasificacion1` FOREIGN KEY (`idClasificacion`) REFERENCES `clasificacion` (`idClasificacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idMarca1` FOREIGN KEY (`idMarca`) REFERENCES `marca` (`idMarca`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.articulo: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.articuloproveedor
CREATE TABLE IF NOT EXISTS `articuloproveedor` (
  `idarticuloProveedor` smallint(6) NOT NULL AUTO_INCREMENT,
  `fechaSurt` date DEFAULT NULL,
  `cantidad` decimal(6, 2) DEFAULT NULL,
  `costoSurt` decimal(6, 2) DEFAULT NULL,
  `idArticulo` int(11) DEFAULT NULL,
  `RFC` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idarticuloProveedor`),
  KEY `idArticulo2` (`idArticulo`),
  KEY `RFC2` (`RFC`),
  CONSTRAINT `RFC2` FOREIGN KEY (`RFC`) REFERENCES `proveedor` (`RFC`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idArticulo2` FOREIGN KEY (`idArticulo`) REFERENCES `articulo` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.articuloproveedor: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.clasificacion
CREATE TABLE IF NOT EXISTS `clasificacion` (
  `idClasificacion` int(11) NOT NULL,
  `nombreClasificacion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idClasificacion`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.clasificacion: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `numTel` bigint(20) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  KEY `idDomicilio2` (`idDomicilio`),
  CONSTRAINT `idDomicilio2` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.cliente: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.domicilio
CREATE TABLE IF NOT EXISTS `domicilio` (
  `idDomicilio` int(11) NOT NULL AUTO_INCREMENT,
  `calle` varchar(50) DEFAULT NULL,
  `numero` int(11) DEFAULT NULL,
  `cp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`idDomicilio`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.domicilio: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.empleado
CREATE TABLE IF NOT EXISTS `empleado` (
  `codEmp` smallint(6) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellidoM` varchar(20) DEFAULT NULL,
  `apellidoP` varchar(20) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `sueldo` decimal(6, 2) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`codEmp`),
  KEY `fkDomicilio1` (`idDomicilio`),
  CONSTRAINT `fkDomicilio1` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.empleado: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.marca
CREATE TABLE IF NOT EXISTS `marca` (
  `idMarca` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idMarca`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.marca: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.proveedor
CREATE TABLE IF NOT EXISTS `proveedor` (
  `RFC` varchar(50) NOT NULL,
  `razonSocial` varchar(100) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `idDomicilio` int(11) DEFAULT NULL,
  PRIMARY KEY (`RFC`),
  KEY `idDomicilio3` (`idDomicilio`),
  CONSTRAINT `idDomicilio3` FOREIGN KEY (`idDomicilio`) REFERENCES `domicilio` (`idDomicilio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.proveedor: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.venta
CREATE TABLE IF NOT EXISTS `venta` (
  `idVenta` smallint(6) NOT NULL,
  `totalVenta` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `codEmp` smallint(6) DEFAULT NULL,
  `idCliente` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `codEmp1` (`codEmp`),
  KEY `idCliente1` (`idCliente`),
  CONSTRAINT `codEmp1` FOREIGN KEY (`codEmp`) REFERENCES `empleado` (`codEmp`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idCliente1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.venta: ~0 rows (aproximadamente)
-- Volcando estructura para tabla el_triunfo.ventaaarticulo
CREATE TABLE IF NOT EXISTS `ventaaarticulo` (
  `idVentaArticulo` smallint(6) NOT NULL AUTO_INCREMENT,
  `nomArt` varchar(50) DEFAULT NULL,
  `precio` decimal(6, 2) DEFAULT NULL,
  `importe` decimal(6, 2) DEFAULT NULL,
  `idventa` smallint(6) DEFAULT NULL,
  `idArticulo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idVentaArticulo`),
  KEY `idVenta1` (`idventa`),
  KEY `idArticulo1` (`idArticulo`),
  CONSTRAINT `idArticulo1` FOREIGN KEY (`idArticulo`) REFERENCES `articulo` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idVenta1` FOREIGN KEY (`idventa`) REFERENCES `venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_spanish_ci;
-- Volcando datos para la tabla el_triunfo.ventaaarticulo: ~0 rows (aproximadamente)
/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */
;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */
;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */
;