document.addEventListener("DOMContentLoaded", () => {
    const loginC = document.getElementById("login-container");
    const regC = document.getElementById("register-container");

    // Rutas de redirección a los archivos PHP
    const routes = {
        administrador: "src/pages/admin.php",
        empleado: "src/pages/empleado.php",
        cliente: "src/pages/cliente.php",
    };

    const norm = (s) => (s || "").toString().trim().toLowerCase();

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

    // -------------------------------------------------------------
    // ------------- LOGIN (USANDO FETCH PARA PHP/BD) --------------
    // -------------------------------------------------------------
    const loginForm = document.getElementById("login-form");

    loginForm.addEventListener("submit", async (e) => {
        e.preventDefault();

        // 1. Validar el formulario con HTML5/Bootstrap
        if (!loginForm.checkValidity()) {
            loginForm.classList.add('was-validated');
            return;
        }
        // Opcional: remover la clase si la validación pasa antes del fetch
        loginForm.classList.remove('was-validated');

        const roleSel = document.getElementById("login-role").value;
        const email = document.getElementById("login-email").value;
        const password = document.getElementById("login-password").value;

        if (!roleSel) return alert("Selecciona un tipo de usuario.");

        try {
            // 2. Petición al script PHP de login (¡RUTA ABSOLUTA CORREGIDA!)
            const response = await fetch('/ProyectoPapeleria/login.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    correo: email,
                    contraseña: password,
                }),
            });

            // Maneja errores de conexión o servidor (404, 500)
            if (!response.ok) {
                throw new Error("Error del servidor: " + response.status);
            }

            const data = await response.json();

            // 3. Manejo de la Respuesta del Servidor (Errores de BD o Lógica)
            if (data.error || data.errorDB) {
                alert("Error de autenticación: " + (data.error || data.errorDB));
                return;
            }

            // 4. Validación de Rol
            const userRole = data.rol;
            const selectedRole = norm(roleSel);
            const registeredRole = norm(userRole);

            if (selectedRole !== registeredRole) {
                alert(`Este correo está registrado como "${userRole}". Selecciona ese rol para ingresar.`);
                return;
            }

            // 5. Éxito: Redirige (la sesión ya fue creada en login.php)
            const target = routes[registeredRole];
            if (!target) return alert("Ruta de panel no configurada para el rol.");

            window.location.assign(new URL(target, window.location.href));

        } catch (error) {
            console.error("Error en la comunicación con el servidor:", error);
            alert("No se pudo conectar con el servidor de autenticación. Verifica que Apache/PHP estén corriendo y las rutas.");
        }
    });

    // -------------------------------------------------------------
    // ------------- REGISTRO (USANDO FETCH PARA PHP/BD) -------------
    // -------------------------------------------------------------
    const registerForm = document.getElementById("register-form");
    const roleSelect = document.getElementById("register-role");
    const roleFields = Array.from(document.querySelectorAll(".role-field"));
    const submitBtn = document.getElementById("register-submit");

    function updateRegisterFields() {
        // Lógica para mostrar/ocultar campos según el rol
        const role = roleSelect.value;
        roleFields.forEach((wrap) => {
            const allowed = (wrap.dataset.roles || "")
                .split(",")
                .map((s) => s.trim());
            const visible = role && allowed.includes(role);
            wrap.style.display = visible ? "" : "none";

            wrap.querySelectorAll("input,select,textarea").forEach((inp) => {
                // Configuración de 'required' basada en el rol
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

    registerForm.addEventListener("submit", async (e) => {
        e.preventDefault();

        // 1. Validar el formulario con HTML5/Bootstrap
        if (!registerForm.checkValidity()) {
            registerForm.classList.add('was-validated');
            return;
        }
        registerForm.classList.remove('was-validated');

        const role = document.getElementById("register-role").value;
        if (!role) return alert("Selecciona un rol.");

        const name = document.getElementById("register-name").value;
        const email = document.getElementById("register-email").value;
        const pass = document.getElementById("register-password").value;

        // Datos opcionales por rol
        const payload = {
            rol: role,
            nombre: name,
            correo: email,
            password: pass,
            direccion: document.getElementById("register-address").value || null,
            id_empleado: document.getElementById("register-id").value || null,
            codigo_admin: document.getElementById("register-code").value || null,
            celular: document.getElementById("register-phone").value || null,
        };

        try {
            // 2. Petición al script PHP de registro (¡RUTA ABSOLUTA CORREGIDA!)
            const response = await fetch('/ProyectoPapeleria/registro.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(payload),
            });

            if (!response.ok) {
                throw new Error("Error del servidor: " + response.status);
            }

            const data = await response.json();

            // 3. Manejo de la Respuesta del Servidor
            if (data.error || data.errorDB) {
                alert("Error de registro: " + (data.error || data.errorDB));
                return;
            }

            alert(`Cuenta creada exitosamente (${role}) para ${name}`);

            // Volver al login
            regC.classList.add("hidden");
            loginC.classList.remove("hidden");
            registerForm.reset();
            updateRegisterFields();

        } catch (error) {
            console.error("Error en la comunicación con el servidor:", error);
            alert("No se pudo conectar con el servidor de registro. Verifica que Apache/PHP estén corriendo y las rutas.");
        }
    });
});