# nRF Connect SDK Development Container

This directory contains the configuration for a VS Code development container (devcontainer) that provides a complete development environment for the nRF Connect SDK, including all tools needed to compile the SDK and build its documentation.

## Features

The devcontainer includes:

### Development Tools
- **nRF Util** with toolchain-manager for SDK compilation
- **West** - Zephyr's meta-tool for managing repositories
- **CMake** and **Ninja** - Build system tools
- **GCC ARM toolchain** - Cross-compiler for nRF devices
- **Git** - Version control

### Documentation Tools
- **Sphinx** - Documentation generator
- **Doxygen** - API documentation generator
- **GraphViz** - Graph visualization for documentation
- **PlantUML** - UML diagram generator
- **Mscgen** - Message sequence chart generator

### Hardware Support
- **QEMU ARM** - Emulator for testing
- **J-Link** - Debugger and flasher (requires license acceptance)
- **DFU Util** - Device firmware upgrade utility

### VS Code Extensions
Pre-configured extensions for:
- C/C++ development (IntelliSense, debugging)
- CMake tools
- Python development
- reStructuredText editing for documentation
- Nordic Semiconductor DeviceTree and Kconfig support
- Git integration (GitLens)
- YAML support

## Quick Start

### Using GitHub Codespaces

1. Navigate to the repository on GitHub
2. Click the **Code** button
3. Select the **Codespaces** tab
4. Click **Create codespace on [branch]**
5. Wait for the codespace to build and start (first time may take 10-15 minutes)
6. The environment will be automatically configured

### Using VS Code Locally

1. Install [VS Code](https://code.visualstudio.com/)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
4. Clone this repository
5. Open the repository in VS Code
6. When prompted, click **Reopen in Container** (or press F1 and select "Dev Containers: Reopen in Container")
7. Wait for the container to build (first time may take 10-15 minutes)

## Building the SDK

### Build an Example Application

```bash
# Navigate to the workspace
cd /workspaces/sdk-nrf

# Build an example for nRF52840 DK
west build -b nrf52840dk/nrf52840 samples/basic/blinky

# Flash to connected device (if hardware is connected)
west flash
```

### Build Different Applications

```bash
# List available samples
ls samples/

# Build a specific sample
west build -b nrf52840dk/nrf52840 samples/bluetooth/peripheral_hids_keyboard -p

# Build with pristine option to clean before build
west build -b nrf52840dk/nrf52840 samples/hello_world --pristine
```

## Building Documentation

### Build Complete Documentation

```bash
# From the workspace root
cd /workspaces/sdk-nrf

# Configure CMake for documentation build
cmake -B build -S doc

# Build all documentation
cmake --build build

# Documentation will be in build/html/
# You can open it with: python3 -m http.server 8000 -d build/html/
```

### Build Specific Documentation Set

```bash
# Build only nRF documentation
cmake --build build --target nrf

# Build only Zephyr documentation
cmake --build build --target zephyr

# Build with live reload (if sphinx-autobuild is available)
cmake --build build --target nrf-html-watch
```

### View Built Documentation

```bash
# Start a simple HTTP server
cd build/html
python3 -m http.server 8000

# Open browser to http://localhost:8000
# Or use VS Code's port forwarding feature
```

## Environment Configuration

### Environment Variables

The devcontainer automatically sets:
- `ZEPHYR_BASE` - Points to the Zephyr RTOS directory
- `NCS_BASE` - Points to the nRF Connect SDK base directory
- `ACCEPT_JLINK_LICENSE=1` - Auto-accepts J-Link license (if you agree)
- `PATH` - Includes toolchain binaries

### Toolchain

The toolchain is automatically detected and installed based on the SDK version. The toolchain environment is sourced automatically in bash sessions.

To manually check or update the toolchain:

```bash
# List installed toolchains
nrfutil toolchain-manager list

# Install a specific toolchain
nrfutil toolchain-manager install --toolchain-bundle-id <ID>

# Update all west projects
west update
```

## Hardware Connection

If you want to flash and debug physical hardware:

1. Connect your nRF development kit via USB
2. Ensure Docker has access to USB devices (Docker Desktop: Settings → Resources → Advanced)
3. The devcontainer runs in privileged mode to access USB devices
4. Use `west flash` to flash firmware

## Tips and Tricks

### Git Configuration

If you encounter git repository trust issues:

```bash
git config --global --add safe.directory '*'
```

### West Commands

```bash
# Update all repositories
west update

# List west commands
west --help

# Show west configuration
west config

# Build with verbose output
west build -v
```

### Python Packages

Additional Python packages can be installed:

```bash
# Install a package for the current user
pip3 install --user <package-name>

# Packages are persisted in the container
```

### Cleaning Build Artifacts

```bash
# Clean build directory
rm -rf build/

# Clean west build
west build -t clean
```

## Troubleshooting

### Container Build Issues

If the container fails to build:
1. Ensure Docker has enough resources (at least 4GB RAM, 2 CPU cores)
2. Check Docker logs for specific errors
3. Try rebuilding: Press F1 → "Dev Containers: Rebuild Container"

### Toolchain Installation Fails

If the toolchain doesn't install automatically:
```bash
# Manually install the toolchain
TOOLCHAIN_ID=$(bash scripts/print_toolchain_checksum.sh)
nrfutil toolchain-manager install --toolchain-bundle-id $TOOLCHAIN_ID
```

### West Update Fails

If `west update` fails:
```bash
# Try with narrower depth
west update --narrow -o=--depth=1

# Or update specific projects
west update zephyr
```

### Documentation Build Fails

If documentation build fails:
```bash
# Install missing dependencies
pip3 install --user -r doc/requirements.txt

# Try building with verbose output
cmake --build build --verbose
```

### J-Link Issues

If J-Link isn't working:
```bash
# Check if J-Link is installed
which JLinkExe

# Manually install J-Link
sudo dpkg -i /jlink/JLink_Linux.deb

# Configure udev rules (requires privileged container)
sudo /jlink/install.sh
```

## Customization

### Adding VS Code Extensions

Edit `.devcontainer/devcontainer.json` and add extension IDs to the `extensions` array:

```json
"extensions": [
    "existing.extension",
    "new.extension-id"
]
```

### Modifying Container Configuration

- **Dockerfile**: Modify `.devcontainer/Dockerfile` to add system packages
- **devcontainer.json**: Modify to change VS Code settings, extensions, or environment variables
- **post-create.sh**: Modify to change post-creation setup steps

### Resource Limits

If you need to limit container resources, add to `devcontainer.json`:

```json
"runArgs": [
    "--privileged",
    "--memory=8g",
    "--cpus=4"
]
```

## Additional Resources

- [nRF Connect SDK Documentation](https://docs.nordicsemi.com/bundle/ncs-latest/page/nrf/index.html)
- [Zephyr Documentation](https://docs.zephyrproject.org/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [West Tool Documentation](https://docs.zephyrproject.org/latest/develop/west/index.html)

## License

This devcontainer configuration is part of the nRF Connect SDK and follows the same license terms.

Note: Using J-Link requires accepting the SEGGER license agreement. The container is configured to auto-accept if `ACCEPT_JLINK_LICENSE=1` is set.
