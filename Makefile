
build: fmt
	git diff --exit-code
	sudo nixos-rebuild switch --flake /home/exec/my-flake/.#Mufasa --verbose

fmt:
	nixfmt *.nix
