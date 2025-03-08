-- ===========================================================================
-- Custom Archipelago Map Script
-- This script generates maps with numerous small islands
-- Author: Your Name
-- ===========================================================================

-- Import necessary modules
include "MapEnums"
include "MapUtilities"
include "CoastalLowlands"
include "RiversManager"

-- Map script metadata
local MapScriptInfo = {
	Name = "LOC_MAPSCRIPT_CUSTOM_ARCHIPELAGO_NAME",
	Description = "LOC_MAPSCRIPT_CUSTOM_ARCHIPELAGO_DESCRIPTION",
	IsExpansion = false
}

-- Map options
local function GetMapScriptOptions()
	local options = {
		{
			Name = "LOC_MAPSCRIPT_ISLAND_SIZE_NAME",
			Values = {
				{
					Name = "LOC_MAPSCRIPT_ISLAND_SIZE_SMALL",
					Description = "LOC_MAPSCRIPT_ISLAND_SIZE_SMALL_DESCRIPTION",
					DefaultValue = true
				},
				{
					Name = "LOC_MAPSCRIPT_ISLAND_SIZE_MEDIUM",
					Description = "LOC_MAPSCRIPT_ISLAND_SIZE_MEDIUM_DESCRIPTION"
				},
				{
					Name = "LOC_MAPSCRIPT_ISLAND_SIZE_LARGE",
					Description = "LOC_MAPSCRIPT_ISLAND_SIZE_LARGE_DESCRIPTION"
				}
			}
		},
		{
			Name = "LOC_MAPSCRIPT_ISLAND_COUNT_NAME",
			Values = {
				{
					Name = "LOC_MAPSCRIPT_ISLAND_COUNT_FEW",
					Description = "LOC_MAPSCRIPT_ISLAND_COUNT_FEW_DESCRIPTION"
				},
				{
					Name = "LOC_MAPSCRIPT_ISLAND_COUNT_MODERATE",
					Description = "LOC_MAPSCRIPT_ISLAND_COUNT_MODERATE_DESCRIPTION",
					DefaultValue = true
				},
				{
					Name = "LOC_MAPSCRIPT_ISLAND_COUNT_MANY",
					Description = "LOC_MAPSCRIPT_ISLAND_COUNT_MANY_DESCRIPTION"
				}
			}
		},
		{
			Name = "LOC_MAPSCRIPT_SEA_LEVEL_NAME",
			Values = {
				{
					Name = "LOC_MAPSCRIPT_SEA_LEVEL_LOW",
					Description = "LOC_MAPSCRIPT_SEA_LEVEL_LOW_DESCRIPTION"
				},
				{
					Name = "LOC_MAPSCRIPT_SEA_LEVEL_MEDIUM",
					Description = "LOC_MAPSCRIPT_SEA_LEVEL_MEDIUM_DESCRIPTION",
					DefaultValue = true
				},
				{
					Name = "LOC_MAPSCRIPT_SEA_LEVEL_HIGH",
					Description = "LOC_MAPSCRIPT_SEA_LEVEL_HIGH_DESCRIPTION"
				}
			}
		}
	}
	return options
end

-- Main function for generating the map
function GenerateMap()
	-- Parse custom map options
	local islandSize = MapConfiguration.GetValue("LOC_MAPSCRIPT_ISLAND_SIZE_NAME") or "LOC_MAPSCRIPT_ISLAND_SIZE_SMALL"
	local islandCount = MapConfiguration.GetValue("LOC_MAPSCRIPT_ISLAND_COUNT_NAME") or "LOC_MAPSCRIPT_ISLAND_COUNT_MODERATE"
	local seaLevel = MapConfiguration.GetValue("LOC_MAPSCRIPT_SEA_LEVEL_NAME") or "LOC_MAPSCRIPT_SEA_LEVEL_MEDIUM"
	
	-- Get width and height from configuration
	local width = MapConfiguration.GetValue("Width")
	local height = MapConfiguration.GetValue("Height")
	
	-- Create map of appropriate size
	local terrainManager = TerrainBuilder.GetInstance()
	terrainManager:SetMapSize(width, height)
	
	-- Fill world with water
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			terrainManager:SetTerrainType(x, y, TerrainTypes.TERRAIN_OCEAN)
		end
	end
	
	-- Determine number of islands based on options
	local numIslands = 0
	if islandCount == "LOC_MAPSCRIPT_ISLAND_COUNT_FEW" then
		numIslands = math.floor(width * height / 400)
	elseif islandCount == "LOC_MAPSCRIPT_ISLAND_COUNT_MODERATE" then
		numIslands = math.floor(width * height / 300)
	else -- many
		numIslands = math.floor(width * height / 200)
	end
	
	-- Determine size of islands
	local maxIslandSize = 0
	if islandSize == "LOC_MAPSCRIPT_ISLAND_SIZE_SMALL" then
		maxIslandSize = 10
	elseif islandSize == "LOC_MAPSCRIPT_ISLAND_SIZE_MEDIUM" then
		maxIslandSize = 15
	else -- large
		maxIslandSize = 20
	end
	
	-- Generate islands
	GenerateIslands(numIslands, maxIslandSize, width, height)
	
	-- Add resources
	ResourceGenerator.AddResources()
	
	-- Add rivers
	RiversManager.DoRivers()
	
	-- Add features (forests, etc.)
	FeatureGenerator.AddFeatures()
	
	-- Add starting positions for players
	AddStartingPositions(width, height)
	
	-- Add coastal lowlands (for rising seas)
	GenerateCoastalLowlands()
	
	return true
end

-- Function to generate islands
function GenerateIslands(numIslands, maxIslandSize, width, height)
	print("Generating " .. tostring(numIslands) .. " islands of maximum size " .. tostring(maxIslandSize))
	
	local terrainManager = TerrainBuilder.GetInstance()
	local islandCenters = {}
	
	-- Create each island
	for i = 1, numIslands do
		-- Choose random location for island center
		local centerX = math.random(0, width - 1)
		local centerY = math.random(0, height - 1)
		
		-- Skip if too close to another island
		local tooClose = false
		for _, center in ipairs(islandCenters) do
			local distance = math.sqrt((centerX - center.x)^2 + (centerY - center.y)^2)
			if distance < maxIslandSize * 2 then
				tooClose = true
				break
			end
		end
		
		if not tooClose then
			table.insert(islandCenters, {x = centerX, y = centerY})
			
			-- Determine island size (random, up to maxIslandSize)
			local islandSize = math.random(math.floor(maxIslandSize / 2), maxIslandSize)
			
			-- Create the island using a basic blob algorithm
			for x = math.max(0, centerX - islandSize), math.min(width - 1, centerX + islandSize) do
				for y = math.max(0, centerY - islandSize), math.min(height - 1, centerY + islandSize) do
					local distance = math.sqrt((x - centerX)^2 + (y - centerY)^2)
					
					-- Create land with some randomness at the edges
					if distance < islandSize * 0.7 or (distance < islandSize and math.random() < 0.7) then
						-- Choose a terrain type (plains, grassland, desert, tundra)
						local terrainRoll = math.random(1, 10)
						local terrainType = TerrainTypes.TERRAIN_PLAINS
						
						if terrainRoll <= 5 then
							terrainType = TerrainTypes.TERRAIN_PLAINS
						elseif terrainRoll <= 8 then
							terrainType = TerrainTypes.TERRAIN_GRASS
						elseif terrainRoll <= 9 then
							terrainType = TerrainTypes.TERRAIN_DESERT
						else
							terrainType = TerrainTypes.TERRAIN_TUNDRA
						end
						
						terrainManager:SetTerrainType(x, y, terrainType)
						
						-- If near edge, make it coast
						if distance > islandSize * 0.6 then
							terrainManager:SetTerrainType(x, y, TerrainTypes.TERRAIN_COAST)
						end
					end
				end
			end
		end
	end
end

-- Add starting positions for players
function AddStartingPositions(width, height)
	-- Get player count
	local playerCount = PlayerManager.GetWasEverAliveCount()
	
	-- Determine best islands for starting positions
	print("Setting start positions for " .. tostring(playerCount) .. " players")
	
	-- Logic for placing start positions would go here
	-- For this template, we'll use the existing StartPositioner utility
	local startPositioner = StartPositioner.Create()
	startPositioner:PlacePlayerStarts()
end

-- Define exported functions
CustomMapScriptArchipelago = {
	Name = MapScriptInfo.Name,
	Description = MapScriptInfo.Description,
	IsExpansion = MapScriptInfo.IsExpansion,
	GetMapScriptOptions = GetMapScriptOptions,
	GenerateMap = GenerateMap
}
return CustomMapScriptArchipelago 