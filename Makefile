.PHONY: init run

.init:
	@echo "Initializing..."
	@touch .init

init: .init Dockerfile run.sh
	./run.sh build

run: init run.sh
	./run.sh run
