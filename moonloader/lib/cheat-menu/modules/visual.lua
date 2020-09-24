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
module.tvisual =
{
    car_names                   = imgui.new.bool(true),
    disable_motion_blur         = imgui.new.bool(fconfig.Get('tvisual.disable_motion_blur',false)),   
    lock_weather                = imgui.new.bool(fconfig.Get('tvisual.lock_weather',false)),   
    radio_channel_names         = imgui.new.bool(fconfig.Get('tvisual.radio_channel_names',true)),
    timecyc                     =
    {   timecyc_24_plugin       = getModuleHandle("timecycle24"),
        ambient                 = imgui.new.float[3](),
        ambient_obj             = imgui.new.float[3](),
        sky_top                 = imgui.new.float[3](),
        sky_bottom              = imgui.new.float[3](),
        sun_core                = imgui.new.float[3](),
        sun_corona              = imgui.new.float[3](),
        sun_size                = imgui.new.int(),
        sprite_size             = imgui.new.int(),
        sprite_brightness       = imgui.new.int(),
        shadow_strength         = imgui.new.int(),
        light_shadow_strength   = imgui.new.int(),
        pole_shadow_strength    = imgui.new.int(),
        far_clip                = imgui.new.int(),   
        fog_start               = imgui.new.int(),   
        lights_on_ground_brightness = imgui.new.int(), 
        low_clouds              = imgui.new.float[3](),
        fluffy_clouds           = imgui.new.float[3](),
        water                   = imgui.new.float[4](),
        postfx1                 = imgui.new.float[4](),
        postfx2                 = imgui.new.float[4](),
        cloud_alpha             = imgui.new.int(),
        waterfog_alpha          = imgui.new.int(),
        high_light_min_intensity= imgui.new.int(),
        directional_mult        = imgui.new.int(),
        weather                 =
        {    
            names               = 
            {
                "EXTRASUNNY LA",
                "SUNNY LA",
                "EXTRASUNNY SMOG LA",
                "SUNNY SMOG LA",
                "CLOUDY LA",
                "SUNNY SF",
                "EXTRASUNNY SF",
                "CLOUDY SF",
                "RAINY SF",
                "FOGGY SF",
                "SUNNY VEGAS",
                "EXTRASUNNY VEGAS",
                "CLOUDY VEGAS",
                "EXTRASUNNY COUNTRYSIDE",
                "SUNNY COUNTRYSIDE",
                "CLOUDY COUNTRYSIDE",
                "RAINY COUNTRYSIDE",
                "EXTRASUNNY DESERT",
                "SUNNY DESERT",
                "SANDSTORM DESERT",
                "UNDERWATER",
                "EXTRACOLOURS 1",
                "EXTRACOLOURS 2"
            },
            array               = {},
        },
    },
    zone_names          = imgui.new.bool(true),
}

module.tvisual.timecyc.weather.array  = imgui.new['const char*'][#module.tvisual.timecyc.weather.names](module.tvisual.timecyc.weather.names)

function module.LockWeather()
    local weather = casts.CTimeCyc.curr_weather[0]
    while module.tvisual.lock_weather[0] do
        casts.CTimeCyc.curr_weather[0] = weather
        casts.CTimeCyc.next_weather[0] = weather
        wait(0)
    end
end

function GetCurrentHourTimeId(hour)

    local h = casts.CTimeCyc.hours[0]

    if hour == 24 then 
        return h
    end

    if h < 5 then  return 0  end
	if h == 5 then  return 1 end
    if h == 6 then  return 2 end
    
	if 7 <= h and h < 12 then  return 3 end
    if 12 <= h and h < 19 then  return 4 end
    
	if h == 19 then  return 5 end
	if h == 20 or h == 21 then  return 6 end
	if h == 22 or h == 23 then  return 7 end
end

function UpdateTimecycData(val)

    module.tvisual.timecyc.ambient[0] = casts.CTimeCyc.ambient_red[val]/255
    module.tvisual.timecyc.ambient[1] = casts.CTimeCyc.ambient_green[val]/255
    module.tvisual.timecyc.ambient[2] = casts.CTimeCyc.ambient_blue[val]/255

    module.tvisual.timecyc.ambient_obj[0] = casts.CTimeCyc.ambient_obj_red[val]/255
    module.tvisual.timecyc.ambient_obj[1] = casts.CTimeCyc.ambient_obj_green[val]/255
    module.tvisual.timecyc.ambient_obj[2] = casts.CTimeCyc.ambient_obj_blue[val]/255

    module.tvisual.timecyc.sky_top[0] = casts.CTimeCyc.sky_top_red[val]/255
    module.tvisual.timecyc.sky_top[1] = casts.CTimeCyc.sky_top_green[val]/255
    module.tvisual.timecyc.sky_top[2] = casts.CTimeCyc.sky_top_blue[val]/255

    module.tvisual.timecyc.sky_bottom[0] = casts.CTimeCyc.sky_bottom_red[val]/255
    module.tvisual.timecyc.sky_bottom[1] = casts.CTimeCyc.sky_bottom_green[val]/255
    module.tvisual.timecyc.sky_bottom[2] = casts.CTimeCyc.sky_bottom_blue[val]/255

    module.tvisual.timecyc.sun_core[0] = casts.CTimeCyc.sun_core_red[val]/255
    module.tvisual.timecyc.sun_core[1] = casts.CTimeCyc.sun_core_green[val]/255
    module.tvisual.timecyc.sun_core[2] = casts.CTimeCyc.sun_core_blue[val]/255

    module.tvisual.timecyc.sun_corona[0] = casts.CTimeCyc.sun_corona_red[val]/255
    module.tvisual.timecyc.sun_corona[1] = casts.CTimeCyc.sun_corona_green[val]/255
    module.tvisual.timecyc.sun_corona[2] = casts.CTimeCyc.sun_corona_blue[val]/255

    module.tvisual.timecyc.sun_size[0] = casts.CTimeCyc.sun_size[val]

    module.tvisual.timecyc.sprite_brightness[0] = casts.CTimeCyc.sprite_brightness[val]
    module.tvisual.timecyc.sprite_size[0]       = casts.CTimeCyc.sprite_size[val]

    module.tvisual.timecyc.shadow_strength[0]       = casts.CTimeCyc.shadow_strength[val]
    module.tvisual.timecyc.light_shadow_strength[0] = casts.CTimeCyc.light_shadow_strength[val]
    module.tvisual.timecyc.pole_shadow_strength[0]  = casts.CTimeCyc.pole_shadow_strength[val]

    module.tvisual.timecyc.fog_start[0]                    = casts.CTimeCyc.fog_start[val]
    module.tvisual.timecyc.far_clip[0]                     = casts.CTimeCyc.far_clip[val]
    module.tvisual.timecyc.lights_on_ground_brightness[0]  = casts.CTimeCyc.lights_on_ground_brightness[val]
   
    module.tvisual.timecyc.low_clouds[0] = casts.CTimeCyc.low_clouds_red[val]/255
    module.tvisual.timecyc.low_clouds[1] = casts.CTimeCyc.low_clouds_green[val]/255
    module.tvisual.timecyc.low_clouds[2] = casts.CTimeCyc.low_clouds_blue[val]/255

    module.tvisual.timecyc.fluffy_clouds[0] = casts.CTimeCyc.fluffy_clouds_red[val]/255
    module.tvisual.timecyc.fluffy_clouds[1] = casts.CTimeCyc.fluffy_clouds_green[val]/255
    module.tvisual.timecyc.fluffy_clouds[2] = casts.CTimeCyc.fluffy_clouds_blue[val]/255

    module.tvisual.timecyc.water[0] = casts.CTimeCyc.water_red[val]/255
    module.tvisual.timecyc.water[1] = casts.CTimeCyc.water_green[val]/255
    module.tvisual.timecyc.water[2] = casts.CTimeCyc.water_blue[val]/255
    module.tvisual.timecyc.water[3] = casts.CTimeCyc.water_alpha[val]/255

    module.tvisual.timecyc.postfx1[0] = casts.CTimeCyc.postfx1_red[val]/255
    module.tvisual.timecyc.postfx1[1] = casts.CTimeCyc.postfx1_green[val]/255
    module.tvisual.timecyc.postfx1[2] = casts.CTimeCyc.postfx1_blue[val]/255
    module.tvisual.timecyc.postfx1[3] = casts.CTimeCyc.postfx1_alpha[val]/255

    module.tvisual.timecyc.postfx2[0] = casts.CTimeCyc.postfx2_red[val]/255
    module.tvisual.timecyc.postfx2[1] = casts.CTimeCyc.postfx2_green[val]/255
    module.tvisual.timecyc.postfx2[2] = casts.CTimeCyc.postfx2_blue[val]/255
    module.tvisual.timecyc.postfx2[3] = casts.CTimeCyc.postfx2_alpha[val]/255

    module.tvisual.timecyc.cloud_alpha[0]  = casts.CTimeCyc.cloud_alpha[val]
    module.tvisual.timecyc.waterfog_alpha[0]  = casts.CTimeCyc.waterfog_alpha[val]
    module.tvisual.timecyc.high_light_min_intensity[0]  = casts.CTimeCyc.high_light_min_intensity[val]
    module.tvisual.timecyc.directional_mult[0]  = casts.CTimeCyc.directional_mult[val]
end

function GenerateTimecycFile(hour)

    local file = io.open(getGameDirectory().."/timecyc.dat", "w")
    if hour == 24 then  
        file = io.open(getGameDirectory().."/timecyc_24h.dat", "w")
    end

    for i=0,(#module.tvisual.timecyc.weather.names-1),1 do
        file:write("\n\n//////////// " .. module.tvisual.timecyc.weather.names[i+1].. "\n")
        
        file:write("//\tAmb\t\t\t\t\tAmb Obj \t\t\t\tDir \t\t\t\t\tSky top\t\t\t\tSky bot\t\t\t\tSunCore\t\t\t\t\tSunCorona\t\t\tSunSz\tSprSz\tSprBght\t\tShdw\tLightShd\tPoleShd\t\tFarClp\t\tFogSt\tLightOnGround\tLowCloudsRGB\tBottomCloudRGB\t\tWaterRGBA\t\t\t\tARGB1\t\t\t\t\tARGB2\t\t\tCloudAlpha\t\tIntensityLimit\t\tWaterFogAlpha\tDirMult \n\n")
        
        for j=0,(hour-1),1 do

            if hour == 24 then 
				if (j >= 12) then
					file:write(string.format("// %s PM\n",j))
				else
					file:write(string.format("// %s AM\n",j))
				end
            else
				if j == 0 then file:write("// Midnight\n") end
				if j == 1 then file:write("// 5 AM\n") end
				if j == 2 then file:write("// 6 AM\n") end
				if j == 3 then file:write("// 7 AM\n") end
				if j == 4 then file:write("// Midday\n") end
				if j == 5 then file:write("// 7 PM\n") end
				if j == 6 then file:write("// 8 PM\n") end
				if j == 7 then file:write("// 10 PM\n") end
            end 

            local val = 23 * j + i

            file:write(
				string.format(
					"\t%d %d %d \t\t" .. -- AmbRGB
					"\t%d %d %d \t\t" .. -- AmbObjRGB
					"\t%d %d %d \t\t" .. -- DirRGB (unused?)
					"\t%d %d %d \t\t" .. -- SkyTopRGB
					"\t%d %d %d \t\t" .. -- SkyBotRGB
					"\t%d %d %d \t\t" .. -- SunCore RGB
					"\t%d %d %d \t\t" .. -- SunCorona RGB
					"\t%.1f\t\t%.1f\t\t%.1f\t\t" .. -- SunSz, SpriteSz, SpriteBrightness
					"\t%d \t%d \t\t\t%d\t\t" .. -- ShadStrenght, LightShadStreght, PoleShadStrenght
					"\t%.1f\t\t%.1f\t\t%.1f\t\t" .. -- fFarClip, fFogStart, fLightsOnGroundBrightness
					"\t\t%d %d %d\t" .. -- LowCloudsRGB
					"\t%d %d %d\t\t" .. -- FluffyCloudsRGB
					"\t%d %d %d %d\t\t" .. -- WaterRGBA
					"\t%d %d %d %d\t\t" .. -- PostFx1ARGB
					"\t%d %d %d %d" .. -- PostFx2ARGB
					"\t%d\t\t\t\t%d\t\t\t\t\t%d\t\t\t\t%.2f\t\t\n", -- CloudAlpha HiLiMinIntensity WaterFogAlpha DirectionalMult
					casts.CTimeCyc.ambient_red[val], casts.CTimeCyc.ambient_green[val],	casts.CTimeCyc.ambient_blue[val],
					casts.CTimeCyc.ambient_obj_red[val], casts.CTimeCyc.ambient_obj_green[val],	casts.CTimeCyc.ambient_obj_blue[val],
					255, 255, 255,
					casts.CTimeCyc.sky_top_red[val], casts.CTimeCyc.sky_top_green[val], casts.CTimeCyc.sky_top_blue[val],
					casts.CTimeCyc.sky_bottom_red[val], casts.CTimeCyc.sky_bottom_green[val], casts.CTimeCyc.sky_bottom_blue[val],
					casts.CTimeCyc.sun_core_red[val],casts.CTimeCyc.sun_core_green[val],casts.CTimeCyc.sun_core_blue[val],
					casts.CTimeCyc.sun_corona_red[val], casts.CTimeCyc.sun_corona_green[val], casts.CTimeCyc.sun_corona_blue[val],
					(casts.CTimeCyc.sprite_size[val] - 0.5) / 10.0,(casts.CTimeCyc.sprite_size[val] - 0.5) / 10.0,(casts.CTimeCyc.sprite_brightness[val] - 0.5) / 10.0,
					casts.CTimeCyc.shadow_strength[val],casts.CTimeCyc.light_shadow_strength[val],casts.CTimeCyc.pole_shadow_strength[val],
					casts.CTimeCyc.far_clip[val],casts.CTimeCyc.fog_start[val],	(casts.CTimeCyc.lights_on_ground_brightness[val] - 0.5) / 10.0,
					casts.CTimeCyc.low_clouds_red[val],casts.CTimeCyc.low_clouds_green[val],casts.CTimeCyc.low_clouds_blue[val],
					casts.CTimeCyc.fluffy_clouds_red[val],casts.CTimeCyc.fluffy_clouds_green[val],casts.CTimeCyc.fluffy_clouds_blue[val],
					casts.CTimeCyc.water_red[val],casts.CTimeCyc.water_blue[val],casts.CTimeCyc.water_blue[val],casts.CTimeCyc.water_alpha[val],
					casts.CTimeCyc.postfx1_alpha[val],casts.CTimeCyc.postfx1_red[val],casts.CTimeCyc.postfx1_green[val],casts.CTimeCyc.postfx1_blue[val],
					casts.CTimeCyc.postfx2_alpha[val],casts.CTimeCyc.postfx2_red[val],casts.CTimeCyc.postfx2_green[val],casts.CTimeCyc.postfx2_blue[val],
					casts.CTimeCyc.cloud_alpha[val],casts.CTimeCyc.high_light_min_intensity[val], casts.CTimeCyc.waterfog_alpha[val],	casts.CTimeCyc.directional_mult[val] / 100.0
				)
			)
        end
    end
    io.close(file)
end
------------------------------------------------

-- Main function
function module.VisualMain()
    if fcommon.BeginTabBar('VisualBar') then
        if fcommon.BeginTabItem('Caixas de seleção') then
            imgui.Columns(2,nil,false)
            fcommon.CheckBoxValue('Borda do colete',0x589123)
            fcommon.CheckBoxValue('Porcentagem do colete',0x589125)
            fcommon.CheckBoxValue('Borda da respiração',0x589207)
            fcommon.CheckBoxValue('Porcentagem da respiração',0x589209)
            fcommon.CheckBoxVar('Exibir nome dos carros',module.tvisual.car_names,nil,
            function()    
                displayCarNames(module.tvisual.car_names[0]) 
                fconfig.Set(fconfig.tconfig.misc_data,"Mostrar nomes de carros",module.tvisual.car_names[0])
            end)
            fcommon.CheckBoxVar('Desativar desfoque de movimento (motion blur)',module.tvisual.disable_motion_blur,nil,
            function()    
                if module.tvisual.disable_motion_blur[0] then
                    writeMemory(0x7030A0,4,0xC3,false)
                else
                    writeMemory(0x7030A0,4,0xF3CEC83,false)
                end
            end)
            fcommon.CheckBoxVar('Mostrar nome das zonas',module.tvisual.zone_names,nil,
            function()     
                displayZoneNames(module.tvisual.zone_names[0])
                fconfig.Set(fconfig.tconfig.misc_data,"Display Zone Names",module.tvisual.zone_names[0])
            end)
            fcommon.CheckBoxValue('Ativar hud',0xBA6769)

            imgui.NextColumn()

            fcommon.CheckBoxValue('Ativar radar',0xBA676C,nil,0,2)
            fcommon.CheckBoxValue('Radar cinzento',0xA444A4)
            fcommon.CheckBoxValue('Borda da saúde',0x589353)
            fcommon.CheckBoxValue('Porcentagem da saúde',0x589355)
            fcommon.CheckBoxValue('Ocultar nível de procurado',0x58DD1B,nil,0x90)
            fcommon.CheckBoxVar('Bloquear tempo',module.tvisual.lock_weather,nil,
            function()
                fcommon.SingletonThread(fvisual.LockWeather,"LockWeather")
            end)
            fcommon.CheckBoxVar('Nomes de canais de rádio',module.tvisual.radio_channel_names,nil,
            function()     
                if module.tvisual.radio_channel_names[0] then
                    writeMemory(0x507035,5,-30533911,false)
                else
                    writeMemory(0x507035,4,0x90,false)
                end
            end)
            imgui.Columns(1)
        end
        if fcommon.BeginTabItem('Menus') then
            fcommon.CRGBAColorPicker("Cor da barra de saúde",0xBAB22C,{180,25,29})
            fcommon.CRGBAColorPicker("Cor da borda no menu principal",0xBAB240,{0,0,0})
            fcommon.CRGBAColorPicker("Cor do dinheiro",0xBAB230,{54,104,44})
            fcommon.RadioButtonAddressEx("Contorno do dinheiro",{"Sem contorno","Contorno fino","Contorno padrão"},{0,1,2},0x58F58D)
            fcommon.RadioButtonAddressEx("Estilo da fonte do dinheiro",{"Estilo 1","Estilo 2","Estilo padrão"},{1,2,3},0x58F57F)
            fcommon.UpdateAddress({ name = 'Altura do radar',address = 0x866B74,size = 4,min=0,default = 76,max = 999,is_float = true})
            fcommon.UpdateAddress({ name = 'Largura do radar',address = 0x866B78,size = 4,min=0,default = 94,max = 999,is_float = true})
            fcommon.UpdateAddress({ name = 'Posição X do radar',address = 0x858A10,size = 4,min=-999,default = 40,max = 999,is_float = true,help_text = "Changes radar vertical position"})
            fcommon.UpdateAddress({ name = 'Posição Y do radar',address = 0x866B70,size = 4,min=-999,default = 104,max = 999,is_float = true,help_text = "Changes radar horizantal position"})
            fcommon.UpdateAddress({ name = 'Zoom no radar',address = 0xA444A3,size = 1,min=0,default = 0,max = 170})
            fcommon.CRGBAColorPicker("Cor da estação de rádio",0xBAB24C,{150,150,150})
            fcommon.CRGBAColorPicker("Cor do texto com estilo",0xBAB258,{226,192,99})
            fcommon.CRGBAColorPicker("Cor do texto",0xBAB234,{50,60,127})
            fcommon.RadioButtonAddressEx("Borda da estrela de procurado",{"Sem borda","Padrão","Borda em negrito"},{0,1,2},0x58DD41)
            fcommon.CRGBAColorPicker("Cor da estrela de procurado",0xBAB244,{144,98,16})
            fcommon.UpdateAddress({ name = 'Posição Y da estrela de procurado',address = 0x858CCC,size = 4,is_float = true,min=-500,default = 12,max = 500})
        end
        if fcommon.BeginTabItem('Timecyc editor') then
            if module.tvisual.timecyc.timecyc_24_plugin ~= 0 then
                HOUR = 24
            else
                HOUR = 8
            end

            local val = 23 * GetCurrentHourTimeId(HOUR) + casts.CTimeCyc.curr_weather[0]
            UpdateTimecycData(val)

            imgui.SetNextItemWidth(imgui.GetWindowContentRegionWidth()/1.7)
            if imgui.Button("Resetar timecyc",imgui.ImVec2(fcommon.GetSize(2))) then
                casts.CTimeCyc.initialise()
                printHelpString("Timecyc resetado!")
            end
            imgui.SameLine()
            if imgui.Button("Criar arquivo timecyc",imgui.ImVec2(fcommon.GetSize(2))) then
                GenerateTimecycFile(HOUR)
                printHelpString("Arquivo criado!")
            end
            imgui.Spacing()
            local weather = imgui.new.int(casts.CTimeCyc.curr_weather[0])
            if imgui.Combo("Clima atual", weather,module.tvisual.timecyc.weather.array,#module.tvisual.timecyc.weather.names) then
                if module.tvisual.lock_weather[0] then
                    printHelpString("Clima bloqueado!")
                else
                    casts.CTimeCyc.curr_weather[0] = weather[0]
                    printHelpString("Clima atual definido")
                end
            end

            weather = imgui.new.int(casts.CTimeCyc.next_weather[0])
            if imgui.Combo("Próximo clima", weather,module.tvisual.timecyc.weather.array,#module.tvisual.timecyc.weather.names) then
                if module.tvisual.lock_weather[0] then
                    printHelpString("Clima bloqueado!")
                else
                    casts.CTimeCyc.next_weather[0] = weather[0]
                    printHelpString("Próximo clima definido!")
                end
            end
            imgui.Spacing()

            if fcommon.BeginTabBar('Timecyc') then
                if fcommon.BeginTabItem('Cores') then
                    if imgui.ColorEdit3("Ambiente",module.tvisual.timecyc.ambient) then
                        casts.CTimeCyc.ambient_red[val]   = module.tvisual.timecyc.ambient[0]*255
                        casts.CTimeCyc.ambient_green[val] = module.tvisual.timecyc.ambient[1]*255
                        casts.CTimeCyc.ambient_blue[val]  = module.tvisual.timecyc.ambient[2]*255
                    end
                    fcommon.InformationTooltip("Cor ambiente em objetos estáticos do mapa")
    
                    if imgui.ColorEdit3("Objeto",module.tvisual.timecyc.ambient_obj) then
                        casts.CTimeCyc.ambient_obj_red[val]   = module.tvisual.timecyc.ambient_obj[0]*255
                        casts.CTimeCyc.ambient_obj_green[val] = module.tvisual.timecyc.ambient_obj[1]*255
                        casts.CTimeCyc.ambient_obj_blue[val]  = module.tvisual.timecyc.ambient_obj[2]*255
                    end
                    fcommon.InformationTooltip("Cor ambiente em objetos dinâmicos do mapas")
    
                    if imgui.ColorEdit3("Nuvens",module.tvisual.timecyc.fluffy_clouds) then
                        casts.CTimeCyc.fluffy_clouds_red[val]   = module.tvisual.timecyc.fluffy_clouds[0]*255
                        casts.CTimeCyc.fluffy_clouds_green[val] = module.tvisual.timecyc.fluffy_clouds[1]*255
                        casts.CTimeCyc.fluffy_clouds_blue[val]  = module.tvisual.timecyc.fluffy_clouds[2]*255
                    end
    
                    if imgui.ColorEdit3("Nuvens baixas",module.tvisual.timecyc.low_clouds) then
                        casts.CTimeCyc.low_clouds_red[val]   = module.tvisual.timecyc.low_clouds[0]*255
                        casts.CTimeCyc.low_clouds_green[val] = module.tvisual.timecyc.low_clouds[1]*255
                        casts.CTimeCyc.low_clouds_blue[val]  = module.tvisual.timecyc.low_clouds[2]*255
                    end
    
                    if imgui.ColorEdit4("Postfx 1",module.tvisual.timecyc.postfx1) then
                        casts.CTimeCyc.postfx1_red[val]   = module.tvisual.timecyc.postfx1[0]*255
                        casts.CTimeCyc.postfx1_green[val] = module.tvisual.timecyc.postfx1[1]*255
                        casts.CTimeCyc.postfx1_blue[val]  = module.tvisual.timecyc.postfx1[2]*255
                        casts.CTimeCyc.postfx1_alpha[val] = module.tvisual.timecyc.postfx1[3]*255
                    end
                    fcommon.InformationTooltip("Correção de cor 1")
    
                    if imgui.ColorEdit4("Postfx 2",module.tvisual.timecyc.postfx2) then
                        casts.CTimeCyc.postfx2_red[val]   = module.tvisual.timecyc.postfx2[0]*255
                        casts.CTimeCyc.postfx2_green[val] = module.tvisual.timecyc.postfx2[1]*255
                        casts.CTimeCyc.postfx2_blue[val]  = module.tvisual.timecyc.postfx2[2]*255
                        casts.CTimeCyc.postfx2_alpha[val] = module.tvisual.timecyc.postfx2[3]*255
                    end
                    fcommon.InformationTooltip("Correção de cor 2")
    
                    if imgui.ColorEdit3("Céu",module.tvisual.timecyc.sky_bottom) then
                        casts.CTimeCyc.sky_bottom_red[val]   = module.tvisual.timecyc.sky_bottom[0]*255
                        casts.CTimeCyc.sky_bottom_green[val] = module.tvisual.timecyc.sky_bottom[1]*255
                        casts.CTimeCyc.sky_bottom_blue[val]  = module.tvisual.timecyc.sky_bottom[2]*255
                    end
                    
                    if imgui.ColorEdit3("Núcleo do sol",module.tvisual.timecyc.sun_core) then
                        casts.CTimeCyc.sun_core_red[val]   = module.tvisual.timecyc.sun_core[0]*255
                        casts.CTimeCyc.sun_core_green[val] = module.tvisual.timecyc.sun_core[1]*255
                        casts.CTimeCyc.sun_core_blue[val]  = module.tvisual.timecyc.sun_core[2]*255
                    end
    
                    if imgui.ColorEdit3("Sun corona",module.tvisual.timecyc.sun_corona) then
                        casts.CTimeCyc.sun_corona_red[val]   = module.tvisual.timecyc.sun_corona[0]*255
                        casts.CTimeCyc.sun_corona_green[val] = module.tvisual.timecyc.sun_corona[1]*255
                        casts.CTimeCyc.sun_corona_blue[val]  = module.tvisual.timecyc.sun_corona[2]*255
                    end
    
                    if imgui.ColorEdit3("Sky top",module.tvisual.timecyc.sky_top) then
                        casts.CTimeCyc.sky_top_red[val]   = module.tvisual.timecyc.sky_top[0]*255
                        casts.CTimeCyc.sky_top_green[val] = module.tvisual.timecyc.sky_top[1]*255
                        casts.CTimeCyc.sky_top_blue[val]  = module.tvisual.timecyc.sky_top[2]*255
                    end
    
                    if imgui.ColorEdit4("Água",module.tvisual.timecyc.water) then
                        casts.CTimeCyc.water_red[val]   = module.tvisual.timecyc.water[0]*255
                        casts.CTimeCyc.water_green[val] = module.tvisual.timecyc.water[1]*255
                        casts.CTimeCyc.water_blue[val]  = module.tvisual.timecyc.water[2]*255
                        casts.CTimeCyc.water_alpha[val]  = module.tvisual.timecyc.water[3]*255
                    end
                end
                if fcommon.BeginTabItem('Misc') then
                    imgui.PushItemWidth(imgui.GetWindowContentRegionWidth()/2)
                if imgui.SliderInt("Nuvem Alfa", module.tvisual.timecyc.cloud_alpha, 0, 255) then
                    casts.CTimeCyc.cloud_alpha[val]   = module.tvisual.timecyc.cloud_alpha[0]
                end

                if imgui.SliderInt("Multidirecional", module.tvisual.timecyc.directional_mult, 0, 255) then
                    casts.CTimeCyc.directional_mult[val]   = module.tvisual.timecyc.directional_mult[0]
                end
                fcommon.InformationTooltip("Luz em peds & veículo")

                if imgui.SliderInt("Far clip", module.tvisual.timecyc.far_clip, 0, 2000) then
                    casts.CTimeCyc.far_clip[val]   = module.tvisual.timecyc.far_clip[0]
                end
                fcommon.InformationTooltip("Alcanse de visibilidade")

                if imgui.SliderInt("Intensidade mínima de luz alta", module.tvisual.timecyc.high_light_min_intensity, 0, 255) then
                    casts.CTimeCyc.high_light_min_intensity[val]   = module.tvisual.timecyc.high_light_min_intensity[0]
                end
                fcommon.InformationTooltip("Limite de intensidade de radiosity do PS2")

                if imgui.SliderInt("Início de nevoeiro", module.tvisual.timecyc.fog_start, 0, 2000) then
                    casts.CTimeCyc.fog_start[val]   = module.tvisual.timecyc.fog_start[0]
                end

                if imgui.SliderInt("Luz no brilho do sol", module.tvisual.timecyc.lights_on_ground_brightness, 0, 255) then
                    casts.CTimeCyc.lights_on_ground_brightness[val]   = module.tvisual.timecyc.lights_on_ground_brightness[0]
                end

                if imgui.SliderInt("Intensidade da sombra clara", module.tvisual.timecyc.light_shadow_strength, 0, 255) then
                    casts.CTimeCyc.light_shadow_strength[val]   = module.tvisual.timecyc.light_shadow_strength[0]
                end

                if imgui.SliderInt("Força da sombra do poste", module.tvisual.timecyc.pole_shadow_strength, 0, 255) then
                    casts.CTimeCyc.pole_shadow_strength[val]   = module.tvisual.timecyc.pole_shadow_strength[0]
                end

                if imgui.SliderInt("Força das sombras", module.tvisual.timecyc.shadow_strength, 0, 255) then
                    casts.CTimeCyc.shadow_strength[val]   = module.tvisual.timecyc.shadow_strength[0]
                end

                if imgui.SliderInt("Brilho do sprite", module.tvisual.timecyc.sprite_brightness, 0, 127) then
                    casts.CTimeCyc.sprite_brightness[val]   = module.tvisual.timecyc.sprite_brightness[0]
                end

                if imgui.SliderInt("Tamanho do sprite", module.tvisual.timecyc.sprite_size, 0, 127) then
                    casts.CTimeCyc.sprite_size[val]   = module.tvisual.timecyc.sprite_size[0]
                end
                
                if imgui.SliderInt("Tamanho do sol", module.tvisual.timecyc.sun_size, 0, 127) then
                    casts.CTimeCyc.sun_size[val]   = module.tvisual.timecyc.sun_size[0]
                end

                if imgui.SliderInt("Neblina na água", module.tvisual.timecyc.waterfog_alpha, 0, 255) then
                    casts.CTimeCyc.waterfog_alpha[val]   = module.tvisual.timecyc.waterfog_alpha[0]
                end
                end
                fcommon.EndTabBar()
            end
        end
        fcommon.EndTabBar()
    end
end

return module