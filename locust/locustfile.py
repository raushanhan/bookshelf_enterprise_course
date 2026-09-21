from locust import HttpUser, task, between
import random


BOOK_IDS = list(range(1, 4))


class WebsiteUser(HttpUser):

    wait_time = between(1, 3)

    @task
    def browse_books(self):
        self.client.get("/home")

        self.client.get("/bookshelf")

        book_id = random.choice(BOOK_IDS)

        self.client.get(f"/book/{book_id}")

        self.client.get(f"/book/{book_id}/read")


        