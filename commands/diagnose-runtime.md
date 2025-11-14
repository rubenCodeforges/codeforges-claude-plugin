# Diagnose Runtime Issues

Quickly diagnose runtime performance issues in web applications including freezes, hangs, memory leaks, and slow performance.

## What to analyze

Please specify what you need to diagnose:

1. **Provide the URL**: The web application URL to analyze
2. **Describe symptoms** (optional):
   - App freezes or becomes unresponsive
   - High memory usage or memory leaks
   - Slow performance or laggy interactions
   - Browser tab crashes
   - Specific user actions that trigger issues
3. **Authentication** (if needed): Provide auth token or credentials

## Analysis approach

I'll use the web-performance-agent to:

1. **Quick Diagnosis**: Rapid scan for common issues
   - Memory leaks
   - Main thread blocking
   - Network bottlenecks
   - JavaScript errors

2. **Framework Detection**: Identify and apply framework-specific debugging
   - Angular: Zone.js and change detection issues
   - React: Re-render and state management problems
   - Vue: Reactive system and watcher issues

3. **Deep Analysis** (if needed):
   - CPU profiling to find hot functions
   - Heap snapshots for memory analysis
   - Network request monitoring
   - Long task detection

4. **Provide Solutions**:
   - Immediate fixes to try
   - Code examples for optimization
   - Architecture recommendations
   - Best practices to follow

## Example usage

```
/diagnose-runtime https://example.com/app
```

Or with more details:
```
/diagnose-runtime https://example.com/app "The app freezes after clicking the submit button"
```

Or with authentication:
```
/diagnose-runtime https://example.com/app "token: abc123xyz"
```

## What I'll provide

- **Root cause analysis** of the performance issue
- **Evidence** with metrics and measurements
- **Immediate actions** to resolve the problem
- **Long-term solutions** for prevention
- **Specific code fixes** when applicable

Let's diagnose your runtime performance issues!