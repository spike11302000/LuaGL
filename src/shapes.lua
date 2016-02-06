local shapes = {}
function shapes.Panel()
  p = {
    a = {x = 0, y = 0, z = 0};
    b = {x = 1, y = 0, z = 0};
    c = {x = 1, y = 1, z = 0};
    d = {x = 0, y = 1, z = 0};
    color = {math.random()*255, math.random()*255, math.random()*255};
  }
  return p
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


return shapes