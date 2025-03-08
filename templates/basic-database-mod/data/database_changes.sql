-- Basic Database Modifications
-- Author: Your Name
--------------------------------------------------------------

-- Example: Increase yields for coastal tiles
UPDATE TerrainYields SET Yield = Yield + 1 
WHERE TerrainType = 'TERRAIN_COAST' AND YieldType = 'YIELD_FOOD';

-- Example: Reduce cost of a building
UPDATE Buildings SET Cost = Cost * 0.9 
WHERE BuildingType = 'BUILDING_GRANARY';

-- Example: Modify unit combat strength
UPDATE Units SET Combat = Combat + 2 
WHERE UnitType = 'UNIT_WARRIOR';

--------------------------------------------------------------
-- NOTE: Replace the examples above with your actual database changes
-- Use the database-modding.md guide for reference on table structures
-------------------------------------------------------------- 