default: help

help: ## -> show this help  the default action
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'| column -t -s $$'@'

install: do_build_devops_docker_image do_create_container ## @-> setup the whole environment to run this proj

run: run_hello_world ## @-> run some functions

do_run: do_run_hello_world ## @-> run some functions in the running container

do_build_devops_docker_image: ## @-> build the devops docker image
	docker build . -t tulli-currency-converter-devops-img --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

do_create_container: ## @-> create a container named "tulli-currency-converter-devops" from the builded image
	docker run -d -v $$(pwd):/opt/tulli-currency-converter -v $$HOME/.aws:/home/ubuntu/.aws -v $$HOME/.kube:/home/ubuntu/.kube -p 8888:8888 --name tulli-currency-converter-devops tulli-currency-converter-devops-img ; docker ps -a

do_delete_container: ## @-> delete the container with the name "tulli-currency-converter-devops" if exists
	docker stop tulli-currency-converter-devops ; docker rm tulli-currency-converter-devops ; docker ps -a

start_tornado_server: ## @-> start the tornado server
	./run -a do_start_tornado_server

run_hello_world: ## @-> run the hello world function
	./run -a do_run_hello_world

do_start_tornado_server: ## @-> start the tornado server at the container
	docker exec -it tulli-currency-converter-devops /opt/tulli-currency-converter/run -a do_start_tornado_server

do_run_hello_world: ## @-> run the hello world function in the "tulli-currency-converter-devops" container
	docker exec -it tulli-currency-converter-devops /opt/tulli-currency-converter/run -a do_run_hello_world

read_logs: ## @-> read the current log file of the tornado server
	cat /home/ubuntu/.tulli-currency-converter/logs/log.out

do_read_logs: ## @-> read the current log file of the tornado server in the running container
	docker exec -it tulli-currency-converter-devops /bin/bash -c "cat /home/ubuntu/.tulli-currency-converter/logs/log.out"

do_prune_docker_system: ## @-> completely wipe out all the docker caches for ALL IMAGES !!!
	docker builder prune -f --all ; docker system prune -f

ensure_is_exported_for_var-%:   ## @-> zip the whole project without the .git dir
	@if [ "${${*}}" = "" ]; then \
		echo "the var \"$*\" is not set, do set it by: export $*='value'"; \
		exit 1; \
	fi

task-which-requires-a-var: ensure_is_exported_for_var-ENV_TYPE
	@echo ${ENV_TYPE}

spawn_tgt_project: ensure_is_exported_for_var-TGT_PROJ zip_me ## @-> spawn a new target project
	-rm -r $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	unzip -o ../tulli-currency-converter.zip -d $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	to_srch=tulli-currency-converter to_repl=$(shell echo $$TGT_PROJ) dir_to_morph=$(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ) ./run -a do_morph_dir


zip_me: ## @-> zip the whole project without the .git dir
	-rm -v ../tulli-currency-converter.zip ; zip -r ../tulli-currency-converter.zip  . -x '*.git*'
