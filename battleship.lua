local aEnemies = 
{
    "John O. Agwunobi",
    "Dennis C. Blair",
    "Albert Calland",
    "Vern Clark",
    "William J. Fallon",
    "James G. Foggo, III",
    "Joxel Garcia",
    "Edmund P. Giambastiani",
    "Jonathan W. Greenert",
    "John C. Harvey, Jr.",
    "Timothy J. Keating",
    "Deborah Ann Loewer",
    "Bruce E. MacDonald",
    "Robert T. Moeller",
    "Michael G. Mullen",
    "Eric T. Olson",
    "James Perkins",
    "Ann E. Rondeau",
    "Gary Roughead",
    "Raymond C. Smith, Jr.",
    "James G. Stavridis",
    "Jeremy M. Boorda",
    "William Brockman",
    "Arleigh Burke",
    "Harley H. Christy",
    "Gordon Pai'ea Chung-Hoon",
    "Charles Cooke",
    "Robert E. Coontz",
    "William Crowe",
    "Edward W. Eberle",
    "Aubrey W. Fitch",
    "Frank Jack Fletcher",
    "Harold W. Gehman, Jr.",
    "Caspar F. Goodrich",
    "Samuel L. Gravely, Jr.",
    "William F. Halsey",
    "John H. Hoover",
    "Grace Hopper",
    "Bobby Ray Inman",
    "David E. Jeremiah",
    "Jay Johnson",
    "C. Turner Joy",
    "Frank B. Kelso II",
    "Husband E. Kimmel",
    "Ernest J. King",
    "Charles R. Larson",
    "James E. McPherson",
    "John S. McCain, Senior",
    "John McConnel",
    "Charles Momsen",
    "Thomas H. Moorer",
    "Michael Mullen",
    "Chester W. Nimitz",
    "William Owens",
    "Arthur W. Radford",
    "Forrest P. Sherman",
    "Leighton Smith",
    "Raymond A. Spruance",
    "Harold R. Stark",
    "James B. Stockdale",
    "Arthus Dewey Stuble",
    "William Studeman",
    "Patricia Tracey",
    "Carlisle Trost",
    "Richard Truly",
    "Richmond Kelly Turner",
    "Stansfield Turner",
    "James Watkins",
    "William Bainbridge",
    "James Barron",
    "Isaac Chauncey",
    "Napoleon Collins",
    "Peirce Crosby",
    "George Dewey",
}

local function iif(condition, a, b)

    if condition == true then return a else return b end
end


local function battleshipParseCoordinate(str)

    local result = { x = 0, y = 0 }
    local y = string.sub(str, 1, 1)
    local x = string.sub(str, 2, 2)

    if (x == "0") then result.x = 0 
    elseif (x == "1") then result.x = 1
    elseif (x == "2") then result.x = 2 
    elseif (x == "3") then result.x = 3 
    elseif (x == "4") then result.x = 4 
    elseif (x == "5") then result.x = 5 
    elseif (x == "6") then result.x = 6 
    elseif (x == "7") then result.x = 7 
    elseif (x == "8") then result.x = 8 
    elseif (x == "9") then result.x = 9
    else
        return false, "coordinate given is invalid"
    end 

    if ((y == "a") or (y == "A")) then result.y = 0 
    elseif ((y == "b") or (y == "B")) then result.y = 1
    elseif ((y == "c") or (y == "C")) then result.y = 2 
    elseif ((y == "d") or (y == "D")) then result.y = 3 
    elseif ((y == "e") or (y == "E")) then result.y = 4 
    elseif ((y == "f") or (y == "F")) then result.y = 5 
    elseif ((y == "g") or (y == "G")) then result.y = 6 
    elseif ((y == "h") or (y == "H")) then result.y = 7 
    elseif ((y == "i") or (y == "I")) then result.y = 8 
    elseif ((y == "j") or (y == "J")) then result.y = 9 
    else
        return false, "coordinate given is invalid"
    end 
    
    return true, result
end

local aYAxisStringValues = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j" }
local function battleshipCoordinateToString(coordinate)

    return aYAxisStringValues[coordinate.y + 1] .. tostring(coordinate.x)
end

local function battleshipParseCoordinates(str)
    
    local result, start, stop
    
    result, start = battleshipParseCoordinate(string.sub(str, 1, 2))
    if (not result) then return false, start end
    
    result, stop = battleshipParseCoordinate(string.sub(str, 4, 5))
    if (not result) then stop = { x = start.x, y = start.y } end
    
    if ((start.x ~= stop.x) and (start.y ~= stop.y)) then
        
        return false, "coordinates must to be in one line"
    end
    
    local length = math.max(math.abs(start.x - stop.x), math.abs(start.y - stop.y)) + 1
    
    if (length > 4) then

        return false, "ship is too long"
    end

    return true, 
    { 
        start = 
        {
            x = math.min(start.x, stop.x),
            y = math.min(start.y, stop.y)
        }, 
        stop = 
        {     
            x = math.max(start.x, stop.x),
            y = math.max(start.y, stop.y)
        }, 
        length = length 
    }    
end

local function buildScreen()

    local dimensions = { rows = 20, columns = 70 }
    local data = {}

    -- Creating the screen matrix
    for row = 1, dimensions.rows do
        data[row] = {}
        for column = 1, dimensions.columns do
            data[row][column] = " "
        end
    end
    
    local screen = 
    { 
        dimensions = dimensions, 
        data = data
    }

    return screen
end

local bScreenWasPrepared = false

local function drawScreen(screen, printFunction)

    for row = 1, screen.dimensions.rows do
        printFunction(table.concat(screen.data[row], ""))
    end
end

local function paintTextHorizontal(screen, x, y, text, padding)
    
    local lx = x
    local ly = y
    local padding = padding or 0
    
    for position = 1, #text do

        local letter = string.sub(text, position, position)

        if (letter == "\n") then
            lx = x
            ly = ly + 1
        else
            screen.data[ly][lx] = string.sub(text, position, position)
            lx = lx + padding + 1
        end
    end
end

local function paintTextVertical(screen, x, y, text, padding)

    local y = y
    local padding = padding or 0
    
    for position = 1, #text do
        screen.data[y][x] = string.sub(text, position, position)
        y = y + padding + 1
    end
end

local function paintRect(screen, x, y, width, height, filament)

    local maxy = y + height - 1
    local maxx = x + width - 1

    -- Corners
    screen.data[y][x] = '+'
    screen.data[y][maxx] = '+'
    screen.data[maxy][x] = '+'
    screen.data[maxy][maxx] = '+'

    -- Verticals
    for row = y+1, maxy-1 do
        screen.data[row][x] = '|'
        screen.data[row][maxx] = '|'
    end

    -- Horizontals
    for column = x+1, maxx-1 do
        screen.data[y][column] = '-'
        screen.data[maxy][column] = '-'
    end
    
    if (filament ~= nil) then
        for row = y+1, maxy-1 do
            for column = x+1, maxx-1 do
                screen.data[row][column] = filament
            end
        end
    end
end

local function paintBoard(screen, x, y, name, ships, shots)

    local width = 23
    local height = 12
    
    paintRect(screen, x, y, width, height)
    paintTextVertical(screen, x-1, y+1, "abcdefghij")
    paintTextHorizontal(screen, x+2, y-1, "0123456789", 1)
    paintTextHorizontal(screen, x + math.ceil((width - #name) / 2), y-3, name)
    
    if (ships ~= nil) then
    
        for shipNum = 1, #ships do
            
            local ship = ships[shipNum]
            
            if (ship.set) then
            
                for cellNum = 1,#ship.cells do
                
                    local cell = ship.cells[cellNum]
                    screen.data[y + 1 + cell.y][x + 2 + (cell.x * 2)] = "O"
                end
            end
        end
    end
    
    if (shots ~= nil) then
    
        for shotNum = 1, #shots do
            
            local shot = shots[shotNum]
            
            screen.data[y + 1 + shot.y][x + 2 + (shot.x * 2)] = iif(shot.hit, "X", "+")
        end
    end
end

local function paintLastShots(screen, x, y, shots, count)
    
    paintTextHorizontal(screen, x+1, y-1, "last hits")

    local shotNum = #shots
    local shotsWritten = 0
    
    while shotNum > 0 do

        shotsWritten = shotsWritten + 1
        if (shotsWritten > count) then break end
    
        local shotInfo = 
            battleshipCoordinateToString(shots[shotNum]) 
            .. " "
            .. iif(shots[shotNum].hit, iif(shots[shotNum].kill, "KILL", "Hit"), "miss")

        paintTextHorizontal(screen, x+2, y + shotsWritten, shotInfo)
        shotNum = shotNum - 1
    end
end

local function buildShip(class, cells)
    
    local ship = { class = class, cells = {}, set = false }
    
    for cell = 1, cells do 
        ship.cells[cell] = { x = 0, y = 0 } 
    end
    
    return ship
end

local function buildShips()

    local ships = {}    

    ships[1] = buildShip("Cruiser", 4)
    ships[2] = buildShip("Destroyer", 3)
    ships[3] = buildShip("Destroyer", 3)
    ships[4] = buildShip("Frigate", 2)
    ships[5] = buildShip("Frigate", 2)
    ships[6] = buildShip("Frigate", 2)
    ships[7] = buildShip("Corvette", 1)
    ships[8] = buildShip("Corvette", 1)
    ships[9] = buildShip("Corvette", 1)
    ships[10] = buildShip("Corvette", 1)
    
    return ships
end

local function placeShip(ships, coordinates, concreteShipNum)

    local shipNumToPlace = iif(concreteShipNum == nil, -1, tonumber(concreteShipNum))
    local prohibitedCells = {}

    for shipNum = 1, #ships do

        local ship = ships[shipNum]
        
        if (ship.set == false) and (#ship.cells == coordinates.length) and (shipNumToPlace == -1) then
            -- The ship is ready to be placed
            shipNumToPlace = shipNum
        end
                
        if (ship.set == true) then
         
            -- Calculates the prohibited cells
            for cellNum = 1, #ship.cells do
                
                local cell = ship.cells[cellNum]
                
                -- Writing signature of prohibited cell
                prohibitedCells[cell.y * 10 + cell.x] = true

                -- Writing signatures of other prohibited cells
                if (cell.x > 0) then 
                    prohibitedCells[cell.y * 10 + cell.x - 1] = true 
                    if (cell.y > 0) then prohibitedCells[(cell.y - 1) * 10 + cell.x - 1] = true end
                    if (cell.y < 9) then prohibitedCells[(cell.y + 1) * 10 + cell.x - 1] = true end
                end
                if (cell.x < 9) then 
                    prohibitedCells[cell.y * 10 + cell.x + 1] = true
                    if (cell.y > 0) then prohibitedCells[(cell.y - 1) * 10 + cell.x + 1] = true end
                    if (cell.y < 9) then prohibitedCells[(cell.y + 1) * 10 + cell.x + 1] = true end
                end
                if (cell.y > 0) then prohibitedCells[(cell.y - 1) * 10 + cell.x] = true end
                if (cell.y < 9) then prohibitedCells[(cell.y + 1) * 10 + cell.x] = true end
            end
        end
    end
    
    if (shipNumToPlace == -1) then
    
        return false, "All " .. tostring(coordinates.length) .. "-deckers are placed."
    end

    -- Next, we will check for placement rules
    for x = coordinates.start.x, coordinates.stop.x do
    
        for y = coordinates.start.y, coordinates.stop.y do
    
            if (prohibitedCells[(y * 10) + x] == true) then
            
                return false, "Cannot place ships border-to-border."
            end
        end
    end

    local cellNum = 1    

    -- Emplace
    for x = coordinates.start.x, coordinates.stop.x do
    
        for y = coordinates.start.y, coordinates.stop.y do
            
            ships[shipNumToPlace].cells[cellNum].x = x
            ships[shipNumToPlace].cells[cellNum].y = y
            
            cellNum = cellNum + 1
        end
    end
    
    ships[shipNumToPlace].set = true
    
    return true, ships[shipNumToPlace].class .. " (" .. tostring(coordinates.length) .. "-decker) entered the order."
end

local function getPlacedShipsInfo(ships, shots)

    local shipsPlaced = 0
    local shipsTotal = 0
    local shipsKilled = 0
    
    local healthInfo = {}
    
    for shipNum = 1, #ships do
        
        local ship = ships[shipNum]
        
        shipsTotal = shipsTotal + 1

        if (ship.set == true) then
        
            shipsPlaced = shipsPlaced + 1
        end
        
        -- If shots are passed then calculate kills info
        if (shots ~= nil) then

            healthInfo[shipNum] = {}

            -- Prefill ship data
            for cellNum=1, #ship.cells do
                
                healthInfo[shipNum][cellNum] = { x = ship.cells[cellNum].x, y = ship.cells[cellNum].y, hit = false }  
            end
         end
    end
    
    -- If shots are passed then calculate kills info
    if (shots ~= nil) then

        -- Iterate through shots
        for shotNum=1, #shots do
        
            local shot = shots[shotNum]
            
            if (shot.shipNum ~= nil) then
                local cells = healthInfo[shot.shipNum]

                for cellNum=1, #cells do
                    
                    if (cells[cellNum].x == shot.x) and (cells[cellNum].y == shot.y) then
                        
                        cells[cellNum].hit = true
                        break
                    end
                end
            end
        end

        -- Calculate overall hit cells    
        for shipNum = 1, #healthInfo do
        
            local healths = healthInfo[shipNum]
            local hitCells = 0
        
            for cellNum=1, #healths do

                if (healths[cellNum].hit) then hitCells = hitCells + 1 end
            end

            if (hitCells >= #healths) then shipsKilled = shipsKilled + 1 end
        end
    end
    
    return { placed = shipsPlaced, total = shipsTotal, killed = shipsKilled }
end

local function placeShipsAuto(ships)

    for shipNum = 1, #ships do

        while (not ships[shipNum].set) do

            local ship = ships[shipNum]
            local length = #ship.cells
        
            -- limit randomness to allow place the ship any way
            local randomStartX = math.random(10 - length + 1) - 1
            local randomStartY = math.random(10 - length + 1) - 1
            local randomDirection = math.random(2)
        
            -- enlength the radom coordinates
            local stopX = iif(randomDirection == 1, randomStartX + length - 1, randomStartX)
            local stopY = iif(randomDirection == 2, randomStartY + length - 1, randomStartY)

            local coordinates = 
            {
                start = { x = randomStartX, y = randomStartY },
                stop = { x = stopX, y = stopY },
                length = length
            }
            
            -- try to place the ship. This metod will set the `set` flag internally
            -- note that the placeShip is restricted to shipNum with 3rd parameter
            local result, message = placeShip(ships, coordinates, shipNum)               
        end
    end

    return true, ""
end

local function buildShots()
    return {} 
end

local function addShot(shots, ships, x, y)
    
    local shotNum = #shots + 1
    
    for shipNum = 1, #ships do

        local ship = ships[shipNum]
        
        if (ship.set) then
        
            for cellNum = 1,#ship.cells do
            
                local cell = ship.cells[cellNum]
                
                if (cell.x == x) and (cell.y == y) then
                    
                    shots[shotNum] = { x = x, y = y, hit = true, shipNum = shipNum }
                    return shots[shotNum]
                end
            end
        end
    end

    shots[shotNum] = { x = x, y = y, hit = false }    
    return shots[shotNum]
end

local function getShipHealthStatus(ships, shots, shipNum)
    
    local ship = ships[shipNum]
    local cells = {}

    -- Prefill ship data
    for cellNum=1, #ship.cells do
        
        cells[cellNum] = { x = ship.cells[cellNum].x, y = ship.cells[cellNum].y, hit = false }  
    end
    
    -- Iterate through shots
    for shotNum=1, #shots do
    
        local shot = shots[shotNum]
        
        if (shot.shipNum == shipNum) then
        
            for cellNum=1, #cells do
                
                if (cells[cellNum].x == shot.x) and (cells[cellNum].y == shot.y) then
                    
                    cells[cellNum].hit = true
                    break
                end
            end
        end
    end

    -- Calculate overall hit cells    
    local hitCells = 0
    
    for cellNum=1, #ship.cells do

        if (cells[cellNum].hit) then hitCells = hitCells + 1 end
    end
    
    return { health = #ship.cells, hits = hitCells, killed = (hitCells >= #ship.cells) }
end

local function battleshipSetStage(bs, stage)

    bs.stage = stage
    bs.stages[stage].init(bs, bs.stages[stage], bs.stages[stage].view)
end

local function battleshipNextStage(bs)

    battleshipSetStage(bs, bs.stage + 1)
end

local function battleshipQuit(bs)

    bs.quit = true
end

local function battleshipHandleCommand(bs, command)
    
    return bs.stages[bs.stage].action(bs, bs.stages[bs.stage], bs.stages[bs.stage].view, command)
end

----------------------------
-- ARTIFICIAL INTELLIGENCE
----------------------------

local function buildAiNotebook()

    local notebook =
    {
        poi = {},
        prohibited = {}
    }
    
    for y = 0,9 do
    
        notebook.prohibited[y] = {}
        
        for x = 0,9 do notebook.prohibited[y][x] = false end
    end
    
    return notebook
end

local function aiRandomMove(shots, notebook)

    local tries = 1

    while (true == true) do

        local x = math.random(10) - 1
        local y = math.random(10) - 1
        local isOk = true

        if (notebook.prohibited[y][x]) then isOk = false end
        
        if (isOk or (#shots >= 1000) or (tries > 10000)) then return { x = x, y = y } end
        
        tries = tries + 1
    end
end

local function aiIntermediateMove(shots, notebook)
    
    -- If we have no POI then use random shot
    if (#notebook.poi == 0) then

        return aiRandomMove(shots, notebook)
    end
    
    local pois = 0
    
    for _ in pairs(notebook.poi) do 
    
        pois = pois + 1 
    end
    
    local poiToUse = math.random(pois)
    
    local count = 1
    for _, v in ipairs(notebook.poi) do 

        if (count == poiToUse) then return { x = v.x, y = v.y } end
        count = count + 1
    end
end

local function addAiPOI(notebook, x, y, prohibit)

    if (x >= 0) and (x <= 9) and (y >=0) and (y <=9 ) then
        
        if not notebook.prohibited[y][x] then
    
            table.insert(notebook.poi, { x = x, y = y, prohibit = prohibit })
        end
    end
end

local function addAiProhibited(notebook, x, y)

    if (x >= 0) and (x <= 9) and (y >=0) and (y <=9 ) then
       
        notebook.prohibited[y][x] = true
    end
end

local function aiStoreShotInfo(shots, notebook, shot, killed)

    -- TODO: Add here probability map for ship types (e.g., if 
    -- square area available has enough space for 2-decker but
    -- here are only 4-decker alive then this square area must 
    -- to be lowered in probability to shoot

    -- Remove shot from POI
    local doCleanup = true
    
    while (doCleanup) do
        
        doCleanup = false
           
        for k,v in ipairs(notebook.poi) do
        
            if (v.x == shot.x) and (v.y == shot.y) then

                if (shot.hit) then
                    -- First, prohibit associated cells, associated with POI
                    if (v.prohibit ~= nil) then
                       
                        for _,p in ipairs(v.prohibit) do
                        
                            addAiProhibited(notebook, p.x, p.y)
                        end
                    end
                end

                table.remove(notebook.poi, k)
                doCleanup = true
                break
            end
            
            if notebook.prohibited[v.y][v.x] then
                table.remove(notebook.poi, k)
                doCleanup = true
                break
            end
        end
    end

    -- If killed then prohibit near cells
    if (shot.hit and killed) then

        addAiProhibited(notebook, shot.x, shot.y)
        addAiProhibited(notebook, shot.x - 1, shot.y)
        addAiProhibited(notebook, shot.x + 1, shot.y)

        addAiProhibited(notebook, shot.x - 1, shot.y - 1)
        addAiProhibited(notebook, shot.x, shot.y - 1)
        addAiProhibited(notebook, shot.x + 1, shot.y - 1)

        addAiProhibited(notebook, shot.x - 1, shot.y + 1)
        addAiProhibited(notebook, shot.x, shot.y + 1)
        addAiProhibited(notebook, shot.x + 1, shot.y + 1)

    -- If hit, add the directive points to POI and prohibit cross cells
    elseif (shot.hit) then

        addAiProhibited(notebook, shot.x, shot.y)
        addAiProhibited(notebook, shot.x - 1, shot.y - 1)
        addAiProhibited(notebook, shot.x + 1, shot.y - 1)
        addAiProhibited(notebook, shot.x - 1, shot.y + 1)
        addAiProhibited(notebook, shot.x + 1, shot.y + 1)
        
        -- adding POIs with prohibition lists
        addAiPOI(notebook, shot.x, shot.y - 1, { 
            [1] = { x = shot.x - 1, y = shot.y }, 
            [2] = { x = shot.x + 1, y = shot.y } 
        })
        addAiPOI(notebook, shot.x, shot.y + 1, { 
            [1] = { x = shot.x - 1, y = shot.y }, 
            [2] = { x = shot.x + 1, y = shot.y } 
        })
        addAiPOI(notebook, shot.x - 1, shot.y, { 
            [1] = { x = shot.x, y = shot.y - 1 }, 
            [2] = { x = shot.x, y = shot.y + 1 } 
        })
        addAiPOI(notebook, shot.x + 1, shot.y, { 
            [1] = { x = shot.x, y = shot.y - 1 }, 
            [2] = { x = shot.x, y = shot.y + 1 } 
        })
    else
        addAiProhibited(notebook, shot.x, shot.y)
    end
end

local function printAiDebugBoard(screen, x, y, notebook)

    -- Output POI and prohibited pending
    
    paintRect(screen, x, y, 12, 12)
    paintTextVertical(screen, x-1, y+1, "abcdefghij")
    paintTextHorizontal(screen, x+1, y-1, "0123456789",0)
    paintTextHorizontal(screen, x+1, y-2, "POI",1)

    paintRect(screen, x+13, y, 12, 12)
    paintTextVertical(screen, x+13-1, y+1, "abcdefghij")
    paintTextHorizontal(screen, x+13+1, y-1, "0123456789",0)
    paintTextHorizontal(screen, x+13+1, y-2, "PROH P",1)

    for k,v in ipairs(notebook.poi) do

        screen.data[y+1+v.y][x+1+v.x] = '?'    

        if (v.prohibit ~= nil) then
           
            for _,p in ipairs(v.prohibit) do
            
                if (p.x>=0) and (p.x<=9) and (p.y>=0) and (p.y<=9) then
                    
                    screen.data[y+1+p.y][x+13+1+p.x] = "*"
                end
            end
        end
    end      

    -- Output prohibited (set)

    paintRect(screen, x+26, y, 12, 12)
    paintTextVertical(screen, x+26-1, y+1, "abcdefghij")
    paintTextHorizontal(screen, x+26+1, y-1, "0123456789",0)
    paintTextHorizontal(screen, x+26+1, y-2, "PROH S",1)
    
    for yy=0,9 do

        for xx=0,9 do
        
            if notebook.prohibited[yy][xx] then
            
                screen.data[y+1+yy][x+26+1+xx] = '%'
            end
        end
    end
end

------------
-- STAGES --
------------

local function stageGreetingsInit(bs, stage, view)

    view.allowedCommands = "> [quit], [start]"
end

local function stageGreetings(bs, stage, view, command)

    local errorMessage = ""

    if (command == "") then
    elseif (command == "quit") then 
    
        battleshipQuit(bs)
        return false        

    elseif (command == "start") then
        
        battleshipNextStage(bs)
        return false

    else
        
        errorMessage = "* You've entered unknown command"
    end

    local screen = buildScreen()

    paintTextHorizontal(screen, 1, 1,
[[

##################################################################
########################### ######################################
#################### #####   #####################################
#################### #      ######################################
###################    #     #####################################
############### ##    ##       ## ################################
##############        ##            #  ###########################
###########                             ###########            ###
####                                                       #######
#####                                                   ##########
##################################################################
]]
    )
    paintTextHorizontal(screen, 8, 11, "BATTLESHIP", 4)
    paintTextHorizontal(screen, 10, 14, "2016 edition", 1)
    paintTextHorizontal(screen, 2, 18, errorMessage)
    paintTextHorizontal(screen, 2, 20, view.allowedCommands)

    drawScreen(screen, bs.printFunction)

    return true
end

local function stageSetupInit(bs, stage, view)

    bs.enemyName = aEnemies[math.random(#aEnemies)]
    
    bs.humanShips = buildShips()
    bs.enemyShips = buildShips()
    bs.humanShots = buildShots()
    bs.enemyShots = buildShots()

    view.allowedCommands = "> [quit], [reset], [ship ? ?], [auto]"
end

local function stageSetup(bs, stage, view, command)

    local errorMessage = ""

    if (command == "") then
    elseif (command == "quit") then 
    
        battleshipQuit(bs)
        return false        

    elseif (command == "reset") then
        
        battleshipSetStage(bs, 2)
        return false
        
    elseif (string.sub(command, 1, 4) == "ship") then

        -- Place ships hand-by-hand

        local result, coordinates = battleshipParseCoordinates(string.sub(command, 6, 10))
        
        if (result == true) then 

            local result, message = placeShip(bs.humanShips, coordinates)        
            
            if ( result == true) then
            
                errorMessage = message
            else
            
                errorMessage = "* Error: " .. message
            end
        else
        
            errorMessage = "* Error: " .. coordinates .. ". Example: `ship e3 e6`."   
        end

    elseif (command == "auto") then
        
        -- Automagic
        
        local result, message = placeShipsAuto(bs.humanShips)
        
        if (result == true) then
        
            battleshipNextStage(bs)
            return false
        else
        
            errorMessage = "* Error: " .. message
        end
        
    else
        
        errorMessage = "* You've entered unknown command"
    end

    local placedInfo = getPlacedShipsInfo(bs.humanShips)

    if (placedInfo.placed == placedInfo.total) then

        battleshipNextStage(bs)
        return false
    end

    local screen = buildScreen()

    paintTextHorizontal(screen, 2, 2, "* SOMEWHERE IN THE WHITE SEA. KIROV-CLASS SUPERCRUISER BATTLE DECK. *")
    paintTextHorizontal(screen, 28, 4, "OFFICER:" , 1)
    paintTextHorizontal(screen, 44, 4, "Captain! The USF battle ve-")
    paintTextHorizontal(screen, 44, 5, "ssels' order under the com-")
    paintTextHorizontal(screen, 29, 6, "mand of admiral " .. bs.enemyName)
    paintTextHorizontal(screen, 29, 7, "is approaching! We've caught by their at-") 
    paintTextHorizontal(screen, 29, 8, "tack artillery and missiles AESA stations!")
    paintTextHorizontal(screen, 28, 10, "YOU:" , 1)
    paintTextHorizontal(screen, 36, 10, "COMLINK! Command 'ORDER TO BATTLE'")
    paintTextHorizontal(screen, 36, 11, "engagement! The augmented cyberne-")
    paintTextHorizontal(screen, 29, 12, "tic USF admiral is trying to start the war.")
    paintTextHorizontal(screen, 29, 13, "We will stop the evil with price of our")
    paintTextHorizontal(screen, 29, 14, "lives! Let's fight!")
    paintTextHorizontal(screen, 35, 16, "*PLACE THE SHIPS*", 1)
    paintTextHorizontal(screen, 45, 17, tostring(placedInfo.placed) .. "/" .. tostring(placedInfo.total), 1)

    paintTextHorizontal(screen, 2, 18, errorMessage)
    paintTextHorizontal(screen, 2, 20, view.allowedCommands)

    paintBoard(screen, 3, 5, "", bs.humanShips, nil)

    drawScreen(screen, bs.printFunction)
    
    return true
end

local function stagePlayInit(bs, stage, view)

    placeShipsAuto(bs.enemyShips)

    view.notebook = buildAiNotebook()
    view.allowedCommands = "> [quit], [reset], [fire ?] or just a coordinate"
end

local function stagePlay(bs, stage, view, command)

    local errorMessage = ""

    if (command == "") then
    elseif (command == "quit") then 
    
        battleshipQuit(bs)
        return false        

    elseif (command == "reset") then
        
        battleshipSetStage(bs, 2)
        return false

    elseif (command == "enemy") then

        for shipNum = 1, #bs.humanShips do
            local ship = bs.humanShips[shipNum]
            for cellNum = 1, #ship.cells do
                addShot(bs.enemyShots, bs.humanShips, ship.cells[cellNum].x, ship.cells[cellNum].y)
            end
        end
    
    elseif (command == "human") then

        for shipNum = 1, #bs.enemyShips do
            local ship = bs.enemyShips[shipNum]
            for cellNum = 1, #ship.cells do
                addShot(bs.humanShots, bs.enemyShips, ship.cells[cellNum].x, ship.cells[cellNum].y)
            end
        end
       
    else
    
        local coordinateString = iif (string.sub(command, 1, 4) == "fire", string.sub(command, 6, 7), command)
        local result, coordinate = battleshipParseCoordinate(coordinateString)
        
        if (result == true) then 

            local shot = addShot(bs.humanShots, bs.enemyShips, coordinate.x, coordinate.y)

            shot.kill = false

            if (shot.hit) then
            
                local healthStatus = getShipHealthStatus(bs.enemyShips, bs.humanShots, shot.shipNum)

                shot.kill = healthStatus.killed                
                errorMessage = iif(healthStatus.killed, "Kill!", "Hit!")
            else
    
                -- THE AI BATTLE PART --
            
                errorMessage = "Miss and enemy moved."
            
                while (true == true) do
                
                    local coordinate = aiIntermediateMove(bs.enemyShots, view.notebook)
                    local shot = addShot(bs.enemyShots, bs.humanShips, coordinate.x, coordinate.y)

                    shot.kill = false

                    if (shot.hit) then

                        local healthStatus = getShipHealthStatus(bs.humanShips, bs.enemyShots, shot.shipNum)

                        aiStoreShotInfo(bs.enemyShots, view.notebook, shot, healthStatus.killed)
                        
                        shot.kill = healthStatus.killed
                    else

                        aiStoreShotInfo(bs.enemyShots, view.notebook, shot, false)

                        break
                    end
                end
            end
        else
        
            errorMessage = "* You've entered unknown command. Try `fire e3` or just `e3`."   
        end
    end
    
    local humanFleetInfo = getPlacedShipsInfo(bs.humanShips, bs.enemyShots)
    local enemyFleetInfo = getPlacedShipsInfo(bs.enemyShips, bs.humanShots)
    
    if (humanFleetInfo.killed == humanFleetInfo.total) or (enemyFleetInfo.killed == enemyFleetInfo.total) then
    
        battleshipNextStage(bs)
        return false
    end
    
    local screen = buildScreen()

    paintBoard(screen, 3, 5, bs.playerName, bs.humanShips, bs.enemyShots)
    paintLastShots(screen, 26, 5, bs.enemyShots, 10)
    paintBoard(screen, 39, 5, bs.enemyName, nil, bs.humanShots)
    paintLastShots(screen, 62, 5, bs.humanShots, 10)

    paintTextHorizontal(screen, 28, 2, tostring(humanFleetInfo.total - humanFleetInfo.killed) .. "/" .. tostring(humanFleetInfo.total))
    paintTextHorizontal(screen, 64, 2, tostring(enemyFleetInfo.total - enemyFleetInfo.killed) .. "/" .. tostring(enemyFleetInfo.total))
    
    -- Comment enemy paintBoard and uncomment this to debug the AI
    -- printAiDebugBoard(screen, 28, 5, view.notebook)
    
    paintTextHorizontal(screen, 2, 18, errorMessage)
    paintTextHorizontal(screen, 2, 20, view.allowedCommands)

    drawScreen(screen, bs.printFunction)
    
    return true
end

local function stageFinalInit(bs, stage, view)

    local humanFleetInfo = getPlacedShipsInfo(bs.enemyShips, bs.humanShots)
    
    view.humanWon = (humanFleetInfo.killed == humanFleetInfo.total)
    view.allowedCommands = "> [quit], [reset]"
end

local function stageFinal(bs, stage, view, command)

    local errorMessage = ""

    if (command == "") then
    elseif (command == "quit") then 
    
        battleshipQuit(bs)
        return false        

    elseif (command == "reset") then
        
        battleshipSetStage(bs, 2)
        return false
        
    else
    
        errorMessage = "* You've entered unknown command."   
    end

    local screen = buildScreen()

    if (view.humanWon) then
    
        paintTextHorizontal(screen, 1, 1,
[[
     ########################################################     
          ######################  ######################          
#####          ################    ################          #####
##########          #########   ##   #########          ##########
######################          ##          ######################
########################      # ## #      ########################
##########################     ####     ##########################
###############         #               #          ###############
##########          ####       ####      #####          ##########
#####          ########     #########     #########          #####
          ############   ###############   #############          
     ########################################################     
]]
        )
        paintTextHorizontal(screen, 15, 14, "YOU'VE WON!", 3)
        paintTextHorizontal(screen, 11, 16, "Motherland is protected", 1)
    else

        paintTextHorizontal(screen, 1, 1,
[[
##################################################################
#######    ##################        ##################    #######
########  ################              ################  ########
#### ###  ### ###########                ########### ###  ### ####
#####  #  #  ############                ############  #  # ######
#######    ##############   ###    ###   ##############    #######
###################  ####   ###    ###   ####  ###################
#################     ####              ####     #################
####################   #####  ######  #####   ####################
######################   ###  ######  ###   ######################
########################  ###        ###  ########################
##################################################################
]]
        )
        paintTextHorizontal(screen, 12, 14, "YOU'VE LOST...", 3)
        paintTextHorizontal(screen, 3, 16, "and the motherland is demolished", 1)
    end
    
    paintTextHorizontal(screen, 2, 18, errorMessage)
    paintTextHorizontal(screen, 2, 20, view.allowedCommands)

    drawScreen(screen, bs.printFunction)

    return true
end

local function buildBattleship(playerName, printFunction)

    math.randomseed(os.time())

    local bs = 
    {
        printFunction = printFunction,
        playerName = playerName,
        enemyName = "",
        humanShips = {},
        enemyShips = {},
        humanShots = {},
        enemyShots = {},
        stages = {},
        stage = 1,
        quit = false
    }

    bs.stages[1] = { init = stageGreetingsInit, action = stageGreetings, view = {} }
    bs.stages[2] = { init = stageSetupInit, action = stageSetup, view = {} }
    bs.stages[3] = { init = stagePlayInit, action = stagePlay, view = {} }
    bs.stages[4] = { init = stageFinalInit, action = stageFinal, view = {} }
    
    battleshipSetStage(bs, 1)
    
    return bs
end

local function battleshipPrintLine(x)

    print(x)
end

local function battleshipReadLine()

    return io.read()
end

-- The reference procedure to demonstrate battleship logic.
-- You may freely redistribute this and use as a christmas
-- egg inside your logic (e.g. consoles, graphics, etc).
-- You must to provide output function and feed the battleship
-- structure with commands via `battleshipHandleCommand`.

local function battleshipDemo()

    local bs = buildBattleship("You", battleshipPrintLine)
    local doAskCommand = false
    
    while (bs.quit == false) do
    
        local command = ""
        
        if (doAskCommand) then 
            command = battleshipReadLine() 
        end
        
        doAskCommand = battleshipHandleCommand(bs, command)        
    end
end

battleshipDemo()
