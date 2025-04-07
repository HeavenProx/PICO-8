pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	draw_map()
	create_player()
end


function _update()
	update_camera()
	if not messages[1] then
		move()
	end
	update_msg()
	
	if btnp(❎) then
		shoot()
	end

	for arrow in all(arrows) do
		arrow.x += arrow.dir
	end
end

function _draw()
	cls()
	map()
	draw_player()
	draw_ui()
	draw_msg() 

	for arrow in all(arrows) do
		spr(arrow.sp, arrow.x, arrow.y, 1, 1, arrow.flip)
	end
end


-->8
-- player
arrows = {}
messages = {}

function create_player()
	p = {
		sprite=1,
		x=2,
		y=4,
		largeur=8,
		hauteur=8,
		keys=0,
		life=100,
		flip=false
	}
end

function draw_player() 
	palt(0, false)
	palt(14, true)
 spr(p.sprite,p.x*8,p.y*8,1,1,p.flip)
	palt()
end

function shoot()
 add(arrows, {
 	x = p.x * 8,
 	y = p.y * 8,
  sp = 2,  
  dir = p.flip and -2 or 2, 
  flip = p.flip 
 })
 sfx(0)
end


function move()
  local speed = 1 
  local newx = p.x
  local newy = p.y

  if btnp(⬅️) then 
   newx -= speed
   p.flip = true
  end
  if btnp(➡️) then 
   newx += speed
   p.flip = false
  end
  if btnp(⬆️) then 
   newy -= speed 
  end
  if btnp(⬇️) then 
   newy += speed 
  end
  
  interact(newx,newy)

  if not check_flag(0, newx, newy) then
   p.x = mid(0,newx,127) 
   p.y = mid(0,newy,63)    
  end
end

function interact(x,y)
	if check_flag(1,x,y) then
		pick_up_key(x,y)
	elseif check_flag(2,x,y) then
		if p.keys>=1 then
			open_door(x,y)
			p.keys-=1
		else 
			sfx(3)
			create_msg("porte",
			"il te faut une cle pour\nrentrer ici. reviens quand",
			"tu en auras trouver une")
		end
	end
	if x==8 and y==5 then
		create_msg("panneau", 
	"bienvenu aventurier !\npour eradiquer le mal de ce",
	"monde, tu devras battres les\nmonstres et venir a bout des",
 "donjons... que la force soit\navec toi !")
	end
	if x==4 and y==12 then
		create_msg("ezia", 
	"excusez moi, les monstres ont\nprit possession de nos biens",
	"et ont enleve la princesse,\naide nous a la retrouver !")
	end
	if x==16 and y==1 
	and not(key_yellow) then
		create_msg("infos", 
	"les cles jaunes ne servent\nqu'a ouvrir les portes des",
	"batiments. elles ne\npermettront pas d'ouvrir les",
	"donjons ! tu decouvriras bien\nvite comment le faire...")
	key_yellow=true
	end
end

function next_tile(x,y)
	sprite = mget(x,y)
	mset(x,y,sprite+1)
end

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	sfx(01)
end

function open_door(x,y)
	next_tile(x,y)
	sfx(02)
end
-->8
-- map 

function draw_map()
	map(0,0,0,0,128,64)
end

function check_flag(flag, x, y) 
 local sprite = mget(x, y)
 return fget(sprite, flag)
end

function update_camera()
	-- flr arrondi en bas
	camx=flr(p.x/16)*16
	camy=flr(p.y/16)*16
	camera(camx*8,camy*8)
end

function follow_camera()
	camx=mid(0,p.x-7.5,127-119)
	camy=flr(0,p.y-7.5,127-119)
	camera(camx*8,camy*8)
end
-->8
-- ui

function draw_ui()
	camera()
	palt(0, false)
	palt(14, true)
	spr(24, 2, 3)
	palt()
	print_outline("X"..p.keys,10,3)
end

function print_outline(text,x,y)
	print(text,x+1,y,0)
	print(text,x-1,y,0)
	print(text,x,y+1,0)
	print(text,x,y-1,0)
	print(text,x,y,7)
end
-->8
--messages

function init_msg()
	messages={}
end

function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if (btnp(🅾️)) then
		deli(messages,1)
	end
end

function draw_msg()
	if messages[1] then
		local y=100
		if p.y%16>9 then
			y=10
		end
		-- # est pour la longueur
		rectfill(7,y,11+#msg_title*4,
		y+7,2)
		print(msg_title,10,y+2,9)
		
		rectfill(3,y+8,124,y+24,4)
		rect(3,y+8,124,y+24,2)
		print(messages[1],6,y+11,15)
	end
end
__gfx__
00000000e000e9ee000000000000000000000000000000000000000033333333333333333333333333bbbb334444444466644444444446664444444444444444
0000000000000e9e00000000000000000000000000000000000000003999999333333333333333333bbaabb34444444464644444444446464444444444444444
007007000f505e9e00000000000000000000000000000000000000003444444333a33333333333333bbbab13cccccccc666466644666466644a4444444444444
00077000effffefe7446000000000000000000000000000000000000342242433a3aaaa3333333333bbbb3131111111146444444444444644a4aaaa444444444
000770000000009e00000000000000000000000000000000000000003444444333a33a3333333333313b331311111111464444444444446444a44a4444444444
00700700f0000e9e0000000000000000000000000000000000000000331332333333333333333333331111331111111166646664466646664111111441111114
00000000e00009ee0000000000000000000000000000000000000000334334333333333333333333333223331111111164644444444446464411114444111144
00000000efeefeee0000000000000000000000000000000000000000333333333333333333333333331442331111111166644444444446664111111441111114
0000000034444433000000000000000000000000000000000000000000000000ee0eeeee33333333333bb3331111111144444444666446666666656666666566
0000000044ffff43000000000000000000000000000000000000000000000000e0a0000e37333333333ba3331111111144644644646666466666656666666656
0000000044f0f0430000000000000000000000000000000000000000000000000a0aaaa07973333333b3ab331111111144644644666446665555555555665575
0000000044ffff43000000000000000000000000000000000000000000000000e0a00a0e373333333133bbb31111111144644644444444445777777756565767
0000000033888833000000000000000000000000000000000000000000000000ee0ee0ee3333373313333bbb1111111144444444446446445766666665757666
0000000038c57c33000000000000000000000000000000000000000000000000eeeeeeee33337973311111131111111166644666446446445766666665666666
0000000038cccc33000000000000000000000000000000000000000000000000eeeeeeee33333733333223331111111164666646446446445555555567556665
0000000033633633000000000000000000000000000000000000000000000000eeeeeeee33333333331442331111111166644666444444447777757766675656
00000000344444330000000000000000000000000000000000000000000000000000000033333333333333330000000066444466444444444444441115555551
0000000034fff443000000000000000000000000000000000000000000000000000000003333373333bb333b000000006646646644444444444444551555a551
00000000330f0f430000000000000000000000000000000000000000000000000000000033337873333b33bb0000000044444444444444444444445544444444
0000000033ffff4300000000000000000000000000000000000000000000000000000000333337333b3bb3b30000000044444444444444444444445a44444444
000000003399993300000000000000000000000000000000000000000000000000000000373333333bb3bbb30000000044444444444444444444445544444444
000000003397e933000000000000000000000000000000000000000000000000000000007873333333b3bb330000000044444444444444444444445544444444
0000000033999933000000000000000000000000000000000000000000000000000000003733333333b3bb330000000066466466444444444444445544444444
00000000336336330000000000000000000000000000000000000000000000000000000033333333333333330000000066444466444444444444441144444444
00000000000000000000000000000000000000000000000000000000000000000000000055555555333333330000000000000000000000001166661116620000
00000000000000000000000000000000000000000000000000000000000000000000000056555556333333330000000000000000000000004405050444520000
00000000000000000000000000000000000000000000000000000000000000000000000055555555333333330000000000000000000000006405050465520000
00000000000000000000000000000000000000000000000000000000000000000000000055556555333333b30000000000000000000000006444444465120000
000000000000000000000000000000000000000000000000000000000000000000000000555555553bb33bb30000000000000000000000004444441444a20000
0000000000000000000000000000000000000000000000000000000000000000000000005556555633b33b330000000000000000000000006444449464420000
0000000000000000000000000000000000000000000000000000000000000000000000005655555533b333330000000000000000000000006424444464200000
00000000000000000000000000000000000000000000000000000000000000000000000055555555333333330000000000000000000000004224242442200000
0033b3b33b3333b3bb33b3000000000044444444000000000000b333333300000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333300000000444444440000000000bb3333333333000000000000000000000000000000000000000000000000000000000000000000
33443334334433343344333400000000444444440000044400333333333333300000000000000000000000000000000000000000000000000000000000000000
44444344444443444444434400033000444444440004440003333bbb33333bb30000000000000000000000000000000000000000000000000000000000000000
444444444444444444444444300300304444444444444000033bbb33bbb333bb0000000000000000000000000000000000000000000000000000000000000000
064444666644446666444460030303304444444444440000333b333333bb333b0000000000000000000000000000000000000000000000000000000000000000
0556566565565665655656600333030044444444400000003b333333333333330000000000000000000000000000000000000000000000000000000000000000
0055555555555555555555000333333044444444000000003b333333333333330000000000000000000000000000000000000000000000000000000000000000
00000000ab3338b300000000000000000000000000000000333bb333333b33bb0000000000000000000000000000000000000000000000000000000000000000
0000000033a3833800000000000000000000000000000000bbbb333333bb33b30000000000000000000000000000000000000000000000000000000000000000
000000003a44383400000000000000000000000044400000333333b33bb333330000000000000000000000000000000000000000000000000000000000000000
00000000444443440000000000000000000000000044400033bb33b3333333330000000000000000000000000000000000000000000000000000000000000000
000000004444444400000000000070000000000400044444033b33b33333bb300000000000000000000000000000000000000000000000000000000000000000
0000000066444466000000000007a700000000440000044403bb33bbbbbbb3300000000000000000000000000000000000000000000000000000000000000000
00000000655656650000000003037000000004440000000400b3333bbb3333000000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000330000000444440000000000003333333300000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc00000000000000000000000004444000333bb333000000000000000000000000000000000000000000000000000000000000000000000000
0000000033cccc33000000000000000000000000004440003bbb3333000000000000000000000000000000000000000000000000000000000000000000000000
00000000334433340000000000000000000000000004440033333333000000000000000000000000000000000000000000000000000000000000000000000000
000000004444434400000000000700000000000000044440333333b3000000000000000000000000000000000000000000000000000000000000000000000000
000000004444444400000000007870004000000000004444333333b3000000000000000000000000000000000000000000000000000000000000000000000000
000000006644446600000000000733004400000000000444333333bb000000030000000000000000000000000000000000000000000000000000000000000000
00000000655656650000000000000300444000000000004433333333000000330000000000000000000000000000000000000000000000000000000000000000
00000000555555550000000000003300444440000000000433333333000003bb0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000b333333300000444333bb333000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003344433300004440bb8b3333000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000444444440004440033333383000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000444444440444400033bb33b3000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000004444444444440000333b83b3300000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000444444444440000038bb33bb330000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000444444444400000033b3333bbbb000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000004444444440000000bbb33333333330000000000000000000000000000000000000000000000000000000000000000000
90909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090000000000000000000000000000000000000
__gff__
0000000000000001020001010000030100010000000000000200010100000101000100000000000000000000000005000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1b1b1b1b0a0a0a090a0a0a0a0a0a0a0a0a0a0a0a0a1b1b1b0a0a0a0a0a0a0a29090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b1b2a2a2a2a09090909090a0a0a0a082a2a09092c2c0909093a093a090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b3a2a2a3a090909092929290a0a0a0a2a3a090b1b1b090909090909090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b0909093a09090909090a292929090a0a3a3a0a1b1b09090909093a0a0a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a3a090909090909090a0a0a292929090a0a0a0a1b1b09291909090a0a090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a3a3a090909090907090a0a0a0909090909091d1d1d09193a09090909090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0929090909090909092909090909093a09091c1c1c093a09093a09093a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a090909190909090909090909090b0b0b0b0b1b1b1b0909090909093a3a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a1919090a09090a0b0b0b0b0b1b1b1b1b1b1b1b09090909093a0909090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a09090b0c0d0b1b1b1b1b1b1b1b09090909093a3a091a1a090929090909090909090909090909090909090900000000000000000000000000000000000000006746664700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b1b0c0d1b1b1b3a3a090909090909093a09091a1a1a1a091919090a0a0909090909090909090909090900000000000000000000000000000000000000467666667600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b1b1b1b1b090909093a3a090a0a2a090909090909091a1a1a090909090a0a0a0909090909090909090909090900000000000000000000000000000000000000766666765700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a09090911090909090909090a0a0a09093a3a0919093a091a090909090a0a0a090909090909090909090909090900000000000000000000000000000000000000565774750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a2a093a0909090909192919090a2a2a2a092a3a3a09090909090909090a0a09090909090909090909090909090900000000000000000000000000000000000000005544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a2a2a0a0909090909291909093a2a2a091a1a19093a092a3a0909090a0a090909090909090909090909090909090000000000000000000000000000000000000000544464534300530b004300634300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a2a2a0a0a0a3a093a3a0909093a2a2a091a1a1a3a093a2a2a09090a0a090929090909090909090909090909090900000000000000000000000000000000000000405141414151614141415151414161420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a3a3a090a0a09093a3a09090909090909091a1a1a09093a09090a0a0a3a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a3a09090a0a0909092a09090a0909090909091a1a09090909090a0a0a3a2a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a2a3a09090a0929093a3a0a0a0a092a093a2a2a1a0909090909090a09192a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a2a3a09092a0909093a0a0a091919193a091a1a092a3a2909090a0a0a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a0909090909093a0909090a3a09091a1a1a09090909090909090a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e1f1f1e1e3a09090909093a090a0a0909091a3a09090909090b0b093a3a0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1f2d2d2d1f09093a09090909093a09093a0929090909192a0b1b1b0b093a3a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1f0e2d2d2e090919093a09090909092929090909093a09092a1b1b1b09090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e2d2d2d1e090909093a09092a090a0a0a0a09290909090909091b1b29090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e1f1f1e1f093a091a1a1a0909090a0a0a0a092a090909091909093a3a090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a0909092a1a1a0a3a09090909092a09090929090a3a09093a09093a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a090909091a0a0a0a3a3a3a0909093a09090a0a0a090909092a093a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a09090909090a0a0a09090909090909090a0a092a0909093a2a09191a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a093a0909090a0a0a09193a090909093a0a0a3a3a0909093a09091a1a1a09090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a0929193a0909090a0909192a3a0909090a0a093a09093a0909091a1a090909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2909092909090909090909090929092909090909090909091a1a1a1a09090929090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300001d5101c5101b5101a510121001d70018700127000f7001400012000100000e0000d0000c000150001900007000080000b0000e000100001100015000180001b0001e0002200026000290002c0002f000
000300002201024010260103050033500280102b01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900001b12017100211200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d00000a15009100081500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000030250302503025030250302502f2502f2502e2502d2502b25029250232501f2501b250152501425019050150501405012050120501305000000000000000000000000000000000000000000000000000
