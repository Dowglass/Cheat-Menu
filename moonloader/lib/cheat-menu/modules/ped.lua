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

module.tped =
{
    gang =
    {
        is_exgangwars_installed = false,
        index = imgui.new.int(0),
        list = 
        {
            "Ballas",
            "Grove street families",
            "Los santos vagos",
            "San fierro rifa",
            "Da nang boys",
            "Mafia",
            "Mountain cloud triad",
            "Varrio los aztecas",
            "Gang9",
            "Gang10",
        },
        names = 
        {   
            ["Ballas"] = 0,
            ["Da nang boys"] = 4,
            ["Gang9"] = 8,
            ["Gang10"] = 9,
            ["Grove street families"] = 1,
            ["Los santos vagos"] = 2,
            ["Mafia"] = 5,
            ["Mountain cloud triad"] = 6,
            ["San fierro rifa"] = 3,
            ["Varrio los aztecas"] = 7,
        },  
        wars = imgui.new.bool(fconfig.Get('tped.gang.wars',false)),
    },
    images      = {},
    names       = fcommon.LoadJson("ped"),
    path        = tcheatmenu.dir .. "peds\\",
    ped_health_display = imgui.new.bool(fconfig.Get('tped.ped_health_display',false)),
    selected    = nil,
    spawned_peds= 
    {
        list = {},
    },
    special     = fcommon.LoadJson("ped special"),
}

module.tped.gang.array = imgui.new['const char*'][#module.tped.gang.list](module.tped.gang.list)

if getModuleHandle("ExGangWars.asi") ~= 0 then
    module.tped.gang.is_exgangwars_installed = true
end

-- Returns ped name
function module.GetModelName(model)
    if module.tped.names[model] then 
        return module.tped.names[model] 
    else 
        return "" 
    end
end

function module.SpawnPed(model)  
 
    if  module.tped.names[model] ~= nil then
        if module.tped.special[model] == nil then
            model = tonumber(model)
            requestModel(model)
            loadAllModelsNow()
            x,y,z = getCharCoordinates(PLAYER_PED)
            ped = createChar(5,model,x,y,z) -- CIVMALE
            markModelAsNoLongerNeeded(model)
            module.tped.spawned_peds.list[ped] = tostring(getCharModel(ped))
        else
            if hasSpecialCharacterLoaded(model) then
                unloadSpecialCharacter(model)
            end
            loadSpecialCharacter(module.tped.special[tostring(model)],1)
            loadAllModelsNow()
            x,y,z = getCharCoordinates(PLAYER_PED)
            ped = createChar(5,290,x,y,z) -- CIVMALE
            module.tped.spawned_peds.list[ped] = tostring(getCharModel(ped))
            markModelAsNoLongerNeeded(module.tped.special[tostring(model)])
        end
        printHelpString("Ped ~g~Criado!")
    end
end

function module.PedHealthDisplay()
    while module.tped.ped_health_display[0] do
        local result, char = getCharPlayerIsTargeting(PLAYER_HANDLE)

        if result then

            local health = getCharHealth(char)
            local x,y,z = getCharCoordinates(char)
            local screenX,screenY = convert3DCoordsToScreen(x,y,z+1.0)
            mad.draw_text(tostring(health),screenX,screenY,1,0.8,0.4,0,false,false,false,255,255,255,255,false)

        end
        wait(0)
    end

end

function module.RemoveAllSpawnedPeds()
    for ped,model in pairs(module.tped.spawned_peds.list) do
        removeCharElegantly(ped)
        module.tped.spawned_peds.list[ped] = nil
    end
end

function GetLargestGangInZone()
    local gang = 0
    local density = 0

    for title,id in pairs(module.tped.gang.names) do

        local x,y,z = getCharCoordinates(PLAYER_PED)

        local gang_desity = getZoneGangStrength(getNameOfInfoZone(x,y,z),id)
       
        if gang_desity > density then
            density = gang_desity
            gang = id
        end
    end
    return gang
end

function module.PedMain()

    if fcommon.BeginTabBar('Ped') then
        if fcommon.BeginTabItem('Caixas de seleção') then
            imgui.Columns(2,nil,false)
            fcommon.CheckBoxVar("Exibir saúde do ped",module.tped.ped_health_display,nil,
            function()
                fcommon.SingletonThread(module.PedHealthDisplay,"PedHealthDisplay")
            end)
            fcommon.CheckBoxValue("Elvis em toda parte",0x969157)
            fcommon.CheckBoxValue("Todo mundo armado",0x969140)
            fcommon.CheckBoxValue("Gangues controlam ruas",0x96915B)
            fcommon.CheckBoxValue("Gangues em todos os lugares",0x96915A)
            fcommon.CheckBoxVar("Zona de gangues",module.tped.gang.wars,nil,
            function()
                setGangWarsActive(module.tped.gang.wars[0])
                if module.tped.gang.wars[0] then fcommon.CheatActivated() else fcommon.CheatDeactivated() end
            end,
            function()
                if imgui.Button("Iniciar gerra de gangues",imgui.ImVec2(fcommon.GetSize(2))) then
                    if GetLargestGangInZone() == 1 then
                        callFunction(0x444300,0,0) -- defensive gang war
                    else
                        callFunction(0x446050,0,0) -- offensive gang war
                    end
                    setGangWarsActive(true)
                end   
                imgui.SameLine()
                if imgui.Button("Finalizar guerra de gangues",imgui.ImVec2(fcommon.GetSize(2))) then
                    callFunction(0x4464C0,0,0)
                    setGangWarsActive(true)
                end      
                
                imgui.Dummy(imgui.ImVec2(0,20))
                imgui.TextWrapped("Densidade da zona de gangue:")
                imgui.Spacing()
                for title,id in pairs(module.tped.gang.names) do

                    local x,y,z = getCharCoordinates(PLAYER_PED)
    
                    local density = imgui.new.int(getZoneGangStrength(getNameOfInfoZone(x,y,z),id))
                    imgui.PushItemWidth(imgui.GetWindowWidth()/2)
                    if imgui.SliderInt(title,density,0,255) then
                        setZoneGangStrength(getNameOfInfoZone(x,y,z),id,density[0])
                        clearSpecificZonesToTriggerGangWar()
                    end
                end
                imgui.PopItemWidth()
                imgui.Dummy(imgui.ImVec2(0,20))
                if not module.tped.gang.is_exgangwars_installed then
                    imgui.TextWrapped("Você precisará do ExGangWars para exibir algumas cores de gangue")
                    imgui.Spacing()
                    if imgui.Button("Baixar ExGangWars",imgui.ImVec2(fcommon.GetSize(1))) then
                        os.execute('explorer "https://gtaforums.com/topic/682194-extended-gang-wars/"')
                    end
                end
            end)
            
            imgui.NextColumn()

            fcommon.CheckBoxValue("Sem peds nas ruas",0x8D2538,nil,0,25)
            fcommon.CheckBoxValue("Peds se atacam (caos)",0x96913E)
            fcommon.CheckBoxValue("Peds atacam com RPG",0x969158)
            fcommon.CheckBoxValue("Motim de Peds",0x969175)
            fcommon.CheckBoxValue("Ímã de prostituta",0x96915D)
            
            imgui.Columns(1)
            imgui.Spacing()
        end
        if fcommon.BeginTabItem('Menus') then
            fcommon.UpdateAddress({name = 'Multiplicador de densidade de pedestres',address = 0x8D2530,size = 4,min = 0,max = 10, default = 1,is_float = true})
            fcommon.DropDownMenu("Recrutar qualquer ped",function()
                fcommon.RadioButtonAddress("Selecionar arma",{"9mm","AK47","Rockets"},{0x96917C,0x96917D,0x96917E})
            end)
        end
        if fcommon.BeginTabItem('Criar') then
            if imgui.Button("Remover todos os peds criados",imgui.ImVec2(fcommon.GetSize(1))) then
                module.RemoveAllSpawnedPeds()  
                printHelpString("Peds removidos")        
            end
            
            imgui.Dummy(imgui.ImVec2(0,10))                
            fcommon.DrawEntries(fconst.IDENTIFIER.PED,fconst.DRAW_TYPE.IMAGE,module.SpawnPed,nil,module.GetModelName,module.tped.images,fconst.PED.IMAGE_HEIGHT,fconst.PED.IMAGE_WIDTH)
        end
        fcommon.EndTabBar()
    end
end
return module
