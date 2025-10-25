--[[
═══════════════════════════════════════════════════════════
    TRAIN TO FIGHT - DIAGNOSTIC SCRIPT
    Jalankan ini untuk cek struktur stats
═══════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

print("\n" .. string.rep("=", 60))
print("🔍 TRAIN TO FIGHT - DIAGNOSTIC MODE")
print(string.rep("=", 60))

-- Function untuk print tree structure
local function printTree(instance, indent)
    indent = indent or ""
    for _, child in pairs(instance:GetChildren()) do
        local info = child.Name .. " (" .. child.ClassName .. ")"
        if child:IsA("ValueBase") then
            info = info .. " = " .. tostring(child.Value)
        end
        print(indent .. "├─ " .. info)
        
        if #child:GetChildren() > 0 and not child:IsA("ValueBase") then
            printTree(child, indent .. "│  ")
        end
    end
end

wait(2) -- Wait for game to load

-- 1. CHECK PLAYER STRUCTURE
print("\n📂 1. PLAYER STRUCTURE:")
print("Player Name:", Player.Name)
printTree(Player, "")

-- 2. CHECK CHARACTER STRUCTURE
print("\n👤 2. CHARACTER STRUCTURE:")
if Player.Character then
    printTree(Player.Character, "")
else
    print("❌ Character not found!")
end

-- 3. SPECIFIC LEADERSTATS CHECK
print("\n📊 3. LEADERSTATS DETAILED CHECK:")
local leaderstats = Player:FindFirstChild("leaderstats")
if leaderstats then
    print("✅ Leaderstats FOUND at:", leaderstats:GetFullName())
    print("\nStats inside leaderstats:")
    for _, stat in pairs(leaderstats:GetChildren()) do
        local statInfo = {
            Name = stat.Name,
            ClassName = stat.ClassName,
            Value = stat:IsA("ValueBase") and stat.Value or "N/A",
            Parent = stat.Parent.Name,
            FullPath = stat:GetFullName()
        }
        print(string.format("  • %s", stat.Name))
        print(string.format("    - Type: %s", statInfo.ClassName))
        print(string.format("    - Current Value: %s", tostring(statInfo.Value)))
        print(string.format("    - Full Path: %s", statInfo.FullPath))
        print(string.format("    - Can be modified: %s", stat.Value ~= nil and "YES" or "NO"))
    end
else
    print("❌ Leaderstats NOT FOUND!")
    print("\nSearching in other locations...")
    
    local possibleLocations = {
        Player.PlayerGui,
        Player.PlayerScripts,
        Player.Backpack,
        Player.Character
    }
    
    for _, location in pairs(possibleLocations) do
        if location then
            local found = location:FindFirstChild("leaderstats") or location:FindFirstChild("Stats")
            if found then
                print("✅ Found stats at:", found:GetFullName())
            end
        end
    end
end

-- 4. TEST MODIFICATION
print("\n🔧 4. TESTING STAT MODIFICATION:")
if leaderstats then
    local testStat = leaderstats:FindFirstChild("Arms")
    if testStat then
        local originalValue = testStat.Value
        print(string.format("Testing Arms modification..."))
        print(string.format("  Original value: %s", tostring(originalValue)))
        
        wait(0.5)
        
        -- Try to modify
        local success, err = pcall(function()
            testStat.Value = originalValue + 100
        end)
        
        if success then
            wait(0.5)
            local newValue = testStat.Value
            print(string.format("  New value: %s", tostring(newValue)))
            
            if newValue == originalValue + 100 then
                print("✅ Modification SUCCESS!")
                -- Restore original value
                testStat.Value = originalValue
                print("  (Value restored)")
            else
                print("⚠️ Value changed but not as expected!")
                print(string.format("  Expected: %s, Got: %s", originalValue + 100, newValue))
            end
        else
            print("❌ Modification FAILED!")
            print("  Error:", err)
        end
    else
        print("❌ Arms stat not found for testing")
    end
end

-- 5. CHECK REMOTES
print("\n📡 5. CHECKING REMOTES:")
local remoteCount = 0
for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        remoteCount = remoteCount + 1
        if remote.Name:lower():find("train") or 
           remote.Name:lower():find("stat") or
           remote.Name:lower():find("workout") then
            print(string.format("  📍 %s (%s)", remote.Name, remote:GetFullName()))
        end
    end
end
print(string.format("Total remotes found: %d", remoteCount))

-- 6. SECURITY CHECK
print("\n🛡️ 6. SECURITY CHECKS:")
local tests = {
    {name = "Can modify WalkSpeed", test = function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local h = Player.Character.Humanoid
            local old = h.WalkSpeed
            h.WalkSpeed = 100
            local result = h.WalkSpeed == 100
            h.WalkSpeed = old
            return result
        end
        return false
    end},
    {name = "ReplicatedStorage accessible", test = function()
        return game:GetService("ReplicatedStorage") ~= nil
    end},
    {name = "Can use getgenv()", test = function()
        return getgenv ~= nil
    end}
}

for _, test in ipairs(tests) do
    local success, result = pcall(test.test)
    local status = (success and result) and "✅ PASS" or "❌ FAIL"
    print(string.format("  %s - %s", status, test.name))
end

print("\n" .. string.rep("=", 60))
print("📋 DIAGNOSTIC COMPLETE")
print(string.rep("=", 60))
print("\n💡 INSTRUCTIONS:")
print("1. Take a screenshot of this output")
print("2. Share it so I can see the exact structure")
print("3. Or copy-paste the 'LEADERSTATS DETAILED CHECK' section")
print(string.rep("=", 60) .. "\n")

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Diagnostic Complete",
    Text = "Check console (F9) for results!",
    Duration = 5
})
