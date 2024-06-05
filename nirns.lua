-- N(IR)NS
-- v0.1.1
-- convolution 
-- cross-synthesis
--------------------
-- controls
-- >> e2: dry signal
-- >> e3: wet signal
-- params
-- >> load IR
--------------------
-- thanks @hankyates  

local engine.name = 'Nirns'
local ControlSpec = require "controlspec"
local Formatters = require "formatters"
local fileselect = require 'fileselect'
local file = "/home/we/dust/audio/ir/bottledungeon.wav"


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

  params:add{type="file", id="ir_file", name="file",
  action = function(file)
          print("Action function called")  -- Print a message when the function is called
    -- if file ~= "cancel" then
    --   print("Selected file: " .. file)  -- Print the selected file
    --   engine.ir_file(file)
    --   screen_dirty=true
  if file == "-" then
          -- Load the default IR file
   local default_file = "/home/we/dust/audio/ir/bottledungeon.wav"
   print("Loading default IR file: " .. default_file)
   engine.ir_file(default_file)
 --  params:set("ir_file",default_file,silent)
   screen_dirty=true
   elseif file ~= "-" then
   print("selected file: " .. file)
   engine.ir_file(file)
   screen_dirty=true
   end
  end
}
  
  params:bang()
end


function redraw_clock()
  while true do
    clock.sleep(1/15)
    if screen_dirty then
      redraw()
      screen_dirty = false
    end
  end
end

function redraw()
  screen.clear()
  screen.aa(0)
  screen.font_face(24)
  screen.font_size(10)
  screen.level(15)
  screen.move(64, 15)
  screen.text_center(message)
  screen.pixel(0, 0)
  screen.pixel(127, 0)
  screen.pixel(127, 63)
  screen.pixel(0, 63)
  screen.fill()
  screen.update()

  screen.move(10,30)
  screen.text("dry: ")
  screen.move(118,30)
  screen.text_right(params:string("dry"))

  screen.move(10,45)
  screen.text("wet: ")
  screen.move(118,40)
  screen.text_right(params:string("wet"))
  
  screen.move(10,60)
  screen.text(params:string("ir_file"))

  screen.update()
end


function enc(n, delta)
  if n == 2 then  
    params:delta("dry", delta)
  elseif n == 3 then
    params:delta("wet", delta)
  end
end


-- function r()
--   norns.script.load(norns.state.script)
-- end


function cleanup()
 clock.cancel(redraw_clock_id)
end
