# Gameplay Balance Mod Template

This template demonstrates how to create a comprehensive gameplay balance mod for Civilization VII. It includes example changes to units, buildings, technologies, and civics to create a more balanced and enjoyable gameplay experience.

## Structure

- `gameplay-balance-mod.modinfo`: The mod definition file
- `data/units.sql`: Balance changes for military units
- `data/buildings.sql`: Balance changes for buildings and districts
- `data/technologies.sql`: Balance changes for technologies and civics

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your mod's unique name
2. Update the mod ID in the `.modinfo` file to something unique (e.g., "com.yourusername.yourmodname")
3. Review and adjust the balance changes to match your vision
4. Test your mod in-game to ensure the changes have the desired effect

## About Balance Modding

Balance modding focuses on adjusting numerical values and relationships between game elements to create a more enjoyable gameplay experience. This can involve:

1. **Adjusting Costs**: Making certain choices more or less expensive
2. **Modifying Stats**: Changing combat values, yields, or other statistics
3. **Altering Timelines**: Making certain game elements available earlier or later
4. **Enhancing Underused Features**: Making rarely-used game elements more attractive
5. **Addressing Overpowered Elements**: Toning down dominant strategies

When creating balance changes, consider:
- The original game design intent
- The ripple effects of your changes on other systems
- The player experience at different skill levels

## Example Changes

This template includes examples of:

### Unit Balance
- Adjustments to combat strength for various units
- Cost reductions/increases to better align with unit power
- Movement and range adjustments to differentiate unit roles

### Building Balance
- Yield adjustments to make buildings more valuable
- Cost reductions for underused buildings
- Maintenance changes to balance economy

### Tech & Civic Balance
- Adjustments to research costs based on value of unlocks
- Better pacing for key technologies and civics
- Incentives for different playstyles through cost adjustments

## Reference Documentation

For more information on gameplay modding, refer to:
- [Gameplay Modding Guide](../gameplay-modding.md) - For detailed information on modifying gameplay systems
- [Database Modding Guide](../database-modding.md) - For understanding the database tables and fields
- [Troubleshooting Guide](../troubleshooting.md) - For help with common modding issues

## Tips

- Start with small changes and test frequently
- Get feedback from different players with varied playstyles
- Document your changes so players understand your design philosophy
- Consider compatibility with other mods
- Create a clear gameplay vision before making widespread changes 