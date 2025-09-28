<#include "../base.ftl">
    <#macro title>
        404 - Не найдено
    </#macro>

    <#macro body>
        <div class="container my-5 text-center">
            <h1 class="display-1 text-danger">404</h1>
            <h2>Страница не найдена</h2>
            <p class="lead">${message!''}</p>
            <a href="/home" class="btn btn-primary mt-4">Вернуться на главную</a>
        </div>
    </#macro>

<@page/>