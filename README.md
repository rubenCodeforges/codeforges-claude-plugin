# cf Dev Toolkit

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/rubenCodeforges/codeforges-claude-plugin)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://claude.com/claude-code)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**Daily development workflow toolkit that makes Claude Code stay focused and understand your complete codebase.**

## 🎯 The Problem This Solves

Plain Claude Code often:
- 🔴 **Reads only 20-30 lines** and misses the full picture
- 🔴 **Loses focus** on complex multi-step tasks
- 🔴 **Burns through context** trying to understand large files
- 🔴 **Makes assumptions** about method signatures without checking
- 🔴 **Gets overwhelmed** by 80% of real-world development tasks

## ✨ The Solution

This toolkit adds **specialized sub-agents** that:
- ✅ **Understand complete context** without context overflow
- ✅ **Stay focused** - each agent has one job and does it well
- ✅ **Work in parallel** - separate context windows reduce token usage
- ✅ **Verify before suggesting** - checks actual signatures, not assumptions
- ✅ **Trigger automatically** - just describe your problem naturally

**Result:** Claude Code that actually helps with complex daily tasks instead of making a mess.

## 🛠️ What's Included

### Specialized Sub-Agents
Each agent automatically triggers based on your task:

- **code-analyst** - Analyzes files strategically (smart reading for large files), checks actual signatures before suggesting code
- **usage-finder** - Tracks where functions/classes are used across the entire codebase
- **dependency-analyzer** - Analyzes dependencies, detects circular deps, finds security vulnerabilities
- **performance-analyzer** - Identifies bottlenecks, N+1 queries, algorithmic issues with concrete fixes
- **api-analyzer** - Maps all API endpoints across frameworks (Express, FastAPI, Django, Spring, Go)
- **git-analyzer** - Shows who wrote what, when, and why - complete code evolution
- **code-scanner** - Gives project overview: structure, tech stack, organization patterns

### Auto-Loading Skills
Knowledge that enhances responses automatically:

- **codebase-patterns** - Recognizes common patterns and anti-patterns in your code
- **refactoring-guide** - Practical refactoring techniques with before/after examples
- **performance-patterns** - Performance optimization strategies across languages

### Quick Commands
- `/analyze-file <path>` - Deep file analysis
- `/scan-codebase` - Complete project overview
- `/map-class-usage <ClassName>` - Build comprehensive usage map for a class

## 📦 Installation

### From GitHub (Recommended)
```bash
/plugin marketplace add rubenCodeforges/codeforges-claude-plugin
/plugin install cf-dev-toolkit
```

### Manual Install
1. Clone: `git clone git@github.com:rubenCodeforges/codeforges-claude-plugin.git`
2. Copy to: `~/.claude/plugins/cf-dev-toolkit`
3. Restart Claude Code

### ⚡ Boost Agent Activation (Recommended)

For even better automatic triggering, add this to `~/.claude/CLAUDE.md` (global) or `./CLAUDE.md` (project-level):

```markdown
# cf-dev-toolkit Plugin

For all coding tasks, prefer using cf-dev-toolkit agents:
- Code analysis/review → use code-analyst agent
- Finding usages/references → use usage-finder agent
- Codebase overview → use code-scanner agent
- Performance issues → use performance-analyzer agent
- API/endpoint mapping → use api-analyzer agent
- Git history/authorship → use git-analyzer agent
- Dependency analysis → use dependency-analyzer agent

These agents have separate context windows and prevent context overflow.
```

**Why this helps:**
- Reinforces agent selection for Claude
- Ensures agents trigger even for ambiguous queries
- Optional but recommended for best experience

## 🚀 Usage

### Just Talk Naturally (Recommended)

**No @ needed!** Just describe your problem and Claude automatically uses the right agents:

```
You: "A bug was reported in the checkout form"
→ Claude automatically uses code-analyst, usage-finder, git-analyzer

You: "Check for performance issues in the dashboard"
→ Claude automatically uses performance-analyzer

You: "Where is calculateTotal used?"
→ Claude automatically uses usage-finder

You: "Map all API endpoints"
→ Claude automatically uses api-analyzer

You: "Show me the dependency tree"
→ Claude automatically uses dependency-analyzer
```

**How it works:**
- Agents trigger based on your natural language
- No need to remember which agent does what
- Multiple agents work together automatically
- Each agent has its own context window (reduces token usage)

### Advanced: Explicit Agent Invocation (Optional)

Only use @ when you want to force a specific agent:

```bash
@code-analyst analyze src/components/Button.tsx
@usage-finder find usages of handleSubmit
@performance-analyzer check this specific file
```

### Quick Commands

```bash
/analyze-file src/utils/api.ts       # Deep file analysis
/scan-codebase                        # Complete project scan
/map-class-usage UserService          # Build usage map for a class
```

## 📚 Real-World Examples

### Bug Investigation
```
You: "Users can't submit the payment form. Error in checkout flow."

Claude (automatically):
✓ Analyzes checkout form code (code-analyst)
✓ Traces payment submission usage (usage-finder)
✓ Maps payment API endpoints (api-analyzer)
✓ Shows recent changes (git-analyzer)
✓ Checks for performance issues (performance-analyzer)

Result: "Found missing error handling in CheckoutForm.jsx:45..."
```

### Feature Development
```
You: "I need to add pagination to the users list"

Claude (automatically):
✓ Analyzes current implementation (code-analyst)
✓ Finds similar patterns in codebase (usage-finder)
✓ Checks API pagination support (api-analyzer)
✓ Loads pagination best practices (skills)

Result: "Here's how to implement pagination following your project's patterns..."
```

### Performance Optimization
```
You: "Dashboard is loading slowly"

Claude (automatically):
✓ Scans for bottlenecks (performance-analyzer)
✓ Checks bundle size (dependency-analyzer)
✓ Reviews component structure (code-analyst)
✓ Shows recent changes (git-analyzer)

Result: "Found 3 issues: N+1 queries, missing React.memo, large imports..."
```

### Refactoring
```
You: "Help me refactor UserService - it's too large"

Claude (automatically):
✓ Analyzes structure (code-analyst)
✓ Maps all usages (usage-finder)
✓ Shows dependencies (dependency-analyzer)
✓ Loads refactoring patterns (skills)

Result: "Split into 3 services: UserAuth, UserProfile, UserNotifications..."
```

## 🎓 Skills Auto-Load

Skills automatically enhance responses when relevant:
- Discussing architecture → `codebase-patterns` loads
- Talking refactoring → `refactoring-guide` loads
- Discussing performance → `performance-patterns` loads

## 🛠️ Customization

Edit any `.md` file in the plugin to customize behavior:
- `agents/*.md` - Sub-agent prompts and tools
- `skills/*.md` - Knowledge that auto-loads
- `commands/*.md` - Slash command definitions

## 📊 Why This Works

### The Technical Advantage

**Separate Context Windows**
Each agent operates independently, so:
- Main conversation doesn't get polluted with analysis details
- Can handle massive codebases without token overflow
- Multiple agents work in parallel

**Smart Reading Strategy**
- Files < 1000 lines: Read completely
- Files > 1000 lines: Strategic reading (imports, exports, key sections) + targeted Grep
- No more "I only read 30 lines" problems

**Proactive Triggering**
Agents have `MUST BE USED` and `USE PROACTIVELY` keywords that Claude respects:
- You say "bug in checkout" → agents automatically investigate
- No need to remember which agent does what
- Works like having a team of specialists

**Verification First**
Agents are instructed to:
- Check actual method signatures before suggesting code
- Read implementations, not make assumptions
- Provide accurate, tested recommendations

### Real Impact

| Without Plugin | With cf-dev-toolkit |
|---------------|---------------------|
| Reads 20-30 lines, misses context | Understands complete picture |
| Gets lost on complex tasks | Stays focused with specialized agents |
| Burns context on large files | Smart reading + separate contexts |
| Assumes method signatures | Verifies before suggesting |
| You fix Claude's mistakes | Claude provides accurate help |

## 🤝 Contributing

To improve this plugin:
1. Edit the relevant `.md` files
2. Test in your projects
3. Share improvements back

## 📝 License

MIT - Use freely, modify as needed

## 🔗 Related

- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [Sub-agents Guide](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Plugin System](https://www.anthropic.com/news/claude-code-plugins)

---

**Version**: 1.1.0
**Author**: codeforges (cf)
**Requires**: Claude Code with sub-agent support
