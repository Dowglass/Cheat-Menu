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

module.tmemory    =
{
    address            = imgui.new.char[10](""),
    filter             = imgui.ImGuiTextFilter(),
    offset             = imgui.new.char[10]("0"),
    is_float           = imgui.new.bool(fconfig.Get('tmemory.is_float',false)),
    list               = fcommon.LoadJson("memory"),
    name               = imgui.new.char[20](""),
    radio_button       = imgui.new.int(fconfig.Get('tmemory.radio_button',0)), 
    size               = imgui.new.int(fconfig.Get('tmemory.size',1)),
    value              = imgui.new.int(fconfig.Get('tmemory.value',0)),
    vp                 = imgui.new.bool(fconfig.Get('tmemory.vp',false)),
}

-- Main function
function module.MemoryMain()
 
    fcommon.OnHotKeyPress(tcheatmenu.hot_keys.mc_paste,function()
        imgui.StrCopy(module.tmemory.address, imgui.GetClipboardText(),ffi.sizeof(module.tmemory.address))
    end)

    fcommon.Tabs("Memória",{"Ler","Escrever","Procurar","Personalizar"},{
        function()
            imgui.Text("Ponto")
            imgui.SameLine()
            imgui.RadioButtonIntPtr("Nenhum", module.tmemory.radio_button, 0)
            imgui.SameLine()
            imgui.RadioButtonIntPtr("Carro", module.tmemory.radio_button, 1)
            fcommon.InformationTooltip("Obter ponto do carro mais próximo.")
            imgui.SameLine()
            imgui.RadioButtonIntPtr("Caractere", module.tmemory.radio_button, 2)
            fcommon.InformationTooltip("Obter ponto do caractere mais próximo.")
            imgui.Dummy(imgui.ImVec2(0,10))

            imgui.Columns(2,nil,false)
            imgui.Text("Valor da memória : " .. module.tmemory.value[0])
            imgui.NextColumn()

            local car,ped = storeClosestEntities(PLAYER_PED)

            if module.tmemory.radio_button[0] == fconst.MEMORY_RB.CAR then      
                if car ~= -1 then
                    local pCar = getCarPointer(car)
                    imgui.StrCopy(module.tmemory.address,string.format("0x%8.8X",pCar))
                end
            end
            if module.tmemory.radio_button[0] == fconst.MEMORY_RB.CHAR then
                
                if ped ~= -1 then
                    local pChar = getCharPointer(ped)
                    imgui.StrCopy(module.tmemory.address,string.format("0x%8.8X",pChar))
                end
            end
            imgui.Columns(1)
            imgui.Spacing()

            imgui.InputText("Endereço", module.tmemory.address,ffi.sizeof(module.tmemory.address))
            fcommon.InformationTooltip(fcommon.GetHotKeyNames(tcheatmenu.hot_keys.mc_paste) .. " para colar")
            imgui.InputText("Offset", module.tmemory.offset,ffi.sizeof(module.tmemory.offset))

            fcommon.InformationTooltip("Blank = no offset")
            imgui.SliderInt("Tamanho", module.tmemory.size,1,4)

            if module.tmemory.size[0] == 4 then
                imgui.Columns(2,nil,false)
                imgui.Checkbox("Float",module.tmemory.is_float)
                imgui.NextColumn()
            else
                imgui.Columns(1,nil,false)
            end


            imgui.Checkbox("Proteção Virtual", module.tmemory.vp)
            imgui.Columns(1)
            imgui.Dummy(imgui.ImVec2(0,10))
            if imgui.Button("Ler",imgui.ImVec2(fcommon.GetSize(2))) then

                if ffi.string(module.tmemory.offset) == "" then 
                    imgui.StrCopy(module.tmemory.offset,"0") 
                end

                if ffi.string(module.tmemory.address) ~= "" then
                    module.tmemory.value[0] = fcommon.RwMemory((tonumber(ffi.string(module.tmemory.address))+tonumber(ffi.string(module.tmemory.offset))),module.tmemory.size[0],nil,module.tmemory.vp[0],module.tmemory.is_float[0])
                end
            end
            imgui.SameLine()
            if imgui.Button("Limpar",imgui.ImVec2(fcommon.GetSize(2))) then
                module.tmemory.value[0] = 0
                imgui.StrCopy(module.tmemory.address,"")
                imgui.StrCopy(module.tmemory.offset,"0")
                module.tmemory.size[0] = 0
                module.tmemory.vp[0] = false
                module.tmemory.is_float[0] = false
                module.tmemory.radio_button[0] = 0
                printHelpString("Entradas limpas")
            end
        end,
        function()
            imgui.Text("Ponto")
            imgui.SameLine()
            imgui.RadioButtonIntPtr("Nenhum", module.tmemory.radio_button, 0)
            imgui.SameLine()
            imgui.RadioButtonIntPtr("Carro", module.tmemory.radio_button, 1)
            fcommon.InformationTooltip("Obtem ponto do carro mais próximo.")
            imgui.SameLine()
            imgui.RadioButtonIntPtr("Caractere", module.tmemory.radio_button, 2)
            fcommon.InformationTooltip("Obtem ponto do caractere mais próximo.")
            imgui.Dummy(imgui.ImVec2(0,10))

            local car,ped = storeClosestEntities(PLAYER_PED)

            if module.tmemory.radio_button[0] == fconst.MEMORY_RB.CAR then      
                if car ~= -1 then
                    local pCar = getCarPointer(car)
                    imgui.StrCopy(module.tmemory.address,string.format("0x%8.8X",pCar))
                end
            end
            if module.tmemory.radio_button[0] == fconst.MEMORY_RB.CHAR then
                
                if ped ~= -1 then
                    local pChar = getCharPointer(ped)
                    imgui.StrCopy(module.tmemory.address,string.format("0x%8.8X",pChar))
                end
            end
            
            imgui.InputInt("Valor", module.tmemory.value)
            imgui.InputText("Endereço", module.tmemory.address,ffi.sizeof(module.tmemory.address))
            fcommon.InformationTooltip(fcommon.GetHotKeyNames(tcheatmenu.hot_keys.mc_paste) .. " para colar")
            imgui.InputText("Offset", module.tmemory.offset,ffi.sizeof(module.tmemory.offset))
            fcommon.InformationTooltip("Blank = no offset")
            imgui.SliderInt("Tamanho", module.tmemory.size,1,4)

            if module.tmemory.size[0] == 4 then
                imgui.Columns(2,nil,false)
                imgui.Checkbox("Float",module.tmemory.is_float)
                imgui.NextColumn()
            else
                imgui.Columns(1,nil,false)
            end


            imgui.Checkbox("Proteção Virtual", module.tmemory.vp)
            imgui.Columns(1)
            imgui.Dummy(imgui.ImVec2(0,10))

            if imgui.Button("Escrever",imgui.ImVec2(fcommon.GetSize(2))) then
                
                if ffi.string(module.tmemory.offset) == "" then 
                    imgui.StrCopy(module.tmemory.offset,"0") 
                end

                if ffi.string(module.tmemory.address) ~= "" then
                    fcommon.RwMemory(tonumber(ffi.string(module.tmemory.address))+tonumber(ffi.string(module.tmemory.offset)),module.tmemory.size[0],module.tmemory.value[0],module.tmemory.vp[0],module.tmemory.is_float[0])
                    printHelpString("Valor ~g~Atualizado")
                end
            end
            imgui.SameLine()
            if imgui.Button("Limpar",imgui.ImVec2(fcommon.GetSize(2))) then
                module.tmemory.value[0] = 0
                imgui.StrCopy(module.tmemory.address,"")
                imgui.StrCopy(module.tmemory.offset,"0")
                module.tmemory.size[0] = 0
                module.tmemory.vp[0] = false
                module.tmemory.is_float[0] = false
                module.tmemory.radio_button[0] = 0
                printHelpString("Entradas limpas")
            end
        end,
        function()

            fcommon.DrawEntries(fconst.IDENTIFIER.MEMORY,fconst.DRAW_TYPE.TEXT,
                function(address,size)
                    imgui.StrCopy(module.tmemory.address,address)
                    imgui.StrCopy(module.tmemory.offset,"0")
                    if size == "byte" then 
                        module.tmemory.size[0] = 1
                        module.tmemory.is_float[0] = false
                    end
                    if size == "word" then 
                        module.tmemory.size[0] = 2
                        module.tmemory.is_float[0] = false
                    end
                    if size == "dword" then 
                        module.tmemory.size[0] = 4
                        module.tmemory.is_float[0] = false
                    end
                    if size == "float" then 
                        module.tmemory.size[0] = 4
                        module.tmemory.is_float[0] = true
                    end
                    printHelpString("Endereco definido!")
                end,
                function(text)
                    for category,table in pairs(module.tmemory.list) do
                        for key,val in pairs(table) do
                            if key == text then
                                module.tmemory.list[category][key] = nil
                                goto end_loop
                            end
                        end
                    end
                    ::end_loop::

                    fcommon.SaveJson("memory",module.tmemory.list)
                    module.tmemory.list = fcommon.LoadJson("memory")
                    printHelpString("Memoria ~r~removida")
                end,
                function(a) return a end,module.tmemory.list)
        end,
        function()
            imgui.InputText("Nome",module.tmemory.name,ffi.sizeof(module.tmemory.name))
            imgui.InputText("Endereço",module.tmemory.address,ffi.sizeof(module.tmemory.address))
            imgui.SliderInt("Tamanho", module.tmemory.size,1,4)
            imgui.Checkbox("Float",module.tmemory.is_float)
            imgui.Spacing()
            if imgui.Button("Adicionar endereço",imgui.ImVec2(fcommon.GetSize(1))) then

                local mem_type = ""
                if module.tmemory.size[0] == 1 then 
                    mem_type = "byte"
                end
                if module.tmemory.size[0] == 2 then 
                    mem_type = "word"
                end
                if module.tmemory.size[0] == 4 then 
                    if module.tmemory.is_float[0] == true then
                        mem_type = "float"
                    else
                        mem_type = "dword"
                    end
                end
                
                module.tmemory.list[mem_type][ffi.string(module.tmemory.name)] = mem_type .. "$" .. ffi.string(module.tmemory.address)
                fcommon.SaveJson("memory",module.tmemory.list)
                module.tmemory.list = fcommon.LoadJson("memory")
                printHelpString("Endereco ~g~adicionado")
            end
        end})
end

return module
