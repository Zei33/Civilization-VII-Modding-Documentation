# Database Modding in Civilization VII

This guide explains how to modify the Civilization VII game database, which contains all the game's data including civilizations, units, buildings, terrains, and more.

## Table of Contents
- [Introduction](#introduction)
- [Database Structure](#database-structure)
- [Common Database Tables](#common-database-tables)
- [SQL Basics for Modding](#sql-basics-for-modding)
- [Modifying Existing Entries](#modifying-existing-entries)
- [Adding New Content](#adding-new-content)
- [Working with Requirements](#working-with-requirements)
- [Common Pitfalls](#common-pitfalls)
- [Examples](#examples)
- [Related Documentation](#related-documentation)

## Introduction

Civilization VII, like its predecessors, stores most of its game data in SQLite databases. These databases define everything from unit stats to civilization abilities. By modifying these databases, you can:

- Change existing game content
- Add new content
- Remove or disable content
- Modify gameplay rules and systems

Database modding is one of the most powerful tools for Civilization VII modders, allowing fundamental changes to how the game works.

## Database Structure

The Civilization VII database is organized in a relational structure with many interconnected tables. Understanding this structure is crucial for effective modding.

```mermaid
graph TD
    A[Types] -->|references| B[Units]
    A -->|references| C[Buildings]
    A -->|references| D[Improvements]
    LEADERS -->|references| LEADER_TRAITS
    LEADERS ||--o{ LEADER_TRAITS : has
    CIVILIZATIONS ||--o{ CIVILIZATION_TRAITS : has
    UNITS --> UNIT_ABILITIES
    BUILDINGS --> BUILDING_EFFECTS
    TERRAINS ||--o{ TERRAIN_FEATURES : contains
```

The database is organized with specific relationships between tables, maintaining referential integrity to ensure data consistency.

> **See Also:** For information on how the database connects to UI elements, check the [UI Modding Guide](./ui-modding.md#communication-between-ui-and-game).

## Common Database Tables

Here are some of the most frequently modified tables in Civilization VII:

| Table | Purpose | Common Columns |
|-------|---------|----------------|
| Types | Defines all game objects | Type, Kind |
| Units | Unit definitions | UnitType, Name, Combat, Cost |
| Buildings | Building definitions | BuildingType, Name, Cost, Maintenance |
| Improvements | Tile improvements | ImprovementType, Name, PrereqTech |
| Technologies | Tech tree definitions | TechnologyType, Cost, Era |
| Civilizations | Civilization definitions | CivilizationType, Name, StartingTech |
| Leaders | Leader definitions | LeaderType, Name, InheritFrom |
| Resources | Resource definitions | ResourceType, Name, ResourceClassType |
| Terrains | Terrain type information | TerrainType, Name, Movement |
| Features | Natural features on terrain | FeatureType, Name, Movement |

> **Related Topic:** For creating new civilizations using these tables, see the [New Civilizations Guide](./new-civilizations.md).

## SQL Basics for Modding

To modify the database, you'll need to write SQL commands. Here are the most common SQL operations used in modding:

### SELECT
```sql
-- View all civilizations
SELECT * FROM Civilizations;

-- Get specific information about units
SELECT UnitType, Name, Cost, Combat FROM Units;
```

### INSERT
```sql
-- Add a new building
INSERT INTO Buildings (BuildingType, Name, Cost, Maintenance, PrereqTech)
VALUES ('BUILDING_CUSTOM_LIBRARY', 'LOC_BUILDING_CUSTOM_LIBRARY_NAME', 180, 2, 'TECH_WRITING');
```

### UPDATE
```sql
-- Modify unit stats
UPDATE Units
SET Combat = Combat + 5, Cost = Cost + 20
WHERE UnitType = 'UNIT_WARRIOR';
```

### DELETE
```sql
-- Remove an obsolete building
DELETE FROM Buildings
WHERE BuildingType = 'BUILDING_OBSOLETE';
```

## Modifying Existing Entries

To modify existing game data, use the SQL `UPDATE` statement:

```sql
-- Make walls cheaper to build
UPDATE Buildings
SET Cost = 150 -- Default is 200
WHERE BuildingType = 'BUILDING_WALLS';

-- Reduce library maintenance
UPDATE Buildings
SET Maintenance = 1
WHERE BuildingType = 'BUILDING_LIBRARY';

-- Make scouts faster
UPDATE Units
SET BaseMoves = 3 -- Default is 2
WHERE UnitType = 'UNIT_SCOUT';
```

> **See Also:** For more examples of gameplay modifications, check the [Gameplay Modding Guide](./gameplay-modding.md#simple-gameplay-modifications).

## Adding New Content

### Adding a New Unit

```sql
-- Add a new unit type
INSERT INTO Types (Type, Kind)
VALUES ('UNIT_CUSTOM_KNIGHT', 'KIND_UNIT');

-- Add the unit to the Units table
INSERT INTO Units (UnitType, Name, Description, Cost, Combat, Movement, PrereqTech)
VALUES (
	'UNIT_CUSTOM_KNIGHT', 
	'LOC_UNIT_CUSTOM_KNIGHT_NAME',
	'LOC_UNIT_CUSTOM_KNIGHT_DESCRIPTION',
	240,
	45,
	4,
	'TECH_STIRRUPS'
);

-- Add unit ability
INSERT INTO UnitAbilities (UnitAbilityType, Name, Description)
VALUES (
	'ABILITY_CUSTOM_KNIGHT_CHARGE',
	'LOC_ABILITY_CUSTOM_KNIGHT_CHARGE_NAME',
	'LOC_ABILITY_CUSTOM_KNIGHT_CHARGE_DESCRIPTION'
);

-- Link unit to ability
INSERT INTO UnitAbilityAttachments (UnitAbilityType, UnitType)
VALUES ('ABILITY_CUSTOM_KNIGHT_CHARGE', 'UNIT_CUSTOM_KNIGHT');
```

### Adding a New Building

```sql
-- Add a new building type
INSERT INTO Types (Type, Kind)
VALUES ('BUILDING_CUSTOM_MARKET', 'KIND_BUILDING');

-- Add the building to the Buildings table
INSERT INTO Buildings (
	BuildingType, 
	Name, 
	Description, 
	Cost, 
	Maintenance, 
	PrereqTech, 
	Gold
)
VALUES (
	'BUILDING_CUSTOM_MARKET',
	'LOC_BUILDING_CUSTOM_MARKET_NAME',
	'LOC_BUILDING_CUSTOM_MARKET_DESCRIPTION',
	150,
	2,
	'TECH_CURRENCY',
	5
);

-- Add building to districts
INSERT INTO BuildingPrereqs (Building, PrereqBuilding)
VALUES ('BUILDING_CUSTOM_MARKET', 'BUILDING_MARKET');
```

## Working with Requirements

Requirements define when certain content is available or active:

```sql
-- Create a requirement set for a coastal city
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES ('CITY_IS_COASTAL_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');

-- Add the actual requirement to the set
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES ('CITY_IS_COASTAL_REQUIREMENTS', 'REQUIRES_CITY_IS_COASTAL');

-- Create a modifier that uses this requirement set
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('COASTAL_CITY_GOLD_BONUS', 'MODIFIER_CITY_ADJUST_YIELD_CHANGE', 'CITY_IS_COASTAL_REQUIREMENTS');

-- Set the modifier's effect
INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES 
    ('COASTAL_CITY_GOLD_BONUS', 'YieldType', 'YIELD_GOLD'),
    ('COASTAL_CITY_GOLD_BONUS', 'Amount', '2');
```

> **Related Topic:** For narrative requirements and conditions, refer to the [Narrative and Story Guide](./narrative-and-story.md#condition-systems).

## Common Pitfalls

When working with the database, be aware of these common issues:

1. **Foreign Key Constraints**: Always add entries to the `Types` table before referencing them in other tables
2. **Case Sensitivity**: Table and column names are case-sensitive
3. **Missing References**: Ensure all referenced IDs exist in their respective tables
4. **Order of Operations**: Follow the correct order when adding interdependent entries
5. **Text Keys**: Remember to add localization entries for text keys

> **See Also:** For troubleshooting database issues, check the [Troubleshooting Guide](./troubleshooting.md#database-errors).

## Examples

### Example 1: Rebalancing Resource Yields

```sql
-- Increase yields from strategic resources
UPDATE Resource_YieldChanges
SET YieldChange = YieldChange + 1
WHERE ResourceType IN (
	SELECT ResourceType 
	FROM Resources 
	WHERE ResourceClassType = 'RESOURCECLASS_STRATEGIC'
);

-- Increase food from bonus resources
UPDATE Resource_YieldChanges
SET YieldChange = YieldChange + 1
WHERE ResourceType IN (
	SELECT ResourceType 
	FROM Resources 
	WHERE ResourceClassType = 'RESOURCECLASS_BONUS'
) AND YieldType = 'YIELD_FOOD';
```

### Example 2: Creating a New Government

```sql
-- Add a new government type
INSERT INTO Types (Type, Kind)
VALUES ('GOVERNMENT_TECHNOCRACY', 'KIND_GOVERNMENT');

-- Add the government to the Governments table
INSERT INTO Governments (
	GovernmentType, 
	Name, 
	Description, 
	PrereqCivic, 
	PolicySlots
)
VALUES (
	'GOVERNMENT_TECHNOCRACY',
	'LOC_GOVERNMENT_TECHNOCRACY_NAME',
	'LOC_GOVERNMENT_TECHNOCRACY_DESCRIPTION',
	'CIVIC_SCIENTIFIC_THEORY',
	8
);

-- Define policy slots for the new government
INSERT INTO Government_PolicySlots (GovernmentType, PolicySlotType, NumSlots)
VALUES 
	('GOVERNMENT_TECHNOCRACY', 'POLICY_SLOT_MILITARY', 1),
	('GOVERNMENT_TECHNOCRACY', 'POLICY_SLOT_ECONOMIC', 3),
	('GOVERNMENT_TECHNOCRACY', 'POLICY_SLOT_DIPLOMATIC', 1),
	('GOVERNMENT_TECHNOCRACY', 'POLICY_SLOT_WILDCARD', 3);

-- Add government's inherent bonus
INSERT INTO Modifiers (ModifierId, ModifierType)
VALUES ('TECHNOCRACY_SCIENCE_BONUS', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE');

INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES 
	('TECHNOCRACY_SCIENCE_BONUS', 'YieldType', 'YIELD_SCIENCE'),
	('TECHNOCRACY_SCIENCE_BONUS', 'Amount', '3');

INSERT INTO GovernmentModifiers (GovernmentType, ModifierId)
VALUES ('GOVERNMENT_TECHNOCRACY', 'TECHNOCRACY_SCIENCE_BONUS');

-- Add localization
INSERT OR REPLACE INTO LocalizedText (Tag, Language, Text)
VALUES
	('LOC_GOVERNMENT_TECHNOCRACY_NAME', 'en_US', 'Technocracy'),
	('LOC_GOVERNMENT_TECHNOCRACY_DESCRIPTION', 'en_US', 'A form of government where decision-makers are selected based on their technical expertise. +3 Science in all cities.');
```

### Example 3: Creating a Civilization Trait

```sql
-- Add a new trait
INSERT INTO Types (Type, Kind)
VALUES ('TRAIT_CIVILIZATION_ISLAND_MASTERY', 'KIND_TRAIT');

-- Define the trait
INSERT INTO Traits (TraitType, Name, Description)
VALUES (
	'TRAIT_CIVILIZATION_ISLAND_MASTERY',
	'LOC_TRAIT_CIVILIZATION_ISLAND_MASTERY_NAME',
	'LOC_TRAIT_CIVILIZATION_ISLAND_MASTERY_DESCRIPTION'
);

-- Create a modifier for the trait (bonus production on coastal tiles)
INSERT INTO Modifiers (ModifierId, ModifierType)
VALUES ('TRAIT_COASTAL_TILES_PRODUCTION', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD');

INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES 
	('TRAIT_COASTAL_TILES_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
	('TRAIT_COASTAL_TILES_PRODUCTION', 'Amount', '1'),
	('TRAIT_COASTAL_TILES_PRODUCTION', 'IsCoastalLand', '1');

-- Attach modifier to trait
INSERT INTO TraitModifiers (TraitType, ModifierId)
VALUES ('TRAIT_CIVILIZATION_ISLAND_MASTERY', 'TRAIT_COASTAL_TILES_PRODUCTION');

-- Add localization
INSERT OR REPLACE INTO LocalizedText (Tag, Language, Text)
VALUES
	('LOC_TRAIT_CIVILIZATION_ISLAND_MASTERY_NAME', 'en_US', 'Island Mastery'),
	('LOC_TRAIT_CIVILIZATION_ISLAND_MASTERY_DESCRIPTION', 'en_US', 'Coastal tiles receive +1 Production.');
```

## Related Documentation

For more information on topics related to database modding, refer to these guides:

- [Gameplay Modding](./gameplay-modding.md) - For examples of how database changes affect gameplay
- [New Civilizations](./new-civilizations.md) - For applying database knowledge to create civilizations
- [UI Modding](./ui-modding.md) - For displaying database information in the UI
- [Troubleshooting](./troubleshooting.md#database-errors) - For resolving database-related issues
- [Advanced Topics](./advanced-topics.md) - For complex database operations and scripting
- [Narrative and Story](./narrative-and-story.md) - For database aspects of narrative systems

## Additional Resources

- [Mod Structure Guide](./mod-structure.md) - Learn about the overall structure of mods
- [Quick Start Guide](./quick-start-guide.md) - Get started with your first mod
- [Basic Database Mod Template](./Templates/basic-database-mod/) - A ready-to-use template for database modifications
- [Custom Resource Mod Template](./Templates/custom-resource-mod/) - A ready-to-use template for adding new resources

---

*Remember: The database is the foundation of Civilization VII. Understanding how to modify it opens up countless possibilities for your mods!* 