<#include 'base.ftl'>

<#macro head>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</#macro>

<#macro title>
    Администрирование
</#macro>

<#macro body>
    <div class="container container-box">
        <#list users as user_in_list>
            <#if user_in_list.id != user.id>
                <div class="user-card d-flex justify-content-between align-items-center">
                    <div class="d-flex">
                        <div><strong>${user_in_list.username}</strong></div>
                        <a class="underline-link ms-4" href="/profile/${user_in_list.username}">Перейти к профилю</a>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <#if !user_in_list.isBanned>
                            <div class="text-success user-status">Активный</div>
                            <form class='change-status-form ban-form' method="post"
                                  action="/admin/ban/${user_in_list.id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button class="btn btn-outline-danger btn-sm ban-user-btn ms-4"
                                        data-user-id="${user_in_list.id}" type="submit">Заблокировать
                                </button>
                            </form>
                        <#else>
                            <div class="text-danger user-status">Заблокированный</div>
                            <form class='change-status-form unban-form' method="post"
                                  action="/admin/unban/${user_in_list.id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button class="btn btn-outline-success btn-sm unban-user-btn ms-4"
                                        data-user-id="${user_in_list.id}" type="submit">Разблокировать
                                </button>
                            </form>
                        </#if>
                    </div>
                </div>
            </#if>
        </#list>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</#macro>

<#macro scripts>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.ban-form').forEach(form => {
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    const button = form.querySelector('.ban-user-btn');
                    banUser.call(button);
                })
            });

            document.querySelectorAll('.unban-form').forEach(form => {
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    const button = form.querySelector('.unban-user-btn');
                    unbanUser.call(button);
                })
            });
            function banUser() {
                const userId = this.dataset.userId;

                fetch('/admin/ban/' + userId, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-TOKEN': getCsrfToken()
                    }
                }).then(response => {
                    if (response.ok) {
                        const userCard = this.closest('.user-card');
                        const statusDiv = userCard.querySelector('.user-status');
                        if (statusDiv) {
                            statusDiv.classList.remove('text-success');
                            statusDiv.classList.add('text-danger');
                            statusDiv.textContent = 'Заблокированный';
                        }

                        const form = userCard.querySelector('.change-status-form');
                        form.setAttribute('action', '/admin/unban/' + userId);

                        const button = form.querySelector('button');
                        button.classList.remove('btn-outline-danger');
                        button.classList.add('btn-outline-success');
                        button.textContent = 'Разблокировать';

                        button.classList.remove('ban-user-btn');
                        button.classList.add('unban-user-btn');
                        button.dataset.userId = userId;
                        button.removeEventListener('click', banUser);
                        button.addEventListener('click', unbanUser);
                    } else {
                        alert("Ошибка при блокировке пользователя");
                    }
                }).catch(err => {
                    console.error("Ошибка:", err);
                });
            }

            function unbanUser() {
                const userId = this.dataset.userId;

                fetch('/admin/unban/' + userId, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-TOKEN': getCsrfToken()
                    }
                }).then(response => {
                    if (response.ok) {
                        const userCard = this.closest('.user-card');
                        const statusDiv = userCard.querySelector('.user-status');
                        if (statusDiv) {
                            statusDiv.classList.remove('text-danger');
                            statusDiv.classList.add('text-success');
                            statusDiv.textContent = 'Активный';
                        }

                        const form = userCard.querySelector('.change-status-form');
                        form.setAttribute('action', '/admin/ban/' + userId);

                        const button = form.querySelector('button');
                        button.classList.remove('btn-outline-success');
                        button.classList.add('btn-outline-danger');
                        button.textContent = 'Заблокировать';

                        button.classList.remove('unban-user-btn');
                        button.classList.add('ban-user-btn');
                        button.dataset.userId = userId;
                        button.removeEventListener('click', unbanUser);
                        button.addEventListener('click', banUser);
                    } else {
                        alert("Ошибка при разблокировке пользователя");
                    }
                }).catch(err => {
                    console.error("Ошибка:", err);
                });
            }

            function getCsrfToken() {
                const csrfMeta = document.querySelector('meta[name="_csrf"]');
                return csrfMeta ? csrfMeta.content : '';
            }
        });
    </script>
</#macro>

<@page/>