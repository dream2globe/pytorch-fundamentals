CUDA=11.6.2
BASE=ubuntu20.04
PYTHON=3.9.16
SERVER=dream2globe.jfrog.io

docker-build:
	docker build --build-arg BASE_IMAGE=nvidia/cuda:${CUDA}-base-${BASE} --build-arg PYTHON=${PYTHON} -t ${SERVER}/default-docker/mytorch:${CUDA}-${BASE}-${PYTHON} .

docker-update:
	docker login -ushyeon.kang@gmail.com ${SERVER}
	docker tag mytorch:${CUDA}-${BASE}-${PYTHON} ${SERVER}/default-docker/mytorch:latest
	docker push ${SERVER}/default-docker/mytorch:${CUDA}-${BASE}-${PYTHON}
	docker push ${SERVER}/default-docker/mytorch:latest

docker-clean:
	docker stop $$(docker ps -a -q)
	docker rm -f $$(docker ps -a -q)

docker-remove:
	docker system prune --volumes -f
	docker rmi -f $$(docker images -q)

docker-run:
	docker run --name mytorch --ipc=host --gpus all --rm -it -p=8888:8888 -v=.:/app ${SERVER}/default-docker/mytorch:latest