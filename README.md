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
make do_build_devops_docker_image
```
2. Instantiate a container:
```bash
make do_create_container
```
3. Start the tornado server
```bash
# on a host
./run -a do_start_tornado_server
# via the docker
make do_start_tornado_server

# and test
curl http://localhost:8888/tulli-currency-rates|jq '.'
# filter by currency 
curl http://localhost:8888/tulli-currency-rates?currency-code=USD|jq '.'
```  

---

_Other `make` functions could be checked with the command:_
```bash
make help
```
