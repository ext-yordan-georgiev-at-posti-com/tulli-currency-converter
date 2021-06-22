import json
from datetime import datetime
from tornado.web import RequestHandler
from lib.utils.biz.tulli_currency_rates import get_tulli_currencies

class TulliCurrencyRatesController(RequestHandler):
    def get(self):
        status_code = 200
        response = {
            "currencies": [],
        }

        try:
            current_month = datetime.now().strftime("yyyy-mm")
            month = self.get_argument("month", current_month)
            currency_code = self.get_argument("currency-code", "ALL")
            response["currencies"] = get_tulli_currencies(month, currency_code)

        except Exception as err:
            response["error"] = f"{err}"
            status_code = 500

        self.set_header("Content-Type", "application/json")
        self.set_status(status_code)
        self.write(json.dumps(response))
