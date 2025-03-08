# New Civilization Mod Template

This template provides a starting point for creating a new custom civilization for Civilization VII, complete with a unique leader, traits, abilities, unit, and building.

## Structure

- `new-civilization-mod.modinfo`: The mod definition file
- `data/civilization.sql`: SQL definitions for the civilization, leader, traits, etc.
- `text/en_us/Localization.xml`: Localized text strings for all civilization elements
- `art/icons/`: Directory for all required art assets (includes sample icons for civilization, leader, unit, and building)
- `ui/`: Directory for any custom UI components (empty in this template)

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your civilization's name
2. Update the mod ID in the `.modinfo` file to something unique
3. Replace all instances of `CUSTOM` in the SQL and XML files with your civilization name
4. Update the localized text to reflect your civilization's history and characteristics
5. Create and add the necessary art assets to the `art/icons/` directory
6. Test your mod in-game

## Required Art Assets

At minimum, you'll need the following art assets:
- Civilization icon (main and small)
- Civilization background
- Leader portrait and background
- Unique unit icon
- Unique building icon

See the README in the `art/icons/` directory for more details.

## Customization Options

The template includes examples of how to implement:

1. **Civilization Trait**: A coastal-focused civilization with bonuses to food from water tiles
2. **Leader Ability**: Production bonuses for districts built near water
3. **Unique Unit**: A specialized warrior unit with combat bonuses on coastal tiles
4. **Unique Building**: A trading port that enhances coastal yields
5. **Leader Agenda**: An AI behavior pattern that values naval prowess

Modify these examples to create your own unique civilization.

## Reference Documentation

For more information on creating civilizations, refer to:
- [New Civilizations Guide](../new-civilizations.md)
- [Database Modding Guide](../database-modding.md)
- [Asset Creation Guide](../asset-creation.md)

## Tips

- Start by designing your civilization's unique traits and abilities on paper
- Use existing civilizations as reference points for balance
- Test your civilization in different map types and game settings
- Consider compatibility with other mods
- Gather feedback from players to refine your civilization's balance 