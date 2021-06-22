import os
from tornado.web import Application
from tornado.ioloop import IOLoop
from tornado.autoreload import start as autoreload_start
from tornado.options import parse_command_line
from .controllers.tulli_currency_rates_controller import TulliCurrencyRatesController


TORNADO_PORT = os.getenv("TORNADO_PORT", default = "8888")

ROUTES = [
    (r"/tulli-currency-rates", TulliCurrencyRatesController)
]


def make_app():
    return Application(ROUTES)


def start_server():
    app = make_app()
    app.listen(TORNADO_PORT)
    parse_command_line()
    print(f"Server started at port {TORNADO_PORT}...")
    autoreload_start()
    IOLoop.current().start()


if __name__ == "__main__":
    start_server()
