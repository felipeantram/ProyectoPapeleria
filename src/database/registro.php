<?php
// FICHERO: registro.php - Maneja la inserción de nuevos usuarios a la BD

header('Content-Type: application/json');
require_once 'connection.php'; // Incluye tu clase de conexión a la BD

// Función para manejar las respuestas JSON de error
function responderError($mensaje, $clave = "error")
{
    echo json_encode([$clave => $mensaje]);
    exit;
}

try {
    // 1. Conexión a la BD
    $conn = ConexionDB::setConnection();

    // 2. Obtener datos del JSON enviado por JavaScript
    $entrada = json_decode(file_get_contents('php://input'), true);

    // Mapeo básico de campos desde JS payload
    $rol = $entrada['rol'] ?? null; // tipoUsuario
    $nombre = $entrada['nombre'] ?? null;
    $correo = $entrada['correo'] ?? null;
    $contraseña = $entrada['password'] ?? null; // La contraseña viene sin hashear (igual que en login.php)
    $direccion_usuario = $entrada['direccion'] ?? null; // La dirección simple (usuario.direccion)

    // Campos específicos de rol
    $codigo_admin = $entrada['codigo_admin'] ?? null;
    $celular_cliente = $entrada['celular'] ?? null; // Mapea a cliente.telefono

    // Validaciones básicas
    if (!$rol || !$nombre || !$correo || !$contraseña) {
        responderError("Faltan campos obligatorios para el registro.");
    }

    // 3. Iniciar Transacción (para asegurar que ambas inserciones se completen o ninguna)
    $conn->beginTransaction();

    // 4. Verificar si el correo ya existe
    $sql_check = "SELECT idUsuario FROM usuario WHERE correo = ?";
    $statement_check = $conn->prepare($sql_check);
    $statement_check->execute([$correo]);

    if ($statement_check->fetch()) {
        $conn->rollBack(); // Deshacer si ya existe
        responderError("El correo '$correo' ya está registrado.", "error");
    }

    // 5. Insertar en la tabla 'usuario'
    // La columna 'direccion' en 'usuario' se usará para la dirección simple enviada por el formulario
    $sql_insert_usuario = "INSERT INTO usuario (nombreCompleto, correo, contraseña, direccion, tipoUsuario) VALUES (?, ?, ?, ?, ?)";
    $valores_usuario = [$nombre, $correo, $contraseña, $direccion_usuario, $rol];

    $statement_insert_usuario = $conn->prepare($sql_insert_usuario);
    $statement_insert_usuario->execute($valores_usuario);

    $idUsuario = $conn->lastInsertId();

    // 6. Insertar en la tabla de rol específica
    switch (strtolower($rol)) {
        case 'administrador':
            if (!$codigo_admin) {
                $conn->rollBack();
                responderError("Falta el código de administrador.");
            }
            // Insertar en la tabla administrador
            $sql_rol = "INSERT INTO administrador (idUsuario, codigoAdmin) VALUES (?, ?)";
            $statement_rol = $conn->prepare($sql_rol);
            $statement_rol->execute([$idUsuario, $codigo_admin]);
            break;

        case 'empleado':
            // Insertar en la tabla empleado
            // idDomicilio, idCargo y sueldo son NULLables y no son provistos por el formulario JS, se omiten
            $sql_rol = "INSERT INTO empleado (idUsuario) VALUES (?)";
            $statement_rol = $conn->prepare($sql_rol);
            $statement_rol->execute([$idUsuario]);
            break;

        case 'cliente':
            // Insertar en la tabla cliente, mapeando 'celular' (JS) a 'telefono' (SQL)
            // idDomicilio es NULLable y se omite
            $sql_rol = "INSERT INTO cliente (idUsuario, telefono) VALUES (?, ?)";
            $statement_rol = $conn->prepare($sql_rol);
            $statement_rol->execute([$idUsuario, $celular_cliente]);
            break;

        default:
            $conn->rollBack();
            responderError("Rol de usuario no válido.");
    }

    // 7. Si todo fue exitoso, confirmar la transacción
    $conn->commit();

    // 8. Éxito
    echo json_encode([
        'estado' => true,
        'mensaje' => 'Registro exitoso',
        'idUsuario' => $idUsuario
    ]);

} catch (PDOException $e) {
    // Si hay un error de BD, deshacer la transacción
    if (isset($conn) && $conn->inTransaction()) {
        $conn->rollBack();
    }
    responderError("Error de registro en la base de datos: " . $e->getMessage(), "errorDB");
} catch (Exception $e) {
    responderError("Error interno del servidor: " . $e->getMessage());
}
?>