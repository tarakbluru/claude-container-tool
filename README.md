# Claude Container Tool 🤖

A containerized development environment for [Anthropic Claude Code](https://www.anthropic.com/claude/code) using Podman/Docker. This tool provides an isolated, portable workspace for AI-assisted coding with Claude across multiple projects.

## 🚀 Features

- **Project-based isolation**: Each project gets its own Claude container instance
- **Persistent workspace**: Your project files are mounted into the container
- **Easy management**: Simple PowerShell scripts for starting and stopping containers
- **Podman support**: Built for Podman but compatible with Docker
- **Cross-platform**: Works on Windows, Linux, and macOS

## 📋 Prerequisites

- [Podman](https://podman.io/getting-started/installation) or [Docker](https://docs.docker.com/get-docker/)
- PowerShell (for Windows users)
- Valid Anthropic API key for Claude Code

## 🛠️ Installation

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd claude-container-tool
   ```

2. **Build the Claude container image:**
   ```bash
   podman build -t claude-mcp .
   ```
   
   Or with Docker:
   ```bash
   docker build -t claude-mcp .
   ```

3. **Configure environment variables:**
   ```bash
   # Copy the example environment file
   cp .env.example .env
   
   # Edit .env with your actual git credentials
   # Update GIT_USER_NAME and GIT_USER_EMAIL with your details
   ```

4. **Set up your API key** (refer to [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code))

## 🖥️ Usage

### Starting Claude for a Project

Navigate to your project directory and run the start script:

```powershell
# Windows PowerShell
F:\path\to\claude-container\start-claude.ps1
```

```bash
# Linux/macOS (adapt the PowerShell logic to bash if needed)
# You can run the equivalent commands manually or create a bash version
```

The script will:
- Use your current directory as the project workspace
- Create a container named after your project folder
- Mount your project files into `/workspace` in the container
- Start an interactive bash session with Claude Code available

### Stopping Claude for a Project

From the same project directory:

```powershell
# Windows PowerShell
F:\path\to\claude-container\stop-claude.ps1
```

This will:
- Stop the container for the current project
- Remove the container and associated volumes
- Show any remaining Claude containers

### PowerShell Profile Setup (Recommended)

For easier access, add these functions to your PowerShell profile:

```powershell
# Add to your PowerShell profile ($PROFILE)
function Start-Claude { 
    <path>\start-claude.ps1 
}

function Stop-Claude { 
    <path>\claude_container\stop-claude.ps1 
}
```

**To set up:**
1. Open PowerShell and run: `notepad $PROFILE`
2. Add the functions above (adjust paths to match your installation)
3. Save and restart PowerShell
4. Now you can simply run `Start-Claude` or `Stop-Claude` from any project directory

### Manual Container Management

You can also manage containers manually:

```bash
# Start container for current directory
export WORKSPACE_DIR=$(pwd)
podman compose -p $(basename $(pwd)) up -d

# Connect to running container
podman compose -p $(basename $(pwd)) exec claude-mcp bash

# Stop container
podman compose -p $(basename $(pwd)) down
```

## 📁 Project Structure

```
claude-container-tool/
├── Dockerfile              # Container definition with Claude Code
├── docker-compose.yml      # Service configuration with git env vars
├── start-claude.ps1        # PowerShell script to start Claude
├── stop-claude.ps1         # PowerShell script to stop Claude
├── .env.example            # Environment variables template
├── .env                    # Your actual environment variables (excluded from git)
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## 🔧 Configuration

### Environment Variables

The following environment variables can be configured in your `.env` file:

**Git Configuration:**
- `GIT_USER_NAME`: Your git username for commit authoring (e.g., "tarakesh")
- `GIT_USER_EMAIL`: Your git email for commit authoring (e.g., "tarakesh.nc@gmail.com")

**Container Configuration:**
- `WORKSPACE_DIR`: Directory to mount as workspace (automatically set by scripts)

**GitHub Configuration (optional):**
- `GITHUB_USERNAME`: Your GitHub username
- `GITHUB_TOKEN`: GitHub Personal Access Token for API access

### Customizing the Container

Modify the `Dockerfile` to:
- Add additional development tools
- Install project-specific dependencies
- Configure shell preferences

Example additions:
```dockerfile
FROM node:lts
RUN npm install -g @anthropic-ai/claude-code

# Add additional tools
RUN apt-get update && apt-get install -y git vim curl

# Install other global packages
RUN npm install -g typescript eslint prettier

WORKDIR /workspace
CMD ["bash"]
```

## 💡 Tips and Best Practices

1. **Project Organization**: Each project gets its own container, keeping dependencies isolated
2. **Data Persistence**: Your project files persist outside the container
3. **Resource Management**: Stop containers when not in use to free system resources
4. **Multiple Projects**: You can run multiple Claude containers simultaneously for different projects
5. **API Usage**: Monitor your Claude API usage across projects

## 🐛 Troubleshooting

### Container Won't Start
- Ensure Podman/Docker is running
- Check if the `claude-mcp` image exists: `podman images`
- Verify the docker-compose.yml path is correct

### Permission Issues
- On Linux/macOS, ensure proper file permissions
- Check SELinux settings if applicable

### API Key Issues
- Verify your Anthropic API key is configured
- Check Claude Code documentation for setup instructions

### PowerShell Execution Policy
```powershell
# If scripts won't run, update execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🔄 Updating

To update Claude Code to the latest version:

```bash
# Rebuild the container
podman build -t claude-mcp . --no-cache
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your projects
5. Submit a pull request

## 📄 License

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 🆘 Support

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Podman Documentation](https://docs.podman.io/)
- [Issues](../../issues) - Report bugs or request features

## 🙏 Acknowledgments

- [Anthropic](https://www.anthropic.com/) for Claude Code
- [Podman](https://podman.io/) for containerization
- The open-source community

---

**Happy coding with Claude!** 🎉
