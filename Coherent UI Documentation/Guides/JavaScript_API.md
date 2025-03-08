# JavaScript API

This guide explains the JavaScript API provided by Coherent UI, which allows web content to interact with your game.

## Overview

Coherent UI provides a JavaScript API that enables communication between your HTML/JavaScript UI and your game code. This API allows you to:

1. Call functions bound from C++/C#
2. Access properties and objects exposed by your game
3. Listen for events triggered by the game
4. Trigger events for the game to handle

## The `engine` Object

The main entry point for the JavaScript API is the global `engine` object, which is automatically injected into every view. This object provides access to all the functionality exposed by your game.

```javascript
// Check if the engine is ready
if (engine) {
	console.log("Coherent UI engine is available");
}
```

## Calling C++ Functions

Functions that you've registered from C++ (using the `Binder` class) can be called directly from JavaScript:

```javascript
// Call a C++ function
engine.startGame();

// Call a C++ function with parameters
engine.playerAttack("enemy1", 50);

// Call a C++ function with a callback
engine.loadLevel("level3", function(success) {
	if (success) {
		console.log("Level loaded successfully");
	} else {
		console.log("Failed to load level");
	}
});
```

## Accessing Game Objects

Objects that you've registered from C++ can be accessed as JavaScript objects:

```javascript
// Access player properties
var health = engine.player.health;
var name = engine.player.name;

// Modify player properties
engine.player.health = 75;

// Call player methods
engine.player.levelUp();
```

## Arrays and Collections

C++ arrays and collections are exposed as JavaScript arrays:

```javascript
// Iterate through a collection of enemies
for (var i = 0; i < engine.enemies.length; i++) {
	var enemy = engine.enemies[i];
	console.log("Enemy: " + enemy.name + ", Health: " + enemy.health);
}

// Add an item to inventory (if the C++ side supports it)
engine.inventory.push({
	name: "Health Potion",
	type: "Consumable",
	value: 50
});
```

## Event Handling

Coherent UI supports bidirectional event handling between C++ and JavaScript:

### Listening for Game Events

You can listen for events triggered by the game using the `on` method:

```javascript
// Listen for a player health changed event
engine.on("playerHealthChanged", function(health, maxHealth) {
	updateHealthBar(health, maxHealth);
});

// Listen for a game state change
engine.on("gameStateChanged", function(newState) {
	switch (newState) {
		case "playing":
			showGameUI();
			break;
		case "paused":
			showPauseMenu();
			break;
		case "gameover":
			showGameOverScreen();
			break;
	}
});
```

### Triggering Events for the Game

You can trigger events that C++ code can listen for using the `trigger` method:

```javascript
// Trigger an event when a button is clicked
document.getElementById("startButton").addEventListener("click", function() {
	engine.trigger("startButtonClicked");
});

// Trigger an event with parameters
function selectCharacter(characterId) {
	engine.trigger("characterSelected", characterId);
}

// Trigger an event with a complex object
function submitPlayerSettings(settings) {
	engine.trigger("playerSettingsChanged", {
		difficulty: settings.difficulty,
		controls: settings.controls,
		audioVolume: settings.audioVolume,
		videoSettings: settings.videoSettings
	});
}
```

## Handling Ready State

When a view is loaded, you should wait for the engine to be ready before interacting with it:

```javascript
document.addEventListener("DOMContentLoaded", function() {
	// Check if engine is already ready
	if (engine.isReady) {
		initialize();
	} else {
		// Wait for engine to be ready
		engine.on("ready", initialize);
	}
});

function initialize() {
	// Now it's safe to interact with the engine
	engine.on("gameStateChanged", handleGameStateChange);
	
	// Load initial game state
	var gameState = engine.getGameState();
	updateUI(gameState);
}
```

## Debugging

Coherent UI provides debugging utilities in the JavaScript console:

```javascript
// Print all available engine methods and properties
console.log(engine);

// Check if a specific function exists
if (typeof engine.startGame === "function") {
	console.log("startGame function is available");
}

// Debug event handling
engine.on("*", function(eventName, ...args) {
	console.log("Event received: " + eventName, args);
});
```

## Working with File Downloads

Coherent UI allows downloading files through JavaScript:

```javascript
// Trigger a file download
engine.trigger("downloadRequested", "screenshot.jpg");

// Listen for download progress
engine.on("downloadProgress", function(filename, progress, total) {
	var percent = (progress / total) * 100;
	updateProgressBar(percent);
});

// Listen for download completion
engine.on("downloadCompleted", function(filename, success) {
	if (success) {
		showDownloadComplete(filename);
	} else {
		showDownloadFailed(filename);
	}
});
```

## Advanced Usage

### Custom Event Objects

You can use custom event objects for more structured communication:

```javascript
// Define a custom event object
var gameEvent = {
	type: "combat",
	attacker: {
		id: 1,
		name: "Player"
	},
	target: {
		id: 5,
		name: "Dragon"
	},
	damage: 25,
	isCritical: true
};

// Trigger the event with the custom object
engine.trigger("gameEvent", gameEvent);
```

### Promises

You can wrap C++ callbacks in promises for more modern JavaScript code:

```javascript
// Create a promise wrapper for a C++ function
function loadLevelAsync(levelName) {
	return new Promise(function(resolve, reject) {
		engine.loadLevel(levelName, function(success, errorMessage) {
			if (success) {
				resolve();
			} else {
				reject(new Error(errorMessage));
			}
		});
	});
}

// Use with async/await
async function changeLevel(levelName) {
	try {
		await loadLevelAsync(levelName);
		showLevelIntro(levelName);
	} catch (error) {
		showErrorMessage("Failed to load level: " + error.message);
	}
}
```

### Custom Protocols

You can use custom protocols to load resources through your game's file system:

```javascript
// Load an image from the game's file system
var img = new Image();
img.src = "coui://textures/ui/button.png";
document.body.appendChild(img);

// Load an HTML template
fetch("coui://templates/inventory-item.html")
	.then(response => response.text())
	.then(html => {
		var template = document.createElement("template");
		template.innerHTML = html;
		return template.content.cloneNode(true);
	})
	.then(node => {
		document.getElementById("inventory").appendChild(node);
	});
```

## Best Practices

1. **Wait for the Engine**: Always check that the engine is ready before using it.

2. **Error Handling**: Implement proper error handling for C++ function calls.

3. **Event Naming**: Use consistent naming conventions for events.

4. **Data Validation**: Validate data before sending it to C++.

5. **Performance**: Minimize the amount of data passed between C++ and JavaScript.

6. **Modularity**: Organize your JavaScript code into reusable modules.

7. **Documentation**: Document the API exposed by your game for your UI developers.

## Common Issues

### Engine Not Available

If the `engine` object is not available, it could be due to:
- The view is not fully loaded
- There's an error in the C++ initialization
- The URL is being loaded outside of Coherent UI

### Function Not Found

If a function you're trying to call doesn't exist, check:
- The function was properly registered in C++
- The function name is spelled correctly
- The C++ binding was completed successfully

### Event Not Firing

If an event doesn't fire as expected, check:
- The event name matches between C++ and JavaScript
- The event listener was registered before the event was triggered
- There are no errors in the event callback

### Type Conversion Issues

If data doesn't transfer correctly between C++ and JavaScript, check:
- The C++ and JavaScript types are compatible
- Complex objects have proper type descriptions registered
- Array indices and object property names match

## See Also

- [C++ Binding](Binding_CPP.md)
- [.NET Binding](Binding_NET.md)
- [Binder API](../API%20Reference/Binder.md)
- [C++ and JavaScript Binding Sample](../Samples/CPP_JS_Binding.md) 