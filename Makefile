SHELL=/bin/bash

DOCKER_NAME=rest-li-tutorial

start: build-docker run-docker logs-docker

build-docker:
	docker build -t $(DOCKER_NAME) .

run-docker: build-docker
	docker run -d \
		-p 127.0.0.1:8080:8080 \
		--name ${DOCKER_NAME} \
		${DOCKER_NAME}

attach-docker:
	docker exec -u restli -it `docker ps | grep ${DOCKER_NAME} | awk '{print $$1;}'` /bin/bash

clear-docker:
	docker stop `docker ps | grep ${DOCKER_NAME} | awk '{print $$1;}'` || true
	docker rm `docker ps -a | grep ${DOCKER_NAME} | awk '{print $$1;}'` || true

logs-docker:
	docker logs -t -f ${DOCKER_NAME}

