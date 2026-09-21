# test_register_advanced.py
import requests
import re
import time
import random


def test_registration_advanced(base_url="http://localhost:8080"):
    """Расширенный тест регистрации с полным логированием"""

    print("=" * 60)
    print("РАСШИРЕННЫЙ ТЕСТ РЕГИСТРАЦИИ")
    print("=" * 60)

    # 1. Получаем CSRF токен
    print("\n1. Получаем CSRF токен...")
    session = requests.Session()  # Используем сессию для сохранения кук

    response = session.get(f"{base_url}/register")
    if response.status_code != 200:
        print(f"Ошибка: не удалось получить страницу регистрации, статус {response.status_code}")
        return False

    match = re.search(r'name="_csrf"\s+value="([^"]+)"', response.text)
    if not match:
        print("CSRF токен не найден!")
        return False

    csrf_token = match.group(1)
    print(f"CSRF токен получен: {csrf_token[:30]}...")

    # 2. Создаем пользователя
    timestamp = int(time.time())
    random_suffix = random.randint(1000, 9999)

    username = f"testuser_{timestamp}_{random_suffix}"
    email = f"test_{timestamp}_{random_suffix}@test.com"
    password = "Test123!@#"

    print(f"\n2. Создаем пользователя:")
    print(f"   Username: {username}")
    print(f"   Email: {email}")
    print(f"   Password: {password}")

    register_data = {
        "username": username,
        "name": "Тест",
        "surname": "Тестов",
        "patronymic": "Тестович",
        "email": email,
        "password": password,
        "password_repeat": password,
        "_csrf": csrf_token
    }

    # 3. Отправляем запрос
    print("\n3. Отправляем запрос на регистрацию...")

    response = session.post(
        f"{base_url}/register",
        data=register_data,
        allow_redirects=False,  # Не следуем за редиректами
        headers={
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    )

    print(f"\n4. Результат регистрации:")
    print(f"   Статус: {response.status_code}")
    print(f"   Заголовки: {dict(response.headers)}")

    # 5. Проверяем редирект
    if response.status_code == 302:
        location = response.headers.get('Location')
        print(f"   Редирект на: {location}")

        # Следуем за редиректом
        print("\n5. Следуем за редиректом...")
        redirect_response = session.get(f"{base_url}{location}" if location.startswith('/') else location)
        print(f"   Статус после редиректа: {redirect_response.status_code}")
        print(f"   URL: {redirect_response.url}")
        print(f"   Куки: {session.cookies.get_dict()}")

        # Проверяем, что на странице логина
        if "/login" in redirect_response.url:
            print("\n6. Редирект на страницу логина")
            print("   Проверяем сообщения на странице логина:")

            # Ищем сообщения об успехе или ошибке
            messages = []

            # Ищем сообщения в разных форматах
            patterns = [
                r'<div[^>]*class="[^"]*success[^"]*"[^>]*>([^<]+)</div>',
                r'<div[^>]*class="[^"]*alert-success[^"]*"[^>]*>([^<]+)</div>',
                r'<div[^>]*class="[^"]*message[^"]*"[^>]*>([^<]+)</div>',
                r'<p[^>]*class="[^"]*success[^"]*"[^>]*>([^<]+)</p>',
                r'успешн[оа].*?регистрац',
                r'подтвердит[еь].*?почт',
                r'на ваш email',
                r'проверьт.*?почт'
            ]

            for pattern in patterns:
                matches = re.findall(pattern, redirect_response.text, re.IGNORECASE)
                if matches:
                    for match in matches:
                        if len(match) > 10:  # Игнорируем слишком короткие строки
                            messages.append(match.strip())

            # Ищем ошибки
            error_patterns = [
                r'<div[^>]*class="[^"]*error[^"]*"[^>]*>([^<]+)</div>',
                r'<div[^>]*class="[^"]*alert-danger[^"]*"[^>]*>([^<]+)</div>',
                r'ошибк[аи]',
                r'не удалось',
                r'неверн',
                r'занят',
                r'существует'
            ]

            errors = []
            for pattern in error_patterns:
                matches = re.findall(pattern, redirect_response.text, re.IGNORECASE)
                if matches:
                    for match in matches:
                        if len(match) > 10:
                            errors.append(match.strip())

            if messages:
                print("   Найдены сообщения:")
                for msg in messages[:5]:
                    print(f"     - {msg}")
            else:
                print("   Сообщений не найдено")

            if errors:
                print("   Найдены ошибки:")
                for err in errors[:5]:
                    print(f"     - {err}")

            # Проверяем, есть ли параметр в URL
            if "?" in redirect_response.url:
                print(f"\n   Параметры URL: {redirect_response.url.split('?')[1]}")
                if "success" in redirect_response.url:
                    print("   Есть параметр success - регистрация успешна!")
                if "error" in redirect_response.url:
                    print("   Есть параметр error - регистрация не удалась!")

    # 7. Проверяем куки
    print("\n7. Проверяем куки:")
    cookies = session.cookies.get_dict()
    if cookies:
        for key, value in cookies.items():
            print(f"   {key}: {value}")
    else:
        print("   Куки отсутствуют")

    # 8. Проверяем, создался ли пользователь в БД через API
    print("\n8. Проверяем создание пользователя через API...")
    check_user_api(base_url, username)

    return True


def check_user_api(base_url, username):
    """Проверка пользователя через возможные API эндпоинты"""

    endpoints = [
        "/api/users/check",
        "/api/users/exists",
        "/api/user",
        "/users/check",
        "/profile"
    ]

    found = False
    for endpoint in endpoints:
        try:
            response = requests.get(f"{base_url}{endpoint}?username={username}")
            if response.status_code == 200:
                print(f"   Эндпоинт {endpoint}: пользователь найден")
                print(f"   Ответ: {response.text[:200]}")
                found = True
                break
            elif response.status_code == 404:
                print(f"   Эндпоинт {endpoint}: пользователь не найден")
            else:
                print(f"   Эндпоинт {endpoint}: статус {response.status_code}")
        except:
            pass

    if not found:
        print("   Не удалось проверить через API")

    # Проверяем через логин (попытка залогиниться)
    print("\n9. Пробуем залогиниться созданным пользователем...")
    login_data = {
        "username": username,
        "password": "Test123!@#"
    }

    try:
        # Получаем CSRF для логина
        login_page = requests.get(f"{base_url}/login")
        csrf_match = re.search(r'name="_csrf"\s+value="([^"]+)"', login_page.text)
        if csrf_match:
            login_data["_csrf"] = csrf_match.group(1)

        login_response = requests.post(
            f"{base_url}/login",
            data=login_data,
            allow_redirects=False
        )

        if login_response.status_code == 302:
            print("   УСПЕШНО! Пользователь существует и может залогиниться!")
            return True
        elif login_response.status_code == 200:
            print("   НЕ УДАЛОСЬ залогиниться. Проверь пароль или пользователь не создан.")
            # Ищем сообщение об ошибке
            if "Invalid" in login_response.text or "неверн" in login_response.text:
                print("   Ошибка: неверный логин или пароль")
        else:
            print(f"   Ошибка логина: статус {login_response.status_code}")
    except Exception as e:
        print(f"   Ошибка при попытке логина: {e}")

    return False


if __name__ == "__main__":
    BASE_URL = "http://localhost:8080"

    print("Проверка доступности сервера...")
    try:
        response = requests.get(f"{BASE_URL}/register", timeout=5)
        if response.status_code == 200:
            print("Сервер доступен")
        else:
            print(f"Сервер ответил с кодом: {response.status_code}")
            exit(1)
    except Exception as e:
        print(f"Сервер недоступен: {e}")
        exit(1)

    # Запускаем тест
    test_registration_advanced(BASE_URL)