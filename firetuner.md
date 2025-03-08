# FireTuner - A Powerful Debugging Tool for Civilization VII

FireTuner (also known as LiveTuner) is an advanced debugging and modding companion application that runs alongside Civilization VII. This tool was originally developed for Civilization VI but can be used with Civilization VII with some adaptations.

Find the original documentation [here](https://jonathanturnock.github.io/civ-vi-modding/docs/)

> **Note:** This documentation is based on the FireTuner functionality from Civilization VI, adapted for use with Civilization VII. While most functionality should work similarly, there may be some differences or limitations.

## Table of Contents
- [Overview](#overview)
- [Setting Up FireTuner](#setting-up-firetuner)
- [Basic Usage](#basic-usage)
- [Executing Commands](#executing-commands)
- [Autoplay Feature](#autoplay-feature)
- [Custom Panels](#custom-panels)
- [Advanced Features](#advanced-features)
- [Troubleshooting](#troubleshooting)

## Overview

FireTuner provides several powerful features for Civilization VII modders:

- **Live Code Execution**: Execute JavaScript (previously Lua in Civ VI) code directly in the running game
- **Real-time Game State Inspection**: View and modify game variables and state
- **Debug Panels**: Use specialized panels to access specific game functionality
- **Autoplay**: Run automated game sessions for testing purposes
- **Performance Analysis**: Assess mod performance in real-time

## Setting Up FireTuner

### Installation

FireTuner is included with the Civilization VI SDK, which is available via Steam:

1. In your Steam library, search for "Sid Meier's Civilization VI Development Tools"
2. Install these development tools
3. Launch the SDK and select "FireTuner" from the available tools

### Configuring Civilization VII

To enable FireTuner connectivity with Civilization VII:

1. Locate your game's AppOptions.txt file:
   - **Windows**: `\AppData\Local\Firaxis Games\Sid Meier's Civilization VII\AppOptions.txt`
   - **MacOS**: `~/Library/Application Support/Civilization VII/AppOptions.txt`
   - **Linux**: `~/.local/share/Civilization VII/AppOptions.txt`

2. Open the file in any text editor

3. Find the following line (it may be commented out with a semicolon):
   ```
   ;Enable FireTuner. 1 : Enable, 2: Disable, -1 : Default
   ;EnableTuner -1
   ```

4. Change it to:
   ```
   EnableTuner 1
   ```
   (Remember to remove the semicolon at the beginning)

5. It's recommended to run the game in windowed mode for easier interaction with FireTuner. Find:
   ```
   ;0 : windowed, 1 : fullscreen, 2 : windowed with no title bar
   FullScreen 1
   ```
   
   And change it to:
   ```
   FullScreen 0
   ```

6. Save the file and restart the game

## Basic Usage

### Connecting to the Game

1. Launch FireTuner from the SDK
2. Start Civilization VII
3. FireTuner should automatically connect to the game (you'll see "Connected" in the bottom left)
4. If the Lua/JS States dropdown menu is empty, go to Connection → Refresh Lua States
5. The menu should now allow you to choose between "App UI" or "Tuner" contexts (in the main menu, only "App UI" will be available)
6. Select "Tuner" context when in-game

### Console Interface

The FireTuner console provides:
- A command input area
- Output/results display
- Autocomplete functionality (press Tab while typing)
- History of previous commands

## Executing Commands

### Basic Command Execution

Type your JS/Lua commands in the input box and press Enter:

```
print("Hello World")
```

This will output "Hello World" to both the FireTuner console and the game's log files.

### Accessing Game Objects

FireTuner allows you to access and manipulate game objects:

```
// Get info about the current player
var player = Players[Game.GetLocalPlayer()];
print(player.GetCivilizationDescription());
```

### Command Autocomplete

Use the Tab key to access autocomplete suggestions while typing commands. This is particularly helpful for exploring available functions and objects.

## Autoplay Feature

The Autoplay feature is particularly useful for testing mods across multiple turns without manual interaction.

### Autoplay Commands

```
Autoplay.setObserveAsPlayer(1000)  // Observer with full vision (1000)
Autoplay.setReturnAsPlayer(0)      // Return as player 0 when finished
Autoplay.setActive(true)           // Start autoplay
Autoplay.setActive(false)          // End autoplay
```

Other available Autoplay commands:
- `setTurns` - Set number of turns to autoplay
- `setAsLocalPlayer` - Use the local player's visibility
- `setPause` - Pause autoplay

> **Note:** You must set a valid return player number with `setReturnAsPlayer()` before calling `setActive(true)`.

## Custom Panels

FireTuner supports custom debug panels, which are collections of UI elements backed by code.

### Using Existing Panels

1. From the File menu, select Open Panel
2. Navigate to: `\Steam\steamapps\common\Sid Meier's Civilization VII\Base\Platforms\Windows\Config\TunerPanels`
3. Select a panel file (`.ltp` extension)

> **Note:** Not all Civilization VI panels are fully compatible with Civilization VII. You may need to adapt them or use the console for certain functionality.

### Learning From Panels

Right-click on any panel element to view the underlying code. This can be an excellent way to learn how to access specific game functionality.

## Advanced Features

### Logging and Output Files

FireTuner output is saved to log files that can be inspected later:

- **Windows**: `\Documents\My Games\Civilization VII\Logs\`
- **MacOS**: `~/Library/Application Support/Civilization VII/Logs/`
- **Linux**: `~/.local/share/Civilization VII/Logs/`

Key log files include:
- `Lua.log` or `JS.log` - Script execution logs
- `FireTuner.log` - FireTuner-specific logs
- `Database.log` - Database operations

### Game State Inspection

FireTuner allows detailed inspection of the game state:

```
// Print all civs in the game
for (var i = 0; i < PlayerManager.GetWasEverAliveCount(); i++) {
    var player = Players[i];
    if (player && player.IsAlive()) {
        print(i + ": " + player.GetCivilizationDescription());
    }
}
```

## Troubleshooting

### Common Issues

1. **FireTuner shows "Not Connected"**
   - Ensure EnableTuner is set to 1 in AppOptions.txt
   - Restart both the game and FireTuner
   - Check FireTuner.log for connection errors

2. **Empty Lua/JS States dropdown**
   - Use Connection → Refresh Lua States while the game is running
   - Try switching between main menu and in-game

3. **Commands not working as expected**
   - Remember that Civilization VII uses JavaScript instead of Lua (used in Civ VI)
   - Check syntax differences between the two languages
   - Look for updated API documentation specific to Civilization VII

4. **Panels not loading or functioning**
   - Not all panels from Civilization VI are compatible with Civilization VII
   - Try using the console for direct command execution instead

### Getting Help

If you encounter issues with FireTuner:
- Check the official Civilization forums
- Post questions on CivFanatics community forums
- Check for updated documentation as more is learned about Civilization VII modding

## Related Documentation

- [Troubleshooting Guide](./troubleshooting.md)
- [Advanced Topics](./advanced-topics.md)
- [UI Modding](./ui-modding.md)
- [Gameplay Modding](./gameplay-modding.md) 