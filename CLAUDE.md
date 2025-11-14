# Claude Code Plugin Development Guide

This file contains instructions for Claude Code when working on this plugin.

## Plugin Purpose

**cf-dev-toolkit** is a daily development workflow plugin that solves Claude Code's tendency to:
- Read only 20-30 lines and miss context
- Lose focus on complex tasks
- Make assumptions about method signatures
- Get overwhelmed by real-world development work

It provides specialized sub-agents with separate context windows that stay focused, understand complete context, and verify before suggesting code.

## Important Rules

### When Modifying Agents

1. **Keep Proactive Keywords**
   - Always include `MUST BE USED` and `USE PROACTIVELY` in descriptions
   - These trigger automatic invocation based on user's natural language

2. **Verification First**
   - All agents must check actual method signatures before suggesting code
   - No assumptions - always read implementations

3. **Smart Reading Strategy**
   - Files < 1000 lines: Read completely
   - Files > 1000 lines: Strategic reading (imports, exports, key sections) + Grep
   - Never say "I only read X lines" without justification

4. **No Hard-Coded Numbers**
   - Don't mention "7 agents" or "3 skills" in descriptions
   - Plugin may grow - keep descriptions version-agnostic

### File Structure

```
cf-dev-toolkit/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace config (name, owner, plugins)
├── manifest.json             # Plugin manifest (agents, skills, commands)
├── agents/                   # Sub-agent definitions (.md files)
├── skills/                   # Auto-loading knowledge (.md files)
├── commands/                 # Slash commands (.md files)
├── LICENSE                   # MIT license
├── .gitignore               # Git exclusions
├── CONTRIBUTING.md          # Contribution guidelines
├── README.md                # User-facing documentation
└── CLAUDE.md                # This file (for Claude Code)
```

### Naming Conventions

- **Plugin name**: `cf-dev-toolkit` (not "code-analysis-toolkit")
- **Author**: `codeforges` (or `cf` for short)
- **Owner**: `codeforges` in marketplace.json

### Agent Description Format

```yaml
---
name: agent-name
description: MUST BE USED for [purpose]. USE PROACTIVELY when user asks [triggers]. [Brief capability description].
tools: [Read, Grep, Glob, Bash]
model: sonnet
---

You are a [role] specialist...

**CRITICAL RULE**: Before suggesting ANY code changes:
1. Read the actual implementation
2. Check parameters, return types, behavior
3. NEVER assume method signatures
```

### Skills Format

Skills auto-load when relevant. Keep them:
- Comprehensive but concise
- Multi-language examples
- Practical, not theoretical
- Organized with clear headings

### Marketplace Structure

**Must follow Claude Code docs:**
- Marketplace file at `.claude-plugin/marketplace.json`
- Includes `name`, `owner` (required), `plugins` array
- Plugin `source` points to `./` for root directory

## Development Workflow

### Adding New Agent

1. Create `agents/new-agent.md` with proper frontmatter
2. Add to `manifest.json` agents array
3. Include `MUST BE USED` and `USE PROACTIVELY` keywords
4. Add verification rules if it suggests code changes
5. Test automatic invocation with natural language

### Adding New Skill

1. Create `skills/new-skill.md`
2. Add to `manifest.json` skills array
3. Ensure it's educational, not instructional
4. Multi-language examples preferred

### Adding New Command

1. Create `commands/new-command.md`
2. Add to `manifest.json` commands array
3. Keep it simple and focused

### Testing Changes

Before committing:
1. Verify manifest.json is valid JSON
2. Check all paths in manifest exist
3. Test agent invocation with natural prompts
4. Ensure README reflects changes
5. Update version if needed

## Common Tasks

### Updating Agent Descriptions

When user reports agent not triggering automatically:
1. Check description has `MUST BE USED` and `USE PROACTIVELY`
2. Add more trigger phrases: "when user asks X, Y, Z"
3. Be specific about triggers but keep description concise

### Improving Context Management

If agents read too much/too little:
1. Review the strategic reading threshold (currently 1000 lines)
2. Adjust agent instructions for file size handling
3. Test with large files (5000+ lines)

### Fixing Assumption Problems

If agents suggest code without checking:
1. Add/strengthen "CRITICAL RULE" section
2. Emphasize: "Read actual implementation first"
3. Add: "NEVER assume method signatures"

## Version Management

Current version: 1.1.12

When incrementing:
1. Update `manifest.json` version
2. Update `.claude-plugin/marketplace.json` plugin version
3. Update README.md badge
4. Document changes in git commit

### Versioning Pattern (Custom for this project)

**IMPORTANT: This project uses a modified versioning pattern:**

Format: `1.MINOR.PATCH`
- **1.X.0**: Major feature releases (reserved for significant milestones)
- **1.1.X**: All regular updates including:
  - New agents, skills, commands
  - Feature enhancements
  - Bug fixes
  - Documentation updates
  - Performance improvements

Examples:
- Add new agent → 1.1.12 (increment patch)
- Fix agent trigger keywords → 1.1.13 (increment patch)
- Major rewrite/v2 → 2.0.0 (only for breaking changes)

**Note**: We keep all backward-compatible changes as patch versions (1.1.X) to maintain stability and indicate continuous improvement rather than major version jumps.

## Installation Testing

Test both installation methods:

```bash
# Marketplace
/plugin marketplace add rubenCodeforges/codeforges-claude-plugin
/plugin install cf-dev-toolkit

# Direct GitHub
/plugin add github rubenCodeforges/codeforges-claude-plugin
```

### Testing Checklist

After making changes:
1. Validate JSON syntax in `manifest.json` and `.claude-plugin/marketplace.json`
2. Verify all paths exist (agents, skills, commands)
3. Test agent auto-triggering with natural language prompts
4. Test slash commands if modified
5. Check skills load correctly
6. Test in fresh conversation (restart Claude Code if needed)
7. Verify version numbers match across all files

## User's Vision

Remember the core vision:
- **Reduce context window usage** by delegating to specialized agents
- **Enhance quality** through focused, specialized analysis
- **Prevent Claude from losing focus** on complex tasks
- **Daily workflow tool** - not just "analysis"

This plugin makes Claude Code productive for real-world development, not toy examples.

## Troubleshooting

### Agent Not Triggering Automatically

1. Check description has `MUST BE USED` and `USE PROACTIVELY`
2. Add more natural trigger phrases
3. Verify agent is listed in `manifest.json`
4. Restart Claude Code
5. Try explicit invocation with `@agent-name`

### Skills Not Loading

1. Verify skill is in `manifest.json` skills array
2. Check file exists at specified path
3. Skills load when relevant - not every conversation
4. Skills are informational, not instructional

### Commands Not Working

1. Check command is in `manifest.json` commands array
2. Verify file exists at specified path
3. Use exact name: `/command-name`, not `/commandName`
4. Restart Claude Code after adding commands

### JSON Validation Errors

Use `jq` to validate JSON files:
```bash
jq . manifest.json
jq . .claude-plugin/marketplace.json
```

## Best Practices

### Agent Design

1. **Single Responsibility**: Each agent should have one clear purpose
2. **Comprehensive Tools**: Give agents all tools they need (Read, Grep, Glob, Bash)
3. **Smart Model Selection**: Use `sonnet` for balance of speed and quality
4. **Clear Instructions**: Be explicit about what agent should/shouldn't do
5. **Verification Steps**: Always include verification before code suggestions

### Skill Design

1. **Auto-Loading**: Skills should enhance, not replace agent capabilities
2. **Multi-Language**: Provide examples for common languages
3. **Practical Focus**: Real-world patterns, not academic theory
4. **Organized Content**: Clear headings, concise explanations
5. **Keep Updated**: Reflect current best practices

### Command Design

1. **Simple Interface**: Commands should have clear, simple syntax
2. **Delegate to Agents**: Commands should invoke agents, not duplicate logic
3. **User-Friendly**: Think about what users type naturally

## Contact

- **Author**: codeforges (cf)
- **License**: MIT
- **Repository**: rubenCodeforges/codeforges-claude-plugin

## References

- [Claude Code Plugin Docs](https://code.claude.com/docs/en/plugins)
- [Sub-agents Guide](https://code.claude.com/docs/en/sub-agents)
- [Marketplace Guide](https://code.claude.com/docs/en/plugin-marketplaces)
