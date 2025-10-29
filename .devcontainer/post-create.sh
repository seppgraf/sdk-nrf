#!/bin/bash
# Post-create script for nRF Connect SDK devcontainer
# This script runs after the container is created to set up the development environment

set -e

echo "🚀 Starting nRF Connect SDK devcontainer post-create setup..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the workspace folder
WORKSPACE_DIR="${1:-/workspaces/sdk-nrf}"
cd "$WORKSPACE_DIR"

echo -e "${BLUE}📦 Installing Python documentation requirements...${NC}"
if [ -f "$WORKSPACE_DIR/doc/requirements.txt" ]; then
    pip3 install --user --no-cache-dir -r "$WORKSPACE_DIR/doc/requirements.txt"
    echo -e "${GREEN}✓ Documentation requirements installed${NC}"
else
    echo "Warning: doc/requirements.txt not found"
fi

echo -e "${BLUE}📦 Installing Python base requirements...${NC}"
if [ -f "$WORKSPACE_DIR/scripts/requirements-base.txt" ]; then
    pip3 install --user --no-cache-dir -r "$WORKSPACE_DIR/scripts/requirements-base.txt"
    echo -e "${GREEN}✓ Base requirements installed${NC}"
else
    echo "Warning: scripts/requirements-base.txt not found"
fi

echo -e "${BLUE}📦 Installing Python build requirements...${NC}"
if [ -f "$WORKSPACE_DIR/scripts/requirements-build.txt" ]; then
    pip3 install --user --no-cache-dir -r "$WORKSPACE_DIR/scripts/requirements-build.txt"
    echo -e "${GREEN}✓ Build requirements installed${NC}"
else
    echo "Warning: scripts/requirements-build.txt not found"
fi

# Install nRF SDK toolchain if not already installed
echo -e "${BLUE}🔧 Checking nRF SDK toolchain...${NC}"
if [ -f "$WORKSPACE_DIR/scripts/print_toolchain_checksum.sh" ]; then
    TOOLCHAIN_ID=$(bash "$WORKSPACE_DIR/scripts/print_toolchain_checksum.sh")
    echo "Detected toolchain ID: $TOOLCHAIN_ID"
    
    # Check if toolchain is already installed
    if nrfutil toolchain-manager list 2>/dev/null | grep -q "$TOOLCHAIN_ID"; then
        echo -e "${GREEN}✓ Toolchain $TOOLCHAIN_ID already installed${NC}"
    else
        echo -e "${BLUE}Installing toolchain bundle $TOOLCHAIN_ID (this may take several minutes)...${NC}"
        nrfutil toolchain-manager install --toolchain-bundle-id "$TOOLCHAIN_ID" || {
            echo "Warning: Toolchain installation failed. You may need to install it manually."
        }
    fi
    
    # Set up toolchain environment
    nrfutil toolchain-manager env --as-script > /tmp/toolchain-env.sh || true
    if [ -f /tmp/toolchain-env.sh ]; then
        echo "source /tmp/toolchain-env.sh" >> ~/.bashrc
        echo -e "${GREEN}✓ Toolchain environment configured${NC}"
    fi
else
    echo "Warning: scripts/print_toolchain_checksum.sh not found"
fi

# Initialize west if in a workspace with west.yml
echo -e "${BLUE}🌍 Initializing west workspace...${NC}"
if [ -f "$WORKSPACE_DIR/west.yml" ]; then
    # Mark the directory as safe for git
    git config --global --add safe.directory '*'
    
    # Initialize west if not already initialized
    if [ ! -f "$WORKSPACE_DIR/../.west/config" ]; then
        echo "Initializing west workspace..."
        cd "$WORKSPACE_DIR/.."
        west init -l "$WORKSPACE_DIR" || echo "West already initialized"
        
        echo -e "${BLUE}📥 Updating west projects (this may take a while)...${NC}"
        west update --narrow -o=--depth=1 || echo "Warning: West update failed. You may need to run 'west update' manually."
        
        cd "$WORKSPACE_DIR"
        echo -e "${GREEN}✓ West workspace initialized${NC}"
    else
        echo -e "${GREEN}✓ West workspace already initialized${NC}"
        # Still try to update
        cd "$WORKSPACE_DIR/.."
        echo -e "${BLUE}📥 Updating west projects...${NC}"
        west update --narrow -o=--depth=1 || echo "Warning: West update failed."
        cd "$WORKSPACE_DIR"
    fi
else
    echo "Warning: west.yml not found in workspace root"
fi

# Install JLink if license accepted
if [ "${ACCEPT_JLINK_LICENSE}" = "1" ]; then
    echo -e "${BLUE}📦 Installing J-Link...${NC}"
    if [ -f /jlink/install.sh ]; then
        sudo bash /jlink/install.sh 2>/dev/null || echo "Warning: J-Link installation failed"
        echo -e "${GREEN}✓ J-Link installation attempted${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✨ nRF Connect SDK devcontainer setup complete!${NC}"
echo ""
echo "📚 Quick Start:"
echo "  • Build documentation: cmake -B build -S doc && cmake --build build"
echo "  • Build an application: west build -b nrf52840dk/nrf52840 samples/hello_world"
echo "  • Flash to device: west flash"
echo "  • Update dependencies: west update"
echo ""
echo "🔗 Useful commands:"
echo "  • west --help          - Show west command help"
echo "  • nrfutil --help       - Show nrfutil command help"
echo "  • cmake --help         - Show CMake help"
echo ""
echo "Happy coding! 🎉"
