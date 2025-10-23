<?php

header('Content-Type: application/json');
require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();
    $entrada = json_decode(file_get_contents('php://input'), true);

    $tabla = $entrada['tabla'] ?? null;
    $datosFormulario = $entrada['datosFormulario'] ?? [];

    $mapeo = [
        'codigobarra' => 'txtCodigoBarra',
        'nombre' => 'txtNombre',
        'precio' => 'txtPrecio',
        'existencia' => 'rngCantidad',
        'idmarca' => 'cboMarca',
        'idcategoria' => 'cboCategoria'
    ];

    foreach ($mapeo as $claveBD => $claveForm) {
        if (!isset($datosFormulario[$claveForm])) {
            throw new Exception("Falta el campo del formulario: $claveForm");
        }
    }

    if (trim($datosFormulario['txtCodigoBarra']) === '') {
        throw new Exception("El ID no puede estar vacío");
    }

    $campos = array_keys($mapeo);

    $valores = array_map(fn($campo) => $datosFormulario[$mapeo[$campo]], $campos);

    $placeholders = implode(', ', array_fill(0, count($campos), '?'));
    $sql = "INSERT INTO `$tabla` (`" . implode('`, `', $campos) . "`) VALUES ($placeholders)";

    $statement = $conn->prepare($sql);
    if (!$statement) {
        throw new Exception("Error al preparar la consulta: " . $conn->error);
    }

    $statement->execute($valores);

    echo json_encode(['estado' => true, 'mensaje' => 'Datos insertados correctamente']);


} catch (PDOException $e) {
    echo json_encode(["errorBD" => "Error en la inserción: " . $e->getMessage()]);
} catch (Exception $e) {
    echo json_encode(["error" => "Error: " . $e->getMessage()]);
} catch (Exception $e) {
    echo json_encode(["error" => "Error: " . $e->getMessage()]);
}

?>