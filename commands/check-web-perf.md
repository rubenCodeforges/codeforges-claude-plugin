---
name: check-web-perf
description: Diagnostic command to check web performance toolkit setup and dependencies
---

Run a comprehensive diagnostic check of the web performance toolkit setup, including Lighthouse, Puppeteer, Node.js, and system dependencies.

**Execute the following diagnostic script:**

```bash
#!/bin/bash

echo "🔍 Web Performance Toolkit Diagnostic Check"
echo "==========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check command function
check_command() {
    local cmd=$1
    local install_hint=$2

    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -n1)
        echo -e "${GREEN}✅ $cmd:${NC} $version"
        return 0
    else
        echo -e "${RED}❌ $cmd:${NC} not found"
        if [ -n "$install_hint" ]; then
            echo -e "   ${YELLOW}Install:${NC} $install_hint"
        fi
        return 1
    fi
}

# Check npm package
check_npm_package() {
    local package=$1
    local install_hint=$2

    if npm list -g "$package" &> /dev/null; then
        local version=$(npm list -g "$package" 2>&1 | grep "$package@" | head -n1 | sed 's/.*@//' | sed 's/ .*//')
        echo -e "${GREEN}✅ $package:${NC} $version (global)"
        return 0
    elif [ -f "$(pwd)/node_modules/.bin/$package" ] || [ -d "$(pwd)/node_modules/$package" ]; then
        echo -e "${GREEN}✅ $package:${NC} installed (plugin-local)"
        return 0
    else
        echo -e "${RED}❌ $package:${NC} not found"
        if [ -n "$install_hint" ]; then
            echo -e "   ${YELLOW}Install:${NC} $install_hint"
        fi
        return 1
    fi
}

# System information
echo "📊 System Information"
echo "-------------------"
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM="Linux";;
    Darwin*)    PLATFORM="macOS";;
    CYGWIN*|MINGW*|MSYS*) PLATFORM="Windows";;
    *)          PLATFORM="Unknown";;
esac
echo "Platform: $PLATFORM"
echo "Architecture: $(uname -m)"
echo ""

# Core dependencies
echo "🛠️  Core Dependencies"
echo "-------------------"
check_command "node" "https://nodejs.org"
check_command "npm" "Comes with Node.js"
echo ""

# Web performance tools
echo "🚀 Web Performance Tools"
echo "----------------------"
check_command "lighthouse" "npm install -g lighthouse"
check_npm_package "puppeteer" "npm install -g puppeteer"
echo ""

# Chromium/Chrome check
echo "🌐 Browser Engines"
echo "----------------"

CHROMIUM_FOUND=false

# Check for Puppeteer's Chromium
if [ -d "$HOME/.cache/puppeteer" ]; then
    echo -e "${GREEN}✅ Puppeteer Chromium:${NC} found in ~/.cache/puppeteer"
    CHROMIUM_FOUND=true
elif [ -d "$(pwd)/node_modules/puppeteer/.local-chromium" ]; then
    echo -e "${GREEN}✅ Puppeteer Chromium:${NC} found in plugin directory"
    CHROMIUM_FOUND=true
fi

# Check for system Chrome/Chromium
if command -v google-chrome &> /dev/null; then
    echo -e "${GREEN}✅ Google Chrome:${NC} $(google-chrome --version)"
    CHROMIUM_FOUND=true
elif command -v chromium &> /dev/null; then
    echo -e "${GREEN}✅ Chromium:${NC} $(chromium --version)"
    CHROMIUM_FOUND=true
elif command -v chromium-browser &> /dev/null; then
    echo -e "${GREEN}✅ Chromium:${NC} $(chromium-browser --version)"
    CHROMIUM_FOUND=true
fi

if [ "$CHROMIUM_FOUND" = false ]; then
    echo -e "${YELLOW}⚠️  Chromium:${NC} not found"
    echo "   Will be downloaded automatically on first Puppeteer use (~170MB)"
fi

echo ""

# System libraries (Linux only)
if [ "$PLATFORM" = "Linux" ]; then
    echo "📦 System Libraries (Linux)"
    echo "-------------------------"

    check_lib() {
        if ldconfig -p 2>/dev/null | grep -q "$1"; then
            echo -e "${GREEN}✅ $1${NC}"
        else
            echo -e "${RED}❌ $1${NC}"
        fi
    }

    check_lib "libnss3"
    check_lib "libxss1"
    check_lib "libasound2"
    check_lib "libatk-bridge"

    echo ""
fi

# Configuration check
echo "⚙️  Configuration"
echo "--------------"

if [ -f "$HOME/.config/cf-dev-toolkit/web-perf.conf" ]; then
    echo -e "${GREEN}✅ Config file:${NC} found"
    cat "$HOME/.config/cf-dev-toolkit/web-perf.conf"
else
    echo -e "${YELLOW}ℹ️  Config file:${NC} not found (using defaults)"
fi

echo ""

# npx availability
echo "📦 npx Fallback"
echo "-------------"
if command -v npx &> /dev/null; then
    echo -e "${GREEN}✅ npx:${NC} available (can auto-download Lighthouse)"
else
    echo -e "${RED}❌ npx:${NC} not available"
fi

echo ""

# Network connectivity test
echo "🌐 Network Connectivity"
echo "---------------------"
if curl -s --head --max-time 5 https://registry.npmjs.org &> /dev/null; then
    echo -e "${GREEN}✅ npm registry:${NC} reachable"
else
    echo -e "${RED}❌ npm registry:${NC} unreachable"
    echo "   npx mode requires internet connectivity"
fi

echo ""

# Determine overall status
echo "📋 Summary & Recommendations"
echo "============================"
echo ""

HAS_LIGHTHOUSE=$(command -v lighthouse &> /dev/null && echo "yes" || echo "no")
HAS_NPX=$(command -v npx &> /dev/null && echo "yes" || echo "no")

if [ "$HAS_LIGHTHOUSE" = "yes" ]; then
    echo -e "${GREEN}✅ Status: Fully configured${NC}"
    echo ""
    echo "All tools are installed. You can use the web-performance-agent."
    echo ""
    echo "Example:"
    echo '  Ask: "Analyze the performance of https://example.com"'
    echo ""

elif [ "$HAS_NPX" = "yes" ]; then
    echo -e "${YELLOW}⚠️  Status: npx mode (zero-config)${NC}"
    echo ""
    echo "Lighthouse will be downloaded automatically via npx on first use."
    echo "First run may take 30-60 seconds."
    echo ""
    echo "For faster performance, install globally:"
    echo "  npm install -g lighthouse"
    echo ""
    echo "Or run the setup script:"
    echo "  cd ~/.claude/plugins/cf-dev-toolkit"
    echo "  ./setup.sh"
    echo ""

else
    echo -e "${RED}❌ Status: Missing dependencies${NC}"
    echo ""
    echo "Node.js and npm are required but not found."
    echo ""
    echo "Install Node.js 18+ from:"
    echo "  https://nodejs.org"
    echo ""
    echo "Then run the setup script:"
    echo "  cd ~/.claude/plugins/cf-dev-toolkit"
    echo "  ./setup.sh"
    echo ""
fi

# Quick fixes
echo "🔧 Quick Fixes"
echo "------------"
echo ""
echo "To install all dependencies automatically:"
echo "  cd ~/.claude/plugins/cf-dev-toolkit"
echo "  ./setup.sh"
echo ""
echo "To install manually:"
echo "  npm install -g lighthouse puppeteer"
echo ""
echo "To use without installation (slower):"
echo "  Just use the agent - it will automatically use npx"
echo ""

# Test command
echo "🧪 Test Your Setup"
echo "----------------"
echo ""
echo "Run a test analysis:"
echo '  Ask: "Analyze the performance of https://example.com"'
echo ""

# Documentation
echo "📚 Resources"
echo "----------"
echo ""
echo "Plugin documentation:"
echo "  ~/.claude/plugins/cf-dev-toolkit/README.md"
echo ""
echo "Lighthouse documentation:"
echo "  https://developer.chrome.com/docs/lighthouse"
echo ""
echo "Report issues:"
echo "  https://github.com/rubenCodeforges/codeforges-claude-plugin/issues"
echo ""

echo "==========================================="
echo "Diagnostic check complete!"
```

**Analyze the output and provide the user with:**
1. Summary of what's installed vs missing
2. Recommended next steps based on their setup
3. Quick commands to fix any issues
4. Confirmation that they're ready to use the web-performance-agent (or what's blocking them)

If the user has missing dependencies, be encouraging and explain that npx mode will work automatically as a fallback, but they can run `./setup.sh` for optimal performance.
