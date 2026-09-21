<#include 'base.ftl'>

<#macro title>
    ${book.title}
</#macro>

<#macro body>

    <div class="container my-5">
        <div class="row">
            <div class="col-md-8">
                <h1>${book.title}</h1>
                <p class="text-muted mb-1">
                    Автор: <a href="/profile/${book.author.username}">${book.author.username}</a>
                </p>
                <#if book.lastUpdateDate??>
                    <p class="text-muted">
                        Последнее обновление: ${lastUpdateDate?string("dd.MM.yyyy HH:mm")}
                    </p>
                </#if>
            </div>
        </div>

        <hr class="my-5">

        <div class="book-text fs-5" style="white-space: pre-wrap;">
            ${book.text}
        </div>
    </div>

</#macro>

<@page/>