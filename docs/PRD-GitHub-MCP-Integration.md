# Product Requirements Document: GitHub MCP Server Integration

## 1. Overview

This document outlines the integration of GitHub MCP (Model Context Protocol) server into the Claude Container Tool to enable seamless access to both public and private GitHub repositories from within the containerized environment.

### Purpose
Enable Claude Code running in a Podman/Docker container to interact with GitHub repositories using the MCP protocol, providing read/write access to code, issues, pull requests, and other GitHub resources.

### Scope
- Integration of GitHub MCP server into the existing Claude Container Tool
- Token-based authentication for accessing private repositories
- Simple configuration through environment variables

## 2. Requirements

### Functional Requirements
1. **Repository Access**
   - Read access to public repositories
   - Read/write access to private repositories (with appropriate token permissions)
   - Clone, fetch, and pull operations
   - File browsing and content retrieval

2. **GitHub API Operations**
   - Create, read, update issues
   - Create, review, merge pull requests
   - Access repository metadata
   - Search repositories and code

3. **Authentication**
   - Support for GitHub Personal Access Token (PAT)
   - Secure token storage via environment variables
   - Token validation at startup

### Non-Functional Requirements
1. **Security**
   - No token exposure in logs or console output
   - Secure token transmission to container
   - Minimal required token scopes

2. **Performance**
   - Quick startup time
   - Efficient API usage (respecting rate limits)
   - Caching where appropriate

3. **Usability**
   - Simple configuration process
   - Clear error messages
   - Automatic MCP server registration

## 3. Technical Implementation

### 3.1 Container Modifications

#### Dockerfile Updates
```dockerfile
# Add to existing Dockerfile
RUN npm install -g @modelcontextprotocol/server-github

# Create MCP configuration directory
RUN mkdir -p /root/.config/claude

# Add MCP server startup script
COPY scripts/setup-mcp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-mcp.sh
```

#### Docker Compose Updates
```yaml
# Add to docker-compose.yml
environment:
  - GITHUB_TOKEN=${GITHUB_TOKEN}
  - GIT_USERNAME=${GIT_USERNAME}
  - GIT_EMAIL=${GIT_EMAIL}
```

### 3.2 MCP Configuration

#### Server Configuration Structure
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### 3.3 Setup Script (`setup-mcp.sh`)
```bash
#!/bin/bash
# Configure GitHub MCP server on container startup

if [ -n "$GITHUB_TOKEN" ]; then
    # Create MCP configuration
    cat > /root/.config/claude/claude.json << EOF
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "$GITHUB_TOKEN"
      }
    }
  }
}
EOF
    echo "GitHub MCP server configured successfully"
else
    echo "Warning: GITHUB_TOKEN not set, GitHub MCP server will not be available"
fi
```

## 4. User Guide

### 4.1 Setup Instructions

1. **Create GitHub Personal Access Token**
   - Go to GitHub Settings > Developer settings > Personal access tokens
   - Create a new token with these scopes:
     - `repo` (full control of private repositories)
     - `read:org` (read org and team membership)
     - `workflow` (if you need to access GitHub Actions)

2. **Configure Environment**
   ```bash
   # Update .env file
   GITHUB_TOKEN=ghp_your_token_here
   ```

3. **Start Container**
   ```powershell
   ./start-claude.ps1
   ```

### 4.2 Usage Examples

Once configured, Claude Code can:

```bash
# Access repository information
claude> "Show me the README from github:username/repository"

# Browse private repositories
claude> "List my private repositories"

# Create issues
claude> "Create an issue in myrepo with title 'Bug: X not working'"

# Work with pull requests
claude> "Show open PRs in organization/project"
```

## 5. Security Considerations

### 5.1 Token Management
- Store GitHub token in `.env` file (already gitignored)
- Never commit tokens to version control
- Use minimal required scopes for tokens
- Rotate tokens periodically

### 5.2 Container Security
- Token is passed as environment variable (not in build args)
- No token logging in startup scripts
- MCP server runs with container user permissions

## 6. Testing & Validation

### 6.1 Verification Steps
1. Container starts without errors
2. MCP server registers successfully
3. Can access public repositories
4. Can access private repositories with valid token
5. Error handling for invalid/missing tokens

### 6.2 Test Commands
```bash
# Inside container
claude mcp list  # Should show github server
claude> "List repositories for github:octocat"  # Test public access
claude> "Show my private repositories"  # Test private access
```

## 7. Future Enhancements

1. **Multiple Token Support**: Support for different tokens per organization
2. **Token Refresh**: Automatic token refresh for OAuth apps
3. **Caching Layer**: Local caching of frequently accessed repositories
4. **GitLab/Bitbucket**: Support for other Git platforms

## 8. Appendix

### Required Token Scopes
- `repo`: Full control of private repositories
- `read:org`: Read-only access to organization membership
- `read:user`: Read-only access to user profile data
- `workflow`: Update GitHub Action workflows (optional)

### Error Codes
- `MCP001`: GitHub token not provided
- `MCP002`: Invalid GitHub token
- `MCP003`: Insufficient token permissions
- `MCP004`: MCP server startup failed

### References
- [Model Context Protocol Documentation](https://modelcontextprotocol.io)
- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)