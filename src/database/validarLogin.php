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

    // --- MODIFICACIÓN CLAVE (Corrección Funcional) ---
    // Se normaliza el rol para asegurar que la primera letra es mayúscula.
    // Esto garantiza que coincide con los valores del ENUM en la BD ('Administrador', 'Empleado', 'Cliente').
    $rol = ucfirst(strtolower(trim($rol)));
    // --------------------------------------------------

    // Consulta al usuario
    $stmt = $conn->prepare("SELECT * FROM usuario WHERE correo = ? AND tipoUsuario = ? AND activo = 1 LIMIT 1");
    $stmt->execute([$correo, $rol]);
    $usuario = $stmt->fetch();

    if (!$usuario) {
        // El error funcional de "Usuario no encontrado" se corrige con la normalización de $rol.
        echo json_encode(['error' => 'Usuario no encontrado o rol incorrecto.']);
        exit;
    }

    // ---------------- ADVERTENCIA DE SEGURIDAD CRÍTICA -----------------
    // Su sistema de contraseñas es vulnerable. Se recomienda encarecidamente
    // utilizar password_hash() al registrar usuarios y password_verify()
    // para validar la contraseña.
    if ($usuario['contraseña'] !== $password) {
        // La línea segura DEBERÍA ser:
        // if (!password_verify($password, $usuario['contraseña'])) {
        echo json_encode(['error' => 'Contraseña incorrecta.']);
        exit;
    }
    // -------------------------------------------------------------------

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
?>