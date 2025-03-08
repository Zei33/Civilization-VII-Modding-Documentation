# Basic Database Modification Template

This template demonstrates how to create a simple mod that modifies the Civilization VII database. Use this as a starting point for mods that change game values like unit stats, building costs, terrain yields, etc.

## Structure

- `basic-database-mod.modinfo`: The mod definition file
- `data/database_changes.sql`: Example SQL modifications to the game database

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your mod's unique name
2. Update the mod ID in the `.modinfo` file to something unique (e.g., "com.yourusername.yourmodname")
3. Modify the SQL file with your desired database changes
4. Test your mod in-game

## Reference Documentation

For more information on database modding, refer to:
- [Database Modding Guide](../database-modding.md)
- [Mod Structure Guide](../mod-structure.md)

## Tips

- Use comments in your SQL to document your changes
- Start with small, targeted modifications and test frequently
- Check the game database structure (explained in the Database Modding guide) to understand available tables and fields
- Consider compatibility with other mods by focusing on specific changes rather than broad overhauls 