<#include "../base.ftl">

<#macro title>
        Ошибка
</#macro>

<#macro body>
        <div class="container mt-5">
            <div class="alert alert-danger shadow rounded-3">
                <h1 class="display-5">Упс! Что-то пошло не так.</h1>
                <p class="lead">Произошла ошибка при обработке запроса.</p>

                <#if message??>
                    <div class="mt-3">
                        <strong>Сообщение:</strong>
                        <pre class="bg-light p-3 border rounded">${message}</pre>
                    </div>
                </#if>

                <a href="/home" class="btn btn-primary mt-4">Вернуться на главную</a>
            </div>
        </div>
</#macro>

<@page/>
