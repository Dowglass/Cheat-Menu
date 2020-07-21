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

module.tteleport =
{
	coords                  = imgui.new.char[64](""),
	coordinates             = fcommon.LoadJson("coordinate"),
	coord_name              = imgui.new.char[64](""),
	filter                  = imgui.ImGuiTextFilter(),
    insert_coords           = imgui.new.bool(fconfig.Get('tteleport.insert_coords',false)),
	shortcut                = imgui.new.bool(fconfig.Get('tteleport.shortcut',false)),
}

-- Teleports player to a specified coordinates
function module.Teleport(x, y, z,interior_id)
	
	local target = false

	if x == nil and y == nil then
		target, x,y,z = getTargetBlipCoordinates()

		if not target then
			printHelpString("Nenhum marcador encontrado")
			return
		end
	end

	if math.abs(x) > 99999 or math.abs(y) > 99999 or math.abs(z) > 99999 then
		printHelpString("Coordenada muito alta")
		return
	end

	if interior_id == nil then
		interior_id = 0
	end
	
	lockPlayerControl(true)
	doFade(false,200)
	wait(200)

	setCharInterior(PLAYER_PED,interior_id)
	setInteriorVisible(interior_id)
	clearExtraColours(true)
	loadScene(x,y,z)
	requestCollision(x,y)
	activateInteriorPeds(true)

	if isCharInAnyCar(PLAYER_PED) then
		local car = getCarCharIsUsing(PLAYER_PED)
		setCarCoordinates(car,x,y,z)
	else
		setCharCoordinates(PLAYER_PED, x, y, z)
	end

	local timer = getGameTimer()
	
	if target or z == nil then
		while true do
			wait(0)
			local px,py = getCharCoordinates(PLAYER_PED)

			if isCharInAnyCar(PLAYER_PED) then
				local car = getCarCharIsUsing(PLAYER_PED)
				setCarCoordinates(car,x,y,-100)
			else
				setCharCoordinates(PLAYER_PED, x, y, -100)
			end

			if px == x and py == y then
				break
			end

			if getGameTimer() - timer > 500 then
				break
			end

		end
	end
	doFade(true,200)
	lockPlayerControl(false)
end

-- Main function
function module.TeleportMain()

	fcommon.Tabs("Teleporte",{"Teleporte","Procurar","Personalizar"},{
		function()
			imgui.Columns(2,nil,false)
			fcommon.CheckBoxVar("Inserir coordenadas",module.tteleport.insert_coords,"Mostra suas coordenadas atuais.")
			imgui.NextColumn()
			fcommon.CheckBoxVar("Quick teleport",module.tteleport.shortcut,"Teleporta para a marcação usando" ..  fcommon.GetHotKeyNames(tcheatmenu.hot_keys.quick_teleport))
			imgui.Columns(1)
			
			imgui.Spacing()

            imgui.InputText("Coordenada",module.tteleport.coords,ffi.sizeof(module.tteleport.coords))

            if module.tteleport.insert_coords[0] then
                local x,y,z = getCharCoordinates(PLAYER_PED)
                imgui.StrCopy(module.tteleport.coords,string.format("%d, %d, %d", math.floor(x) , math.floor(y) , math.floor(z)))
			end

			if (isKeyDown(vkeys.VK_LCONTROL) or isKeyDown(vkeys.VK_RCONTROL)) and isKeyDown(vkeys.VK_V) then
				imgui.StrCopy(module.tteleport.coords,getClipboardText())
			end
            fcommon.InformationTooltip("Insira coordenada XYZ.\nFormato : X,Y,Z")
            imgui.Dummy(imgui.ImVec2(0,10))

            if imgui.Button("Teleportar para coordenada",imgui.ImVec2(fcommon.GetSize(2))) then
				local x,y,z = (ffi.string(module.tteleport.coords)):match("([^,]+),([^,]+),([^,]+)")
				if tonumber(x) ~= nil and tonumber(y) ~= nil and tonumber(z) ~= nil then
					lua_thread.create(module.Teleport,x, y, z,0)
				else
					printHelpString("Nenhuma coordenada encontrada!")
				end
            end
            imgui.SameLine()
            if imgui.Button("Teleportar para marcação",imgui.ImVec2(fcommon.GetSize(2))) then
                lua_thread.create(module.Teleport)
            end
		end,
		function()
			fcommon.DrawEntries(fconst.IDENTIFIER.TELEPORT,fconst.DRAW_TYPE.TEXT,function(text)
				local interior_id, x, y, z = text:match("([^, ]+), ([^, ]+), ([^, ]+), ([^, ]+)")
				lua_thread.create(module.Teleport,x, y, z,interior_id)
			end,
			function(text)
				for category,table in pairs(module.tteleport.coordinates) do
					for key,val in pairs(table) do
						if key == text then
							module.tteleport.coordinates[category][key] = nil
							goto end_loop
						end
					end
				end
				::end_loop::

				fcommon.SaveJson("coordinate",module.tteleport.coordinates)
				module.tteleport.coordinates = fcommon.LoadJson("coordinate")
				printHelpString("Coordenada ~r~removida!")
			end,function(a) return a end,module.tteleport.coordinates)
		end,
		function()
			imgui.Columns(1)
			imgui.InputText("Nome do Local",module.tteleport.coord_name,ffi.sizeof(module.tteleport.coords))
			imgui.InputText("Coordenadas",module.tteleport.coords,ffi.sizeof(module.tteleport.coords))
			fcommon.InformationTooltip("Insira coordenadas XYZ.\nFormato : X, Y, Z")
			if module.tteleport.insert_coords[0] then
				local x,y,z = getCharCoordinates(PLAYER_PED)

                imgui.StrCopy(module.tteleport.coords,string.format("%d, %d, %d", math.floor(x) , math.floor(y) , math.floor(z)))
			end
			imgui.Spacing()
			if imgui.Button("Salvar local",imgui.ImVec2(fcommon.GetSize(1))) then
				if ffi.string(module.tteleport.coord_name) == "" then
					imgui.StrCopy(module.tteleport.coord_name,"Untitled")
				end
				module.tteleport.coordinates["Custom"][ffi.string(module.tteleport.coord_name)] = string.format("%d, %s",getCharActiveInterior(PLAYER_PED), ffi.string(module.tteleport.coords))
				fcommon.SaveJson("coordinate",module.tteleport.coordinates)
				module.tteleport.coordinates = fcommon.LoadJson("coordinate")
				printHelpString("Local ~g~adicionado!")
            end
		end
	})
end

return module
