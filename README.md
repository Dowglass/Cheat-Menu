# A versão oficial em lua está descontinuada. Novas versões oficiais estão no [repositório oficial](https://github.com/user-grinch/Cheat-Menu).
<p align="center">
  <img width="400" height="250" src="https://i.imgur.com/fZ71SbF.png">
</p>

#
![GitHub repo size](https://img.shields.io/github/repo-size/user-grinch/Cheat-Menu?label=Size&style=for-the-badge)
[![Licensa](https://img.shields.io/github/license/user-grinch/Cheat-Menu?style=for-the-badge)](https://github.com/user-grinch/Cheat-Menu/blob/master/LICENSE)
[![Discord](https://img.shields.io/discord/689515979847237649?label=Discord&style=for-the-badge)](https://discord.gg/ZzW7kmf)

[![MixMods](https://img.shields.io/badge/Topic-Mixmods-%234e4784?style=for-the-badge)](https://forum.mixmods.com.br/f5-scripts-codigos/t1777-lua-cheat-menu)
[![GTAF](https://img.shields.io/badge/Topic-GTA%20Forums-%23244052?style=for-the-badge)](https://gtaforums.com/topic/961636-moon-cheat-menu/)
## Introdução

O Cheat Menu permite que um grande conjunto de modificações/truques, permitindo uma jogabilidade muito mais fácil e divertida.

É baseado no [Moonloader](https://gtaforums.com/topic/890987-moonloader/) e usa [mimgui](https://github.com/THE-FYP/mimgui) como interface.

## Versões oficiais

### Releases
[Releases](https://github.com/inanahammad/Cheat-Menu/releases) são as versões atualizadas e estáveis. Se você deseja uma experiência tranquila com o mínimo de erros possível, esse e o recomendado.

### Master Branch
[Master branch](https://github.com/inanahammad/Cheat-Menu) contém a versão mais recente do cheat menu e é traduzida [aqui](https://github.com/Dowglass/Cheat-Menu). Embora essa seja a melhor forma para uma boa gameplay e experimentar os recursos mais recentes, ela pode vir com alguns bugs.

### Cheat menu
[Cheat menu](https://github.com/user-grinch/Cheat-Menu/tree/master) versão oficial **(atualmente descontinuada)**.

## Instalação:

1. Instale [DirectX](https://www.microsoft.com/en-us/download/details.aspx?id=35) e [Visual C++ Redistributable 2017](https://aka.ms/vs/16/release/vc_redist.x86.exe) se ainda não estiver instalado.
2. Se a sua versão do jogo não for a v1.0, será necessário fazer [downgrade](https://gtaforums.com/topic/927016-san-andreas-downgrader/).
3. Baixe o [Moonloader](https://gtaforums.com/topic/890987-moonloader/) [aqui](https://blast.hk/moonloader/files/moonloader-026.zip). Em seguida, extraia os arquivos para a pasta do jogo (substitua, se necessário).
4. Baixe o Cheat Menu [aqui](https://github.com/Dowglass/Cheat-Menu).
5. Abra o arquivo e extraia tudo no diretório do jogo (substitua, se necessário).

No jogo, pressione <kbd>Ctrl</kbd> + <kbd>M</kbd>. Se não funcionar, crie uma postagem em um dos tópicos no [repositório oficial](https://github.com/user-grinch/Cheat-Menu) com 'moonloader.log'. 

## Youtubers

Se você estiver criando vídeos sobre esse mod, não faça o upload em outro lugar. Coloque o link do [repositório oficial](https://github.com/user-grinch/Cheat-Menu). Isso ajudará o autor a fornecer um melhor suporte e desenvolvimento. Também seria ótimo se você mantivesse o nome do autor (Grinch_) na descrição do seu vídeo.

## Imagens (EN)
![1](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/teleport.gif)
![2](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/player.gif)
![3](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/ped.gif)
![4](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/animation.gif)
![5](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/vehicle.gif)
![6](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/weapon.gif)
![7](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/game.gif)
![8](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/visual.gif)
![9](https://raw.githubusercontent.com/user-grinch/user-grinch.github.io/master/assets/img/mods/cheat-menu/menu.gif)
(By: Grinch_).

## Documentação 

### Adicionando imagens personalizadas de peds/skin - jpg

Imagens de ped/skin são carregadas em '\moonloader\lib\cheat-menu\peds\'. O nome da imagem deve conter o ID do modelo ped. Os nomes dos peds personalizados devem ser adicionados no arquivo ped.json em '\moonloader\lib\cheat-menu\json\ped.json'.

### Adicionando skins personalizadas #2

Você também pode adicionar skins de jogadores (semelhante ao skin selector). Coloque os arquivos txd e dff dentro da pasta 'modloader\Custom Skins\'. Nota, o uso do [Modloader](https://gtaforums.com/topic/669520-mod-loader/) é obrigatório e os nomes não podem exceder de 8 caracteres.

### Adicionando imagens de veículo personalizadas - jpg

As imagens do veículo são carregadas em '\moonloader\lib\cheat-menu\vehicles\images\'. O nome da imagem deve conter o ID do modelo do veículo. Você não precisa adicionar nomes de veículos personalizados na v2.0-beta e adiante.

### Adicionando imagens personalizadas nos componentes de veículos - jpg

As imagens dos componentes do veículo são carregadas em '\moonloader\lib\cheat-menu\vehicles\component\'. O nome da imagem deve conter o ID do modelo do componente.

### Adicionando imagens de pintura de veículos personalizados - png

As imagens são carregadas em '\moonloader\lib\cheat-menu\vehicles\paintjobs\'. Os nomes das imagens podem ser qualquer sequência e o nome deles será exibido no menu.

### Adicionando imagens de armas personalizadas - jpg

As imagens de armas são carregadas em '\moonloader\lib\cheat-menu\weapons\'. O nome da imagem deve conter o ID do modelo da arma. Nomes de armas personalizadas devem ser adicionados no arquivo weapon.json em '\moonloader\lib\cheat-menu\json\weapon.json'.

### Adicionando roupas personalizadas - jpg

Imagens de roupas são carregadas em '\moonloader\lib\cheat-menu\clothes\'. O nome da imagem deve neste formato 'body_part$model_name$texture_name'
