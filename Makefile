
build: fmt
	git diff --exit-code
	sudo nixos-rebuild switch --flake /home/exec/Projects/github.com/eval-exec/nixos-config/.#Mufasa --verbose

fmt:
	nixfmt *.nix
