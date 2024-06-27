fmt:
	nixfmt *.nix

flake-update:
	nix flake update
	notify-send "NixOS: \"nix flake update\" finished"

dry-build: fmt
	git diff --exit-code
	sudo -S nixos-rebuild dry-build --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose

switch🔄: fmt
	git diff --exit-code
	sudo -S nixos-rebuild switch --build-host matrix_wan --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose # --show-trace
	notify-send "NixOS: make switch finished"

boot: fmt
	git diff --exit-code
	sudo -S nixos-rebuild boot --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose --show-trace
	notify-send "NixOS: make book finished"
