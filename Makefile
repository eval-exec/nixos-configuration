HOST ?= Mufasa
FLAKE ?= .\#$(HOST)
NIX_FILES := $(shell rg --files -g '*.nix')

# Only notify when a daemon owns org.freedesktop.Notifications: without one
# (e.g. booted to kmscon without Plasma), notify-send blocks for ~85s while
# D-Bus activation waits for plasma_waitforname to time out. Notification
# failures are non-fatal, so the target never reports an ignored error.
NOTIFY := sh -c 'busctl --user call org.freedesktop.DBus /org/freedesktop/DBus \
	org.freedesktop.DBus GetNameOwner s org.freedesktop.Notifications \
	>/dev/null 2>&1 || exit 0; notify-send "$$@" || true' sh

.PHONY: fmt check flake-update dry-build switch-os switch-hm switch-hm-fast boot

fmt:
	nixfmt $(NIX_FILES)

check:
	nix flake check --no-build

flake-update:
	nix flake update
	$(NOTIFY) 'NixOS: nix flake update finished'

dry-build: fmt check
	git diff --exit-code
	sudo -S nixos-rebuild dry-build --flake $(FLAKE) --verbose

# nh prompts for sudo itself. The cache list is still taken from this flake
# so a newly added substituter works before /etc/nix/nix.conf has it.
NIX_CACHE = \
	--option substituters "$$(nix eval --raw '.\#nixosConfigurations.$(HOST).config.nix.settings.substituters' --apply 'builtins.concatStringsSep " "')" \
	--option trusted-public-keys "$$(nix eval --raw '.\#nixosConfigurations.$(HOST).config.nix.settings.trusted-public-keys' --apply 'builtins.concatStringsSep " "')"

switch-os: fmt check
	git diff --exit-code
	nh os switch . -H $(HOST) -j 20 --cores 20 -v $(NIX_CACHE)
	$(NOTIFY) 'NixOS: make switch finished'

# Standalone Home Manager. nh writes the profile and home files, and a
# reboot does not run a system service that replaces them.
switch-hm: fmt check
	git diff --exit-code
	nh home switch . -c exec -b hm-backup -v $(NIX_CACHE)
	$(NOTIFY) 'Home Manager: make switch-hm finished'

switch-hm-fast:
	nh home switch . -c exec -b hm-backup $(NIX_CACHE)

boot: fmt check
	git diff --exit-code
	nh os boot . -H $(HOST) -v $(NIX_CACHE)
	$(NOTIFY) 'NixOS: make boot finished'
