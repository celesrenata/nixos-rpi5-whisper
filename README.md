# Goblin Cluster NixOS Configuration

Unified NixOS flake configuration for the goblin-1, goblin-2, and goblin-3 Raspberry Pi 5 cluster.

## Structure

```
.
├── flake.nix                    # Main flake configuration
├── modules/                     # Shared modules
│   ├── common.nix              # Common configuration for all hosts
│   ├── graphics.nix            # Graphics/GPU configuration
│   ├── remote-build.nix        # Distributed build configuration
│   ├── whisper.nix             # Wyoming/Whisper voice services
│   ├── dns.nix                 # Avahi/mDNS configuration
│   ├── home.crt                # Shared certificate
│   └── secrets.toml            # SOPS secrets (not in git)
└── hosts/                       # Host-specific configurations
    ├── goblin-1/
    │   └── hardware-configuration.nix
    ├── goblin-2/
    │   └── hardware-configuration.nix
    └── goblin-3/
        └── hardware-configuration.nix
```

## Installation

### Initial Setup

1. Clone this repository:
   ```bash
   git clone <repo-url> /etc/nixos-flake
   cd /etc/nixos-flake
   ```

2. Copy your host's age key:
   ```bash
   cp /etc/nixos/.age-key.txt modules/
   ```

3. Build and switch for your host:
   ```bash
   sudo nixos-rebuild switch --flake .#goblin-1  # or goblin-2, goblin-3
   ```

### Updating Configuration

1. Make changes to the configuration
2. Commit and push to git
3. On each host, pull and rebuild:
   ```bash
   cd /etc/nixos-flake
   git pull
   sudo nixos-rebuild switch --flake .#$(hostname)
   ```

## Notes

- Each host has its own hardware-configuration.nix with unique UUIDs
- The flake automatically sets the hostname based on the configuration name
- Secrets are managed with SOPS and require the .age-key.txt file
- All hosts share the same base configuration but can be customized per-host if needed
