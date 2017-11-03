function love.load()
  debug = false
end

function love.update(dt)

end

function love.draw()

if debug then draw_debug() end
end

function love.keyreleased(key)
  if key == 'q' then love.event.quit() end
  if key == 'p' then
    if debug then debug = false else debug = true end
  end
end

function draw_debug()
  local x = 10
  local y = 10
  local w = 100
  local h = 50
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('line', x, y, w, h)

  love.graphics.print(tostring(love.timer.getFPS()), x + 2, y + 2)

end
