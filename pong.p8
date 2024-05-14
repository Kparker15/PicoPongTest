pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	scene:loadscn(gamescene)
end

function _update60()
	scene.current:update()
end

function _draw()
	scene.current:draw()
end
-->8
-- utilities
gbl=_ENV
noop=function()end

p1config={
	up=⬆️,
	down=⬇️,
	serve=❎,
	xpos=12,
}

p2config={
	up=⬅️,
	down=➡️,
	serve=🅾️,
	xpos=113,
}

setplayer=function(p,cfg)
		p.up=cfg.up
		p.down=cfg.down
		p.serve=cfg.serve
		p.x=cfg.xpos
end
-->8
-- class
class=setmetatable({
	extend=function(self,tbl)
		tbl=tbl or {}
		tbl.__index=tbl
		return setmetatable(tbl,{
				__index=self,
				__call=function(self,...)
					return self:new(...)
				end
			})
	end,
	
	new=function(self,tbl)
		tbl=setmetatable(tbl or {}, self)
		tbl:init()
		return tbl
	end,
	
	init=noop,
},{__index=_ENV})



-->8
-- entities
entity=class:extend({
	-- class
	pool={},
	
	extend=function(_ENV,tbl)
		tbl=class.extend(_ENV,tbl)
		return tbl
	end,
	
	each=function(_ENV,method,...)
		for e in all(pool) do
			if (e[method]) e[method](e,...) 
		end
	end,
	
	--instance
	x=0,y=0,
	w=8,h=8,
	
	init=function(_ENV)
		add(entity.pool,_ENV)
		if pool != entity.pool then
			add(pool,_ENV)
		end
	end,
	
	detect=function(_ENV,other,callback)
		if collide(_ENV, other) then
			callback(_ENV)
		end
	end,
	
	collide=function(_ENV,other)
		return x<other.x+other.w and
			x+w>other.x and
			y<other.y+other.h and
			h+y>other.y
	end,
	
	destroy=function(_ENV)
		del(entity.pool,_ENV)
		if pool != entity.pool then
			del(pool,_ENV)
		end
	end,
})

paddle=entity:extend({
	up,down,serve,
	x=0,
	y=53,
	w=2,
	h=20,
	dy=2,
	col=7,
	
	update=function(_ENV)
		nexty=y
		
		if btn(up) then
			nexty-=dy
		elseif btn(down) then
			nexty+=dy
		end
		
		if btn(up) and btn(down) then
			nexty=y
		end
		
		y=nexty
		y=mid(0,y,127-h)
	end,
	
	draw=function(_ENV)
		rectfill(x,y,x+w,y+h,col)
	end,
})

ball=entity:extend({
	x=33,
	y=63,
	h=4,
	w=4,
	dx=1,
	dy=1,
	rad=2,
	col=10,
	
	update=function(_ENV)
		nextx=x
		nexty=y
		
		if x>=127-rad or x<=rad then
			nextx=mid(rad,nextx,127-rad)
			dx=-dx
		end
		if y>=127-rad or y<=rad then
			nexty=mid(rad,nexty,127-rad)
			dy=-dy
		end
		
		nextx=dx
		nexty=dy
		
		x+=nextx
		y+=nexty
	end,
	
	draw=function(_ENV)
		circfill(x,y,rad,col)
	end,
	
	collide=function(_ENV,other)
		if y-rad>other.y+other.h then return false end
		if y+rad<other.y then return false end
		if x-rad>other.x+other.w then return false end
		if x+rad<other.x then	return false end
		return true
	end,
	
	dflx=function(_ENV,other)
		
	end,
	
})

-->8
-- scene
scene=class:extend({
	current=nil,
	
	update=noop,
	draw=noop,
	
	destroy=function(_ENV)
		entity:each("destroy")
	end,
	
	loadscn=function(_ENV,scn)
		if current != scn then
			if(current) current:destroy()
			current=scn()
		end
	end,
})

titlescene=scene:extend({

})

gamescene=scene:extend({
	init=function(_ENV)
		cls(1)
		p1=paddle()
		p2=paddle()
		
		gball=ball()
		
		setplayer(p1,p1config)
	 setplayer(p2,p2config)
	end,
	
	update=function(_ENV)
		entity:each("update")
		ball:each("detect",p1,function(obj)
			sfx(0)
		end)
	end,
	
	draw=function(_ENV)
		cls(1)
		entity:each("draw")
		print(tostr(p1.y),p1.x-12,p1.y,8)
		print(tostr(p2.y),p2.x+4,p2.y,8)
	end,
})

endscene=scene:extend({

})
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000025150271502a1503015038150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
