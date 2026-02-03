#!/bin/bash
# init-project.sh - Initialize a new project with vibe coding agents

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║     🚀 Vibe Coding Agents - Project Initialization          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if we're in the agents repo
if [ ! -f "AGENTS.md" ]; then
    print_error "This doesn't appear to be the vibe-coding-agents repository"
    print_info "Please run this script from the vibe-coding-agents directory"
    exit 1
fi

print_header

# Get project information
echo ""
print_info "Let's set up your new project!"
echo ""

read -p "Project name: " PROJECT_NAME
read -p "Project type (web-app/api/mobile/data/infra): " PROJECT_TYPE
read -p "Target directory (default: ../$PROJECT_NAME): " TARGET_DIR

TARGET_DIR=${TARGET_DIR:-"../$PROJECT_NAME"}

# Confirm
echo ""
print_info "Project Configuration:"
echo "  Name: $PROJECT_NAME"
echo "  Type: $PROJECT_TYPE"
echo "  Target: $TARGET_DIR"
echo ""
read -p "Continue? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    print_warning "Initialization cancelled"
    exit 0
fi

# Create target directory
print_info "Creating project directory..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Copy agent files
print_info "Copying agent configuration files..."

# Core context
cp -r "$(dirname "$0")/../.ai" .
print_success "Copied .ai/ directory"

# Tool-specific configs
if [ -f "$(dirname "$0")/../AGENTS.md" ]; then
    cp "$(dirname "$0")/../AGENTS.md" .
    print_success "Copied AGENTS.md (Codex)"
fi

if [ -d "$(dirname "$0")/../.claude" ]; then
    cp -r "$(dirname "$0")/../.claude" .
    print_success "Copied .claude/ directory"
fi

if [ -f "$(dirname "$0")/../GEMINI.md" ]; then
    cp "$(dirname "$0")/../GEMINI.md" .
    print_success "Copied GEMINI.md"
fi

if [ -d "$(dirname "$0")/../.gemini" ]; then
    cp -r "$(dirname "$0")/../.gemini" .
    print_success "Copied .gemini/ directory"
fi

if [ -d "$(dirname "$0")/../.windsurf" ]; then
    cp -r "$(dirname "$0")/../.windsurf" .
    print_success "Copied .windsurf/ directory"
fi

if [ -d "$(dirname "$0")/../.cursor" ]; then
    cp -r "$(dirname "$0")/../.cursor" .
    print_success "Copied .cursor/ directory"
fi

if [ -d "$(dirname "$0")/../.github" ]; then
    mkdir -p .github
    cp "$(dirname "$0")/../.github/copilot-instructions.md" .github/ 2>/dev/null || true
    print_success "Copied .github/copilot-instructions.md"
fi

# Create docs directory
mkdir -p docs/ADR
print_success "Created docs/ directory"

# Create scripts directory
mkdir -p scripts
print_success "Created scripts/ directory"

# Update CORE.md with project info
print_info "Updating CORE.md with project information..."
sed -i.bak "s/nombre: \"\"/nombre: \"$PROJECT_NAME\"/" .ai/context/CORE.md 2>/dev/null || true
sed -i.bak "s/tipo: \[web-app | api | mobile | data | infra\]/tipo: $PROJECT_TYPE/" .ai/context/CORE.md 2>/dev/null || true
rm -f .ai/context/CORE.md.bak

# Create basic README
print_info "Creating README.md..."
cat > README.md << EOF
# $PROJECT_NAME

> Project initialized with Vibe Coding Agents

## 🚀 Getting Started

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Start development:
   \`\`\`bash
   npm run dev
   \`\`\`

## 📋 Available Commands

- \`npm run dev\` - Start development server
- \`npm run build\` - Build for production
- \`npm run test\` - Run tests
- \`npm run lint\` - Run linter
- \`npm run typecheck\` - Run type checker

## 🤖 AI Agents

This project uses a multi-agent system. Available commands:

| Command | Agent | Description |
|---------|-------|-------------|
| \`/ask\` | ASK | Analyze requirements |
| \`/plan\` | PLAN | Technical planning |
| \`/build [slice]\` | BUILD | Implementation |
| \`/test\` | TEST | Testing |
| \`/review\` | REVIEW | Code review |
| \`/release\` | RELEASE | Release |

## 📚 Documentation

- [PRD](docs/PRD.md) - Product Requirements
- [Architecture](docs/ARCHITECTURE.md) - Technical Architecture
- [Core Context](.ai/context/CORE.md) - Project Context
- [Standards](.ai/context/STANDARDS.md) - Coding Standards

---

Initialized with [Vibe Coding Agents](https://github.com/your-repo/vibe-coding-agents)
EOF

print_success "Created README.md"

# Create .gitignore
print_info "Creating .gitignore..."
cat > .gitignore << EOF
# Dependencies
node_modules/
.pnp
.pnp.js

# Build
dist/
build/
*.tsbuildinfo

# Environment
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log
npm-debug.log*

# Testing
coverage/
.nyc_output/

# Temporary
tmp/
temp/
EOF

print_success "Created .gitignore"

# Initialize git
print_info "Initializing git repository..."
git init
git add .
git commit -m "chore: initial project setup with vibe coding agents"
print_success "Git repository initialized"

echo ""
print_success "Project '$PROJECT_NAME' initialized successfully!"
echo ""
print_info "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. Update .ai/context/CORE.md with project details"
echo "  3. Run your AI tool (Claude Code, Windsurf, etc.)"
echo "  4. Start with: /ask 'Describe your idea'"
echo ""
print_info "Happy coding! 🚀"
