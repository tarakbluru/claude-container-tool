#!/bin/bash
# Container entrypoint script

# Initialize SuperClaude if not already done
if [ ! -d "/root/.claude" ] || [ ! -f "/root/.claude/.initialized" ]; then
    echo "============================================"
    echo "Initializing SuperClaude framework..."
    echo "============================================"
    
    # SuperClaude is already installed via git clone and install.sh in the Dockerfile
    # Just run any post-install configuration if needed
    if command -v superclaude &> /dev/null; then
        # Create expect script for automated configuration if needed
        cat > /tmp/configure_superclaude.exp << 'EOF'
#!/usr/bin/expect -f
set timeout 60

# Run SuperClaude configuration if it has interactive setup
spawn superclaude --configure

# Handle any interactive prompts
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
        
        chmod +x /tmp/configure_superclaude.exp
        # Try configuration, but don't fail if SuperClaude doesn't need interactive setup
        /tmp/configure_superclaude.exp 2>/dev/null || true
        
        touch /root/.claude/.initialized
        echo "✓ SuperClaude framework ready!"
        rm -f /tmp/configure_superclaude.exp
    else
        echo "⚠ SuperClaude command not found, but continuing..."
        touch /root/.claude/.initialized
    fi
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