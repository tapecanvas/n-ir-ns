-- N(IR)NS
-- Convolution cross-synthesis
-- Thanks to: lines forum, @hankyates, and @tyleretters

engine.name = 'Impulse'
ControlSpec = require "controlspec"
Formatters = require "formatters"
fileselect = require 'fileselect'

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


  params:add_file{"ir_file", "file",
  action = function(file)
    if file ~= "cancel" then
      engine.loadIR(file, ~startUsingIR)
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

  screen.move(10,40)
  screen.text("wet: ")
  screen.move(118,40)
  screen.text_right(params:string("wet", "%"))

  screen.update()
end

function enc(n, delta)
  if n == 2 then  
    params:delta("dry", delta)
  elseif n == 3 then
    params:delta("wet", delta)
  end
end

function r()
  norns.script.load(norns.state.script)
end

function cleanup()
  clock.cancel(redraw_clock_id)
end