<?php
require_once "../database/connection.php";
header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Origin: *");

$data = json_decode(file_get_contents("php://input"), true);

$rol = strtolower($data["rol"] ?? "");
$correo = $data["correo"] ?? "";
$password = $data["password"] ?? "";

if (!$rol || !$correo || !$password) {
    echo json_encode(["error" => "Faltan campos obligatorios"]);
    exit;
}

$table = $rol === "cliente" ? "cliente" : "empleado";

$stmt = $conn->prepare("SELECT id, nombre, correo, password FROM $table WHERE correo=? LIMIT 1");
$stmt->bind_param("s", $correo);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if (!$user || !password_verify($password, $user["password"])) {
    echo json_encode(["error" => "Credenciales incorrectas"]);
    exit;
}

echo json_encode([
    "message" => "Login exitoso",
    "rol" => $rol,
    "usuario" => ["id" => $user["id"], "nombre" => $user["nombre"], "correo" => $user["correo"]]
]);
