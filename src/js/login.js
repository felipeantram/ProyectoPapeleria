document.addEventListener("DOMContentLoaded", () => {
    const loginC = document.getElementById("login-container");
    const regC = document.getElementById("register-container");

    // Rutas front
    const routes = {
        administrador: "src/pages/admin.html",
        empleado: "src/pages/empleado.html",
        cliente: "src/pages/cliente.html",
    };

    // Base de la API (login.html está en la raíz del proyecto)
    const apiBase = new URL("./api/", window.location.href).href;

    // Helpers
    const norm = (s) => (s || "").toString().trim().toLowerCase();
    const byId = (id) => document.getElementById(id);

    async function postJSON(url, data) {
        const res = await fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data),
        });
        // PHP devolverá 4xx/5xx cuando haya error; parseamos siempre el json
        const json = await res.json().catch(() => ({}));
        if (!res.ok || json.error) {
            const msg = json.error || `Error HTTP ${res.status}`;
            throw new Error(msg);
        }
        return json;
    }

    // ------- NAV login/registro ----------
    byId("go-register").addEventListener("click", (e) => {
        e.preventDefault();
        loginC.classList.add("hidden");
        regC.classList.remove("hidden");
    });

    byId("go-login").addEventListener("click", (e) => {
        e.preventDefault();
        regC.classList.add("hidden");
        loginC.classList.remove("hidden");
    });

    byId("btn-back-login").addEventListener("click", () => {
        regC.classList.add("hidden");
        loginC.classList.remove("hidden");
    });

    // ------------- LOGIN (contra PHP/MariaDB) -------------
    byId("login-form").addEventListener("submit", async (e) => {
        e.preventDefault();

        const roleSel = byId("login-role").value; // "Administrador" | "Empleado" | "Cliente"
        const email = byId("login-email").value;
        const password = byId("login-password").value;

        if (!roleSel) return alert("Selecciona un tipo de usuario.");
        if (!(email && password)) return alert("Por favor llena todos los campos.");

        const sel = norm(roleSel);

        // Por ahora solo BD para cliente/empleado
        if (sel === "administrador") {
            alert("El rol Administrador aún no está conectado a BD. Agrega su tabla/endpoint para habilitarlo.");
            return;
        }

        // Deshabilitar botón para evitar doble submit
        const btn = e.submitter || byId("login-submit");
        btn && (btn.disabled = true);

        try {
            const payload = { rol: roleSel, correo: email, password };
            const data = await postJSON(`${apiBase}login.php`, payload);

            // Guarda sesión mínima y redirige a SU panel
            localStorage.setItem("role", roleSel);
            localStorage.setItem("userEmail", email);

            const target = routes[sel];
            if (!target) throw new Error("Ruta de panel no configurada para el rol.");
            window.location.assign(new URL(target, window.location.href));
        } catch (err) {
            alert(err.message || "Error al iniciar sesión.");
        } finally {
            btn && (btn.disabled = false);
        }
    });

    // ------------- REGISTRO dinámico por rol -------------
    const roleSelect = byId("register-role");
    const roleFields = Array.from(document.querySelectorAll(".role-field"));
    const submitBtn = byId("register-submit");

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

    // ------------- REGISTRO (contra PHP/MariaDB) -------------
    byId("register-form").addEventListener("submit", async (e) => {
        e.preventDefault();

        const role = byId("register-role").value; // "Administrador" | "Empleado" | "Cliente"
        if (!role) return alert("Selecciona un rol.");

        if (norm(role) === "administrador") {
            alert("El registro de Administrador no está conectado a BD aún.");
            return;
        }

        const name = byId("register-name").value;
        const email = byId("register-email").value;
        const pass = byId("register-password").value;

        // Construimos payload; PHP ignora campos que no apliquen
        const payload = {
            rol: role,
            nombre: name,
            correo: email,
            password: pass,
            direccion: byId("register-address")?.value || "",
            telefono: byId("register-phone")?.value || "",
            puesto: byId("register-id")?.value || "" // ajusta si usas otro input para puesto
        };

        submitBtn.disabled = true;

        try {
            const data = await postJSON(`${apiBase}register.php`, payload);
            alert(`Cuenta creada (${data.rol}) para ${name}`);

            // Volver al login
            regC.classList.add("hidden");
            loginC.classList.remove("hidden");
            e.target.reset();
            updateRegisterFields();
        } catch (err) {
            alert(err.message || "Error al registrar.");
        } finally {
            submitBtn.disabled = false;
        }
    });
});
