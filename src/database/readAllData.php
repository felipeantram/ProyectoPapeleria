<?php

header('Content-Type: application/json');
require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();

    // 1. Obtener la tabla: Intenta JSON (POST), luego GET (URL)
    $entrada = json_decode(file_get_contents('php://input'), true);
    $tabla = $entrada['tabla'] ?? $_GET['tabla'] ?? null;
    $tabla = strtolower($tabla); // Normalizar a minúsculas para la lista blanca

    // 2. Lista blanca de tablas de EL_TRIUNFO (completa)
    $tablasValidas = [
        'administrador',
        'articulo',
        'cargo',
        'clasificacion',
        'cliente',
        'cortecaja',
        'detallecorte',
        'detallepedido',
        'domicilio',
        'empleado',
        'marca',
        'pago',
        'pedido',
        'proveedor',
        'tipopago',
        'usuario',
        'venta',
        'ventaarticulo'
    ];

    if (!in_array($tabla, $tablasValidas)) {
        echo json_encode(["errorDB" => "Tabla no permitida o no especificada.", "disponibles" => $tablasValidas]);
        exit;
    }

    // 3. Consulta segura
    $sql = "SELECT * FROM `" . $tabla . "`"; // Usa comillas graves para la tabla
    $resultado = $conn->query($sql);
    $datos = $resultado->fetchAll(PDO::FETCH_ASSOC);

    // 4. Retorna los datos
    echo json_encode($datos ?: []);

} catch (PDOException $e) {
    echo json_encode(["errorDB" => "Error en la consulta: " . $e->getMessage()]);
} catch (Exception $e) {
    echo json_encode(["errorDB" => "Error general: " . $e->getMessage()]);
}
?>