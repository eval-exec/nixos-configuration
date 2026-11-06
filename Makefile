HOST ?= Mufasa
FLAKE ?= .\#$(HOST)
NIX_FILES := $(shell rg --files -g '*.nix')

# Only notify when a daemon owns org.freedesktop.Notifications. Without one
# (e.g. booted to kmscon without Plasma), notify-send blocks for ~85s while
# D-Bus activation waits for plasma_waitforname to time out.
NOTIFY := busctl --user call org.freedesktop.DBus /org/freedesktop/DBus \
	org.freedesktop.DBus GetNameOwner s org.freedesktop.Notifications \
	>/dev/null 2>&1 && notify-send

.PHONY: fmt check flake-update dry-build switch-os switch-hm switch-hm-fast boot

fmt:
	nixfmt $(NIX_FILES)

check:
	nix flake check --no-build

flake-update:
	nix flake update
	-$(NOTIFY) 'NixOS: nix flake update finished'

dry-build: fmt check
	git diff --exit-code
	sudo -S nixos-rebuild dry-build --flake $(FLAKE) --verbose

switch-os: fmt check
	git diff --exit-code
	rm -f "$$HOME/.config/fontconfig/conf.d/10-hm-fonts.conf"
	sudo -S nixos-rebuild switch --max-jobs 20 --cores 20 --flake $(FLAKE) \
		--verbose --show-trace --print-build-logs \
		--option substituters "$$(nix eval --raw '.#nixosConfigurations.$(HOST).config.nix.settings.substituters' --apply 'builtins.concatStringsSep " "')" \
		--option trusted-public-keys "$$(nix eval --raw '.#nixosConfigurations.$(HOST).config.nix.settings.trusted-public-keys' --apply 'builtins.concatStringsSep " "')"
	-$(NOTIFY) 'NixOS: make switch finished'

switch-hm: fmt check
	git diff --exit-code
	primary_user="$$(nix eval --raw ".#nixosConfigurations.$(HOST).config.users.primaryUser")"; \
		activation="$$(nix build --no-link --print-out-paths ".#nixosConfigurations.$(HOST).config.home-manager.users.$$primary_user.home.activationPackage")"; \
		"$$activation/activate"

# Fast iteration: activate only the Home Manager generation. No fmt, no
# flake check, and no clean-tree requirement; use switch-hm to deploy.
switch-hm-fast:
	primary_user="$$(nix eval --raw ".#nixosConfigurations.$(HOST).config.users.primaryUser")"; \
		activation="$$(nix build --no-link --print-out-paths ".#nixosConfigurations.$(HOST).config.home-manager.users.$$primary_user.home.activationPackage")"; \
		"$$activation/activate"

boot: fmt check
	git diff --exit-code
	sudo -S nixos-rebuild boot --flake $(FLAKE) --verbose --show-trace
	-$(NOTIFY) 'NixOS: make boot finished'
