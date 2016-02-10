shapes = require("shapes")
local misc = require("misc")
width, height = love.graphics.getDimensions()
print("windows size: "..height..":"..width)
local scene = {}
local Textures = {}
local renderScene = {}
local Player = {
  x = 0;
  y = 0;
  z = 0;
  rx = 0;
  ry = 0;
}
for x = 1, 10 do
for y = 1, 10 do
        p = shapes.Panel(0,1,0, 0,1,1, 1,1,1, 1,1,0, "grass_top",shapes.Color(126,190,84,255)) --top
        shapes.movePanel(p,y,0,-x)
        scene[#scene+1] = p
        
        p = shapes.Panel(0,0,0, 0,0,1, 1,0,1, 1,0,0, "dirt") --buttom
        shapes.movePanel(p,y,0,-x)
        scene[#scene+1] = p
        
        p = shapes.Panel(0,1,0, 0,0,0, 1,0,0, 1,1,0, "grass_side") --side
        shapes.movePanel(p,y,0,-x)
        scene[#scene+1] = p
        
        p = shapes.Panel(0,1,1, 0,0,1, 1,0,1, 1,1,1, "grass_side") --side
        shapes.movePanel(p,y,0,-x)
        scene[#scene+1] = p
        
        p = shapes.Panel(0,1,0, 0,0,0, 0,0,1, 0,1,1, "grass_side") --side
        shapes.movePanel(p,y,0,-x)
        scene[#scene+1] = p
        
        p = shapes.Panel(1,1,0, 1,0,0, 1,0,1, 1,1,1, "grass_side") --side
        shapes.movePanel(p,y,0,-x)
        scene[#scene+1] = p
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
        --translate(Player.x,Player.y,Player.z,renderScene)
        local my = ry(Player.ry)
        local mx = rx(Player.rx)
        rotate(my,renderScene)
        --translate(Player.x,Player.y,Player.z,scene)
        rotate(mx,renderScene)
        --translate(Player.x,Player.y,Player.z,renderScene)
        for _, poly in pairs(renderScene) do
                if poly.a.z > -100 then
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
 
function love.update(delta)
        local moveSpeed = delta*5
        local rotSpeed = delta
       
        if love.keyboard.isDown("a") then
                --translate(moveSpeed, 0, 0,scene)
                Player.x = Player.x + moveSpeed
        end
        if love.keyboard.isDown("d") then
                --translate(-moveSpeed, 0, 0,scene)
                Player.x = Player.x - moveSpeed
        end
       
        if love.keyboard.isDown("w") then
                --translate(0, 0, moveSpeed,scene)
                Player.z = Player.z + moveSpeed
        end
        if love.keyboard.isDown("s") then
                --translate(0, 0, -moveSpeed,scene)
                Player.z = Player.z - moveSpeed
        end
        if love.keyboard.isDown("space") then
                --translate(0, -moveSpeed,0,scene)
                Player.y = Player.y - moveSpeed
        end
        if love.keyboard.isDown("lshift") then
                --translate(0, moveSpeed,0,scene)
                Player.y = Player.y + moveSpeed
        end
        if love.keyboard.isDown("left") then
                --local m = ry(-rotSpeed)
                --rotate(m)
                Player.ry = Player.ry - rotSpeed
        end
        if love.keyboard.isDown("right") then
                --local m = ry(rotSpeed)
                --rotate(m)
                Player.ry = Player.ry + rotSpeed
        end
       
        if love.keyboard.isDown("up") then
                --local m = rx(-rotSpeed)
                --rotate(m)
                Player.rx = Player.rx - rotSpeed
        end
        if love.keyboard.isDown("down") then
                --local m = rx(rotSpeed)
                --rotate(m)
                Player.rx = Player.rx + rotSpeed
        end
end