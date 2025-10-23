<?php
session_start();

// Verificación de sesión y rol desde la base de datos
if (!isset($_SESSION['usuario']) || $_SESSION['usuario']['rol'] !== 'Cliente') {
    header("Location: /login.html");
    exit;
}
?>

<!doctype html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Panel | Cliente</title>
    <link rel="stylesheet" href="../assets/css/styles.css" />
</head>

<body>

    <header class="container">
        <h1>Cliente</h1>
        <nav>
            <a href="cliente.php" aria-current="page">Inicio</a>
            <a href="empleado.php">Empleado</a>
            <a href="admin.php">Administrador</a>
            <a href="/logout.php">Cerrar sesión</a>
        </nav>
    </header>

    <main class="container">
        <section class="card">
            <h2>¡Bienvenido, <?php echo htmlspecialchars($_SESSION['usuario']['nombre']); ?>!</h2>
            <p>Aquí podrás ver tus pedidos, facturas y soporte.</p>
            <div class="grid-3">
                <a class="tile" href="#">Mis pedidos</a>
                <a class="tile" href="#">Facturación</a>
                <a class="tile" href="#">Soporte</a>
            </div>
        </section>
    </main>

</body>

</html>