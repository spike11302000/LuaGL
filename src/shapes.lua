local shapes = {}
function shapes.Panel(ax,ay,az,bx,by,bz,cx,cy,cz,dx,dy,dz,image,Color)
  p = {
    a = {x = ax, y = ay, z = az};
    b = {x = bx, y = by, z = bz};
    c = {x = cx, y = cy, z = cz};
    d = {x = dx, y = dy, z = dz};
    color = Color;
    texture = image;
    display = true;
  } 
  if Color == nil then
      p.color = shapes.Color(255,255,255,2555)
    end
  return p
end
function shapes.cube()
  p = shapes.Panel(0,1,0,0,1,1,1,1,1,1,1,0) --top
  shapes.movePanel(p,x,y,z)
  scene[#scene+1] = p
        
   p = shapes.Panel(0,0,0,0,0,1,1,0,1,1,0,0) --buttom
   shapes.movePanel(p,x,y,z)
   scene[#scene+1] = p
        
   p = shapes.Panel(0,0,0,1,0,0,1,1,0,0,1,0) --side
   shapes.movePanel(p,x,y,z)
    scene[#scene+1] = p
end
function shapes.Color(r,g,b,a)
  return {r,g,b,a}
end
function shapes.movePanel(p,x,y,z)
  p.a.x = p.a.x + x;
  p.a.y = p.a.y + y;
  p.a.z = p.a.z + z;
  
  p.b.x = p.b.x + x;
  p.b.y = p.b.y + y;
  p.b.z = p.b.z + z;
  
  p.c.x = p.c.x + x;
  p.c.y = p.c.y + y;
  p.c.z = p.c.z + z;
  
  p.d.x = p.d.x + x;
  p.d.y = p.d.y + y;
  p.d.z = p.d.z + z;
end
function shapes.gradient(colors)
    local direction = colors.direction or "horizontal"
    if direction == "horizontal" then
        direction = true
    elseif direction == "vertical" then
        direction = false
    else
        error("Invalid direction '" .. tostring(direction) "' for gradient.  Horizontal or vertical expected.")
    end
    local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
    for i, color in ipairs(colors) do
        local x, y
        if direction then
            x, y = 0, i - 1
        else
            x, y = i - 1, 0
        end
        result:setPixel(x, y, color[1], color[2], color[3], color[4] or 255)
    end
    result = love.graphics.newImage(result)
    result:setFilter('linear', 'linear')
    return result
end

return shapes