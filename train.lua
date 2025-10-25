-- Detector Script - Paste di executor
print("=== TRAIN TO FIGHT REMOTE DETECTOR ===")

-- 1. Cari semua RemoteEvents
print("\n📡 REMOTE EVENTS:")
for _, v in pairs(game.ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        print("  ✅", v:GetFullName())
    end
end

-- 2. Cari yang ada kata "train"
print("\n🎯 TRAINING RELATED:")
for _, v in pairs(game.ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and string.find(v.Name:lower(), "train") then
        print("  💪", v:GetFullName())
    end
end

-- 3. Hook remote untuk lihat arguments
print("\n🔍 MONITORING REMOTE CALLS...")
print("(Tekan tombol training di game, lalu lihat output)")

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        if string.find(tostring(self):lower(), "train") then
            print("\n🚀 REMOTE CALLED:")
            print("  Remote:", self:GetFullName())
            print("  Arguments:", table.concat(args, ", "))
        end
    end
    
    return old(self, ...)
end)

print("\n✅ Detector aktif! Coba training di game sekarang.")
