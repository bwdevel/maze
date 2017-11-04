function love.load()
  math.randomseed(os.time())
  debug = false
  blocksize = 16
  mazewidth = math.floor(love.graphics.getWidth()/blocksize)
  mazeheight = math.floor(love.graphics.getHeight()/blocksize)

  -- set maze globals and initial maze
  counter = 0
  maze = {}
  walllist = {}
  start = 0
  maze_init()
end

function love.update(dt)
  --if #walllist > 0 then
  if #walllist == 0 then maze_init() end
  while #walllist > 0 do
    local target = walllist[math.random(#walllist)]
    local tneighbors = get_neighbors(target, 2, 0)
    if #tneighbors > 0 then
      local tneighbor = tneighbors[math.random(#tneighbors)]
      local middle = get_middle(target, tneighbor)
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
  if key == 'r' and #walllist == 0 then maze_init() end
end

function draw_debug()
  local x = 10
  local y = 10
  local w = 150
  local h = 50
  love.graphics.setColor(0, 0, 0, 192)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('line', x, y, w, h)

  love.graphics.print(tostring(love.timer.getFPS()), x + 2, y + 2)
  love.graphics.print('Generations: ' .. counter, x + 2, y + 14)
end

function maze_generate(w, h)
  local index = 1
  local out = {}
  for x = 1, w, 1 do
    for y = 1, h, 1 do
      local val = 1
      if x == 1 or x == w or y == 1 or y == h then val = 0 end
      out[index] = {x = x, y = y, val = val}
      index = index + 1
    end
  end
  return out
end

function maze_init()
  walllist = {}
  maze = maze_generate(mazewidth, mazeheight)
  local legit = false
  while not legit do
    start = math.random(#maze)
    local this = maze[start]
    if this.x > 2 and this.x < mazewidth - 2 and this.y > 2 and this.y < mazeheight - 2 then legit = true end
  end
  maze[start].val = 0
  table_add_table(walllist, get_neighbors(start, 2, 1))
  counter = counter + 1
end

function maze_draw(tbl)
  local posx = 0
  local posy = 0
  local bs = blocksize

  for i = 1, #tbl, 1 do
    local cand = false
    for j = 1, #walllist, 1 do
      if walllist[j] == i then
        cand = true
      end
    end
    if cand then
      love.graphics.setColor(0, 255, 0, 255)
    else
      love.graphics.setColor(255, 255, 255, 255)
    end

    local type = 'fill'
    if tbl[i].val == 0 then type = 'line' end
    local x = (tbl[i].x - 1) * bs + posx
    local y = (tbl[i].y - 1) * bs + posy
    local w = bs
    local h = bs
    if type == 'fill' then love.graphics.rectangle(type, x, y, w, h) end
  end

end

function find_by_coords(tbl, x, y)
  local out = nil
  for i = 1, #tbl, 1 do
    if tbl[i].x == x and tbl[i].y == y then out = i end
  end
  return out
end

function get_neighbors(num, dist, val)
  local this = maze[num]
  local x = this.x
  local y = this.y
  local candidates = {}
  if x - dist > 1           then table.insert(candidates, find_by_coords(maze, x - dist, y)) end
  if x + dist < mazewidth   then table.insert(candidates, find_by_coords(maze, x + dist, y)) end
  if y - dist > 1           then table.insert(candidates, find_by_coords(maze, x, y - dist)) end
  if y + dist < mazeheight  then table.insert(candidates, find_by_coords(maze, x, y + dist)) end
  for i = #candidates, 1, -1 do
    if maze[candidates[i]].val ~= val then table.remove(candidates, i) end
  end
  return candidates
end

function get_middle(current, candidate)
  local curx = maze[current].x
  local cury = maze[current].y
  local canx = maze[candidate].x
  local cany = maze[candidate].y
  local diffx = (curx - canx) / 2
  local diffy = (cury - cany) / 2
  local middle = find_by_coords(maze, curx + diffx, cury + diffy)
  return middle
end

function table_add_table(tgt, src)
  for i = 1, #src, 1 do
    table_add_unique(tgt, src[i])
  end
end

function table_add_unique(tbl, val)
  local add = true
  for i = 1, #tbl, 1 do
    if tbl[i] == val then add = false end
  end
  if add == true then table.insert(walllist, val)
  end
end
