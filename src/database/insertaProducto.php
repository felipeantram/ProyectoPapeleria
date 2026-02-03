<?php

header('Content-Type: application/json');
require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();
    $entrada = json_decode(file_get_contents('php://input'), true);

    // *** Cambios clave aquí: Mapeo a las columnas de la tabla `articulo` ***
    $tabla = 'articulo'; // Fijo para este script
    $datosFormulario = $entrada['datosFormulario'] ?? [];

    $mapeo = [
        // Clave BD (SQL) => Clave Formulario (JS/HTML)
        'nomArt' => 'txtNombre',            // Corresponde a nomArt
        'modelo' => 'txtModelo',            // Nuevo campo, asume que existe
        'precioArticulo' => 'txtPrecio',    // Corresponde a precioArticulo
        'stock' => 'rngCantidad',           // Corresponde a stock
        'unidad' => 'txtUnidad',            // Nuevo campo, asume que existe
        'idMarca' => 'cboMarca',
        'idClasificacion' => 'cboClasificacion' // Corresponde a idClasificacion
    ];

    // Validar campos obligatorios
    foreach ($mapeo as $claveBD => $claveForm) {
        if (!isset($datosFormulario[$claveForm])) {
            throw new Exception("Falta el campo del formulario: $claveForm");
        }
    }

    // Preparar la consulta
    $campos = array_keys($mapeo);
    $valores = array_map(fn($campo) => $datosFormulario[$mapeo[$campo]], $campos);

    $placeholders = implode(', ', array_fill(0, count($campos), '?'));
    $sql = "INSERT INTO `$tabla` (`" . implode('`, `', $campos) . "`) VALUES ($placeholders)";

    $statement = $conn->prepare($sql);
    if (!$statement) {
        throw new Exception("Error al preparar la consulta.");
    }

    $statement->execute($valores);

    echo json_encode(['estado' => true, 'mensaje' => 'Artículo insertado correctamente', 'idArticulo' => $conn->lastInsertId()]);


} catch (PDOException $e) {
    echo json_encode(["errorBD" => "Error en la inserción: " . $e->getMessage()]);
} catch (Exception $e) {
    echo json_encode(["error" => "Error: " . $e->getMessage()]);
}
?>