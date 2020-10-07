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
	fast_load_images    = imgui.new.bool(fconfig.Get('tmenu.fast_load_images',false)),
	font				=
	{
		list			= {},
		selected		= fconfig.Get('tmenu.font.selected',"Trebucbd.ttf"),
		size  		    = imgui.new.int(fconfig.Get('tmenu.font.size',math.floor(resY/54.85))),
	},
	get_beta_updates	= imgui.new.bool(fconfig.Get('tmenu.get_beta_updates',true)),
	hot_keys     =
    {
        asc_key               = fconfig.Get('tmenu.hot_keys.asc_key',{vkeys.VK_RETURN,vkeys.VK_RETURN}),
        camera_mode           = fconfig.Get('tmenu.hot_keys.camera_mode',{vkeys.VK_LMENU,vkeys.VK_C}),
        camera_mode_forward   = fconfig.Get('tmenu.hot_keys.camera_mode_forward',{vkeys.VK_I,vkeys.VK_I}),
        camera_mode_backward  = fconfig.Get('tmenu.hot_keys.camera_mode_backward',{vkeys.VK_K,vkeys.VK_K}),
        camera_mode_left      = fconfig.Get('tmenu.hot_keys.camera_mode_left',{vkeys.VK_J,vkeys.VK_J}),
        camera_mode_right     = fconfig.Get('tmenu.hot_keys.camera_mode_right',{vkeys.VK_L,vkeys.VK_L}),
        camera_mode_slow      = fconfig.Get('tmenu.hot_keys.camera_mode_slow',{vkeys.VK_RCONTROL,vkeys.VK_RCONTROL}),
        camera_mode_fast      = fconfig.Get('tmenu.hot_keys.camera_mode_fast',{vkeys.VK_RSHIFT,vkeys.VK_RSHIFT}),
        camera_mode_up        = fconfig.Get('tmenu.hot_keys.camera_mode_up',{vkeys.VK_O,vkeys.VK_O}),
        camera_mode_down      = fconfig.Get('tmenu.hot_keys.camera_mode_down',{vkeys.VK_P,vkeys.VK_P}),
        command_window        = fconfig.Get('tmenu.hot_keys.command_window',{vkeys.VK_LMENU,vkeys.VK_M}),
        menu_open             = fconfig.Get('tmenu.hot_keys.menu_open',{vkeys.VK_LCONTROL,vkeys.VK_M}),
        quick_screenshot      = fconfig.Get('tmenu.hot_keys.quick_screenshot',{vkeys.VK_LCONTROL,vkeys.VK_S}),
        quick_teleport        = fconfig.Get('tmenu.hot_keys.quick_teleport',{vkeys.VK_X,vkeys.VK_Y}),
        script_manager_temp   = {vkeys.VK_LCONTROL,vkeys.VK_1}
    },
	lock_player   		= imgui.new.bool(fconfig.Get('tmenu.lock_player',false)),
	overlay             = 
	{
		coordinates     = imgui.new.bool(fconfig.Get('tmenu.overlay.coordinates',false)),
		fps             = imgui.new.bool(fconfig.Get('tmenu.overlay.fps',false)),
		show            = imgui.new.bool(true),
		location    	= imgui.new.bool(fconfig.Get('tmenu.overlay.location',false)),
    	position        = {"Customizar","Superior esquerdo","Superior direito","Inferior esquerdo","Inferior direito"},
    	position_array  = {},
		position_index  = imgui.new.int(fconfig.Get('tmenu.overlay.position_index',4)),
		health          = imgui.new.bool(fconfig.Get('tmenu.overlay.health',false)),
		pos_x           = imgui.new.int(fconfig.Get('tmenu.overlay.pos_x',0)),
		pos_y           = imgui.new.int(fconfig.Get('tmenu.overlay.pos_y',0)),
		speed           = imgui.new.bool(fconfig.Get('tmenu.overlay.speed',false)),		
		transparent_bg  = imgui.new.bool(fconfig.Get('tmenu.overlay.transparent_bg',false)),
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
		if t[2] == nil or t[3] == nil then
			printHelpString("Coordenada nao inserida!")
			return
		end

        if t[4] == nil then t[4] = getGroundZFor3dCoord(x,y,100) end
		lua_thread.create(fteleport.Teleport,tonumber(t[2]),tonumber(t[3]),tonumber(t[4]))
	end,"Teleporta para a coordenada","{X} {Y} {Z}(opcional)")
	
	module.RegisterCommand("settime",function(t)
        setTimeOfDay(t[2],t[3])
        printHelpString("Horario definido as")
	end,"Define o horário no jogo","{hora} {minuto}")
	
	module.RegisterCommand("cheatmenu",function(t)
        tcheatmenu.show[0] = not tcheatmenu.show[0]
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
		fcommon.CreateThread(fgame.CameraMode)
	end,"Ativa ou desativa o modo de câmera")
	
	module.RegisterCommand("veh",function(t)
		if t[2] == nil then 
			printHelpString("Nenhum nome de veiculo fornecido") 
			return 
		end

		local model = tonumber(t[2])

		if type(model) == "nil" then
			print(string.upper(t[2]))
			model = casts.CModelInfo.GetModelFromName(string.upper(t[2])) 

			if model ~= 0 and isModelAvailable(model) then  
				fvehicle.GiveVehicleToPlayer(model)
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
-- Updater code

function module.CheckUpdates()
	
	if fmenu.tmenu.get_beta_updates[0] then
		link = "https://raw.githubusercontent.com/Dowglass/Cheat-Menu/master/moonloader/cheat-menu.lua"
	else
		link = "https://api.github.com/repos/Dowglass/Cheat-Menu/tags"
	end

	downloadUrlToFile(link,string.format("%s/version.txt",tcheatmenu.dir),
	function(id, status, p1, p2)
		if status == fconst.UPDATE_STATUS.DOWNLOADED then
			local file_path = string.format("%s\\version.txt",tcheatmenu.dir)
			if doesFileExist(file_path) then
				local file = io.open(file_path,"rb")
				local content = file:read("*all")

				if fmenu.tmenu.get_beta_updates[0] then
					repo_version = content:match("script_version_number%((%d+)%)")
					this_version = script.this.version_num
				else
					repo_version = decodeJson(content)[1].name
					this_version = script.this.version
				end
	
				if repo_version ~= nil then
					if tostring(repo_version) > tostring(this_version) then
						module.tmenu.update_status = fconst.UPDATE_STATUS.NEW_UPDATE
						module.tmenu.repo_version = tostring(repo_version)
						printHelpString("Nova atualizacao disponivel!")
					else
						printHelpString("Nenhuma atualizacao disponivel")
					end
				else
					printHelpString("Nao foi possivel conectar ao github. O restante do menu ainda esta funcional. Voce pode desativar a verificacao de atualizacao automatica em 'Menu'.")
				end
				io.close(file)
				os.remove(file_path)
			else
				print("Version.txt nao existe")
			end
		end
	end)
end

function module.DownloadUpdate()
	if fmenu.tmenu.get_beta_updates[0] then
		link = "https://github.com/Dowglass/Cheat-Menu/archive/master.zip"
	else
		link = "https://github.com/Dowglass/Cheat-Menu/archive/".. module.tmenu.repo_version .. ".zip"
	end
	
	downloadUrlToFile(link,string.format("%supdate.zip",tcheatmenu.dir),
	function(id, status, p1, p2)
		if status == fconst.UPDATE_STATUS.DOWNLOADED then
			fmenu.tmenu.update_status = fconst.UPDATE_STATUS.DOWNLOADED
			printHelpString("Download completo. Clique no botao 'Instalar atualizacao' para finalizar.")
		end
	end)

	printHelpString("O download foi iniciado. Voce sera notificado quando o download for concluido.")
	module.tmenu.update_status = fconst.UPDATE_STATUS.DOWNLOADING
end

function module.InstallUpdate()
	fmenu.tmenu.update_status = fconst.UPDATE_STATUS.HIDE_MSG
	fgame.tgame.script_manager.skip_auto_reload = true
	ziplib.zip_extract(tcheatmenu.dir .. "update.zip",tcheatmenu.dir,nil,nil)
	
	local dir = tcheatmenu.dir

	if fmenu.tmenu.get_beta_updates[0] then
		dir = dir .. "\\Cheat-Menu-master\\"
	else
		dir = dir .. "\\Cheat-Menu-" .. fmenu.tmenu.repo_version .. "\\"
	end

	fcommon.MoveFiles(dir,getGameDirectory())
	
	os.remove(tcheatmenu.dir .. "update.zip")

	-- Delete the old config file too, causes crash?
	os.remove(string.format(tcheatmenu.dir .. "/json/config.json"))
	fconfig.tconfig.save_config = false

	printHelpString("Atualizacao ~g~Instalada")
	print("Atualizacao instalada! Recarregando script.")
	thisScript():reload()
end

--------------------------------------------------

function module.MenuMain()

	if fcommon.BeginTabBar('MenuBar') then
		if fcommon.BeginTabItem('Config') then
			if imgui.Button("Configurações padrão",imgui.ImVec2(fcommon.GetSize(2))) then
				module.tmenu.crash_text = "Configuracoes padrao ~g~definida"
				fconfig.tconfig.reset = true
				thisScript():reload()
			end
			imgui.SameLine()
			if imgui.Button("Recarregar",imgui.ImVec2(fcommon.GetSize(2))) then
				module.tmenu.crash_text = "Cheat Menu ~g~recarregado"
				thisScript():reload()
			end
			imgui.Spacing()
			imgui.PushItemWidth((imgui.GetWindowContentRegionWidth()-imgui.GetStyle().ItemSpacing.x) * 0.50)
			fcommon.DropDownListStr("##Selectfont",fmenu.tmenu.font.list,"Font - " ..fmenu.tmenu.font.selected,
			function(key,val)
				imgui.GetIO().FontDefault = val
				fmenu.tmenu.font.selected = key
			end)
			imgui.SameLine()
			if imgui.SliderInt("##Fontsize", module.tmenu.font.size, 12, 48) then
				tcheatmenu.restart_required = true
			end
			imgui.PopItemWidth()
			imgui.Dummy(imgui.ImVec2(0,5))
			imgui.Columns(2,nil,false)
			fcommon.CheckBoxVar("Auto recarregar",module.tmenu.auto_reload,"Recarrega o cheat menu automaticamente em caso de crash.\nÁs vezes, pode causar alguma falha.")
			fcommon.CheckBoxVar("Verificar se há atualizações",module.tmenu.auto_update_check,"O Cheat Menu irá verificar automaticamente se há atualizações online.\nIsso requer uma conexão com\
a internet para baixar arquivos do github.")	
			fcommon.CheckBoxVar("Obter atualizações beta",module.tmenu.get_beta_updates,"Receber atualizações beta frequentemente.\
(Essas atualizações podem ser instáveis)")
				
			imgui.NextColumn()
			fcommon.CheckBoxVar("Bloquear jogador",module.tmenu.lock_player,"Bloqueia os controles do jogador enquanto o menu estiver aberto.")
			fcommon.CheckBoxVar("Mostrar mensagem de falha",module.tmenu.show_crash_message)
			fcommon.CheckBoxVar("Mostrar dicas de ferramentas",module.tmenu.show_tooltips,"Mostra dicas de uso ao lado das opções.")
			imgui.Columns(1)
		end
		if fcommon.BeginTabItem('Info') then
			imgui.Columns(2,nil,false)
			fcommon.CheckBoxVar("Sem fundo",module.tmenu.overlay.transparent_bg)
			fcommon.CheckBoxVar("Mostrar coordenadas",module.tmenu.overlay.coordinates)
			fcommon.CheckBoxVar("Mostrar FPS",module.tmenu.overlay.fps)	
			imgui.NextColumn()

			fcommon.CheckBoxVar("Mostrar localização",module.tmenu.overlay.location)
			fcommon.CheckBoxVar("Mostrar integridade do veículo",module.tmenu.overlay.health)
			fcommon.CheckBoxVar("Mostrar velocidade do veículo",module.tmenu.overlay.speed)
			imgui.Columns(1)

			imgui.Spacing()
			imgui.Combo("Posição", module.tmenu.overlay.position_index,module.tmenu.overlay.position_array,#module.tmenu.overlay.position)
			fcommon.InformationTooltip("Você também pode clicar com o botão direito do mouse na\nsobreposição para acessar essas opções.")
			end
			if fcommon.BeginTabItem('Comandos') then
			module.tmenu.command.filter:Draw("Procurar")
			fcommon.InformationTooltip(string.format("Abra a janela de comando usando %s\n e feche usando Enter.",fcommon.GetHotKeyNames(module.tmenu.hot_keys.command_window)))
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
		end
		if fcommon.BeginTabItem('Teclas de atalho') then
			local x,y = fcommon.GetSize(3)
			y = y/1.2
			
			fcommon.HotKey("Abre/Fecha o cheat menu",module.tmenu.hot_keys.menu_open)
			fcommon.HotKey("Abre a janela de comandos",module.tmenu.hot_keys.command_window)

			imgui.Dummy(imgui.ImVec2(0,10))

			fcommon.HotKey("Ativa o 'aim skin changer'",module.tmenu.hot_keys.asc_key)
			fcommon.HotKey("Captura de tela",module.tmenu.hot_keys.quick_screenshot)
			fcommon.HotKey("Teleportar com 'Quick teleport'",module.tmenu.hot_keys.quick_teleport)

			imgui.Dummy(imgui.ImVec2(0,10))

			fcommon.HotKey("Ativa/Desativa o modo câmera",module.tmenu.hot_keys.camera_mode)
			fcommon.HotKey("Câmera para frente",module.tmenu.hot_keys.camera_mode_forward)
			fcommon.HotKey("Câmera para trás",module.tmenu.hot_keys.camera_mode_backward)
			fcommon.HotKey("Câmera para esquerda",module.tmenu.hot_keys.camera_mode_left)
			fcommon.HotKey("Câmera para direita",module.tmenu.hot_keys.camera_mode_right)
			fcommon.HotKey("Movimento da câmera mais lento",module.tmenu.hot_keys.camera_mode_slow)
			fcommon.HotKey("Movimento da câmera mais rápido",module.tmenu.hot_keys.camera_mode_fast)
			fcommon.HotKey("Modo de câmera pra cima (Câmera travada)",module.tmenu.hot_keys.camera_mode_up)
			fcommon.HotKey("Modo de câmera pra baixo (Câmera travada)",module.tmenu.hot_keys.camera_mode_down)
			imgui.Dummy(imgui.ImVec2(0,10))

			imgui.TextWrapped("Você pode redefinir essas configurações para o padrão no botão 'Configurações padrão' na guia 'Config'.")
		end
		if fcommon.BeginTabItem('Estilos') then
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

					printHelpString("Estilo salvo!")
				end
			end

			imgui.Spacing()

			imgui.InputText('##Nomedoestilo', fstyle.tstyle.name, ffi.sizeof(fstyle.tstyle.name) - 1) 
			imgui.SameLine()
			local vec_size = imgui.GetItemRectSize()
			local text = "Adicionar novo estilo"
			vec_size.x = imgui.CalcTextSize(text).x+10
			if imgui.Button(text,vec_size) then
				fstyle.saveStyles(imgui.GetStyle(), ffi.string(fstyle.tstyle.name))
				fstyle.tstyle.list = fstyle.getStyles()
				fstyle.tstyle.array = imgui.new['const char*'][#fstyle.tstyle.list](fstyle.tstyle.list)
				for k,v in ipairs(fstyle.tstyle.list) do
					if v == ffi.string(fstyle.tstyle.name) then
						fstyle.tstyle.selected[0] = k-1
					end
				end
				fstyle.tstyle.selected_name = fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1]
				printHelpString("Estilo adicionado")
			end

			if fstyle.tstyle.status then
				
				if imgui.Combo('Selecionar estilo', fstyle.tstyle.selected, fstyle.tstyle.array, #fstyle.tstyle.list) then
					fstyle.applyStyle(imgui.GetStyle(), fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1])
					fstyle.tstyle.selected_name = fstyle.tstyle.list[fstyle.tstyle.selected[0] + 1]
				end
				
				fstyle.StyleEditor()
		   end
	   end
	   if fcommon.BeginTabItem('Licensa') then
			imgui.TextWrapped("Este programa é um software gratuito. Você pode modificá-lo e/ou redistribuí-lo ao seu critério sob os termos da \z
				GNU General Public License conforme publicado pela Free Software Foundation na 3° versão da licença. \z
				 \n\n\z
	
				Este programa é distribuído na esperança de que seja útil, mas SEM QUALQUER GARANTIA, sem sequer o implícito \z
				garantido de COMERCIALIZAÇÃO ou ADEQUAÇÃO PARA UMA FINALIDADE ESPECÍFICA. Veja a Licença Pública Geral GNU para mais detalhes. \n\n\z
	
				Você deve ter recebido uma cópia da Licença Pública Geral GNU junto com este programa. Caso contrário, consulte: <http://www.gnu.org/licenses/>.\n\n\n\z
	
				Copyright (C) 2019-2020 Grinch_ \n")
			end
			if fcommon.BeginTabItem('Sobre') then
			if imgui.Button("Verificar se há atualizações",imgui.ImVec2(fcommon.GetSize(3))) then
				module.CheckUpdates()
			end
			imgui.SameLine()
			if imgui.Button("Servidor no Discord",imgui.ImVec2(fcommon.GetSize(3))) then
				os.execute('explorer "https://discord.gg/ZzW7kmf"')
			end
			imgui.SameLine()
			if imgui.Button("Ir para repo oficial no Github",imgui.ImVec2(fcommon.GetSize(2))) then
				os.execute('explorer "https://github.com/user-grinch/Cheat-Menu"')
			end
			imgui.Spacing()

			if imgui.BeginChild("AboutChild") then

				imgui.Columns(2,nil,false)
				imgui.Text(string.format("%s v%s",script.this.name,script.this.version))
				imgui.Text(string.format("Build: %d",script.this.version_num))
	
				imgui.NextColumn()
				imgui.Text(string.format("Autor: %s",script.this.authors[1]))
				imgui.Text(string.format("Imgui: v%s",imgui._VERSION))
				imgui.Columns(1)

				imgui.TextWrapped("Por favor, em caso de crash's forneça o 'moonloader.log'.")
				imgui.Dummy(imgui.ImVec2(0,10))
				imgui.TextWrapped("Agradecimentos especiais a: ")
				imgui.Columns(2,nil,false)
				
				imgui.TextWrapped("Dowglas_")
				imgui.TextWrapped("guru guru")
				imgui.TextWrapped("Israel")
				imgui.TextWrapped("Junior-Djjr")
				
				imgui.NextColumn()
				imgui.TextWrapped("randazz0")
				imgui.TextWrapped("Um_Geek")
				imgui.TextWrapped("Comunidade Modding")
				imgui.TextWrapped("Rockstar Games")
				imgui.EndChild()
			end
			imgui.Columns(1)
		end
		fcommon.EndTabBar()
	end
end

return module
