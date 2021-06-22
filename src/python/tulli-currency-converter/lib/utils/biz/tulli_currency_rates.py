import re
from datetime import datetime
import requests
from bs4 import BeautifulSoup
from bs4.element import Tag


def get_tulli_currencies(month: str, currency_code: str):
    current_month = datetime.now().strftime("yyyy-mm")
    currencies = []

    if not re.search(r"^[0-9]{4}\-[0-9]{2}$", month):
        month = current_month

    base_url = "https://tulli.fi/en/businesses/import/currency-conversion-rates/-/cr"
    web_document = requests.get(f"{base_url}/{month}")
    scraping = BeautifulSoup(web_document.text, "html.parser")

    table: Tag = scraping.find(
        name="table", 
        attrs={"class": "datatable-currency-rates-management-list"}
    )
    table_rows = table.find(name="tbody").find_all(name="tr")

    for table_row in table_rows:
        cells = table_row.find_all(name="td")
        data = {
            "currency": cells[0].contents[0],
            "currency_code": cells[1].contents[0],
            "currency_rate": cells[2].contents[0],
        }

        if data["currency_code"] == currency_code:
            currencies = [data]
            break

        currencies.append(data)

    return currencies
