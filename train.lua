-- Detector untuk cari remote penambahan stat
print("=== STAT INCREASE DETECTOR ===")

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        local remoteName = tostring(self)
        
        -- Cari remote yang berhubungan dengan stat/arms/legs/back/agility
        if string.find(remoteName:lower(), "stat") or
           string.find(remoteName:lower(), "arms") or
           string.find(remoteName:lower(), "legs") or
           string.find(remoteName:lower(), "back") or
           string.find(remoteName:lower(), "agility") or
           string.find(remoteName:lower(), "train") or
           string.find(remoteName:lower(), "apply") or
           string.find(remoteName:lower(), "mobile") or
           string.find(remoteName:lower(), "equipment") then
            
            print("\n🚀 REMOTE CALLED:")
            print("  Remote:", self:GetFullName())
            print("  Method:", method)
            print("  Arguments:")
            for i, arg in pairs(args) do
                print("    [" .. i .. "]:", arg, type(arg))
            end
        end
    end
    
    return old(self, ...)
end)

print("\n✅ Detector aktif!")
print("Sekarang KLIK TRAINING (Arms/Legs/Back/Agility) dan lihat output!")
