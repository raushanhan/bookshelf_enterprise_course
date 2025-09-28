<#include 'base.ftl'>

<#macro title>
    Вход
</#macro>

<#macro body>

<#--    <form action="/login" method="post">-->
<#--        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />-->

<#--        <label for="username">Логин:</label><br>-->
<#--        <input type="text" id="username" name="username" required><br><br>-->

<#--        <label for="password">Пароль:</label><br>-->
<#--        <input type="password" id="password" name="password" required><br><br>-->

<#--        <button type="submit">Войти</button>-->
<#--    </form>-->

    <form action="/login" method="post" class="container mt-5" style="max-width: 400px;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div class="text-center mb-4">
            <h2 class="h3 mb-3 font-weight-normal">Вход в систему</h2>
        </div>

        <div class="form-floating mb-3">
            <input type="text" class="form-control" id="username" name="username" placeholder="Логин" required>
            <label for="username">Логин</label>
        </div>

        <div class="form-floating mb-3">
            <input type="password" class="form-control" id="password" name="password" placeholder="Пароль" required>
            <label for="password">Пароль</label>
        </div>

        <div class="d-grid gap-2">
            <button class="btn btn-dark btn-lg" type="submit">Войти</button>
        </div>

        <div class="mt-3 text-center hover-grey">
            <a href="#" class="text-decoration-none text-black hover-grey">Забыли пароль?</a>
        </div>
    </form>

    <p class="text-center">Нет аккаунта? <a href="/register">Зарегистрироваться</a></p>
</#macro>

<@page/>