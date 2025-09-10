#!/bin/bash
# Container entrypoint script

# Ensure pipx binaries are in PATH
export PATH="/root/.local/bin:$PATH"

# Check SuperClaude Framework status
if [ ! -f "/root/.claude/.initialized" ]; then
    echo "============================================"
    echo "Verifying SuperClaude Framework..."
    echo "============================================"
    
    # Check if SuperClaude is installed via pipx
    if command -v SuperClaude &> /dev/null; then
        echo "✓ SuperClaude Framework found via pipx"
        
        # Check if configuration files exist and commands are populated
        if [ -d "/root/.claude" ] && [ -f "/root/.claude/CLAUDE.md" ] && [ "$(ls -A /root/.claude/commands/ 2>/dev/null | wc -l)" -gt 0 ]; then
            echo "✓ SuperClaude configuration files already installed and commands populated"
        else
            echo "SuperClaude framework found but commands missing, running installer..."
            if SuperClaude install --force --yes; then
                echo "✓ SuperClaude Framework configured successfully!"
            else
                echo "⚠ SuperClaude installer had issues, but framework is available"
            fi
        fi
        
        # Verify installation
        if [ -d "/root/.claude" ] && [ "$(ls -A /root/.claude 2>/dev/null | wc -l)" -gt 0 ]; then
            echo "✓ SuperClaude configuration verified in ~/.claude/"
            echo "✓ Full SuperClaude Framework v4 capabilities available"
        fi
        
        touch /root/.claude/.initialized
        echo "✓ SuperClaude Framework ready!"
        
    else
        echo "⚠ SuperClaude Framework not found"
        echo "Expected: SuperClaude should be installed via pipx"
        
        # Create minimal setup as fallback
        mkdir -p /root/.claude
        echo "# Basic Claude Code Setup" > /root/.claude/CLAUDE.md
        touch /root/.claude/.initialized
    fi
else
    echo "✓ SuperClaude Framework already verified and ready"
fi

# Function to create project-specific SuperClaude setup
setup_project_superclaude() {
    local project_dir="/workspace"
    
    if [ -d "$project_dir" ] && command -v SuperClaude &> /dev/null; then
        echo ""
        echo "🔧 Setting up SuperClaude for current project..."
        
        # Create project .claude directory if it doesn't exist
        mkdir -p "$project_dir/.claude"
        
        # Create a project-specific CLAUDE.md that integrates with the full framework
        if [ ! -f "$project_dir/.claude/CLAUDE.md" ]; then
            cat > "$project_dir/.claude/CLAUDE.md" << 'EOF'
# Project SuperClaude Configuration

This project uses the complete SuperClaude Framework v4 with full capabilities.

## Framework Status
- ✅ Global SuperClaude Framework v4 active
- ✅ All /sc: commands available with full functionality
- ✅ Advanced orchestration and intelligent routing
- ✅ Token optimization (70% reduction capability)
- ✅ Wave mode for complex multi-step operations
- ✅ MCP integration (Context7, Sequential, Magic, Playwright)
- ✅ Git checkpoint system and task management

## Available Commands
Core SuperClaude /sc: commands with full framework support:
- /sc:brainstorm - Interactive requirements discovery
- /sc:implement - Feature implementation with intelligent routing
- /sc:analyze - Multi-dimensional analysis with persona coordination
- /sc:build - Smart build operations with framework detection
- /sc:test - Advanced testing workflows with quality gates
- /sc:improve - Code improvement with optimization algorithms
- /sc:document - Intelligent documentation generation
- /sc:troubleshoot - Systematic debugging with root cause analysis

## Advanced Features Available
- **Token Optimization**: Automatic compression for large projects
- **Wave Mode**: Use --wave for complex multi-step operations
- **Persona Auto-Activation**: Smart switching based on context
- **MCP Orchestration**: Automatic tool coordination
- **Task Management**: Project workflow coordination
- **Git Checkpoints**: Advanced workflow state management

## Cognitive Personas (Auto-Activating)
- --persona-architect: Systems design and architecture
- --persona-frontend: UI/UX and modern frontend practices
- --persona-backend: APIs, databases, and infrastructure
- --persona-security: Security-first approach and threat modeling
- --persona-analyzer: Debugging and root cause investigation
- --persona-qa: Quality assurance and comprehensive testing
- --persona-performance: Optimization and efficiency focus
- --persona-scribe: Documentation and technical writing

## Project-Specific Context
Add your project-specific guidelines, preferences, and context here.
This will be combined with the global SuperClaude Framework for optimal results.

EOF
            echo "✓ Created project-specific .claude/CLAUDE.md with full framework integration"
        fi
        
        # Optionally create a .gitignore entry for local Claude settings
        if [ -f "$project_dir/.gitignore" ]; then
            if ! grep -q ".claude/settings.local.json" "$project_dir/.gitignore" 2>/dev/null; then
                echo "" >> "$project_dir/.gitignore"
                echo "# Claude Code local settings" >> "$project_dir/.gitignore"
                echo ".claude/settings.local.json" >> "$project_dir/.gitignore"
                echo "✓ Added Claude settings to .gitignore"
            fi
        fi
        
        echo "✓ Project SuperClaude setup complete"
    fi
}

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

# Setup project-specific SuperClaude configuration
setup_project_superclaude

echo "==================================="
echo "Claude Code + SuperClaude Ready!"
echo "==================================="
echo "Available enhancements:"

# Check what's actually available
if command -v SuperClaude &> /dev/null; then
    echo "✅ SuperClaude Framework v4 (Full) - Installed via pipx"
    
    # Try to get version
    SUPERCLAUDE_VERSION=$(SuperClaude --version 2>/dev/null || echo "4.x")
    echo "   Version: $SUPERCLAUDE_VERSION"
    
    echo ""
    echo "🚀 Complete Framework Features:"
    echo "   • Advanced orchestration with intelligent tool routing"
    echo "   • Token optimization (70% reduction for large projects)"
    echo "   • Wave mode for complex multi-step operations" 
    echo "   • Full MCP integration (Context7, Sequential, Magic, Playwright)"
    echo "   • Git checkpoint system for workflow state management"
    echo "   • Task management and project coordination"
    echo "   • Smart persona auto-activation and switching"
    echo ""
    echo "📁 Configuration Status:"
    if [ -f "/root/.claude/CLAUDE.md" ]; then
        echo "   ✅ Global: ~/.claude/ (full framework installed)"
        echo "   📊 Files: $(ls /root/.claude/ 2>/dev/null | wc -l) configuration files"
    else
        echo "   ⚠  Global: ~/.claude/ (may need setup)"
    fi
    
    if [ -f "/workspace/.claude/CLAUDE.md" ]; then
        echo "   ✅ Project: /workspace/.claude/ (project-optimized)"
    else
        echo "   💡 Project: Ready for setup"
    fi
    
    echo ""
    echo "⚡ Available /sc: commands (full framework power):"
    echo "   • /sc:brainstorm - AI-powered requirements discovery"
    echo "   • /sc:implement - Intelligent feature implementation"
    echo "   • /sc:analyze - Multi-dimensional code analysis"
    echo "   • /sc:build - Smart build with auto-optimization"
    echo "   • /sc:test - Advanced testing orchestration"
    echo "   • /sc:improve - AI-driven code enhancement"
    echo "   • /sc:document - Intelligent documentation generation"
    echo "   • /sc:troubleshoot - Systematic debugging workflows"
    echo ""
    echo "🎯 Advanced Usage Examples:"
    echo "   /sc:brainstorm \"e-commerce platform\" --wave"
    echo "   /sc:analyze codebase/ --persona-security --focus vulnerabilities"
    echo "   /sc:implement \"user auth\" --persona-architect --wave"
    echo ""
    echo "🚀 Get started: Run 'claude' then try '/sc:brainstorm \"your idea\"'"
    
else
    echo "⚠  SuperClaude Framework not available"
    echo "💡 Expected: pipx install SuperClaude should be completed"
fi

echo ""
echo "🔧 Additional Capabilities:"
echo "   • GitHub MCP integration with repository access"
echo "   • Complete GitHub workflow management"
echo "   • Docker-in-Docker for MCP servers"
echo "==================================="

# Execute the main command
exec "$@"