document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("loginForm");
    const registerForm = document.getElementById("registerForm");

    const btnGoRegister = document.getElementById("btnGoRegister");
    const btnGoLogin = document.getElementById("btnGoLogin");

    const formLogin = document.getElementById("formLogin");
    const formRegister = document.getElementById("formRegister");

    // Cambiar entre login y registro
    btnGoRegister.addEventListener("click", () => {
        loginForm.classList.add("hidden");
        registerForm.classList.remove("hidden");
    });

    btnGoLogin.addEventListener("click", () => {
        registerForm.classList.add("hidden");
        loginForm.classList.remove("hidden");
    });

    // Registro: guarda el usuario en localStorage
    formRegister.addEventListener("submit", (event) => {
        event.preventDefault();

        const email = document.getElementById("regEmail").value;
        const password = document.getElementById("regPassword").value;
        const password2 = document.getElementById("regPassword2").value;

        if (password !== password2) {
            alert("Las contraseñas no coinciden.");
            return;
        }

        // Guardar usuario en localStorage
        localStorage.setItem("userEmail", email);
        localStorage.setItem("userPassword", password);

        alert("Usuario registrado correctamente. Ahora inicia sesión.");

        // Regresar al login
        registerForm.classList.add("hidden");
        loginForm.classList.remove("hidden");
    });

    // Login: verifica credenciales
    formLogin.addEventListener("submit", (event) => {
        event.preventDefault();

        const email = document.getElementById("txtEmail").value;
        const password = document.getElementById("idPassword").value;
        const terms = document.getElementById("termsCheck").checked;

        if (!terms) {
            alert("Debes aceptar los términos.");
            return;
        }

        const savedEmail = localStorage.getItem("userEmail");
        const savedPassword = localStorage.getItem("userPassword");

        if (email === savedEmail && password === savedPassword) {
            sessionStorage.setItem("isLoggedIn", "true");
            window.location.href = "index.html";
        } else {
            alert("Correo o contraseña incorrectos.");
        }
    });
});
