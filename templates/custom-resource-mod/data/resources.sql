-- ===========================================================================
-- Custom Resources
-- Author: Your Name
-- ===========================================================================

-- COFFEE RESOURCE (Luxury)
-- =========================================================================

-- Add Coffee resource type
INSERT INTO Types (Type, Kind)
VALUES ('RESOURCE_COFFEE', 'KIND_RESOURCE');

-- Add Coffee resource definition
INSERT INTO Resources (
	ResourceType, 
	Name, 
	Description, 
	ResourceClassType, 
	ReminderText, 
	Trade
) VALUES (
	'RESOURCE_COFFEE', 
	'LOC_RESOURCE_COFFEE_NAME', 
	'LOC_RESOURCE_COFFEE_DESCRIPTION', 
	'RESOURCECLASS_LUXURY', 
	'LOC_RESOURCE_COFFEE_REMINDER', 
	1
);

-- Add Coffee harvest ability
INSERT INTO TypeTags (Type, Tag)
VALUES ('RESOURCE_COFFEE', 'CLASS_HARVEST_CANNOT');

-- Add Coffee to valid features (hills, plains, grassland)
INSERT INTO Resource_ValidFeatures (ResourceType, FeatureType)
VALUES 
    ('RESOURCE_COFFEE', 'FEATURE_HILLS');

-- Add Coffee to valid terrains
INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType)
VALUES 
    ('RESOURCE_COFFEE', 'TERRAIN_GRASS'),
    ('RESOURCE_COFFEE', 'TERRAIN_PLAINS');

-- Add appearance parameters for map generation
INSERT INTO Resource_Harvests (ResourceType, YieldType, Amount, PrereqTech)
VALUES ('RESOURCE_COFFEE', 'YIELD_FOOD', 10, 'TECH_IRRIGATION');

-- Add Coffee yields
INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange)
VALUES 
    ('RESOURCE_COFFEE', 'YIELD_GOLD', 3),
    ('RESOURCE_COFFEE', 'YIELD_FOOD', 1);

-- JADE RESOURCE (Luxury)
-- =========================================================================

-- Add Jade resource type
INSERT INTO Types (Type, Kind)
VALUES ('RESOURCE_JADE', 'KIND_RESOURCE');

-- Add Jade resource definition
INSERT INTO Resources (
	ResourceType, 
	Name, 
	Description, 
	ResourceClassType, 
	ReminderText, 
	Trade
) VALUES (
	'RESOURCE_JADE', 
	'LOC_RESOURCE_JADE_NAME', 
	'LOC_RESOURCE_JADE_DESCRIPTION', 
	'RESOURCECLASS_LUXURY', 
	'LOC_RESOURCE_JADE_REMINDER', 
	1
);

-- Add Jade harvest ability
INSERT INTO TypeTags (Type, Tag)
VALUES ('RESOURCE_JADE', 'CLASS_HARVEST_CANNOT');

-- Add Jade to valid features
INSERT INTO Resource_ValidFeatures (ResourceType, FeatureType)
VALUES 
    ('RESOURCE_JADE', 'FEATURE_MOUNTAINS');

-- Add Jade to valid terrains
INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType)
VALUES 
    ('RESOURCE_JADE', 'TERRAIN_GRASS'),
    ('RESOURCE_JADE', 'TERRAIN_PLAINS'),
    ('RESOURCE_JADE', 'TERRAIN_TUNDRA');

-- Add appearance parameters for map generation
INSERT INTO Resource_Harvests (ResourceType, YieldType, Amount, PrereqTech)
VALUES ('RESOURCE_JADE', 'YIELD_GOLD', 15, 'TECH_MINING');

-- Add Jade yields
INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange)
VALUES 
    ('RESOURCE_JADE', 'YIELD_GOLD', 4),
    ('RESOURCE_JADE', 'YIELD_CULTURE', 1);

-- RESOURCE IMPROVEMENTS
-- =========================================================================

-- Make Coffee harvestable with Plantation
INSERT INTO Improvement_ValidResources (ImprovementType, ResourceType, MustRemoveFeature)
VALUES ('IMPROVEMENT_PLANTATION', 'RESOURCE_COFFEE', 0);

-- Add coffee plantation bonus yields
INSERT INTO Improvement_BonusYieldResourceTypes (
    ImprovementType, 
    ResourceType, 
    YieldType, 
    YieldChange, 
    PrereqTech
) VALUES (
    'IMPROVEMENT_PLANTATION', 
    'RESOURCE_COFFEE', 
    'YIELD_GOLD', 
    1, 
    'TECH_ECONOMICS'
);

-- Make Jade harvestable with Mine
INSERT INTO Improvement_ValidResources (ImprovementType, ResourceType, MustRemoveFeature)
VALUES ('IMPROVEMENT_MINE', 'RESOURCE_JADE', 0);

-- Add jade mine bonus yields
INSERT INTO Improvement_BonusYieldResourceTypes (
    ImprovementType, 
    ResourceType, 
    YieldType, 
    YieldChange, 
    PrereqTech
) VALUES (
    'IMPROVEMENT_MINE', 
    'RESOURCE_JADE', 
    'YIELD_CULTURE', 
    1, 
    'TECH_BANKING'
);

-- RESOURCE PLACEMENT ON MAPS
-- =========================================================================

-- Add Coffee to map generation
INSERT INTO Resource_Distribution (
    ResourceType, 
    Frequency, 
    MinAreaSize, 
    MinClusters, 
    MaxClusters, 
    MinClusterSize, 
    MaxClusterSize
) VALUES (
    'RESOURCE_COFFEE', 
    'RESOURCEFREQUENCY_STANDARD', 
    3, 
    2, 
    3, 
    1, 
    2
);

-- Add Jade to map generation
INSERT INTO Resource_Distribution (
    ResourceType, 
    Frequency, 
    MinAreaSize, 
    MinClusters, 
    MaxClusters, 
    MinClusterSize, 
    MaxClusterSize
) VALUES (
    'RESOURCE_JADE', 
    'RESOURCEFREQUENCY_RARE', 
    4, 
    1, 
    2, 
    1, 
    1
);

-- RESOURCE VISIBILITY
-- =========================================================================

-- Make Coffee visible with irrigation
INSERT INTO Resource_Visibilities (ResourceType, TechType)
VALUES ('RESOURCE_COFFEE', 'TECH_IRRIGATION');

-- Make Jade visible with mining
INSERT INTO Resource_Visibilities (ResourceType, TechType)
VALUES ('RESOURCE_JADE', 'TECH_MINING');

-- RESOURCE CONSUMPTION BY BUILDINGS
-- =========================================================================

-- Add Coffee as market amenity
INSERT INTO Building_ResourceCosts (
    BuildingType, 
    ResourceType, 
    Quantity, 
    Consumable
) VALUES (
    'BUILDING_MARKET', 
    'RESOURCE_COFFEE', 
    1, 
    1
);

-- Add Jade as theater square amenity
INSERT INTO Building_ResourceCosts (
    BuildingType, 
    ResourceType, 
    Quantity, 
    Consumable
) VALUES (
    'BUILDING_THEATER', 
    'RESOURCE_JADE', 
    1, 
    1
);

-- RESOURCE ICONS
-- =========================================================================

-- Set resource icons
INSERT INTO IconDefinitions (Name, Atlas, IconIndex)
VALUES 
    ('ICON_RESOURCE_COFFEE', 'ICON_ATLAS_RESOURCES', 1),
    ('ICON_RESOURCE_JADE', 'ICON_ATLAS_RESOURCES', 2); 