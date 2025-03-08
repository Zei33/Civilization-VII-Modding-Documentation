-- New Civilization SQL Definition
-- Author: Your Name
--------------------------------------------------------------

-- CIVILIZATION DEFINITION
--------------------------------------------------------------
-- Add Types entry for civilization
INSERT INTO Types (Type, Kind)
VALUES ('CIVILIZATION_CUSTOM', 'KIND_CIVILIZATION');

INSERT INTO Civilizations
		(CivilizationType, Name, Description, Adjective, StartingCivilizationAbility)
VALUES	('CIVILIZATION_CUSTOM', 'LOC_CIVILIZATION_CUSTOM_NAME', 'LOC_CIVILIZATION_CUSTOM_DESCRIPTION', 
		'LOC_CIVILIZATION_CUSTOM_ADJECTIVE', 'ABILITY_CIVILIZATION_CUSTOM');

-- CIVILIZATION TRAITS
--------------------------------------------------------------
INSERT INTO CivilizationTraits
		(CivilizationType, TraitType)
VALUES	('CIVILIZATION_CUSTOM', 'TRAIT_CIVILIZATION_CUSTOM_ABILITY');

-- TRAIT DEFINITIONS
--------------------------------------------------------------
INSERT INTO Traits
		(TraitType, Name, Description)
VALUES	('TRAIT_CIVILIZATION_CUSTOM_ABILITY', 'LOC_TRAIT_CIVILIZATION_CUSTOM_ABILITY_NAME', 
		'LOC_TRAIT_CIVILIZATION_CUSTOM_ABILITY_DESCRIPTION');

-- TRAIT MODIFIERS
--------------------------------------------------------------
-- Example: +1 Food from coastal tiles
INSERT INTO TraitModifiers
		(TraitType, ModifierID)
VALUES	('TRAIT_CIVILIZATION_CUSTOM_ABILITY', 'MODIFIER_CIVILIZATION_CUSTOM_COASTAL_FOOD');

INSERT INTO Modifiers
		(ModifierID, ModifierType, SubjectRequirementSetID)
VALUES	('MODIFIER_CIVILIZATION_CUSTOM_COASTAL_FOOD', 'MODIFIER_PLAYER_CITIES_TERRAIN_YIELDS', 'REQSET_TERRAIN_IS_COAST');

INSERT INTO ModifierArguments
		(ModifierID, Name, Value)
VALUES	('MODIFIER_CIVILIZATION_CUSTOM_COASTAL_FOOD', 'YieldType', 'YIELD_FOOD'),
		('MODIFIER_CIVILIZATION_CUSTOM_COASTAL_FOOD', 'Amount', '1');

-- LEADER DEFINITION
--------------------------------------------------------------
-- Add Types entry for leader
INSERT INTO Types (Type, Kind)
VALUES ('LEADER_CUSTOM', 'KIND_LEADER');

INSERT INTO Leaders
		(LeaderType, Name, Description, Ability)
VALUES	('LEADER_CUSTOM', 'LOC_LEADER_CUSTOM_NAME', 'LOC_LEADER_CUSTOM_DESCRIPTION', 'ABILITY_LEADER_CUSTOM');

-- LEADER TRAITS
--------------------------------------------------------------
INSERT INTO LeaderTraits
		(LeaderType, TraitType)
VALUES	('LEADER_CUSTOM', 'TRAIT_LEADER_CUSTOM_ABILITY');

INSERT INTO Traits
		(TraitType, Name, Description)
VALUES	('TRAIT_LEADER_CUSTOM_ABILITY', 'LOC_TRAIT_LEADER_CUSTOM_ABILITY_NAME', 
		'LOC_TRAIT_LEADER_CUSTOM_ABILITY_DESCRIPTION');

-- LEADER AGENDA
--------------------------------------------------------------
INSERT INTO LeaderAgendas
		(LeaderType, AgendaType)
VALUES	('LEADER_CUSTOM', 'AGENDA_CUSTOM');

INSERT INTO Agendas
		(AgendaType, Name, Description)
VALUES	('AGENDA_CUSTOM', 'LOC_AGENDA_CUSTOM_NAME', 'LOC_AGENDA_CUSTOM_DESCRIPTION');

-- CIVILIZATION-LEADER PAIRINGS
--------------------------------------------------------------
INSERT INTO CivilizationLeaders
		(CivilizationType, LeaderType, CapitalName)
VALUES	('CIVILIZATION_CUSTOM', 'LEADER_CUSTOM', 'LOC_CITY_NAME_CUSTOM_CAPITAL');

-- STARTING BIAS
--------------------------------------------------------------
INSERT INTO StartBiases
		(CivilizationType, BiasType, Tier)
VALUES	('CIVILIZATION_CUSTOM', 'BIAS_COAST', 3),
		('CIVILIZATION_CUSTOM', 'BIAS_PLAINS', 2);

-- UNIQUE UNIT
--------------------------------------------------------------
INSERT INTO Units
		(UnitType, Name, Description, CanMOTU, CostMod, BaseMoves, BaseSight, ZoneOfControl,
		Domain, FormationClass, Cost, PopulationCost, MaintMod, Maintenance, Combat, RangedCombat,
		Range, MovesRequiredToKill, RequiredTech, PrereqDisctrict, TraitType)
VALUES	('UNIT_CUSTOM', 'LOC_UNIT_CUSTOM_NAME', 'LOC_UNIT_CUSTOM_DESCRIPTION', 1, 0, 2, 2, 1,
		'DOMAIN_LAND', 'FORMATION_CLASS_LAND_COMBAT', 150, 0, 0, 3, 40, 0,
		0, 1, 'TECH_IRON_WORKING', NULL, 'TRAIT_CIVILIZATION_CUSTOM_ABILITY');

-- UNIQUE BUILDING
--------------------------------------------------------------
INSERT INTO Buildings
		(BuildingType, Name, Description, PrereqTech, PrereqCivic, Cost, MaxPlayerInstances,
		Housing, Entertainment, TraitType, RequiredDistrict)
VALUES	('BUILDING_CUSTOM', 'LOC_BUILDING_CUSTOM_NAME', 'LOC_BUILDING_CUSTOM_DESCRIPTION',
		'TECH_CONSTRUCTION', NULL, 225, 0, 0, 0, 'TRAIT_CIVILIZATION_CUSTOM_ABILITY', 'DISTRICT_CITY_CENTER');

-- CITY NAMES
--------------------------------------------------------------
INSERT INTO CityNames
		(CivilizationType, CityName)
VALUES	('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_1'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_2'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_3'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_4'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_5'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_6'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_7'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_8'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_9'),
		('CIVILIZATION_CUSTOM', 'LOC_CITY_NAME_CUSTOM_10');

--------------------------------------------------------------
-- NOTE: Replace the placeholders with your actual civilization details
-- Use new-civilizations.md and database-modding.md guides for reference
-------------------------------------------------------------- 