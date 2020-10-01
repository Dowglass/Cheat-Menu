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

module.tvehicle =
{
    aircraft =
    {
        camera = imgui.new.bool(fconfig.Get('tvehicle.aircraft.camera',false)),
        index = fconfig.Get('tvehicle.aircraft.index',2),
        spawn_in_air = imgui.new.bool(fconfig.Get('tvehicle.aircraft.spawn_in_air',true)),
        zoom = { -5.0,-15.0,-20.0,-30.0,-40.0},
    },
    apply_material_filter = imgui.new.bool(fconfig.Get('tvehicle.apply_material_filter',true)),
    car_engine = imgui.new.int(fconfig.Get('tvehicle.car_engine',fconst.CHECKBOX_STATE.NOT_CONFIGURED)),
    color =
    {
        car_data_table = {},
        col_data_table = {},
        default = -1,
        radio_btn = imgui.new.int(1),
        rgb      = imgui.new.float[3](0.0,0.0,0.0),
        show_all = imgui.new.bool(fconfig.Get('tvehicle.color.show_all',false))
    },
    components   =
    {
        enable_saving = imgui.new.bool(fconfig.Get('tvehicle.components.enable_saving',false)),
        save_data     = fconfig.Get('tvehicle.components.save_data',{}),
        images   = {},
        list     = {},
        names    = {},
        path     =  tcheatmenu.dir .. "vehicles\\components\\",
        saved    = false,
        selected = imgui.new.int(0),
        value    = imgui.new.int(0),
    },
    doors = 
    {
        "Capô",
    	"Porta-malas",
    	"Porta dianteira esquerdo",
    	"Porta dianteira direita",
    	"Porta traseira esquerda",
        "Porta traseira direita",
        "Tudo",
    },
    door_menu_button = imgui.new.int(0),
    first_person_camera = 
    {
        bool            = imgui.new.bool(fconfig.Get('tvehicle.first_person_camera.bool',false)),
        offsets         = fcommon.LoadJson("first person camera offsets"),
        offset_x_var    = imgui.new.float(0),
        offset_y_var    = imgui.new.float(0),
        offset_z_var    = imgui.new.float(0),
    },
    gxt_name        = imgui.new.char[32](""),
    gxt_name_table  = fconfig.Get('tvehicle.gxt_name_table',{}),
    handling_flags = fcommon.LoadJson("handling flags"),
    handling_name = {},
    heavy = imgui.new.bool(fconfig.Get('tvehicle.heavy',false)),
    images = {},
    invisible_car = imgui.new.bool(fconfig.Get('tvehicle.invisible_car',false)),
    license_plate_text = imgui.new.char[9](fconfig.Get('tvehicle.license_plate_text',"TM28 4CO")),
    lights = imgui.new.bool(fconfig.Get('tvehicle.lights',false)),
    lock_doors = imgui.new.bool(false),
    lock_speed = imgui.new.bool(fconfig.Get('tvehicle.lock_speed',false)),
    max_velocity_temp = imgui.new.int(-1),
    model_flags = fcommon.LoadJson("model flags"),
    names = fcommon.LoadJson("vehicle"),
    paintjobs  = 
    {
        cache_images     = {},
        current_paintjob = imgui.new.int(-1);
        enable_saving    = imgui.new.bool(fconfig.Get('tvehicle.paintjobs.enable_saving',false)),
        save_data        = fconfig.Get('tvehicle.paintjobs.save_data',{}),
        names            = 0,
        path             =  tcheatmenu.dir .. "vehicles\\paintjobs",
        paintjobs_count  = 0,
        images           = {},
        texture          = nil
    },
    neon   = 
    {
        checkbox = imgui.new.bool(fconfig.Get('tvehicle.neon.checkbox',false)),
        data     = fcommon.LoadJson("neon data"),
        rgb      = imgui.new.float[3](0.0,0.0,0.0),
        rb_value = imgui.new.int(-1),
    },
    no_vehicles = imgui.new.bool(fconfig.Get('tvehicle.no_vehicles',false)),
    no_damage = imgui.new.bool(fconfig.Get('tvehicle.no_damage',false)),
    path = tcheatmenu.dir .. "vehicles\\images",
    rainbow_colors = 
    {
        bool = imgui.new.bool(fconfig.Get('tvehicle.rainbow_colors.bool',false)),
        traffic = imgui.new.bool(fconfig.Get('tvehicle.rainbow_colors.traffic',false)),
        speed = imgui.new.float(fconfig.Get('tvehicle.rainbow_colors.speed',0.5)),
    },
    rainbow_neons = 
    {
        bool = imgui.new.bool(fconfig.Get('tvehicle.rainbow_neons.bool',false)),
        traffic = imgui.new.bool(fconfig.Get('tvehicle.rainbow_neons.traffic',false)),
        speed = imgui.new.float(fconfig.Get('tvehicle.rainbow_neons.speed',0.5)),
    },
    spawn_inside = imgui.new.bool(fconfig.Get('tvehicle.spawn_inside',true)),
    speed = imgui.new.int(fconfig.Get('tvehicle.speed',0)),
    stay_on_bike = imgui.new.bool(fconfig.Get('tvehicle.stay_on_bike',false)),
    trains =
    {
        ["449"]     = {8,9},
        ["537"]     = {0,3,6,10,12,13},
        ["538"]     = {1,5,15},
    },
    unlimited_nitro = imgui.new.bool(fconfig.Get('tvehicle.unlimited_nitro',false)), 
    visual_damage   = imgui.new.bool(fconfig.Get('tvehicle.visual_damage',false)),
    watertight_car  = imgui.new.bool(fconfig.Get('tvehicle.watertight_car',false)),
}

--------------------------------------------------
-- Neon

result, handle = loadDynamicLibrary("neon_api.asi")
module.tvehicle.neon["Handle"] = handle

if module.tvehicle.neon["Handle"] ~= 0 then
    result, proc = getDynamicLibraryProcedure("SetFlag",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["SetFlag"] = proc

    result, proc = getDynamicLibraryProcedure("GetFlag",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["GetFlag"] = proc

    result, proc = getDynamicLibraryProcedure("SetX",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["SetX"] = proc

    result, proc = getDynamicLibraryProcedure("SetY",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["SetY"] = proc

    result, proc = getDynamicLibraryProcedure("InstallNeon",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["InstallNeon"] = proc

    result, proc = getDynamicLibraryProcedure("SetRed",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["SetRed"] = proc

    result, proc = getDynamicLibraryProcedure("SetGreen",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["SetGreen"] = proc

    result, proc = getDynamicLibraryProcedure("SetBlue",module.tvehicle.neon["Handle"])
    module.tvehicle.neon["SetBlue"] = proc
end

function InstallNeon(car,color)
    car = car or getCarCharIsUsing(PLAYER_PED)
    local pveh = getCarPointer(car)
    
    if module.tvehicle.neon["Handle"] ~= 0 then
        if module.tvehicle.neon["InstallNeon"] and module.tvehicle.neon["SetX"] and module.tvehicle.neon["SetY"] then
            callFunction(module.tvehicle.neon["InstallNeon"],3,3,pveh,0,0)
            
            local data = module.tvehicle.neon.data[casts.CModelInfo.GetNameFromModel(getCarModel(car))] or { X = 0.0, Y = 0.0}
  
            callFunction(module.tvehicle.neon["SetX"],2,2,pveh,data.X)
            callFunction(module.tvehicle.neon["SetY"],2,2,pveh,data.Y)

            callFunction(module.tvehicle.neon["SetRed"],2,2,pveh,color[1])
            callFunction(module.tvehicle.neon["SetGreen"],2,2,pveh,color[2])
            callFunction(module.tvehicle.neon["SetBlue"],2,2,pveh,color[3])

            if module.tvehicle.paintjobs.enable_saving[0] then
                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.neon.red",getCarModel(car)),color[1])
                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.neon.green",getCarModel(car)),color[2])
                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.neon.blue",getCarModel(car)),color[3])
            end
        end
    end
end

function module.TrafficNeons()
    while module.tvehicle.neon.checkbox[0] and module.tvehicle.neon["Handle"] ~= 0 do
        for hveh in fcommon.pool("veh") do
            local temp = 0

            if getVehicleClass(hveh) == fconst.VEHICLE_CLASS.NORMAL then
                temp = math.random(1,20) -- 5%
            end
            if getVehicleClass(hveh) == fconst.VEHICLE_CLASS.RICH_FAMILY then
                temp = math.random(1,5) -- 20%
            end
            if getVehicleClass(hveh) == fconst.VEHICLE_CLASS.EXECUTIVE then
                temp = math.random(1,3) -- 30%
            end

            if temp == 1 and callFunction(module.tvehicle.neon["GetFlag"],1,1,hveh) ~= 0x10 then
                if getCarCharIsUsing(PLAYER_PED) ~= hveh then
                    InstallNeon(hveh,{math.random(0,255),math.random(0,255),math.random(0,255)})
                end
            end
            callFunction(module.tvehicle.neon["SetFlag"],2,2,hveh,0x10)
        end
        wait(100)
    end
end

--------------------------------------------------

function module.GiveVehicleToPlayer(model)
    model = tonumber(model)
    local vehicle = nil
    local interior = getCharActiveInterior(PLAYER_PED)

    if isModelAvailable(model) then

        local x,y,z = getCharCoordinates(PLAYER_PED)

        local speed = 0
        
        if isCharInAnyCar(PLAYER_PED) and module.tvehicle.spawn_inside[0] then

            local hveh = getCarCharIsUsing(PLAYER_PED)
            local previous_model = getCarModel(hveh)
            speed = getCarSpeed(hveh)

            warpCharFromCarToCoord(PLAYER_PED,x,y,z)

            if casts.CModelInfo.IsTrainModel(model) then
                deleteMissionTrain(hveh)
            else
                deleteCar(hveh)
            end
        end

        if interior == 0 then
            if (module.tvehicle.aircraft.spawn_in_air[0]) and (isThisModelAHeli(model) or isThisModelAPlane(model)) then
                z = 400
            end
        else
            z = z - 5
        end
        
        if casts.CModelInfo.IsTrainModel(model) then

            local train_id_table = module.tvehicle.trains[tostring(model)]
            local train_id = train_id_table[math.random(1,#train_id_table)]

            -- Loading all train related models
            requestModel(590)	
            requestModel(538)	
            requestModel(570)	
            requestModel(569)
            requestModel(537)	
            requestModel(449)

            loadAllModelsNow()

            if math.random(0,1) == 0 then
                vehicle = createMissionTrain(train_id,x,y,z)
            else
                vehicle = createMissionTrain(train_id,x,y,z,true)
            end
            
            deleteChar(getDriverOfCar(vehicle))

            if module.tvehicle.spawn_inside[0] then
                warpCharIntoCar(PLAYER_PED,vehicle)
                setTrainCruiseSpeed(vehicle,speed)
            end

            markMissionTrainAsNoLongerNeeded(vehicle)
            markModelAsNoLongerNeeded(590)	
            markModelAsNoLongerNeeded(538)	
            markModelAsNoLongerNeeded(570)	
            markModelAsNoLongerNeeded(569)
            markModelAsNoLongerNeeded(537)	
            markModelAsNoLongerNeeded(449)

        else

            requestModel(model)
            loadAllModelsNow()

            customPlateForNextCar(model,ffi.string(module.tvehicle.license_plate_text))
            
            if not module.tvehicle.spawn_inside[0] then
                vehicle = spawnVehicleByCheating(model)
            else
                vehicle = createCar(model,x,y,z)
                setCarHeading(vehicle,getCharHeading(PLAYER_PED))
                warpCharIntoCar(PLAYER_PED,vehicle)
                setCarForwardSpeed(vehicle,speed)
            end

            markCarAsNoLongerNeeded(vehicle)
            markModelAsNoLongerNeeded(model)
        end

        if doesVehicleExist(vehicle) then
            setVehicleInterior(vehicle,interior)
        end
        
        fcommon.CheatActivated()
    end
end

--------------------------------------------------
-- Camera

function module.AircraftCamera()

    while module.tvehicle.aircraft.camera[0] do
        while isCharInAnyHeli(PLAYER_PED)
        or isCharInAnyPlane(PLAYER_PED) do
            
            -- FirstPersonCamera controls the camera if its enabled
            if module.tvehicle.aircraft.camera[0] == false or module.tvehicle.first_person_camera.bool[0] then break end 

            local vehicle = getCarCharIsUsing(PLAYER_PED)
            local roll = getCarRoll(vehicle)

            attachCameraToVehicle(vehicle,0.0,module.tvehicle.aircraft.zoom[module.tvehicle.aircraft.index],2.5,0.0,0.0,0.0,(roll*-1),2)
            if isKeyDown(0x56) then
                while isKeyDown(0x56) do
                    wait(0)
                end
                module.tvehicle.aircraft.index = module.tvehicle.aircraft.index + 1
                if module.tvehicle.aircraft.index > #module.tvehicle.aircraft.zoom then
                    module.tvehicle.aircraft.index  = 0
                end
            end
            wait(0)
        end
        wait(100)
    end
    restoreCameraJumpcut()
end

function module.FirstPersonCamera()
    local total_x = 0
    local total_y = 0

    while module.tvehicle.first_person_camera.bool[0] and not isCharOnFoot(PLAYER_PED) and not fgame.tgame.camera.bool[0] do

        local hveh = getCarCharIsUsing(PLAYER_PED)        
        
        x,y = getPcMouseMovement()
        total_x = total_x + x
        total_y = total_y + y

        local roll = 0.0
        if module.tvehicle.aircraft.camera[0] == true then -- check if new aircraft camera is enabled
            roll = getCarRoll(hveh)
        end

        if fgame.tgame.camera.bool[0] then
            break
        end
        attachCameraToChar(PLAYER_PED,module.tvehicle.first_person_camera.offset_x_var[0], module.tvehicle.first_person_camera.offset_y_var[0], module.tvehicle.first_person_camera.offset_z_var[0], total_x, 180, total_y, (roll*-1), 2)
        wait(0)
    end
    restoreCameraJumpcut()  
end

--------------------------------------------------
-- Color/ paintjob

function module.ForEachCarComponent(func,skip,car)
    car = car or getCarCharIsUsing(PLAYER_PED)
    if car ~= nil then

        for _, comp in ipairs(mad.get_all_vehicle_components(car)) do
            for _, obj in ipairs(comp:get_objects()) do
                for _, mat in ipairs(obj:get_materials()) do
                    func(mat,comp,car)
                    if skip == true then
                        goto _skip
                    end
                end
            end
            ::_skip::
        end
    else
        printHelpString("O jogador ~r~nao ~w~esta no carro!")
    end
end

function module.GetTextureName(name)
    if name == nil then
        return ""
    else
        return name
    end
end

function module.ParseCarcols()
    local file_path = string.format("%s/data/carcols.dat",getGameDirectory())
    local col_data = false
    local car_data = false

    if doesFileExist(file_path) then
  
        for line in io.lines(file_path) do
            if line == "col" then
                col_data = true
                goto continue
            end
            if line == "car" or line == "car4" then
                car_data = true
                goto continue
            end 
            if line == "end" then
                if col_data then col_data = false end
                if car_data then car_data = false end
                goto continue
            end
            if col_data then
                local r, g, b = string.match(line,"(%d+).(%d+).(%d+)")

                if r and g and b then
                    table.insert(module.tvehicle.color.col_data_table,string.format("%d %d %d",r,g,b))
                end
            end
            if car_data then
                local name = nil
                for x in string.gmatch(line,"[^,]+") do
                    if type(tonumber(x)) == "nil" then
                        name = string.upper(x)
                        module.tvehicle.color.car_data_table[name] = {}
                    end
                    if type(tonumber(x)) == "number" then
                        table.insert(module.tvehicle.color.car_data_table[name],tonumber(x))
                    end
                end
            end
            ::continue::
        end
    end
end

function module.ParseVehiclesIDE()
    local file_path = string.format("%s/data/vehicles.ide",getGameDirectory())
    local cars_data = false
    local tt = module.tvehicle.handling_name
    if doesFileExist(file_path) then
  
        for line in io.lines(file_path) do
            if line == "cars" then
                cars_data = true
            end 
            if line == "end" then
                if cars_data then cars_data = false end
                goto continue
            end
            if cars_data then
                local name = nil
                local t = {}
                for x in string.gmatch(line,"[^,]+") do             
                    x = x:gsub(".",{["\t"] ="",[","] = "",[" "] = ""})
                    table.insert(t,x)
                end
                t[1] = tonumber(t[1])
                if t[1] ~= nil then
                    tt[t[1]] = t[5]
                end
            end
        end
        ::continue::
    end
end

function ApplyColor(load_saved_color,car)


    module.ForEachCarComponent(function(mat,comp,car)

        local r, g, b, old_a = mat:get_color()
        local model = getCarModel(car)

        if load_saved_color then
            module.tvehicle.color.rgb[0] = fconfig.Get(string.format("%d.%s.red",model,comp.name),-1,module.tvehicle.paintjobs.save_data) 
            module.tvehicle.color.rgb[1] = fconfig.Get(string.format("%d.%s.green",model,comp.name),-1,module.tvehicle.paintjobs.save_data) 
            module.tvehicle.color.rgb[2] = fconfig.Get(string.format("%d.%s.blue",model,comp.name),-1,module.tvehicle.paintjobs.save_data) 
        end

        if (module.tvehicle.color.rgb[0] ~= -1.0 and module.tvehicle.color.rgb[1] ~= -1.0 and module.tvehicle.color.rgb[2] ~= -1.0)
        and (not module.tvehicle.apply_material_filter[0] or (r == 0x3C and g == 0xFF and b == 0x00) or (r == 0xFF and g == 0x00 and b == 0xAF)) then
            
            local save_data = false

            if module.tvehicle.components.selected[0] == 0 and not load_saved_color then   
                mat:set_color(module.tvehicle.color.rgb[0]*255, module.tvehicle.color.rgb[1]*255, module.tvehicle.color.rgb[2]*255, 255.0)
                save_data = true
            end

            if comp.name == module.tvehicle.components.names[module.tvehicle.components.selected[0]+1] or load_saved_color then     
                mat:set_color(module.tvehicle.color.rgb[0]*255, module.tvehicle.color.rgb[1]*255, module.tvehicle.color.rgb[2]*255, 255.0)
                save_data = true
            end

            if save_data and module.tvehicle.paintjobs.enable_saving[0] then
                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.%s.red",model,comp.name),module.tvehicle.color.rgb[0])
                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.%s.green",model,comp.name),module.tvehicle.color.rgb[1])
                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.%s.blue",model,comp.name),module.tvehicle.color.rgb[2])
            end 
        end
        module.tvehicle.color.default = getCarColours(car)
    end,false,car)  
end

function ApplyTexture(filename,load_saved_texture,car)

    module.ForEachCarComponent(function(mat,comp,car)
        local r, g, b, old_a = mat:get_color()

        local model = getCarModel(car)

        if load_saved_texture then
            filename = fconfig.Get(string.format("%d.%s.texture",model,comp.name),nil,module.tvehicle.paintjobs.save_data) 
        end 

        if filename ~= nil then
            local fullpath = module.tvehicle.paintjobs.path .. "\\" .. filename .. ".png"

            if doesFileExist(fullpath) then
                
                if module.tvehicle.paintjobs.cache_images[filename] == nil then
                    module.tvehicle.paintjobs.cache_images[filename] = mad.load_png_texture(fullpath)
                end

                module.tvehicle.paintjobs.texture = module.tvehicle.paintjobs.cache_images[filename]


                if not module.tvehicle.apply_material_filter[0] or (r == 0x3C and g == 0xFF and b == 0x00) or (r == 0xFF and g == 0x00 and b == 0xAF) then
                    local save_data = false

                    if module.tvehicle.components.selected[0] == 0 and not load_saved_texture then
                        mat:set_texture(module.tvehicle.paintjobs.texture)
                        save_data = true
                    end
                    if comp.name == module.tvehicle.components.names[module.tvehicle.components.selected[0]+1] or load_saved_texture then
                        mat:set_texture(module.tvehicle.paintjobs.texture)
                        save_data = true
                    end
                  
                    if save_data and module.tvehicle.paintjobs.enable_saving[0] then
                        fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.%s.texture",model,comp.name),filename)
                    end 
                end
            end
        end
        module.tvehicle.color.default = getCarColours(car)
    end,false,car)
end

function Rainbow(speed)
    local r = math.floor(math.sin(os.clock() * speed) * 127 + 128)
    local g = math.floor(math.sin(os.clock() * speed + 2) * 127 + 128)
    local b = math.floor(math.sin(os.clock() * speed + 4) * 127 + 128)
    return r,g,b
end

function RainbowVehicleColor(hveh)
    module.ForEachCarComponent(function(mat,comp,hveh)
        local r,g,b = mat:get_color()

        if not module.tvehicle.apply_material_filter[0] 
        or (r == 0x3C and g == 0xFF and b == 0x00) or (r == 0xFF and g == 0x00 and b == 0xAF) then
            r,g,b = Rainbow(module.tvehicle.rainbow_colors.speed[0])
            mat:set_color(r,g,b,255)
        end
    end,false,hveh)
end

function module.RainbowColors()
    while module.tvehicle.rainbow_colors.bool[0] do
        
        if module.tvehicle.rainbow_colors.traffic[0] then -- Player + Traffic  
        
            for hveh in fcommon.pool("veh") do
                RainbowVehicleColor(hveh)    
            end        
            
        else -- Only Player
            if isCharInAnyCar(PLAYER_PED) then
                local hveh = getCarCharIsUsing(PLAYER_PED)
                RainbowVehicleColor(hveh)
            else -- function not needed at this time
                break
            end
        end
        wait(0)
    end
end

function module.RainbowNeons()
    
    while module.tvehicle.rainbow_neons.bool[0] do
        
        if module.tvehicle.rainbow_neons.traffic[0] then -- Player + Traffic  
        
            for hveh in fcommon.pool("veh") do
                InstallNeon(hveh,{Rainbow(module.tvehicle.rainbow_neons.speed[0])})    
            end        
            
        else -- Only Player
            if isCharInAnyCar(PLAYER_PED) then
                local hveh = getCarCharIsUsing(PLAYER_PED)
                InstallNeon(hveh,{Rainbow(module.tvehicle.rainbow_neons.speed[0])})   
            else -- function not needed at this time
                break
            end
        end
        
        wait(0)
    end
end

--------------------------------------------------
-- Component/ tune

function StoreComponentData(hveh)
    if module.tvehicle.components.enable_saving[0] then
        local model = tostring(getCarModel(hveh))
        module.tvehicle.components.save_data[model] = {}

        for x=1,14,1 do
            local comp_model = getCurrentCarMod(hveh,x)

            if comp_model ~= -1 then
                table.insert(module.tvehicle.components.save_data[model],comp_model)
            end
        end
    end
end

function module.AddComponentToVehicle(component,car,hide_msg)
    component = tonumber(component)
    if isCharInAnyCar(PLAYER_PED) then
        if car == nil then
            car = getCarCharIsUsing(PLAYER_PED)
        end
        if isModelAvailable(component) and doesVehicleExist(car) then
            requestVehicleMod(component)
            loadAllModelsNow()
            addVehicleMod(car,component)
             
            StoreComponentData(car)

            if hide_msg ~= true then
                printHelpString("Componente ~g~adicionado")
            end
            markModelAsNoLongerNeeded(component)
        end
    end
end

function module.RemoveComponentFromVehicle(component,car,hide_msg)
    component = tonumber(component)
    if car == nil then
        car = getCarCharIsUsing(PLAYER_PED)
    end
    if doesVehicleExist(car) then
        removeVehicleMod(car,component)
        
        StoreComponentData(car)
        
        if hide_msg ~= true then
            printHelpString("Componente ~g~removido")
        end
    end
end

--------------------------------------------------
-- Misc

function module.OnEnterVehicle()

    while true do
        
        if isCharInAnyCar(PLAYER_PED) then
            local hveh        = getCarCharIsUsing(PLAYER_PED)
            local pVeh       = getCarPointer(hveh)
            local model      = getCarModel(hveh)
            
            local model_name = module.tvehicle.gxt_name_table[casts.CModelInfo.GetNameFromModel(model)] or getGxtText(casts.CModelInfo.GetNameFromModel(model))

            -- Get vehicle components
            module.tvehicle.components.names = {"default"}

            module.ForEachCarComponent(function(mat,comp,hveh)
                table.insert(module.tvehicle.components.names,comp.name)
            end,true)
            module.tvehicle.components.list  = imgui.new['const char*'][#module.tvehicle.components.names](module.tvehicle.components.names)
            
            imgui.StrCopy(module.tvehicle.gxt_name,model_name)

            if module.tvehicle.first_person_camera.offsets[tostring(model)] == nil then
                module.tvehicle.first_person_camera.offsets[tostring(model)] = 
                {
                    ["x"] = 0,
                    ["y"] = 0.1,
                    ["z"] = 0.6,
                }
            end

            module.tvehicle.first_person_camera.offset_x_var[0] = module.tvehicle.first_person_camera.offsets[tostring(model)]["x"]
            module.tvehicle.first_person_camera.offset_y_var[0] = module.tvehicle.first_person_camera.offsets[tostring(model)]["y"]
            module.tvehicle.first_person_camera.offset_z_var[0] = module.tvehicle.first_person_camera.offsets[tostring(model)]["z"]

            fcommon.SingletonThread(module.AircraftCamera,"AircraftCamera")
            fcommon.SingletonThread(module.FirstPersonCamera,"FirstPersonCamera")
            fcommon.SingletonThread(module.RainbowColors,"RainbowColors")
            fcommon.SingletonThread(module.UnlimitedNitro,"UnlimitedNitro")

            module.tvehicle.paintjobs.current_paintjob[0] = fconfig.Get(string.format("%d.paintjob",model),nil,module.tvehicle.paintjobs.save_data)  or getCurrentVehiclePaintjob(hveh)  
            module.tvehicle.paintjobs.paintjobs_count =  getNumAvailablePaintjobs(hveh)

            module.tvehicle.paintjobs.names = {"None"} 

            for i=1,module.tvehicle.paintjobs.paintjobs_count,1 do
                table.insert(module.tvehicle.paintjobs.names, string.format("Paintjob %d",i))
            end
                

            if module.tvehicle.paintjobs.enable_saving[0] then
                ApplyColor(true)
                ApplyTexture(nil,true)
                
                if getNumAvailablePaintjobs(hveh) >= module.tvehicle.paintjobs.current_paintjob[0] then
                    giveVehiclePaintjob(hveh,module.tvehicle.paintjobs.current_paintjob[0])
                end

                local color = 
                {
                    fconfig.Get(string.format("tvehicle.paintjobs.save_data.%d.neon.red",model),0),
                    fconfig.Get(string.format("tvehicle.paintjobs.save_data.%d.neon.green",model),0),
                    fconfig.Get(string.format("tvehicle.paintjobs.save_data.%d.neon.blue",model),0)
                }
                InstallNeon(hveh,color)
            end

            if module.tvehicle.components.enable_saving[0] then
                for tmodel,table in pairs(module.tvehicle.components.save_data) do
                    if tmodel == tostring(model) then
                        for _,component in ipairs(table) do
                            module.AddComponentToVehicle(component,car,true)
                        end
                        break
                    end
                end
            end

            while isCharInCar(PLAYER_PED,hveh) do
                wait(0)
            end

            module.tvehicle.first_person_camera.offsets[tostring(model)].x = module.tvehicle.first_person_camera.offset_x_var[0]
            module.tvehicle.first_person_camera.offsets[tostring(model)].y = module.tvehicle.first_person_camera.offset_y_var[0] 
            module.tvehicle.first_person_camera.offsets[tostring(model)].z = module.tvehicle.first_person_camera.offset_z_var[0] 
            module.tvehicle.max_velocity_temp[0] = -1
        end
        wait(0)
    end
end

function DoorMenu(func)
    local vehicle = getCarCharIsUsing(PLAYER_PED)
    local seats   = getMaximumNumberOfPassengers(vehicle) + 1 -- passenger + driver  

    if seats == 4 then
        doors = 5
    else
        doors = 3
    end
    if imgui.Button(module.tvehicle.doors[7],imgui.ImVec2(fcommon.GetSize(1))) then
        for i=0,doors,1 do
            func(vehicle,i)
        end
    end
    for i=0,doors,1 do
        if imgui.Button(module.tvehicle.doors[i+1],imgui.ImVec2(fcommon.GetSize(2))) then
            func(vehicle,i)
        end
        if i%2 ~= 1 then
            imgui.SameLine()
        end
    end

end   

function module.UnlimitedNitro()
    writeMemory(0x969165,1,0,true) -- ALl cars have nitro
    writeMemory(0x96918B,1,0,true) -- All taxis have nitro
    local hveh = getCarCharIsUsing(PLAYER_PED)
    while isCharInCar(PLAYER_PED,hveh) and module.tvehicle.unlimited_nitro[0] and isThisModelACar(getCarModel(hveh)) do
        
        if isKeyDown(vkeys.VK_LBUTTON) then
            module.AddComponentToVehicle(1010,hveh,true)
            while isKeyDown(vkeys.VK_LBUTTON) do
                wait(0)
            end
            module.RemoveComponentFromVehicle(1010,hveh,true)
        end

        wait(0)
    end
end

--------------------------------------------------
-- Main

function module.VehicleMain()
    if imgui.Button("Explodir carros",imgui.ImVec2(fcommon.GetSize(3))) then
        callFunction(0x439D80,0,0)
        fcommon.CheatActivated()
    end
    imgui.SameLine()
    if imgui.Button("Reparar veículo",imgui.ImVec2(fcommon.GetSize(3))) then
        if isCharInAnyCar(PLAYER_PED) then
            local car = getCarCharIsUsing(PLAYER_PED)
            fixCar(car)
            fcommon.CheatActivated()
        else
            printHelpString("Jogador nao esta no veiculo!")
        end
    end
    imgui.SameLine()
    if imgui.Button("Girar veículo",imgui.ImVec2(fcommon.GetSize(3))) then
        
        if isCharInAnyCar(PLAYER_PED) then
            local car   = getCarCharIsUsing(PLAYER_PED)

            setCarRoll(car,getCarRoll(car) + 180)
            setCarRoll(car,getCarRoll(car)) -- rotation fix
            fcommon.CheatActivated()
        else
            printHelpString("Jogador nao esta no veiculo!")
        end
    end

    if fcommon.BeginTabBar('VehiclesBar') then
        if fcommon.BeginTabItem('Caixas de seleção') then
            imgui.Columns(2,nil,false)
                
            fcommon.CheckBoxValue("Motoristas agressivos",0x96914F)
            fcommon.CheckBoxValue("Mirar enquanto estiver dirigindo (driveby)",0x969179)
            fcommon.CheckBoxValue("Todos carros com nitro",0x969165)
            fcommon.CheckBoxValue("Todos taxis com nitro",0x96918B)
            fcommon.CheckBoxValue("Barcos voam",0x969153)
            fcommon.CheckBox3Var("Motor do carro",module.tvehicle.car_engine,"Marcado - Ligado\nMarca quadrada - Não Configurado\nCaixa em branco - Desligado\n\
Defina como 'Não Configurado' se você estiver usando algum mod\nque envolve o sistemas de combustível (desativação do motor do carro).")
            fcommon.CheckBoxValue("Carros voam",0x969160)
            fcommon.CheckBoxVar("Pesar carro",module.tvehicle.heavy)
            fcommon.CheckBoxValue("Diminuir tráfego",0x96917A)
            fcommon.CheckBoxVar("Não cair de bicicletas/motos",module.tvehicle.stay_on_bike)
            fcommon.CheckBoxValue("Dirigir na água",0x969152)
            fcommon.CheckBoxVar("Câmera em primeira pessoa",module.tvehicle.first_person_camera.bool,nil,nil,
            function()
                fcommon.SingletonThread(module.FirstPersonCamera,"FirstPersonCamera")
            end,
            function()
                fcommon.InputFloat("Ângulo X", module.tvehicle.first_person_camera.offset_x_var,nil,-5,5,0.02)
                fcommon.InputFloat("Ângulo Y", module.tvehicle.first_person_camera.offset_y_var,nil,-5,5,0.02)
                fcommon.InputFloat("Ângulo Z", module.tvehicle.first_person_camera.offset_z_var,nil,-5,5,0.02)
            end)
            fcommon.CheckBoxVar("Fixar câmera em aeronaves",module.tvehicle.aircraft.camera,nil,
            function()
                fcommon.SingletonThread(module.AircraftCamera,"AircraftCamera")
            end)
            fcommon.CheckBoxValue("Fixar câmera em trens",5416239,nil,fconst.TRAIN_CAM_FIX.ON,fconst.TRAIN_CAM_FIX.OFF)
            
            imgui.NextColumn()

            fcommon.CheckBoxValue("Carros flutuam ao ser atingidos",0x969166)
            fcommon.CheckBoxValue("Semáforos verde",0x96914E)
            fcommon.CheckBoxVar("Carro invisível",module.tvehicle.invisible_car,nil,
            function()
                if isCharInAnyCar(PLAYER_PED) then
                    local car = getCarCharIsUsing(PLAYER_PED)
                    setCarVisible(car,not module.tvehicle.invisible_car[0])
                end
            end)
            fcommon.CheckBoxVar("Ligar luzes",module.tvehicle.lights,nil,
            function()
                if isCharInAnyCar(PLAYER_PED) then
                    car = getCarCharIsUsing(PLAYER_PED)
                    if module.tvehicle.lights[0] then
                        forceCarLights(car,2)
                        addOneOffSound(x,y,z,1052)
                        fcommon.CheatActivated()
                    else
                        forceCarLights(car,1)
                        addOneOffSound(x,y,z,1053)
                        fcommon.CheatDeactivated()
                    end
                else
                    printHelpString("O Jogador  ~r~nao~w~ esta no carro!")
                end
            end,nil,false)

            fcommon.CheckBoxVar("Trancar portas",module.tvehicle.lock_doors,nil,
            function()
                if isCharInAnyCar(PLAYER_PED) then
                    local car   = getCarCharIsUsing(PLAYER_PED)
                    if getCarDoorLockStatus(car) == 4 then
                        lockCarDoors(car,1)
                        fcommon.CheatDeactivated()
                    else
                        lockCarDoors(car,4)
                        fcommon.CheatActivated()
                    end
                else
                    printHelpString("O Jogador  ~r~nao~w~ esta no carro!")
                end
            end,nil,false)
 
            fcommon.CheckBoxVar("Sem dano",module.tvehicle.no_damage)
            fcommon.CheckBoxVar("Sem trânsito de veículos",module.tvehicle.no_vehicles,nil,
            function()
                if module.tvehicle.no_vehicles[0] then
                    writeMemory(0x434237,1,0x73,false) -- change condition to unsigned (0-255)
                    writeMemory(0x434224,1,0,false)
                    writeMemory(0x484D19,1,0x83,false) -- change condition to unsigned (0-255)
                    writeMemory(0x484D17,1,0,false)
                    fcommon.CheatActivated()
                else
                    writeMemory(0x434237,1,-1063242627,false) -- change condition to unsigned (0-255)
                    writeMemory(0x434224,1,940431405,false)
                    writeMemory(0x484D19,1,292493,false) -- change condition to unsigned (0-255)
                    writeMemory(0x484D17,1,1988955949,false)
                    fcommon.CheatDeactivated()
                end
            end,nil,false)
            
            fcommon.CheckBoxVar("Não mostrar dano",module.tvehicle.visual_damage)
            fcommon.CheckBoxValue("Handling perfeito",0x96914C)
            fcommon.CheckBoxValue("Modo tanque",0x969164) 
            fcommon.CheckBoxVar("Tráfego neon",module.tvehicle.neon.checkbox,"Adiciona luzes de neon aos veículos de trânsito.\nApenas alguns veículos terão.",
            function()
                fcommon.SingletonThread(fvehicle.TrafficNeons,"TrafficNeons")
            end)
            fcommon.CheckBoxVar("Nitro ilimitado",module.tvehicle.unlimited_nitro,"O Nitro será ativado ao clicar com o botão esquerdo.\nAtivar isso desativa: \n'Todos os carros e taxis tem nitro'.",
            function()
                fcommon.SingletonThread(module.UnlimitedNitro,"UnlimitedNitro")
            end)
            fcommon.CheckBoxVar("Watertight car",module.tvehicle.watertight_car,nil,
            function()
                if isCharInAnyCar(PLAYER_PED) then
                    local car = getCarCharIsUsing(PLAYER_PED)
                    setCarWatertight(car,module.tvehicle.watertight_car[0])
                end
            end)
            fcommon.CheckBoxValue("Apenas rodas",0x96914B)
    
            imgui.Columns(1)
        end
        if fcommon.BeginTabItem('Menus') then
            fcommon.DropDownMenu("Entrar no veículo mais próximo",function()
                local vehicle,ped = storeClosestEntities(PLAYER_PED)
                if vehicle ~= -1 then
                    local seats = getMaximumNumberOfPassengers(vehicle)
                    imgui.Spacing()
                    imgui.Columns(2,nil,false)
                    imgui.Text(casts.CModelInfo.GetNameFromModel(getCarModel(vehicle)))
                    imgui.NextColumn()
                    imgui.Text(string.format("Total de bancos: %d",seats+1))
                    imgui.Columns(1)

                    imgui.Spacing()
                    if imgui.Button("Motorista",imgui.ImVec2(fcommon.GetSize(2))) then
                        warpCharIntoCar(PLAYER_PED,vehicle)
                    end
                    for i=0,seats-1,1 do
                        if i%2 ~= 1 then
                            imgui.SameLine()
                        end
                        if imgui.Button("Passageiro " .. tostring(i+1),imgui.ImVec2(fcommon.GetSize(2))) then
                            warpCharIntoCarAsPassenger(PLAYER_PED,vehicle,i)
                        end
                    end
                else
                    imgui.Text("Não há veículos por perto")
                end
            end)
            fcommon.DropDownMenu("Texto da placa",function()
                imgui.InputText("Texto", module.tvehicle.license_plate_text,ffi.sizeof(module.tvehicle.license_plate_text))
                fcommon.InformationTooltip("Texto da placa do veículo\n criado pelo cheat menu.")
            end)

            fcommon.DropDownMenu("Opções de tráfego",function()
                fcommon.RadioButtonAddress("Cor",{"Preto","Rosa"},{0x969151,0x969150})
                imgui.Spacing()
                fcommon.RadioButtonAddress("Tipo",{"'Cheap'","Country","Rápido"},{0x96915E,0x96917B,0x96915F})
            end)

            if isCharInAnyCar(PLAYER_PED) then
                local car = getCarCharIsUsing(PLAYER_PED)
                local pCar = getCarPointer(car)
                local model = getCarModel(car)

                fcommon.UpdateAddress({name = 'Multiplicador de densidade',address = 0x8A5B20,size = 4,min = 0,max = 10, default = 1,is_float = true})
                fcommon.UpdateAddress({name = 'Nível de sujeira',address = pCar + 1200 ,size = 4,min = 0,max = 15, default = 7.5,is_float = true})
                fcommon.DropDownMenu("Portas",function()
                    if isCharInAnyCar(PLAYER_PED) and not (isCharOnAnyBike(PLAYER_PED) or isCharInAnyBoat(PLAYER_PED) 
                    or isCharInAnyHeli(PLAYER_PED) or isCharInAnyPlane(PLAYER_PED)) then    
                        imgui.Columns(2,nil,false)
                        imgui.RadioButtonIntPtr("Dano", module.tvehicle.door_menu_button,0) 
                        imgui.RadioButtonIntPtr("Corrigir", module.tvehicle.door_menu_button,1) 
                        imgui.NextColumn()
                        imgui.RadioButtonIntPtr("Abrir", module.tvehicle.door_menu_button,2) 
                        imgui.RadioButtonIntPtr("Soltar", module.tvehicle.door_menu_button,3)
                        imgui.Columns(1)

                        imgui.Spacing()

                        if module.tvehicle.door_menu_button[0] == 0 then
                            if module.tvehicle.visual_damage[0] == false then
                                DoorMenu(function(vehicle,door)
                                    damageCarDoor(vehicle,door)
                                end)
                            else
                                imgui.Text("Nenhum dano visual ativado")
                            end
                        end
                        if module.tvehicle.door_menu_button[0] == 1 then
                            DoorMenu(function(vehicle,door)
                                fixCarDoor(vehicle,door)
                            end)
                        end
                        if module.tvehicle.door_menu_button[0] == 2 then
                            DoorMenu(function(vehicle,door)
                                openCarDoor(vehicle,door)
                            end)
                        end
                        if module.tvehicle.door_menu_button[0] == 3 then
                            DoorMenu(function(vehicle,door)
                                popCarDoor(vehicle,door,true)
                            end)
                        end
                    else
                        imgui.Text("O jogador não está no carro")
                    end
                    
                end)
                fcommon.DropDownMenu("Definir nome",function()

                    imgui.Text(string.format( "Nome do carro = %s",casts.CModelInfo.GetNameFromModel(getCarModel(car))))
                    imgui.Spacing()
                    imgui.InputText("Nome", module.tvehicle.gxt_name,ffi.sizeof(module.tvehicle.gxt_name))

                    imgui.Spacing()
                    if imgui.Button("Definir",imgui.ImVec2(fcommon.GetSize(3))) then
                        setGxtEntry(casts.CModelInfo.GetNameFromModel(getCarModel(car)),ffi.string(module.tvehicle.gxt_name))
                        fcommon.CheatActivated()
                    end
                    imgui.SameLine()
                    if imgui.Button("Salvar",imgui.ImVec2(fcommon.GetSize(3))) then
                        mmodule.tvehicle.gxt_name_table[casts.CModelInfo.GetNameFromModel(getCarModel(car))] = ffi.string(module.tvehicle.gxt_name)
                    end
                    imgui.SameLine()
                    if imgui.Button("Limpar tudo",imgui.ImVec2(fcommon.GetSize(3))) then
                        module.tvehicle.gxt_name_table = {}
                    end
                end)
                fcommon.DropDownMenu("Definir velocidade",function()
                    
                    fcommon.CheckBoxVar("Bloquear velocidade",module.tvehicle.lock_speed)
                    imgui.Spacing()
                    imgui.InputInt("Definir",module.tvehicle.speed)
                     
                    imgui.Spacing()
                    if imgui.Button("Definir velocidade##brn",imgui.ImVec2(fcommon.GetSize(2))) then
                        if isCharInAnyCar(PLAYER_PED) then
                            car = getCarCharIsUsing(PLAYER_PED)
                            setCarForwardSpeed(car,module.tvehicle.speed[0])
                        end
                    end
                    imgui.SameLine()
                    if imgui.Button("Parada instantânea",imgui.ImVec2(fcommon.GetSize(2))) then
                        if isCharInAnyCar(PLAYER_PED) then
                            car = getCarCharIsUsing(PLAYER_PED)
                            setCarForwardSpeed(car,0.0)
                        end
                    end
                    if module.tvehicle.speed[0] > 500 then
                        module.tvehicle.speed[0] = 500
                    end
                    if module.tvehicle.speed[0] < 0 then
                        module.tvehicle.speed[0] = 0
                    end
                end)
                fcommon.UpdateAddress({name = 'Tamanho da roda',address = pCar+0x458,size = 4,min = 0,max = 10, default = 1,is_float = true})
                --fcommon.UpdateAddress({name = 'ZZZZZ',address = pCar+0x489,size = 4,min = -10,max = 10, default = 1,is_float = false})
            
            end    
        end
        if fcommon.BeginTabItem('Criar') then
            imgui.Columns(2,nil,false)
            fcommon.CheckBoxVar("Criar dentro do carro",module.tvehicle.spawn_inside,"Criar dentro do veículo como motorista.")

            imgui.NextColumn()
            fcommon.CheckBoxVar("Criar aeronaves no ar",module.tvehicle.aircraft.spawn_in_air)
            imgui.Columns(1)

            imgui.Dummy(imgui.ImVec2(0,10))   
            fcommon.DrawEntries(fconst.IDENTIFIER.VEHICLE,fconst.DRAW_TYPE.IMAGE,module.GiveVehicleToPlayer,nil,casts.CModelInfo.GetNameFromModel,module.tvehicle.images,fconst.VEHICLE.IMAGE_HEIGHT,fconst.VEHICLE.IMAGE_WIDTH)
        
        end
        if fcommon.BeginTabItem('Pintura') then
            if isCharInAnyCar(PLAYER_PED) then
                local car = getCarCharIsUsing(PLAYER_PED)
                local pveh = getCarPointer(car) 
                local model = getCarModel(car)
            
                if imgui.Button("Resetar cor",imgui.ImVec2(fcommon.GetSize(2))) then

                    module.ForEachCarComponent(function(mat,comp,car)
                        mat:reset_color()
                    end)
                    module.tvehicle.color.default = -1
                    printHelpString("Cor resetada!")
                end
                imgui.SameLine()
                if imgui.Button("Resetar textura",imgui.ImVec2(fcommon.GetSize(2))) then
                    fconfig.tconfig.temp_texture_name = nil
                    module.ForEachCarComponent(function(mat,comp,car)
                        mat:reset_texture()
                    end)
                    module.tvehicle.paintjobs.texture = nil
                    printHelpString("Textura resetada!")
                end

                imgui.Spacing()
                imgui.Columns(2,nil,false)
                fcommon.CheckBoxVar("Ativar salvamento",module.tvehicle.paintjobs.enable_saving,"Salve e carregue dados de pintura do veículo.\nAplica-se a todos os veículos deste modelo.",
                function()
                    if module.tvehicle.paintjobs.enable_saving[0] then
                        ApplyColor(true)
                    end
                end)
                fcommon.CheckBoxVar("Filtrar material",module.tvehicle.apply_material_filter,"Filtra o material ao aplicar cor/textura.\nDesative se algo não funcionar corretamente.")
                imgui.NextColumn()
                fcommon.CheckBoxVar("Cores aleatórias",module.tvehicle.rainbow_colors.bool,"Cores aleatórias no veículo do jogador.",function()
                    fcommon.SingletonThread(module.RainbowColors,"RainbowColors")
                end,
                function()
                    fcommon.CheckBoxVar("Aplicar no tráfego",module.tvehicle.rainbow_colors.traffic,"Cores aleatórias em veículos de trânsito.",
                    function()
                        fcommon.SingletonThread(module.RainbowColors,"RainbowColors")
                    end)
                    imgui.Dummy(imgui.ImVec2(0,20))
                    imgui.SliderFloat("Velocidade",module.tvehicle.rainbow_colors.speed,0,2)
                end)
                fcommon.CheckBoxVar("Neons aleatórios",module.tvehicle.rainbow_neons.bool,"Neons aleatórios no veículo do jogador.",function()
                    fcommon.SingletonThread(module.RainbowNeons,"RainbowNeons")
                end,
                function()
                    fcommon.CheckBoxVar("Aplicar no tráfego",module.tvehicle.rainbow_neons.traffic,"Neons aleatórios em veículos de trânsito.",
                    function()
                        fcommon.SingletonThread(module.RainbowNeons,"RainbowNeons")
                    end)
                    imgui.Dummy(imgui.ImVec2(0,20))
                    imgui.SliderFloat("Velocidade",module.tvehicle.rainbow_neons.speed,0,2)
                end)
                imgui.Columns(1)
                imgui.Spacing()
                
                if imgui.ColorEdit3("Cores",module.tvehicle.color.rgb) then
                    ApplyColor()
                end
                fcommon.ConfigPanel("Cor",function()
                    if not isCharInAnyCar(PLAYER_PED) then
                        tcheatmenu.window.panel_func = nil
                    end
                    fcommon.CheckBoxVar("Mostrar todas as cores", module.tvehicle.color.show_all)
                    imgui.Spacing()
                    
                    local name = casts.CModelInfo.GetNameFromModel(getCarModel(car))
                    
                    local shown_colors = {}
                    imgui.Text("Cores:")
                    imgui.Spacing()
                    imgui.Columns(2,nil,false)
                    imgui.RadioButtonIntPtr("Primeira", module.tvehicle.color.radio_btn, 1)
                    imgui.RadioButtonIntPtr("Segunda", module.tvehicle.color.radio_btn, 2)
                    imgui.NextColumn()
                    imgui.RadioButtonIntPtr("Terceira", module.tvehicle.color.radio_btn, 3)
                    imgui.RadioButtonIntPtr("Quarta", module.tvehicle.color.radio_btn, 4)
                    imgui.Spacing()
                    imgui.Columns(1)
                    imgui.Text("Selecionar cor predefinida:")
                    imgui.Spacing()

                    if imgui.BeginChild("Cores") then
                        local x,y = fcommon.GetSize(1)
                        local btns_in_row = math.floor(imgui.GetWindowContentRegionWidth()/(y*2))
                        local btn_size = (imgui.GetWindowContentRegionWidth() - imgui.StyleVar.ItemSpacing*(btns_in_row-0.75*btns_in_row))/btns_in_row
                        local btn_count = 1

                        func = function(v)
                            if not shown_colors[v] then
                                local t = {}
                                local k =  1
                                
                                for i in string.gmatch(module.tvehicle.color.col_data_table[v+1],"%w+") do 
                                    table.insert( t,tonumber(i))
                                end

                                if imgui.ColorButton("Cor " .. tostring(v),imgui.ImVec4(t[1]/255,t[2]/255,t[3]/255,255),0,imgui.ImVec2(btn_size,btn_size)) then
                                    writeMemory(getCarPointer(car) + 1075 + module.tvehicle.color.radio_btn[0],1,tonumber(v),false)
                                    module.ForEachCarComponent(function(mat,comp,car)
                                        mat:reset_color()
                                    end)
                                end
                                if imgui.IsItemHovered() then
                                    local drawlist = imgui.GetWindowDrawList()
                                    drawlist:AddRectFilled(imgui.GetItemRectMin(), imgui.GetItemRectMax(), imgui.GetColorU32(imgui.Col.ModalWindowDimBg))
                                end
                                shown_colors[v] = true
                                if btn_count % btns_in_row ~= 0 then
                                    imgui.SameLine(0.0,4.0)
                                end
                                btn_count = btn_count + 1
                            end
                        end

                        if module.tvehicle.color.show_all[0] then       
                            for v=0,(#module.tvehicle.color.col_data_table-1),1 do
                                func(v)
                            end
                        else
                            if module.tvehicle.color.car_data_table[name] ~= nil then
                                for k,v in ipairs(module.tvehicle.color.car_data_table[name]) do
                                    func(v)
                                end
                            end
                        end
                        imgui.EndChild()
                    end
                    
                end)

                imgui.Combo("Componente",module.tvehicle.components.selected,module.tvehicle.components.list,#module.tvehicle.components.names)
                
                if imgui.ColorEdit3("Neons",module.tvehicle.neon.rgb) then
                    InstallNeon(car,{module.tvehicle.neon.rgb[0]*255,module.tvehicle.neon.rgb[1]*255,module.tvehicle.neon.rgb[2]*255})
                end

                if module.tvehicle.paintjobs.paintjobs_count > 0 then
                    
                    if fcommon.HorizontalSelector("Paintjob",module.tvehicle.paintjobs.current_paintjob,
                    module.tvehicle.paintjobs.names) then
                        if module.tvehicle.paintjobs.current_paintjob[0] >= -1 and module.tvehicle.paintjobs.current_paintjob[0] <= module.tvehicle.paintjobs.paintjobs_count then
                            giveVehiclePaintjob(car,module.tvehicle.paintjobs.current_paintjob[0])
                              
                            if module.tvehicle.paintjobs.enable_saving[0] then
                                fconfig.Set(module.tvehicle.paintjobs.save_data,string.format("%d.paintjob",model),module.tvehicle.paintjobs.current_paintjob[0])
                            end
                        end
                    end
                end
                fcommon.DrawEntries(fconst.IDENTIFIER.PAINTJOB,fconst.DRAW_TYPE.IMAGE,ApplyTexture,nil,module.GetTextureName,module.tvehicle.paintjobs.images,fconst.VEHICLE.IMAGE_HEIGHT,fconst.VEHICLE.IMAGE_WIDTH)
            else
                imgui.TextWrapped("O jogador precisa estar dentro de um veículo para que as opções apareçam aqui.")
            end
        end
        if fcommon.BeginTabItem('Tunar') then
            if isCharInAnyCar(PLAYER_PED) then
                local car = getCarCharIsUsing(PLAYER_PED)
                local model = getCarModel(car)

                if imgui.Button("Resetar componentes do veículo",imgui.ImVec2(fcommon.GetSize(1))) then
                    for x=1,fconst.COMPONENT.TOTAL_SLOTS,1 do
                        local comp_model = getCurrentCarMod(car,x)

                        if comp_model ~= -1 then
                            module.RemoveComponentFromVehicle(comp_model,car,true)
                        end
                    end
                    printHelpString("Componentes do veiculo resetados!")
                end
                
                fcommon.CheckBoxVar("Ativar salvamento",module.tvehicle.components.enable_saving,"Salve e carregue ajustes de tunagem do veículo.\nAplica-se a todos os veículos deste modelo.",
                function()
                    if module.tvehicle.components.enable_saving[0] then
                        for tmodel,table in pairs(module.tvehicle.components.save_data) do
                            if tmodel == tostring(model) then
                                for _,component in ipairs(table) do
                                    module.AddComponentToVehicle(component,car,true)
                                end
                                break
                            end
                        end
                    end
                end)                
                imgui.Dummy(imgui.ImVec2(0,10))
                fcommon.DrawEntries(fconst.IDENTIFIER.COMPONENT,fconst.DRAW_TYPE.IMAGE,module.AddComponentToVehicle,
                function(component)
                    if imgui.MenuItemBool("Remover componente") then 
                        module.RemoveComponentFromVehicle(component)
                    end
                end,function(a) return a end,module.tvehicle.components.images,fconst.COMPONENT.IMAGE_HEIGHT,fconst.COMPONENT.IMAGE_WIDTH)
                
            else
                imgui.TextWrapped("O jogador precisa estar dentro de um veículo para que as opções apareçam aqui.")
            end
        end
        if fcommon.BeginTabItem('Handling') then
            if isCharInAnyCar(PLAYER_PED) then
                local car = getCarCharIsUsing(PLAYER_PED)
                local model = getCarModel(car)

                -------------------------------------------------------
                local phandling = readMemory((casts.CModelInfo.ms_modelInfoPtrs[model] + 0x4A),2,false) --m_nHandlingId
                phandling = phandling * 0xE0
                phandling = phandling + 0xC2B9DC

                if module.tvehicle.max_velocity_temp[0] == -1 then
                    local velocity = memory.getfloat(phandling + 0x84)
                    velocity = velocity*206 + (velocity-0.918668)*1501
                    module.tvehicle.max_velocity_temp[0] = velocity
                end

                if imgui.Button("Resetar handling",imgui.ImVec2(fcommon.GetSize(3))) then
                    local cHandlingDataMgr = readMemory(0x05BFA96,4,false)
                    callMethod(0x5BD830,cHandlingDataMgr,0,0)
                    printHelpString("Handling resetado!")
                end
                imgui.SameLine()
                if imgui.Button("Salvar arquivo",imgui.ImVec2(fcommon.GetSize(3))) then
                    local name = module.tvehicle.handling_name[model]
                    local fMass =  memory.getfloat(phandling + 0x4)
                    local fTurnMass = memory.getfloat(phandling + 0xC)
                    local fDragMult = memory.getfloat(phandling + 0x10)
                    local CentreOfMassX = memory.getfloat(phandling + 0x14)
                    local CentreOfMassY = memory.getfloat(phandling + 0x18)
                    local CentreOfMassZ = memory.getfloat(phandling + 0x1C)
                    local nPercentSubmerged = memory.read(phandling + 0x20,4)
                    local fTractionMultiplier = memory.getfloat(phandling + 0x28)
                    local fTractionLoss = memory.getfloat(phandling + 0xA4)
                    local TractionBias  = memory.getfloat(phandling + 0xA8)                     
                    local nNumberOfGears= memory.read(phandling + 0x76,1)    
                    local fMaxVelocity = module.tvehicle.max_velocity_temp[0] --memory.getfloat(phandling + 0x84)
                    --fMaxVelocity = fMaxVelocity*206 + (fMaxVelocity-0.918668)*1501
                    local fEngineAcceleration = memory.getfloat(phandling + 0x7C)*12500
                    local fEngineInertia = memory.getfloat(phandling + 0x80)	
                    local nDriveType = memory.tostring(phandling + 0x74,1)	
                    local nEngineType = memory.tostring(phandling + 0x75,1)			
                    local BrakeDeceleration = memory.getfloat(phandling + 0x94)*2500
                    local BrakeBias	= memory.getfloat(phandling + 0x98)	
                    local ABS = memory.read(phandling + 0x9C,1)    			
                    local SteeringLock = memory.getfloat(phandling + 0xA0)			
                    local SuspensionForceLevel = memory.getfloat(phandling + 0xAC)	
                    local SuspensionDampingLevel = memory.getfloat(phandling + 0xB0)		
                    local SuspensionHighSpdComDamp	= memory.getfloat(phandling + 0xB4)			
                    local Suspension_upper_limit = memory.getfloat(phandling + 0xB8)	
                    local Suspension_lower_limit = memory.getfloat(phandling + 0xBC)	
                    local Suspension_bias = memory.getfloat(phandling + 0xC0)	
                    local Suspension_anti_dive_multiplier = memory.getfloat(phandling + 0xC4)	
                    local fSeatOffsetDistance = memory.getfloat(phandling + 0xD4)	
                    local fCollisionDamageMultiplier = memory.getfloat(phandling + 0xC8)*0.338
                    local nMonetaryValue = memory.read(phandling + 0xD8,4)
                    local modelFlags = string.format('%x',memory.read(phandling + 0xCC,4))   	
                    local handlingFlags = string.format('%x',memory.read(phandling + 0xD0,4))   	
                    local front_lights = memory.read(phandling + 0xDC,1)   
                    local rear_lights = memory.read(phandling + 0xDD,1)   
                    local vehicle_anim_group = memory.read(phandling + 0xDE,1)  
 	

                    local file = io.open(getGameDirectory() .. "/handling.txt","a+")
                    local data = string.format("\n%s\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%d\t%d\t%.5g\t%.5g\t%s\t%s\t%.5g\t%.5g\t%d\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%.5g\t%d\t%s\t%s\t%d\t%d\t%d",
                    name,fMass,fTurnMass,fDragMult,CentreOfMassX,CentreOfMassY,CentreOfMassZ,nPercentSubmerged,fTractionMultiplier,fTractionLoss,TractionBias,nNumberOfGears,
                    fMaxVelocity,fEngineAcceleration,fEngineInertia,tostring(nDriveType),nEngineType,BrakeDeceleration,BrakeBias,ABS,SteeringLock,SuspensionForceLevel,SuspensionDampingLevel,
                    SuspensionHighSpdComDamp,Suspension_upper_limit,Suspension_lower_limit,Suspension_bias,Suspension_anti_dive_multiplier,fSeatOffsetDistance,
                    fCollisionDamageMultiplier,nMonetaryValue,tostring(modelFlags),tostring(handlingFlags),front_lights,rear_lights,vehicle_anim_group)
                    file:write(data)
                    file:close()
                    printHelpString("Dados salvos!")
                end
                imgui.SameLine()
                if imgui.Button("Sobre handling",imgui.ImVec2(fcommon.GetSize(3))) then
                    os.execute('explorer "https://projectcerbera.com/gta/sa/tutorials/handling"')
                end

                imgui.Spacing()
                if imgui.BeginChild("Handling") then
                    fcommon.RadioButtonAddressEx("ABS",{"Ligado","Desligado"},{1.0,0.0},phandling + 0x9C,false)
                    fcommon.UpdateAddress({name = 'Multiplicador anti-mergulho',address = phandling + 0xC4 ,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Viés de freio',address = phandling + 0x98 ,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Desaceleração do freio',address = phandling + 0x94 ,size = 4,min = 0.1,max = 20,is_float = true,mul = 2500,cvalue = 0.1, save = false})
                    fcommon.UpdateAddress({name = 'Centro da massa X',address = phandling + 0x14 ,size = 1,min = -10.0,max = 10.0,is_float = true,cvalue = 0.05, save = false})
                    fcommon.UpdateAddress({name = 'Centro da massa Y',address = phandling + 0x18 ,size = 1,min = -10.0,max = 10.0,is_float = true,cvalue = 0.05, save = false})
                    fcommon.UpdateAddress({name = 'Centro da massa Z',address = phandling + 0x1C ,size = 1,min = -10.0,max = 10.0,is_float = true,cvalue = 0.05, save = false})
                    fcommon.UpdateAddress({name = 'Multiplicador de danos por colisão',address = phandling + 0xC8,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01,mul = 0.3381, save = false})                    
                    fcommon.UpdateAddress({name = 'Nível de amortecimento',address = phandling + 0xB0 ,size = 4,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Drag mult',address = phandling + 0x10 ,size = 4,min = 0,max = 30.0,is_float = true, save = false})
                    fcommon.RadioButtonAddressEx("Tipo de direção",{"Tração dianteira","Tração Traseira","Tração nas quatro rodas"},{70,82,52},phandling + 0x74,false)
                    fcommon.UpdateAddress({name = 'Aceleração do motor',address = phandling + 0x7C ,size = 4,min = 0,max = 49,is_float = true,mul = 12500, save = false})
                    fcommon.UpdateAddress({name = 'Inércia do motor',address = phandling + 0x80 ,size = 4,min = 0,max = 400,is_float = true, save = false})
                    fcommon.RadioButtonAddressEx("Tipo de motor",{"Gasolina","Diesel","Elétrico"},{80,68,69},phandling + 0x75,false)
                    fcommon.RadioButtonAddressEx("Luzes dianteiras",{"Longa","Pequena","Grande"},{0,1,2,3},phandling + 0xDC,false)
                    fcommon.UpdateAddress({name = 'Nível de força',address = phandling + 0xAC ,size = 4,is_float = true,cvalue = 0.1, save = false})
                    fcommon.UpdateBits("Manipulação de sinalizadores",module.tvehicle.handling_flags,phandling + 0xD0,4)
                    fcommon.UpdateAddress({name = 'Amortecimento em alta velocidade',address = phandling + 0xB4 ,size = 4,is_float = true,cvalue = 0.1, save = false})
                    fcommon.UpdateAddress({name = 'Limite inferior',address = phandling + 0xBC ,size = 4,min = -1,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Massa',address = phandling + 0x4 ,size = 4,min = 1,max = 50000,is_float = true, save = false})
                    
                    -- fcommon.UpdateAddress({name = 'Max velocity',address = phandling + 0x84 ,size = 4,min = 0,max = 2,is_float = true,cvalue = 0.01 , save = false})
                    fcommon.DropDownMenu("Velocidade máxima",function()
                        imgui.Text("Info")
                        fcommon.InformationTooltip("Devido a um problema, quaisquer alterações feitas aqui não serão\naplicados no jogo. Você ainda pode gerar seu\
arquivo de dados com esses valores alterados aqui.")
                        imgui.Columns(2,nil,false)
                        imgui.Text("Mínimo= 0")
                        imgui.NextColumn()
                        imgui.Text("Máximo = 500")
                        imgui.Columns(1)
                        imgui.Spacing()
                
                        imgui.InputInt("Definir##MaxVelocity",module.tvehicle.max_velocity_temp)

                        if imgui.Button("Mínimo##MaxVelocity",imgui.ImVec2(fcommon.GetSize(3))) then
                            module.tvehicle.max_velocity_temp[0] = 0
                        end
            
                        imgui.SameLine()
                        if imgui.Button("Padrão##MaxVelocity",imgui.ImVec2(fcommon.GetSize(3))) then
                            local fMaxVelocity = memory.getfloat(phandling + 0x84)
                            fMaxVelocity = fMaxVelocity*206 + (fMaxVelocity-0.918668)*1501
                            module.tvehicle.max_velocity_temp[0] = math.floor(fMaxVelocity)
                        end
            
                        imgui.SameLine()
                        if imgui.Button("Mínimo##MaxVelocity",imgui.ImVec2(fcommon.GetSize(3))) then
                            module.tvehicle.max_velocity_temp[0] = 500
                        end

                        if module.tvehicle.max_velocity_temp[0] > 500 then
                            module.tvehicle.max_velocity_temp[0] = 500
                        end

                        if module.tvehicle.max_velocity_temp[0] < 0 then
                            module.tvehicle.max_velocity_temp[0] = 0
                        end
                    end)

                    fcommon.UpdateBits("Model flags",module.tvehicle.model_flags,phandling + 0xCC,4)
                    fcommon.UpdateAddress({name = 'Valor monetário',address = phandling + 0xD8 ,size = 4, save = false})
                    fcommon.UpdateAddress({name = 'Número de engrenagens',address = phandling + 0x76 ,size = 1,min = 1,max = 10, save = false})
                    fcommon.UpdateAddress({name = 'Porcentagem submersa',address = phandling + 0x20 ,size = 1,min = 10,max = 120, save = false})
                    fcommon.RadioButtonAddressEx("Luzes traseiras",{"Longa","Pequena","Grande","Alta"},{0,1,2,3},phandling + 0xDD,false)
                    fcommon.UpdateAddress({name = 'Distância do deslocamento do assento',address = phandling + 0xD4 ,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Trava de direção',address = phandling + 0xA0 ,size = 4,min = 10,max = 50,is_float = true, save = false})
                    fcommon.UpdateAddress({name = 'Viés de suspensão',address = phandling + 0xC0 ,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Tração de viés',address = phandling + 0xA8 ,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Perda de tração',address = phandling + 0xA4 ,size = 4,min = 0,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Multiplicador de tração',address = phandling + 0x28 ,size = 4,min = 0.5,max = 2,is_float = true,cvalue = 0.05, save = false})
                    fcommon.UpdateAddress({name = 'Virar massa',address = phandling + 0xC ,size = 4,min = 20,is_float = true, save = false})
                    fcommon.UpdateAddress({name = 'Limite superior',address = phandling + 0xB8 ,size = 4,min = -1,max = 1,is_float = true,cvalue = 0.01, save = false})
                    fcommon.UpdateAddress({name = 'Grupo de anim de veículo',address = phandling + 0xDE ,size = 1, save = false})
                    imgui.EndChild()
                end
            else
                imgui.TextWrapped("O jogador precisa estar dentro de um veículo para que as opções apareçam aqui.")
            end
        end
        fcommon.EndTabBar()
    end
end

return module
