-- search and data functions

function find_by_coords(tbl, x, y)
  -- tbl: source table to search (redundant)
  -- x/y: coords to search for
  local out = nil
  for i = 1, #tbl, 1 do
    if tbl[i].x == x and tbl[i].y == y then out = i end
  end
  return out
end

function get_neighbors(num, dist, val)
  -- num: index value in maze[]
  -- dist: distance from num to gather neighbors
  -- val: 1 = wall, 2 = path
  local this = maze[num]
  local x = this.x
  local y = this.y
  local candidates = {}
  if x - dist > 1           then table.insert(candidates, find_by_coords(maze, x - dist, y)) end
  if x + dist < mazewidth   then table.insert(candidates, find_by_coords(maze, x + dist, y)) end
  if y - dist > 1           then table.insert(candidates, find_by_coords(maze, x, y - dist)) end
  if y + dist < mazeheight  then table.insert(candidates, find_by_coords(maze, x, y + dist)) end
  -- filter table to only those with value passed by val
  for i = #candidates, 1, -1 do
    if maze[candidates[i]].val ~= val then table.remove(candidates, i) end
  end
  return candidates
end

-- find the block between two blocks
function get_middle(current, candidate)
  local curX = maze[current].x
  local curY = maze[current].y
  local canX = maze[candidate].x
  local canY = maze[candidate].y
  local diffX = (curX - canX) / 2
  local diffY = (curY - canY) / 2
  local middle = find_by_coords(maze, curX + diffX, curY + diffY)
  return middle
end

-- add the unique contents of a table to an existing table
function table_add_table(tgt, src)
  for i = 1, #src, 1 do
    table_add_unique(tgt, src[i])
  end
end

-- add a val, if unuqie, to a table
function table_add_unique(tbl, val)
  local add = true
  for i = 1, #tbl, 1 do
    if tbl[i] == val then add = false end
  end
  if add == true then table.insert(walllist, val)
  end
end
