FROM node:lts

# Install Python, pip, and other dependencies including ping
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
    iputils-ping \
    tree \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli gh \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN python3 -m pip install --break-system-packages requests pandas numpy python-dotenv

# Update npm to latest version
RUN npm install -g npm@latest

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Install SuperClaude Framework using pipx (bypasses PEP 668)
# Note: v4.1.9+ uses simplified CLI - just 'superclaude install' with no extra flags
RUN echo "=== Installing SuperClaude Framework via pipx ===" \
    && pipx install SuperClaude \
    && echo "✅ SuperClaude Framework installed via pipx" \
    && echo "=== Running SuperClaude installer ===" \
    && /root/.local/bin/superclaude install \
    && echo "=== Verifying installation ===" \
    && ls -la /root/.claude/ \
    && echo "Commands directory contents:" \
    && ls -la /root/.claude/commands/ \
    && echo "Commands count: $(ls /root/.claude/commands/ 2>/dev/null | wc -l)" \
    && echo "✅ SuperClaude Framework fully configured"

# Make pipx binaries available in PATH
ENV PATH="/root/.local/bin:$PATH"

# Create MCP configuration directory
RUN mkdir -p /root/.config/claude

# Create global Claude configuration directory
RUN mkdir -p /root/.claude

# Copy global CLAUDE.md to the container (this makes it available in every container instance)
COPY global_CLAUDE.md /root/.claude/CLAUDE.md

# Create claude configuration directory and copy environment variables
RUN mkdir -p /etc/claude
COPY .env /etc/claude/.env

# Configure shell to automatically source environment variables in all sessions
RUN echo '' >> /root/.bashrc \
    && echo '# Load Claude container environment variables' >> /root/.bashrc \
    && echo 'if [ -f "/etc/claude/.env" ]; then' >> /root/.bashrc \
    && echo '    set -a  # automatically export all variables' >> /root/.bashrc \
    && echo '    source /etc/claude/.env' >> /root/.bashrc \
    && echo '    set +a' >> /root/.bashrc \
    && echo 'fi' >> /root/.bashrc

# Copy scripts
COPY scripts/connect_mcp.sh /connect_mcp.sh
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /connect_mcp.sh /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]