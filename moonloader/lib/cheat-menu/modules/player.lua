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

module.tplayer =
{
    aimSkinChanger      = imgui.new.bool(fconfig.Get('tplayer.aimSkinChanger',false)),
    cjBody              = imgui.new.int(fconfig.Get('tplayer.cjBody',0)),
    clothes             = 
    { 
        images          = {},
        path            = tcheatmenu.dir .. "clothes\\",
    },
    custom_skins        =
    {
        filter          = imgui.ImGuiTextFilter(),
        is_modloader_installed = false,
        names           = {},
        path            = string.format("%s\\modloader\\Custom Skins",getGameDirectory())
    },
    filter              = imgui.ImGuiTextFilter(),
    god                 = imgui.new.bool(fconfig.Get('tplayer.god',false)),
    invisible           = imgui.new.bool(fconfig.Get('tplayer.invisible',false)),
    keep_position       = imgui.new.bool(fconfig.Get('tplayer.keep_position',false)),
    model_val           = nil,
    never_wanted        = imgui.new.bool(false),
}

function module.CustomSkinsSetup()
    local hmodloader = getModuleHandle("modloader.asi")
    if hmodloader ~= 0 then
        local dir = fplayer.tplayer.custom_skins.path

        module.tplayer.custom_skins.is_modloader_installed = true

        if not doesDirectoryExist(dir) then
            createDirectory(dir)
        end

        fcommon.IndexFiles(dir,fplayer.tplayer.custom_skins.names,"dff")

    end
end

function module.KeepPosition()
    while true do
        if isPlayerDead(PLAYER_HANDLE) and module.tplayer.keep_position[0] then
            local x,y,z = getCharCoordinates(PLAYER_PED)
            wait(1000)
            setCharCoordinates(PLAYER_PED,x,y,z)
        end
        wait(0)
    end
end

function module.ChangePlayerModel(model)

    local modeldff = (model .. ".dff")

    if fped.tped.names[model] ~= nil or fplayer.tplayer.custom_skins.names[modeldff] ~= nil then
        if fped.tped.special[model] == nil and fplayer.tplayer.custom_skins.names[modeldff] == nil then
            model = tonumber(model)
            if isModelAvailable(model) then
                requestModel(model)
                loadAllModelsNow()
                setPlayerModel(PLAYER_HANDLE,model)
                markModelAsNoLongerNeeded(model)
            end
        else
            if fped.tped.special[model] ~= nil then
                model = fped.tped.special[model]
            end

            loadSpecialCharacter(model,1)
            loadAllModelsNow()
            setPlayerModel(PLAYER_HANDLE,290)
            unloadSpecialCharacter(290)
        end
        
        local hveh = nil
        if isCharInAnyCar(PLAYER_PED) then
            hveh = getCarCharIsUsing(PLAYER_PED)
            speed = getCarSpeed(hveh)
        end
        clearCharTasksImmediately(PLAYER_PED)
        if hveh ~= nil then
            taskWarpCharIntoCarAsDriver(PLAYER_PED,hveh)
            setCarForwardSpeed(hveh,speed)
        end
        printHelpString("~g~Skin~w~ alterada")
    end
end

function WantedLevelMenu()
    
    fcommon.DropDownMenu("Nível de procurado",function()
        local  _,wl = storeWantedLevel(PLAYER_HANDLE)
        local wanted_level = imgui.new.int(wl)
        local max_wanted_level = imgui.new.int(readMemory(0x58DFE4,1,false))
        
        imgui.Columns(2,nil,false)
        imgui.Text("Mínimo" .. " = " .. tostring(0))
        imgui.NextColumn()
        imgui.Text("Máximo" .. " = " .. tostring(6))
        imgui.Columns(1)

        imgui.Spacing()

        imgui.PushItemWidth(imgui.GetWindowWidth()-50)

        if imgui.InputInt("Definir",wanted_level) then
            callFunction(0x4396F0,1,0,false)      
            alterWantedLevel(PLAYER_HANDLE,wanted_level[0])
        end
        imgui.PopItemWidth()
   
        imgui.Spacing()
        if imgui.Button("Mínimo",imgui.ImVec2(fcommon.GetSize(3))) then
            callFunction(0x4396F0,1,0,false)      
            alterWantedLevel(PLAYER_HANDLE,0)
        end
        imgui.SameLine()
        if imgui.Button("Padrão",imgui.ImVec2(fcommon.GetSize(3))) then
            callFunction(0x4396F0,1,0,false)      
            alterWantedLevel(PLAYER_HANDLE,0)
        end
        imgui.SameLine()
        if imgui.Button("Máximo",imgui.ImVec2(fcommon.GetSize(3))) then
            callFunction(0x4396F0,1,0,false)      
            alterWantedLevel(PLAYER_HANDLE,max_wanted_level[0])
        end
    end)
end

--------------------------------------------------
-- Cloth functions

function module.ChangePlayerCloth(name)
    local body_part, model, texture = name:match("([^$]+)$([^$]+)$([^$]+)")
    
    setPlayerModel(PLAYER_HANDLE,0)
    givePlayerClothesOutsideShop(PLAYER_HANDLE,0,0,body_part)
    givePlayerClothesOutsideShop(PLAYER_HANDLE,texture,model,body_part)
    buildPlayerModel(PLAYER_HANDLE)
    printHelpString("Roupa alterada!")
    local veh = nil
    local speed = 0
    if isCharInAnyCar(PLAYER_PED) then
        veh = getCarCharIsUsing(PLAYER_PED)
        speed = getCarSpeed(veh)
    end
    clearCharTasksImmediately(PLAYER_PED)
    if veh ~= nil then
        taskWarpCharIntoCarAsDriver(PLAYER_PED,veh)
        setCarForwardSpeed(veh,speed)
    end
end

function module.RemoveThisCloth(name)
    local body_part, model, texture = name:match("([^$]+)$([^$]+)$([^$]+)")
    givePlayerClothes(PLAYER_HANDLE,0,0,body_part)
    buildPlayerModel(PLAYER_HANDLE)
end
--------------------------------------------------

-- Main function
function module.PlayerMain()
    if imgui.Button("Suicidar",imgui.ImVec2(fcommon.GetSize(1))) then
        setCharHealth(PLAYER_PED,0)
    end
    imgui.Spacing()

    fcommon.Tabs("Jogador",{"Caixas de seleção","Menus","Skins","Roupas"},{
        function()
            imgui.Columns(2,nil,false)
            fcommon.CheckBoxValue("Mirar enquanto estiver dirigindo",0x969179)
            fcommon.CheckBoxVar("Modo Deus",module.tplayer.god)
            fcommon.CheckBoxValue("Recompensa na cabeça",0x96913F)
            fcommon.CheckBoxValue("Saltos mais altos do ciclo",0x969161)
            fcommon.CheckBoxValue("Munição infinita",0x969178)
            fcommon.CheckBoxValue("Oxigênio infinito",0x96916E)
            fcommon.CheckBoxValue("Corrida infinita",0xB7CEE4)
        
            imgui.NextColumn()

            fcommon.CheckBoxVar("Jogador invisível",module.tplayer.invisible,"O jogador não poderá entrar/sair do veículo.",
            function()
                if module.tplayer.invisible[0] then
                    module.tplayer.model_val = readMemory((getCharPointer(PLAYER_PED)+1140),4,false)
                    writeMemory(getCharPointer(PLAYER_PED)+1140,4,2,false)
                    fcommon.CheatActivated()
                else
                    writeMemory((getCharPointer(PLAYER_PED)+1140),4,fplayer.tplayer.model_val,false)
                    fcommon.CheatDeactivated()
                end
            end)
            fcommon.CheckBoxVar("Manter posição",module.tplayer.keep_position,"Teleporte automático para a posição em que você morreu.")
            fcommon.CheckBoxValue("Bloquear controle do jogador",getCharPointer(PLAYER_PED)+0x598)
            fcommon.CheckBoxValue("Super pulo",0x96916C)
            fcommon.CheckBoxValue("Super soco",0x969173)
            fcommon.CheckBoxValue("Nunca sentir fome",0x969174)

            module.tplayer.never_wanted[0] = readMemory(0x969171 ,1,false)
            fcommon.CheckBoxVar("Nunca ser procurado",module.tplayer.never_wanted,nil,
            function()
                callFunction(0x4396C0,1,0,false)
                if module.tplayer.never_wanted[0] then
                    fcommon.CheatActivated()
                else
                    fcommon.CheatDeactivated()
                end
                fconfig.Set(fconfig.tconfig.misc_data,"Never Wanted",module.tplayer.never_wanted[0])
            end)
           
            imgui.Columns(1)
        end,
        function()
            fcommon.UpdateAddress({name = "Colete",address = getCharPointer(PLAYER_PED)+0x548,size = 4,min = 0,default =0,max = 100, is_float = true})
            fcommon.DropDownMenu("Corpo",function()
                if imgui.RadioButtonIntPtr("Gordo",module.tplayer.cjBody,1) then
                    callFunction(0x439110,1,1,false)
                    fconfig.Set(fconfig.tconfig.misc_data,"Body",1)
                    fcommon.CheatActivated()
                end
                if imgui.RadioButtonIntPtr("Musculoso",module.tplayer.cjBody,2) then
                    -- body not changing to muscular after changing to fat fix
                    callFunction(0x439190,1,1,false)
                    callFunction(0x439150,1,1,false)
                    fconfig.Set(fconfig.tconfig.misc_data,"Body",2)
                    fcommon.CheatActivated()
                end
                if imgui.RadioButtonIntPtr("Magro",module.tplayer.cjBody,3) then
                    callFunction(0x439190,1,1,false)
                    fconfig.Set(fconfig.tconfig.misc_data,"Body",3)
                    fcommon.CheatActivated()
                end
            end)
            fcommon.UpdateStat({ name = "Energia",stat = 165})
            fcommon.UpdateStat({ name = "Gordura",stat = 21})
            fcommon.UpdateAddress({name = "Saúde",address = getCharPointer(PLAYER_PED)+0x540,size = 4,min = 0,default =100,max = 255, is_float = true})
            fcommon.UpdateStat({ name = "Capacidade pulmonar",stat = 225})
            fcommon.UpdateStat({ name = "Saúde máxima",stat = 24,min = 0,default = 569,max = 1450})
            fcommon.UpdateAddress({name = "Dinheiro",address = 0xB7CE50,size = 4,min = -9999999,max = 9999999})
            fcommon.UpdateStat({ name = "Músculo",stat = 23})
            fcommon.UpdateStat({ name = "Respeito",stat = 68,max = 2450}) 
            fcommon.UpdateStat({ name = "Stamina",stat = 22})
            
            WantedLevelMenu()
        end,
        function()
            fcommon.CheckBoxVar("Aim skin changer", module.tplayer.aimSkinChanger,"Comandos: Mire no ped +".. fcommon.GetHotKeyNames(tcheatmenu.hot_keys.asc_key))

            imgui.Spacing()
            fcommon.Tabs("Skins",{"Lista","Procurar","Personalizar"},{
                function()
                    fcommon.DrawImages(fconst.IDENTIFIER.PED,fconst.DRAW_TYPE.LIST,fped.tped.images,fconst.PED.IMAGE_HEIGHT,fconst.PED.IMAGE_WIDTH,module.ChangePlayerModel,nil,fped.GetModelName,module.tplayer.filter)
                end,
                function()
                    fcommon.DrawImages(fconst.IDENTIFIER.PED,fconst.DRAW_TYPE.SEARCH,fped.tped.images,fconst.PED.IMAGE_HEIGHT,fconst.PED.IMAGE_WIDTH,module.ChangePlayerModel,nil,fped.GetModelName,module.tplayer.filter)
                end,
                function()
                    if module.tplayer.custom_skins.is_modloader_installed then
                        module.tplayer.custom_skins.filter:Draw("Filtrar")
                        fcommon.InformationTooltip(string.format("Coloque os arquivos dff & txd dentro,\n'%s'\n\
Nota:\nOs nomes dos arquivos não podem exceder 8 caracteres.\nNão mude os nomes enquanto o jogo estiver em execução.",fplayer.tplayer.custom_skins.path))
                        imgui.Spacing()

                        if imgui.BeginChild("Skins personalizadas") then
                            for model_name,_ in pairs(fplayer.tplayer.custom_skins.names) do
                                if module.tplayer.custom_skins.filter:PassFilter(model_name) then
                                    model_name = string.sub(model_name,1,-5)
                                    if #model_name < 9 and imgui.MenuItemBool(model_name) then
                                        fplayer.ChangePlayerModel(model_name)
                                    end
                                end
                            end
                            imgui.EndChild()
                        end
                    else
                        if imgui.Button("Baixar Modloader",imgui.ImVec2(fcommon.GetSize(1))) then
                            os.execute('explorer "https://gtaforums.com/topic/669520-mod-loader/"')
                        end
                        imgui.Spacing()
                        imgui.TextWrapped("O Modloader não está instalado. Por favor, instale o modloader.")
                    end
                end
            })
        end,
        function()
            if imgui.Button("Remover roupas",imgui.ImVec2(fcommon.GetSize(1))) then
                for i=0, 17 do givePlayerClothes(PLAYER_HANDLE,0,0,i) end
                buildPlayerModel(PLAYER_HANDLE)
                printHelpString("Roupas ~r~removidas")
            end
            imgui.Text("Info")
            fcommon.InformationTooltip("Clique com o botão direito para adicionar \ne botão esquerdo para remover a roupa.")
            imgui.Spacing()          
            fcommon.DrawImages(fconst.IDENTIFIER.CLOTHES,fconst.DRAW_TYPE.LIST,module.tplayer.clothes.images,fconst.CLOTH.IMAGE_HEIGHT,fconst.CLOTH.IMAGE_WIDTH,module.ChangePlayerCloth,module.RemoveThisCloth)
        end
    })
end

return module
