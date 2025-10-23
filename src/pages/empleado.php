<?php
session_start();

// Verificación de sesión y rol desde la base de datos
if (!isset($_SESSION['usuario']) || $_SESSION['usuario']['rol'] !== 'Empleado') {
    header("Location: /login.html");
    exit;
}
?>

<!doctype html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Panel | Empleado</title>
    <link rel="stylesheet" href="../assets/css/styles.css" />
</head>

<body>

    <header class="container">
        <h1>Empleado</h1>
        <nav>
            <a href="empleado.php" aria-current="page">Inicio</a>
            <a href="cliente.php">Clientes</a>
            <a href="admin.php">Administrador</a>
            <a href="/logout.php">Cerrar sesión</a>
        </nav>
    </header>

    <main class="container">
        <section class="card">
            <h2>¡Hola, <?php echo htmlspecialchars($_SESSION['usuario']['nombre']); ?>!</h2>
            <p>Accesos rápidos del empleado.</p>

            <div class="grid-3">
                <a class="tile" href="#">Vender</a>
                <a class="tile" href="#">Consultar inventario</a>
                <a class="tile" href="#">Historial de ventas</a>
            </div>
        </section>
    </main>

</body>

</html>