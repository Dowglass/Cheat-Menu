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

module.tmission =
{
    array       = {},
    filter      = imgui.ImGuiTextFilter(),
    names       = fcommon.LoadJson("mission"),
}

-- Generating missions list from loaded json file
for id, name in pairs(module.tmission.names) do
    if name ~= "" then
        table.insert(module.tmission.array,tonumber(id))
    end
end

-- Display mission name as entry
function ShowMissionEntries(title,list,filter)

    fcommon.DropDownMenu(title,function()

        for _,i in pairs(list) do
            if filter == nil or filter:PassFilter(module.tmission.names[tostring(i)]) then
                if imgui.MenuItemBool(module.tmission.names[tostring(i)]) then
                    if getCharActiveInterior(PLAYER_PED) == 0 then
                        if getGameGlobal(glob.ONMISSION) == 0 then
                            lockPlayerControl(true)
                            doFade(true,1000)
                            clearWantedLevel(PLAYER_HANDLE)
                            loadAndLaunchMissionInternal(i)
                            lockPlayerControl(false)
                        else
                            printHelpString('Voce já esta em uma missao!')
                        end
                    else
                        printHelpString('Nao e possivel iniciar a missao dentro do interior!')
                    end
                end
            end
        end
    end)
end

-- Main function
function module.MissionMain()
    imgui.Spacing()

    if imgui.Button("Cancelar missão atual",imgui.ImVec2(fcommon.GetSize(1))) then
        if isPlayerControlOn(PLAYER_HANDLE) then
            failCurrentMission()
            fcommon.CheatActivated()
        end
    end
    fcommon.Tabs("Missões",{"LS","SF","LV","Desert","Back to LS","Outras","Procurar"},{
        function()
            ShowMissionEntries('Big smoke',{27,28,29,30})
            ShowMissionEntries('Cesar vialpando',{45})
            ShowMissionEntries('Frank tenpenny',{22,23,39})
            ShowMissionEntries('Introdução',{11,12})
            ShowMissionEntries('OG loc',{31,32,33,34})
            ShowMissionEntries('Robbery',{41,42,43,44})
            ShowMissionEntries('Ryder',{24,25,26})
            ShowMissionEntries('Sweet',{13,14,15,16,17,18,19,20,21,37,38})
            ShowMissionEntries('The truth',{46,47})
        end,
        function()
            ShowMissionEntries('Carl johnson',{49,50,51})
            ShowMissionEntries('Frank tenpenny',{52})
            ShowMissionEntries('Loco syndicate',{58,59,60,61,62,63,64,65,66})
            ShowMissionEntries('Wang cars',{67,68,69,70,71})
            ShowMissionEntries('WuZiMu',{53,54,55,56,57})
            ShowMissionEntries('Zero',{72,73,74})
        end,
        function()
            ShowMissionEntries('Caligulas casino',{89,90,91,92})
            ShowMissionEntries('Frank tenpenny',{93,94})
            ShowMissionEntries('Heist',{96,97,98,99,100,101})
            ShowMissionEntries('Madd dogg',{95})
            ShowMissionEntries('The four dragons casino',{84,85,86,87,88,102})
        end,
        function()
            ShowMissionEntries('Mike toreno',{75,76,77,78})
            ShowMissionEntries('Verdant meadows airstrip',{79,80,81,82,83})
        end,
        function()
            ShowMissionEntries('Carl johnson',{103,104,105})
            ShowMissionEntries('Riot',{108,109,110,111,112})
            ShowMissionEntries('Sweet',{106,107})
        end,
        function()
            ShowMissionEntries('Missões de Arena',{128,129,130})
            ShowMissionEntries('Miscellaneous',{117,118})
            ShowMissionEntries('Video games',{3,4,5,6,7,9,10})
        end,
        function()       
            module.tmission.filter:Draw("Filtrar")
            imgui.Spacing()

            if imgui.BeginChild("MissionsEntries") then
                ShowMissionEntries(nil,module.tmission.array,module.tmission.filter)
                imgui.EndChild()
            end
        end
    })
end
return module
