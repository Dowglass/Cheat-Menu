-- Cheat Menu -  Cheat menu for Grand Theft Auto SanAndreas
-- Copyright (C) 2019-2020 Grinch_

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local module = {}

module.tgame                =
{
    camera                  = 
    {
        bool                = imgui.new.bool(false),
        fov                 = imgui.new.int(fconfig.Get('tgame.camera.fov',70)),
        lock_on_player      = imgui.new.bool(false),
        movement_speed      = imgui.new.float(fconfig.Get('tgame.camera.movement_speed',0.1)),
        shake               = imgui.new.float(0.0),
    },
    cop = 
    {
        ["0x8a5a8c"] = 599, -- policeranger
        ["0x8a5a90"] = 596, -- policels
        ["0x8a5a94"] = 597, -- policesf
        ["0x8a5a98"] = 598, -- policelv
        ["0x8a8a9c"] = 523, -- policebike
    },
    day                     =
    {    
        names               = {"Domingo","Segunda","Terça","Quarta","Quinta","Sexta","Sábado"},
        array               = {},
    },    
    disable_cheats          = imgui.new.bool(fconfig.Get('tgame.disable_cheats',false)),
    disable_help_popups     = imgui.new.bool(fconfig.Get('tgame.disable_help_popups',false)),
    disable_replay          = imgui.new.bool(fconfig.Get('tgame.disable_replay',false)),
    fps_limit               = imgui.new.int(fconfig.Get('tgame.fps_limit',60)),
    forbidden_area_wanted_level = imgui.new.bool(fconfig.Get('tgame.forbidden_area_wanted_level',true)),
    freeze_mission_timer    = imgui.new.bool(fconfig.Get('tgame.freeze_mission_timer',false)), 
    freeze_time             = imgui.new.bool(fconfig.Get('tgame.freeze_time',false)), 
    ghost_cop_cars          = imgui.new.bool(fconfig.Get('tgame.ghost_cop_cars',false)),
    gxt_save_name           = imgui.new.char[22](""),
    keep_stuff              = imgui.new.bool(fconfig.Get('tgame.keep_stuff',false)),
    object_spawner          = 
    {
        coord               = 
        {
            x               = imgui.new.float(0),
            y               = imgui.new.float(0),
            z               = imgui.new.float(0),
        },
        categories          = {["Grupos"] = 1,["Objetos"] = 2},
        selected            = "Objetos",
        filter              = imgui.ImGuiTextFilter(),
        group_name          = imgui.new.char[32]("Groupo 1"),
        obj_name            = imgui.new.char[32]("Objeto"),
        model               = imgui.new.int(1427),
        placed              = {},
        set_player_coord    = imgui.new.bool(fconfig.Get('tgame.object_spawner.set_player_coord',false)),
    },  
    random_cheats           = 
    {
        activated_cheats       = {},
        cheat_activate_timer   = imgui.new.int(fconfig.Get('tgame.random_cheats.cheat_activate_timer',10)),
        cheat_deactivate_timer = imgui.new.int(fconfig.Get('tgame.random_cheats.cheat_deactivate_timer',10)),
        cheat_name             = fcommon.LoadJson("cheat name"),
        checkbox               = imgui.new.bool(fconfig.Get('tgame.random_cheats.checkbox',false)),
        disable_cheat_checkbox = imgui.new.bool(fconfig.Get('tgame.random_cheats.disable_cheat_checkbox',false)),
        disabled_cheats        = fconfig.Get('tgame.random_cheats.disabled_cheats',{}),
    },
    script_manager          =
    {
        filter              = imgui.ImGuiTextFilter(),
        categories          = {["Todos"] = 1,["Carregado"] = 2,["Não carregado"] = 3},
        selected            = "Todos",
        scripts             = fconfig.Get('tgame.script_manager.scripts',{}),
        skip_auto_reload    = false,
        not_loaded          = {},
    },
    solid_water             = imgui.new.bool(fconfig.Get('tgame.solid_water',false)),
    solid_water_object      = nil,
    ss_shortcut             = imgui.new.bool(fconfig.Get('tgame.ss_shortcut',false)), 
    sync_system_time        = imgui.new.bool(fconfig.Get('tgame.sync_system_time',false)), 
}

module.tgame.day.array      = imgui.new['const char*'][#module.tgame.day.names](module.tgame.day.names)


function module.SolidWater()
    while module.tgame.solid_water[0] do
        wait(0)
        local x,y,z = getCharCoordinates(PLAYER_PED)
        local water_height =  getWaterHeightAtCoords(x,y,false)

        if doesObjectExist(module.tgame.solid_water_object) then
            deleteObject(module.tgame.solid_water_object)
        end

        if z > water_height and water_height ~= -1000 and not isCharInAnyBoat(PLAYER_PED) then     -- Don't create the object if player is under water/diving
            module.tgame.solid_water_object = createObject(3095,x,y,water_height)
            setObjectVisible(module.tgame.solid_water_object,false)
        end
    end

    if doesObjectExist(module.tgame.solid_water_object) then
        deleteObject(module.tgame.solid_water_object)
    end
end

function module.CameraMode()

    while module.tgame.camera.bool[0] do

        local x,y,z = getCharCoordinates(PLAYER_PED)

        local ped =  createRandomChar(x,y,z)

        freezeCharPositionAndDontLoadCollision(ped,true)
        setCharCollision(ped,false)
        setLoadCollisionForCharFlag(ped,false)
        setEveryoneIgnorePlayer(0,true)
        
        displayRadar(false)
        displayHud(false)
        setCharVisible(ped,false)

        local total_mouse_x = getCharHeading(PLAYER_PED)
        local total_mouse_y = 0
        local total_mouse_delta = 0
        

        setCharCoordinates(ped,x,y,z-20) 

        cameraSetLerpFov(getCameraFov(),module.tgame.camera.fov[0],1000,true)
        cameraPersistFov(true) 

        while module.tgame.camera.bool[0] do
            local factor = 1.0
            x, y, z = getCharCoordinates(ped)  
            local mouse_x, mouse_y =  getPcMouseMovement()

            total_mouse_x = total_mouse_x - mouse_x/6
            total_mouse_y = total_mouse_y + mouse_y/3
            
            if total_mouse_y > 170 then total_mouse_y = 170 end
            if total_mouse_y < -170 then total_mouse_y = -170 end
            

            if isKeyDown(tcheatmenu.hot_keys.camera_mode_slow[1] and tcheatmenu.hot_keys.camera_mode_slow[2]) then 
                factor = factor*0.5
            end
            if isKeyDown(tcheatmenu.hot_keys.camera_mode_fast[1] and tcheatmenu.hot_keys.camera_mode_fast[2]) then 
                factor = factor*2
            end


            if isKeyDown(tcheatmenu.hot_keys.camera_mode_forward[1] and tcheatmenu.hot_keys.camera_mode_forward[2]) then 
                local angle = getCharHeading(ped) + 90

                x = x + module.tgame.camera.movement_speed[0] * math.cos(angle * math.pi/180) * factor
                y = y + module.tgame.camera.movement_speed[0] * math.sin(angle * math.pi/180) * factor
                z = z + module.tgame.camera.movement_speed[0] * math.sin(total_mouse_y* math.pi/180) * factor
            end
    
            if isKeyDown(tcheatmenu.hot_keys.camera_mode_backward[1] and tcheatmenu.hot_keys.camera_mode_backward[2]) then 
                local angle = getCharHeading(ped) + 90
                
                x = x - module.tgame.camera.movement_speed[0] * math.cos(angle * math.pi/180) * factor
                y = y - module.tgame.camera.movement_speed[0] * math.sin(angle * math.pi/180) * factor
                z = z - module.tgame.camera.movement_speed[0] * math.sin(total_mouse_y* math.pi/180) * factor
            end

            if isKeyDown(tcheatmenu.hot_keys.camera_mode_left[1] and tcheatmenu.hot_keys.camera_mode_left[2]) then 
                local angle = getCharHeading(ped)
                
                x = x - module.tgame.camera.movement_speed[0] * math.cos(angle * math.pi/180) * factor
                y = y - module.tgame.camera.movement_speed[0] * math.sin(angle * math.pi/180) * factor
            end

            if isKeyDown(tcheatmenu.hot_keys.camera_mode_right[1] and tcheatmenu.hot_keys.camera_mode_right[2]) then 
                local angle = getCharHeading(ped)
                
                x = x + module.tgame.camera.movement_speed[0] * math.cos(angle * math.pi/180) * factor
                y = y + module.tgame.camera.movement_speed[0] * math.sin(angle * math.pi/180) * factor
            end

            if module.tgame.camera.lock_on_player[0] then

                local right = 0
                local front = 0
                local up = 0
                total_mouse_x = 0
                total_mouse_y = 0
                while module.tgame.camera.lock_on_player[0] and module.tgame.camera.bool[0] do
                    local mouse_x, mouse_y =  getPcMouseMovement()

                    total_mouse_x = total_mouse_x - mouse_x/6
                    total_mouse_y = total_mouse_y + mouse_y/6
                    if total_mouse_x > 300 then total_mouse_x = 300 end
                    if total_mouse_x < -300 then total_mouse_x = -300 end
                    if total_mouse_y > 170 then total_mouse_y = 170 end
                    if total_mouse_y < -170 then total_mouse_y = -170 end
                    factor = 1
                    
                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_slow[1] and tcheatmenu.hot_keys.camera_mode_slow[2]) then 
                        factor = factor*0.5
                    end
                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_fast[1] and tcheatmenu.hot_keys.camera_mode_fast[2]) then 
                        factor = factor*2
                    end

                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_forward[1] and tcheatmenu.hot_keys.camera_mode_forward[2]) then 
                        front = front + factor * module.tgame.camera.movement_speed[0]
                    end
    
                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_backward[1] and tcheatmenu.hot_keys.camera_mode_backward[2]) then 
                        front = front - factor * module.tgame.camera.movement_speed[0]
                    end

                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_left[1] and tcheatmenu.hot_keys.camera_mode_left[2]) then 
                        right = right - factor * module.tgame.camera.movement_speed[0]
                    end
    
                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_right[1] and tcheatmenu.hot_keys.camera_mode_right[2]) then 
                        right = right + factor * module.tgame.camera.movement_speed[0]
                    end

                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_up[1] and tcheatmenu.hot_keys.camera_mode_up[2]) then 
                        up = up - factor * module.tgame.camera.movement_speed[0]
                    end
    
                    if isKeyDown(tcheatmenu.hot_keys.camera_mode_down[1] and tcheatmenu.hot_keys.camera_mode_down[2]) then 
                        up = up + factor * module.tgame.camera.movement_speed[0]
                    end
                    attachCameraToChar(PLAYER_PED,right, front, up, total_mouse_x*-1, 90.0, total_mouse_y, 0.0, 2)

                    if total_mouse_delta + getMousewheelDelta() ~= total_mouse_delta then
                        total_mouse_delta = total_mouse_delta + getMousewheelDelta()
                        module.tgame.camera.fov[0] = module.tgame.camera.fov[0] - getMousewheelDelta()
                        if module.tgame.camera.fov[0] > 120 then
                            module.tgame.camera.fov[0] = 120
                        end
                        if module.tgame.camera.fov[0] < 5 then
                            module.tgame.camera.fov[0] = 5
                        end
                        cameraSetLerpFov(getCameraFov(),module.tgame.camera.fov[0],100,true)
                        cameraPersistFov(true) 
                    end
                    
                    wait(0)
                end
            else
                setCharHeading(ped,total_mouse_x)
                attachCameraToChar(ped,0.0, 0.0, 20.0, 0.0, 180, total_mouse_y, 0.0, 2)
                setCharCoordinates(ped,x,y,z-1.0)
            end

            if total_mouse_delta + getMousewheelDelta() ~= total_mouse_delta then
                total_mouse_delta = total_mouse_delta + getMousewheelDelta()
                module.tgame.camera.fov[0] = module.tgame.camera.fov[0] - getMousewheelDelta()
                if module.tgame.camera.fov[0] > 120 then
                    module.tgame.camera.fov[0] = 120
                end
                if module.tgame.camera.fov[0] < 5 then
                    module.tgame.camera.fov[0] = 5
                end
                cameraSetLerpFov(getCameraFov(),module.tgame.camera.fov[0],100,true)
                cameraPersistFov(true) 
            end
            wait(0)
        end
    
        cameraPersistFov(false) 

        displayRadar(true)
        displayHud(true)

        restoreCameraJumpcut()
        markCharAsNoLongerNeeded(ped)
        deleteChar(ped)
        wait(0)
    end
end

function module.SyncSystemTime()
    while module.tgame.sync_system_time[0] do
        local time = os.date("*t")
        setTimeOfDay(time.hour,time.min)
        wait(30)
    end
end

function module.RandomCheatsActivate()
    while module.tgame.random_cheats.checkbox[0] do
        wait(module.tgame.random_cheats.cheat_activate_timer[0]*1000)
        
        if not module.tgame.random_cheats.checkbox[0] then break end

        cheatid = math.random(0,91)
        callFunction(0x438370,1,1,cheatid)
        table.insert(module.tgame.random_cheats.activated_cheats,cheatid)
        printHelpString("~g~" .. module.tgame.random_cheats.cheat_name[tostring(cheatid)][1])
    end
end

function module.RandomCheatsDeactivate()
    while module.tgame.random_cheats.disable_cheat_checkbox[0] and module.tgame.random_cheats.checkbox[0] do
        for _,x in ipairs(module.tgame.random_cheats.activated_cheats) do
            if module.tgame.random_cheats.cheat_name[tostring(x)][2] == "true" then
                wait(module.tgame.random_cheats.cheat_deactivate_timer[0]*1000)
                
                if not (module.tgame.random_cheats.checkbox[0] or module.tgame.random_cheats.checkbox[0]) then break end

                if module.tgame.random_cheats.disable_cheat_checkbox[0] then
                    callFunction(0x438370,1,1,module.tgame.random_cheats.activated_cheats[x])
                    printHelpString("~r~" .. module.tgame.random_cheats.cheat_name[tostring(x)][1])
                end
            end
        end
        wait(0)
    end
end

function module.FreezeTime()
    while module.tgame.freeze_time[0] do

        local status = fvisual.tvisual.lock_weather[0]
        memory.write(0x969168,1,1)  -- Freeze time
        while module.tgame.freeze_time[0] do
            fvisual.tvisual.lock_weather[0] = true
            wait(0)
        end
        fvisual.tvisual.lock_weather[0] = status
        memory.write(0x969168,0,1)  -- Freeze time
        wait(0)
    end
end

--------------------------------------------------
-- Functions of script manager

function module.LoadScriptsOnKeyPress()
    while true do
        for name,table in pairs(module.tgame.script_manager.scripts) do
            fcommon.OnHotKeyPress(table,function()
                local full_file_path = string.format( "%s\\%s.loadonkeypress",getWorkingDirectory(),name)
                local is_loaded = false
                local sc_handle = nil
                for index, script in ipairs(script.list()) do
                    if full_file_path == script.path then
                        is_loaded = true
                        sc_handle = script
                    end
                end
                if is_loaded == false then
                    script.load(full_file_path)
                    printHelpString("Script carregado")
                else
                    sc_handle:unload()
                    printHelpString("Script descarregado")
                end 
                module.tgame.script_manager.not_loaded[name .. ".loadonkeypress"] = nil
            end)
        end
        wait(0)
    end
end

function module.MonitorScripts()
    local mainDir  = getWorkingDirectory()
    for file in lfs.dir(mainDir) do
        local full_file_path = mainDir .. "\\" .. file
        if doesFileExist(full_file_path) then

            local file_path,file_name,file_ext = string.match(full_file_path, "(.-)([^\\/]-%.?([^%.\\/]*))$") 

            if (file_ext == "lua" or file_ext == "neverload" or file_ext == "loadonkeypress") and module.tgame.script_manager.not_loaded[file_name] == nil  then
                local is_loaded = false
                for index, script in ipairs(script.list()) do
                    if full_file_path == script.path then
                        is_loaded = true
                    end
                end
                if is_loaded == false then
                    module.tgame.script_manager.not_loaded[file_name] = full_file_path
                end 
            end
        end
    end
end

function ShowNotLoadedScripts(name,path)

    local _,file_name,file_ext = string.match(path, "(.-)([^\\/]-%.?([^%.\\/]*))$") 

    fcommon.DropDownMenu(name .. "##" .. path,function()

        imgui.Spacing()
        imgui.SameLine()

        if file_ext ==  "lua" then
            imgui.Text("Status: Não carregado")
        end
        if file_ext ==  "neverload" then
            imgui.Text("Status: Nunca carregar")
        end
        if file_ext ==  "loadonkeypress" then
            imgui.Text("Status: Carregar ao pressionar a tecla")
        end
        
        imgui.Spacing()
        imgui.SameLine()
        imgui.TextWrapped("Filepath: " .. path)
        
        if imgui.Button("Carregar##" .. path,imgui.ImVec2(fcommon.GetSize(1))) then
            if doesFileExist(path) then 

                local load_path = path
                if file_ext ==  "neverload" then
                    load_path = string.sub(path,1,-11)
                    os.rename(path,load_path)
                end
                if file_ext ==  "loadonkeypress" then
                    module.tgame.script_manager.scripts[name:sub(1,-16)] = nil
                    load_path = string.sub(path,1,-16)
                    os.rename(path,load_path)
                end
                module.tgame.script_manager.not_loaded[name] = nil
                script.load(load_path)
                printHelpString("Script carregado")
            end
        end
    end,true)
end

function ShowLoadedScript(script,index)
    fcommon.DropDownMenu(script.name .. "##" .. index,function()
        local _,file_name,file_ext = string.match(script.path, "(.-)([^\\/]-%.?([^%.\\/]*))$") 
        local authors = ""
        for _,author in ipairs(script.authors) do
            authors = authors .. author .. ", "
        end
        local properties = ""
        for _,property in ipairs(script.properties) do
            properties = properties .. property .. ", "
        end
        local dependencies = ""
        for _,dependency in ipairs(script.dependencies) do
            dependencies = dependencies .. dependency .. ", "
        end

        imgui.Columns(2,nil,false)
        imgui.Text("Autor: ")
        imgui.SameLine(0.0,0.0)
        imgui.TextWrapped(string.sub(authors,1,-3))
        imgui.Text("Versão: " .. tostring(script.version))
        imgui.Text("Versão n°: " .. tostring(script.version_num))
        imgui.NextColumn()
        imgui.Text("Script ID: " .. script.id)
        imgui.Text("Status: Carregado")
        imgui.Text("Nome do arquivo: ")
        imgui.SameLine(0.0,0.0)
        imgui.TextWrapped(script.filename)
        imgui.Columns(1)
        if properties ~= "" then
            imgui.Spacing()
            imgui.SameLine()
            imgui.Text("Propriedades: ")
            imgui.SameLine(0.0,0.0)
            imgui.TextWrapped(string.sub(properties,1,-3))
        end
        if dependencies ~= "" then
            imgui.Spacing()
            imgui.SameLine()
            imgui.Text("Dependências: ")
            imgui.SameLine(0.0,0.0)
            imgui.TextWrapped(string.sub(dependencies,1,-3))
        end
        if description ~= "" then
            imgui.Spacing()
            imgui.SameLine()
            imgui.Text("Descrição: ")
            imgui.SameLine(0.0,0.0)
            imgui.TextWrapped(script.description)
        end
        imgui.Spacing()

        if script.path:match(".loadonkeypress") then
            file_name = file_name:sub(1,-16)
        end

        tcheatmenu.hot_keys.script_manager_temp = module.tgame.script_manager.scripts[file_name] or  tcheatmenu.hot_keys.script_manager_temp

        fcommon.HotKey("Tecla para carregar",tcheatmenu.hot_keys.script_manager_temp,fcommon.GetSize(3))
        imgui.Spacing()
        
        if imgui.Button("Nunca carregar##" .. index,imgui.ImVec2(fcommon.GetSize(2))) then
            printHelpString("Script definido para nunca carregar")
            os.rename(script.path,script.path.. ".neverload")
            script:unload()
        end
        imgui.SameLine()

        if imgui.Button("Carregar ao pressionar a tecla##" .. index,imgui.ImVec2(fcommon.GetSize(2))) then
            if script.name == thisScript().name then
                printHelpString("Nao e possivel definir no Cheat Menu!")
            else
                module.tgame.script_manager.scripts[file_name] = {tcheatmenu.hot_keys.script_manager_temp[1],tcheatmenu.hot_keys.script_manager_temp[2]}
                printHelpString("Carregar script pressionando a tecla")

                if not script.path:match(".loadonkeypress") then
                    os.rename(script.path,script.path.. ".loadonkeypress")
                end
                script:unload()
            end
        end

        if imgui.Button("Recarregar##" .. index,imgui.ImVec2(fcommon.GetSize(2))) then
            if script.name == thisScript().name then
                module.tgame.script_manager.skip_auto_reload = true
            end  
            printHelpString("Script recarregado!")
            script:reload()
        end
        imgui.SameLine()
        if imgui.Button("Descarregar##" .. index,imgui.ImVec2(fcommon.GetSize(2))) then
            if script.name == thisScript().name then
                module.tgame.script_manager.skip_auto_reload = true
            end
            printHelpString("Script descarregado!")
            script:unload()
        end
    end)
end

function FollowPed(ped)
    local total_mouse_x = 0
    local total_mouse_y = 0
    while true do
        if not doesCharExist(ped) then
            restoreCamera()
            break
        end
        local x,y,z = getCharCoordinates(ped)
        local mouseX,mouseY = getPcMouseMovement()
        total_mouse_x = total_mouse_x + mouseX
        total_mouse_y = total_mouse_y + mouseY
        
        if doesCharExist(ped) then
            attachCameraToChar(ped,0.0,-2,3.0,0.0,total_mouse_x/20,total_mouse_y/20,0.0,2)
        end
        wait(0)
    end
end

function SpawnObject(model,obj_name,grp_name,x,y,z)
    
    if isModelAvailable(model) and casts.CBaseModelInfo.GetModelType(model) == fconst.MODEL_TYPE.ATOMIC then
        requestModel(model)
        loadAllModelsNow()

        local obj = createObject(model,x,y,z)
        setObjectRotation(obj,0,0,0)
        setObjectCollision(obj,false)

        if module.tgame.object_spawner.placed[grp_name] == nil then
            module.tgame.object_spawner.placed[grp_name] = {}
        end
        module.tgame.object_spawner.placed[grp_name][string.format("%d##%d",model,obj)] = 
        {
            name = obj_name,
            collision = imgui.new.bool(false),
            rotx = imgui.new.float(0),
            roty = imgui.new.float(0),
            rotz = imgui.new.float(0),
        }

        markModelAsNoLongerNeeded(model)
        printHelpString("Objeto criado")
    else
        printHelpString("Modelo invalido")
    end
end

function GenerateIPL()
    local file = io.open("generated.ipl","w")
    local write_string = "inst\n"

    for grp,data in pairs(module.tgame.object_spawner.placed) do
        for key,value in pairs(data) do
            local model, handle = string.match(key,"(%w+)##(%w+)")
            local _,posx,posy,posz = getObjectCoordinates(handle)
            local rotx,roty,rotz,rotw = getObjectQuaternion(handle)
            local interior =  getActiveInterior()

            local inst_line = string.format("%d, dummy, %d, %f, %f, %f, %f, %f, %f, %f, -1\n",model,interior,posx,posy,posz,rotx,roty,rotz,rotw)
            write_string = write_string .. inst_line
        end
    end
    write_string = write_string .. "end"
    file:write(write_string)
    file:close()
    printHelpString("IPL criado")
end

function module.RemoveAllObjects()
    for grp,data in pairs(module.tgame.object_spawner.placed) do
        for key,value in pairs(data) do
            local model, handle = string.match(key,"(%w+)##(%w+)")
            deleteObject(tonumber(handle))
            module.tgame.object_spawner.placed[grp][key] = nil
        end
        module.tgame.object_spawner.placed[grp] = nil
    end
end

--------------------------------------------------


-- Main function
function module.GameMain()
    if imgui.Button("Salvar jogo",imgui.ImVec2(fcommon.GetSize(1))) then
        if isCharOnFoot(PLAYER_PED) then
            activateSaveMenu()
        else
            printHelpString("O jogador ~r~nao~w~ esta a pe!")
        end
    end
   
    if fcommon.BeginTabBar('Jogo') then
        if fcommon.BeginTabItem('Caixas de seleção') then
            
            imgui.Columns(2,nil,false)
            fcommon.CheckBoxVar("Modo câmera",module.tgame.camera.bool,string.format("Atalho: %s\n\nPara frente: %s\tPara trás: %s\
Esquerda: %s\t\tDireita: %s\n\nMovimento lento: %s\nMovimento rápido: %s\n\nRotação: Mouse\nZoom Cima/Baixo : Roda do mouse \n\
Cima : %s (Câmera travada)\nBaixo: %s (Câmera travada)",fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode),
            fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_forward),fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_backward),
            fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_left),fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_right),
            fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_slow),fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_fast),
            fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_up),
            fcommon.GetHotKeyNames(tcheatmenu.hot_keys.camera_mode_down)),
            function()
                fcommon.SingletonThread(module.CameraMode,"CameraMode")
            end,
            function()
                fcommon.CheckBoxVar("Travar câmera",module.tgame.camera.lock_on_player,"Trava a câmera no jogador.")

                imgui.Spacing()
                if imgui.SliderInt("FOV", module.tgame.camera.fov, 5,120) then
                    if module.tgame.camera.bool[0] then
                        cameraSetLerpFov(getCameraFov(),module.tgame.camera.fov[0],1000,true)
                        cameraPersistFov(true) 
                    end
                end
                imgui.SliderFloat("Velocidade de movimento",module.tgame.camera.movement_speed, 0.0, 5.0)
                if imgui.SliderFloat("Mexer", module.tgame.camera.shake, 0.0,100) then
                    if module.tgame.camera.bool[0] then
                        cameraSetShakeSimulationSimple(1,10000,module.tgame.camera.shake[0])
                    end
                end
                
                imgui.Spacing()
                if imgui.Button("Restaurar Câmera",imgui.ImVec2(fcommon.GetSize(2))) then
                    restoreCamera()
                    module.tgame.camera.fov[0] = 70
                    cameraSetLerpFov(getCameraFov(),module.tgame.camera.fov[0],1000,true)
                    cameraPersistFov(true) 
                    module.tgame.camera.shake[0] = 0.0
                    cameraSetShakeSimulationSimple(1,1,0.0)
                    module.tgame.camera.movement_speed[0] = 0.2
                end
                imgui.SameLine()
                if imgui.Button("Criar jogador",imgui.ImVec2(fcommon.GetSize(2))) then
                    local cx,cy,cz = getActiveCameraCoordinates()
                    cz = getGroundZFor3dCoord(cx,cy,cz)
                    setCharCoordinates(PLAYER_PED,cx,cy,cz)
                    printHelpString("Jogador criado")
                end
            end)
            fcommon.CheckBoxVar("Desativar cheats",module.tgame.disable_cheats,nil,
            function()
                if module.tgame.disable_cheats[0] then
                    writeMemory(0x004384D0 ,1,0xE9 ,false)
                    writeMemory(0x004384D1 ,4,0xD0 ,false)
                    writeMemory(0x004384D5 ,4,0x90909090 ,false)
                    fcommon.CheatActivated()
                else
                    writeMemory(0x4384D0 ,1,0x83,false)
                    writeMemory(0x4384D1 ,4,-0x7DF0F908,false)
                    writeMemory(0x4384D5 ,4,0xCC,false)
                    fcommon.CheatDeactivated()
                end
            end)
            fcommon.CheckBoxVar("Desativar caixas de ajuda",module.tgame.disable_help_popups,"Desativa caixas de ajua após ser preso ou morto\nem um novo jogo.",
            function()
                tcheatmenu.window.restart_required = true
            end)
            fcommon.CheckBoxValue('Pay n Spray Grátis',0x96C009)
            fcommon.CheckBoxVar("Parar tempo em missão",module.tgame.freeze_mission_timer,nil,function()
                if module.tgame.freeze_mission_timer[0] then
                    freezeOnscreenTimer(true)
                    fcommon.CheatActivated()
                else
                    freezeOnscreenTimer(false)
                    fcommon.CheatDeactivated()
                end
            end)
            fcommon.CheckBoxVar("Desativar replay",module.tgame.disable_replay,nil,function()
                if module.tgame.disable_replay[0] then
                    writeMemory(0x460500,4,0xC3,false)
                    fcommon.CheatActivated()
                else
                    writeMemory(0x460500,4,0xBD844BB,false)
                    fcommon.CheatDeactivated()
                end
            end)
            fcommon.CheckBoxValue("Relógio mais rápido",0x96913B)        
            fcommon.CheckBoxVar("Nível de procurado +",module.tgame.forbidden_area_wanted_level,"Receber níveis de procurado em outras\
cidades sem completar missões.",
            function()
                if module.tgame.forbidden_area_wanted_level[0] then
                    writeMemory(0x441770,1,0x83,false)
                else
                    writeMemory(0x441770,1,0xC3,false)
                end
            end)    

            imgui.NextColumn()

            fcommon.CheckBoxVar("Parar relógio",module.tgame.freeze_time,nil,
            function()
                fcommon.SingletonThread(module.FreezeTime,"FreezeTime")
            end)

            fcommon.CheckBoxVar("Ghost cop vehicles",module.tgame.ghost_cop_cars,nil,function()        
                for key,value in pairs(module.tgame.cop) do
                    if  module.tgame.ghost_cop_cars[0] then
                        writeMemory(tonumber(key),4,math.random(400,611),false)
                    else
                        writeMemory(tonumber(key),4,value,false)
                    end
                end
            end)
            fcommon.CheckBoxVar("Manter itens",module.tgame.keep_stuff,"Manter itens após prisão/morte.",
            function()
                switchArrestPenalties(module.tgame.keep_stuff[0])
                switchDeathPenalties(module.tgame.keep_stuff[0])
            end)
            fcommon.CheckBoxVar("Random cheats",module.tgame.random_cheats.checkbox,"Ativa cheats aleatoriamente em um determinado tempo.",function()
                fcommon.SingletonThread(fgame.RandomCheatsActivate,"RandomCheatsActivate")
            end,
            function()
                fcommon.CheckBoxVar('Desativar cheats',module.tgame.random_cheats.disable_cheat_checkbox,"Desativar cheats ativados em um determinado tempo.",
                function()
                    fcommon.SingletonThread(fgame.RandomCheatsDeactivate,"RandomCheatsDeactivate")
                end)
                imgui.Spacing()
                imgui.SetNextItemWidth(imgui.GetWindowWidth()/2)
                imgui.SliderInt("Ativar temporizador de cheats", module.tgame.random_cheats.cheat_activate_timer, 10, 100)
                imgui.SetNextItemWidth(imgui.GetWindowWidth()/2)
                imgui.SliderInt("Desativar temporizador de cheats", module.tgame.random_cheats.cheat_deactivate_timer, 10, 100)
                imgui.Spacing()

                imgui.TextWrapped("Cheats ativados")
                imgui.Separator()
                if imgui.BeginChild("Lista de cheats") then  
                    for i=0,91,1 do   -- Cheat ids 0 -> 91
                        if module.tgame.random_cheats.disabled_cheats[tostring(i)] then
                            selected = false
                        else
                            selected = true
                        end

                        if imgui.MenuItemBool(tostring(module.tgame.random_cheats.cheat_name[tostring(i)][1]),nil,selected) then
                            module.tgame.random_cheats.disabled_cheats[tostring(i)] = selected
                        end
                    end
                    imgui.EndChild()
                end
            end)
            fcommon.CheckBoxVar('Captura de tela',module.tgame.ss_shortcut,"Tire uma captura de tela usando" .. fcommon.GetHotKeyNames(tcheatmenu.hot_keys.quick_screenshot))
            fcommon.CheckBoxVar('Água sólida',module.tgame.solid_water,nil,
            function()
                fcommon.SingletonThread(fgame.SolidWater,"SolidWater")
            end)
            fcommon.CheckBoxVar('Sincronizar horário do sistema',module.tgame.sync_system_time,nil,
            function()
                fcommon.SingletonThread(fgame.SyncSystemTime,"SyncSystemTime")
            end)
            fcommon.CheckBoxValue('Widescreen',0xB6F065)
            imgui.Columns(1)
        end
        if fcommon.BeginTabItem('Menus') then
            if imgui.BeginChild("MenusChild") then
                fcommon.DropDownMenu('Dia da Semana',function()
                    local current_day = imgui.new.int(readMemory(0xB7014E,1,false)-1)
                    imgui.SetNextItemWidth(imgui.GetWindowContentRegionWidth()/1.7)
                    if imgui.Combo("Dia", current_day,module.tgame.day.array,#module.tgame.day.names) then
                        writeMemory(0xB7014E,1,current_day[0]+1,false)
                        fcommon.CheatActivated()
                    end
                end)
                fcommon.DropDownMenu('Personalizar nome do save',function()
                    imgui.InputText("Nome", module.tgame.gxt_save_name,ffi.sizeof(module.tgame.gxt_save_name))
                    imgui.Spacing()
                    if imgui.Button("Salvar",imgui.ImVec2(fcommon.GetSize(1))) then
                        if isCharOnFoot(PLAYER_PED) then
                            registerMissionPassed(setFreeGxtEntry(ffi.string(module.tgame.gxt_save_name)))
                            activateSaveMenu()
                        else
                            printHelpString("Jogador ~r~nao~w~ esta a pe!")
                        end
                    end
                end)
                
                fcommon.UpdateAddress({name = 'Dias que se passaram',address = 0xB79038 ,size = 4,min = 0,max = 9999})
                fcommon.DropDownMenu('FPS',function()

                    imgui.Columns(2,nil,false)
                    imgui.Text("Mínimo" .. " = 1")
                    
                    imgui.NextColumn()
                    imgui.Text("Máximo" .. " = 999")
                    imgui.Columns(1)

                    imgui.PushItemWidth(imgui.GetWindowWidth()-50)
                    if imgui.InputInt('Definir',module.tgame.fps_limit) then
                        memory.write(0xC1704C,(module.tgame.fps_limit[0]+1),1)
                        memory.write(0xBA6794,1,1)
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xC1704C),{1,module.tgame.fps_limit[0]+1})
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xBA6794),{1,1})
                    end
                    if module.tgame.fps_limit[0] < 1 then
                        module.tgame.fps_limit[0] = 1
                    end

                    imgui.PopItemWidth()

                    imgui.Spacing()
                    if imgui.Button("Mínimo",imgui.ImVec2(fcommon.GetSize(3))) then
                        memory.write(0xC1704C,1,1)
                        memory.write(0xBA6794,1,1)
                        module.tgame.fps_limit[0] = 1
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xC1704C),{1,1})
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xBA6794),{1,1})
                    end
                    imgui.SameLine()
                    if imgui.Button("Padrão",imgui.ImVec2(fcommon.GetSize(3))) then
                        memory.write(0xC1704C,30,1)
                        memory.write(0xBA6794,1,1)
                        module.tgame.fps_limit[0] = 30
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xC1704C),{1,30})
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xBA6794),{1,1})
                    end
                    imgui.SameLine()
                    if imgui.Button("Máximo",imgui.ImVec2(fcommon.GetSize(3))) then
                        memory.write(0xBA6794,0,1)
                        memory.write(0xBA6794,1,1)
                        module.tgame.fps_limit[0] = 999
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xC1704C),{1,999})
                        fconfig.Set(fconfig.tconfig.memory_data,string.format("0x%6.6X",0xBA6794),{1,1})
                    end
                end)
                fcommon.UpdateAddress({name = 'Velocidade do Jogo',address = 0xB7CB64,size = 4,max = 10,min = 0, is_float =true, default = 1})
                fcommon.UpdateAddress({name = 'Gravidade',address = 0x863984,size = 4,max = 1,min = -1, default = 0.008,cvalue = 0.001 ,is_float = true})
                fcommon.DropDownMenu("Definir horário",function()
                    imgui.Spacing()
            
                    local days_passed = imgui.new.int(memory.read(0xB79038 ,4))
                    local hour = imgui.new.int(memory.read(0xB70153,1))
                    local minute = imgui.new.int(memory.read(0xB70152,1))
            
                    if imgui.InputInt("Hora",hour) then
                        memory.write(0xB70153 ,hour[0],1)
                    end
            
                    if imgui.InputInt("Minuto",minute) then
                        memory.write(0xB70152 ,minute[0],1)
                    end
            
                    if minute[0] > 59 then
                        hour[0] = hour[0] + 1
                        minute[0] = 0
                    end
            
                    if hour[0] > 23 then
                        memory.write(0xB70153 ,0,1)
                        current_day = memory.read(0xB7014E,1)
                        memory.write(0xB7014E,(current_day+1),1)
                        days_passed = memory.read( 0xB79038,4)
                        memory.write( 0xB79038,(days_passed+1),4)
                    end
            
                    if minute[0] < 0 then
                        hour[0] = hour[0] - 1
                        minute[0] = 59
                    end
            
                    if hour[0] < 0 then
                        memory.write(0xB70153 ,23,1)
                        current_day = memory.read(0xB7014E,1)
                        memory.write(0xB7014E,(current_day-1),1)
                        days_passed = memory.read( 0xB79038,4)
                        memory.write( 0xB79038,(days_passed-1),4)
                    end
                end)
                fcommon.DropDownMenu('Temas',function()
                    fcommon.RadioButtonAddress('Selecionar tema',{'Praia','Country','Fun house','Ninja'},{0x969159,0x96917D,0x969176,0x96915C})
                end)
                fcommon.CallFuncButtons("Clima",  {["Ensolarado"] = 0x438F50,["Nublado"] = 0x438F60,["Chuvoso"] = 0x438F70,
                                                   ["Neblina"] = 0x438F80,["Trovoada"] = 0x439570,["Tempestade de areia"] = 0x439590})
                imgui.EndChild()
            end
        end
        if fcommon.BeginTabItem('Gerenciador de Script') then
            if imgui.Button("Recarregar todos scripts",imgui.ImVec2(fcommon.GetSize(1))) then
                fgame.tgame.script_manager.skip_auto_reload = true
                reloadScripts()
            end
            imgui.Spacing()
            local width = imgui.GetWindowContentRegionWidth()
            imgui.SetNextItemWidth(width/2)
            fcommon.DropDownList("##Lista",module.tgame.script_manager.categories,module.tgame.script_manager.selected,
            function(key,val) 
                module.tgame.script_manager.selected = key
            end)
            imgui.SameLine()
        
            imgui.SetNextItemWidth(width/2)
            local filter = module.tgame.script_manager.filter

            filter:Draw("Procurar")
            if filter:PassFilter('') then
                local min = imgui.GetItemRectMin()
                local drawlist = imgui.GetWindowDrawList()
                drawlist:AddText(imgui.ImVec2(min.x+imgui.GetStyle().ItemInnerSpacing.x,min.y+imgui.GetStyle().FramePadding.y), imgui.GetColorU32(imgui.Col.TextDisabled),"Procurar")
            end

            if imgui.BeginChild("Script entries") then

                module.MonitorScripts()

                if module.tgame.script_manager.selected ~= "Não carregado" then
                    for index, script in ipairs(script.list()) do
                        if filter:PassFilter(script.name) then
                            ShowLoadedScript(script,index)
                        end
                    end
                end
                
                if module.tgame.script_manager.selected ~= "Carregado" then
                    for name,path in pairs(module.tgame.script_manager.not_loaded) do
                        if filter:PassFilter(name) then
                            ShowNotLoadedScripts(name,path)
                        end
                    end
                end
				imgui.EndChild()
			end
        end
        if fcommon.BeginTabItem('Criador de objetos') then
            if imgui.Button("Procurar imagens",imgui.ImVec2(fcommon.GetSize(3))) then
                os.execute('explorer "https://dev.prineside.com/en/gtasa_samp_model_id"')
            end
            imgui.SameLine()
            if imgui.Button("Criar IPL",imgui.ImVec2(fcommon.GetSize(3))) then
                GenerateIPL()
            end
            imgui.SameLine()
            if imgui.Button("Remover todos",imgui.ImVec2(fcommon.GetSize(3))) then
                module.RemoveAllObjects()
                printHelpString("Objetos removidos")
            end
            if fcommon.BeginTabBar('Object SpawnerBar') then
                if fcommon.BeginTabItem('Criar') then
                    fcommon.CheckBoxVar('Inserir coordenada do jogador',module.tgame.object_spawner.set_player_coord)
                    imgui.Spacing()
                    imgui.InputText("Nome do objeto", module.tgame.object_spawner.obj_name,ffi.sizeof(module.tgame.object_spawner.obj_name))
                    imgui.InputText("Nome do Grupo", module.tgame.object_spawner.group_name,ffi.sizeof(module.tgame.object_spawner.group_name))
                    if module.tgame.object_spawner.set_player_coord[0] then
                        module.tgame.object_spawner.coord.x[0],module.tgame.object_spawner.coord.y[0],module.tgame.object_spawner.coord.z[0] = getCharCoordinates(PLAYER_PED)
                    end
                    imgui.Spacing()
                    imgui.InputInt("Modelo",module.tgame.object_spawner.model)
                    imgui.Spacing()
                    imgui.InputFloat("Coordenada X",module.tgame.object_spawner.coord.x,1.0, 1.0, "%.5f")
                    imgui.InputFloat("Coordenada Y",module.tgame.object_spawner.coord.y,1.0, 1.0, "%.5f")
                    imgui.InputFloat("Coordenada Z",module.tgame.object_spawner.coord.z,1.0, 1.0, "%.5f")
                    imgui.Dummy(imgui.ImVec2(0,10))
                    if imgui.Button("Criar objeto",imgui.ImVec2(fcommon.GetSize(1))) then
                        SpawnObject(module.tgame.object_spawner.model[0],ffi.string(module.tgame.object_spawner.obj_name),ffi.string(module.tgame.object_spawner.group_name),module.tgame.object_spawner.coord.x[0],module.tgame.object_spawner.coord.y[0],module.tgame.object_spawner.coord.z[0])
                    end
                end
                if fcommon.BeginTabItem('Adicionados') then
                    imgui.Spacing()
                    local width = imgui.GetWindowContentRegionWidth()
                    imgui.SetNextItemWidth(width/2)
                    fcommon.DropDownList("##Lista",module.tgame.object_spawner.categories,module.tgame.object_spawner.selected,
                    function(key,val) 
                        module.tgame.object_spawner.selected = key
                    end)
                    imgui.SameLine()
                
                    imgui.SetNextItemWidth(width/2)
                    local filter = module.tgame.object_spawner.filter
    
                    filter:Draw("Procurar")
                    if filter:PassFilter('') then
                        local min = imgui.GetItemRectMin()
                        local drawlist = imgui.GetWindowDrawList()
                        drawlist:AddText(imgui.ImVec2(min.x+imgui.GetStyle().ItemInnerSpacing.x,min.y+imgui.GetStyle().FramePadding.y), imgui.GetColorU32(imgui.Col.TextDisabled),"Procurar")
                    end
                    imgui.Spacing()
                    if imgui.BeginChild("Adicionados") then 
                        if module.tgame.object_spawner.selected == "Grupos" then
                            local size = imgui.GetFrameHeight()
                            for grp,data in pairs(module.tgame.object_spawner.placed) do
                                fcommon.DropDownMenu(grp,function()
    
                                    if imgui.Button("Adicionar colisões",imgui.ImVec2(fcommon.GetSize(2))) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.collision[0] = true
                                                    setObjectCollision(handle,true)
                                                end
                                                break
                                            end
                                        end
                                        printHelpString("Colisoes adicionadas")
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("Remover colisões",imgui.ImVec2(fcommon.GetSize(2))) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.collision[0] = false
                                                    setObjectCollision(handle,false)
                                                end
                                                break
                                            end
                                        end
                                        printHelpString("Colisoes removidas")
                                    end
                                    imgui.Spacing()
                                    imgui.Columns(2,nil,false)
                                    if imgui.Button("+##X",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    _,x,y,z = getObjectCoordinates(handle)
                                                    x = x + 1
                                                    setObjectCoordinates(handle,x,y,z)
                                                end
                                                break
                                            end
                                        end
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("-##X",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    _,x,y,z = getObjectCoordinates(handle)
                                                    x = x - 1
                                                    setObjectCoordinates(handle,x,y,z)
                                                end
                                                break
                                            end
                                        end
                                    end    
                                    imgui.SameLine()        
                                    imgui.Text("Mover X")
    
                                    if imgui.Button("+##Y",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    _,x,y,z = getObjectCoordinates(handle)
                                                    y = y + 1
                                                    setObjectCoordinates(handle,x,y,z)
                                                end
                                                break
                                            end
                                        end
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("-##Y",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    _,x,y,z = getObjectCoordinates(handle)
                                                    y = y - 1
                                                    setObjectCoordinates(handle,x,y,z)
                                                end
                                                break
                                            end
                                        end
                                    end    
                                    imgui.SameLine()        
                                    imgui.Text("Mover Y")
                                    
                                    if imgui.Button("+##Z",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    _,x,y,z = getObjectCoordinates(handle)
                                                    z = z + 1
                                                    setObjectCoordinates(handle,x,y,z)
                                                end
                                                break
                                            end
                                        end
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("-##Z",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    _,x,y,z = getObjectCoordinates(handle)
                                                    z = z - 1
                                                    setObjectCoordinates(handle,x,y,z)
                                                end
                                                break
                                            end
                                        end
                                    end    
                                    imgui.SameLine()        
                                    imgui.Text("Mover Z")
    
                                    imgui.NextColumn()
                                    
                                    if imgui.Button("+##rotX",imgui.ImVec2(size,size)) then
                            
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.rotx[0] = value.rotx[0] + 1
                                                    setObjectRotation(tonumber(handle),value.rotx[0],value.roty[0],value.rotz[0])
                                                end
                                                break
                                            end
                                        end
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("-##rotX",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.rotx[0] = value.rotx[0] - 1
                                                    setObjectRotation(tonumber(handle),value.rotx[0],value.roty[0],value.rotz[0])
                                                end
                                                break
                                            end
                                        end
                                    end    
                                    imgui.SameLine()        
                                    imgui.Text("Rotacionar X")
    
                                    if imgui.Button("+##rotY",imgui.ImVec2(size,size)) then
                            
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.roty[0] = value.roty[0] + 1
                                                    setObjectRotation(tonumber(handle),value.rotx[0],value.roty[0],value.rotz[0])
                                                end
                                                break
                                            end
                                        end
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("-##rotY",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.roty[0] = value.roty[0] - 1
                                                    setObjectRotation(tonumber(handle),value.rotx[0],value.roty[0],value.rotz[0])
                                                end
                                                break
                                            end
                                        end
                                    end    
                                    imgui.SameLine()        
                                    imgui.Text("Rotacionar Y")
    
                                    if imgui.Button("+##rotZ",imgui.ImVec2(size,size)) then
                            
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.rotz[0] = value.rotz[0] + 1
                                                    setObjectRotation(tonumber(handle),value.rotx[0],value.roty[0],value.rotz[0])
                                                end
                                                break
                                            end
                                        end
                                    end
                                    imgui.SameLine()
                                    if imgui.Button("-##rotZ",imgui.ImVec2(size,size)) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    value.rotz[0] = value.rotz[0] - 1
                                                    setObjectRotation(tonumber(handle),value.rotx[0],value.roty[0],value.rotz[0])
                                                end
                                                break
                                            end
                                        end
                                    end    
                                    imgui.SameLine()        
                                    imgui.Text("Rotacionar Z")
                                    imgui.Columns(1)
                                    
                                    imgui.Spacing()
                                    if imgui.Button("Remover grupo",imgui.ImVec2(fcommon.GetSize(1))) then
                                        for lgrp,ldata in pairs(module.tgame.object_spawner.placed) do
                                            if grp == lgrp then
                                                for lkey,value in pairs(ldata) do
                                                    local model, handle = string.match(lkey,"(%w+)##(%w+)")
                                                    deleteObject(tonumber(handle))
                                                end
                                                module.tgame.object_spawner.placed[lgrp] = nil
                                                break
                                            end
                                        end
                                        printHelpString("Grupo removido")
                                    end
                                end)
                            end
                        else
                            for grp,data in pairs(module.tgame.object_spawner.placed) do
                                for key,value in pairs(data) do
                                    local model, handle = string.match(key,"(%w+)##(%w+)")
                                    if filter:PassFilter(tostring(model)) or filter:PassFilter(value.name) then
                                        handle = tonumber(handle)
                                        fcommon.DropDownMenu(string.format("%s - %s - %s",grp,value.name,key),function()
                                            local _,x,y,z = getObjectCoordinates(handle)
                                            
                                            module.tgame.object_spawner.coord.x[0] = x
                                            module.tgame.object_spawner.coord.y[0] = y
                                            module.tgame.object_spawner.coord.z[0] = z
    
                                            if imgui.Checkbox("Collisão",value.collision) then
                                                setObjectCollision(handle,value.collision[0])
                                            end
                                            imgui.InputFloat("Coordenada X",module.tgame.object_spawner.coord.x,1.0, 1.0, "%.5f")
                                            imgui.InputFloat("Coordenada Y",module.tgame.object_spawner.coord.y,1.0, 1.0, "%.5f")
                                            imgui.InputFloat("Coordenada Z",module.tgame.object_spawner.coord.z,1.0, 1.0, "%.5f")
                                            setObjectCoordinates(handle,module.tgame.object_spawner.coord.x[0],module.tgame.object_spawner.coord.y[0],module.tgame.object_spawner.coord.z[0])
                                            
                                            imgui.Spacing()
                                            
                                            imgui.SliderFloat("Rotacionar X",value.rotx,0,360, "%.5f")
                                            imgui.SliderFloat("Rotacionar Y",value.roty,0,360, "%.5f")
                                            imgui.SliderFloat("Rotacionar Z",value.rotz,0,360, "%.5f")
                                            setObjectRotation(handle,value.rotx[0],value.roty[0],value.rotz[0])
                                            imgui.Spacing()
                                            if imgui.Button("Remover objeto",imgui.ImVec2(fcommon.GetSize(1))) then
                                                for lgrp,data in pairs(module.tgame.object_spawner.placed) do
                                                    if grp == lgrp then
                                                        for lkey,value in pairs(data) do
                                                            if key == lkey then
                                                                local model, handle = string.match(key,"(%w+)##(%w+)")
                                                                deleteObject(tonumber(handle))
                                                                module.tgame.object_spawner.placed[grp][key] = nil
                                                            end
                                                        end
                                                        break
                                                    end
                                                end
                                                printHelpString("Objeto removido")
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                        imgui.EndChild()
                    end
                end
                fcommon.EndTabBar()
            end
        end
        fcommon.EndTabBar()
    end
end

return module
