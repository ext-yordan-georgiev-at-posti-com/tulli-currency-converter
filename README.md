# TORNADO POC

A proof of concept of the Python framework [Tornado](https://www.tornadoweb.org/en/stable/).

---

## Prerequisite
- Make
- Docker

---

## Usage
<!-- The devops container is guided to the different environments via the following env vars: -->
1. Build the docker image:
```bash
make install
```
2. Start the tornado server
```bash
make do_start_tornado_server
```
3. Test by 

```bash
curl -s http://localhost:8888/tulli-currency-rates|jq '.'
# filter by currency 
curl -s http://localhost:8888/tulli-currency-rates?currency-code=USD|jq '.'
```  

---

Other `make` functions could be checked with the command:_
```bash
make help
```
