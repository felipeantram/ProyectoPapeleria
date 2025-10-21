<?php
session_start();

// Verificación de sesión y rol
if (!isset($_SESSION['usuario']) || $_SESSION['usuario']['rol'] !== 'Administrador') {
    header("Location: /login.html");
    exit;
}
?>

<!doctype html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Panel | Administrador</title>
    <link rel="stylesheet" href="../assets/css/styles.css" />
</head>

<body>

    <header class="container">
        <h1>Administrador</h1>
        <nav>
            <a href="admin.php" aria-current="page">Inicio</a>
            <a href="empleado.php">Empleados</a>
            <a href="cliente.php">Clientes</a>
            <a href="/logout.php">Cerrar sesión</a>
        </nav>
    </header>

    <main class="container">
        <section class="card">
            <h2>¡Bienvenido, <?php echo htmlspecialchars($_SESSION['usuario']['nombre']); ?>!</h2>
            <p>Desde aquí podrás gestionar usuarios, inventario y reportes.</p>

            <div class="grid-3">
                <a class="tile" href="#">Gestión de usuarios</a>
                <a class="tile" href="#">Inventario</a>
                <a class="tile" href="#">Reportes</a>
            </div>
        </section>
    </main>

</body>

</html>