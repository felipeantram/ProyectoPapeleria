document.addEventListener("DOMContentLoaded", () => {
    console.log("✅ Script de login cargado correctamente");

    // === REFERENCIAS ===
    const roleSelection = document.getElementById("roleSelection");
    const forms = document.querySelectorAll(".form-section");

    // Formularios de registro
    const formCliente = document.getElementById("formCliente");
    const formEmpleado = document.getElementById("formEmpleado");
    const formAdmin = document.getElementById("formAdmin");

    // Formularios de login
    const loginCliente = document.getElementById("loginCliente");
    const loginEmpleado = document.getElementById("loginEmpleado");
    const loginAdmin = document.getElementById("loginAdmin");

    // === FUNCIONES DE VISIBILIDAD ===
    function showForm(form) {
        forms.forEach(f => f.classList.remove("active"));
        form.classList.add("active");
    }

    function backToMenu() {
        forms.forEach(f => f.classList.remove("active"));
        roleSelection.classList.add("active");
    }

    // === SELECCIÓN DE REGISTRO ===
    document.getElementById("btnCliente").addEventListener("click", () => showForm(formCliente));
    document.getElementById("btnEmpleado").addEventListener("click", () => showForm(formEmpleado));
    document.getElementById("btnAdmin").addEventListener("click", () => showForm(formAdmin));

    // === BOTONES VOLVER ===
    document.getElementById("volverCliente").addEventListener("click", backToMenu);
    document.getElementById("volverEmpleado").addEventListener("click", backToMenu);
    document.getElementById("volverAdmin").addEventListener("click", backToMenu);

    // === LINK: YA TIENES CUENTA ===
    document.getElementById("loginClienteLink").addEventListener("click", (e) => {
        e.preventDefault();
        showForm(loginCliente);
    });

    document.getElementById("loginEmpleadoLink").addEventListener("click", (e) => {
        e.preventDefault();
        showForm(loginEmpleado);
    });

    document.getElementById("loginAdminLink").addEventListener("click", (e) => {
        e.preventDefault();
        showForm(loginAdmin);
    });

    // === VOLVER DESDE LOGIN ===
    document.getElementById("volverLoginCliente").addEventListener("click", () => showForm(formCliente));
    document.getElementById("volverLoginEmpleado").addEventListener("click", () => showForm(formEmpleado));
    document.getElementById("volverLoginAdmin").addEventListener("click", () => showForm(formAdmin));

    // === REGISTROS ===
    document.getElementById("clienteRegisterForm").addEventListener("submit", (e) => {
        e.preventDefault();
        alert("✅ Registro de cliente completado correctamente.");
        showForm(loginCliente);
    });

    document.getElementById("empleadoRegisterForm").addEventListener("submit", (e) => {
        e.preventDefault();
        alert("✅ Registro de empleado completado correctamente.");
        showForm(loginEmpleado);
    });

    document.getElementById("adminRegisterForm").addEventListener("submit", (e) => {
        e.preventDefault();
        alert("✅ Registro de administrador completado correctamente.");
        showForm(loginAdmin);
    });

    // === LOGIN ===
    document.getElementById("clienteLoginForm").addEventListener("submit", (e) => {
        e.preventDefault();
        alert("Bienvenido, cliente!");
        window.location.href = "src/pages/cliente.html";
    });

    document.getElementById("empleadoLoginForm").addEventListener("submit", (e) => {
        e.preventDefault();
        alert("Bienvenido, empleado!");
        window.location.href = "src/pages/empleado.html";
    });

    document.getElementById("adminLoginForm").addEventListener("submit", (e) => {
        e.preventDefault();
        alert("Bienvenido, administrador!");
        window.location.href = "src/pages/admin.html";
    });
});
