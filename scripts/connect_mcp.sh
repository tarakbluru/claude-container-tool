#!/bin/bash
# Configure GitHub MCP server on container startup

echo "Setting up GitHub MCP server..."

if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub MCP server..."
    
    # Ensure claude command is available and MCP config directory exists
    mkdir -p /root/.config/claude
    
    # Add GitHub MCP server using official Docker image (stdio mode)
    if command -v claude &> /dev/null; then
        claude mcp add github -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" ghcr.io/github/github-mcp-server
        echo "GitHub MCP server configured successfully"
        echo "GitHub repositories are now accessible through Claude"
    else
        echo "Warning: Claude command not found, trying alternative MCP configuration..."
        
        # Alternative: Create MCP config manually if claude command isn't available
        cat > /root/.config/claude/claude_desktop_config.json << EOF
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ]
    }
  }
}
EOF
        echo "GitHub MCP server configured manually"
    fi
else
    echo "Warning: GITHUB_TOKEN not set"
    echo "GitHub MCP server will not be available"
    echo "Set GITHUB_TOKEN in your .env file to enable GitHub access"
fi

echo "MCP setup complete"