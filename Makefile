default: help

help: ## @-> show this help  the default action
	@clear
	@fgrep -h "##" $(MAKEFILE_LIST)|fgrep -v fgrep|sed -e 's/^\.PHONY //'|sed -e 's/^\(.*\):\(.*\)##/\1/'|column -t -s $$'@'

install: do_build_devops_docker_ima do_create_container ## @-> setup the whole environment to run this proj

.PHONY install_no_cache: ## @-> setup the whole environment to run this proj, but do NOT reuse the cache
install_no_cache: do_build_devops_docker_ima_no_cache do_create_container

run: run_tulli_currency_converter ## @-> run some functions

do_run: do_run_tulli_currency_converter ## @-> run some functions in the running container

do_build_devops_docker_ima: ## @-> build the devops docker image
	docker build . -t proj-img --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

do_build_devops_docker_ima_no_cache: ## @-> build the devops docker image, do NOT use cached 
	docker build . --no-cache -t proj-img --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

stop_container: ## @-> stop the devops running container
	-docker container stop $$(docker ps -aqf "name=proj-con")
	-docker container rm $$(docker ps -aqf "name=proj-con")

do_create_container: stop_container ## @-> create a container named "proj-con" from the builded image
	docker run -d -v $$(pwd):/opt/tulli-currency-converter -v $$HOME/.aws:/home/ubuntu/.aws -v $$HOME/.kube:/home/ubuntu/.kube -p 8888:8888 --name proj-con proj-img ; docker ps -a

do_delete_container: ## @-> delete the container with the name "proj-con" if exists
	docker stop proj-con ; docker rm proj-con ; docker ps -a

start_tornado_server: ## @-> start the tornado server
	./run -a do_start_tornado_server

run_tulli_currency_converter: ## @-> run the hello world function
	./run -a do_run_tulli_currency_converter

do_start_tornado_server: ## @-> start the tornado server at the container
	docker exec -it proj-con /opt/tulli-currency-converter/run -a do_start_tornado_server

do_run_tulli_currency_converter: ## @-> run the hello world function in the "proj-con" container
	-docker container stop $$(docker ps -aqf "name=proj-con")
	-docker container rm $$(docker ps -aqf "name=proj-con")
	docker exec -it proj-con /opt/tulli-currency-converter/run -a do_run_tulli_currency_converter

read_logs: ## @-> read the current log file of the tornado server
	cat /home/ubuntu/.tulli-currency-converter/logs/log.out

do_read_logs: ## @-> read the current log file of the tornado server in the running container
	docker exec -it proj-con /bin/bash -c "cat /home/ubuntu/.tulli-currency-converter/logs/log.out"

do_prune_docker_system: ## @-> completely wipe out all the docker caches for ALL IMAGES !!!
	-docker kill $$(docker ps -q) ; -docker rm $(docker ps -a -q)
	docker builder prune -f --all ; docker system prune -f

ensure_var-%:   ## @-> ensure a var is set in the make calling shell
	@if [ "${${*}}" = "" ]; then \
		echo "the var \"$*\" is not set, do set it by: export $*='value'"; \
		exit 1; \
	fi

task-which-requires-a-var: ensure_var-ENV_TYPE
	@echo ${ENV_TYPE}

spawn_tgt_project: ensure_var-TGT_PROJ zip_me ## @-> spawn a new target project
	-rm -r $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	unzip -o ../tulli-currency-converter.zip -d $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	to_srch=tulli-currency-converter to_repl=$(shell echo $$TGT_PROJ) dir_to_morph=$(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ) ./run -a do_morph_dir


zip_me: ## @-> zip the whole project without the .git dir
	-rm -v ../tulli-currency-converter.zip ; zip -r ../tulli-currency-converter.zip  . -x '*.git*'
