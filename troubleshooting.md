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
       <n>Your Mod Name</n>
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
   - Follow instructions in the "HowToEnableIngameConsole" documentation
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
   - `player AddAllCivics` - Unlocks all civics
   - `debugresources` - Shows resource details
   - `debugyields` - Shows tile yield details
   - `debug ai` - Displays AI decision-making information

3. **Custom Debug Commands**:
   ```lua
   -- Register a custom debug command
   function OnDebugCommand(command, parameters)
     if command == "testmod" then
       print("Testing mod functionality...");
       TestModFunction(parameters[1]);
       return true;
     end
     return false;
   end
   
   Events.DebugCommand.Add(OnDebugCommand);
   
   -- Usage in console: testmod parameter1
   ```

### Enabling Debug Databases

The game can generate copies of its databases for debugging purposes:

1. **Enable Database Copying**:
   - Locate the "AppOptions.txt" file:
     - Windows: `\AppData\Local\Firaxis Games\Sid Meier's Civilization VII\`
     - macOS: `~/Library/Application Support/Sid Meier's Civilization VII/`
     - Linux: `~/.local/share/Sid Meier's Civilization VII/`
   
   - Find this section and change the setting:
   ```
   ;Make copies of commonly used databases to disk after they have been updated.
   ;CopyDatabasesToDisk 0
   ```
   
   - Change it to:
   ```
   CopyDatabasesToDisk 1
   ```
   (Be sure to remove the semicolon at the beginning)

2. **Accessing the Databases**:
   - Databases will be copied to the "Debug" folder in the same directory
   - Two main databases are generated:
     - FrontEnd Database (Config)
     - GamePlay Database
   - You can open these with any SQLite browser to examine the game's data

3. **Using Debug Databases**:
   - Examine table structures to understand relationships
   - Check values to debug unexpected behavior
   - Compare with your SQL modifications to identify issues
   - Track dynamic changes in gameplay values

### Advanced Logs

1. **Enabling Detailed Logs**:
   - Edit the game's configuration to increase log detail
   - Look for logging configurations in the game's settings folder

2. **Creating Custom Logs**:
   ```lua
   -- Custom logging function
   function LogToFile(message)
     local logFile = io.open("MyModLog.txt", "a");
     if logFile then
       logFile:write(os.date("%Y-%m-%d %H:%M:%S") .. ": " .. message .. "\n");
       logFile:close();
     end
   end
   
   -- Usage
   LogToFile("Unit created: " .. unitType);
   ```

3. **Structured Logging**:
   ```lua
   -- Create different log levels
   local LOG_LEVELS = {
     ERROR = 1,
     WARNING = 2,
     INFO = 3,
     DEBUG = 4
   };
   
   local CURRENT_LOG_LEVEL = LOG_LEVELS.INFO; -- Set your desired level
   
   function Log(level, message)
     if level <= CURRENT_LOG_LEVEL then
       local prefix = "";
       if level == LOG_LEVELS.ERROR then prefix = "ERROR: ";
       elseif level == LOG_LEVELS.WARNING then prefix = "WARNING: ";
       elseif level == LOG_LEVELS.INFO then prefix = "INFO: ";
       elseif level == LOG_LEVELS.DEBUG then prefix = "DEBUG: "; end
       
       print(prefix .. message);
     end
   end
   
   -- Usage
   Log(LOG_LEVELS.ERROR, "Critical failure in unit processing");
   Log(LOG_LEVELS.DEBUG, "Variable value: " .. someValue); -- Only prints if debug enabled
   ```

### External Tools

1. **SQLite Browser**:
   - Use DB Browser for SQLite to examine game databases
   - Test SQL queries before adding them to your mod

2. **XML Validators**:
   - Use online validators or tools like XMLStarlet
   - Validate XML files to catch syntax errors

3. **Lua Linters**:
   - Tools like Luacheck can find common Lua errors
   - Integrate with your development environment for real-time feedback

> **Related Topic:** For gameplay-specific debugging, see the [Gameplay Modding Guide](./gameplay-modding.md#debugging-gameplay-mods).

## Common Error Messages

### Interpreting Error Messages

1. **"File not found"**:
   - Check file paths in your `.modinfo` file
   - Verify that the file exists in the specified location
   - Remember that paths are case-sensitive

2. **"Nil value"**:
   - In Lua, you're trying to access a variable or property that doesn't exist
   - Add checks for nil values before accessing properties

3. **"Foreign key constraint failed"**:
   - In SQL, you're trying to reference a value that doesn't exist
   - Ensure parent records are created before child records
   - Check that referenced values exist in the appropriate tables

4. **"Out of memory"**:
   - Your mod might be using too many resources
   - Check for memory leaks or excessive asset loading
   - Optimize resource usage, especially for large maps

### Solutions for Common Errors

1. **XML Parsing Errors**:
   - Look for unclosed tags, improper nesting, or invalid characters
   - Use an XML validator to identify and fix issues

2. **SQL Syntax Errors**:
   - Check for missing semicolons, incorrect quotes, or typos
   - Test queries in a SQLite browser first

3. **Lua Runtime Errors**:
   - Add error handling with pcall:
     ```lua
     local success, error = pcall(function()
       -- Potentially problematic code
       DoSomethingRisky();
     end);
     
     if not success then
       print("Error occurred: " .. tostring(error));
     end
     ```

> **See Also:** For database-specific errors, refer to the [Database Modding Guide](./database-modding.md#common-pitfalls).

## Compatibility with Other Mods

When your mod conflicts with other mods:

### Identifying Mod Conflicts

1. **Systematic Testing**:
   - Disable all mods except yours
   - Add other mods one by one to identify conflicts
   - Use binary search for large mod collections (disable half, test, repeat)

2. **Check for Overlapping Changes**:
   - Multiple mods editing the same files
   - Mods changing the same database entries
   - Mods using the same global variables in Lua

3. **Log Analysis**:
   - Look for error messages related to specific mods
   - Check for database constraint failures mentioning other mods

### Resolving Mod Conflicts

1. **Load Order Adjustments**:
   - Set appropriate load orders to control which mod's changes take precedence:
     ```xml
     <ActionGroup id="my-mod-changes">
       <Properties>
         <LoadOrder>100</LoadOrder> <!-- Higher numbers load later and can override -->
       </Properties>
       <!-- Actions -->
     </ActionGroup>
     ```

2. **Namespacing Your Content**:
   - Use unique prefixes for your database entries:
     ```sql
     -- Instead of generic names
     INSERT INTO Types (Type, Kind)
     VALUES ('BUILDING_LIBRARY', 'KIND_BUILDING'); -- Might conflict
     
     -- Use namespaced names
     INSERT INTO Types (Type, Kind)
     VALUES ('BUILDING_MYUSERNAME_LIBRARY', 'KIND_BUILDING'); -- Less likely to conflict
     ```
   - Use unique identifiers for UI elements:
     ```xml
     <!-- Instead of -->
     <Button ID="SettingsButton">
     
     <!-- Use -->
     <Button ID="MyMod_SettingsButton">
     ```

3. **Compatibility Patches**:
   - Create specific patches for popular mods:
     ```xml
     <ActionCriteria>
       <Criteria id="other-mod-active">
         <ActiveMod>other-mod-id</ActiveMod>
       </Criteria>
     </ActionCriteria>
     
     <ActionGroups>
       <ActionGroup id="compatibility-patch" criteria="other-mod-active">
         <Actions>
           <UpdateDatabase>
             <Item>data/other_mod_compatibility.sql</Item>
           </UpdateDatabase>
         </Actions>
       </ActionGroup>
     </ActionGroups>
     ```

> **Related Topic:** For designing more compatible mods from the start, see the [Mod Structure Guide](./mod-structure.md#designing-for-compatibility).

## Getting Help from the Community

When you need assistance with challenging problems:

### Preparing for Community Help

1. **Document the Issue Thoroughly**:
   - Describe exactly what's happening
   - List steps to reproduce the problem
   - Include your mod files (or relevant excerpts)
   - Share any error messages or logs

2. **Create a Minimal Example**:
   - Strip down your mod to just the problematic part
   - Create a simplified version that still shows the issue

3. **Try Basic Troubleshooting First**:
   - Show that you've already tried the obvious solutions
   - Document what you've attempted so far

### Community Resources

1. **Official Forums**:
   - Post in the Civilization modding forums
   - Follow the forum's guidelines for help requests

2. **Discord Channels**:
   - Join the official Civilization Discord
   - Look for modding-specific channels

3. **Modding Communities**:
   - CivFanatics has a dedicated modding section
   - Reddit's r/civ has modding discussions

4. **GitHub/GitLab**:
   - Some modders share their work on GitHub
   - Look at similar mods for solutions to common problems

### Giving Back

1. **Document Your Solutions**:
   - When you solve a problem, share the solution
   - Consider creating tutorials for difficult aspects

2. **Help Others**:
   - Answer questions from less experienced modders
   - Share code snippets and examples

3. **Contribute to Shared Resources**:
   - Help maintain shared libraries and tools
   - Contribute to modding documentation

## Related Documentation

For more information on topics mentioned in this troubleshooting guide, refer to these related documents:

- [Quick Start Guide](./quick-start-guide.md) - For basic modding concepts
- [Mod Structure](./mod-structure.md) - For understanding mod organization
- [Database Modding](./database-modding.md) - For database-related issues
- [UI Modding](./ui-modding.md) - For UI-specific troubleshooting
- [Asset Creation](./asset-creation.md) - For asset-related problems
- [Advanced Topics](./advanced-topics.md) - For complex scripting issues
- [Gameplay Modding](./gameplay-modding.md) - For gameplay modification issues

## Conclusion

Troubleshooting is an essential skill for modding Civilization VII. By systematically identifying and addressing issues, you can create stable, high-quality mods that enhance the game experience.

Remember that the modding community is a valuable resource. When you encounter challenges, don't hesitate to seek help, and when you overcome obstacles, share your knowledge to help others.

Most importantly, keep backups of your work, test changes incrementally, and maintain comprehensive documentation of your mod. These practices will make troubleshooting easier and help prevent issues before they occur.

---

*This guide will be updated as new common issues and solutions are identified. If you discover a problem and solution not covered here, consider contributing to this documentation.* 