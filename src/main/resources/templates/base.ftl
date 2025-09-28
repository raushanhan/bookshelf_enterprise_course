<#macro title>

</#macro>
<#macro head>

</#macro>
<#macro body>

</#macro>
<#macro scripts>

</#macro>
<#macro page>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><@title/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/css/styles.css">
        <@head/>
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">bookshelf</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <form class="d-flex flex-grow-1 mx-4" role="search">
                    <input class="form-control flex-grow-1" type="search" placeholder="Поиск..." aria-label="Поиск">
                    <button class="btn btn-outline-light ms-2" type="submit">Найти</button>
                </form>

                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/home">Главная</a>
                    </li>
                    <#if user??>
                        <#if isAdmin??>
                            <li class="nav-item">
                                <a class="nav-link" href="/admin">Администрирование</a>
                            </li>
                        </#if>
                        <#if isModerator??>
                            <li class="nav-item">
                                <a class="nav-link" href="/moderate">Модерирование</a>
                            </li>
                        </#if>
                        <li class="nav-item">
                            <a class="nav-link" href="/profile/${user.username}">Профиль</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/bookshelf">Список чтения</a>
                        </li>
                    </#if>
                </ul>

                <#if user??>
                    <form action="/logout" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <button type="submit" class="btn btn-outline-light">Выход</button>
                    </form>
                <#else>
                    <a class="btn btn-outline-light" type="button" href="/login">Вход</a>
                </#if>
            </div>
        </div>
    </nav>
    <@body/>
    <@scripts/>
    </body>
    </html>
</#macro>
