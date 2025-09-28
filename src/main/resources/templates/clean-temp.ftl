<#include 'base.ftl'>

<#macro head>

</#macro>

<#macro title>
    clean temp
</#macro>

<#macro body>
    <#if user??>
        Добро пожаловать, ${user.name}
    </#if>

</#macro>

<#macro scripts>

</#macro>

<@page/>