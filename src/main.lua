shapes = require("shapes")
local scene = {}
for i = 1, 10 do
        p = shapes.Panel()
        shapes.movePanel(p,0,0,-i)
        scene[i] = p
end

function project(vertex)
        local x = vertex.x / -vertex.z
        local y = vertex.y / -vertex.z * -1
       
        if vertex.z > 0 then
                x = x * -10
                y = y * -10
        end
       
        x = 400 + x*400
        y = 300 + y*400
       
        return x, y, vertex.z
end
 
function love.draw()
        local render = {}
       
        for _, poly in pairs(scene) do
                local ax, ay, az = project(poly.a)
                local bx, by, bz = project(poly.b)
                local cx, cy, cz = project(poly.c)
                local dx, dy, dz = project(poly.d)
               
                if az < 0 or bz < 0 or cz < 0 or dz < 0 then
                        render[#render + 1] = {
                                vertices = {
                                        ax, ay;
                                        bx, by;
                                        cx, cy;
                                        dx, dy;
                                };
                                poly = poly;
                                z = (az + bz + cz + dz)/3;
                        }
                end
        end
       
        table.sort(render, function(a, b) return a.z < b.z end)
       
        for _, data in pairs(render) do
                local poly = data.poly
               
                love.graphics.setColor(poly.color)
                love.graphics.polygon("fill", data.vertices)
        end
end
 
function translate(x, y, z)
        for _, poly in pairs(scene) do
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
 
function rotate(m)
        for _, poly in pairs(scene) do
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
                translate(moveSpeed, 0, 0)
        end
        if love.keyboard.isDown("d") then
                translate(-moveSpeed, 0, 0)
        end
       
        if love.keyboard.isDown("w") then
                translate(0, 0, moveSpeed)
        end
        if love.keyboard.isDown("s") then
                translate(0, 0, -moveSpeed)
        end
        if love.keyboard.isDown("space") then
                translate(0, -moveSpeed,0)
        end
        if love.keyboard.isDown("lshift") then
                translate(0, moveSpeed,0)
        end
        if love.keyboard.isDown("left") then
                local m = ry(-rotSpeed)
                rotate(m)
        end
        if love.keyboard.isDown("right") then
                local m = ry(rotSpeed)
                rotate(m)
        end
       
        if love.keyboard.isDown("r") then
                local m = rx(-rotSpeed)
                rotate(m)
        end
        if love.keyboard.isDown("f") then
                local m = rx(rotSpeed)
                rotate(m)
        end
end