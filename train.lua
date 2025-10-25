-- Advanced Detector - Capture SEMUA remote calls
print("=== ADVANCED STAT DETECTOR ===")

local loggedRemotes = {}

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        local remotePath = self:GetFullName()
        
        -- Log semua remote (bukan hanya train)
        if not loggedRemotes[remotePath] then
            loggedRemotes[remotePath] = true
            
            print("\n📡 NEW REMOTE FOUND:")
            print("  Path:", remotePath)
            print("  Method:", method)
            print("  Args Count:", #args)
            
            if #args > 0 then
                print("  Arguments:")
                for i, arg in pairs(args) do
                    local argType = type(arg)
                    local argValue = tostring(arg)
                    
                    -- Tampilkan lebih detail untuk table
                    if argType == "table" then
                        argValue = "TABLE:"
                        for k, v in pairs(arg) do
                            argValue = argValue .. " [" .. tostring(k) .. "]=" .. tostring(v)
                        end
                    end
                    
                    print("    [" .. i .. "] " .. argType .. ":", argValue)
                end
            end
            print("---")
        end
    end
    
    return old(self, ...)
end)

print("\n✅ Advanced detector active!")
print("🎮 Sekarang TRAINING dan tunggu 10 detik")
print("📋 Semua remote akan ter-log di console\n")

-- Auto print summary setelah 15 detik
task.wait(15)
print("\n\n=== SUMMARY - ALL REMOTES LOGGED ===")
for path, _ in pairs(loggedRemotes) do
    print("  ✅", path)
end
print("=====================================")
