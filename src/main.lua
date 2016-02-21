shapes = require("shapes")
local misc = require("misc")
width, height = love.graphics.getDimensions()
local centerx , centery = width/2 ,height/2
print("windows size: "..height..":"..width)
local scene = {}
local Cubes = {}
local Textures = {}
local renderScene = {}
local Player = {
  x = 0;
  y = 0;
  z = 0;
  
  rx = 0;
  ry = 0;
  dy = 0;
  dx = 0;
  
  mx = 0;
  my = 0;
  mz = 0;
}
local Cursor = {
  x = 0;
  y = 0;
  ax = 0;
  ay = 0;
  
}
local key = {
  Debug = false;
  DebugPressed = false;
}
function Cube(x,y,z,txTop,txBottom,txSide1,txSide2,txSide3,txSide4,topColor)
  if topColor == nil then
    topColor = shapes.Color(255,255,255,255)
  end
  a = shapes.Panel(0,1,0, 0,1,1, 1,1,1, 1,1,0, txTop,topColor) --top
  shapes.movePanel(a,x,y,z)
  scene[#scene+1] = a
        
  b = shapes.Panel(0,0,0, 0,0,1, 1,0,1, 1,0,0, txBottom) --buttom
  shapes.movePanel(b,x,y,z)
  scene[#scene+1] = b
        
  c = shapes.Panel(0,1,0, 0,0,0, 1,0,0, 1,1,0, txSide1) --side
  shapes.movePanel(c,x,y,z)
  scene[#scene+1] = c
        
  d = shapes.Panel(0,1,1, 0,0,1, 1,0,1, 1,1,1, txSide2) --side
  shapes.movePanel(d,x,y,z)
  scene[#scene+1] = d
        
  e = shapes.Panel(0,1,0, 0,0,0, 0,0,1, 0,1,1, txSide3) --side
  shapes.movePanel(e,x,y,z)
  scene[#scene+1] = e
        
  f = shapes.Panel(1,1,0, 1,0,0, 1,0,1, 1,1,1, txSide4) --side
  shapes.movePanel(f,x,y,z)
  scene[#scene+1] = f
end
for x = 1, 20 do
for y = 1, 20 do
 Cube(y,0,-x,"grass_top","dirt","grass_side","grass_side","grass_side","grass_side",shapes.Color(math.random()*255,math.random()*255,math.random()*255,255))
end
end
local fog = shapes.gradient {
    direction = 'vertical';
    {0, 0, 0,150};
    {255, 255, 255,150};
    {0, 0, 0, 150};

}
function project(vertex)
        local x = vertex.x / -vertex.z
        local y = vertex.y / -vertex.z * -1
        if vertex.z > 0 then
                x = x * -10
                y = y * -10
        end
        x = (width/2) + x*(width/2)
        y = (height/2) + y*(width/2)
        return x, y, vertex.z
end
function love.load()
  love.mouse.setGrabbed(true)
  love.mouse.setVisible(false)
  --love.mouse.setRelativeMode(true)
  Textures = {
    grass_top = love.graphics.newImage("res/grass_top.png");
    grass_side = love.graphics.newImage("res/grass_side.png");
    dirt = love.graphics.newImage("res/dirt.png")
    
  }
  mesh = love.graphics.newMesh({{0,0},{0,0},{0,0},{0,0}}, "fan")
end
function sortRender(a,b)
  
  return a.z < b.z
end
function love.draw()
        local render = {}
        --translate(Player.x,Player.y,Player.z,scene)
        local renderScene = misc.CloneScene(scene)
        translate(Player.x,Player.y,Player.z,renderScene)
        local my = ry(Player.ry)
        local mx = rx(Player.rx)
        rotate(my,renderScene)
        --translate(Player.x,Player.y,Player.z,scene)
        rotate(mx,renderScene)
        --translate(Player.x,Player.y,Player.z,renderScene)
        for _, poly in pairs(renderScene) do
                if poly.a.z > -10 then
                local ax, ay, az = project(poly.a)
                local bx, by, bz = project(poly.b)
                local cx, cy, cz = project(poly.c)
                local dx, dy, dz = project(poly.d)
               
                if az < 0 or bz < 0 or cz < 0 or dz < 0 then
                  
                        render[#render + 1] = {
                                vertices = {
                                        {ax, ay, 0, 0};
                                        {bx, by, 0, 1};
                                        {cx, cy, 1, 1};
                                        {dx, dy, 1, 0};
                                };
                                poly = poly;
                                z = (az + bz + cz + dz)/3;
                        }
                        end
                end
        end
        
        table.sort(render, sortRender)
        
        for _, data in pairs(render) do
                local poly = data.poly
                mesh:setVertex(1,data.vertices[1])
                mesh:setVertex(2,data.vertices[2])
                mesh:setVertex(3,data.vertices[3])
                mesh:setVertex(4,data.vertices[4])
                love.graphics.setColor(poly.color)
                mesh:setTexture(Textures[poly.texture])
                love.graphics.draw(mesh, 0, 0)
                love.graphics.setColor(255,255,255,255)
           
        end
        love.graphics.circle("line", width/2,height/2, 5, 100)
love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)  
if key.Debug then
  love.graphics.print("Rotate x,y "..Player.dx..","..Player.dy,10,30)
  love.graphics.print("X,Y,Z "..math.floor(Player.x)..","..math.floor(Player.y)..","..math.floor(Player.z),10,40)
  love.graphics.print("Cursor x,y "..Cursor.ax..","..Cursor.ay,10,50)
  --love.graphics.print("Movement Direction "..Player.mx..","..Player.mz,10,60)
end
end
 
function translate(x, y, z, points)
        if not points then
          points = scene
        end
        for _, poly in pairs(points) do
                for _, vertex in pairs {poly.a, poly.b, poly.c, poly.d} do
                        vertex.x = vertex.x + x
                        vertex.y = vertex.y + y
                        vertex.z = vertex.z + z
                end
        end
end
 
function rx(r)
        local cosR = math.cos(r)
        local sinR = math.sin(r)
        local m = {
                {  1  ,   0  ,   0  };
                {  0  ,  cosR, -sinR};
                {  0  ,  sinR,  cosR};
        }
        return m
end
 
function ry(r)
        local cosR = math.cos(r)
        local sinR = math.sin(r)
        local m = {
                { cosR,   0  ,  sinR};
                {  0  ,   1  ,   0  };
                {-sinR,   0  ,  cosR};
        }
        return m
end
 
function rotate(m,points)
        for _, poly in pairs(points) do
                for _, vertex in pairs {poly.a, poly.b, poly.c, poly.d} do
                        local x = vertex.x
                        local y = vertex.y
                        local z = vertex.z
                       
                        vertex.x = x*m[1][1] + y*m[1][2] + z*m[1][3]
                        vertex.y = x*m[2][1] + y*m[2][2] + z*m[2][3]
                        vertex.z = x*m[3][1] + y*m[3][2] + z*m[3][3]
                end
        end
end
function love.mousemoved( x, y, dx, dy )
  --Cursor.ax = dx
  --Cursor.ay = dy
end
function love.update(delta)
          Cursor.x, Cursor.y = love.mouse.getPosition()
          Cursor.ay = (Cursor.x - centerx)
          Cursor.ax = (Cursor.y - centery)
          love.mouse.setPosition(centerx,centery)

        
        Player.ry = Player.ry + (Cursor.ay/1000)
        temprx = Player.rx + (Cursor.ax/1000)
        if math.floor((temprx/6.3)*360) <= 85 and math.floor((temprx/6.3)*360) >= -85 then
          Player.rx = temprx
        end
        if Player.dy < 90 and Player.dy > -90 then
          Player.mx = Player.dy/90
        else
          if Player.dy > 0 then
            Player.mx = ((90/Player.dy)-.5)*2
          else
            Player.mx = ((90/Player.dy)*2)+1
          end
        end
        
        if Player.dx < 90 and Player.dx > -90 then
          Player.mz = Player.dy/90
        else
          if Player.dy > 0 then
            Player.mz = ((90/Player.dx)-.5)*2
          else
            Player.mz = ((90/Player.dx)*2)+1
          end
        end
        if Player.mz > 0 then
          Player.mz = 1 - Player.mz
        else
          Player.mz = 1 + Player.mz
        end
        
        
        Player.dx = math.floor((Player.rx/6.3)*360); --up/down
        Player.dy = math.floor((Player.ry/6.3)*360); --left/right
        for i = 0,100 do
        if Player.dy > 180 then
          Player.dy = -180 + (Player.dy-180)
        end
        
        if Player.dy < -180 then
          Player.dy = 180 + (Player.dy+180)
        end
        
        
        end
        local moveSpeed = delta*5
        local rotSpeed = delta
       
        if love.keyboard.isDown("a") then
                Player.z = Player.z + ((Player.mx*delta)*5)
                Player.x = Player.x + ((Player.mz*delta)*5)
        end
        if love.keyboard.isDown("d") then
                Player.z = Player.z - ((Player.mx*delta)*5)
                Player.x = Player.x - ((Player.mz*delta)*5)
        end
       
        if love.keyboard.isDown("w") then
                Player.z = Player.z + ((Player.mz*delta)*5)
                Player.x = Player.x - ((Player.mx*delta)*5)
        end
        if love.keyboard.isDown("s") then
                Player.z = Player.z - ((Player.mz*delta)*5)
                Player.x = Player.x + ((Player.mx*delta)*5)
        end
        if love.keyboard.isDown("space") then
                --translate(0, -moveSpeed,0,scene)
                Player.y = Player.y - moveSpeed
        end
        if love.keyboard.isDown("lshift") then
                --translate(0, moveSpeed,0,scene)
                Player.y = Player.y + moveSpeed
        end
        
        if love.keyboard.isDown("escape") then
                love.window.close( )
        end
        if love.keyboard.isDown("f3") then
                key.Debug = not key.Debug
        end
end