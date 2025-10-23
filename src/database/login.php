<?php
// FICHERO: login.php (Versión Final)
session_start(); // Inicia la sesión de PHP

header('Content-Type: application/json');
require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();

    // 1. Obtener datos del JSON
    $entrada = json_decode(file_get_contents('php://input'), true);

    // Usamos 'correo' y 'password' como claves de JSON para evitar problemas con la 'ñ'
    $correo = $entrada['correo'] ?? null;
    $contrasena_plana = $entrada['password'] ?? null;

    if (!$correo || !$contrasena_plana) {
        echo json_encode(["error" => "Faltan correo o contraseña.", "logeado" => false]);
        exit;
    }

    // 2. Consulta segura a la tabla 'usuario' (AÑADIMOS 'activo')
    $sql = "SELECT idUsuario, nombreCompleto, contraseña, tipoUsuario, activo 
            FROM usuario 
            WHERE correo = ?";

    $statement = $conn->prepare($sql);
    $statement->execute([$correo]);
    $usuario = $statement->fetch(PDO::FETCH_ASSOC);

    if (!$usuario) {
        echo json_encode(["error" => "Correo no encontrado.", "logeado" => false]);
        exit;
    }

    // 3. Verificación de estado ACTIVO (CRÍTICO)
    if ($usuario['activo'] != 1) {
        echo json_encode(["error" => "El usuario está inactivo o suspendido.", "logeado" => false]);
        exit;
    }

    // 4. Verificación de Contraseña (texto plano, como está en tu BD)
    if ($contrasena_plana !== $usuario['contraseña']) {
        echo json_encode(["error" => "Contraseña incorrecta.", "logeado" => false]);
        exit;
    }

    // 5. Éxito: CREAR LA SESIÓN DE PHP
    $_SESSION['usuario'] = [
        'id' => $usuario['idUsuario'],
        'nombre' => $usuario['nombreCompleto'],
        'rol' => $usuario['tipoUsuario'],
        'logeado' => true
    ];

    // 6. Devolver la respuesta de éxito
    echo json_encode([
        'estado' => true,
        'mensaje' => "Acceso concedido.",
        'logeado' => true,
        'tipoUsuario' => $usuario['tipoUsuario']
    ]);

} catch (PDOException $e) {
    echo json_encode(["errorDB" => "Error de base de datos: " . $e->getMessage(), "logeado" => false]);
} catch (Exception $e) {
    echo json_encode(["error" => "Error general: " . $e->getMessage(), "logeado" => false]);
}
?>