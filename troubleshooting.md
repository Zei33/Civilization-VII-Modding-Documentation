# Troubleshooting Guide for Civilization VII Modding

This guide addresses common issues that modders encounter when developing mods for Civilization VII and provides solutions to help you resolve them quickly.

## Table of Contents
- [General Troubleshooting](#general-troubleshooting)
- [Mod Not Appearing](#mod-not-appearing)
- [Game Crashes](#game-crashes)
- [Database Errors](#database-errors)
- [UI Issues](#ui-issues)
- [Asset Problems](#asset-problems)
- [Lua Script Issues](#lua-script-issues)
- [Performance Problems](#performance-problems)
- [Multiplayer Compatibility Issues](#multiplayer-compatibility-issues)
- [Debugging Tips and Tools](#debugging-tips-and-tools)
- [Common Error Messages](#common-error-messages)
- [Compatibility with Other Mods](#compatibility-with-other-mods)
- [Getting Help from the Community](#getting-help-from-the-community)
- [Related Documentation](#related-documentation)

## General Troubleshooting

### Basic Troubleshooting Steps

1. **Check for Updates**:
   - Make sure your game is fully updated
   - Check for updates to any modding tools you're using

2. **Read the Logs**:
   - Civilization VII produces log files that can help identify issues
   - Log locations:
     - Windows: `C:\Users\[YourUsername]\Documents\My Games\Civilization VII\Logs`
     - macOS: `~/Library/Application Support/Civilization VII/Logs`
     - Linux: `~/.local/share/Civilization VII/Logs`

3. **Isolate the Issue**:
   - Disable other mods to check for conflicts
   - Comment out parts of your mod to identify problematic sections
   - Test with a new game (not a saved game)

4. **Verify Game Files**:
   - On Steam: Right-click the game → Properties → Local Files → Verify Integrity of Game Files
   - On Epic: Library → Three dots next to Civilization VII → Verify

5. **API Compatibility**:
   - Use the correct API interfaces:
     - Use `engine.on()` and `engine.trigger()` instead of `UIEvents.on()` and `GameEvents.SendMessage()`
     - Use `Locale.Lookup()` instead of `Game.Localize()`
     - Use `UI.ShowPopupNotification()` instead of `UI.ShowNotification()`
   - Implement a proper request-response pattern for asynchronous communication
   - Using incorrect API interfaces is a common cause of non-functional mods

> **See Also:** For a basic understanding of mod structure, refer to the [Mod Structure Guide](./mod-structure.md).

## Mod Not Appearing

If your mod doesn't appear in the in-game mod list:

### Check the Mod File Structure

1. **Confirm the Mod Location**:
   - Ensure your mod is in the correct directory:
     - Windows: `C:\Users\[YourUsername]\Documents\My Games\Civilization VII\Mods`
     - macOS: `/Users/[YourUsername]/Library/Application Support/Civilization VII/Mods`
     - Linux: `~/.local/share/Civilization VII/Mods`

2. **Verify File Structure**:
   - Your mod should have a root folder with a `.modinfo` file
   - The `.modinfo` filename should match your folder name

### Check the ModInfo File

1. **ModInfo Syntax**:
   - Ensure the XML is well-formed
   - Check for missing or mismatched tags
   - Verify the XML declaration is present: `<?xml version="1.0" encoding="utf-8"?>`

2. **Required Elements**:
   ```xml
   <Mod id="your.unique.mod.id" version="1" xmlns="ModInfo">
     <Properties>
       <Name>Your Mod Name</Name>
       <Description>Your mod description</Description>
       <Authors>Your Name</Authors>
       <Package>Mod</Package>
     </Properties>
     <!-- Dependencies, ActionGroups, etc. -->
   </Mod>
   ```

3. **Common ModInfo Issues**:
   - Missing or incorrect namespace: `xmlns="ModInfo"`
   - Non-unique mod ID (conflicts with another mod)
   - Missing required Properties elements

> **Related Topic:** For more information on proper mod structure, check the [Mod Structure Guide](./mod-structure.md#modinfo-file).

## Game Crashes

When the game crashes while using your mod:

### On Startup Crashes

1. **Check Mod Dependencies**:
   - Ensure all required mods are enabled
   - Verify dependency order in your `.modinfo` file

2. **Check File References**:
   - Make sure all files referenced in your `.modinfo` exist
   - Verify file paths are correct (note: paths are case-sensitive)

3. **XML Validation**:
   - Use an XML validator to check your mod's XML files
   - Look for unclosed tags, invalid characters, or incorrect nesting

### During Gameplay Crashes

1. **Check the Error Log**:
   - Look for lines in the log file that mention your mod
   - Pay attention to any exceptions or error messages

2. **Common Causes**:
   - Accessing nil values in Lua scripts
   - Infinite loops in game events
   - Invalid database entries (foreign key constraints)
   - Missing assets that the game tries to load

3. **Isolate the Issue**:
   - Comment out different parts of your mod
   - Add one component at a time until you find what's causing the crash

### Example: Finding a Crash in a Lua Script

```lua
-- Add debug output to help isolate the crash
function OnUnitCreated(playerID, unitID)
    print("Debug: Function started with playerID=" .. playerID .. ", unitID=" .. unitID);
    
    local player = Players[playerID];
    print("Debug: Player object obtained");
    
    if player then
        local unit = player:GetUnits():FindID(unitID);
        print("Debug: Unit object obtained");
        
        if unit then
            local unitType = unit:GetType();
            print("Debug: UnitType=" .. unitType);
            
            -- Here's where the crash might happen if GameInfo.Units[unitType] doesn't exist
            local unitInfo = GameInfo.Units[unitType];
            
            if unitInfo then
                print("Debug: UnitInfo obtained for " .. unitInfo.UnitType);
                -- Rest of function...
            else
                print("Debug: UnitInfo is nil for type " .. unitType);
            end
        end
    end
end
```

> **See Also:** For advanced debugging techniques for complex mods, refer to the [Advanced Topics Guide](./advanced-topics.md#debugging-tools-and-techniques).

## Database Errors

When your database modifications aren't working:

### SQL Syntax Issues

1. **Check Basic SQL Syntax**:
   - Ensure all statements end with semicolons
   - Check for proper quoting of string values
   - Verify table and column names exist in the game database

2. **Common SQL Mistakes**:
   - Missing quotes around string values
   - Using the wrong case for table or column names
   - Assuming non-existent columns or tables

3. **Testing SQL Statements**:
   - Use a SQLite browser to test your statements against the game database
   - Validate complex queries before adding them to your mod

### Foreign Key Constraints

1. **Adding New Content**:
   - Remember to add entries to the `Types` table before referencing them
   - Follow the proper order of operations (create parent records before child records)

2. **Example Correct Order**:
   ```sql
   -- First add the type
   INSERT INTO Types (Type, Kind)
   VALUES ('BUILDING_MY_CUSTOM_BUILDING', 'KIND_BUILDING');
   
   -- Then reference it in the Buildings table
   INSERT INTO Buildings (BuildingType, Name, Cost)
   VALUES ('BUILDING_MY_CUSTOM_BUILDING', 'LOC_MY_BUILDING_NAME', 100);
   
   -- Then add any child records
   INSERT INTO BuildingModifiers (BuildingType, ModifierId)
   VALUES ('BUILDING_MY_CUSTOM_BUILDING', 'MODIFIER_MY_BUILDING_EFFECT');
   ```

### Database Update Not Applied

1. **Check Registration**:
   - Ensure your SQL file is properly listed in the `.modinfo` file:
     ```xml
     <UpdateDatabase>
       <Item>data/my_database_changes.sql</Item>
     </UpdateDatabase>
     ```

2. **Load Order Issues**:
   - Check if your mod's load order is causing conflicts
   - Set an appropriate load order in your ActionGroup

3. **Action Criteria**:
   - Verify your ActionCriteria allow the database updates to be applied
   - Test with an "always" criteria to rule out criteria issues:
     ```xml
     <Criteria id="always">
       <AlwaysMet></AlwaysMet>
     </Criteria>
     ```

> **Related Topic:** For comprehensive database information, see the [Database Modding Guide](./database-modding.md).

## UI Issues

When your UI modifications aren't working correctly:

### UI Not Appearing

1. **File Registration**:
   - Check that your UI files are correctly registered in the `.modinfo`:
     ```xml
     <ReplaceUIScript id="custom-panel">
       <File>ui/Panels/CustomPanel.xml</File>
     </ReplaceUIScript>
     ```

2. **Path Matching**:
   - UI replacements must match the original file path exactly
   - Check for case sensitivity in file paths

### UI-Game Communication Issues

1. **Using Deprecated APIs**:
   - **Problem**: Non-functional UI when using outdated API methods
   - **Solution**: Replace deprecated interfaces with the supported engine APIs:
     ```javascript
     // INCORRECT
     UIEvents.on("ElementName", "click", function() {...});
     GameEvents.SendMessage("GameEvent", data);
     
     // CORRECT
     document.getElementById("ElementName").addEventListener("click", function() {...});
     engine.trigger("GameEvent", data);
     ```

2. **Event Communication**:
   - **Problem**: UI sends events but game doesn't respond
   - **Solution**: Use request-response pattern with unique IDs:
     ```javascript
     // Generate unique request ID
     const requestId = "DataRequest_" + Date.now();
     
     // Listen for response with this specific ID
     engine.on('DataResponse_' + requestId, function(data) {
       // Clean up the listener when done
       engine.off('DataResponse_' + requestId);
       // Process response...
     });
     
     // Send request with the ID
     engine.trigger("RequestData", { requestId: requestId, /* other params */ });
     ```

3. **Script Registration Issues**:
   - **Problem**: Lua script doesn't handle UI events
   - **Solution**: Use the correct event registration and response pattern:
     ```lua
     -- Register for UI events in Lua
     Events.ScriptEvent.Add("RequestData", function(params)
       -- Process the request
       local result = ProcessTheRequest(params);
       
       -- Send response back to UI
       UI.QueueEvent("DataResponse_" .. params.requestId, result);
     end);
     ```

4. **Localization and Notifications**:
   - **Problem**: Text not displaying or notifications not showing
   - **Solution**: Use the correct API methods:
     ```javascript
     // INCORRECT
     const text = Game.Localize("LOC_TEXT_KEY");
     UI.ShowNotification(text, "positive");
     
     // CORRECT
     const text = Locale.Lookup("LOC_TEXT_KEY");
     UI.ShowPopupNotification(text, "positive");
     ```

3. **Base Game Updates**:
   - Game updates might have changed the UI structure
   - Compare your mod with the current version of the base game files

### UI Styling Problems

1. **CSS Specificity**:
   - Use more specific selectors to ensure your styles are applied
   - Check for conflicting styles from other mods or the base game

2. **Example of Improving CSS Specificity**:
   ```css
   /* Less specific - might be overridden */
   .ResourceIcon {
     width: 32px;
   }
   
   /* More specific - more likely to be applied */
   .ResourcePanel .ResourceList .ResourceIcon {
     width: 32px;
   }
   ```

### JavaScript Errors

1. **Check the Console**:
   - Use the in-game debug console (F12) to check for JavaScript errors
   - Look for undefined objects or functions

2. **Common JS Issues**:
   - Trying to access DOM elements before they exist
   - Conflicting variable names with other mods
   - Missing event handlers

3. **Debugging JavaScript**:
   ```javascript
   // Add console.log statements to trace execution
   console.log("About to initialize MyMod");
   
   // Check if objects exist before using them
   if (document.getElementById("ResourcePanel")) {
     console.log("Found ResourcePanel, modifying it");
     // Modify the panel...
   } else {
     console.log("ResourcePanel not found!");
   }
   
   // Wrap code in try/catch to prevent crashes
   try {
     // Potentially problematic code
     customizeResourcePanel();
   } catch (error) {
     console.error("Error in customizeResourcePanel:", error);
   }
   ```

> **See Also:** For detailed UI development guidance, check the [UI Modding Guide](./ui-modding.md).

## Asset Problems

When custom assets aren't appearing or working correctly:

### Missing Assets

1. **File Registration**:
   - Ensure assets are properly listed in your `.modinfo`:
     ```xml
     <ImportFiles>
       <Items>
         <File>art/civilization/my_civ_icon.dds</File>
         <!-- Other assets -->
       </Items>
     </ImportFiles>
     ```

2. **File Path Issues**:
   - Check for typos in file paths
   - Verify case sensitivity
   - Ensure the full path from the mod root is correct

3. **Database Registration**:
   - Assets need database entries to link them to game elements:
     ```sql
     INSERT INTO CivilizationIcons (CivilizationType, IconType, IconName)
     VALUES ('CIVILIZATION_MY_CIV', 'ICON_CIVILIZATION_LARGE', 'art/civilization/my_civ_icon.dds');
     ```

### Asset Format Problems

1. **Texture Formats**:
   - Ensure textures are in the correct format (DDS with appropriate compression)
   - Verify dimensions are powers of 2 (256x256, 512x512, etc.)

2. **Model Formats**:
   - Models should be in FBX format
   - Check orientation and scale match the game's expectations

3. **Audio Formats**:
   - Audio should be in WAV or OGG format
   - Check sample rate and bit depth (typically 44.1 kHz, 16-bit)

### Converting Assets

1. **Converting to DDS**:
   - Use tools like Nvidia Texture Tools or Intel Texture Works
   - Command line conversion using DirectXTex tools:
     ```
     texconv -m 1 -f BC3_UNORM input.png -o output_directory
     ```

2. **Converting Audio**:
   - Use tools like Audacity for WAV export
   - For OGG conversion, use tools like ffmpeg:
     ```
     ffmpeg -i input.wav -c:a libvorbis -q:a 5 output.ogg
     ```

> **Related Topic:** For detailed instructions on creating and implementing assets, see the [Asset Creation Guide](./asset-creation.md).

## Lua Script Issues

When your Lua scripts aren't functioning correctly:

### Script Not Running

1. **File Registration**:
   - Check that your Lua files are properly registered in the `.modinfo`:
     ```xml
     <AddGameplayScripts>
       <File>scripts/my_script.lua</File>
     </AddGameplayScripts>
     ```

2. **Load Errors**:
   - Look for Lua syntax errors in the logs
   - Check for missing required files (included via `include()`)

3. **Initialization Issues**:
   - Ensure your script initializes properly
   - Check if initialization function is called at the right time

### Event Handlers Not Firing

1. **Event Registration**:
   - Verify events are registered correctly:
     ```lua
     function Initialize()
       GameEvents.PlayerTurnStarted.Add(OnPlayerTurnStarted);
     end
     
     function OnPlayerTurnStarted(playerID)
       print("Player " .. playerID .. " turn started");
     end
     
     Initialize(); -- Don't forget to call your initialize function!
     ```

2. **Event Timing**:
   - Some events may need to be registered at specific times
   - Try registering to different core events like `GameEvents.LoadScreenClose`

3. **Debugging Event Registration**:
   ```lua
   -- Check if events are registered properly
   function Initialize()
     print("Registering event handlers...");
     if GameEvents and GameEvents.PlayerTurnStarted then
       print("PlayerTurnStarted event exists, registering handler");
       GameEvents.PlayerTurnStarted.Add(OnPlayerTurnStarted);
     else
       print("ERROR: PlayerTurnStarted event does not exist!");
     end
   end
   ```

### Lua Runtime Errors

1. **Nil Value Errors**:
   - Always check if objects exist before accessing their properties:
     ```lua
     -- Unsafe:
     local cityName = city:GetName();
     
     -- Safe:
     local cityName = "Unknown";
     if city then
       cityName = city:GetName();
     end
     ```

2. **Scope Issues**:
   - Be aware of variable scope in Lua:
     ```lua
     -- This won't work as expected
     local function Setup()
       localVar = "test"; -- Note: no 'local' keyword makes this global
     end
     
     function UseVar()
       print(localVar); -- May be nil or have unexpected value
     end
     
     -- Better approach
     local sharedVar; -- Declare at file scope
     
     local function Setup()
       sharedVar = "test";
     end
     
     function UseVar()
       print(sharedVar);
     end
     ```

> **See Also:** For advanced Lua techniques, refer to the [Advanced Topics Guide](./advanced-topics.md#lua-scripting-advanced-techniques).

## Performance Problems

When your mod causes performance issues:

### Identifying Performance Issues

1. **Isolate the Problem**:
   - Enable and disable different components of your mod
   - Test with various game settings and map sizes

2. **Monitor Resource Usage**:
   - Check CPU and memory usage while playing
   - Look for sudden spikes when certain actions occur

3. **In-Game Profiling**:
   - Use the game's debug console to check for performance metrics
   - Look for frame time increases when your mod is active

### Common Performance Bottlenecks

1. **Inefficient Loops**:
   ```lua
   -- Inefficient:
   function CheckAllUnits()
     for playerID = 0, GameDefines.MAX_PLAYERS-1 do
       local player = Players[playerID];
       if player and player:IsAlive() then
         local units = player:GetUnits();
         for i = 0, units:GetCount()-1 do
           local unit = units:GetAt(i);
           -- Do something with every unit on every turn
         end
       end
     end
   end
   GameEvents.PlayerTurnStarted.Add(CheckAllUnits);
   
   -- More efficient:
   function CheckUnitWhenCreated(playerID, unitID)
     local player = Players[playerID];
     if player then
       local unit = player:GetUnits():FindID(unitID);
       if unit then
         -- Do something only with this unit when it's created
       end
     end
   end
   GameEvents.UnitAddedToMap.Add(CheckUnitWhenCreated);
   ```

2. **Excessive Event Handlers**:
   - Limit the number of event handlers you register
   - Combine handlers for similar events where possible

3. **Database Operation Efficiency**:
   - Use targeted updates rather than large table scans
   - Index tables that you query frequently

### Optimization Techniques

1. **Caching Results**:
   ```lua
   -- Cache results of expensive calculations
   local cachedResults = {};
   
   function ExpensiveCalculation(unitType)
     if cachedResults[unitType] then
       return cachedResults[unitType];
     end
     
     -- Perform expensive calculation
     local result = PerformComplexComputation(unitType);
     
     -- Cache the result
     cachedResults[unitType] = result;
     return result;
   end
   ```

2. **Throttling Updates**:
   ```lua
   -- Only update UI every few turns instead of every turn
   local turnCounter = 0;
   
   function OnTurnBegin()
     turnCounter = turnCounter + 1;
     
     -- Only update every 5 turns
     if turnCounter % 5 == 0 then
       UpdateExpensiveUI();
     end
   end
   ```

3. **Optimizing Asset Usage**:
   - Use appropriate texture sizes
   - Implement level-of-detail for complex models
   - Unload assets when not needed

> **Related Topic:** For optimization techniques, see the [Advanced Topics Guide](./advanced-topics.md#performance-optimization).

## Multiplayer Compatibility Issues

When your mod causes problems in multiplayer games:

### Desyncs

1. **Identifying Desyncs**:
   - Players see different game states
   - Error messages about synchronization
   - Players getting kicked from games

2. **Common Causes of Desyncs**:
   - Client-side only changes affecting gameplay
   - Inconsistent random number generation
   - Different mod versions between players

3. **Preventing Desyncs**:
   - Use the game's synchronized RNG system:
     ```lua
     -- Don't use this in multiplayer
     local randomValue = math.random(1, 10);
     
     -- Use this instead
     local randomValue = Game.GetRandNum(10, "My mod random roll");
     ```
   - Avoid client-side modifications to gameplay state
   - Ensure all players have identical mod versions

### UI/Gameplay Separation

1. **Separate UI from Gameplay Logic**:
   - UI modifications are generally safe for multiplayer
   - Keep gameplay logic in synchronized scripts

2. **Example Structure**:
   ```
   MyMod/
   ├── ui/                 <!-- Client-side only, visual changes -->
   │   └── custom_panel.xml
   └── scripts/            <!-- Synchronized gameplay changes -->
       └── gameplay_logic.lua
   ```

3. **Use Appropriate Registration**:
   ```xml
   <!-- UI changes (client-side) -->
   <ReplaceUIScript id="custom-panel">
     <File>ui/custom_panel.xml</File>
   </ReplaceUIScript>
   
   <!-- Gameplay changes (synchronized) -->
   <AddGameplayScripts>
     <File>scripts/gameplay_logic.lua</File>
   </AddGameplayScripts>
   ```

> **See Also:** For designing multiplayer-compatible mods, check the [Advanced Topics Guide](./advanced-topics.md#multiplayer-compatibility).

## Debugging Tips and Tools

### In-Game Console

1. **Enabling the Console**:
   - Follow instructions in the [Debugging Tools section](./advanced-topics.md#in-game-console) of the Advanced Topics guide
   - Press the `~` key (or your configured key) to open the console in-game

2. **Useful Console Commands**:
   - `DumpGameState` - Outputs current game state to logs
   - `reveal all` - Reveals the entire map
   - `debugmodifier` - Shows modifier data
   - `debugculture` - Shows culture borders clearly
   - `unitdata` - Shows data about selected unit
   - `luadebug` - Enables additional Lua debugging
   - `player Gold 10000` - Gives current player 10,000 gold
   - `player AddAllTechs` - Unlocks all technologies
   - `player AddAllCivics`