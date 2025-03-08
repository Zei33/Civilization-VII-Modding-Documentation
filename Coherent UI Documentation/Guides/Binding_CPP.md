# C++ Binding

This guide explains how to use Coherent UI's C++ binding system to expose C++ objects and functions to JavaScript.

## Overview

Coherent UI provides a powerful binding mechanism that allows you to:

1. Call C++ functions from JavaScript
2. Access C++ object properties from JavaScript
3. Receive callbacks from JavaScript to C++
4. Communicate game state to the UI

This bidirectional communication bridge makes it easy to integrate your game logic with your UI.

## Creating a Binder

The first step is to create a `Binder` object, which is responsible for registering C++ objects and functions:

```cpp
#include <Coherent/UI/Binder.h>

// Create a binder
Coherent::UI::Binder binder;
```

## Binding Simple Types

### Binding Functions

You can bind simple C++ functions to make them callable from JavaScript:

```cpp
// C++ function to bind
void HelloWorld(const char* message) {
	std::cout << "Hello from JavaScript: " << message << std::endl;
}

// Bind the function
binder.Register("helloWorld", &HelloWorld);
```

From JavaScript, you can now call this function:

```javascript
// Call the C++ function from JavaScript
engine.helloWorld("This is JavaScript calling C++!");
```

### Binding Methods

You can also bind methods of a class:

```cpp
class GameController {
public:
	int GetScore() const {
		return m_Score;
	}
	
	void SetScore(int score) {
		m_Score = score;
	}
	
private:
	int m_Score = 0;
};

// Create an instance
GameController controller;

// Bind methods
binder.Register("getScore", &GameController::GetScore, &controller);
binder.Register("setScore", &GameController::SetScore, &controller);
```

In JavaScript:

```javascript
// Get the current score
var score = engine.getScore();

// Set a new score
engine.setScore(100);
```

## Binding Objects

You can expose entire C++ objects to JavaScript using the `RegisterObject` method:

```cpp
class Player {
public:
	Player(const std::string& name) : m_Name(name), m_Health(100), m_Level(1) {}
	
	const std::string& GetName() const { return m_Name; }
	int GetHealth() const { return m_Health; }
	int GetLevel() const { return m_Level; }
	
	void SetHealth(int health) { m_Health = health; }
	void LevelUp() { m_Level++; }
	
private:
	std::string m_Name;
	int m_Health;
	int m_Level;
};

// Create a player
Player player("Hero");

// Register the player object
binder.RegisterObject("player")
	.Property("name", &Player::GetName)
	.Property("health", &Player::GetHealth, &Player::SetHealth)
	.Property("level", &Player::GetLevel)
	.Method("levelUp", &Player::LevelUp)
	.Commit(&player);
```

In JavaScript:

```javascript
// Access properties
console.log("Player name: " + engine.player.name);
console.log("Health: " + engine.player.health);
console.log("Level: " + engine.player.level);

// Call methods
engine.player.levelUp();

// Set properties
engine.player.health = 75;
```

## Binding Arrays and Collections

You can bind C++ containers to JavaScript arrays:

```cpp
std::vector<int> scores = {100, 200, 300, 400, 500};

// Register the array
binder.Register("scores", scores);
```

In JavaScript:

```javascript
// Access array elements
for (var i = 0; i < engine.scores.length; i++) {
	console.log("Score " + i + ": " + engine.scores[i]);
}
```

## Receiving Events from JavaScript

You can register C++ functions as handlers for JavaScript events:

```cpp
void OnButtonClicked(const char* buttonId) {
	std::cout << "Button clicked: " << buttonId << std::endl;
}

// Register event handler
binder.Register("onButtonClicked", &OnButtonClicked);
```

In JavaScript:

```javascript
function handleButtonClick(id) {
	// Call the C++ handler
	engine.onButtonClicked(id);
}

// Attach to HTML buttons
document.getElementById("startButton").onclick = function() {
	handleButtonClick("start");
};
```

## Binding to a View

Once you've set up your binding, you need to attach it to a view:

```cpp
// Assuming you have a view
Coherent::UI::View* view = context->CreateView(info, L"coui://ui/main.html", listener);

// Bind to the view
view->BindingsReady += [&binder, &view](Coherent::UI::View* v) {
	binder.BindTo(v);
};
```

## Advanced Usage

### Type Conversions

Coherent UI automatically converts between equivalent C++ and JavaScript types:

| C++ Type | JavaScript Type |
|----------|----------------|
| bool | Boolean |
| int, short, long | Number |
| float, double | Number |
| char*, std::string | String |
| std::vector, std::array | Array |
| std::map, std::unordered_map | Object |

### Custom Types

For custom types, you need to register type descriptions:

```cpp
struct Vector3 {
	float x, y, z;
};

// Register type description
Coherent::UI::TypeDescription<Vector3> vecType;
vecType.Add("x", &Vector3::x);
vecType.Add("y", &Vector3::y);
vecType.Add("z", &Vector3::z);

binder.RegisterTypeDescription(vecType);

// Now you can use Vector3 in bindings
Vector3 position = {1.0f, 2.0f, 3.0f};
binder.Register("position", position);
```

### Event Objects

You can bind event objects to send structured data between C++ and JavaScript:

```cpp
// Define an event object
struct PlayerEvent {
	std::string playerName;
	int health;
	bool isAlive;
};

// Register the event object
Coherent::UI::TypeDescription<PlayerEvent> playerEventType;
playerEventType.Add("playerName", &PlayerEvent::playerName);
playerEventType.Add("health", &PlayerEvent::health);
playerEventType.Add("isAlive", &PlayerEvent::isAlive);

binder.RegisterTypeDescription(playerEventType);

// Register an event handler
void OnPlayerHit(const PlayerEvent& event) {
	std::cout << "Player " << event.playerName << " was hit. Health: " << event.health << std::endl;
}

binder.Register("onPlayerHit", &OnPlayerHit);
```

In JavaScript:

```javascript
// Create an event object
var playerEvent = {
	playerName: "Hero",
	health: 75,
	isAlive: true
};

// Send the event to C++
engine.onPlayerHit(playerEvent);
```

## Best Practices

1. **Use Proper Namespacing**: Organize your API by using JavaScript objects as namespaces.

   ```cpp
   binder.RegisterObject("game")
       .Method("start", &Game::Start)
       .Method("pause", &Game::Pause)
       .Commit(&gameInstance);
   
   binder.RegisterObject("game.player")
       .Property("health", &Player::GetHealth, &Player::SetHealth)
       .Commit(&playerInstance);
   ```

2. **Minimize Data Transfer**: Large data transfers between C++ and JavaScript can impact performance.

3. **Handle Errors**: Implement proper error handling in both C++ and JavaScript.

4. **Clean Up Resources**: Unregister bindings when they are no longer needed.

5. **Document Your API**: Clearly document the interface between C++ and JavaScript.

## See Also

- [JavaScript API](JavaScript_API.md)
- [Binding for .NET](Binding_NET.md)
- [Best Practices](Best_Practices.md)
- [C++ and JavaScript Binding Sample](../Samples/CPP_JS_Binding.md) 