# Code Analysis Toolkit Plugin

Comprehensive code analysis toolkit for Claude Code with 6 specialized sub-agents, 3 skills, and 2 slash commands.

## 🎯 What's Included

### Sub-Agents (6)
- **code-analyst** - Deep file analysis: architecture, patterns, dependencies, issues, recommendations
- **usage-finder** - Find all usages of functions, methods, classes across codebase
- **dependency-analyzer** - Analyze dependencies, detect circular deps, security vulnerabilities
- **performance-analyzer** - Identify bottlenecks, N+1 queries, inefficient algorithms
- **api-analyzer** - Map API endpoints, routes, HTTP methods across frameworks
- **git-analyzer** - Analyze git history, commits, contributors, blame

### Skills (3)
- **codebase-patterns** - Common patterns, anti-patterns, architectural conventions
- **refactoring-guide** - Practical refactoring techniques and when to apply them
- **performance-patterns** - Performance optimization patterns and bottlenecks

### Slash Commands (2)
- `/analyze-file` - Deep analysis of specific file with code-analyst
- `/scan-codebase` - Comprehensive project structure scan

## 📦 Installation

### Option 1: Direct Install (if published)
```bash
/plugin install code-analysis-toolkit
```

### Option 2: Manual Install
1. Download the `code-analysis-toolkit` folder
2. Copy to `~/.claude/plugins/` or `.claude/plugins/`
3. Restart Claude Code

## 🚀 Usage

### Automatic Invocation
Sub-agents trigger automatically based on your questions:
- "Analyze this file" → code-analyst
- "Where is this function used?" → usage-finder
- "Check for performance issues" → performance-analyzer
- "Map all API endpoints" → api-analyzer
- "Show dependency tree" → dependency-analyzer
- "Who wrote this code?" → git-analyzer

### Explicit Invocation
```bash
@code-analyst analyze src/components/Button.tsx
@usage-finder find usages of handleSubmit
@dependency-analyzer check for vulnerabilities
```

### Slash Commands
```bash
/analyze-file src/utils/api.ts
/scan-codebase
```

## 📚 Examples

### Deep File Analysis
```
User: Analyze src/services/AuthService.ts
Agent: @code-analyst [performs comprehensive analysis]
```

### Find Usage
```
User: Where is the validateEmail function used?
Agent: @usage-finder [searches across codebase]
```

### Performance Audit
```
User: Check for performance issues in this component
Agent: @performance-analyzer [identifies bottlenecks]
```

### API Documentation
```
User: Map all our API endpoints
Agent: @api-analyzer [generates API reference]
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

## 📊 Benefits

✅ **Context Management** - Each sub-agent has separate context window  
✅ **Specialized Expertise** - Purpose-built agents for specific tasks  
✅ **Auto-invocation** - Triggers based on description matching  
✅ **Comprehensive** - Covers analysis, performance, security, dependencies  
✅ **Multi-language** - Works with JS/TS, Python, Go, Java, etc.  

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

**Version**: 1.0.0  
**Author**: Custom  
**Requires**: Claude Code with sub-agent support
