fmt:
	nixfmt *.nix

flake-update:
	nix flake update

dry-build: fmt
	git diff --exit-code
	sudo nixos-rebuild dry-build --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose

switch: fmt
	git diff --exit-code
	sudo nixos-rebuild switch --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose --show-trace
