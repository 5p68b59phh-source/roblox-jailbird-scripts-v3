-- HBV Hub Jailbird Script Loader
print("Loading HBV Hub...")

local success, err = pcall(function()
    local script = game:HttpGet("https://raw.githubusercontent.com/5p68b59phh-source/roblox-jailbird-scripts-v3/main/main.lua")
    loadstring(script)()
end)

if not success then
    warn("Failed to load: " .. tostring(err))
    -- Fallback to direct load
    loadstring(game:HttpGet("https://raw.githubusercontent.com/5p68b59phh-source/roblox-jailbird-scripts-v3/main/main.lua"))()
end

print("HBV Hub loaded successfully!")
