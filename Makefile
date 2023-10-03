
build: fmt
	git diff --exit-code
	sudo nixos-rebuild switch --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose

fmt:
	nixfmt *.nix
