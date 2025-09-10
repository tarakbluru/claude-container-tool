FROM node:lts

# Install Python, pip, and other dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    python3-full \
    pipx \
    expect \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli gh \
    && rm -rf /var/lib/apt/lists/*

# Update npm to latest version
RUN npm install -g npm@latest

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Install SuperClaude Framework using pipx (bypasses PEP 668)
RUN echo "=== Installing SuperClaude Framework via pipx ===" \
    && pipx install SuperClaude \
    && echo "✓ SuperClaude Framework installed via pipx" \
    && echo "=== Running SuperClaude installer ===" \
    && /root/.local/bin/SuperClaude install --yes \
    && echo "✓ SuperClaude Framework configured for Claude Code"

# Make pipx binaries available in PATH
ENV PATH="/root/.local/bin:$PATH"

# Create MCP configuration directory
RUN mkdir -p /root/.config/claude

# Copy scripts
COPY scripts/connect_mcp.sh /connect_mcp.sh
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /connect_mcp.sh /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]