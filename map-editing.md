# Map Editing and Creation in Civilization VII

This comprehensive guide explains how to create, edit, and customize maps for Civilization VII through modding.

## Table of Contents
- [Introduction](#introduction)
- [Map Concepts](#map-concepts)
- [Map Types](#map-types)
- [Map Script Modding](#map-script-modding)
- [WorldBuilder Tool](#worldbuilder-tool)
- [Creating a Custom Map](#creating-a-custom-map)
- [Map Generation Parameters](#map-generation-parameters)
- [Advanced Map Scripts](#advanced-map-scripts)
- [Testing and Debugging](#testing-and-debugging)
- [Map Distribution](#map-distribution)
- [Examples](#examples)

## Introduction

Maps in Civilization VII can be created and modified in several ways:

1. **Map Scripts**: Lua scripts that procedurally generate maps based on parameters
2. **WorldBuilder**: An in-game tool for hand-crafting maps
3. **Save Game Editing**: Modifying existing map saves

Map modding allows you to:
- Create historically accurate recreations of Earth or specific regions
- Design balanced competitive multiplayer maps
- Craft unique scenarios with custom starting positions
- Develop new map types with unusual terrain distributions

## Map Concepts

### Core Map Elements

- **Plots**: Individual hexagonal tiles that make up the map
- **Terrains**: Base terrain types (grassland, plains, desert, tundra, snow, ocean)
- **Features**: Natural elements on tiles (forests, jungles, mountains, reefs)
- **Resources**: Strategic, luxury, and bonus resources
- **Rivers**: Water features that run between tiles
- **Continents**: Connected landmasses
- **Start Positions**: Where civilizations begin the game
- **Natural Wonders**: Unique map features with special benefits

### Map Coordinates

Civilization VII uses a hexagonal coordinate system:

```
    _____       _____
   /     \     /     \
  /       \___/       \
  \       /   \       /
   \_____/     \_____/
   /     \     /     \
  /       \___/       \
  \       /   \       /
   \_____/     \_____/
```

Each plot has an (x,y) coordinate, where:
- X increases from west to east
- Y increases from south to north

## Map Types

Civilization VII includes several built-in map types that you can extend or modify:

| Map Type | Description |
|----------|-------------|
| Pangaea | One large landmass |
| Continents | Several large landmasses |
| Islands | Many small landmasses |
| Archipelago | Numerous tiny islands |
| Inland Sea | Landmass surrounding a central sea |
| Mediterranean | Large sea with land around the edges |
| Earth | Recreation of Earth geography |
| Fractal | Generated using fractal algorithms |
| True Start Location | Civilizations begin at their historical locations |

## Map Script Modding

Map scripts are Lua files that control terrain generation. They provide the most flexibility for creating procedurally generated maps.

### Basic Map Script Structure

```lua
-- Example basic map script structure
include("MapUtilities");
include("TerrainGenerator");
include("FeatureGenerator");
include("RiverGenerator");
include("ResourceGenerator");

-- Map parameters
local g_iWidth = 0;
local g_iHeight = 0;

-- Initialize the map
function InitializeMap()
	-- Set map dimensions
	g_iWidth, g_iHeight = Map.GetGridSize();
	
	-- Initialize generators
	terrainGenerator = TerrainGenerator.Create();
	featureGenerator = FeatureGenerator.Create();
	riverGenerator = RiverGenerator.Create();
	resourceGenerator = ResourceGenerator.Create();
	
	-- Generate terrain layers
	GenerateTerrain();
	GenerateFeatures();
	GenerateRivers();
	GenerateResources();
	GenerateStartPositions();
end

-- Generate base terrain
function GenerateTerrain()
	print("Generating terrain...");
	
	-- Set terrain types
	for i = 0, g_iWidth - 1 do
		for j = 0, g_iHeight - 1 do
			local plot = Map.GetPlot(i, j);
			
			-- Implement your terrain creation logic here
			-- Example: create land in the center, water around edges
			local distFromCenter = math.sqrt((i - g_iWidth/2)^2 + (j - g_iHeight/2)^2);
			local maxDist = math.sqrt((g_iWidth/2)^2 + (g_iHeight/2)^2);
			
			if distFromCenter < maxDist * 0.6 then
				-- Land area
				plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
			else
				-- Ocean area
				plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
			end
		end
	end
	
	terrainGenerator:StampContinents();
end

-- Generate terrain features
function GenerateFeatures()
	print("Adding features...");
	featureGenerator:AddFeatures();
end

-- Generate rivers
function GenerateRivers()
	print("Adding rivers...");
	riverGenerator:AddRivers();
end

-- Generate resources
function GenerateResources()
	print("Adding resources...");
	resourceGenerator:AddResourcesLuxury();
	resourceGenerator:AddResourcesStrategic();
	resourceGenerator:AddResourcesBonus();
end

-- Generate starting positions for civilizations
function GenerateStartPositions()
	print("Generating start positions...");
	-- Implementation depends on the map type
end

-- Main map generation function
function GenerateMap()
	InitializeMap();
	return 1; -- Indicate generation was successful
end
```

### Map Script Location

Place your map script in:

```
YourMod/
└── scripts/
    └── Maps/
        └── YourCustomMap.lua
```

Then register it in your `.modinfo` file:

```xml
<AddGameplayScripts>
	<File>scripts/Maps/YourCustomMap.lua</File>
</AddGameplayScripts>
```

## WorldBuilder Tool

The WorldBuilder is a graphical tool for creating custom maps by hand.

### Accessing WorldBuilder

To access the WorldBuilder:

1. Enable the in-game console (see "HowToEnableIngameConsole" documentation)
2. Press ~ to open the console
3. Type `WorldBuilder` and press Enter

### WorldBuilder Controls

| Control | Action |
|---------|--------|
| Left-click | Select plot |
| Right-click | Apply current tool |
| Mouse wheel | Zoom in/out |
| WASD | Pan camera |
| T | Terrain brush |
| F | Feature brush |
| R | Resource brush |
| C | Civilization placement |
| U | Unit placement |
| B | City placement |
| L | Load map |
| S | Save map |

### Creating a Map in WorldBuilder

1. Start a new map with File → New
2. Set map dimensions and properties
3. Paint terrain using the terrain brush
4. Add features like forests and mountains
5. Place resources
6. Set start positions for civilizations
7. Save your map

### Saving and Loading

WorldBuilder maps are saved as `.Civ7Map` files. These can be distributed as part of your mod or converted to map scripts for better integration.

## Creating a Custom Map

Let's walk through creating a custom map mod:

### 1. Set Up the Mod Structure

```
CustomMapMod/
├── CustomMapMod.modinfo
├── Maps/
│   └── CustomEarth.Civ7Map
└── Scripts/
    └── Maps/
        └── CustomEarthGenerator.lua
```

### 2. Create the .modinfo File

```xml
<?xml version="1.0" encoding="utf-8"?>
<Mod id="com.example.custom-earth-map" version="1" xmlns="ModInfo">
	<Properties>
		<n>Custom Earth Map</n>
		<Description>A detailed recreation of Earth with balanced start positions.</Description>
		<Authors>Your Name</Authors>
		<Package>Mod</Package>
	</Properties>
	<Dependencies>
		<Mod id="base-standard" title="LOC_MODULE_BASE_STANDARD_NAME"/>
	</Dependencies>
	<ActionCriteria>
		<Criteria id="always">
			<AlwaysMet></AlwaysMet>
		</Criteria>
	</ActionCriteria>
	<ActionGroups>
		<ActionGroup id="ModGroup" scope="game" criteria="always">
			<Properties>
				<LoadOrder>50</LoadOrder>
			</Properties>
			<Actions>
				<AddGameplayScripts>
					<File>Scripts/Maps/CustomEarthGenerator.lua</File>
				</AddGameplayScripts>
				<ImportFiles>
					<Items>
						<File>Maps/CustomEarth.Civ7Map</File>
					</Items>
				</ImportFiles>
			</Actions>
		</ActionGroup>
	</ActionGroups>
</Mod>
```

### 3. Develop Your Map Script

Create a Lua script that generates your map:

```lua
-- CustomEarthGenerator.lua
include("MapUtilities");
include("TerrainGenerator");
include("FeatureGenerator");

function GenerateMap()
	-- Initialize map size based on game settings
	local width, height = Map.GetGridSize();
	
	-- Create a realistic Earth map
	CreateEarthTerrain(width, height);
	AddMountainRanges();
	AddRivers();
	PlaceResources();
	
	-- Add true start locations for civilizations
	AddStartLocations();
	
	return 1;
end

function CreateEarthTerrain(width, height)
	-- Implementation for Earth-like terrain generation
	print("Creating Earth terrain...");
	
	-- Define major landmasses
	local continents = {
		{name = "North America", x1 = 0.05, y1 = 0.5, x2 = 0.25, y2 = 0.9},
		{name = "South America", x1 = 0.1, y1 = 0.1, x2 = 0.25, y2 = 0.5},
		{name = "Europe", x1 = 0.4, y1 = 0.6, x2 = 0.5, y2 = 0.85},
		{name = "Africa", x1 = 0.4, y1 = 0.2, x2 = 0.55, y2 = 0.6},
		{name = "Asia", x1 = 0.5, y1 = 0.4, x2 = 0.85, y2 = 0.9},
		{name = "Australia", x1 = 0.75, y1 = 0.1, x2 = 0.9, y2 = 0.3}
	};
	
	-- Create each continent
	for i, continent in ipairs(continents) do
		local x1 = math.floor(continent.x1 * width);
		local y1 = math.floor(continent.y1 * height);
		local x2 = math.floor(continent.x2 * width);
		local y2 = math.floor(continent.y2 * height);
		
		print("Creating " .. continent.name);
		
		for x = x1, x2 do
			for y = y1, y2 do
				local plot = Map.GetPlot(x, y);
				if plot then
					-- Create continent with some randomness at edges
					local distFromEdge = math.min(
						x - x1, x2 - x, 
						y - y1, y2 - y
					);
					
					if distFromEdge > 3 or (distFromEdge > 0 and math.random() > 0.4) then
						-- Determine terrain type based on latitude
						local latitude = y / height;
						if latitude > 0.8 or latitude < 0.2 then
							plot:SetTerrainType(TerrainTypes.TERRAIN_TUNDRA, false);
						elseif latitude > 0.7 or latitude < 0.3 then
							plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false);
						elseif latitude > 0.5 or latitude < 0.5 then
							plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
						else
							plot:SetTerrainType(TerrainTypes.TERRAIN_DESERT, false);
						end
					else
						plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
					end
				end
			end
		end
	end
end

function AddMountainRanges()
	-- Implementation for major mountain ranges
	print("Adding mountain ranges...");
	
	local mountainRanges = {
		{name = "Rockies", x1 = 0.12, y1 = 0.6, x2 = 0.18, y2 = 0.85},
		{name = "Andes", x1 = 0.18, y1 = 0.15, x2 = 0.22, y2 = 0.45},
		{name = "Alps", x1 = 0.42, y1 = 0.65, x2 = 0.48, y2 = 0.7},
		{name = "Himalayas", x1 = 0.6, y1 = 0.6, x2 = 0.7, y2 = 0.65}
	};
	
	local width, height = Map.GetGridSize();
	
	for i, range in ipairs(mountainRanges) do
		local x1 = math.floor(range.x1 * width);
		local y1 = math.floor(range.y1 * height);
		local x2 = math.floor(range.x2 * width);
		local y2 = math.floor(range.y2 * height);
		
		print("Creating " .. range.name);
		
		for x = x1, x2 do
			for y = y1, y2 do
				if math.random() < 0.6 then
					local plot = Map.GetPlot(x, y);
					if plot and plot:IsLand() then
						plot:SetFeatureType(FeatureTypes.FEATURE_MOUNTAIN);
					end
				end
			end
		end
	end
end

function AddRivers()
	-- River implementation
end

function PlaceResources()
	-- Resource placement
end

function AddStartLocations()
	-- Implementation for civilization start positions
	print("Adding true start locations...");
	
	local startPositions = {
		{civ = "CIVILIZATION_AMERICA", x = 0.15, y = 0.7},
		{civ = "CIVILIZATION_ENGLAND", x = 0.42, y = 0.75},
		{civ = "CIVILIZATION_FRANCE", x = 0.44, y = 0.7},
		{civ = "CIVILIZATION_GERMANY", x = 0.48, y = 0.72},
		{civ = "CIVILIZATION_RUSSIA", x = 0.55, y = 0.8},
		{civ = "CIVILIZATION_CHINA", x = 0.7, y = 0.65},
		{civ = "CIVILIZATION_JAPAN", x = 0.8, y = 0.7},
		{civ = "CIVILIZATION_EGYPT", x = 0.52, y = 0.5},
		{civ = "CIVILIZATION_ROME", x = 0.47, y = 0.63}
	};
	
	local width, height = Map.GetGridSize();
	
	for i, position in ipairs(startPositions) do
		local x = math.floor(position.x * width);
		local y = math.floor(position.y * height);
		local plot = Map.GetPlot(x, y);
		
		if plot and plot:IsLand() then
			local startConfig = {
				-- Set specific civilization start
				CivilizationType = position.civ,
				Position = {x = x, y = y}
			};
			
			Map.PlaceStartingPosition(startConfig);
		end
	end
end
```

## Map Generation Parameters

When creating a map script, you can expose parameters for players to customize:

```lua
-- Define map parameters
local MapParameters = {
	{
		Name = "Sea Level",
		Values = {
			{Name = "Low", Description = "More land, less ocean", Value = 0.3},
			{Name = "Medium", Description = "Balanced land and ocean", Value = 0.5, Default = true},
			{Name = "High", Description = "Less land, more ocean", Value = 0.7}
		}
	},
	{
		Name = "Temperature",
		Values = {
			{Name = "Cold", Description = "More tundra and snow, less desert", Value = "Cold"},
			{Name = "Temperate", Description = "Balanced climate regions", Value = "Temperate", Default = true},
			{Name = "Hot", Description = "More desert, less tundra and snow", Value = "Hot"}
		}
	},
	{
		Name = "Resources",
		Values = {
			{Name = "Sparse", Description = "Fewer resources", Value = 0.7},
			{Name = "Standard", Description = "Standard resource distribution", Value = 1.0, Default = true},
			{Name = "Abundant", Description = "More resources", Value = 1.3}
		}
	}
};

function GetMapParameters()
	return MapParameters;
end
```

## Advanced Map Scripts

### Terrain Generation Techniques

#### Perlin Noise

Perlin noise is excellent for creating natural-looking terrain:

```lua
function GenerateTerrainWithPerlinNoise(width, height)
	local perlin = require("PerlinNoise");
	local noiseMap = {};
	
	-- Generate noise map
	for x = 0, width - 1 do
		noiseMap[x] = {};
		for y = 0, height - 1 do
			-- Multiple frequencies of noise for more detail
			local nx = x / width - 0.5;
			local ny = y / height - 0.5;
			
			noiseMap[x][y] = 
				perlin.noise(1 * nx, 1 * ny) * 1.0 +
				perlin.noise(2 * nx, 2 * ny) * 0.5 +
				perlin.noise(4 * nx, 4 * ny) * 0.25 +
				perlin.noise(8 * nx, 8 * ny) * 0.125;
				
			-- Normalize
			noiseMap[x][y] = (noiseMap[x][y] + 1) / 2;
		end
	end
	
	-- Apply noise map to terrain
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			local plot = Map.GetPlot(x, y);
			local value = noiseMap[x][y];
			
			if value < 0.4 then
				plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
			elseif value < 0.45 then
				plot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false);
			elseif value < 0.55 then
				plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
			elseif value < 0.7 then
				plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false);
			elseif value < 0.85 then
				plot:SetTerrainType(TerrainTypes.TERRAIN_DESERT, false);
			else
				plot:SetTerrainType(TerrainTypes.TERRAIN_MOUNTAIN, false);
			end
		end
	end
end
```

#### Plate Tectonics Simulation

For realistic continents, simulate plate tectonics:

```lua
function SimulatePlateTectonics(width, height, numPlates)
	-- Create initial plates
	local plates = {};
	for i = 1, numPlates do
		plates[i] = {
			x = math.random(0, width - 1),
			y = math.random(0, height - 1),
			movement = { 
				x = math.random(-100, 100) / 100, 
				y = math.random(-100, 100) / 100 
			},
			isOceanic = (math.random() < 0.6)
		};
	end
	
	-- Assign each plot to nearest plate
	local plotPlates = {};
	for x = 0, width - 1 do
		plotPlates[x] = {};
		for y = 0, height - 1 do
			local nearestPlate = 1;
			local minDist = 999999;
			
			for i, plate in ipairs(plates) do
				local dx = math.min(math.abs(x - plate.x), width - math.abs(x - plate.x));
				local dy = math.min(math.abs(y - plate.y), height - math.abs(y - plate.y));
				local dist = math.sqrt(dx * dx + dy * dy);
				
				if dist < minDist then
					minDist = dist;
					nearestPlate = i;
				end
			end
			
			plotPlates[x][y] = nearestPlate;
		end
	end
	
	-- Find plate boundaries (potential mountain ranges and oceanic trenches)
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			local plot = Map.GetPlot(x, y);
			local plateIndex = plotPlates[x][y];
			
			-- Check neighbors for different plates
			local boundaries = 0;
			for direction = 0, 5 do
				local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
				if adjacentPlot then
					local nx = adjacentPlot:GetX();
					local ny = adjacentPlot:GetY();
					if plotPlates[nx][ny] ~= plateIndex then
						boundaries = boundaries + 1;
					end
				end
			end
			
			-- Determine terrain based on plate type and boundaries
			if plates[plateIndex].isOceanic then
				if boundaries > 2 then
					-- Oceanic trench or volcanic island
					if math.random() < 0.3 then
						plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
						plot:SetFeatureType(FeatureTypes.FEATURE_VOLCANO);
					else
						plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
					end
				else
					plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
				end
			else
				if boundaries > 2 then
					-- Continental collision - mountain range
					plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
					plot:SetFeatureType(FeatureTypes.FEATURE_MOUNTAIN);
				else
					plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false);
				end
			end
		end
	end
end
```

### Specialized Map Patterns

#### Archipelago Generation

```lua
function GenerateArchipelago(width, height)
	local numIslands = math.floor(width * height / 300);
	local islands = {};
	
	-- Create island centers
	for i = 1, numIslands do
		islands[i] = {
			x = math.random(0, width - 1),
			y = math.random(0, height - 1),
			size = math.random(3, 8)
		};
	end
	
	-- Set entire map to ocean first
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			local plot = Map.GetPlot(x, y);
			plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
		end
	end
	
	-- Create islands
	for i, island in ipairs(islands) do
		local size = island.size;
		
		for dx = -size, size do
			for dy = -size, size do
				local distance = math.sqrt(dx * dx + dy * dy);
				if distance <= size then
					local x = (island.x + dx) % width;
					local y = (island.y + dy) % height;
					
					-- Islands get smaller as distance increases
					local probability = 1.0 - (distance / size);
					if math.random() < probability then
						local plot = Map.GetPlot(x, y);
						plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
					end
				end
			end
		end
	end
end
```

#### Pangaea with Inland Sea

```lua
function GeneratePangaeaWithInlandSea(width, height)
	-- Central coordinates
	local centerX = width / 2;
	local centerY = height / 2;
	
	-- Radii for continent and inland sea
	local continentRadius = math.min(width, height) * 0.4;
	local seaRadius = continentRadius * 0.5;
	
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			local plot = Map.GetPlot(x, y);
			
			-- Calculate distance from center
			local dx = x - centerX;
			local dy = y - centerY;
			local distFromCenter = math.sqrt(dx * dx + dy * dy);
			
			-- Add some randomness to edges
			local continentEdge = continentRadius * (0.9 + math.random() * 0.2);
			local seaEdge = seaRadius * (0.9 + math.random() * 0.2);
			
			if distFromCenter < seaEdge then
				-- Inland sea
				plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
			elseif distFromCenter < continentEdge then
				-- Continent
				plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
			else
				-- Outer ocean
				plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
			}
		end
	end
end
```

## Testing and Debugging

### Testing Your Map

1. **In-Game Testing**:
   - Enable your mod in the Additional Content menu
   - Create a new game and select your custom map
   - Play through the early game to check resource balance and start positions

2. **Debug Output**:
   - Add `print()` statements to your Lua code for debugging
   - Check the game logs for these outputs

3. **Debug Mode**:
   ```lua
   local DEBUG_MODE = true;
   
   function DebugPrint(message)
       if DEBUG_MODE then
           print("DEBUG: " .. message);
       end
   end
   ```

### Common Map Issues and Solutions

| Issue | Solution |
|-------|----------|
| Civilizations start too close | Increase the minimum distance between start positions |
| Resource distribution uneven | Adjust resource placement algorithms |
| Too much/little land | Modify terrain generation thresholds |
| Rivers not flowing correctly | Check river generation logic |
| Mountain ranges misplaced | Adjust mountain placement coordinates |
| Performance issues | Optimize algorithms, especially for larger maps |

## Map Distribution

### Including Maps in Mods

1. **WorldBuilder Map File**:
   - Include the `.Civ7Map` file directly
   - Register it in the `.modinfo` file

2. **Script-Generated Map**:
   - Include the Lua script
   - Register it with `AddGameplayScripts`

3. **Both**:
   - Include both for maximum flexibility
   - The script provides procedural generation
   - The WorldBuilder file provides a specific instance

### Making Your Map Available in Game

For your map to appear in the game's map selection:

```lua
function GetMapName()
	return "Custom Earth";
end

function GetMapDescription()
	return "A detailed recreation of Earth with balanced start positions for up to 12 players.";
end

function GetMapSize()
	return { 
		[60] = "Small", 
		[74] = "Standard", 
		[96] = "Large"
	};
end

function IsWrapX()
	return true; -- Allows East-West map wrapping
end

function IsWrapY()
	return false; -- Disables North-South map wrapping
end
```

## Examples

### Small Island Clusters

```lua
-- SmallIslandClusters.lua
function GenerateMap()
	local width, height = Map.GetGridSize();
	
	-- Set all to ocean
	for x = 0, width - 1 do
		for y = 0, height - 1 do
			local plot = Map.GetPlot(x, y);
			plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false);
		end
	end
	
	-- Create island clusters
	local numClusters = 5;
	for i = 1, numClusters do
		-- Random cluster center
		local centerX = math.random(0, width - 1);
		local centerY = math.random(0, height - 1);
		
		-- Create 3-8 islands per cluster
		local islandsInCluster = math.random(3, 8);
		
		for j = 1, islandsInCluster do
			-- Island position near cluster center
			local islandX = (centerX + math.random(-10, 10)) % width;
			local islandY = (centerY + math.random(-10, 10)) % height;
			
			-- Island size
			local size = math.random(2, 5);
			
			-- Create the island
			for dx = -size, size do
				for dy = -size, size do
					local distance = math.sqrt(dx * dx + dy * dy);
					if distance <= size and math.random() > distance / size then
						local x = (islandX + dx) % width;
						local y = (islandY + dy) % height;
						
						local plot = Map.GetPlot(x, y);
						if plot then
							plot:SetTerrainType(TerrainTypes.TERRAIN_GRASS, false);
							
							-- Add some forests
							if math.random() < 0.3 then
								plot:SetFeatureType(FeatureTypes.FEATURE_FOREST);
							end
						end
					end
				end
			end
		end
	end
	
	-- Add resources appropriate for islands
	AddIslandResources();
	
	-- Place start positions on the largest islands
	CalculateStartPositions();
	
	return 1;
end
```

### Historical Europe

```lua
-- HistoricalEurope.lua
function GenerateMap()
	local width, height = Map.GetGridSize();
	
	-- Create land outline based on simplified Europe geography
	CreateEuropeLandmass(width, height);
	
	-- Add major mountain ranges
	AddMountains("Alps", 0.48, 0.42, 5);
	AddMountains("Pyrenees", 0.35, 0.32, 3);
	AddMountains("Carpathians", 0.6, 0.4, 4);
	
	-- Add major rivers
	AddRiver("Rhine", 0.45, 0.55, 0.45, 0.35);
	AddRiver("Danube", 0.49, 0.45, 0.65, 0.38);
	AddRiver("Seine", 0.39, 0.45, 0.35, 0.4);
	AddRiver("Thames", 0.38, 0.52, 0.38, 0.5);
	
	-- Add major forests
	AddForests();
	
	-- Add resources with historical distribution
	AddHistoricalResources();
	
	-- Set true start locations for European civilizations
	SetTrueStartLocations();
	
	return 1;
end

function SetTrueStartLocations()
	local width, height = Map.GetGridSize();
	
	local startLocations = {
		{civ = "CIVILIZATION_ENGLAND", x = 0.38, y = 0.53},
		{civ = "CIVILIZATION_FRANCE", x = 0.4, y = 0.45},
		{civ = "CIVILIZATION_GERMANY", x = 0.48, y = 0.48},
		{civ = "CIVILIZATION_ROME", x = 0.5, y = 0.3},
		{civ = "CIVILIZATION_GREECE", x = 0.6, y = 0.25},
		{civ = "CIVILIZATION_RUSSIA", x = 0.7, y = 0.5},
		{civ = "CIVILIZATION_SPAIN", x = 0.3, y = 0.3}
	};
	
	for _, location in ipairs(startLocations) do
		local x = math.floor(location.x * width);
		local y = math.floor(location.y * height);
		
		local startConfig = {
			CivilizationType = location.civ,
			Position = {x = x, y = y}
		};
		
		Map.PlaceStartingPosition(startConfig);
	end
end
```

## Additional Resources

- [Gameplay Modding Guide](./gameplay-modding.md) - For integrating map features with gameplay
- [Database Modding Guide](./database-modding.md) - For understanding terrain and feature definitions
- [Map Script Mod Template](./templates/mapscript-mod/) - A ready-to-use template for creating custom map scripts

---

*Creating custom maps and scripts allows you to craft unique gameplay experiences that can dramatically change how Civilization VII is played!* 