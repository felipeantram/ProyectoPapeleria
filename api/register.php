<?php
require_once "../database/connection.php";
header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Origin: *");

$data = json_decode(file_get_contents("php://input"), true);

$rol = strtolower($data["rol"] ?? "");
$nombre = $data["nombre"] ?? "";
$correo = $data["correo"] ?? "";
$password = $data["password"] ?? "";
$telefono = $data["telefono"] ?? "";
$direccion = $data["direccion"] ?? "";
$puesto = $data["puesto"] ?? "";

if (!$rol || !$nombre || !$correo || !$password) {
    echo json_encode(["error" => "Faltan campos obligatorios"]);
    exit;
}

$hash = password_hash($password, PASSWORD_BCRYPT);

if ($rol === "cliente") {
    $stmt = $conn->prepare("INSERT INTO cliente (nombre, correo, password, telefono, direccion) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $nombre, $correo, $hash, $telefono, $direccion);
} elseif ($rol === "empleado") {
    $stmt = $conn->prepare("INSERT INTO empleado (nombre, correo, password, puesto) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $nombre, $correo, $hash, $puesto);
} else {
    echo json_encode(["error" => "Rol no válido"]);
    exit;
}

if ($stmt->execute()) {
    echo json_encode(["message" => "Registro exitoso", "rol" => $rol]);
} else {
    echo json_encode(["error" => "Error al registrar: " . $stmt->error]);
}
