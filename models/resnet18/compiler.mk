.PHONY : clean build all

MODEL ?= resnet18
MODELINPUT ?= "data",float,[1,3,224,224]
BAPI ?= static
BUNDLE ?= bin
MEMOPT ?= false

all: clean build

build: ${BUNDLE}/$(MODEL).o

${BUNDLE}/$(MODEL).o : $(MODEL).onnx
	@echo 'Build the bundle object $@:'
	${GLOWBIN}/model-compiler \
		-model=$(MODEL).onnx \
		-model-input=$(MODELINPUT) \
		-bundle-api=$(BAPI) \
		-MO436-features=false \
		-emit-bundle=$(BUNDLE) \
		-dump-graph-DAG-before-compile=$(MODEL)-before.dot \
		-dump-graph-DAG=$(MODEL)-after.dot \
		-backend=CPU \
		-reuse-activation-memory-allocations=$(MEMOPT) \
		-dump-ir > $(MODEL).lir

clean:
	rm -f ${BUNDLE}/$(MODEL).o
