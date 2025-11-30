#!/bin/bash
# Neople Protocol Handler Setup Script for Linux
# This script sets up neople:// URL handler for DNF game launcher

set -e

echo "=== Neople Protocol Handler Setup ==="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Wine is installed
if ! command -v wine &> /dev/null; then
    echo -e "${RED}ERROR: Wine is not installed.${NC}"
    echo "Please install Wine first: sudo pacman -S wine"
    exit 1
fi

# Check if NeopleCustomURLStarter.exe exists
NEOPLE_STARTER="$HOME/.wine/drive_c/Program Files (x86)/NeoplePlugin/NeopleCustomURLStarter.exe"
if [ ! -f "$NEOPLE_STARTER" ]; then
    echo -e "${YELLOW}WARNING: NeopleCustomURLStarter.exe not found at:${NC}"
    echo "  $NEOPLE_STARTER"
    echo ""
    echo "Please make sure DNF/Neople plugin is installed in Wine."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create directories if they don't exist
echo "Creating directories..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"

# Create the handler script
echo "Creating neople-handler.sh..."
cat > "$HOME/.local/bin/neople-handler.sh" << 'EOF'
#!/bin/bash
# Neople Protocol Handler for Linux
# Handles neople:// URLs to launch DNF through Wine

URL="$1"

# Log for debugging
echo "[$(date)] Received URL: $URL" >> /tmp/neople-handler.log

# Check if URL starts with neople://
if [[ "$URL" == neople://* ]]; then
    # Wine path to NeopleCustomURLStarter.exe
    NEOPLE_STARTER="$HOME/.wine/drive_c/Program Files (x86)/NeoplePlugin/NeopleCustomURLStarter.exe"

    if [ -f "$NEOPLE_STARTER" ]; then
        echo "[$(date)] Launching with Wine: $NEOPLE_STARTER" >> /tmp/neople-handler.log
        # Launch the Neople starter with the full URL
        wine "$NEOPLE_STARTER" "$URL" &>> /tmp/neople-handler.log &
    else
        echo "[$(date)] ERROR: NeopleCustomURLStarter.exe not found" >> /tmp/neople-handler.log
        notify-send "Neople Handler Error" "NeopleCustomURLStarter.exe not found"
    fi
else
    echo "[$(date)] ERROR: Invalid URL format" >> /tmp/neople-handler.log
fi
EOF

# Make handler script executable
chmod +x "$HOME/.local/bin/neople-handler.sh"
echo -e "${GREEN}✓${NC} Created handler script"

# Create .desktop file
echo "Creating neople-handler.desktop..."
cat > "$HOME/.local/share/applications/neople-handler.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Neople Protocol Handler
Comment=Handle neople:// URLs for DNF game launcher
Exec=$HOME/.local/bin/neople-handler.sh %u
Icon=applications-games
Terminal=false
MimeType=x-scheme-handler/neople;
Categories=Game;
NoDisplay=true
EOF

echo -e "${GREEN}✓${NC} Created .desktop file"

# Update desktop database
echo "Updating desktop database..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications"
    echo -e "${GREEN}✓${NC} Updated desktop database"
else
    echo -e "${YELLOW}WARNING: update-desktop-database not found, skipping...${NC}"
fi

# Register protocol handler
echo "Registering neople:// protocol handler..."
xdg-mime default neople-handler.desktop x-scheme-handler/neople

# Verify registration
REGISTERED=$(xdg-mime query default x-scheme-handler/neople)
if [ "$REGISTERED" = "neople-handler.desktop" ]; then
    echo -e "${GREEN}✓${NC} Protocol handler registered successfully"
else
    echo -e "${RED}ERROR: Failed to register protocol handler${NC}"
    exit 1
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "The neople:// protocol handler has been configured."
echo ""
echo "Usage:"
echo "  - Click neople:// links in your browser"
echo "  - Or run: xdg-open 'neople://dnfreal?...'"
echo ""
echo "Logs will be saved to: /tmp/neople-handler.log"
echo ""
echo -e "${GREEN}You can now launch DNF from web browsers!${NC}"
