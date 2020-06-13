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

module.tmenu =
{	
	auto_update_check   = imgui.new.bool(fconfig.Get('tmenu.auto_update_check',true)),
	auto_reload 		= imgui.new.bool(fconfig.Get('tmenu.auto_reload',true)),
	command             = 
	{
		filter          = imgui.ImGuiTextFilter(),
		height          = 40,
		input_field     = imgui.new.char[256](),
		list            = {},
		show            = imgui.new.bool(false),
	},
	crash_text          = "",
	draw_text_only      = imgui.new.bool(fconfig.Get('tmenu.draw_text_only',false)),
	fast_load_images    = imgui.new.bool(fconfig.Get('tmenu.fast_load_images',false)),
	lock_player   		= imgui.new.bool(fconfig.Get('tmenu.lock_player',false)),
	overlay             = 
	{
		coordinates     = imgui.new.bool(fconfig.Get('tmenu.overlay.coordinates',false)),
		fps             = imgui.new.bool(fconfig.Get('tmenu.overlay.fps',false)),
		show            = imgui.new.bool(true),
		location    	= imgui.new.bool(fconfig.Get('tmenu.overlay.location',false)),
		offset          = imgui.new.int(10),
    	position        = {"Customizar","Superior esquerdo","Superior direito","Inferior esquerdo","Inferior direito"},
    	position_array  = {},
		position_index  = imgui.new.int(fconfig.Get('tmenu.overlay.position_index',4)),
		health          = imgui.new.bool(fconfig.Get('tmenu.overlay.health',false)),
		pos_x           = imgui.new.int(fconfig.Get('tmenu.overlay.pos_x',0)),
		pos_y           = imgui.new.int(fconfig.Get('tmenu.overlay.pos_y',0)),
		speed           = imgui.new.bool(fconfig.Get('tmenu.overlay.speed',false)),		
	},
	repo_version        = nil,
	show_tooltips	    = imgui.new.bool(fconfig.Get('tmenu.show_tooltips',true)),
	show_crash_message  = imgui.new.bool(fconfig.Get('tmenu.show_crash_message',true)),
	update_status       = fconst.UPDATE_STATUS.HIDE_MSG,
}

module.tmenu.overlay.position_array = imgui.new['const char*'][#module.tmenu.overlay.position](module.tmenu.overlay.position)

--------------------------------------------------
-- Command window

function module.FindArgument(t,string)
    for k,v in ipairs(t) do
        if v == string then
            return true
        end
    end
    return false
end

function module.RegisterCommand(string,call_back_func,desc,usage)
    module.tmenu.command.list[string] = {call_back_func,desc,usage}
end

function module.ExecuteCommand()

    local string = ffi.string(module.tmenu.command.input_field)
	local t = {}
	
    for w in string:gmatch("%S+") do 
        table.insert(t,w)
	end
	
	for v,k in pairs(module.tmenu.command.list) do
        if v == t[1] then
            k[1](t)
            return
        end
	end
end

function module.RegisterAllCommands()

	module.RegisterCommand("reload",function(t)
		thisScript():reload()
	end,"Recarrega o cheat menu")

	module.RegisterCommand("reloadall",function(t)
		reloadScripts()
	end,"Recarrega todos scripts no moonloader")

	module.RegisterCommand("tp",function(t)
        if t[4] == nil then t[4] = getGroundZFor3dCoord(x,y,100) end
		lua_thread.create(fteleport.Teleport,tonumber(t[2]),tonumber(t[3]),tonumber(t[4]))
	end,"Teleporta para a coordenada","{X} {Y} {Z}(opcional)")
	
	module.RegisterCommand("settime",function(t)
        setTimeOfDay(t[2],t[3])
        printHelpString("Horario definido as")
	end,"Define o horário no jogo","{hora} {minuto}")
	
	module.RegisterCommand("cheatmenu",function(t)
        tcheatmenu.window.show[0] = not tcheatmenu.window.show[0]
    end,"Abre ou fecha o cheat menu")

    module.RegisterCommand("sethealth",function(t)
       setCharHealth(PLAYER_PED,tonumber(t[2]))
       printHelpString("Saude definida como " .. t[2])
	end,"Define o valor da saúde do jogador","{valor}")
	
    module.RegisterCommand("setmaxhealth",function(t)
        setCharMaxHealth(PLAYER_PED,tonumber(t[2]))
        printHelpString("Saude maxima definida como " .. t[2])
	end,"Define o valor máximo de vida do jogador","{saúde_max}")
	
    module.RegisterCommand("copycoordinates",function(t)
        local x,y,z = getCharCoordinates(PLAYER_PED)
        setClipboardText(string.format("%s %s %s",math.floor(x),math.floor(y),math.floor(z)))
        printHelpString("Coordenadas copiadas para a area de transferencia")
    end,"Copia coordenadas para a área de transferência")

    module.RegisterCommand("setcarspeed",function(t)
        if isCharInAnyCar(PLAYER_PED) then
            local car = getCarCharIsUsing(PLAYER_PED)
            setCarForwardSpeed(car,tonumber(t[2]))
            printHelpString("Velocidade do carro definida como " ..t[2])
        else
            printHelpString("O jogador nao esta no carro")
        end
    end,"Define a velocidade do veículo","{velocidade}")

    module.RegisterCommand("restorecam",function(t)
        restoreCamera()
	end,"Restaura a câmera padrão")

	module.RegisterCommand("cameramode",function(t)
        fgame.tgame.camera.bool[0] = not fgame.tgame.camera.bool[0]
	end,"Ativa ou desativa o modo câmera")
	
	module.RegisterCommand("veh",function(t)
		if t[2] == nil then 
			printHelpString("Nenhum nome de veiculo fornecido") 
			return 
		end

		local model = tonumber(t[2])

        if type(model) == "nil" then
			model = fvehicle.GetModelInfo(string.upper(t[2])) 

			if model ~= 0 and isModelAvailable(model) then  
				if isThisModelABoat(model) 
				or isThisModelACar(model)
				or isThisModelAHeli(model)
				or isThisModelAPlane(model) then
					fvehicle.GiveVehicleToPlayer(model)
				else
					printHelpString("Isso nao e um modelo de veiculo!")
				end
			else
				printHelpString("Nome de veiculo invalido!")
			end
		end
		

	end,"Criar veículo","{nome do veículo}")

    module.RegisterCommand("wep",function(t)
		if t[2] == nil then 
			printHelpString("Nenhum nome de arma fornecido") 
			return 
		end

        local model = tonumber(t[2])

        if type(model) == "nil" then
            model = fweapon.CBaseWeaponInfo(string.upper(t[2]))  
            if model == 0 then  
                printHelpString("Nome de arma invalido!")
                return
            end
			t[2] = model
			fweapon.GiveWeapon(t[2])
        end
    end,"Criar arma","{nome da arma}")
end
--------------------------------------------------

function module.httpRequest(request, body, handler) -- copas.http
    -- start polling task
    if not copas.running then
        copas.running = true
        lua_thread.create(function()
            wait(0)
            while not copas.finished() do
                local ok, err = copas.step(0)
                if ok == nil then error(err) end
                wait(0)
            end
            copas.running = false
        end)
    end
    -- do request
    if handler then
        return copas.addthread(function(r, b, h)
            copas.setErrorHandler(function(err) h(nil, err) end)
            h(http.request(r, b))
        end, request, body, handler)
    else
        local results
        local thread = copas.addthread(function(r, b)
            copas.setErrorHandler(function(err) results = {nil, err} end)
            results = table.pack(http.request(r, b))
        end, request, body)
        while coroutine.status(thread) ~= 'dead' do wait(0) end
        return table.unpack(results)
    end
end

function module.GetPlayerLocation()
	local interior = getActiveInterior() 

	local town_name = "San Andreas"
	local city =  getCityPlayerIsIn(PLAYER_PED)

	if city == 0 then
		town_name = "CS"
	end
	if city == 1 then
		town_name = "LS"
	end
	if city == 2 then
		town_name = "SF"
	end
	if city == 3 then
		town_name = "LV"
	end

	if interior == 0 then

		local x,y,z = getCharCoordinates(PLAYER_PED)
		local zone_name = getGxtText(getNameOfZone(x,y,z))

		return string.format("Localização: %s, %s",zone_name,town_name)
	else
		return string.format("Localização: Interior %d, %s",getCharActiveInterior(PLAYER_PED),town_name)
	end
end

function module.CheckUpdates()
	if string.find( script.this.version,"beta") then
		link = "https://raw.githubusercontent.com/Dowglass/Cheat-Menu/master/moonloader/cheat-menu.lua"
	else
		link = "https://api.github.com/repos/Dowglass/Cheat-Menu/tags"
	end

	module.httpRequest(link, nil, function(body, code, headers, status)
		if body then
			print(link, 'OK', status)
			if string.find( script.this.version,"beta") then
				repo_version = body:match("script_version_number%((%d+)%)")
				this_version = script.this.version_num
			else
				repo_version = decodeJson(body)[1].name
				this_version = script.this.version
			end

			if  repo_version ~= nil then
				if tostring(repo_version) > tostring(this_version) then
					module.tmenu.update_status = fconst.UPDATE_STATUS.NEW_UPDATE
					printHelpString("Nova atualizacao disponivel!")
				else
					printHelpString("Nenhuma atualizacao disponivel")
				end
			else
				printHelpString("Nao foi possivel conectar ao github. O restante do menu ainda esta funcional. Voce pode desativar a verificacao de atualizacao automatica em 'Menu'.")
			end
		else
			print(link, 'Erro', code)
		end
	end)
end

function module.DownloadHandler(id, status, p1, p2)
	print("Status da atualizacao: " .. status)
	if status == fconst.UPDATE_STATUS.INSTALL then
		fmenu.tmenu.update_status = fconst.UPDATE_STATUS.INSTALL
		printHelpString("Download completo. Clique no botao 'Instalar atualizacao' para finalizar.")
	end
end

function DownloadUpdate()
	if string.find( script.this.version,"beta") then
		module.httpRequest("https://github.com/Dowglass/Cheat-Menu/archive/master.zip", nil, function(body, code, headers, status)  
			print(link, 'OK', status)
			downloadUrlToFile("https://github.com/Dowglass/Cheat-Menu/archive/master.zip",string.format("%supdate.zip",tcheatmenu.dir),module.DownloadHandler)
		end)
	else
		module.httpRequest("https://api.github.com/repos/Dowglass/Cheat-Menu/tags", nil, function(body, code, headers, status)  
			print(link, 'OK', status)
			module.tmenu.repo_version = tostring(decodeJson(body)[1].name)
			downloadUrlToFile("https://github.com/Dowglass/Cheat-Menu/archive/".. module.tmenu.repo_version .. ".zip",string.format("%supdate.zip",tcheatmenu.dir),module.DownloadHandler)
		end)
	end
	
	printHelpString("O download foi iniciado. Voce sera notificado quando o download for concluido.")
	module.tmenu.update_status = fconst.UPDATE_STATUS.DOWNLOADING
end

-- Main function
function module.MenuMain()

	fcommon.Tabs("Menu",{"Config","Info","Comandos","Teclas de atalho","Estilos","Licença","Sobre"},{
		function()
			if imgui.Button("Configurações padrão",imgui.ImVec2(fcommon.GetSize(2))) then
				module.tmenu.crash_text = "Configuraçoes padrao ~g~definida"
				fconfig.tconfig.reset = true
				thisScript():reload()
			end
			imgui.SameLine()
			if imgui.Button("Recarregar",imgui.ImVec2(fcommon.GetSize(2))) then
				module.tmenu.crash_text = "Cheat Menu ~g~recarregado"
				thisScript():reload()
			end
			imgui.Dummy(imgui.ImVec2(0,5))
			imgui.Columns(2,nil,false)
			fcommon.CheckBoxVar("Auto recarregar",module.tmenu.auto_reload,"Recarrega o cheat menu automaticamente em caso de crash.\nÁs vezes, pode causar alguma falha.")
			fcommon.CheckBoxVar("Verificar se há atualizações",module.tmenu.auto_update_check,"O Cheat Menu irá verificar automaticamente se há atualizações online.\nIsso requer uma conexão com\
a internet para baixar arquivos do github.")
			fcommon.CheckBoxVar("Apenas texto",module.tmenu.draw_text_only,"Substitua as imagens do menu por nomes de texto.\
Isso pode melhorar o desempenho do menu.")	
			fcommon.CheckBoxVar("Carregamento rápido de imagens",module.tmenu.fast_load_images,"Carregamento rápido de imagens de veículos, armas, peds e etc.\n \
Isso pode aumentar o tempo de inicialização do jogo ou travar\npor alguns segundos, mas melhora o desempenho do menu.")
				
			imgui.NextColumn()
			fcommon.CheckBoxVar("Bloquear jogador",module.tmenu.lock_player,"Bloqueia os controles do jogador enquanto o menu estiver aberto.")
			fcommon.CheckBoxVar("Mostrar mensagem de falha",module.tmenu.show_crash_message)
			fcommon.CheckBoxVar("Mostrar dicas de ferramentas",module.tmenu.show_tooltips,"Mostra dicas de uso ao lado das opções.")
			imgui.Columns(1)
			
		end,
		function()
			imgui.Columns(2,nil,false)
			fcommon.CheckBoxVar("Mostrar coordenadas",module.tmenu.overlay.coordinates)
			fcommon.CheckBoxVar("Mostrar FPS",module.tmenu.overlay.fps)	
			fcommon.CheckBoxVar("Mostrar localização",module.tmenu.overlay.location)
			imgui.NextColumn()

			fcommon.CheckBoxVar("Mostrar integridade do veículo",module.tmenu.overlay.health)
			fcommon.CheckBoxVar("Mostrar velocidade do veículo",module.tmenu.overlay.speed)
			imgui.Columns(1)

			imgui.Spacing()
			imgui.Combo("Posição", module.tmenu.overlay.position_index,module.tmenu.overlay.position_array,#module.tmenu.overlay.position)
			fcommon.InformationTooltip("Você também pode clicar com o botão direito do mouse na\nsobreposição para acessar essas opções.")
		end,
		function()
			module.tmenu.command.filter:Draw("Filtrar")
			fcommon.InformationTooltip(string.format("Abra a janela de comando usando %s\n e feche usando Enter.",fcommon.GetHotKeyNames(tcheatmenu.hot_keys.command_window)))
			imgui.Spacing()

			if imgui.BeginChild("Command entries") then
				for v,k in fcommon.spairs(module.tmenu.command.list) do
					if module.tmenu.command.filter:PassFilter(v) and imgui.CollapsingHeader(v) then
						imgui.Spacing()
						if k[2] ~= nil then
							imgui.TextWrapped("Descrição: " .. k[2])
						end

						if k[3] == nil then k[3] = "" end
						imgui.TextWrapped("Uso: " .. v .. " " .. k[3])

						imgui.Separator()
					end
				end
				imgui.EndChild()
			end
		end,
		function()
			fcommon.HotKey(tcheatmenu.hot_keys.menu_open,"Abre/Fecha o cheat menu")
			fcommon.HotKey(tcheatmenu.hot_keys.command_window,"Abre a janela de comandos")

			imgui.Dummy(imgui.ImVec2(0,10))

			fcommon.HotKey(tcheatmenu.hot_keys.asc_key,"Ativa o 'aim skin changer'")
			fcommon.HotKey(tcheatmenu.hot_keys.mc_paste,"Colar endereço de memória")
			fcommon.HotKey(tcheatmenu.hot_keys.quick_screenshot,"Captura de tela")
			fcommon.HotKey(tcheatmenu.hot_keys.quick_teleport,"Teleportar com 'Quick teleport'")

			imgui.Dummy(imgui.ImVec2(0,10))
			
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode,"Ativa/Desativa o modo câmera")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_forward,"Câmera para frente")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_backward,"Câmera para trás")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_left,"Câmera para esquerda")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_right,"Câmera para direita")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_slow,"Movimento da câmera mais lento")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_fast,"Movimento da câmera mais rápido")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_up,"Modo de câmera pra cima (Câmera travada)")
			fcommon.HotKey(tcheatmenu.hot_keys.camera_mode_down,"Modo de câmera para baixo (Câmera travada)")
			imgui.Dummy(imgui.ImVec2(0,10))

			imgui.TextWrapped("Você pode redefinir essas configurações para o padrão no botão 'Configurações padrão' na guia 'Config'.")
		end,
		function()
			if fstyle.tstyle.status then
				if imgui.Button("Excluir estilo",imgui.ImVec2(fcommon.GetSize(2))) then
					if fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1] == nil then
						printHelpString("Estilo nao selecionado")
					else
						if fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1] == "Default" then
							printHelpString("Nao e possivel excluir o estilo padrao!")
						else
							fstyle.tstyle.styles_table[(fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1])] = nil
							fstyle.tstyle.list = fstyle.getStyles()
							fstyle.tstyle.array = imgui.new['const char*'][#fstyle.tstyle.list](fstyle.tstyle.list)
							fcommon.SaveJson("styles",fstyle.tstyle.styles_table)

							for k,v in ipairs(fstyle.tstyle.list) do
								if v == "Default" then
									fstyle.tstyle.selected[0] = k-1
								end
							end

							if fstyle.tstyle.list[fstyle.tstyle.selected[0]+1] == nil then
								fstyle.tstyle.selected[0] = fstyle.tstyle.selected[0] - 1
							end
							fstyle.applyStyle(imgui.GetStyle(), fstyle.tstyle.list[fstyle.tstyle.selected[0]+1])
							fstyle.tstyle.selected_name = fstyle.tstyle.list[fstyle.tstyle.selected[0]+1]
							printHelpString("Estilo deletado")
						end
					end
				end
				imgui.SameLine()
				if imgui.Button("Salvar estilo",imgui.ImVec2(fcommon.GetSize(2))) then
					fstyle.saveStyles(imgui.GetStyle(), ffi.string(fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1]))
					fstyle.tstyle.list  = fstyle.getStyles()
					fstyle.tstyle.array = imgui.new['const char*'][#fstyle.tstyle.list](fstyle.tstyle.list)
					fstyle.applyStyle(imgui.GetStyle(), fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1])
					fstyle.tstyle.selected_name = fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1]
					printHelpString("Estilo salvo")
				end
			end

			imgui.Spacing()

			imgui.InputText('##Nomedoestilo', fstyle.tstyle.name, ffi.sizeof(fstyle.tstyle.name) - 1) 
			imgui.SameLine()
			local vec_size = imgui.GetItemRectSize()
			vec_size.x = fcommon.GetSize(3)
			if imgui.Button("Adicionar novo estilo",vec_size) then
				fstyle.saveStyles(imgui.GetStyle(), ffi.string(fstyle.tstyle.name))
				fstyle.tstyle.list = fstyle.getStyles()
				fstyle.tstyle.array = imgui.new['const char*'][#fstyle.tstyle.list](fstyle.tstyle.list)
				for k,v in ipairs(fstyle.tstyle.list) do
					if v == ffi.string(fstyle.tstyle.name) then
						fstyle.tstyle.selected[0] = k-1
					end
				end
				fstyle.tstyle.selected_name = fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1]
				printHelpString("Estilo adicionado!")
			end

			if fstyle.tstyle.status then
				
				if imgui.Combo('Select style', fstyle.tstyle.selected, fstyle.tstyle.array, #fstyle.tstyle.list) then
					fstyle.applyStyle(imgui.GetStyle(), fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1])
					fstyle.tstyle.selected_name = fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1]
				end
				
				fstyle.StyleEditor()
			end
		end,
		function()
			imgui.TextWrapped("Este programa é um software gratuito. Você pode modificá-lo e/ou redistribuí-lo ao seu critério sob os termos da \z
				GNU General Public License conforme publicado pela Free Software Foundation na 3° versão da licença. \z
				 \n\n\z
	
				Este programa é distribuído na esperança de que seja útil, mas SEM QUALQUER GARANTIA, sem sequer o implícito \z
				garantido de COMERCIALIZAÇÃO ou ADEQUAÇÃO PARA UMA FINALIDADE ESPECÍFICA. Veja a Licença Pública Geral GNU para mais detalhes. \n\n\z
	
				Você deve ter recebido uma cópia da Licença Pública Geral GNU junto com este programa. Caso contrário, consulte: <http://www.gnu.org/licenses/>.\n\n\n\z
	
				Copyright (C) 2019-2020 Grinch_ \n")
		end,
		function()
			if imgui.Button("Verificar se há atualizações",imgui.ImVec2(fcommon.GetSize(2))) then
				module.CheckUpdates()
			end
			imgui.SameLine()
			if imgui.Button("Ir para repo oficial no Github",imgui.ImVec2(fcommon.GetSize(2))) then
				os.execute('explorer "https://github.com/user-grinch/Cheat-Menu"')
			end
			imgui.Spacing()

			if imgui.BeginChild("Sobre") then

				imgui.Columns(2,nil,false)
				imgui.Text(string.format("%s v%s",script.this.name,script.this.version))
				imgui.Text(string.format("Build: %d",script.this.version_num))
	
				imgui.NextColumn()
				imgui.Text(string.format("Autor: %s",script.this.authors[1]))
				imgui.Text(string.format("Imgui: v%s",imgui._VERSION))
				imgui.Columns(1)

				imgui.Dummy(imgui.ImVec2(0,10))
				imgui.TextWrapped("Precisa de ajuda?/Enfrentando problemas?/Tem sugestões?\nEntre em contato comigo no discord: Grinch_#3311 ou no fórum.")
				imgui.TextWrapped("Por favor, em caso de crash's forneça o 'moonloader.log'.")
				imgui.Dummy(imgui.ImVec2(0,10))
				imgui.TextWrapped("Resolução mínima: 1024x768")
				imgui.TextWrapped(string.format("Sua resolução: %dx%d",resX,resY))
				imgui.TextWrapped("Resolução máxima: 1920x1080")
				imgui.Spacing()
				imgui.TextWrapped("O menu funcionará corretamente em outras resoluções, mas a GUI e as fontes poderam ter problemas.")
				imgui.Dummy(imgui.ImVec2(0,10))
				imgui.TextWrapped("Agradecimentos especiais para: ")
				imgui.Columns(2,nil,false)
				
				imgui.TextWrapped("Dowglas_")
				imgui.TextWrapped("Fabio")
				imgui.TextWrapped("guru guru")
				imgui.TextWrapped("Israel")
				imgui.TextWrapped("Junior-Djjr")
				imgui.TextWrapped("kuba--")
				imgui.TextWrapped("randazz0")
				imgui.TextWrapped("Um_Geek")
				imgui.TextWrapped("Comunidade Modding")
				imgui.TextWrapped("Rockstar Games")
				imgui.NextColumn()
				imgui.TextWrapped("Pela Tradução em português")
				imgui.TextWrapped("Pelo GSX")
				imgui.TextWrapped("Pelo Timecyc stuff")
				imgui.TextWrapped("Pelo api Neon")
				imgui.TextWrapped("Por sua ajuda")
				imgui.TextWrapped("Pela C zip library")
				imgui.TextWrapped("Pelo ImStyleSerializer")
				imgui.TextWrapped("Por sua ajuda")
				imgui.EndChild()
			end
			imgui.Columns(1)
		end
	})
end

return module
