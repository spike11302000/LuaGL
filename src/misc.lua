shapes = require("shapes")
local misc = {}
function misc.shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

function misc.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
function misc.tableToString(t)
    local entries = {}
    for k, v in pairs(t) do
        -- if we find a nested table, convert that recursively
        if type(v) == 'table' then
            v = stringifyTable(v)
        else
            v = tostring(v)
        end
        k = tostring(k)
 
        -- add another entry to our stringified table
        entries[#entries + 1] = ("%s = %s"):format(k, v)
    end
 
    -- the memory location of the table
    local id = tostring(t):sub(8)
 
    return ("{%s}@%s"):format(table.concat(entries, ', '), id)
end
function misc.CloneScene(t)
  rt = {}
  for i = 1,1 do
    m = t[i]
    rt[i] = shapes.Panel(m.a.x,m.a.y,m.a.z,m.b.x,m.b.y,m.b.z,m.c.x,m.c.y,m.c.z,m.d.x,m.d.y,m.d.z,m.texture,m.color)
    rt[i].display = m.display
  end
  return rt
end
return misc