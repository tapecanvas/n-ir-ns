-- thanks to:
-- lines forum, @hankyates,
-- and @tyleretters
--------------------
-- N(IR)NS
-- convolution 
-- cross-synthesis
--------------------
-- >> k1: exit
-- >> k2: 
-- >> k3: 
-- >> e1:
-- >> e2: dry signal
-- >> e3: wet signal

engine.name = 'Nirns'
--fileselect = require 'fileselect'
ControlSpec = require "controlspec"
Formatters = require "formatters"


function init()
  message = "N(IR)NS" 
  screen_dirty = true 
  redraw_clock_id = clock.run(redraw_clock) 

  params:add{type = "control", id= "dry", name = "dry", controlspec = ControlSpec.new(0.00, 1.00, 'lin', 0.01, 0.50, '%', 1/(1/.01)), action = function(value)
    engine.dry(value)
    screen_dirty=true
  end}
  
  params:add{type = "control", id = "wet", name = "wet", controlspec = ControlSpec.new(0.00, 1.00,'lin', 0.01, 0.50, '%', 1/(1/.01)), action = function(value)
    engine.wet(value)
    screen_dirty=true
  end}
  
  params:bang()


end


-- screen:

function redraw_clock() ----- a clock that draws space
  while true do ------------- "while true do" means "do this forever"
    clock.sleep(1/15) ------- pause for a fifteenth of a second (aka 15fps)
    if screen_dirty then ---- only if something changed
      redraw() -------------- redraw space
      screen_dirty = false -- and everything is clean again
    end
  end
end

function redraw()
  screen.clear()
  screen.aa(0) ----------------- enable anti-aliasing
  screen.font_face(24) ---------- set the font face to "04B_03"
  screen.font_size(10) ---------- set the size to 8
  screen.level(15) ------------- max
  screen.move(64, 15) ---------- move the pointer to x = 64, y = 32
  screen.text_center(message) -- center our message at (64, 32)
  screen.pixel(0, 0) ----------- make a pixel at the north-western most terminus
  screen.pixel(127, 0) --------- and at the north-eastern
  screen.pixel(127, 63) -------- and at the south-eastern
  screen.pixel(0, 63) ---------- and at the south-western
  screen.fill() ---------------- fill the termini and message at once
  screen.update() -------------- update space

  screen.move(10,30)
  screen.text("dry: ")
  screen.move(118,30)
  screen.text_right(params:string("dry"))


  screen.move(10,40)
  screen.text("wet: ")
  screen.move(118,40)
  screen.text_right(params:string("wet", "%"))

  screen.update()
end


--keys:

-- testing spectrum clear
function key(n, z)
  if z == 1 then
    if n == 2 then
    elseif n == 3 then
    end
  end
end

-- encoders:

-- adjust wet/dry mix
function enc(n, delta)
    if n == 2 then  
      params:delta("dry", delta)
      redraw()
     -- engine.dry(delta)       
    elseif n == 3 then
      params:delta("wet", delta)
      redraw()
    --  engine.wet(delta)
  end
end


function r() ----------------------------- execute r() in the repl to quickly rerun this script
  norns.script.load(norns.state.script) -- https://github.com/monome/norns/blob/main/lua/core/state.lua
end


function cleanup() --------------- cleanup() is automatically called on script close
  clock.cancel(redraw_clock_id) -- melt our clock vie the id we noted
end