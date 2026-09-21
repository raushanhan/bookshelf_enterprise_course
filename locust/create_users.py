# create_users.py
import requests
import random
import time
import string
import re


def get_csrf_token(base_url="http://localhost:8080"):
    """Получение CSRF токена со страницы регистрации"""
    try:
        response = requests.get(f"{base_url}/register")
        if response.status_code == 200:
            # Ищем CSRF токен разными способами
            patterns = [
                r'name="_csrf"\s+value="([^"]+)"',
                r'value="([^"]+)"\s+name="_csrf"',
                r'name="_csrf"\s+value=\'([^\']+)\'',
                r'value=\'([^\']+)\'\s+name="_csrf"',
            ]

            for pattern in patterns:
                match = re.search(pattern, response.text)
                if match:
                    csrf_token = match.group(1)
                    print(f"CSRF токен найден: {csrf_token[:20]}...")
                    return csrf_token

            print("CSRF токен не найден")
            return None
    except Exception as e:
        print(f"Ошибка получения CSRF: {e}")
        return None


def generate_username():
    return f"loaduser_{random.randint(10000, 999999)}"


def generate_name():
    names = ["Алексей", "Мария", "Иван", "Екатерина", "Дмитрий", "Анна", "Сергей", "Ольга", "Андрей", "Татьяна"]
    return random.choice(names)


def generate_surname():
    surnames = ["Иванов", "Петров", "Сидоров", "Смирнов", "Кузнецов", "Попов", "Соколов", "Лебедев", "Козлов",
                "Новиков"]
    return random.choice(surnames)


def generate_patronymic():
    patronymics = ["Александрович", "Сергеевич", "Алексеевич", "Дмитриевич", "Владимирович",
                   "Андреевич", "Николаевич", "Петрович", "Иванович", "Михайлович"]
    return random.choice(patronymics)


def generate_email(username):
    domains = ["test.com", "example.com", "mail.ru", "yandex.ru", "gmail.com"]
    return f"{username}@{random.choice(domains)}"


def generate_password():
    return "Test123!@#"


def create_users(count=100, base_url="http://localhost:8080"):
    """Создание пользователей с подробным логированием"""

    print(f"Начинаем создание {count} пользователей...")
    print(f"URL: {base_url}")
    print("-" * 50)

    # Получаем CSRF токен
    csrf_token = get_csrf_token(base_url)
    if csrf_token:
        print(f"CSRF токен получен: {csrf_token[:30]}...")
    else:
        print("ВНИМАНИЕ: CSRF токен не получен!")

    created = 0
    failed = 0
    failed_users = []
    debug_responses = []  # Для отладки первых ответов

    for i in range(count):
        username = generate_username()
        name = generate_name()
        surname = generate_surname()
        patronymic = generate_patronymic()
        email = generate_email(username)
        password = generate_password()

        register_data = {
            "username": username,
            "name": name,
            "surname": surname,
            "patronymic": patronymic,
            "email": email,
            "password": password,
            "password_repeat": password
        }

        if csrf_token:
            register_data['_csrf'] = csrf_token

        try:
            # Отправляем запрос
            response = requests.post(
                f"{base_url}/register",
                data=register_data,
                allow_redirects=False,  # Не следуем за редиректами
                headers={
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
                }
            )

            # Сохраняем первые 5 ответов для отладки
            if i < 5:
                debug_responses.append({
                    "username": username,
                    "status_code": response.status_code,
                    "headers": dict(response.headers),
                    "body_preview": response.text[:500] if response.text else "EMPTY"
                })

            # Проверяем результат
            if response.status_code == 302:
                # Успешная регистрация (редирект на /login или /home)
                created += 1
                if created % 10 == 0:
                    print(f"Создано {created} пользователей...")

            elif response.status_code == 200:
                # Проверяем текст ошибки
                response_text = response.text

                if "Данное имя пользователя уже занято" in response_text:
                    print(f"Имя {username} уже занято, пропускаем...")
                    continue

                elif "Аккаунт с данным адресом электронной почты уже создан" in response_text:
                    print(f"Email {email} уже используется, пропускаем...")
                    continue

                elif "Invalid CSRF Token" in response_text or "CSRF" in response_text:
                    print(f"Ошибка CSRF для {username}! Обновляем токен...")
                    csrf_token = get_csrf_token(base_url)
                    failed += 1
                    failed_users.append({
                        "username": username,
                        "error": "CSRF token invalid"
                    })

                elif "error" in response_text.lower() or "ошибк" in response_text.lower():
                    # Показываем ошибку
                    print(f"Ошибка при создании {username}:")
                    # Ищем сообщение об ошибке в HTML
                    error_pattern = r'<div[^>]*class="[^"]*error[^"]*"[^>]*>([^<]+)</div>'
                    error_match = re.search(error_pattern, response_text)
                    if error_match:
                        print(f"  Сообщение: {error_match.group(1).strip()}")
                    else:
                        print(f"  Статус 200, но есть ошибка (смотри debug)")

                    failed += 1
                    failed_users.append({
                        "username": username,
                        "error": "Unknown error on page"
                    })
                else:
                    # Возможно, успех, но нет редиректа
                    print(f"Неизвестный ответ для {username}: статус 200, но нет ошибки")
                    # Проверяем, может быть редирект через meta или JavaScript
                    if "redirect" in response_text.lower() or "meta" in response_text.lower():
                        print(f"  Возможно, редирект через JavaScript")
                        created += 1
                    else:
                        failed += 1
                        failed_users.append({
                            "username": username,
                            "error": "Status 200 without redirect"
                        })
            else:
                failed += 1
                failed_users.append({
                    "username": username,
                    "status": response.status_code
                })
                print(f"Ошибка при создании {username}: статус {response.status_code}")

        except requests.exceptions.RequestException as e:
            failed += 1
            failed_users.append({
                "username": username,
                "error": str(e)
            })
            print(f"Ошибка соединения для {username}: {e}")

        # Задержка между запросами
        time.sleep(random.uniform(0.2, 0.5))

        if (i + 1) % 50 == 0:
            print(f"Пауза 2 секунды...")
            time.sleep(2)

    # Выводим отладочную информацию
    print("\n" + "=" * 50)
    print("ОТЛАДОЧНАЯ ИНФОРМАЦИЯ (первые 5 запросов):")
    for debug in debug_responses:
        print(f"\nПользователь: {debug['username']}")
        print(f"  Статус: {debug['status_code']}")
        print(f"  Заголовки: {debug['headers'].get('location', 'Нет редиректа')}")
        if debug['status_code'] == 200:
            print(f"  Тело ответа (первые 300 символов):")
            print(f"  {debug['body_preview'][:300]}...")

    print("\n" + "=" * 50)
    print("ИТОГИ СОЗДАНИЯ ПОЛЬЗОВАТЕЛЕЙ:")
    print(f"Успешно создано: {created}")
    print(f"Не удалось создать: {failed}")

    if failed_users:
        print("\nОшибки:")
        for user in failed_users[:10]:
            print(f"  - {user['username']}: {user.get('error', user.get('status', 'Unknown'))}")
        if len(failed_users) > 10:
            print(f"  ... и еще {len(failed_users) - 10} ошибок")

    return created, failed_users


def save_users_to_file(users_count=100):
    filename = "users_list.txt"
    with open(filename, "w") as f:
        for i in range(users_count):
            username = f"loaduser_{10000 + i}" if i < 10000 else f"loaduser_{i}"
            f.write(f"{username}:Test123!@#\n")
    print(f"Список пользователей сохранен в {filename}")


if __name__ == "__main__":
    BASE_URL = "http://localhost:8080"
    USERS_TO_CREATE = 10  # Для теста создаем 10 пользователей

    print("Проверка доступности API...")
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

    print("\n" + "=" * 50)

    # Создаем пользователей
    created, failed = create_users(USERS_TO_CREATE, BASE_URL)

    if created > 0:
        save_users_to_file(created)
        print("\nСписок пользователей сохранен в файл")

    print("\nГотово!")