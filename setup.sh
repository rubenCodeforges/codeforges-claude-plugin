#!/bin/bash

# cf-dev-toolkit Web Performance Tools Setup
# Automated installation script for Lighthouse, Puppeteer, and dependencies

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis
ROCKET="🚀"
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
PACKAGE="📦"
WRENCH="🔧"
SPARKLES="✨"

echo -e "${BLUE}${ROCKET} cf-dev-toolkit Web Performance Tools Setup${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Detect platform
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM="Linux";;
    Darwin*)    PLATFORM="macOS";;
    CYGWIN*|MINGW*|MSYS*) PLATFORM="Windows";;
    *)          PLATFORM="Unknown";;
esac

echo -e "${INFO} Platform detected: ${PLATFORM}\n"

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check npm package
npm_package_exists() {
    npm list -g "$1" &> /dev/null
}

# Check Node.js
echo -e "${WRENCH} Checking prerequisites..."
echo ""

if ! command_exists node; then
    echo -e "${CROSS} Node.js not found\n"
    echo -e "Please install Node.js 18+ first:"
    echo ""
    case "${PLATFORM}" in
        macOS)
            echo "  Using Homebrew:"
            echo "    brew install node"
            echo ""
            echo "  Or download from: https://nodejs.org"
            ;;
        Linux)
            echo "  Ubuntu/Debian:"
            echo "    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
            echo "    sudo apt-get install -y nodejs"
            echo ""
            echo "  Fedora/RHEL:"
            echo "    curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -"
            echo "    sudo dnf install -y nodejs"
            ;;
        Windows)
            echo "  Download from: https://nodejs.org"
            echo "  Or use winget: winget install OpenJS.NodeJS"
            ;;
    esac
    exit 1
else
    NODE_VERSION=$(node -v)
    echo -e "${CHECK} Node.js ${NODE_VERSION} found"
fi

# Check npm
if ! command_exists npm; then
    echo -e "${CROSS} npm not found (should come with Node.js)"
    exit 1
else
    NPM_VERSION=$(npm -v)
    echo -e "${CHECK} npm ${NPM_VERSION} found"
fi

echo ""

# Check current installation status
echo -e "${WRENCH} Checking current installation status..."
echo ""

LIGHTHOUSE_INSTALLED=false
PUPPETEER_INSTALLED=false

if command_exists lighthouse; then
    LIGHTHOUSE_VERSION=$(lighthouse --version 2>&1)
    echo -e "${CHECK} Lighthouse already installed: ${LIGHTHOUSE_VERSION}"
    LIGHTHOUSE_INSTALLED=true
else
    echo -e "${CROSS} Lighthouse not installed"
fi

if npm_package_exists puppeteer; then
    PUPPETEER_VERSION=$(npm list -g puppeteer 2>&1 | grep puppeteer@ | head -n1 || echo "installed")
    echo -e "${CHECK} Puppeteer already installed"
    PUPPETEER_INSTALLED=true
else
    echo -e "${CROSS} Puppeteer not installed"
fi

echo ""

# If everything is already installed
if [ "$LIGHTHOUSE_INSTALLED" = true ] && [ "$PUPPETEER_INSTALLED" = true ]; then
    echo -e "${SPARKLES} All tools are already installed!"
    echo ""
    echo "You're ready to use the web-performance-agent."
    echo ""
    read -p "Would you like to reinstall/update? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup complete. No changes made."
        exit 0
    fi
    echo ""
fi

# Install system dependencies for Puppeteer (Linux only)
if [ "$PLATFORM" = "Linux" ]; then
    echo -e "${PACKAGE} Checking system dependencies for Puppeteer..."
    echo ""

    if command_exists apt-get; then
        echo "Ubuntu/Debian detected. System dependencies may be required for Puppeteer."
        read -p "Install system dependencies? (recommended) (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing system dependencies..."
            sudo apt-get update
            sudo apt-get install -y \
                libnss3 \
                libxss1 \
                libasound2 \
                libatk-bridge2.0-0 \
                libgtk-3-0 \
                libgbm1 \
                libnspr4 \
                libnss3 \
                libx11-xcb1 \
                libxcomposite1 \
                libxcursor1 \
                libxdamage1 \
                libxrandr2 \
                ca-certificates \
                fonts-liberation
            echo -e "${CHECK} System dependencies installed"
        fi
    fi
    echo ""
fi

# Offer installation choices
echo -e "${WRENCH} Choose installation method:"
echo ""
echo "  1) ${GREEN}Global${NC} (Recommended for frequent use)"
echo "     - Fastest performance"
echo "     - Available system-wide"
echo "     - Requires npm global permissions"
echo ""
echo "  2) ${BLUE}Plugin-local${NC} (Isolated installation)"
echo "     - Isolated to this plugin"
echo "     - Slightly slower startup"
echo "     - No global permissions needed"
echo ""
echo "  3) ${YELLOW}Use npx only${NC} (No installation)"
echo "     - No installation needed"
echo "     - Downloads on each first use"
echo "     - Slowest option"
echo ""
read -p "Enter choice [1-3] (default: 1): " choice
choice=${choice:-1}

echo ""

case $choice in
    1)
        echo -e "${PACKAGE} Installing globally..."
        echo ""

        # Check if we need sudo (Linux/macOS with system npm)
        NPM_PREFIX=$(npm config get prefix)
        NEED_SUDO=false

        if [ "$PLATFORM" != "Windows" ] && [[ "$NPM_PREFIX" == "/usr"* ]]; then
            echo -e "${INFO} Global npm location requires sudo"
            NEED_SUDO=true
        fi

        # Install Lighthouse
        if [ "$NEED_SUDO" = true ]; then
            echo "Installing Lighthouse (may require password)..."
            sudo npm install -g lighthouse
        else
            echo "Installing Lighthouse..."
            npm install -g lighthouse
        fi
        echo -e "${CHECK} Lighthouse installed"

        # Install Puppeteer
        if [ "$NEED_SUDO" = true ]; then
            echo "Installing Puppeteer (may require password)..."
            sudo npm install -g puppeteer
        else
            echo "Installing Puppeteer..."
            npm install -g puppeteer
        fi
        echo -e "${CHECK} Puppeteer installed"

        echo ""
        echo -e "${SPARKLES} Global installation complete!"
        ;;

    2)
        echo -e "${PACKAGE} Installing in plugin directory..."
        echo ""

        # Create package.json if it doesn't exist
        if [ ! -f "package.json" ]; then
            cat > package.json << 'EOF'
{
  "name": "cf-dev-toolkit-web-perf",
  "version": "1.0.0",
  "description": "Web performance analysis dependencies for cf-dev-toolkit",
  "private": true,
  "dependencies": {
    "lighthouse": "^11.0.0",
    "puppeteer": "^21.0.0",
    "chrome-launcher": "^1.0.0"
  }
}
EOF
            echo -e "${CHECK} Created package.json"
        fi

        # Install dependencies
        echo "Installing dependencies..."
        npm install

        echo ""
        echo -e "${SPARKLES} Plugin-local installation complete!"
        echo -e "${INFO} Dependencies installed in: $(pwd)/node_modules"
        ;;

    3)
        echo -e "${INFO} No installation needed for npx mode"
        echo ""

        # Create config file to remember preference
        mkdir -p ~/.config/cf-dev-toolkit
        echo "USE_NPX=true" > ~/.config/cf-dev-toolkit/web-perf.conf

        echo -e "${CHECK} Configuration saved"
        echo ""
        echo "The web-performance-agent will use 'npx lighthouse' automatically."
        echo "First run will download Lighthouse (~50MB), then it's cached."
        ;;

    *)
        echo -e "${CROSS} Invalid choice"
        exit 1
        ;;
esac

# Test installation
echo ""
echo -e "${WRENCH} Testing installation..."
echo ""

case $choice in
    1)
        # Test global installation
        if command_exists lighthouse; then
            VERSION=$(lighthouse --version 2>&1)
            echo -e "${CHECK} Lighthouse test: ${VERSION}"
        else
            echo -e "${CROSS} Lighthouse test failed"
        fi
        ;;

    2)
        # Test local installation
        if [ -f "node_modules/.bin/lighthouse" ]; then
            VERSION=$(./node_modules/.bin/lighthouse --version 2>&1)
            echo -e "${CHECK} Lighthouse test: ${VERSION}"
        else
            echo -e "${CROSS} Lighthouse test failed"
        fi
        ;;

    3)
        # Test npx
        echo "Testing npx (this may take a moment on first run)..."
        if npx -y lighthouse --version &> /dev/null; then
            echo -e "${CHECK} npx lighthouse test passed"
        else
            echo -e "${CROSS} npx test failed - check internet connection"
        fi
        ;;
esac

# Final success message
echo ""
echo -e "${GREEN}${SPARKLES}============================================${NC}"
echo -e "${GREEN}${SPARKLES}  Setup Complete!${NC}"
echo -e "${GREEN}${SPARKLES}============================================${NC}"
echo ""
echo "You can now use the web-performance-agent!"
echo ""
echo "Example usage:"
echo "  Ask: \"Analyze the performance of https://example.com\""
echo "  Command: /analyze-performance https://example.com"
echo ""
echo "Check your setup anytime with:"
echo "  /check-web-perf"
echo ""
echo "For troubleshooting, see:"
echo "  ~/.claude/plugins/cf-dev-toolkit/README.md"
echo ""

# Offer to run test analysis
read -p "Would you like to run a test analysis now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    TEST_URL="https://example.com"
    echo -e "${WRENCH} Running test analysis on ${TEST_URL}..."
    echo ""

    case $choice in
        1)
            lighthouse "$TEST_URL" --output=json --quiet --only-categories=performance --chrome-flags="--headless --no-sandbox"
            ;;
        2)
            ./node_modules/.bin/lighthouse "$TEST_URL" --output=json --quiet --only-categories=performance --chrome-flags="--headless --no-sandbox"
            ;;
        3)
            npx -y lighthouse "$TEST_URL" --output=json --quiet --only-categories=performance --chrome-flags="--headless --no-sandbox"
            ;;
    esac

    echo ""
    echo -e "${CHECK} Test analysis complete!"
fi

echo ""
echo "Happy performance optimization! 🚀"
