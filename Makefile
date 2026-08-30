HOST ?= Mufasa
PRIMARY_USER ?= exec
FLAKE ?= .\#$(HOST)
NIX_FILES := $(shell rg --files -g '*.nix')

.PHONY: fmt check flake-update dry-build switch-os switch-hm boot

fmt:
	nixfmt $(NIX_FILES)

check:
	nix flake check --no-build

flake-update:
	nix flake update
	notify-send 'NixOS: nix flake update finished'

dry-build: fmt check
	git diff --exit-code
	sudo -S nixos-rebuild dry-build --flake $(FLAKE) --verbose

switch-os: fmt check
	git diff --exit-code
	rm -f "$$HOME/.config/fontconfig/conf.d/10-hm-fonts.conf"
	sudo -S nixos-rebuild switch --max-jobs 20 --cores 20 --flake $(FLAKE) \
		--verbose --show-trace --print-build-logs \
		--option extra-trusted-public-keys 'lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc='
	notify-send 'NixOS: make switch finished'

switch-hm: fmt check
	git diff --exit-code
	activation="$$(nix build --no-link --print-out-paths ".#nixosConfigurations.$(HOST).config.home-manager.users.$(PRIMARY_USER).home.activationPackage")"; \
		"$$activation/activate"

boot: fmt check
	git diff --exit-code
	sudo -S nixos-rebuild boot --flake $(FLAKE) --verbose --show-trace
	notify-send 'NixOS: make boot finished'
