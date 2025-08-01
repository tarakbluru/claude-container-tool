FROM node:lts

# Install Docker CLI for MCP GitHub server
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Update npm to latest version
RUN npm install -g npm@latest

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Create virtual environment and install SuperClaude
RUN python3 -m venv /opt/superclaude \
    && /opt/superclaude/bin/pip install SuperClaude

# Install SuperClaude Framework during build (not at runtime)
RUN /opt/superclaude/bin/python -m SuperClaude install --profile developer --yes

# Make SuperClaude available system-wide
RUN ln -s /opt/superclaude/bin/python /usr/local/bin/superclaude-python \
    && echo '#!/bin/bash\n/opt/superclaude/bin/python -m SuperClaude "$@"' > /usr/local/bin/SuperClaude \
    && chmod +x /usr/local/bin/SuperClaude

# Create MCP configuration directory
RUN mkdir -p /root/.config/claude

# Copy scripts
COPY scripts/connect_mcp.sh /connect_mcp.sh
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /connect_mcp.sh /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]