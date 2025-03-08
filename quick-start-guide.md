# Quick Start Guide to Civilization VII Modding

This guide will walk you through the process of creating your first Civilization VII mod. By the end, you'll understand the basic workflow and be ready to create more complex mods.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Finding Your Mod Directory](#finding-your-mod-directory)
- [Creating Your First Mod](#creating-your-first-mod)
- [Building the Basic Mod Structure](#building-the-basic-mod-structure)
- [Creating the ModInfo File](#creating-the-modinfo-file)
- [Adding Database Modifications](#adding-database-modifications)
- [Testing Your Mod](#testing-your-mod)
- [Publishing Your Mod](#publishing-your-mod)
- [Next Steps](#next-steps)

## Prerequisites

Before you begin modding Civilization VII, you'll need:

- A copy of Civilization VII
- A text editor (like VS Code, Sublime Text, or Notepad++)
- Basic understanding of XML and SQL
- (Optional) Knowledge of HTML, CSS, and JavaScript for UI mods
- (Optional) Graphics editing software for asset creation

## Finding Your Mod Directory

Civilization VII looks for mods in a specific directory:

### Windows
```
C:\Users\{USER}\AppData\Local\Firaxis Games\Sid Meier's Civilization VII
```

### macOS
```
~/Library/Application Support/Civilization VII/Mods
```

## Creating Your First Mod

For this tutorial, we'll create a simple mod that increases the yield of coastal tiles.

1. Create a new folder in your Mods directory with a unique name, like `improved-coastal-yields`

2. Your folder structure should look like this:
```
improved-coastal-yields/
├── data/
│   └── coastal_yields.sql
└── improved-coastal-yields.modinfo
```

## Building the Basic Mod Structure

### Folder Structure

A typical mod contains these folders:

- `data/` - Contains SQL files for database modifications
- `ui/` - Contains UI customizations (HTML, CSS, JS)
- `art/` - Contains art assets
- `scripts/` - Contains custom Lua scripts

For our simple mod, we only need the `data/` directory.

## Creating the ModInfo File

The `.modinfo` file is an XML file that describes your mod to the game. Create a file named `improved-coastal-yields.modinfo` in your mod's root directory with the following content:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Mod id="com.example.improved-coastal-yields" version="1"
	xmlns="ModInfo">
	<Properties>
		<Name>Improved Coastal Yields</Name>
		<Description>This mod increases the yields of coastal tiles.</Description>
		<Authors>Your Name</Authors>
		<Package>Mod</Package>
	</Properties>
	<Dependencies>
		<Mod id="base-standard" title="LOC_MODULE_BASE_STANDARD_NAME"/>
	</Dependencies>
	<ActionCriteria>
		<Criteria id="always">
			<AlwaysMet></AlwaysMet>
		</Criteria>
	</ActionCriteria>
	<ActionGroups>
		<ActionGroup id="base-game-main" scope="game" criteria="always">
			<Properties>
				<LoadOrder>10</LoadOrder>
			</Properties>
			<Actions>
				<UpdateDatabase>
					<Item>data/coastal_yields.sql</Item>
				</UpdateDatabase>
			</Actions>
		</ActionGroup>
	</ActionGroups>
</Mod>
```

### Key Components of the ModInfo File:

- **Mod ID**: A unique identifier for your mod (usually in reverse domain notation)
- **Properties**: Basic information about your mod
- **Dependencies**: Other mods or game modules your mod requires
- **ActionCriteria**: Conditions for when actions should be performed
- **ActionGroups**: Groups of actions that your mod will perform
- **UpdateDatabase**: Specifies SQL files that will modify the game database

## Adding Database Modifications

Create a file named `coastal_yields.sql` in the `data/` directory with the following content:

```sql
-- Increase food yield on coast tiles
UPDATE Features SET Food = Food + 1 WHERE FeatureType = 'FEATURE_COAST';

-- Increase gold yield on coast tiles
UPDATE Features SET Gold = Gold + 1 WHERE FeatureType = 'FEATURE_COAST';
```

This SQL will increase both the food and gold yields of coastal tiles by 1.

## Testing Your Mod

1. Start Civilization VII
2. From the main menu, select "Additional Content"
3. Find your mod in the list and enable it
4. Start a new game and check that coastal tiles have higher yields

## Publishing Your Mod

Once your mod is tested and working, you can share it with others through:

1. **Steam Workshop**: The easiest way to distribute your mod
2. **CivFanatics**: The largest Civilization modding community
3. **GitHub/GitLab**: For more complex mods or collaborative projects

## Next Steps

Now that you've created your first mod, you can explore more complex modding:

- Learn about [Database Modding](./database-modding.md) to make deeper game changes
- Explore [UI Modding](./ui-modding.md) to customize the game interface
- Check out [Gameplay Modding](./gameplay-modding.md) to alter game rules

## Example templates

To help you get started with more complex mods, check out these template projects:

- [Basic Database Mod Template](./templates/basic-database-mod/) - A simple template for database modifications
- [UI Enhancement Mod Template](./templates/ui-enhancement-mod/) - A template for enhancing the game's UI
- [New Civilization Mod Template](./templates/new-civilization-mod/) - A template for creating a new civilization
- [Map Script Mod Template](./templates/mapscript-mod/) - A template for custom map generation scripts
- [Gameplay Balance Mod Template](./templates/gameplay-balance-mod/) - A template for gameplay balance changes
- [Custom Resource Mod Template](./templates/custom-resource-mod/) - A template for adding new resources
- [UI Lens Mod Template](./templates/ui-lens-mod/) - A template for creating custom map lenses

## Common Problems and Solutions

### Mod Not Appearing
- Ensure your `.modinfo` file is properly formatted
- Check that your mod directory is in the correct location

### Changes Not Taking Effect
- Verify your SQL syntax
- Make sure the database tables and columns you're modifying actually exist
- Check load order if you have multiple mods

### Game Crashes
- Look for error logs in your game directory
- Test modifying one thing at a time to isolate the issue

---

*Remember: Start small, test often, and build up your mod gradually!* 