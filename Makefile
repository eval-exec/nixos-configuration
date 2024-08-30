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
	rm /home/exec/.config/fontconfig/conf.d/10-hm-fonts.conf || true
	sudo -S nixos-rebuild switch --max-jobs 20 --cores 20 --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose --show-trace --print-build-logs
	notify-send "NixOS: make switch finished"

boot: fmt
	git diff --exit-code
	sudo -S nixos-rebuild boot --flake /home/exec/Projects/github.com/eval-exec/nixos-configuration/.#Mufasa --verbose --show-trace
	notify-send "NixOS: make book finished"
