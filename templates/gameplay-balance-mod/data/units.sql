-- ===========================================================================
-- Unit Balance Changes
-- Author: Your Name
-- ===========================================================================

-- EARLY GAME UNITS
-- =========================================================================

-- Warrior balancing - slightly increase strength
UPDATE Units SET Combat = 22 WHERE UnitType = 'UNIT_WARRIOR';  -- Default: 20

-- Scout balancing - increase sight
UPDATE Units SET BaseSight = 3 WHERE UnitType = 'UNIT_SCOUT';  -- Default: 2

-- Slinger balancing - decrease cost
UPDATE Units SET Cost = 45 WHERE UnitType = 'UNIT_SLINGER';  -- Default: 50

-- Archer balancing
UPDATE Units 
SET Cost = 65, RangedCombat = 25, Combat = 15
WHERE UnitType = 'UNIT_ARCHER';  -- Default: 70/25/15

-- CLASSICAL ERA UNITS
-- =========================================================================

-- Swordsman balancing
UPDATE Units SET Combat = 38, Cost = 130 WHERE UnitType = 'UNIT_SWORDSMAN';  -- Default: 36/140

-- Horseman balancing - increase movement, adjust strength
UPDATE Units 
SET BaseMoves = 5, Combat = 34 
WHERE UnitType = 'UNIT_HORSEMAN';  -- Default: 4/36

-- Spearman balancing - increase anti-cavalry bonus (via ability)
UPDATE ModifierArguments
SET Value = 12
WHERE Name = 'Amount' AND ModifierId IN (
    SELECT ModifierId FROM UnitAbilityModifiers 
    WHERE UnitAbilityType = 'ABILITY_ANTI_CAVALRY'
);  -- Default: 10

-- MEDIEVAL ERA UNITS
-- =========================================================================

-- Knight balancing - slightly reduce strength
UPDATE Units SET Combat = 46 WHERE UnitType = 'UNIT_KNIGHT';  -- Default: 48

-- Crossbowman balancing - increase range
UPDATE Units SET Range = 3 WHERE UnitType = 'UNIT_CROSSBOWMAN';  -- Default: 2

-- RENAISSANCE ERA UNITS
-- =========================================================================

-- Musketman balancing
UPDATE Units SET Cost = 230, Combat = 52 WHERE UnitType = 'UNIT_MUSKETMAN';  -- Default: 240/50

-- Bombard balancing
UPDATE Units 
SET Cost = 280, RangedCombat = 55, Range = 2
WHERE UnitType = 'UNIT_BOMBARD';  -- Default: 300/50/2

-- INDUSTRIAL ERA UNITS
-- =========================================================================

-- Infantry balancing
UPDATE Units SET Combat = 68 WHERE UnitType = 'UNIT_INFANTRY';  -- Default: 70

-- Artillery balancing - increase range
UPDATE Units SET Range = 3 WHERE UnitType = 'UNIT_ARTILLERY';  -- Default: 2

-- NAVAL UNITS
-- =========================================================================

-- Galley balancing
UPDATE Units 
SET Cost = 70, Combat = 28, Range = 1
WHERE UnitType = 'UNIT_GALLEY';  -- Default: 80/30/1

-- Caravel balancing - increase movement
UPDATE Units SET BaseMoves = 5 WHERE UnitType = 'UNIT_CARAVEL';  -- Default: 4

-- Battleship balancing
UPDATE Units 
SET RangedCombat = 78, Range = 3
WHERE UnitType = 'UNIT_BATTLESHIP';  -- Default: 75/2

-- AIRCRAFT UNITS
-- =========================================================================

-- Fighter balancing
UPDATE Units SET Combat = 85 WHERE UnitType = 'UNIT_FIGHTER';  -- Default: 80

-- Bomber balancing - reduce cost
UPDATE Units SET Cost = 590 WHERE UnitType = 'UNIT_BOMBER';  -- Default: 600 