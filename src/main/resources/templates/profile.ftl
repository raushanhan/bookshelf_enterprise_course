<#include 'base.ftl'>

<#macro title>
    Профиль
</#macro>

<#macro body>
    <div class="container my-5">
        <#if profileOwner??>
            <h2>Профиль пользователя</h2>

            <div class="card mt-4">
                <div class="card-body">
                    <p><strong>Логин:</strong> ${profileOwner.username}</p>
                    <p><strong>Имя:</strong> ${profileOwner.name!""}</p>
                    <p><strong>Фамилия:</strong> ${profileOwner.surname!""}</p>
                    <p><strong>Отчество:</strong> ${profileOwner.patronymic!""}</p>
                    <p><strong>Email:</strong> ${profileOwner.email}</p>
                    <p><strong>Текущая роль:</strong>
                        <#if profileOwner.duty??>
                            ${dutyNames[profileOwner.duty.name]!profileOwner.duty.name}
                        <#else>
                            Роль не выбрана
                        </#if>
                    </p>
                </div>
            </div>

            <#if user??>
                <#if profileOwner.id = user.id>
                    <form method="post" action="/profile/update-duty"
                          class="mt-4 d-flex align-items-end gap-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <div class="form-group">
                            <label for="dutySelect" class="form-label">Изменить роль:</label>
                            <select id="dutySelect" name="dutyId" class="form-select">
                                <#list allDuties as duty>
                                    <option value="${duty.id}"
                                            <#if profileOwner.duty?has_content && profileOwner.duty.id == duty.id>selected</#if>>
                                        ${dutyNames[duty.name]!duty.name}
                                    </option>
                                </#list>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Обновить</button>
                    </form>
                </#if>
            </#if>
        </#if>

        <#if userNotFound??>
            Пользователь не найден
        </#if>
    </div>
</#macro>

<#macro scripts>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</#macro>

<@page/>