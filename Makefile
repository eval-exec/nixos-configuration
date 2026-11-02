HOST ?= Mufasa
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
		--option extra-substituters 'https://cache.lantian.pub/lantian https://noctalia.cachix.org https://umbriel.cachix.org' \
		--option extra-trusted-public-keys 'lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ= noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4= umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw='
	notify-send 'NixOS: make switch finished'

switch-hm: fmt check
	git diff --exit-code
	primary_user="$$(nix eval --raw ".#nixosConfigurations.$(HOST).config.users.primaryUser")"; \
		activation="$$(nix build --no-link --print-out-paths ".#nixosConfigurations.$(HOST).config.home-manager.users.$$primary_user.home.activationPackage")"; \
		"$$activation/activate"

boot: fmt check
	git diff --exit-code
	sudo -S nixos-rebuild boot --flake $(FLAKE) --verbose --show-trace
	notify-send 'NixOS: make boot finished'
