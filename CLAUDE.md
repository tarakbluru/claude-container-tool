# Claude Code + SuperClaude Framework Setup

A complete Docker container setup providing Claude Code with the full SuperClaude Framework v4 for enhanced AI-assisted development.

## 🚀 Quick Start

```powershell
# 1. Build the container (one-time setup)
cd F:\BackUP\Dropbox\Projects\tarak\claude_container\
podman build -t claude-mcp . --no-cache

# 2. Use from any project directory
cd C:\your-project-directory
F:\BackUP\Dropbox\Projects\tarak\claude_container\start-claude.ps1

# 3. Start Claude Code in the container
claude

# 4. Test SuperClaude commands
/sc:brainstorm "web application for task management"
/sc:implement "user authentication system"
/sc:analyze src/
```

## 🎯 What You Get

### Core Capabilities
- **Claude Code CLI** - Latest version with all standard tools
- **SuperClaude Framework v4** - Complete with all advanced features
- **GitHub MCP Integration** - Direct repository access and management
- **Enhanced Development Workflows** - Professional-grade AI assistance

### SuperClaude Framework Features
- **🧠 Intelligent Orchestration** - Smart tool routing and coordination
- **🔥 Token Optimization** - 70% reduction for large projects  
- **🌊 Wave Mode** - Complex multi-step operations with progress tracking
- **🎭 Cognitive Personas** - Auto-activating domain expertise
- **📋 Task Management** - Project coordination and workflow state
- **🔗 Git Checkpoints** - Advanced workflow state management

### Available /sc: Commands
```
/sc:brainstorm    - Interactive requirements discovery
/sc:implement     - Feature implementation with intelligent routing
/sc:analyze       - Multi-dimensional code analysis
/sc:build         - Smart build operations with framework detection
/sc:test          - Advanced testing workflows with quality gates
/sc:improve       - Code improvement with optimization algorithms
/sc:document      - Intelligent documentation generation
/sc:troubleshoot  - Systematic debugging with root cause analysis
```

### Cognitive Personas (Auto-Activating)
```
--persona-architect    - Systems design and architecture
--persona-frontend     - UI/UX and modern frontend practices
--persona-backend      - APIs, databases, and infrastructure
--persona-security     - Security-first approach and threat modeling
--persona-analyzer     - Debugging and root cause investigation
--persona-qa          - Quality assurance and comprehensive testing
--persona-performance - Optimization and efficiency focus
--persona-scribe      - Documentation and technical writing
```

## 📁 File Structure

```
F:\BackUP\Dropbox\Projects\tarak\claude_container\
├── Dockerfile                 # Main container definition
├── docker-compose.yml         # Container orchestration
├── .env                      # Environment variables (copy from .env.example)
├── scripts/
│   ├── connect_mcp.sh       # GitHub MCP server setup
│   └── entrypoint.sh        # Container initialization
├── start-claude.ps1         # Start container for current project
├── stop-claude.ps1          # Stop container
└── CLAUDE.md               # This documentation file
```

## ⚙️ Configuration

### Environment Variables (.env file)
```env
# Git Configuration
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"

# GitHub Token (for MCP GitHub integration)
GITHUB_TOKEN="your_github_token_here"

# Claude Code Configuration (optional)
ANTHROPIC_MODEL="claude-3-5-sonnet-20241022"
CLAUDE_CODE_MAX_OUTPUT_TOKENS="8192"
MAX_THINKING_TOKENS="30000"

# Optional SuperClaude MCP API Keys (for enhanced features)
TWENTYFIRST_API_KEY="your_api_key"     # For advanced UI generation
MORPH_API_KEY="your_api_key"           # For Fast Apply functionality
```

## 🔨 Installation Steps

### 1. Initial Setup
```powershell
# Create directory structure
mkdir F:\BackUP\Dropbox\Projects\tarak\claude_container\scripts

# Copy all files from the artifacts to their respective locations
# - Dockerfile → Root directory
# - docker-compose.yml → Root directory  
# - scripts/connect_mcp.sh → scripts/ subdirectory
# - scripts/entrypoint.sh → scripts/ subdirectory
```

### 2. Configure Environment
```powershell
# Copy environment template
cp .env.example .env

# Edit .env with your details:
# - Add your GitHub token
# - Set your Git name and email
notepad .env
```

### 3. Build Container
```powershell
cd F:\BackUP\Dropbox\Projects\tarak\claude_container\
podman build -t claude-mcp . --no-cache
```

**Build Process Includes:**
- Node.js and Claude Code installation
- SuperClaude Framework v4 via pipx (bypasses Python restrictions)
- All SuperClaude components (`--components all`)
- MCP servers: sequential-thinking, context7, magic, playwright
- GitHub MCP integration setup

## 🎮 Usage Workflows

### Basic Development Session
```powershell
# 1. Navigate to your project
cd C:\your-awesome-project

# 2. Start Claude for this project
F:\BackUP\Dropbox\Projects\tarak\claude_container\start-claude.ps1

# 3. In the container, start Claude Code
claude

# 4. Use SuperClaude commands
/sc:brainstorm "mobile app for fitness tracking"
```

### Advanced SuperClaude Usage
```
# Complex multi-step operations
/sc:implement "user dashboard" --wave --persona-frontend

# Security-focused analysis  
/sc:analyze codebase/ --persona-security --focus vulnerabilities

# Performance optimization
/sc:improve slow-function.js --persona-performance --focus speed

# Architectural review
/sc:analyze system/ --persona-architect --focus scalability
```

### Project Management
```
# Load and analyze project
/sc:analyze . --deep --summary

# Feature planning
/sc:brainstorm "payment integration" --strategy systematic

# Implementation workflow
/sc:implement "stripe payments" --type backend --focus security

# Quality assurance
/sc:test payment-service/ --type integration --coverage
```

## 🔧 Advanced Features

### Wave Mode Operations
Use `--wave` for complex multi-step operations that require coordination:
```
/sc:implement "complete user system" --wave
# Automatically breaks down into: auth, profiles, permissions, etc.
```

### Token Optimization
SuperClaude automatically compresses context for large projects:
- 70% token reduction for large codebases
- Intelligent context summarization
- Maintains quality while saving costs

### MCP Integration
Automatically coordinated external tools:
- **Context7**: Documentation lookup and official guides
- **Sequential**: Multi-step reasoning and complex analysis  
- **Magic**: UI component generation (with API key)
- **Playwright**: Browser automation and testing

### Git Checkpoints
Navigate back to any point in your workflow:
```
# SuperClaude automatically creates checkpoints
# Rollback available through git integration
```

## 🛠️ Troubleshooting

### Container Issues
```powershell
# Check running containers
podman ps

# View container logs
podman logs <container-name>

# Clean rebuild
podman build -t claude-mcp . --no-cache --pull
```

### SuperClaude Not Working
```bash
# In container, verify SuperClaude installation
SuperClaude --version

# Check configuration files
ls -la /root/.claude/
ls -la /root/.claude/commands/

# Verify commands in Claude Code
/help
```

### Missing Commands
If `/sc:` commands don't appear:
```bash
# Manual reinstall (in container)
SuperClaude install --force --yes --components all

# Check command files
ls /r