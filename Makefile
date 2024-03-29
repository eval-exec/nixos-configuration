fmt:
	nixfmt *.nix

flake-update:
	nix flake update

dry-build: fmt
	git diff --exit-code
	sudo -S nixos-rebuild dry-build --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose

switch: fmt
	git diff --exit-code
	sudo -S nixos-rebuild switch --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose --show-trace

boot: fmt
	git diff --exit-code
	sudo -S nixos-rebuild boot --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose --show-trace
