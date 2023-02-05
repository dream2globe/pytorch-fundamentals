CUDA=11.6.2
BASE=ubuntu20.04
PYTHON=3.9.16
SERVER=dream2globe.jfrog.io
REPO=default-docker
BASE_IMAGE := nvidia/cuda:${CUDA}-base-${BASE}
BUILD_IMAGE := ${SERVER}/${REPO}/mytorch
TAG := ${CUDA}-${BASE}-${PYTHON}

docker-build:
	docker build --build-arg BASE_IMAGE=${BASE_IMAGE} --build-arg PYTHON=${PYTHON} -t ${BUILD_IMAGE}:${TAG} .

docker-update:
	docker login -ushyeon.kang@gmail.com ${SERVER}
	docker tag ${BUILD_IMAGE}:${TAG} ${BUILD_IMAGE}:latest
	docker push ${BUILD_IMAGE}:${TAG}
	docker push ${BUILD_IMAGE}:latest

docker-clean:
	docker stop $$(docker ps -a -q)
	docker rm -f $$(docker ps -a -q)

docker-remove:
	docker system prune --volumes -f
	docker rmi -f $$(docker images -q)

docker-run:
	docker run --name mytorch --ipc=host --gpus all --rm -it -p=8888:8888 -v=.:/app ${BUILD_IMAGE}:latest