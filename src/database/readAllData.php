<?php #no se hace ningun cambio 

header('Content-Type: application/json');
require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();

    $entrada = json_decode(file_get_contents('php://input'), true);
    $tabla = $entrada['tabla'] ?? null;

    $tablasValidas = ['producto', 'categoria', 'cliente', 'usuario2'];
    if (!in_array($tabla, $tablasValidas)) {
        echo json_encode(["errorDB" => "Tabla no permitida."]);
        exit;
    }

    $sql = "SELECT * FROM `$tabla`";
    $resultado = $conn->query($sql);
    $datos = $resultado->fetchAll(PDO::FETCH_ASSOC);


    echo json_encode($datos ?: []);

} catch (PDOException $e) {
    echo json_encode(["errorDB" => "Error en la consulta: " . $e->getMessage()]);
}
?>