-- ===========================================================================
-- Technology & Civic Balance Changes
-- Author: Your Name
-- ===========================================================================

-- ANCIENT ERA TECHNOLOGIES
-- =========================================================================

-- Animal Husbandry balancing - reduce cost
UPDATE Technologies 
SET Cost = 25
WHERE TechnologyType = 'TECH_ANIMAL_HUSBANDRY';  -- Default: 30

-- Mining balancing - reduce cost
UPDATE Technologies 
SET Cost = 25
WHERE TechnologyType = 'TECH_MINING';  -- Default: 30

-- Sailing balancing - reduce cost to encourage naval play
UPDATE Technologies 
SET Cost = 40
WHERE TechnologyType = 'TECH_SAILING';  -- Default: 50

-- CLASSICAL ERA TECHNOLOGIES
-- =========================================================================

-- Horseback Riding balancing
UPDATE Technologies 
SET Cost = 130
WHERE TechnologyType = 'TECH_HORSEBACK_RIDING';  -- Default: 140

-- Iron Working balancing
UPDATE Technologies 
SET Cost = 115
WHERE TechnologyType = 'TECH_IRON_WORKING';  -- Default: 120

-- MEDIEVAL ERA TECHNOLOGIES
-- =========================================================================

-- Machinery balancing - increase cost
UPDATE Technologies 
SET Cost = 330
WHERE TechnologyType = 'TECH_MACHINERY';  -- Default: 310

-- Education balancing - slightly decrease cost
UPDATE Technologies 
SET Cost = 380
WHERE TechnologyType = 'TECH_EDUCATION';  -- Default: 400

-- RENAISSANCE ERA TECHNOLOGIES
-- =========================================================================

-- Printing balancing
UPDATE Technologies 
SET Cost = 500
WHERE TechnologyType = 'TECH_PRINTING';  -- Default: 530

-- Military Engineering balancing - reduce cost
UPDATE Technologies 
SET Cost = 600
WHERE TechnologyType = 'TECH_MILITARY_ENGINEERING';  -- Default: 650

-- INDUSTRIAL ERA TECHNOLOGIES
-- =========================================================================

-- Steam Power balancing
UPDATE Technologies 
SET Cost = 880
WHERE TechnologyType = 'TECH_STEAM_POWER';  -- Default: 920

-- Industrialization balancing - reduce cost
UPDATE Technologies 
SET Cost = 920
WHERE TechnologyType = 'TECH_INDUSTRIALIZATION';  -- Default: 950

-- MODERN ERA TECHNOLOGIES
-- =========================================================================

-- Replaceable Parts balancing - reduce cost
UPDATE Technologies 
SET Cost = 1150
WHERE TechnologyType = 'TECH_REPLACEABLE_PARTS';  -- Default: 1190

-- Flight balancing
UPDATE Technologies 
SET Cost = 1290
WHERE TechnologyType = 'TECH_FLIGHT';  -- Default: 1320

-- ANCIENT ERA CIVICS
-- =========================================================================

-- Early Empire balancing - reduce cost
UPDATE Civics 
SET Cost = 60
WHERE CivicType = 'CIVIC_EARLY_EMPIRE';  -- Default: 70

-- Military Tradition balancing
UPDATE Civics 
SET Cost = 70
WHERE CivicType = 'CIVIC_MILITARY_TRADITION';  -- Default: 80

-- CLASSICAL ERA CIVICS
-- =========================================================================

-- Political Philosophy balancing
UPDATE Civics 
SET Cost = 110
WHERE CivicType = 'CIVIC_POLITICAL_PHILOSOPHY';  -- Default: 120

-- Games and Recreation balancing - reduce cost
UPDATE Civics 
SET Cost = 120
WHERE CivicType = 'CIVIC_GAMES_RECREATION';  -- Default: 140

-- MEDIEVAL ERA CIVICS
-- =========================================================================

-- Feudalism balancing
UPDATE Civics 
SET Cost = 290
WHERE CivicType = 'CIVIC_FEUDALISM';  -- Default: 310

-- Civil Service balancing - reduce cost
UPDATE Civics 
SET Cost = 380
WHERE CivicType = 'CIVIC_CIVIL_SERVICE';  -- Default: 400

-- RENAISSANCE ERA CIVICS
-- =========================================================================

-- Diplomatic Service balancing
UPDATE Civics 
SET Cost = 480
WHERE CivicType = 'CIVIC_DIPLOMATIC_SERVICE';  -- Default: 510

-- Reformed Church balancing - reduce cost to make religion more viable
UPDATE Civics 
SET Cost = 480
WHERE CivicType = 'CIVIC_REFORMED_CHURCH';  -- Default: 510

-- INDUSTRIAL ERA CIVICS
-- =========================================================================

-- Nationalism balancing - increase cost
UPDATE Civics 
SET Cost = 860
WHERE CivicType = 'CIVIC_NATIONALISM';  -- Default: 830

-- Natural History balancing
UPDATE Civics 
SET Cost = 850
WHERE CivicType = 'CIVIC_NATURAL_HISTORY';  -- Default: 870

-- MODERN ERA CIVICS
-- =========================================================================

-- Mass Media balancing
UPDATE Civics 
SET Cost = 1080
WHERE CivicType = 'CIVIC_MASS_MEDIA';  -- Default: 1110

-- Suffrage balancing - reduce cost
UPDATE Civics 
SET Cost = 1100
WHERE CivicType = 'CIVIC_SUFFRAGE';  -- Default: 1130 