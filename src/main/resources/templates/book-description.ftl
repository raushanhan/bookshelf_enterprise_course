<#include 'base.ftl'>

<#macro title>
    ${book.title}
</#macro>

<#macro head>
    <style>
        .book-cover {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }
    </style>
</#macro>

<#macro body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-4 text-center">
                <#if book.coverUrl??>
                    <img src="${book.coverUrl}" alt="Обложка книги" class="book-cover mb-3">
                <#else>
                    <div class="bg-secondary text-white d-flex align-items-center justify-content-center" style="width:100%; height:300px; border-radius:8px;">
                        <span>Обложка отсутствует</span>
                    </div>
                </#if>
                <div class="mt-3">
                    <#if likedAlready??>
                        <#if likedAlready>
                            <form action="/book/${book.id}/unlike" method="post" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button type="submit" class="btn btn-danger">💔 Убрать лайк</button>
                            </form>
                        <#else>
                            <form action="/book/${book.id}/like" method="post" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button type="submit" class="btn btn-outline-danger">❤ Понравилось</button>
                            </form>
                        </#if>
                    </#if>
                    <a href="/book/${book.id}/read" class="btn btn-primary ms-2">Читать</a>
                </div>
            </div>

            <div class="col-md-8">
                <h2>${book.title}</h2>
                <p class="text-muted">Автор:
                    <a href="/profile/${book.author.username}">
                        ${book.author.username}
                    </a>
                </p>

                <#if book.genre??>
                    <p><strong>Жанр:</strong> ${book.genre.name}</p>
                </#if>

                <p><strong>Описание:</strong></p>
                <p>${book.description}</p>

                <div class="text-muted">
                    <small>
                        <#if book.dateOfCreation??>
                            Создано: ${book.dateOfCreation?string("dd.MM.yyyy HH:mm")} <br>
                        </#if>
                        <#if book.dateOfLastUpdate??>
                            Обновлено: ${book.dateOfLastUpdate?string("dd.MM.yyyy HH:mm")}
                        </#if>
                    </small>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro scripts>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</#macro>

<@page/>