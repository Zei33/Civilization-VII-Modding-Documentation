-- ===========================================================================
-- Building Balance Changes
-- Author: Your Name
-- ===========================================================================

-- CITY CENTER BUILDINGS
-- =========================================================================

-- Monument balancing - decrease cost
UPDATE Buildings 
SET Cost = 60, Maintenance = 0
WHERE BuildingType = 'BUILDING_MONUMENT';  -- Default: 65/1

-- Granary balancing - increase food yield
UPDATE Buildings
SET Housing = 3, Food = 3
WHERE BuildingType = 'BUILDING_GRANARY';  -- Default: 2/2

-- Water Mill balancing
UPDATE Buildings
SET Cost = 110, Production = 2, Food = 1
WHERE BuildingType = 'BUILDING_WATER_MILL';  -- Default: 120/1/1

-- CAMPUS BUILDINGS
-- =========================================================================

-- Library balancing
UPDATE Buildings
SET Cost = 180, Science = 4, Maintenance = 1
WHERE BuildingType = 'BUILDING_LIBRARY';  -- Default: 190/3/1

-- University balancing
UPDATE Buildings
SET Science = 6
WHERE BuildingType = 'BUILDING_UNIVERSITY';  -- Default: 5

-- Research Lab balancing - decrease maintenance
UPDATE Buildings
SET Maintenance = 2
WHERE BuildingType = 'BUILDING_RESEARCH_LAB';  -- Default: 3

-- THEATER SQUARE BUILDINGS
-- =========================================================================

-- Amphitheater balancing
UPDATE Buildings
SET Culture = 3, Maintenance = 1
WHERE BuildingType = 'BUILDING_AMPHITHEATER';  -- Default: 2/1

-- Art Museum balancing
UPDATE Buildings
SET Culture = 4
WHERE BuildingType = 'BUILDING_ART_MUSEUM';  -- Default: 3

-- COMMERCIAL HUB BUILDINGS
-- =========================================================================

-- Market balancing
UPDATE Buildings
SET Gold = 4, Maintenance = 0
WHERE BuildingType = 'BUILDING_MARKET';  -- Default: 3/0

-- Bank balancing
UPDATE Buildings
SET Cost = 340
WHERE BuildingType = 'BUILDING_BANK';  -- Default: 360

-- INDUSTRIAL ZONE BUILDINGS
-- =========================================================================

-- Workshop balancing
UPDATE Buildings
SET Production = 3, Cost = 170
WHERE BuildingType = 'BUILDING_WORKSHOP';  -- Default: 2/180

-- Factory balancing
UPDATE Buildings
SET RegionalRange = 7
WHERE BuildingType = 'BUILDING_FACTORY';  -- Default: 6

-- HARBOR BUILDINGS
-- =========================================================================

-- Lighthouse balancing
UPDATE Buildings
SET Food = 2, Gold = 2, Housing = 2
WHERE BuildingType = 'BUILDING_LIGHTHOUSE';  -- Default: 1/2/1

-- Shipyard balancing - increase production
UPDATE Buildings
SET Production = 3
WHERE BuildingType = 'BUILDING_SHIPYARD';  -- Default: 2

-- HOLY SITE BUILDINGS
-- =========================================================================

-- Shrine balancing - slightly increase faith
UPDATE Buildings
SET Faith = 3
WHERE BuildingType = 'BUILDING_SHRINE';  -- Default: 2

-- Temple balancing - reduce cost
UPDATE Buildings
SET Cost = 110
WHERE BuildingType = 'BUILDING_TEMPLE';  -- Default: 120

-- ENCAMPMENT BUILDINGS
-- =========================================================================

-- Barracks/Stable balancing
UPDATE Buildings
SET ExperiencePointsGain = 3
WHERE BuildingType IN ('BUILDING_BARRACKS', 'BUILDING_STABLE');  -- Default: 2

-- Military Academy balancing
UPDATE Buildings
SET ExperiencePointsGain = 5, Production = 2
WHERE BuildingType = 'BUILDING_MILITARY_ACADEMY';  -- Default: 4/1

-- ENTERTAINMENT COMPLEX BUILDINGS
-- =========================================================================

-- Arena balancing - increase culture
UPDATE Buildings
SET Culture = 1, Entertainment = 2
WHERE BuildingType = 'BUILDING_ARENA';  -- Default: 0/2

-- Zoo balancing - increase regional range
UPDATE Buildings
SET RegionalRange = 8
WHERE BuildingType = 'BUILDING_ZOO';  -- Default: 6 