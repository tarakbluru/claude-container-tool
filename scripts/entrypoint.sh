#!/bin/bash
# Container entrypoint script

# Initialize SuperClaude if not already done
if [ ! -d "/root/.claude" ] || [ ! -f "/root/.claude/.initialized" ]; then
    echo "============================================"
    echo "Initializing SuperClaude framework..."
    echo "============================================"
    
    # Create expect script for automated installation
    cat > /tmp/install_superclaude.exp << 'EOF'
#!/usr/bin/expect -f
set timeout 60

spawn /opt/superclaude/bin/python -m SuperClaude install

# Handle MCP server selection
expect {
    "Enter numbers separated by commas*" {
        send "7\r"
        exp_continue
    }
    "Select components*" {
        send "all\r"
        exp_continue
    }
    "Continue and update existing installation?*" {
        send "y\r"
        exp_continue
    }
    eof
}
EOF
    
    chmod +x /tmp/install_superclaude.exp
    if /tmp/install_superclaude.exp; then
        touch /root/.claude/.initialized
        echo "✓ SuperClaude framework initialized successfully!"
    else
        echo "⚠ SuperClaude initialization had issues, but continuing..."
    fi
    
    rm -f /tmp/install_superclaude.exp
fi

# Configure git if credentials are provided
if [ -n "$GIT_USER_NAME" ]; then 
    git config --global user.name "$GIT_USER_NAME"
fi

if [ -n "$GIT_USER_EMAIL" ]; then 
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Mark workspace as safe directory
git config --global --add safe.directory /workspace

# Configure GitHub CLI authentication if token is provided
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub CLI authentication..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    echo "GitHub CLI authenticated successfully"
else
    echo "Warning: GITHUB_TOKEN not set - GitHub CLI will require manual authentication"
fi

# Connect to MCP server
/connect_mcp.sh

echo "==================================="
echo "Claude Code + SuperClaude Ready!"
echo "==================================="
echo "Available enhancements:"
echo "• 16 specialized /sc: commands"
echo "• Smart cognitive personas"
echo "• MCP server integrations"
echo "• GitHub repository access (MCP + CLI)"
echo "• Complete GitHub workflow management"
echo "• Task management system"
echo "==================================="

# Execute the main command
exec "$@"