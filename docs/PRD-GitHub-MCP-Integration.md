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
# Install Docker CLI for MCP GitHub server
RUN apt-get update && apt-get install -y \
    docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Create MCP configuration directory
RUN mkdir -p /root/.config/claude

# Copy scripts
COPY scripts/connect_mcp.sh /connect_mcp.sh
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /connect_mcp.sh /entrypoint.sh
```

#### Docker Compose Updates
```yaml
# Add to docker-compose.yml
environment:
  - GITHUB_TOKEN=${GITHUB_TOKEN}
  - GIT_USER_NAME=${GIT_USER_NAME}
  - GIT_USER_EMAIL=${GIT_USER_EMAIL}
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro  # For MCP Docker containers
```

### 3.2 MCP Configuration

#### Server Configuration Method
The GitHub MCP server is configured dynamically using the official Docker image:
```bash
# Using claude mcp add command with Docker stdio mode
claude mcp add github -- docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
  ghcr.io/github/github-mcp-server
```

This approach:
- Uses the official GitHub MCP server Docker image
- Runs in stdio mode for container compatibility
- Automatically registers with Claude Code
- Requires Docker socket access

### 3.3 Setup Scripts

#### connect_mcp.sh
```bash
#!/bin/bash
# Configure GitHub MCP server on container startup

if [ -n "$GITHUB_TOKEN" ]; then
    echo "Configuring GitHub MCP server..."
    
    # Add GitHub MCP server using official Docker image (stdio mode)
    claude mcp add github -- docker run -i --rm \
      -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
      ghcr.io/github/github-mcp-server
    
    echo "GitHub MCP server configured successfully"
else
    echo "Warning: GITHUB_TOKEN not set"
    echo "GitHub MCP server will not be available"
fi
```

#### entrypoint.sh
```bash
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

# Execute the main command
exec "$@"
```

## 4. Implementation Details

### 4.1 Architecture
The implementation uses a Docker-in-Docker approach:
1. Main container runs Claude Code with SuperClaude
2. GitHub MCP server runs as a separate Docker container
3. Communication happens via stdio protocol
4. Docker socket enables container management

### 4.2 Key Changes from Original Design
1. **Docker-based MCP**: Uses official Docker image instead of npm package
2. **Dynamic Configuration**: Uses `claude mcp add` instead of static JSON config
3. **Git Integration**: Added automatic git configuration for commits
4. **SuperClaude Integration**: Includes full SuperClaude framework

## 5. User Guide

### 5.1 Setup Instructions

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
   GIT_USER_NAME="Your Name"
   GIT_USER_EMAIL="your.email@example.com"
   ```

3. **Start Container**
   ```powershell
   ./start-claude.ps1
   ```

### 5.2 Usage Examples

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

## 6. Security Considerations

### 6.1 Token Management
- Store GitHub token in `.env` file (already gitignored)
- Never commit tokens to version control
- Use minimal required scopes for tokens
- Rotate tokens periodically

### 6.2 Container Security
- Token is passed as environment variable (not in build args)
- No token logging in startup scripts
- MCP server runs in separate container with limited permissions
- Docker socket is mounted read-only for security

## 7. Testing & Validation

### 7.1 Verification Steps
1. Container starts without errors
2. MCP server registers successfully
3. Can access public repositories
4. Can access private repositories with valid token
5. Error handling for invalid/missing tokens

### 7.2 Test Commands
```bash
# Inside container
claude mcp list  # Should show github server

# Test GitHub access through Claude Code
claude "List my GitHub repositories"
claude "Show recent pull requests in my repositories"
claude "Create an issue in owner/repo"
```

## 8. Future Enhancements

1. **Multiple Token Support**: Support for different tokens per organization
2. **Token Refresh**: Automatic token refresh for OAuth apps
3. **Caching Layer**: Local caching of frequently accessed repositories
4. **GitLab/Bitbucket**: Support for other Git platforms

## 9. Appendix

### Required Token Scopes
- `repo`: Full control of private repositories
- `read:org`: Read-only access to organization membership
- `read:user`: Read-only access to user profile data
- `workflow`: Update GitHub Action workflows (optional)

### Docker Socket Access
The container requires access to the Docker socket to run MCP servers:
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro
```

This allows the container to spawn Docker-based MCP servers.

### Error Codes
- `MCP001`: GitHub token not provided
- `MCP002`: Invalid GitHub token
- `MCP003`: Insufficient token permissions
- `MCP004`: MCP server startup failed

### References
- [Model Context Protocol Documentation](https://modelcontextprotocol.io)
- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)