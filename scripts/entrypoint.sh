#!/bin/bash
# Container entrypoint script

# Configure git if credentials are provided
if [ -n "$GIT_USER_NAME" ]; then 
    git config --global user.name "$GIT_USER_NAME"
fi

if [ -n "$GIT_USER_EMAIL" ]; then 
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Mark workspace as safe directory
git config --global --add safe.directory /workspace

# Connect to MCP server
/connect_mcp.sh

echo "==================================="
echo "Claude Code + SuperClaude Ready!"
echo "==================================="
echo "Available enhancements:"
echo "• 16 specialized /sc: commands"
echo "• Smart cognitive personas"
echo "• MCP server integrations"
echo "• GitHub repository access"
echo "• Task management system"
echo "==================================="

# Execute the main command
exec "$@"