loadstring(game:HttpGet('https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua'))()

wait(2)

--[[
Credit: USSIndustry
Note: They patched my old method. I'm not working on this anymore.
]]

local mt = getrawmetatable
local getnamecallmethod = getnamecallmethod
local newcclosure = newcclosure
local setreadonly = setreadonly
local unpack = unpack
local typeof = typeof
local hookfunction = hookfunction
local getgc = getgc
local islclosure = islclosure
local debug_getupvalues = debug.getupvalues
local debug_getinfo = debug.getinfo
local pairs = pairs
local next = next

local game_mt = mt(game)
local old_namecall = game_mt.__namecall

setreadonly(game_mt, false)

game_mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" then
        if args[1] == "Grab" then
            args[2] = true
            args[3] = false
            return old_namecall(self, unpack(args))
        end
    end
    return old_namecall(self, ...)
end)

local function hook(upv)
    if upv and typeof(upv) == "function" then
        local hook = hookfunction(upv, function(cd, moveType, ...)
            if moveType == "GRAB" then
                return hook(0, moveType, ...)
            end
            return hook(cd, moveType, ...)
        end)
    end
end

for _, v in pairs(getgc()) do
    if typeof(v) == "function" and islclosure(v) then
        for _, upv in pairs(debug_getupvalues(v)) do
            if typeof(upv) == "function" and debug_getinfo(upv).name == "DoCooldown" then
                hook(upv)
            end
        end
    end
end
