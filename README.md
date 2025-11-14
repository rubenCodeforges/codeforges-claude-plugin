# cf Dev Toolkit

[![Version](https://img.shields.io/badge/version-1.1.1-blue.svg)](https://github.com/rubenCodeforges/codeforges-claude-plugin)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://claude.com/claude-code)

**Make Claude Code production-ready. Get 8 specialized agents that understand complete context, verify before suggesting code, and never lose focus on complex tasks.**

---

## What This Does

Transforms Claude Code from a basic assistant into a **team of specialists**:

- 🔍 **Deep code analysis** without reading only 20 lines
- 🎯 **Stays focused** on multi-step tasks (no more losing track)
- ⚡ **Parallel execution** with separate context windows (no token overflow)
- ✅ **Verifies first** - checks actual code before suggesting changes
- 🚀 **Instant activation** - just talk naturally, agents trigger automatically

**Use Cases:** Bug investigation, performance optimization, refactoring, API mapping, dependency analysis, git history, website performance audits, codebase exploration.

---

## Quick Start

### 1. Install Plugin

```bash
/plugin marketplace add rubenCodeforges/codeforges-claude-plugin
/plugin install cf-dev-toolkit
```

### 2. Add to Claude Memory (Important!)

Click "Add to memory" or "Personalize" and add:

```
Use cf-dev-toolkit plugin agents for all development tasks.
Always prefer using specialized agents over direct analysis.
```

**Why this matters:** Without this, Claude might not automatically use agents. This memory instruction ensures agents activate proactively.

### 3. Optional: Web Performance Setup

The web-performance-agent works immediately with zero config. For faster runs:

```bash
cd ~/.claude/plugins/cf-dev-toolkit
./setup.sh
```

### 4. Start Using

Just talk naturally:
```
"Find where calculateTotal is used"
"Check performance of https://mysite.com"
"Bug in checkout form - users can't submit"
```

No @ needed. Agents activate automatically.

---

## What You Get

### 8 Specialized Agents

| Agent | What It Does | Triggers On |
|-------|-------------|-------------|
| **code-analyst** | Deep file analysis, smart reading for large files | "analyze", "review", "understand code" |
| **usage-finder** | Tracks function/class usage across entire codebase | "where used", "find usages", "what calls this" |
| **performance-analyzer** | Finds bottlenecks, N+1 queries, algorithmic issues | "slow", "performance", "optimize" |
| **web-performance-agent** | Lighthouse analysis for live websites (Core Web Vitals) | URLs, "page speed", "lighthouse" |
| **api-analyzer** | Maps all endpoints (Express, FastAPI, Django, Spring, Go) | "API routes", "endpoints", "map API" |
| **dependency-analyzer** | Security vulnerabilities, circular deps, bundle bloat | "dependencies", "npm audit", "security" |
| **git-analyzer** | Shows who wrote what, when, why | "git blame", "who wrote", "recent changes" |
| **code-scanner** | Project overview: structure, tech stack, patterns | "codebase structure", "project overview" |

**Key Features:**
- Separate context windows (no token overflow)
- Smart reading strategy (complete files < 1000 lines)
- Verification before code suggestions
- Automatic multi-agent coordination

### 4 Auto-Loading Skills
- **codebase-patterns** - Pattern recognition
- **refactoring-guide** - Refactoring techniques
- **performance-patterns** - Optimization strategies
- **web-performance-optimization** - Core Web Vitals, Lighthouse metrics

### 3 Quick Commands
- `/analyze-file <path>` - Deep file analysis
- `/scan-codebase` - Complete project scan
- `/check-web-perf` - Web performance toolkit diagnostics

---

## Real Examples

<details>
<summary><strong>Bug Investigation</strong></summary>

```
You: "Users can't submit payment form"

Claude automatically:
→ Analyzes checkout code (code-analyst)
→ Finds where payment methods are called (usage-finder)
→ Maps payment API endpoints (api-analyzer)
→ Shows recent changes to payment flow (git-analyzer)

Result: "Found missing error handling in CheckoutForm.jsx:45"
```
</details>

<details>
<summary><strong>Website Performance Audit</strong></summary>

```
You: "Check performance of https://myapp.com"

Claude automatically:
→ Runs Lighthouse audit (web-performance-agent)
→ Analyzes Core Web Vitals

Result:
"Performance: 65/100
- LCP: 3.2s (needs improvement)
- 2.3MB unoptimized images
- 850ms render-blocking CSS

Fix 1: Convert images to WebP
Fix 2: Defer non-critical CSS
[...specific code examples...]"
```
</details>

<details>
<summary><strong>Performance Optimization</strong></summary>

```
You: "Dashboard loads slowly"

Claude automatically:
→ Scans for bottlenecks (performance-analyzer)
→ Checks bundle size (dependency-analyzer)
→ Reviews component structure (code-analyst)

Result: "Found 3 issues:
1. N+1 query in getUserPosts()
2. Missing React.memo on DataTable
3. 300KB lodash import (use lodash-es)"
```
</details>

<details>
<summary><strong>Refactoring</strong></summary>

```
You: "UserService is too large, help me refactor"

Claude automatically:
→ Analyzes structure (code-analyst)
→ Maps all usages (usage-finder)
→ Shows dependencies (dependency-analyzer)

Result: "Split into 3 services:
- UserAuth (login, tokens, sessions)
- UserProfile (CRUD, preferences)
- UserNotifications (emails, push)"
```
</details>

---

## FAQ

<details>
<summary><strong>Agents not triggering automatically?</strong></summary>

**Solution 1: Add to Claude Memory**
```
Use cf-dev-toolkit plugin agents for all development tasks.
```

**Solution 2: Add to project CLAUDE.md**
Create `./CLAUDE.md` in your project:
```markdown
# cf-dev-toolkit Plugin

For all coding tasks, prefer using cf-dev-toolkit agents:
- Code analysis/review → code-analyst
- Finding usages → usage-finder
- Performance issues → performance-analyzer
- Web performance → web-performance-agent
- API mapping → api-analyzer
- Git history → git-analyzer
- Dependencies → dependency-analyzer
```

**Solution 3: Explicit invocation**
Use `@agent-name` to force a specific agent.
</details>

<details>
<summary><strong>Plugin disabled after update?</strong></summary>

After updating the plugin, it sometimes gets disabled. To fix:

```bash
# Check plugin status
/plugin list

# Re-enable if needed
/plugin enable cf-dev-toolkit

# Restart Claude Code
```

This is a known behavior - plugins may disable on update as a safety measure.
</details>

<details>
<summary><strong>Web performance agent fails?</strong></summary>

Run diagnostics:
```bash
/check-web-perf
```

Common fixes:
- Install Node.js 18+ if missing
- Run `./setup.sh` for optimal performance
- First npx run downloads ~50MB (then cached)
- Check internet connection for npx mode
</details>

<details>
<summary><strong>How do I customize agents?</strong></summary>

Edit `.md` files in the plugin directory:
```
~/.claude/plugins/cf-dev-toolkit/agents/*.md    # Agent behavior
~/.claude/plugins/cf-dev-toolkit/skills/*.md    # Knowledge base
~/.claude/plugins/cf-dev-toolkit/commands/*.md  # Slash commands
```

After editing, restart Claude Code.
</details>

<details>
<summary><strong>Can I use agents explicitly?</strong></summary>

Yes! Force a specific agent with `@`:

```bash
@code-analyst analyze src/components/Button.tsx
@usage-finder find usages of handleSubmit
@web-performance-agent analyze https://example.com
```
</details>

---

## Advanced

<details>
<summary><strong>Manual Installation</strong></summary>

```bash
git clone https://github.com/rubenCodeforges/codeforges-claude-plugin.git
cp -r codeforges-claude-plugin ~/.claude/plugins/cf-dev-toolkit
# Restart Claude Code
```
</details>

<details>
<summary><strong>Updating</strong></summary>

```bash
/plugin update cf-dev-toolkit
```

Check version: `/plugin list`

**Note:** Plugin may be disabled after update - re-enable with `/plugin enable cf-dev-toolkit`
</details>

---

## Changelog

**1.1.1** - Custom agent colors, improved triggers (rework/improve/check), FAQ section, memory instructions, better README
**1.1.0** - Web performance agent, Lighthouse integration, setup.sh installer, health check command
**1.0.0** - Initial release with 7 agents, 3 skills, 2 commands

---

## Contributing

We welcome improvements!

1. Fork the repo
2. Create feature branch
3. Follow guidelines in `CLAUDE.md`
4. Test in real projects
5. Submit PR

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## Resources

- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [Sub-agents Guide](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Report Issues](https://github.com/rubenCodeforges/codeforges-claude-plugin/issues)

---

**Version 1.1.1** • MIT License • By [codeforges](https://github.com/rubenCodeforges)
