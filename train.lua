-- Game Structure Inspector
print("=== TRAIN TO FIGHT - STRUCTURE INSPECTOR ===\n")

-- 1. Cari TrainEquipment structure
print("📦 TrainEquipment Structure:")
local TrainEquipment = game.ReplicatedStorage:FindFirstChild("TrainEquipment")
if TrainEquipment then
    for _, child in pairs(TrainEquipment:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            print("  ✅", child:GetFullName(), "(" .. child.ClassName .. ")")
        end
    end
else
    print("  ❌ TrainEquipment not found")
end

-- 2. Cari di workspace (mungkin equipment ada di world)
print("\n🌍 Workspace Training Equipment:")
for _, obj in pairs(workspace:GetDescendants()) do
    if obj.Name:lower():find("train") and (obj:IsA("Model") or obj:IsA("Part")) then
        print("  🎯", obj:GetFullName())
        
        -- Cari ClickDetector atau ProximityPrompt
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("ClickDetector") or child:IsA("ProximityPrompt") then
                print("    → Has:", child.ClassName)
            end
        end
    end
end

-- 3. Cari player stats
print("\n📊 Player Stats Location:")
local char = game.Players.LocalPlayer.Character
if char then
    -- Cek leaderstats
    if game.Players.LocalPlayer:FindFirstChild("leaderstats") then
        print("  ✅ Leaderstats found:")
        for _, stat in pairs(game.Players.LocalPlayer.leaderstats:GetChildren()) do
            print("    →", stat.Name, "=", stat.Value)
        end
    end
    
    -- Cek di character
    for _, obj in pairs(char:GetDescendants()) do
        if obj.Name:lower():find("arms") or obj.Name:lower():find("legs") or 
           obj.Name:lower():find("back") or obj.Name:lower():find("agility") then
            print("  🎯 In Character:", obj:GetFullName())
        end
    end
end

-- 4. Monitor saat training (tanpa hook)
print("\n🔍 Ready to monitor. Press E on training equipment now!")
print("Watching for changes in player stats...\n")

-- Track stat changes
local function trackStats()
    local stats = {}
    
    if game.Players.LocalPlayer:FindFirstChild("leaderstats") then
        for _, stat in pairs(game.Players.LocalPlayer.leaderstats:GetChildren()) do
            stats[stat.Name] = stat.Value
        end
    end
    
    while task.wait(0.5) do
        if game.Players.LocalPlayer:FindFirstChild("leaderstats") then
            for _, stat in pairs(game.Players.LocalPlayer.leaderstats:GetChildren()) do
                if stats[stat.Name] and stat.Value ~= stats[stat.Name] then
                    print("📈 STAT CHANGED:", stat.Name, stats[stat.Name], "→", stat.Value, "(+" .. (stat.Value - stats[stat.Name]) .. ")")
                    stats[stat.Name] = stat.Value
                end
            end
        end
    end
end

spawn(trackStats)
```

## **🎯 Atau Cara Paling Mudah:**

**Bisa share link script dari gumanba yang berhasil?** Atau copy paste isi script nya ke sini, biar saya bisa lihat **cara kerja yang sebenarnya**.

Dari link ini:
```
https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/TraintoFight
