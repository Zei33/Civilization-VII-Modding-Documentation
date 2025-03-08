# C++ and JavaScript Binding Sample

This guide explains the C++ and JavaScript Binding sample included with Coherent UI, which demonstrates how to establish communication between your game code and UI.

## Overview

The Binding sample demonstrates:

1. Exposing C++ functions to JavaScript
2. Exposing C++ objects to JavaScript
3. Calling JavaScript functions from C++
4. Handling events between C++ and JavaScript
5. Binding complex data structures

## Sample Files

The sample includes the following key files:

- `BindingSample.cpp` - The main sample implementation
- `BindingSample.h` - Sample header file
- `GameState.h` - Game state class that is exposed to JavaScript
- `html/binding.html` - The HTML file with JavaScript code
- `html/binding.js` - JavaScript code for UI interaction

## Sample Setup

The sample sets up a simple game-like environment with:

- A player character with health, level, and experience properties
- Game statistics like score and time played
- Inventory system with items
- Game actions like attacking, healing, and leveling up

## C++ Implementation

### Game State Classes

The sample defines several classes to represent game state:

```cpp
// Player class
class Player {
public:
	Player() : m_Health(100), m_MaxHealth(100), m_Level(1), m_Experience(0) {}
	
	int GetHealth() const { return m_Health; }
	int GetMaxHealth() const { return m_MaxHealth; }
	int GetLevel() const { return m_Level; }
	int GetExperience() const { return m_Experience; }
	
	void SetHealth(int health) { m_Health = std::min(health, m_MaxHealth); }
	void GainExperience(int exp);
	void LevelUp();
	
private:
	int m_Health;
	int m_MaxHealth;
	int m_Level;
	int m_Experience;
};

// Inventory item
struct Item {
	std::string Name;
	std::string Type;
	int Value;
};

// Game state
class GameState {
public:
	GameState() : m_Score(0), m_TimePlayed(0) {}
	
	Player& GetPlayer() { return m_Player; }
	std::vector<Item>& GetInventory() { return m_Inventory; }
	
	int GetScore() const { return m_Score; }
	void AddScore(int points) { m_Score += points; }
	
	int GetTimePlayed() const { return m_TimePlayed; }
	void IncrementTime() { m_TimePlayed++; }
	
	void AddItem(const std::string& name, const std::string& type, int value);
	void RemoveItem(int index);
	
private:
	Player m_Player;
	std::vector<Item> m_Inventory;
	int m_Score;
	int m_TimePlayed;
};
```

### Setting Up the Binder

The sample creates a `Binder` object and registers the game state classes:

```cpp
void BindingSample::SetupBinding() {
	m_Binder = new Coherent::UI::Binder();
	
	// Register Item type
	Coherent::UI::TypeDescription<Item> itemType;
	itemType.Add("name", &Item::Name);
	itemType.Add("type", &Item::Type);
	itemType.Add("value", &Item::Value);
	m_Binder->RegisterTypeDescription(itemType);
	
	// Register Player object
	m_Binder->RegisterObject("player")
		.Property("health", &Player::GetHealth, &Player::SetHealth)
		.Property("maxHealth", &Player::GetMaxHealth)
		.Property("level", &Player::GetLevel)
		.Property("experience", &Player::GetExperience)
		.Method("levelUp", &Player::LevelUp)
		.Commit(&m_GameState.GetPlayer());
	
	// Register inventory
	m_Binder->Register("inventory", m_GameState.GetInventory());
	
	// Register game state
	m_Binder->RegisterObject("game")
		.Property("score", &GameState::GetScore)
		.Method("addScore", &GameState::AddScore)
		.Property("timePlayed", &GameState::GetTimePlayed)
		.Commit(&m_GameState);
	
	// Register functions
	m_Binder->Register("addItem", [this](const char* name, const char* type, int value) {
		m_GameState.AddItem(name, type, value);
		UpdateUI();
	});
	
	m_Binder->Register("removeItem", [this](int index) {
		m_GameState.RemoveItem(index);
		UpdateUI();
	});
	
	m_Binder->Register("attackEnemy", [this](int damage) {
		// Simulate enemy attack
		Player& player = m_GameState.GetPlayer();
		player.SetHealth(player.GetHealth() - damage);
		m_GameState.AddScore(damage * 10);
		
		// Gain experience
		player.GainExperience(damage * 5);
		
		UpdateUI();
		
		return player.GetHealth() > 0;  // Return if player is still alive
	});
}
```

### Binding to the View

The sample attaches the binder to the view when the view is ready:

```cpp
void BindingSample::ViewReady(Coherent::UI::View* view) {
	BaseSample::ViewReady(view);
	
	// Bind to the view
	view->BindingsReady += [this](Coherent::UI::View* v) {
		m_Binder->BindTo(v);
		UpdateUI();
	};
}
```

### Updating the UI

To keep the UI in sync with the game state, the sample calls a JavaScript function:

```cpp
void BindingSample::UpdateUI() {
	if (m_View) {
		m_View->TriggerEvent("updateUI");
	}
}
```

## JavaScript Implementation

### HTML Structure

The sample HTML creates a simple game UI:

```html
<!DOCTYPE html>
<html>
<head>
	<title>Coherent UI - Binding Sample</title>
	<link rel="stylesheet" href="binding.css">
	<script src="binding.js"></script>
</head>
<body>
	<div class="game-ui">
		<div class="player-stats">
			<h2>Player Stats</h2>
			<div class="stat-row">
				<span>Health:</span>
				<div class="health-bar">
					<div id="health-fill"></div>
				</div>
				<span id="health-text">100/100</span>
			</div>
			<div class="stat-row">
				<span>Level:</span>
				<span id="level">1</span>
			</div>
			<div class="stat-row">
				<span>Experience:</span>
				<div class="xp-bar">
					<div id="xp-fill"></div>
				</div>
				<span id="xp-text">0/100</span>
			</div>
		</div>
		
		<div class="game-stats">
			<h2>Game Stats</h2>
			<div class="stat-row">
				<span>Score:</span>
				<span id="score">0</span>
			</div>
			<div class="stat-row">
				<span>Time Played:</span>
				<span id="time-played">0</span>
			</div>
		</div>
		
		<div class="game-actions">
			<h2>Actions</h2>
			<button id="attack-btn">Attack Enemy</button>
			<button id="heal-btn">Heal</button>
			<button id="level-up-btn">Level Up</button>
		</div>
		
		<div class="inventory">
			<h2>Inventory</h2>
			<div id="inventory-items"></div>
			<div class="inventory-actions">
				<button id="add-item-btn">Add Random Item</button>
			</div>
		</div>
	</div>
</body>
</html>
```

### JavaScript Code

The JavaScript code interacts with the C++ bindings:

```javascript
// Initialize when the document is ready
document.addEventListener('DOMContentLoaded', function() {
	// Set up event handlers
	document.getElementById('attack-btn').addEventListener('click', attackEnemy);
	document.getElementById('heal-btn').addEventListener('click', healPlayer);
	document.getElementById('level-up-btn').addEventListener('click', levelUpPlayer);
	document.getElementById('add-item-btn').addEventListener('click', addRandomItem);
	
	// Register event handler for UI updates
	engine.on('updateUI', updateUI);
	
	// Initial UI update
	updateUI();
});

// Attack an enemy
function attackEnemy() {
	// Random damage between 5 and 15
	var damage = Math.floor(Math.random() * 11) + 5;
	
	// Call C++ function to handle attack logic
	var isAlive = engine.attackEnemy(damage);
	
	// Show message
	showMessage('You attacked an enemy for ' + damage + ' damage!');
	
	if (!isAlive) {
		showMessage('Game Over! You died!', true);
	}
}

// Heal the player
function healPlayer() {
	// Heal for 20 points
	var newHealth = Math.min(engine.player.health + 20, engine.player.maxHealth);
	engine.player.health = newHealth;
	
	// Show message
	showMessage('You healed for 20 health!');
	
	// Update UI
	updateUI();
}

// Level up the player
function levelUpPlayer() {
	// Call C++ method to level up
	engine.player.levelUp();
	
	// Show message
	showMessage('Level up! You are now level ' + engine.player.level);
	
	// Update UI
	updateUI();
}

// Add a random item to inventory
function addRandomItem() {
	// Generate random item
	var types = ['Weapon', 'Armor', 'Potion', 'Scroll'];
	var names = ['Iron', 'Steel', 'Golden', 'Magic', 'Ancient', 'Cursed'];
	var items = ['Sword', 'Shield', 'Helmet', 'Amulet', 'Ring', 'Staff'];
	
	var type = types[Math.floor(Math.random() * types.length)];
	var name = names[Math.floor(Math.random() * names.length)] + ' ' + 
		items[Math.floor(Math.random() * items.length)];
	var value = Math.floor(Math.random() * 100) + 1;
	
	// Call C++ function to add item
	engine.addItem(name, type, value);
	
	// Show message
	showMessage('Added ' + name + ' to inventory');
}

// Update UI to reflect current game state
function updateUI() {
	// Update player stats
	var healthPercent = (engine.player.health / engine.player.maxHealth) * 100;
	document.getElementById('health-fill').style.width = healthPercent + '%';
	document.getElementById('health-text').textContent = 
		engine.player.health + '/' + engine.player.maxHealth;
	
	document.getElementById('level').textContent = engine.player.level;
	
	var xpRequired = engine.player.level * 100;
	var xpPercent = (engine.player.experience / xpRequired) * 100;
	document.getElementById('xp-fill').style.width = xpPercent + '%';
	document.getElementById('xp-text').textContent = 
		engine.player.experience + '/' + xpRequired;
	
	// Update game stats
	document.getElementById('score').textContent = engine.game.score;
	document.getElementById('time-played').textContent = engine.game.timePlayed + 's';
	
	// Update inventory
	var inventoryEl = document.getElementById('inventory-items');
	inventoryEl.innerHTML = '';
	
	if (engine.inventory.length === 0) {
		inventoryEl.innerHTML = '<div class="empty-inventory">No items</div>';
	} else {
		for (var i = 0; i < engine.inventory.length; i++) {
			var item = engine.inventory[i];
			var itemEl = document.createElement('div');
			itemEl.className = 'inventory-item';
			itemEl.innerHTML = 
				'<div class="item-name">' + item.name + '</div>' +
				'<div class="item-type">' + item.type + '</div>' +
				'<div class="item-value">' + item.value + '</div>' +
				'<button class="remove-btn" data-index="' + i + '">Remove</button>';
			inventoryEl.appendChild(itemEl);
		}
		
		// Add remove button handlers
		var removeButtons = document.querySelectorAll('.remove-btn');
		for (var j = 0; j < removeButtons.length; j++) {
			removeButtons[j].addEventListener('click', function(e) {
				var index = parseInt(e.target.getAttribute('data-index'));
				engine.removeItem(index);
			});
		}
	}
}

// Show a message to the user
function showMessage(message, isError) {
	var messageEl = document.createElement('div');
	messageEl.className = 'message' + (isError ? ' error' : '');
	messageEl.textContent = message;
	
	document.body.appendChild(messageEl);
	
	// Remove after 3 seconds
	setTimeout(function() {
		messageEl.classList.add('fade-out');
		setTimeout(function() {
			document.body.removeChild(messageEl);
		}, 500);
	}, 3000);
}
```

## Running the Sample

To run the sample:

1. Build and run the Binding sample application
2. The sample will create a window showing the game UI
3. Interact with the UI to see the C++ and JavaScript communication in action
4. Use the Coherent UI Debugger to inspect the JavaScript and see the bindings

## Key Takeaways

1. **Bidirectional Communication**: The sample shows how to establish two-way communication between C++ and JavaScript.

2. **Object Binding**: Complex C++ objects can be exposed to JavaScript with properties and methods.

3. **Collections**: C++ collections like vectors can be exposed as JavaScript arrays.

4. **Event Handling**: Events can be triggered in both directions to notify about state changes.

5. **Type Descriptions**: Custom C++ types can be described for JavaScript interaction.

## See Also

- [C++ Binding Guide](../Guides/Binding_CPP.md)
- [JavaScript API](../Guides/JavaScript_API.md)
- [Binder API](../API%20Reference/Binder.md)
- [TypeDescription API](../API%20Reference/TypeDescription.md) 