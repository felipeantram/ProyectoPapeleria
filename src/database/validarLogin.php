<?php
session_start();
header('Content-Type: application/json');

require_once 'connection.php';

try {
    $conn = ConexionDB::setConnection();

    $entrada = json_decode(file_get_contents("php://input"), true);

    $correo = $entrada['correo'] ?? '';
    $password = $entrada['contraseña'] ?? '';
    $rol = $entrada['rol'] ?? '';

    if (empty($correo) || empty($password) || empty($rol)) {
        echo json_encode(['error' => 'Todos los campos son obligatorios.']);
        exit;
    }

    // Consulta al usuario
    $stmt = $conn->prepare("SELECT * FROM usuario WHERE correo = ? AND tipoUsuario = ? AND activo = 1 LIMIT 1");
    $stmt->execute([$correo, $rol]);
    $usuario = $stmt->fetch();

    if (!$usuario) {
        echo json_encode(['error' => 'Usuario no encontrado o rol incorrecto.']);
        exit;
    }

    // Validación de contraseña (sin hash)
    if ($usuario['contraseña'] !== $password) {
        echo json_encode(['error' => 'Contraseña incorrecta.']);
        exit;
    }

    // Guardar sesión
    $_SESSION['usuario'] = [
        'id' => $usuario['idUsuario'],
        'nombre' => $usuario['nombreCompleto'],
        'rol' => $usuario['tipoUsuario']
    ];

    echo json_encode(['success' => true, 'rol' => $usuario['tipoUsuario']]);
} catch (Exception $e) {
    echo json_encode(['error' => 'Error de servidor: ' . $e->getMessage()]);
}
