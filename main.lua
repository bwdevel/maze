require './maze'
require './search'

function love.load()
  math.randomseed(os.time())
  debug = true

  -- init maze globals
  blocksize = 16 -- pixel size of each block
  mazewidth = 0
  mazeheight = 0
  blocksize_init(blocksize)
  maze = {} --- maze container
  walllist = {} --- serach list container
  maze_init()
end

function love.update(dt)
  --- 'while' instead of 'if' for faster, non-visual generation
  -- while #walllist > 0 do
  if #walllist > 0 then
    local target = walllist[math.random(#walllist)]
    local tneighbors = get_neighbors(target, 2, 0) -- neighbors of target
    if #tneighbors > 0 then
      local tneighbor = tneighbors[math.random(#tneighbors)] -- candidate from target neighbors
      local middle = get_middle(target, tneighbor) -- block between target and tneighbors to toggle
      maze[middle].val = 0
      maze[target].val = 0
      table_add_table(walllist, get_neighbors(target, 2, 1))
      for i = #walllist, 1 , -1 do
        if walllist[i] == target then table.remove(walllist, i) end
      end
    end
  end
end

function love.draw()
  maze_draw(maze)
  if debug then draw_debug() end
end

function love.keyreleased(key)
  if key == 'q' then love.event.quit() end
  if key == 'p' then
    if debug then debug = false else debug = true end
  end
  if key == 'r' then maze_init() end
  if key == 'right' then
    print(blocksize)
    blocksize = blocksize * 2
    if blocksize > 64 then blocksize = 64 end
    blocksize_init(blocksize)
    maze_init()
  end
  if key == 'left' then
    blocksize = blocksize / 2
    if blocksize < 2 then blocksize = 2 end
    blocksize_init(blocksize)
    maze_init()
  end

end

-- debug window (toggle with 'p')
function draw_debug()
  debug_texts = {
    'FPS: ' ..  tostring(love.timer.getFPS()),
    'Search queue: ' .. tostring(#walllist),
    'Block size: ' .. tostring(blocksize),
    '- - - - - - - - - -',
    'r - redraw',
    '<- / -> - lower/increase block size',
    'p - toggle debug window',
    'q - quit'
  }

  local x = 10
  local y = 10
  local w = 256
  local h = #debug_texts * 16 + 4
  love.graphics.setColor(0, 0, 0, 192)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('line', x, y, w, h)

  for i = 1, #debug_texts, 1 do
    love.graphics.print(debug_texts[i], x + 2, y + 2 + 16 * (i - 1))
  end
end
