import json
import re
from datetime import datetime
import requests
from tornado.web import RequestHandler
from bs4 import BeautifulSoup
from bs4.element import Tag


class TulliCurrencyRatesController(RequestHandler):
    def get(self):
        status_code = 200
        response = {
            "currencies": [],
        }

        try:
            current_month = datetime.now().strftime("yyyy-mm")
            month = self.get_argument("month", current_month)
            if not re.search(r"^[0-9]{4}\-[0-9]{2}$", month):
                month = current_month

            currency_code = self.get_argument("currency-code", "ALL")

            base_url = "https://tulli.fi/en/businesses/import/currency-conversion-rates/-/cr"
            web_document = requests.get(f"{base_url}/{month}")
            scraping = BeautifulSoup(web_document.text, "html.parser")

            table: Tag = scraping.find(name="table", attrs={"class": "datatable-currency-rates-management-list"})
            table_rows = table.find(name="tbody").find_all(name="tr")

            for table_row in table_rows:
                cells = table_row.find_all(name="td")
                data = {
                    "currency": cells[0].contents[0],
                    "currency_code": cells[1].contents[0],
                    "currency_rate": cells[2].contents[0],
                }

                if data["currency_code"] == currency_code:
                    response["currencies"] = [data]
                    break

                response["currencies"].append(data)

        except Exception as err:
            response["error"] = f"{err}"
            status_code = 500

        self.set_header("Content-Type", "application/json")
        self.set_status(status_code)
        self.write(json.dumps(response))
