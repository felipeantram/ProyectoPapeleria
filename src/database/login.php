<?php
// FICHERO: login.php (¡NUEVO ARCHIVO!)
session_start(); // 🚨 CRÍTICO: Inicia la sesión de PHP

header('Content-Type: application/json');
require_once 'connection.php'; // Usa tu archivo de conexión

try {
    $conn = ConexionDB::setConnection();

    // 1. Obtener datos del JSON
    $entrada = json_decode(file_get_contents('php://input'), true);
    $correo = $entrada['correo'] ?? null;
    $contraseña = $entrada['contraseña'] ?? null;

    if (!$correo || !$contraseña) {
        echo json_encode(["error" => "Faltan correo o contraseña."]);
        exit;
    }

    // 2. Consulta segura a la tabla 'usuario'
    $sql = "SELECT idUsuario, nombreCompleto, contraseña, tipoUsuario FROM usuario WHERE correo = ?";

    $statement = $conn->prepare($sql);
    $statement->execute([$correo]);
    $usuario = $statement->fetch(PDO::FETCH_ASSOC);

    if (!$usuario) {
        echo json_encode(["error" => "Correo no encontrado."]);
        exit;
    }

    // 3. Verificación de Contraseña (Insegura, basada en tus datos SQL)
    // 💡 Recomendación: Usa password_verify() si usas contraseñas hasheadas.
    if ($contraseña !== $usuario['contraseña']) {
        echo json_encode(["error" => "Contraseña incorrecta."]);
        exit;
    }

    // 4. Éxito: CREAR LA SESIÓN DE PHP
    $_SESSION['usuario'] = [
        'id' => $usuario['idUsuario'],
        'nombre' => $usuario['nombreCompleto'],
        'correo' => $correo,
        'rol' => $usuario['tipoUsuario']
    ];

    // 5. Devolver el rol a JS para la redirección
    echo json_encode([
        'estado' => true,
        'mensaje' => 'Login exitoso',
        'rol' => $usuario['tipoUsuario']
    ]);

} catch (PDOException $e) {
    echo json_encode(["errorDB" => "Error de consulta: " . $e->getMessage()]);
} catch (Exception $e) {
    echo json_encode(["error" => "Error interno del servidor."]);
}
?>