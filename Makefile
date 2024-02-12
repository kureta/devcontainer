.PHONY: init run clean

BASE_IMAGE=archlinux:latest

.init:
	@echo "Initializing..."
	@touch .init

init: .init Dockerfile run.sh devcontainer-dotfiles/.config/yadm/bootstrap
	./run.sh build $(BASE_IMAGE)

run: init run.sh
	./run.sh run

clean:
	rm .init
