--- functions/logic for operations on the maze array

-- generate an array of arrays indexed by procedural int
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

-- initialize the maze array and seed the search list
function maze_init()
  walllist = {}
  maze = maze_generate(mazewidth, mazeheight)
  local start = 0
  local legit = false
  while not legit do
    start = math.random(#maze)
    local this = maze[start]
    if this.x > 2 and this.x < mazewidth - 2 and this.y > 2 and this.y < mazeheight - 2 then legit = true end
  end
  maze[start].val = 0
  table_add_table(walllist, get_neighbors(start, 2, 1)) -- seed search lists with start position neighbors
end

-- maze drawing
function maze_draw(tbl)
  local posx = 0
  local posy = 0
  local bs = blocksize

  for i = 1, #tbl, 1 do
    local cand = false -- flag for whether a block is a candidate
    for j = 1, #walllist, 1 do
      if walllist[j] == i then
        cand = true
      end
    end
    -- candidate green, the rest white
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

-- set the maze block size
function blocksize_init(size)
  blocksize = size
  mazewidth = math.floor(love.graphics.getWidth() / blocksize)
  mazeheight = math.floor(love.graphics.getHeight() / blocksize)
end
