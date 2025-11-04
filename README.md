# Claude Code Plugin Load Timing Issue - Marketplace

## Purpose

This repository serves as a minimal Claude Code plugin marketplace designed to reproduce a plugin load timing bug. It contains a single demonstration plugin that exposes asynchronous marketplace loading behavior affecting SessionStart hooks.

## Repository Role

This marketplace repository provides the plugin that the [demonstration repository](https://github.com/example/sessionstart-hook-demo) references. When Claude Code loads an external marketplace, the plugin registration occurs asynchronously, which can prevent SessionStart hooks from executing on the first run.

## Plugin Structure

```
marketplace/
├── .claude-plugin/
│   └── marketplace.json                              # Marketplace definition
└── sessionstart-hook-demonstration/
    ├── .claude-plugin/
    │   └── plugin.json                               # Plugin metadata
    ├── hooks/
    │   └── hooks.json                                # SessionStart hook configuration
    └── scripts/
        └── create-file.sh                            # Hook execution script
```

### Key Files

**marketplace.json**
- Defines the marketplace name: `sessionstart-demo-marketplace`
- Registers the `sessionstart-hook-demonstration` plugin
- Points to the local plugin directory

**plugin.json**
- Plugin name: `sessionstart-hook-demonstration`
- Version: 1.0.0
- Purpose: Creates SESSION_START_HOOK_COMPLETE file at session start

**hooks.json**
- Configures a SessionStart hook
- Executes command: `${CLAUDE_PLUGIN_ROOT}/scripts/create-file.sh`
- Uses the CLAUDE_PLUGIN_ROOT variable to reference the plugin directory

**create-file.sh**
- Creates `/workspace/SESSION_START_HOOK_COMPLETE` file if it does not exist
- Writes timestamp of hook execution
- Provides console feedback on creation status

## SessionStart Hook Behavior

The plugin implements a SessionStart hook that should execute when Claude Code initializes. The hook runs a bash script that:

1. Checks if `/workspace/SESSION_START_HOOK_COMPLETE` exists
2. If absent, creates the file with execution timestamp
3. If present, logs that the file already exists

This simple behavior provides clear evidence of whether the SessionStart hook executed successfully.

## The Bug

**Expected Behavior**: The SessionStart hook should execute when Claude Code starts, creating the SESSION_START_HOOK_COMPLETE file on the first run.

**Actual Behavior**: On the first run in a fresh environment, the file is not created. The marketplace loads asynchronously, and the plugin is not registered before the SessionStart event fires. On the second run, the marketplace has already loaded, the plugin is registered, and the hook executes successfully.

This timing issue means that SessionStart hooks in marketplace plugins are unreliable for first-run initialization tasks.

## Usage

This marketplace is referenced by the demonstration repository through the `.claude-plugins` configuration file:

```json
{
  "marketplaces": [
    {
      "name": "plugin-load-timing",
      "source": "file:///workspace/marketplace"
    }
  ],
  "plugins": {
    "plugin-load-timing": {
      "plugins": [
        "sessionstart-hook-demonstration"
      ]
    }
  }
}
```

The demonstration repository provides the complete reproduction environment and test scripts.

## Reference

For the complete bug demonstration, reproduction steps, and testing instructions, see the [main demonstration repository](https://github.com/example/sessionstart-hook-demo) and its README.

## Technical Details

- Marketplace ID: `plugin-load-timing`
- Plugin ID: `sessionstart-hook-demonstration`
- Hook Type: SessionStart
- Target File: `/workspace/SESSION_START_HOOK_COMPLETE`
- Claude Code Version: Affects current versions with asynchronous marketplace loading
