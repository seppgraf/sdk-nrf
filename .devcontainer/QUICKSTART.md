# Quick Start Guide - Development Container

This is a quick reference for using the nRF Connect SDK development container.

## Starting the Container

### GitHub Codespaces (Recommended)
1. Go to the repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace**
3. Wait for the container to build (10-15 minutes first time)
4. Start developing!

### VS Code Local
1. Install Docker Desktop and VS Code
2. Install the "Dev Containers" extension
3. Open repository in VS Code
4. Click "Reopen in Container" when prompted
5. Wait for the container to build

## Building an Application

```bash
# Build an example application
west build -b nrf52840dk/nrf52840 samples/basic/blinky

# Clean build
west build -b nrf52840dk/nrf52840 samples/basic/blinky --pristine
```

## Building Documentation

```bash
# Configure documentation build
cmake -B build -S doc

# Build all documentation
cmake --build build

# View documentation
python3 -m http.server 8000 -d build/html/
# Open http://localhost:8000 in browser
```

## Updating Dependencies

```bash
# Update all west projects
west update

# Update with shallow clone (faster)
west update --narrow -o=--depth=1
```

## Troubleshooting

### Toolchain Not Found
```bash
TOOLCHAIN_ID=$(bash scripts/print_toolchain_checksum.sh)
nrfutil toolchain-manager install --toolchain-bundle-id $TOOLCHAIN_ID
```

### Git Trust Issues
```bash
git config --global --add safe.directory '*'
```

### West Update Fails
```bash
west update --narrow -o=--depth=1
```

## More Information

See [.devcontainer/README.md](.devcontainer/README.md) for complete documentation.
