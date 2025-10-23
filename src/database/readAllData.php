<?php

header('Content-Type: application/json');
require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();

    // Decodifica la entrada JSON enviada al script
    $entrada = json_decode(file_get_contents('php://input'), true);
    $tabla = $entrada['tabla'] ?? null;

    // --- MODIFICACIÓN CLAVE AQUÍ ---
    // Se cambia 'usuario2' por 'usuario' que es el nombre correcto de la tabla según el SQL.
    // También se añade 'administrador' y 'empleado' si se quiere consultar esas tablas directamente.
    $tablasValidas = ['producto', 'categoria', 'cliente', 'usuario', 'administrador', 'empleado', 'domicilio', 'cargo', 'tipopago'];

    if (!in_array($tabla, $tablasValidas)) {
        echo json_encode(["errorDB" => "Tabla no permitida."]);
        exit;
    }

    // Consulta segura: el nombre de la tabla ya fue validado en la lista blanca
    $sql = "SELECT * FROM `$tabla`";
    $resultado = $conn->query($sql);
    $datos = $resultado->fetchAll(PDO::FETCH_ASSOC);

    // Retorna los datos o un array vacío si no hay resultados
    echo json_encode($datos ?: []);

} catch (PDOException $e) {
    // Captura errores específicos de la base de datos (SQL)
    echo json_encode(["errorDB" => "Error en la consulta: " . $e->getMessage()]);
} catch (Exception $e) {
    // Captura cualquier otra excepción no cubierta por PDO (aunque el try-catch de PDO la podría manejar)
    echo json_encode(["errorDB" => "Error general: " . $e->getMessage()]);
}
?>