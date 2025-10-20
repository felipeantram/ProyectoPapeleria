document.addEventListener("DOMContentLoaded", () => {
    const loginC = document.getElementById("login-container");
    const regC = document.getElementById("register-container");

    // Helpers de almacenamiento
    const STORAGE_USERS = "users";   // lista de usuarios
    const STORAGE_ROLE = "role";    // rol de sesión actual
    const STORAGE_EMAIL = "userEmail";

    const routes = {
        administrador: "src/pages/admin.html",
        empleado: "src/pages/empleado.html",
        cliente: "src/pages/cliente.html",
    };

    const norm = (s) => (s || "").toString().trim().toLowerCase();

    const getUsers = () => {
        try { return JSON.parse(localStorage.getItem(STORAGE_USERS)) || []; }
        catch { return []; }
    };
    const saveUsers = (arr) => localStorage.setItem(STORAGE_USERS, JSON.stringify(arr));

    const findUserByEmail = (email) => {
        const users = getUsers();
        return users.find(u => norm(u.correo) === norm(email));
    };

    // ------- NAV login/registro ----------
    document.getElementById("go-register").addEventListener("click", (e) => {
        e.preventDefault();
        loginC.classList.add("hidden");
        regC.classList.remove("hidden");
    });

    document.getElementById("go-login").addEventListener("click", (e) => {
        e.preventDefault();
        regC.classList.add("hidden");
        loginC.classList.remove("hidden");
    });

    document.getElementById("btn-back-login").addEventListener("click", () => {
        regC.classList.add("hidden");
        loginC.classList.remove("hidden");
    });

    // ------------- LOGIN (con validación de rol) -------------
    document.getElementById("login-form").addEventListener("submit", (e) => {
        e.preventDefault();

        const roleSel = document.getElementById("login-role").value; // "Administrador" | "Empleado" | "Cliente"
        const email = document.getElementById("login-email").value;
        const password = document.getElementById("login-password").value;

        if (!roleSel) return alert("Selecciona un tipo de usuario.");
        if (!(email && password)) return alert("Por favor llena todos los campos.");

        const user = findUserByEmail(email);
        if (!user) {
            alert("No existe una cuenta con ese correo.");
            return;
        }

        // Validación de contraseña
        if (user.password !== password) {
            alert("Contraseña incorrecta.");
            return;
        }

        // Validación de rol: el seleccionado debe coincidir con el rol registrado
        const selectedRole = norm(roleSel);                // "administrador" | "empleado" | "cliente"
        const registeredRole = norm(user.rol);             // guardado al registrar

        if (selectedRole !== registeredRole) {
            alert(`Este correo está registrado como "${user.rol}". Selecciona ese rol para ingresar.`);
            // Si prefieres forzar la entrada al rol correcto automáticamente, descomenta:
            // localStorage.setItem(STORAGE_ROLE, user.rol);
            // localStorage.setItem(STORAGE_EMAIL, user.correo);
            // window.location.assign(new URL(routes[registeredRole], window.location.href));
            return;
        }

        // Éxito: guarda sesión y manda a SU panel
        localStorage.setItem(STORAGE_ROLE, user.rol);      // guarda el texto tal cual "Cliente/Empleado/Administrador" si así lo registraste
        localStorage.setItem(STORAGE_EMAIL, user.correo);

        const target = routes[selectedRole];
        if (!target) return alert("Ruta de panel no configurada para el rol.");

        window.location.assign(new URL(target, window.location.href));
    });

    // ------------- REGISTRO (persistiendo usuario) -------------
    const roleSelect = document.getElementById("register-role");
    const roleFields = Array.from(document.querySelectorAll(".role-field"));
    const submitBtn = document.getElementById("register-submit");

    function updateRegisterFields() {
        const role = roleSelect.value; // "", Administrador, Empleado, Cliente
        roleFields.forEach((wrap) => {
            const allowed = (wrap.dataset.roles || "")
                .split(",")
                .map((s) => s.trim());
            const visible = role && allowed.includes(role);
            wrap.style.display = visible ? "" : "none";

            wrap.querySelectorAll("input,select,textarea").forEach((inp) => {
                if (visible) {
                    const id = inp.id;
                    const mustRequire =
                        (role === "Administrador" &&
                            (id === "register-address" ||
                                id === "register-id" ||
                                id === "register-code")) ||
                        (role === "Empleado" &&
                            (id === "register-address" || id === "register-id")) ||
                        (role === "Cliente" && id === "register-phone");
                    inp.required = mustRequire;
                } else {
                    inp.required = false;
                    inp.value = "";
                }
            });
        });
        submitBtn.disabled = !role;
    }

    updateRegisterFields();
    roleSelect.addEventListener("change", updateRegisterFields);

    document.getElementById("register-form").addEventListener("submit", (e) => {
        e.preventDefault();

        const role = document.getElementById("register-role").value; // "Administrador" | "Empleado" | "Cliente"
        if (!role) return alert("Selecciona un rol.");

        const name = document.getElementById("register-name").value;
        const email = document.getElementById("register-email").value;
        const pass = document.getElementById("register-password").value;

        // Datos opcionales por rol
        const payload = {
            rol: role, // guardamos tal cual (luego normalizamos al comparar)
            nombre: name,
            correo: email,
            password: pass,
            direccion: document.getElementById("register-address").value || null,
            id_empleado: document.getElementById("register-id").value || null,
            codigo_admin: document.getElementById("register-code").value || null,
            celular: document.getElementById("register-phone").value || null,
        };

        // Validar que no exista ya un usuario con ese correo
        const existing = findUserByEmail(email);
        if (existing) {
            return alert(`Ese correo ya está registrado como "${existing.rol}". Usa otro correo o inicia sesión como ${existing.rol}.`);
        }

        // Guardar usuario en localStorage
        const users = getUsers();
        users.push(payload);
        saveUsers(users);

        alert(`Cuenta creada (${role}) para ${name}`);

        // Volver al login
        regC.classList.add("hidden");
        loginC.classList.remove("hidden");
        e.target.reset();
        updateRegisterFields();
    });
});
