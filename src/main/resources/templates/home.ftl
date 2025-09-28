<#include 'base.ftl'>

<#macro title>
    Домашняя
</#macro>

<#macro body>

    <div class="container my-5">
        <#list genres as genre>
            <div class="mb-5">
                <h4 class="mb-3">${genre.name}</h4>
                <div class="d-flex flex-row overflow-auto gap-3">
                    <#list genre.books as book>
                        <div class="card flex-shrink-0" style="width: 200px;">
                            <#if book.coverUrl?? && book.coverUrl?length != 0>
                                <img src="${book.coverUrl}" class="card-img-top" alt="Обложка книги">
                            <#else>
                                <div class="card-img-top bg-secondary d-flex align-items-center justify-content-center text-white" style="height: 250px;">
                                    Нет обложки
                                </div>
                            </#if>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title text-truncate" title="${book.title}">${book.title}</h6>
                                <a class="card-text small text-muted" href="/profile/${book.author.username}">${book.author.username}</a>
                                <p class="card-text small text-muted">${book.description?truncate(60, "...")}</p>
                                <a href="/book/${book.id}" class="btn btn-sm btn-outline-primary mt-auto">Читать</a>
                            </div>
                        </div>
                    </#list>
                </div>
            </div>
        </#list>
    </div>

</#macro>

<@page/>