# test_register.py - простой тест регистрации одного пользователя
import requests


def test_single_registration(base_url="http://localhost:8080"):
    """Тест регистрации одного пользователя"""

    # 1. Получаем CSRF токен
    print("1. Получаем CSRF токен...")
    response = requests.get(f"{base_url}/register")
    if response.status_code != 200:
        print(f"Ошибка: не удалось получить страницу регистрации, статус {response.status_code}")
        return

    # Ищем CSRF
    import re
    match = re.search(r'name="_csrf"\s+value="([^"]+)"', response.text)
    if not match:
        print("CSRF токен не найден!")
        return

    csrf_token = match.group(1)
    print(f"CSRF токен: {csrf_token[:30]}...")

    # 2. Создаем пользователя
    print("\n2. Создаем пользователя...")

    username = "testuser_123456"
    email = "testuser_123456@test.com"
    password = "Test123!@#"

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

    print(f"Данные: {register_data}")

    # Отправляем запрос
    response = requests.post(
        f"{base_url}/register",
        data=register_data,
        allow_redirects=False
    )

    print(f"\n3. Результат:")
    print(f"Статус: {response.status_code}")
    print(f"Заголовки: {dict(response.headers)}")

    if response.status_code == 302:
        print("УСПЕШНО! Пользователь создан (редирект)")
        return True
    else:
        print(f"Ошибка! Тело ответа:")
        print(response.text[:1000])
        return False


if __name__ == "__main__":
    test_single_registration("http://localhost:8080")