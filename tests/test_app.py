import unittest
import threading
import urllib.request
import urllib.error

from http.server import HTTPServer
from app import Handler


class AppTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.server = HTTPServer(("127.0.0.1", 0), Handler)
        cls.port = cls.server.server_port

        cls.thread = threading.Thread(
            target=cls.server.serve_forever,
            daemon=True
        )
        cls.thread.start()

    @classmethod
    def tearDownClass(cls):
        cls.server.shutdown()

    def test_healthz_returns_200(self):
        response = urllib.request.urlopen(
            f"http://127.0.0.1:{self.port}/healthz"
        )
        self.assertEqual(response.status, 200)

    def test_healthz_returns_ok(self):
        response = urllib.request.urlopen(
            f"http://127.0.0.1:{self.port}/healthz"
        )
        self.assertEqual(response.read(), b"OK")

    def test_home_returns_project_name(self):
        response = urllib.request.urlopen(
            f"http://127.0.0.1:{self.port}/"
        )
        self.assertEqual(response.read(), b"INF 345 Project")


if __name__ == "__main__":
    unittest.main()