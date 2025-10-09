// Espera a que el DOM cargue antes de ejecutar
document.addEventListener("DOMContentLoaded", () => {
    // Obtiene los datos de sesión guardados
    const isLoggedIn = sessionStorage.getItem("isLoggedIn");
    const usuario = sessionStorage.getItem("usuario");

    // Si no hay sesión iniciada, redirige al login
    if (isLoggedIn !== "true" || !usuario) {
        window.location.href = "login.html";
        return;
    }

    // Si hay sesión, muestra el nombre del usuario en la pantalla
    const userSpan = document.getElementById("usuarioActivo");
    if (userSpan) {
        userSpan.textContent = usuario;
    }

    // Acción del botón de cerrar sesión
    const btnSalir = document.getElementById("btnSalir");
    if (btnSalir) {
        btnSalir.addEventListener("click", () => {
            const salir = confirm("¿Deseas cerrar sesión?");
            if (salir) {
                sessionStorage.clear();
                window.location.href = "login.html";
            }
        });
    }
});