<#include 'base.ftl'>

<#macro head>

</#macro>

<#macro title>
    <style>
        .book-card {
            max-width: 200px;
        }
        .book-cover {
            height: 250px;
            object-fit: cover;
        }
    </style>
</#macro>

<#macro body>
    <div class="container mt-4">
        <h2 class="mb-4">Моя книжная полка</h2>
        <div class="row g-4">
            <#if likedBooks?size == 0>
                <div class="col-12">
                    <p>Вы пока не добавили ни одной книги в избранное.</p>
                </div>
            <#else>
                <#list likedBooks as book>
                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="card book-card h-100 shadow-sm">
                            <#if book.coverUrl??>
                                <img src="${book.coverUrl}" class="card-img-top book-cover" alt="Обложка книги">
                            <#else>
                                <div class="card-img-top book-cover bg-secondary d-flex align-items-center justify-content-center text-white">
                                    Без обложки
                                </div>
                            </#if>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${book.title}</h5>
                                <a class="card-text text-muted" href="/profile/${book.author.username}">${book.author.username}</a>
                                <form action="/book/${book.id}/unlike" method="post" class="mt-auto">
                                    <input type="hidden" name="bookId" value="${book.id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm w-100">Убрать лайк</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </#list>
            </#if>
        </div>
    </div>

</#macro>

<#macro scripts>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</#macro>

<@page/>