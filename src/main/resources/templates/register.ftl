<#include 'base.ftl'>

<#macro title>
    Регистрация
</#macro>

<#macro body>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <h2 class="mb-4 text-center">Регистрация</h2>

                <form action="/register" method="post" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <!-- Никнейм -->
                    <div class="mb-3">
                        <label for="username" class="form-label">Никнейм <span class="text-danger">*</span></label>
                        <input type="text" class="form-control <#if fieldErrors["username"]?? || usernameAlreadyExistsError??>is-invalid</#if>" id="username" name="username" value="${form.username()!}">
                        <#if fieldErrors["username"]??>
                            <div class="invalid-feedback">${fieldErrors["username"]}</div>
                        </#if>
                        <#if usernameAlreadyExistsError??>
                            <div class="invalid-feedback d-block">Данное имя пользователя уже занято</div>
                        </#if>
                    </div>

                    <!-- Имя -->
                    <div class="mb-3">
                        <label for="name" class="form-label">Имя</label>
                        <input type="text" class="form-control" id="name" name="name" value="${form.name()!}">
                    </div>

                    <!-- Фамилия -->
                    <div class="mb-3">
                        <label for="surname" class="form-label">Фамилия</label>
                        <input type="text" class="form-control <#if fieldErrors["surname"]??>is-invalid</#if>" id="surname" name="surname" value="${form.surname()!}">
                        <#if fieldErrors["surname"]??>
                            <div class="invalid-feedback">${fieldErrors["surname"]}</div>
                        </#if>
                    </div>

                    <!-- Отчество -->
                    <div class="mb-3">
                        <label for="patronymic" class="form-label">Отчество</label>
                        <input type="text" class="form-control <#if fieldErrors["patronymic"]??>is-invalid</#if>" id="patronymic" name="patronymic" value="${form.patronymic()!}">
                        <#if fieldErrors["patronymic"]??>
                            <div class="invalid-feedback">${fieldErrors["patronymic"]}</div>
                        </#if>
                    </div>

                    <!-- Email -->
                    <div class="mb-3">
                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control <#if fieldErrors["email"]?? || emailAlreadyExistsError??>is-invalid</#if>" id="email" name="email" value="${form.email()!}" required>
                        <#if fieldErrors["email"]??>
                            <div class="invalid-feedback">${fieldErrors["email"]}</div>
                        </#if>
                        <#if emailAlreadyExistsError??>
                            <div class="invalid-feedback d-block">Аккаунт с данным адресом электронной почты уже создан</div>
                        </#if>
                    </div>

                    <!-- Пароль -->
                    <div class="mb-3">
                        <label for="password" class="form-label">Пароль <span class="text-danger">*</span></label>
                        <input type="password" class="form-control <#if fieldErrors["password"]??>is-invalid</#if>" id="password" name="password" value="${form.password()!}" required>
                        <#if fieldErrors["password"]??>
                            <div class="invalid-feedback">${fieldErrors["password"]}</div>
                        </#if>
                    </div>

                    <!-- Повтор пароля -->
                    <div class="mb-4">
                        <label for="password_repeat" class="form-label">Повторите пароль <span class="text-danger">*</span></label>
                        <input type="password" class="form-control <#if fieldErrors["password_repeat"]??>is-invalid</#if>" id="password_repeat" name="password_repeat" value="${form.password_repeat()!}" required>
                        <#if fieldErrors["password_repeat"]??>
                            <div class="invalid-feedback">${fieldErrors["password_repeat"]}</div>
                        </#if>
                    </div>

                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-dark">Зарегистрироваться</button>
                    </div>

                    <p class="text-center">Уже есть аккаунт? <a href="/login" class="text-secondary">Войти</a></p>

                </form>
            </div>
        </div>
    </div>
</#macro>

<@page/>