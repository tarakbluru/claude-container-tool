#!/bin/bash
# Configure GitHub MCP server on container startup

echo "Setting up GitHub MCP server..."

if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub MCP server..."
    
    # Add GitHub MCP server using official Docker image (stdio mode)
    claude mcp add github -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" ghcr.io/github/github-mcp-server
    
    echo "GitHub MCP server configured successfully"
    echo "GitHub repositories are now accessible through Claude"
else
    echo "Warning: GITHUB_TOKEN not set"
    echo "GitHub MCP server will not be available"
    echo "Set GITHUB_TOKEN in your .env file to enable GitHub access"
fi

echo "MCP setup complete"