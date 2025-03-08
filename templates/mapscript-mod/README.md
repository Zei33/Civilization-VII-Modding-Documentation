# Map Script Mod Template

This template demonstrates how to create a custom map script for Civilization VII. It includes a sample archipelago map generator with customizable parameters.

## Structure

- `mapscript-mod.modinfo`: The mod definition file
- `maps/scripts/custom_archipelago.lua`: The Lua script that generates the map
- `text/en_us/MapScriptText.xml`: Localization for the map script options

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your mod's unique name
2. Update the mod ID in the `.modinfo` file to something unique (e.g., "com.yourusername.yourmodname")
3. Modify the Lua script to create your custom map generation logic
4. Update the localization text as needed
5. Test your map script in-game

## How Map Scripts Work

Map scripts define how the game world is generated. They control:

1. **Terrain**: Land, water, mountains, etc.
2. **Features**: Forests, rainforests, marshes, etc.
3. **Resources**: Strategic, luxury, and bonus resources
4. **Starting Locations**: Where civilizations begin

The map script in this template demonstrates:
- Creating a world with multiple islands
- Customizing map generation through options (island size, count, etc.)
- Distributing terrain types and features
- Setting up player starting locations

## Map Script Options

This template includes examples of how to add custom options to your map script:

1. **Island Size**: Controls the size of generated islands
2. **Island Count**: Determines how many islands are created
3. **Sea Level**: Affects the land-to-water ratio

Players can select these options when starting a new game with your map script.

## Reference Documentation

For more information on map scripting, refer to:
- [Map Editing Guide](../map-editing.md) - For detailed information on map creation
- [Gameplay Modding Guide](../gameplay-modding.md) - For connecting map features to gameplay
- [Lua Scripting Examples](../advanced-topics.md#lua-scripting) - For more scripting techniques

## Tips

- Test your map script with different game settings and player counts
- Use print() statements to debug your script (viewable in game logs)
- Start with simple changes and gradually build complexity
- Consider different play styles when designing your map generation logic 