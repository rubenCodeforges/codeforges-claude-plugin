# Contributing to Code Analysis Toolkit

Thank you for your interest in contributing to the Code Analysis Toolkit! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Plugin Structure](#plugin-structure)
- [Contribution Guidelines](#contribution-guidelines)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project follows a simple code of conduct:
- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear, descriptive title
- Steps to reproduce the issue
- Expected vs actual behavior
- Claude Code version and environment details
- Relevant agent/skill/command involved

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:
- Clear description of the enhancement
- Use case and benefits
- Example usage if applicable
- Whether it's a new agent, skill, command, or improvement to existing ones

### Contributing Code

1. **New Agents**: Add specialized analysis capabilities
2. **New Skills**: Add knowledge bases for auto-loading
3. **New Commands**: Add slash commands for quick access
4. **Improvements**: Enhance existing agents, skills, or commands
5. **Documentation**: Improve README, examples, or inline docs

## Development Setup

### Prerequisites
- Claude Code CLI installed
- Git for version control
- Text editor (VS Code, Vim, etc.)

### Installation

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone git@github.com:YOUR_USERNAME/codeforges-claude-plugin.git
   cd codeforges-claude-plugin
   ```

3. Install the plugin locally for testing:
   ```bash
   # Link to Claude Code plugins directory
   ln -s $(pwd) ~/.claude/plugins/code-analysis-toolkit
   ```

## Plugin Structure

```
code-analysis-toolkit/
├── manifest.json          # Plugin configuration
├── marketplace.json       # Marketplace metadata
├── agents/               # Sub-agent definitions
│   └── agent-name.md     # Agent prompt and configuration
├── skills/               # Auto-loading skills
│   └── skill-name.md     # Skill knowledge base
└── commands/             # Slash commands
    └── command-name.md   # Command definition
```

### Agent Structure

Agents are defined in Markdown files with YAML frontmatter:

```markdown
---
name: agent-name
description: Brief description of what this agent does
tools: [Read, Grep, Glob, Bash]
model: sonnet
---

# Agent Instructions

Detailed instructions for the agent...
```

### Skill Structure

Skills are knowledge bases that auto-load:

```markdown
---
name: skill-name
description: What knowledge this skill provides
---

# Skill Content

Knowledge and patterns...
```

### Command Structure

Commands are slash command definitions:

```markdown
---
name: command-name
description: What this command does
---

# Command Prompt

Instructions when command is invoked...
```

## Contribution Guidelines

### Agent Contributions

When creating or updating agents:

1. **Clear Purpose**: Agent should have a focused, specific purpose
2. **Comprehensive Instructions**: Provide detailed, step-by-step instructions
3. **Tool Usage**: Clearly document which tools to use and when
4. **Output Format**: Specify expected output format with examples
5. **Language Support**: Include patterns for multiple languages when applicable
6. **Examples**: Provide usage examples and expected outputs

**Example Agent Checklist:**
- [ ] Clear mission statement
- [ ] Step-by-step analysis process
- [ ] Framework/language-specific patterns
- [ ] Output format specification
- [ ] Tool usage guidelines
- [ ] Important notes and caveats
- [ ] Example invocations

### Skill Contributions

When creating or updating skills:

1. **Comprehensive Coverage**: Cover topic thoroughly
2. **Practical Examples**: Include before/after code examples
3. **Multi-Language**: Support multiple programming languages
4. **Best Practices**: Focus on industry best practices
5. **Clear Organization**: Use clear headings and structure

**Example Skill Checklist:**
- [ ] Clear introduction
- [ ] Well-organized sections
- [ ] Code examples with explanations
- [ ] Multiple language support
- [ ] Best practices highlighted
- [ ] Common pitfalls noted

### Command Contributions

When creating commands:

1. **Simple Invocation**: Commands should be easy to invoke
2. **Clear Purpose**: Single, focused purpose
3. **Good Documentation**: Explain what the command does
4. **Agent Integration**: Link to appropriate agents when needed

### Code Quality

- Use clear, descriptive language
- Follow markdown best practices
- Include code examples with syntax highlighting
- Use consistent formatting
- Proofread for spelling and grammar

### Testing

Before submitting:

1. **Test the Agent/Skill/Command**: Ensure it works as expected
2. **Test with Claude Code**: Verify it loads correctly
3. **Test Edge Cases**: Try various scenarios
4. **Validate Manifest**: Ensure manifest.json is valid

## Submitting Changes

### Process

1. **Create a Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**:
   - Edit or add agent/skill/command files
   - Update manifest.json if adding new components
   - Update README.md if needed

3. **Test Thoroughly**:
   - Test your changes with Claude Code
   - Verify no breaking changes

4. **Commit Changes**:
   ```bash
   git add .
   git commit -m "Add: descriptive commit message"
   ```

   Commit message format:
   - `Add: new feature or component`
   - `Update: changes to existing component`
   - `Fix: bug fix`
   - `Docs: documentation changes`

5. **Push to Your Fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**:
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template

### Pull Request Guidelines

Your PR should:

1. **Clear Title**: Descriptive title (e.g., "Add: SQL query analysis agent")
2. **Description**: Explain what and why
3. **Testing**: Describe how you tested
4. **Documentation**: Update README if needed
5. **No Breaking Changes**: Unless absolutely necessary
6. **One Feature Per PR**: Keep PRs focused

### PR Template

```markdown
## Description
[Describe your changes]

## Type of Change
- [ ] New agent
- [ ] New skill
- [ ] New command
- [ ] Bug fix
- [ ] Enhancement
- [ ] Documentation

## Testing
[Describe how you tested]

## Checklist
- [ ] Code follows plugin structure
- [ ] Tested with Claude Code
- [ ] Updated manifest.json (if applicable)
- [ ] Updated README.md (if applicable)
- [ ] No breaking changes (or clearly documented)
```

## Manifest Updates

When adding new components, update `manifest.json`:

### Adding an Agent
```json
{
  "agents": [
    {
      "name": "your-agent-name",
      "path": "agents/your-agent-name.md"
    }
  ]
}
```

### Adding a Skill
```json
{
  "skills": [
    {
      "name": "your-skill-name",
      "path": "skills/your-skill-name.md"
    }
  ]
}
```

### Adding a Command
```json
{
  "commands": [
    {
      "name": "your-command-name",
      "path": "commands/your-command-name.md"
    }
  ]
}
```

## Style Guide

### Markdown
- Use ATX-style headings (`#`, `##`, `###`)
- Use fenced code blocks with language identifiers
- Use bullet points for lists
- Use **bold** for emphasis, *italics* for terms

### Code Examples
- Include language identifier: ` ```javascript `
- Provide context comments
- Show before/after when demonstrating improvements
- Keep examples concise but complete

### Naming Conventions
- **Agents**: `noun-verb` (e.g., `code-analyzer`, `usage-finder`)
- **Skills**: `subject-noun` (e.g., `refactoring-guide`, `performance-patterns`)
- **Commands**: `verb-noun` (e.g., `analyze-file`, `scan-codebase`)

## Questions?

If you have questions:
1. Check existing issues and discussions
2. Create a new issue with the `question` label
3. Reach out via GitHub Discussions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Thank you for contributing to the Code Analysis Toolkit! Your contributions help make code analysis better for everyone using Claude Code.
