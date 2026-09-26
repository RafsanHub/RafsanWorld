
-- // [CORE SERVICES] Essential Roblox services for UI, HTTP requests, and Tweening.
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService") 
local player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // [DATA RECEIVER] Fetches Key, Plan, and HWID from sussesskey.lua
local MyLoginKey = _G.RafsanHubActiveKey or "No_Key_Found"
local CurrentPlan = tostring(_G.RafsanHubSubscription or "FREE"):upper() 
local MyHwidHash = _G.RafsanHubHWID or game:GetService("RbxAnalyticsService"):GetClientId()

-- // Clearing global variables for security (Prevents memory leaking to other scripts).
_G.RafsanHubActiveKey = nil 
_G.RafsanHubSubscription = nil 
_G.RafsanHubHWID = nil

-- =========================================================================
-- 🔒 [SECURITY CORE - START]
-- =========================================================================
local function getRenderUrl()
    local bytes = {104, 116, 116, 112, 115, 58, 47, 47, 112, 121, 98, 101, 110, 100, 46, 111, 110, 114, 101, 110, 100, 101, 114, 46, 99, 111, 109}
    local url = ""
    for _, b in ipairs(bytes) do url = url .. string.char(b) end
    return url
end
local serverUrl = getRenderUrl()

-- =========================================================================
-- 🪤 [HONEYPOT TRAPS / FAKE VARIABLES - EXTENDED] 
-- =========================================================================

local function executePermanentBan(reasonText, severityLevel)
    local reqFunc = (syn and syn.request) or http_request or request or (http and http.request)
    local hwidToBan = MyHwidHash
    local rText = reasonText or "Honeypot Triggered in Main Hub"
    local sLevel = severityLevel or "High"
    
    -- 1. Send Ban Request to Render Server
    pcall(function()
        if reqFunc then
            reqFunc({
                Url = serverUrl .. "/ban-hacker",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    hwid = hwidToBan, 
                    reason = rText,
                    severity = sLevel
                })
            })
        end
    end)
    
    -- 2. Delete Key File
    pcall(function()
        if isfile and isfile("RafsanHub/RafsanHubKey.txt") then delfile("RafsanHub/RafsanHubKey.txt") end
        if writefile then writefile("RafsanHub/RafsanHubKey.txt", "") end
    end)

    -- 3. Destroy Existing UI
    local CoreGui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name ~= "RafsanHWIDBan" then
            pcall(function() child:Destroy() end)
        end
    end

    -- 4. Show Pitch-Black Ban UI
    local BanScreen = Instance.new("ScreenGui", CoreGui)
    BanScreen.Name = "RafsanHWIDBan"
    
    local Frame = Instance.new("Frame", BanScreen)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = Color3.fromRGB(255, 204, 0)
    UIStroke.Thickness = 5
    
    local TextLabel = Instance.new("TextLabel", Frame)
    TextLabel.Size = UDim2.new(0, 400, 0, 100)
    TextLabel.Position = UDim2.new(0.5, -200, 0.4, -50)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "🚫 SECURITY ALERT 🚫\n" .. rText
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    TextLabel.TextSize = 25
    TextLabel.Font = Enum.Font.Code
    
    local CancelBtn = Instance.new("TextButton", Frame)
    CancelBtn.Size = UDim2.new(0, 200, 0, 50)
    CancelBtn.Position = UDim2.new(0.5, -100, 0.6, 0)
    CancelBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CancelBtn.Text = "CLOSE & STOP SCRIPT"
    CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    CancelBtn.MouseButton1Click:Connect(function()
        BanScreen:Destroy()
    end)

    -- [UPDATE: Halt Execution (task.wait) সরিয়ে সেফ কিক বসানো হলো যাতে গেম হ্যাং না করে]
    player:Kick("\n[RAFSAN HUB SECURITY]\n" .. rText)
end

-- ১. Pre-load Injection Check (আগেই ট্রু করে রাখলে ধরবে)
if _G.Rafsan_Internal_Key_Bypass_v1 ~= nil and _G.Rafsan_Internal_Key_Bypass_v1 == true then
    executePermanentBan("Honeypot Triggered: Pre-load injection detected.", "High")
end

_G.Rafsan_Internal_Key_Bypass_v1 = false  
_G.RafsanHub_Free_VIP_Access = false      
_G.Rafsan_Premium_Spoof = false           
_G.Unlock_ProMax_Hidden_Dev = false       
_G.Rafsan_Admin_Panel_Unlock = false      
_G.Force_Disable_Heartbeat = false        
_G.Rafsan_Bypass_AntiBan = false          
_G.Disable_Security_Kick = false          

-- [ANTI-TAMPER LOOP: পাহারা দেওয়ার লজিক]
task.spawn(function()
    while task.wait(3) do
        if _G.Rafsan_Internal_Key_Bypass_v1 
           or _G.Unlock_ProMax_Hidden_Dev 
           or _G.RafsanHub_Free_VIP_Access
           or _G.Rafsan_Premium_Spoof
           or _G.Rafsan_Admin_Panel_Unlock
           or _G.Force_Disable_Heartbeat
           or _G.Rafsan_Bypass_AntiBan
           or _G.Disable_Security_Kick then
            
            executePermanentBan("Honeypot Triggered: Attempted to modify security variables.", "High")
        end
    end
end)

-- =========================================================================
-- 📊 [LIVE DATA TRACKING MODULE] - ফায়ারবেসে ডেটা পাঠানো
-- =========================================================================
task.spawn(function()
    local renderTrackingUrl = getRenderUrl() .. "/live-track"
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if not req then return end

    while task.wait(60) do -- প্রতি ৬০ সেকেন্ড পরপর আপডেট (কোনো ল্যাগ হবে না)
        if _G.Is_Local_Testing then continue end 
        
        pcall(function()
            req({
                Url = renderTrackingUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    username = player.Name,
                    userId = player.UserId,
                    hwid = MyHwidHash,
                    device = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and "Mobile" or "PC",
                    gameId = game.PlaceId,
                    runtime = math.floor(workspace.DistributedGameTime) -- কত সেকেন্ড খেলছে
                })
            })
        end)
    end
end)

-- =========================================================================
-- 🔒 [SECURITY CORE - END]
-- =========================================================================

-- ⚙️ [CONFIG] 
-- // Main Settings Table.
local Config = {
    TackleCooldown = 0.5, DribbleCooldown = 0.8, AutoTackleEnabled = false, AutoDribbleEnabled = false, ReachEnabled = false, ReachVisualizer = false, ReachX = 15, ReachY = 15, ReachZ = 15, 
    AutoCurveEnabled = false, CurveRate = 20, EspLineEnabled = false, EspBoxEnabled = false, TeammateColor = Color3.fromRGB(30, 255, 30), EnemyColor = Color3.fromRGB(255, 30, 30),
    BallEspEnabled = false, BallItemEsp = false, TackleBoostEnabled = false, TackleBoostPower = 3.5, InfinityStaminaEnabled = false, SafeSpeedEnabled = false, SpeedPower = 15,
    MenuHeight = 340, MenuWidth = 580, MenuTransparency = 0, MenuRainbow = false, LogoSpeed = 0
}

-- 🌟 [AI HOOKS & UPDATERS] 
getgenv().ToggleUpdaters = {}
getgenv().SliderUpdaters = {}
getgenv().ColorUpdaters = {}
getgenv().PremiumLocks = {} -- 🔒 Tracks all premium lock icons

-- 🎨 [THEME] 
local Color_PrimaryGold = Color3.fromRGB(212, 175, 55)
local Color_BrightGold = Color3.fromRGB(255, 215, 0)
local Color_DarkGold = Color3.fromRGB(150, 120, 40)
local Color_BgDark = Color3.fromRGB(12, 12, 15)
local Color_BgLighter = Color3.fromRGB(22, 22, 26)
local Color_Hover = Color3.fromRGB(32, 32, 38)

-- ⚡ [REMOTES] 
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local ActionRemote = Remotes and Remotes:FindFirstChild("Action")
local ShootRemote = Remotes and Remotes:FindFirstChild("ShootTheBaII")

-- 🖥️ [UI SETUP] 
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true 

pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = game:GetService("CoreGui")
    else ScreenGui.Parent = game:GetService("CoreGui") end
end)
if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- // [DRAG MODULE]
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 🌟 [MAIN MENU UI]
local LogoButton = Instance.new("ImageButton")
LogoButton.Size, LogoButton.Position = UDim2.new(0, 45, 0, 45), UDim2.new(0, 20, 0, 60)
LogoButton.BackgroundColor3, LogoButton.BackgroundTransparency, LogoButton.Image, LogoButton.BorderSizePixel = Color_BgDark, 0.2, "rbxassetid://118480450941502", 0 
LogoButton.Parent = ScreenGui
Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(0, 6)
local LogoStroke = Instance.new("UIStroke", LogoButton) 
LogoStroke.Color, LogoStroke.Thickness = Color_PrimaryGold, 2 
makeDraggable(LogoButton, LogoButton)

local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
MainFrame.Size = UDim2.new(0, Config.MenuWidth, 0, Config.MenuHeight) 
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 30)
MainFrame.BackgroundColor3 = Color_BgDark
MainFrame.BackgroundTransparency = Config.MenuTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color_BgDark), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22))}) 
MainGradient.Rotation = 45 

local Texture = Instance.new("ImageLabel", MainFrame)
Texture.Size, Texture.BackgroundTransparency, Texture.Image = UDim2.new(1, 0, 1, 0), 1, "rbxassetid://3192562637"
Texture.ImageColor3, Texture.ImageTransparency = Color_BrightGold, 0.85
Texture.ScaleType, Texture.TileSize = Enum.ScaleType.Tile, UDim2.new(0, 70, 0, 70) 
Instance.new("UICorner", Texture).CornerRadius = UDim.new(0, 12) 

local UIScale = Instance.new("UIScale", MainFrame) UIScale.Scale = 0 
local UIStroke = Instance.new("UIStroke", MainFrame) 
UIStroke.Color, UIStroke.Thickness, UIStroke.Transparency = Color_BrightGold, 2, 0.1 

task.spawn(function() while true do TweenService:Create(UIStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play() task.wait(1.5) TweenService:Create(UIStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play() task.wait(1.5) end end)

local Title = Instance.new("TextLabel", MainFrame) Title.Size, Title.Position, Title.BackgroundTransparency, Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = UDim2.new(1, -140, 0, 26), UDim2.new(0, 15, 0, 4), 1, "RAFSAN HUB VIP", Color3.fromRGB(255, 255, 255), Enum.Font.PermanentMarker, 24, Enum.TextXAlignment.Left 
local TitleGradient = Instance.new("UIGradient", Title) TitleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 150)), ColorSequenceKeypoint.new(0.5, Color_PrimaryGold), ColorSequenceKeypoint.new(1, Color_DarkGold)}) 
local TitleStroke = Instance.new("UIStroke", Title) TitleStroke.Color, TitleStroke.Thickness = Color3.fromRGB(0, 0, 0), 1.2 

local Subtitle = Instance.new("TextLabel", MainFrame) Subtitle.Size, Subtitle.Position, Subtitle.BackgroundTransparency, Subtitle.Text, Subtitle.TextColor3, Subtitle.Font, Subtitle.TextSize, Subtitle.TextXAlignment = UDim2.new(1, -140, 0, 14), UDim2.new(0, 15, 0, 30), 1, "Script For Realistic Street Soccer V1 | Perfect Engine", Color3.fromRGB(230, 230, 230), Enum.Font.Roboto, 8, Enum.TextXAlignment.Left 

local Divider = Instance.new("Frame", MainFrame) Divider.Size, Divider.Position, Divider.BackgroundColor3, Divider.BorderSizePixel = UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0, 48), Color3.fromRGB(255,255,255), 0 
local DivGrad = Instance.new("UIGradient", Divider) DivGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color_DarkGold), ColorSequenceKeypoint.new(0.5, Color_BrightGold), ColorSequenceKeypoint.new(1, Color_DarkGold)}) 

local MinimizeButton = Instance.new("TextButton", MainFrame) MinimizeButton.Size, MinimizeButton.Position, MinimizeButton.BackgroundTransparency, MinimizeButton.Text, MinimizeButton.TextColor3, MinimizeButton.Font, MinimizeButton.TextSize, MinimizeButton.ZIndex = UDim2.new(0, 45, 0, 48), UDim2.new(1, -80, 0, 0), 1, "-", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 24, 2 
local MinGrad = Instance.new("UIGradient", MinimizeButton) MinGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color_BrightGold), ColorSequenceKeypoint.new(1, Color_PrimaryGold)}) 

local CloseButton = Instance.new("TextButton", MainFrame) CloseButton.Size, CloseButton.Position, CloseButton.BackgroundTransparency, CloseButton.Text, CloseButton.TextColor3, CloseButton.Font, CloseButton.TextSize, CloseButton.ZIndex = UDim2.new(0, 35, 0, 48), UDim2.new(1, -35, 0, 0), 1, "X", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 16, 2 
local CloseGrad = Instance.new("UIGradient", CloseButton) CloseGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color_BrightGold), ColorSequenceKeypoint.new(1, Color_PrimaryGold)}) 


-- 🔴 [AUTO-RESIZING VIP BADGE]
local StatusBadge = Instance.new("Frame", MainFrame)
StatusBadge.Size = UDim2.new(0, 0, 0, 20)
StatusBadge.AutomaticSize = Enum.AutomaticSize.X 
StatusBadge.AnchorPoint = Vector2.new(1, 0)
StatusBadge.Position = UDim2.new(1, -90, 0, 14) 
StatusBadge.BorderSizePixel = 0
StatusBadge.ClipsDescendants = true
Instance.new("UICorner", StatusBadge).CornerRadius = UDim.new(0, 6)

local BadgePadding = Instance.new("UIPadding", StatusBadge)
BadgePadding.PaddingLeft = UDim.new(0, 8)
BadgePadding.PaddingRight = UDim.new(0, 8)

local StatusText = Instance.new("TextLabel", StatusBadge)
StatusText.Size = UDim2.new(0, 0, 1, 0) 
StatusText.AutomaticSize = Enum.AutomaticSize.X 
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 13 
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.ZIndex = 3

local GlowOverlay = Instance.new("Frame", StatusBadge)
GlowOverlay.Size = UDim2.new(1, 0, 1, 0)
GlowOverlay.BackgroundTransparency = 0
GlowOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlowOverlay.BorderSizePixel = 0
GlowOverlay.ZIndex = 2
Instance.new("UICorner", GlowOverlay).CornerRadius = UDim.new(0, 6)

local ShinyGrad = Instance.new("UIGradient", GlowOverlay)
ShinyGrad.Rotation = 45
ShinyGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(0.6, 1),
    NumberSequenceKeypoint.new(1, 1)
})
ShinyGrad.Offset = Vector2.new(-1, 0)


-- // 🔒 VIP & LOCK SYSTEM UPDATER
getgenv().UpdateVIPStatus = function(planName)
    if planName == "FREE" or planName == "" then
        getgenv().IsVIP = false
        StatusBadge.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        StatusText.Text = "FREE"
        if GlowOverlay then GlowOverlay.Visible = false end
    else
        getgenv().IsVIP = true
        StatusBadge.BackgroundColor3 = Color_PrimaryGold
        StatusText.Text = planName 
        if GlowOverlay then GlowOverlay.Visible = true end
    end
    
    if getgenv().PremiumLocks then
        for _, item in ipairs(getgenv().PremiumLocks) do
            if type(item) == "table" and item.Lock and item.Lock.Parent then
                item.Lock.Visible = not getgenv().IsVIP
            end
            
            if type(item) == "table" and item.Label and item.Label.Parent then
                local targetPos = getgenv().IsVIP and item.OriginalPos or item.ShiftedPos
                TweenService:Create(item.Label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
            end
        end
    end
end


getgenv().UpdateVIPStatus(CurrentPlan)

task.spawn(function()
    while true do
        if getgenv().IsVIP then
            TweenService:Create(ShinyGrad, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
            task.wait(0.8)
            ShinyGrad.Offset = Vector2.new(-1, 0)
            task.wait(2.5) 
        else
            task.wait(1)
        end
    end
end)


-- 🔴 [HEARTBEAT LOOP: SECURITY & BAN HANDLER]
task.spawn(function()
    local RenderApiUrl = getRenderUrl() .. "/verify-key"
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if not req then return end
    
        while task.wait(20) do 
        if _G.Is_Local_Testing then continue end 

        if CurrentPlan == "FREE" or CurrentPlan == "" then
            if getgenv().IsVIP == true then
                player:Kick("🚫 EXPLOIT DETECTED: Fake VIP Access Blocked 🚫")
            end
            continue 
        end

        local success, response = pcall(function()
            return req({
                Url = RenderApiUrl,
                Method = "POST",
                Body = HttpService:JSONEncode({
                    key = MyLoginKey, 
                    hwid = MyHwidHash
                }),
                Headers = {["Content-Type"] = "application/json"}
            })
        end)

        if success and response then
            local decodeSuccess, decoded = pcall(function() return HttpService:JSONDecode(response.Body) end)
            if not decodeSuccess then decoded = {} end
            
            if response.StatusCode == 403 or response.StatusCode == 401 or decoded.valid == false then
                pcall(function() 
                    if delfile then delfile("RafsanHub/RafsanHubKey.txt") end
                    if writefile then writefile("RafsanHub/RafsanHubKey.txt", "") end
                end)
                
                local banMsg = decoded.banreason and ("\n\nReason: " .. decoded.banreason) or "\n\nReason: Invalid or Banned Key"
                player:Kick("🚫 YOU HAVE BEEN BANNED FROM RAFSAN HUB VIP 🚫" .. banMsg)
                break 
            end

            if response.StatusCode == 200 and decoded.valid then
                local newPlan = tostring(decoded.plan or "FREE"):upper()
                
                if newPlan ~= CurrentPlan then
                    CurrentPlan = newPlan
                    if getgenv().UpdateVIPStatus then
                        getgenv().UpdateVIPStatus(CurrentPlan)
                    end
                    
                    if CurrentPlan == "FREE" then
                        local vipFeatures = {
                            "AdvanceShootUI", "AdvanceTackleUI", "AutoTackleEnabled", 
                            "AutoDribbleEnabled", "TackleBoostEnabled", "InfinityStaminaEnabled", 
                            "SafeSpeedEnabled", "AutoCurveEnabled"
                        }
                        for _, feature in ipairs(vipFeatures) do
                            if getgenv().ToggleUpdaters and getgenv().ToggleUpdaters[feature] then
                                pcall(function() getgenv().ToggleUpdaters[feature](false) end)
                            end
                        end
                    end
                end
            end
        end
    end
end)


-- // [UI: SEARCH & NAVIGATION FRAMEWORK]
local VerticalDivider = Instance.new("Frame", MainFrame) VerticalDivider.Size, VerticalDivider.Position, VerticalDivider.BackgroundColor3, VerticalDivider.BackgroundTransparency, VerticalDivider.BorderSizePixel = UDim2.new(0, 2, 1, -66), UDim2.new(0, 115, 0, 56), Color_PrimaryGold, 0.7, 0 

local SearchBackground = Instance.new("Frame", MainFrame) 
SearchBackground.Position, SearchBackground.Size, SearchBackground.BackgroundColor3, SearchBackground.BackgroundTransparency, SearchBackground.BorderSizePixel = UDim2.new(0, 130, 0, 56), UDim2.new(1, -145, 0, 34), Color_BgLighter, 0.4, 0 
Instance.new("UICorner", SearchBackground).CornerRadius = UDim.new(0, 4) 
local SearchStroke = Instance.new("UIStroke", SearchBackground) 
SearchStroke.Color, SearchStroke.Thickness, SearchStroke.Transparency = Color_PrimaryGold, 1, 0.5 

local SearchIcon = Instance.new("ImageLabel", SearchBackground)
SearchIcon.Size = UDim2.new(0, 28, 0, 28) 
SearchIcon.Position = UDim2.new(0, 6, 0.5, -14) 
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://93237153057255"
SearchIcon.ImageColor3 = Color3.fromRGB(150, 140, 110) 
SearchIcon.ScaleType = Enum.ScaleType.Fit 

local SearchView = Instance.new("TextBox", SearchBackground) 
SearchView.Size, SearchView.Position, SearchView.BackgroundTransparency, SearchView.ClearTextOnFocus, SearchView.TextTruncate, SearchView.TextXAlignment, SearchView.Text, SearchView.PlaceholderText, SearchView.PlaceholderColor3, SearchView.TextColor3, SearchView.Font, SearchView.TextSize = UDim2.new(1, -40, 1, 0), UDim2.new(0, 34, 0, 0), 1, false, Enum.TextTruncate.AtEnd, Enum.TextXAlignment.Left, "", "Search features...", Color3.fromRGB(150, 140, 110), Color3.fromRGB(255, 255, 255), Enum.Font.GothamMedium, 13 

-- 🌟 [TAB VIEW ARCHITECTURE]
local TabScroll = Instance.new("ScrollingFrame", MainFrame) 
TabScroll.Size, TabScroll.Position, TabScroll.BackgroundTransparency, TabScroll.ScrollBarThickness = UDim2.new(0, 105, 1, -61), UDim2.new(0, 5, 0, 56), 1, 0
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y 
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local TabLayout = Instance.new("UIListLayout", TabScroll) TabLayout.Padding = UDim.new(0, 6) 
local TabPadding = Instance.new("UIPadding", TabScroll) TabPadding.PaddingTop, TabPadding.PaddingLeft, TabPadding.PaddingRight = UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4) 

local FeatureArea = Instance.new("Frame", MainFrame) FeatureArea.Size, FeatureArea.Position, FeatureArea.BackgroundTransparency = UDim2.new(1, -135, 1, -100), UDim2.new(0, 125, 0, 98), 1 

-- 🔘 [ADVANCED MOBILE ACTION BUTTONS]
local ShootCircle = Instance.new("TextButton", ScreenGui) 
ShootCircle.Size, ShootCircle.Position, ShootCircle.BackgroundColor3, ShootCircle.BackgroundTransparency, ShootCircle.Text, ShootCircle.TextColor3, ShootCircle.TextStrokeTransparency, ShootCircle.TextStrokeColor3, ShootCircle.Font, ShootCircle.TextSize, ShootCircle.Visible = UDim2.new(0, 90, 0, 90), UDim2.new(0.8, -10, 0.05, 0), Color_BgDark, 0.2, "ADVANCE\nSHOOT", Color_BrightGold, 0, Color3.fromRGB(0, 0, 0), Enum.Font.PermanentMarker, 14, false
makeDraggable(ShootCircle, ShootCircle) Instance.new("UICorner", ShootCircle).CornerRadius = UDim.new(1, 0)
local SCStroke = Instance.new("UIStroke", ShootCircle) SCStroke.ApplyStrokeMode, SCStroke.Thickness, SCStroke.Color = Enum.ApplyStrokeMode.Border, 2, Color_PrimaryGold

local TackleCircle = Instance.new("TextButton", ScreenGui) 
TackleCircle.Size, TackleCircle.Position, TackleCircle.BackgroundColor3, TackleCircle.BackgroundTransparency, TackleCircle.Text, TackleCircle.TextColor3, TackleCircle.TextStrokeTransparency, TackleCircle.TextStrokeColor3, TackleCircle.Font, TackleCircle.TextSize, TackleCircle.Visible = UDim2.new(0, 75, 0, 75), UDim2.new(0.8, -10, 0.65, 0), Color_BgDark, 0.2, "MANUAL\nTACKLE", Color_BrightGold, 0, Color3.fromRGB(0, 0, 0), Enum.Font.PermanentMarker, 12, false
makeDraggable(TackleCircle, TackleCircle) Instance.new("UICorner", TackleCircle).CornerRadius = UDim.new(1, 0) 
local TCStroke = Instance.new("UIStroke", TackleCircle) TCStroke.ApplyStrokeMode, TCStroke.Thickness, TCStroke.Color = Enum.ApplyStrokeMode.Border, 2, Color_PrimaryGold


-- 🗂️ [TAB & PAGE CONTROLLER]
local allTabs, allPages, AllSearchItems = {}, {}, {}

local tabsWithSearch = {
    [1] = true,  
    [2] = false, 
    [3] = false, 
    [4] = false, 
}

local function switchTab(tabIndex)
    for _, t in pairs(allTabs) do 
        TweenService:Create(t.Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play() 
        TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
        t.Label.TextColor3, t.Icon.ImageColor3 = Color3.fromRGB(150, 140, 110), Color3.fromRGB(150, 140, 110) 
    end
    for _, p in pairs(allPages) do p.Visible = false end
    
    local activeTab = allTabs[tabIndex]
    if activeTab then 
        TweenService:Create(activeTab.Stroke, TweenInfo.new(0.25), {Transparency = 0}):Play() 
        TweenService:Create(activeTab.Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.85}):Play() 
        activeTab.Button.BackgroundColor3, activeTab.Label.TextColor3, activeTab.Icon.ImageColor3 = Color_PrimaryGold, Color_BrightGold, Color_BrightGold 
        allPages[tabIndex].Visible = true 
        
        if tabsWithSearch[tabIndex] == true then 
            if SearchBackground then SearchBackground.Visible = true end
            if FeatureArea then 
                FeatureArea.Position = UDim2.new(0, 125, 0, 98)
                FeatureArea.Size = UDim2.new(1, -135, 1, -100)
            end
        else 
            if SearchBackground then SearchBackground.Visible = false end
            if FeatureArea then 
                FeatureArea.Position = UDim2.new(0, 125, 0, 56)
                FeatureArea.Size = UDim2.new(1, -135, 1, -61)
            end
        end
    end
end

local function createTabAndPage(tabName, iconId, isSingleColumn)
    local tabIndex = #allTabs + 1
    local TabBtn = Instance.new("TextButton", TabScroll) TabBtn.Size, TabBtn.BackgroundTransparency, TabBtn.Text = UDim2.new(1, 0, 0, 32), 1, "" 
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5) 
    local TabStroke = Instance.new("UIStroke", TabBtn) TabStroke.Color, TabStroke.Thickness, TabStroke.Transparency = Color_PrimaryGold, 1.5, 1
    local TabIcon = Instance.new("ImageLabel", TabBtn) TabIcon.Size, TabIcon.Position, TabIcon.BackgroundTransparency, TabIcon.Image, TabIcon.ImageColor3 = UDim2.new(0, 20, 0, 20), UDim2.new(0, 6, 0.5, -10), 1, "rbxassetid://"..tostring(iconId), Color3.fromRGB(150, 140, 110)
    local TabLabel = Instance.new("TextLabel", TabBtn) TabLabel.Size, TabLabel.Position, TabLabel.BackgroundTransparency, TabLabel.Text, TabLabel.TextColor3, TabLabel.Font, TabLabel.TextSize, TabLabel.TextXAlignment = UDim2.new(1, -32, 1, 0), UDim2.new(0, 32, 0, 0), 1, tabName, Color3.fromRGB(150, 140, 110), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left 
    
    local PageScroll = Instance.new("ScrollingFrame", FeatureArea) 
    PageScroll.Size, PageScroll.BackgroundTransparency, PageScroll.ScrollBarThickness = UDim2.new(1, 0, 1, 0), 1, 0
    PageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    PageScroll.Visible = false
    
    table.insert(allTabs, {Button = TabBtn, Stroke = TabStroke, Label = TabLabel, Icon = TabIcon}) 
    table.insert(allPages, PageScroll) 
    TabBtn.MouseButton1Click:Connect(function() switchTab(tabIndex) end) 
    
    if isSingleColumn then
        local MainCol = Instance.new("Frame", PageScroll)
        MainCol.Size = UDim2.new(1, -8, 1, 0) 
        MainCol.BackgroundTransparency = 1
        local MainList = Instance.new("UIListLayout", MainCol)
        MainList.Padding = UDim.new(0, 10)
        local Pad = Instance.new("UIPadding", MainCol)
        Pad.PaddingTop, Pad.PaddingBottom, Pad.PaddingLeft, Pad.PaddingRight = UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4)
        return MainCol, tabIndex
    else
        local LeftCol = Instance.new("Frame", PageScroll) 
        LeftCol.Size = UDim2.new(0.5, -4, 1, 0) 
        LeftCol.BackgroundTransparency = 1 
        local LeftList = Instance.new("UIListLayout", LeftCol) LeftList.Padding = UDim.new(0, 4) 
        
        local RightCol = Instance.new("Frame", PageScroll) 
        RightCol.Size = UDim2.new(0.5, -4, 1, 0)
        RightCol.Position = UDim2.new(0.5, 4, 0, 0)
        RightCol.BackgroundTransparency = 1 
        local RightList = Instance.new("UIListLayout", RightCol) RightList.Padding = UDim.new(0, 4) 
        
        local PadL = Instance.new("UIPadding", LeftCol) PadL.PaddingTop, PadL.PaddingBottom, PadL.PaddingLeft, PadL.PaddingRight = UDim.new(0, 2), UDim.new(0, 4), UDim.new(0, 2), UDim.new(0, 2) 
        local PadR = Instance.new("UIPadding", RightCol) PadR.PaddingTop, PadR.PaddingBottom, PadR.PaddingLeft, PadR.PaddingRight = UDim.new(0, 2), UDim.new(0, 4), UDim.new(0, 2), UDim.new(0, 2) 
        return LeftCol, RightCol, tabIndex
    end
end

-- // [UI BUILDERS]
local function createCFeature(parentColumn, titleText, tabIndex)
    local MainCont = Instance.new("Frame", parentColumn) MainCont.Size, MainCont.BackgroundColor3, MainCont.BorderSizePixel, MainCont.ClipsDescendants = UDim2.new(1, 0, 0, 30), Color_BgLighter, 0, true 
    Instance.new("UICorner", MainCont).CornerRadius = UDim.new(0, 8)
    local HighlightStroke = Instance.new("UIStroke", MainCont) HighlightStroke.Color, HighlightStroke.Thickness, HighlightStroke.Transparency = Color_PrimaryGold, 1, 1
    local TopBar = Instance.new("TextButton", MainCont) TopBar.Size, TopBar.BackgroundTransparency, TopBar.Text = UDim2.new(1, 0, 0, 30), 1, "" 
    
    TopBar.MouseEnter:Connect(function() TweenService:Create(MainCont, TweenInfo.new(0.2), {BackgroundColor3 = Color_Hover}):Play() end)
    TopBar.MouseLeave:Connect(function() TweenService:Create(MainCont, TweenInfo.new(0.2), {BackgroundColor3 = Color_BgLighter}):Play() end)
    
    local TitleLabel = Instance.new("TextLabel", TopBar) TitleLabel.Size, TitleLabel.Position, TitleLabel.BackgroundTransparency, TitleLabel.Text, TitleLabel.TextColor3, TitleLabel.Font, TitleLabel.TextSize, TitleLabel.TextXAlignment = UDim2.new(1, -40, 1, 0), UDim2.new(0, 10, 0, 0), 1, string.upper(titleText), Color_PrimaryGold, Enum.Font.PermanentMarker, 14, Enum.TextXAlignment.Left 
    local ArrowIcon = Instance.new("ImageLabel", TopBar) ArrowIcon.Size, ArrowIcon.Position, ArrowIcon.BackgroundTransparency, ArrowIcon.Image, ArrowIcon.ImageColor3 = UDim2.new(0, 18, 0, 18), UDim2.new(1, -26, 0.5, -9), 1, "rbxassetid://6031091004", Color_PrimaryGold 
    local ContentFrame = Instance.new("Frame", MainCont) ContentFrame.Size, ContentFrame.Position, ContentFrame.BackgroundTransparency, ContentFrame.Visible = UDim2.new(1, 0, 1, -30), UDim2.new(0, 0, 0, 30), 1, false 
    local ContentList = Instance.new("UIListLayout", ContentFrame) ContentList.Padding, ContentList.SortOrder = UDim.new(0, 2), Enum.SortOrder.LayoutOrder 
    local Padding = Instance.new("UIPadding", ContentFrame) Padding.PaddingTop, Padding.PaddingBottom, Padding.PaddingLeft, Padding.PaddingRight = UDim.new(0, 4), UDim.new(0, 5), UDim.new(0, 6), UDim.new(0, 6) 
    
    local isOpen = false
    local function updateSize() 
        if isOpen then 
            ContentFrame.Visible = true 
            TweenService:Create(MainCont, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 30 + ContentList.AbsoluteContentSize.Y + 9)}):Play() 
            TweenService:Create(ArrowIcon, TweenInfo.new(0.3), {Rotation = 180}):Play() 
            TweenService:Create(HighlightStroke, TweenInfo.new(0.3), {Transparency = 0.2}):Play() 
        else 
            local closeT = TweenService:Create(MainCont, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 30)}) 
            closeT:Play() 
            TweenService:Create(ArrowIcon, TweenInfo.new(0.3), {Rotation = 0}):Play() 
            TweenService:Create(HighlightStroke, TweenInfo.new(0.3), {Transparency = 1}):Play() 
            closeT.Completed:Connect(function() if not isOpen then ContentFrame.Visible = false end end) 
        end 
    end
    TopBar.MouseButton1Click:Connect(function() isOpen = not isOpen updateSize() end) 
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if isOpen then MainCont.Size = UDim2.new(1, 0, 0, 30 + ContentList.AbsoluteContentSize.Y + 9) end end)
    local function forceOpen() if not isOpen then isOpen = true updateSize() end end 
    return {Content = ContentFrame, MainCont = MainCont, ForceOpen = forceOpen, TabIndex = tabIndex}
end

-- 🔒 [NEW] PREMIUM LOCK TOGGLE SYSTEM (FIXED POS & SIZE)
local function addToggle(cFeature, text, arg3, arg4)
    local callback = type(arg3) == "function" and arg3 or arg4
    local isPremium = type(arg3) == "boolean" and arg3 or false
    
    local state = false 
    local ToggleCont = Instance.new("TextButton", cFeature.Content) 
    ToggleCont.Size, ToggleCont.BackgroundTransparency, ToggleCont.BackgroundColor3, ToggleCont.Text = UDim2.new(1, 0, 0, 30), 1, Color_Hover, "" 
    Instance.new("UICorner", ToggleCont).CornerRadius = UDim.new(0, 6) 
    
    ToggleCont.MouseEnter:Connect(function() TweenService:Create(ToggleCont, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play() end)
    ToggleCont.MouseLeave:Connect(function() TweenService:Create(ToggleCont, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end)
    
    local Label = Instance.new("TextLabel", ToggleCont) 
    Label.Size, Label.Position, Label.BackgroundTransparency, Label.Text, Label.TextColor3, Label.Font, Label.TextSize, Label.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), 1, text, Color3.fromRGB(220, 220, 220), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left 
    
    local Pill = Instance.new("Frame", ToggleCont) 
    Pill.Size, Pill.AnchorPoint, Pill.Position, Pill.BackgroundColor3 = UDim2.new(0, 34, 0, 18), Vector2.new(1, 0.5), UDim2.new(1, -5, 0.5, 0), Color3.fromRGB(40, 40, 45) 
    Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0) 
    local Circle = Instance.new("Frame", Pill) 
    Circle.Size, Circle.AnchorPoint, Circle.Position, Circle.BackgroundColor3 = UDim2.new(0, 14, 0, 14), Vector2.new(0, 0.5), UDim2.new(0, 2, 0.5, 0), Color3.fromRGB(200, 200, 200) 
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0) 
    
    local LockIcon = Instance.new("ImageLabel", ToggleCont)
    LockIcon.Size = UDim2.new(0, 16, 0, 16) 
    LockIcon.AnchorPoint = Vector2.new(0, 0.5)
    LockIcon.Position = UDim2.new(0, 10, 0.5, 0) 
    LockIcon.BackgroundTransparency = 1
    LockIcon.Image = "rbxassetid://117482937245151" 
    LockIcon.ImageColor3 = Color3.fromRGB(220, 220, 220) 
    LockIcon.ScaleType = Enum.ScaleType.Fit 
    LockIcon.Visible = false
    
    if isPremium then
        table.insert(getgenv().PremiumLocks, {
            Lock = LockIcon,
            Label = Label,
            OriginalPos = UDim2.new(0, 10, 0, 0),
            ShiftedPos = UDim2.new(0, 32, 0, 0)
        })
        LockIcon.Visible = not getgenv().IsVIP
        Label.Position = getgenv().IsVIP and UDim2.new(0, 10, 0, 0) or UDim2.new(0, 32, 0, 0)
        Label.Size = getgenv().IsVIP and UDim2.new(1, -50, 1, 0) or UDim2.new(1, -72, 1, 0)
    end
    
    local function SetState(newState)
        if state == newState then return end
        state = newState
        TweenService:Create(Pill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = state and Color_PrimaryGold or Color3.fromRGB(40, 40, 45)}):Play() 
        TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)}):Play() 
        if callback then callback(state) end 
    end
    
    ToggleCont.MouseButton1Click:Connect(function() 
        if isPremium and not getgenv().IsVIP then
            TweenService:Create(LockIcon, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 20, 0, 20)}):Play()
            task.delay(0.1, function() TweenService:Create(LockIcon, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play() end)
            return 
        end
        SetState(not state) 
    end) 
    
    local plainText = string.lower(string.gsub(text, " ", ""))
    table.insert(AllSearchItems, { Name = plainText, UI = ToggleCont, cFeature = cFeature })
    return SetState 
end

-- 🔒 [NEW] PREMIUM LOCK SLIDER SYSTEM (FIXED POS & SIZE)
local function addSlider(cFeature, text, minVal, maxVal, arg5, arg6)
    local callback = type(arg5) == "function" and arg5 or arg6
    local isPremium = type(arg5) == "boolean" and arg5 or false

    local SliderFrame = Instance.new("Frame", cFeature.Content) 
    SliderFrame.Size, SliderFrame.BackgroundTransparency = UDim2.new(1, 0, 0, 36), 1 
    
    local TitleLabel = Instance.new("TextLabel", SliderFrame) 
    TitleLabel.Size, TitleLabel.Position, TitleLabel.BackgroundTransparency, TitleLabel.Text, TitleLabel.TextColor3, TitleLabel.Font, TitleLabel.TextSize, TitleLabel.TextXAlignment = UDim2.new(1, -40, 0, 18), UDim2.new(0, 10, 0, 0), 1, text, Color3.fromRGB(220, 220, 220), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left 
    
    local ValueLabel = Instance.new("TextLabel", SliderFrame) 
    ValueLabel.Size, ValueLabel.Position, ValueLabel.BackgroundTransparency, ValueLabel.Text, ValueLabel.TextColor3, ValueLabel.Font, ValueLabel.TextSize, ValueLabel.TextXAlignment = UDim2.new(0, 40, 0, 18), UDim2.new(1, -45, 0, 0), 1, tostring(minVal), Color_PrimaryGold, Enum.Font.GothamBold, 13, Enum.TextXAlignment.Right 
    
    local TrackBg = Instance.new("TextButton", SliderFrame) 
    TrackBg.Text, TrackBg.Size, TrackBg.Position, TrackBg.BackgroundColor3, TrackBg.AutoButtonColor = "", UDim2.new(1, -10, 0, 6), UDim2.new(0, 5, 0, 24), Color3.fromRGB(40, 40, 45), false 
    Instance.new("UICorner", TrackBg).CornerRadius = UDim.new(1, 0) 
    local TrackFill = Instance.new("Frame", TrackBg) 
    TrackFill.Size, TrackFill.BackgroundColor3 = UDim2.new(0, 0, 1, 0), Color_PrimaryGold 
    Instance.new("UICorner", TrackFill).CornerRadius = UDim.new(1, 0) 
    local LimitArea = Instance.new("Frame", TrackBg) 
    LimitArea.Size, LimitArea.AnchorPoint, LimitArea.Position, LimitArea.BackgroundTransparency = UDim2.new(1, -12, 1, 0), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), 1 
    
    local Ball = Instance.new("Frame", LimitArea) 
    Ball.Size, Ball.AnchorPoint, Ball.Position, Ball.BackgroundColor3 = UDim2.new(0, 14, 0, 14), Vector2.new(0.5, 0.5), UDim2.new(0, 0, 0.5, 0), Color_PrimaryGold 
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0) 
    
    local LockIcon = Instance.new("ImageLabel", SliderFrame)
    LockIcon.Size = UDim2.new(0, 16, 0, 16)
    LockIcon.AnchorPoint = Vector2.new(0, 0.5)
    LockIcon.Position = UDim2.new(0, 10, 0, 9) 
    LockIcon.BackgroundTransparency = 1
    LockIcon.Image = "rbxassetid://117482937245151"
    LockIcon.ImageColor3 = Color3.fromRGB(220, 220, 220)
    LockIcon.ScaleType = Enum.ScaleType.Fit 
    LockIcon.Visible = false

    if isPremium then
        table.insert(getgenv().PremiumLocks, {
            Lock = LockIcon,
            Label = TitleLabel,
            OriginalPos = UDim2.new(0, 10, 0, 0),
            ShiftedPos = UDim2.new(0, 32, 0, 0)
        })
        LockIcon.Visible = not getgenv().IsVIP
        TitleLabel.Position = getgenv().IsVIP and UDim2.new(0, 10, 0, 0) or UDim2.new(0, 32, 0, 0)
        TitleLabel.Size = getgenv().IsVIP and UDim2.new(1, -40, 0, 18) or UDim2.new(1, -62, 0, 18)
    end

    local function setSliderValue(val)
        val = tonumber(val)
        if not val then return end
        val = math.clamp(val, minVal, maxVal)
        local percent = (val - minVal) / (maxVal - minVal)
        TweenService:Create(Ball, TweenInfo.new(0.15), {Position = UDim2.new(percent, 0, 0.5, 0)}):Play() 
        TweenService:Create(TrackFill, TweenInfo.new(0.15), {Size = UDim2.new(0, (LimitArea.AbsoluteSize.X * percent) + 6, 1, 0)}):Play()
        ValueLabel.Text = tostring(val) 
        if callback then callback(val) end 
    end

    local sliding = false
    local function updateSlider(input) 
        local percent = math.clamp((input.Position.X - LimitArea.AbsolutePosition.X) / LimitArea.AbsoluteSize.X, 0, 1) 
        local val = math.floor(minVal + ((maxVal - minVal) * percent)) 
        setSliderValue(val)
    end
    
    TrackBg.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            if isPremium and not getgenv().IsVIP then
                TweenService:Create(LockIcon, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 20, 0, 20)}):Play()
                task.delay(0.1, function() TweenService:Create(LockIcon, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play() end)
                return
            end
            sliding = true 
            updateSlider(input) 
        end 
    end) 
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end) 
    UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end) 
    
    local plainText = string.lower(string.gsub(text, " ", ""))
    table.insert(AllSearchItems, { Name = plainText, UI = SliderFrame, cFeature = cFeature })
    return setSliderValue
end

local activeColorBox, activeColorCallback = nil, nil
local GlobalPicker = Instance.new("Frame", ScreenGui) GlobalPicker.Name, GlobalPicker.Size, GlobalPicker.AnchorPoint, GlobalPicker.BackgroundColor3, GlobalPicker.Visible, GlobalPicker.Active, GlobalPicker.ZIndex = "ColorPickerLayout", UDim2.new(0, 180, 0, 330), Vector2.new(0.5, 0.5), Color_BgLighter, false, true, 100 
Instance.new("UICorner", GlobalPicker).CornerRadius = UDim.new(0, 6) 
local GPStroke = Instance.new("UIStroke", GlobalPicker) GPStroke.Color, GPStroke.Thickness = Color_PrimaryGold, 1.5 
local GPHeader = Instance.new("Frame", GlobalPicker) GPHeader.Size, GPHeader.BackgroundTransparency, GPHeader.ZIndex = UDim2.new(1, 0, 0, 30), 1, 101 
makeDraggable(GlobalPicker, GPHeader) 
local GPClose = Instance.new("TextButton", GPHeader) GPClose.Size, GPClose.Position, GPClose.BackgroundTransparency, GPClose.Text, GPClose.TextColor3, GPClose.Font, GPClose.TextSize, GPClose.ZIndex = UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0, 0), 1, "X", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 14, 102 
GPClose.MouseButton1Click:Connect(function() GlobalPicker.Visible = false end)

local PreviewColorBox = Instance.new("Frame", GlobalPicker) PreviewColorBox.Size, PreviewColorBox.Position, PreviewColorBox.AnchorPoint, PreviewColorBox.BackgroundColor3, PreviewColorBox.ZIndex = UDim2.new(0, 36, 0, 36), UDim2.new(0.5, 0, 0, 35), Vector2.new(0.5, 0), Color3.fromRGB(255, 255, 255), 101 
Instance.new("UICorner", PreviewColorBox).CornerRadius = UDim.new(0, 4) 
local PreviewStroke = Instance.new("UIStroke", PreviewColorBox) PreviewStroke.Color, PreviewStroke.Thickness = Color3.fromRGB(80, 80, 85), 1.5 
local ColorWheel = Instance.new("ImageButton", GlobalPicker) ColorWheel.Size, ColorWheel.Position, ColorWheel.AnchorPoint, ColorWheel.BackgroundTransparency, ColorWheel.ZIndex, ColorWheel.Image, ColorWheel.ScaleType = UDim2.new(0, 110, 0, 110), UDim2.new(0.5, 0, 0, 85), Vector2.new(0.5, 0), 1, 101, "rbxassetid://98233588287292", Enum.ScaleType.Fit 
local SelectionBall = Instance.new("Frame", ColorWheel) SelectionBall.Size, SelectionBall.AnchorPoint, SelectionBall.Position, SelectionBall.BackgroundColor3, SelectionBall.ZIndex = UDim2.new(0, 10, 0, 10), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), Color3.fromRGB(255, 255, 255), 102 
Instance.new("UICorner", SelectionBall).CornerRadius = UDim.new(1, 0) 
local HexLabel = Instance.new("TextLabel", GlobalPicker) HexLabel.Size, HexLabel.Position, HexLabel.AnchorPoint, HexLabel.BackgroundTransparency, HexLabel.ZIndex, HexLabel.Text, HexLabel.TextColor3, HexLabel.Font, HexLabel.TextSize = UDim2.new(1, 0, 0, 20), UDim2.new(0.5, 0, 0, 205), Vector2.new(0.5, 0), 1, 101, "hex. #FFFFFF  100%", Color3.fromRGB(200, 200, 200), Enum.Font.Code, 11 
local PaletteFrame = Instance.new("Frame", GlobalPicker) PaletteFrame.Size, PaletteFrame.Position, PaletteFrame.AnchorPoint, PaletteFrame.BackgroundTransparency, PaletteFrame.ZIndex = UDim2.new(1, -20, 0, 40), UDim2.new(0.5, 0, 0, 235), Vector2.new(0.5, 0), 1, 101 
local PaletteGrid = Instance.new("UIGridLayout", PaletteFrame) PaletteGrid.CellSize, PaletteGrid.CellPadding, PaletteGrid.HorizontalAlignment, PaletteGrid.SortOrder = UDim2.new(0, 18, 0, 18), UDim2.new(0, 6, 0, 6), Enum.HorizontalAlignment.Center, Enum.SortOrder.LayoutOrder 
local GPApplyBtn = Instance.new("TextButton", GlobalPicker) GPApplyBtn.Size, GPApplyBtn.Position, GPApplyBtn.AnchorPoint, GPApplyBtn.BackgroundColor3, GPApplyBtn.BackgroundTransparency, GPApplyBtn.Text, GPApplyBtn.TextColor3, GPApplyBtn.Font, GPApplyBtn.TextSize, GPApplyBtn.ZIndex = UDim2.new(1, -20, 0, 30), UDim2.new(0.5, 0, 1, -15), Vector2.new(0.5, 1), Color_PrimaryGold, 0, "Apply", Color_BgDark, Enum.Font.GothamMedium, 13, 101 
Instance.new("UICorner", GPApplyBtn).CornerRadius = UDim.new(0, 4) 

local picking, currentSelectedColor = false, Color3.fromRGB(255, 255, 255)
local function rgbToHex(c) return string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255) end
local function updateColor(input)
    local r = ColorWheel.AbsoluteSize.X / 2 if r == 0 then r = 55 end
    local delta = Vector2.new(input.Position.X, input.Position.Y) - (ColorWheel.AbsolutePosition + Vector2.new(r, r))
    local dist = delta.Magnitude local ballDx, ballDy
    if dist <= r then ballDx, ballDy = delta.X, delta.Y else local angle = math.atan2(delta.Y, delta.X) ballDx, ballDy, dist = math.cos(angle)*r, math.sin(angle)*r, r end
    SelectionBall.Position = UDim2.new(0, ballDx + r, 0, ballDy + r)
    currentSelectedColor = Color3.fromHSV((math.atan2(ballDy, ballDx)/(math.pi*2))%1, dist/r, 1)
    PreviewColorBox.BackgroundColor3 = currentSelectedColor HexLabel.Text = "hex. " .. rgbToHex(currentSelectedColor) .. "  100%"
end
ColorWheel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then picking = true updateColor(input) end end) UserInputService.InputChanged:Connect(function(input) if picking and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateColor(input) end end) UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then picking = false end end)
for _, col in ipairs({Color3.fromRGB(255, 59, 48), Color3.fromRGB(255, 149, 0), Color3.fromRGB(255, 204, 0), Color3.fromRGB(76, 217, 100), Color3.fromRGB(90, 200, 250), Color3.fromRGB(0, 122, 255), Color3.fromRGB(88, 86, 214), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color_PrimaryGold}) do
    local cBtn = Instance.new("TextButton", PaletteFrame) cBtn.Text, cBtn.BackgroundColor3, cBtn.ZIndex = "", col, 102 
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0) 
    cBtn.MouseButton1Click:Connect(function() currentSelectedColor = col PreviewColorBox.BackgroundColor3 = col HexLabel.Text = "hex. " .. rgbToHex(col) .. "  100%" end)
end
GPApplyBtn.MouseButton1Click:Connect(function() GlobalPicker.Visible = false if activeColorBox then activeColorBox.BackgroundColor3 = currentSelectedColor end if activeColorCallback then activeColorCallback(currentSelectedColor) end end)

local function addColorPicker(cFeature, text, defaultColor, callback)
    local PickCont = Instance.new("Frame", cFeature.Content) PickCont.Size, PickCont.BackgroundTransparency = UDim2.new(1, 0, 0, 32), 1 
    local Label = Instance.new("TextLabel", PickCont) Label.Size, Label.Position, Label.BackgroundTransparency, Label.Text, Label.TextColor3, Label.Font, Label.TextSize, Label.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), 1, text, Color3.fromRGB(220, 220, 220), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left 
    local ColorBox = Instance.new("TextButton", PickCont) ColorBox.Size, ColorBox.AnchorPoint, ColorBox.Position, ColorBox.BackgroundColor3, ColorBox.Text = UDim2.new(0, 20, 0, 20), Vector2.new(1, 0.5), UDim2.new(1, -8, 0.5, 0), defaultColor or Color3.fromRGB(255, 255, 255), "" 
    Instance.new("UICorner", ColorBox).CornerRadius = UDim.new(0, 4) 
    
    local function openPicker()
        activeColorBox, activeColorCallback, currentSelectedColor = ColorBox, callback, ColorBox.BackgroundColor3 
        PreviewColorBox.BackgroundColor3 = currentSelectedColor 
        HexLabel.Text = "hex. " .. rgbToHex(currentSelectedColor) .. "  100%" 
        GlobalPicker.Position, GlobalPicker.Visible = UDim2.new(0.5, 0, 0.5, 0), true
    end
    ColorBox.MouseButton1Click:Connect(openPicker) 
    
    local basicColors = { red = "#FF0000", green = "#00FF00", blue = "#0000FF", yellow = "#FFFF00", black = "#000000", white = "#FFFFFF", purple = "#800080", pink = "#FFC0CB", orange = "#FFA500", cyan = "#00FFFF", gold = "#FFD700", grey = "#808080", gray = "#808080" }
    
    local function aiSetColor(cmdValue)
        cmdValue = string.match(cmdValue, "^%s*(.-)%s*$")
        if cmdValue == "PICK" then
            openPicker()
        else
            local hexStr = cmdValue
            if basicColors[string.lower(hexStr)] then hexStr = basicColors[string.lower(hexStr)] end
            local success, parsedColor = pcall(function() return Color3.fromHex(hexStr) end)
            if success then
                ColorBox.BackgroundColor3 = parsedColor
                if callback then callback(parsedColor) end
            end
        end
    end
    
    local plainText = string.lower(string.gsub(text, " ", ""))
    table.insert(AllSearchItems, { Name = plainText, UI = PickCont, cFeature = cFeature })
    return aiSetColor
end

-- =========================================================================
-- ⚙️ [GAMEPLAY LOGIC & HOOKS BINDING] 
-- =========================================================================
local menuClickTime = 0
LogoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then menuClickTime = tick() end
end)
LogoButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if tick() - menuClickTime < 0.25 then
            local isMenuOpen = not MainFrame.Visible
            if isMenuOpen then 
                MainFrame.Visible = true 
                TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            else
                local tween = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
                tween:Play()
                tween.Completed:Connect(function() MainFrame.Visible = false end)
            end
        end
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
    tween:Play() tween.Completed:Connect(function() MainFrame.Visible = false end)
end)

CloseButton.MouseButton1Click:Connect(function()
    if workspace:FindFirstChild("ShootESP") then workspace.ShootESP:Destroy() end
    if _G.CoreLoop then _G.CoreLoop:Disconnect() end
    ScreenGui:Destroy()
end)

local function GetPlayerTeam(playerName)
    local stats = workspace:FindFirstChild("PlayerStats")
    if stats then
        local awayFolder = stats:FindFirstChild("Away")
        local homeFolder = stats:FindFirstChild("Home")
        if awayFolder and awayFolder:FindFirstChild(playerName) then return "AWAY"
        elseif homeFolder and homeFolder:FindFirstChild(playerName) then return "HOME" end
    end
    return nil
end

local function GetMyTeam() return GetPlayerTeam(player.Name) or "HOME" end

local function IsTeammate(targetPlayer)
    if targetPlayer == player then return true end
    local myTeam, targetTeam = GetMyTeam(), GetPlayerTeam(targetPlayer.Name)
    if myTeam and targetTeam and myTeam == targetTeam then return true end
    if player.Team and targetPlayer.Team and player.Team == targetPlayer.Team then return true end
    return false
end

local RainbowCache = {}
local lastRainbowColor = nil

local function isGold(c)
    if typeof(c) ~= "Color3" then return false end
    local h, s, v = c:ToHSV()
    return (h >= 0.08 and h <= 0.20 and s >= 0.40 and v >= 0.30)
end

local function cacheElement(obj)
    pcall(function()
        if obj:IsA("UIStroke") then
            table.insert(RainbowCache, {Obj = obj, Prop = "Color", Orig = obj.Color})
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            table.insert(RainbowCache, {Obj = obj, Prop = "TextColor3", Orig = obj.TextColor3})
            table.insert(RainbowCache, {Obj = obj, Prop = "BackgroundColor3", Orig = obj.BackgroundColor3})
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            table.insert(RainbowCache, {Obj = obj, Prop = "ImageColor3", Orig = obj.ImageColor3})
        elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            table.insert(RainbowCache, {Obj = obj, Prop = "BackgroundColor3", Orig = obj.BackgroundColor3})
        elseif obj:IsA("UIGradient") then
            table.insert(RainbowCache, {Obj = obj, Prop = "Gradient", Orig = obj.Color})
        end
    end)
end

task.spawn(function()
    task.wait(0.5)
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Text == "GET PREMIUM" then
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("UIStroke") or child:IsA("UIGradient") or (child:IsA("Frame") and child.BackgroundTransparency == 0) then
                    child:Destroy()
                end
            end
        end
        cacheElement(obj)
    end
end)

ScreenGui.DescendantAdded:Connect(function(obj)
    task.delay(0.05, function() cacheElement(obj) end)
end)

local function registerToggle(name, func) getgenv().ToggleUpdaters[name] = func getgenv().ToggleUpdaters[string.lower(name)] = func end
local function registerSlider(name, func) getgenv().SliderUpdaters[name] = func getgenv().SliderUpdaters[string.lower(name)] = func end

registerToggle("MenuRainbow", function(state) Config.MenuRainbow = state end)
registerSlider("LogoSpeed", function(val) Config.LogoSpeed = tonumber(val) or 0 end)
registerSlider("MenuHeight", function(val) Config.MenuHeight = tonumber(val) or 340; if MainFrame then TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, Config.MenuWidth, 0, Config.MenuHeight)}):Play() end end)
registerSlider("MenuWidth", function(val) Config.MenuWidth = tonumber(val) or 580; if MainFrame then TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, Config.MenuWidth, 0, Config.MenuHeight)}):Play() end end)
registerSlider("MenuTransparency", function(val) Config.MenuTransparency = tonumber(val) and (tonumber(val) / 10) or 0; if MainFrame then TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = Config.MenuTransparency}):Play() end end)

RunService.RenderStepped:Connect(function(deltaTime)
    local isRainbow = Config.MenuRainbow
    local newRainbow = isRainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or nil
    local newSeq = isRainbow and ColorSequence.new(newRainbow) or nil

    if isRainbow then
        for _, item in ipairs(RainbowCache) do
            if item.Obj and item.Obj.Parent then
                if item.Prop == "Gradient" then
                    local isOwned = false
                    for _, kp in ipairs(item.Obj.Color.Keypoints) do
                        if isGold(kp.Value) or kp.Value == lastRainbowColor then isOwned = true break end
                    end
                    if isOwned then item.Obj.Color = newSeq end
                else
                    local currentC = item.Obj[item.Prop]
                    if isGold(currentC) or currentC == lastRainbowColor then
                        item.Obj[item.Prop] = newRainbow
                    end
                end
            end
        end
        lastRainbowColor = newRainbow
    else
        if lastRainbowColor then
            for _, item in ipairs(RainbowCache) do
                if item.Obj and item.Obj.Parent then
                    if item.Prop == "Gradient" then
                        local hasRainbow = false
                        for _, kp in ipairs(item.Obj.Color.Keypoints) do
                            if kp.Value == lastRainbowColor then hasRainbow = true break end
                        end
                        if hasRainbow then item.Obj.Color = item.Orig end
                    else
                        if item.Obj[item.Prop] == lastRainbowColor then
                            item.Obj[item.Prop] = item.Orig
                        end
                    end
                end
            end
            lastRainbowColor = nil
        end
    end
    
    if Config.LogoSpeed > 0 and LogoButton then
        LogoButton.Rotation = (LogoButton.Rotation + (Config.LogoSpeed * deltaTime * 5)) % 360
    else
        if LogoButton then LogoButton.Rotation = 0 end
    end
end)

-- 📑 [TAB 1: PLAYER]
do
    local UI = {}
    UI.TabLeft, UI.TabRight, UI.TabIndex = createTabAndPage("PLAYER", 73882870781409)

    UI.AdvTackleMenu = createCFeature(UI.TabLeft, "ADVANCED TACKLE", UI.TabIndex)
    getgenv().ToggleUpdaters["AdvanceShootUI"] = addToggle(UI.AdvTackleMenu, "Advance Shoot UI", true, function(state) ShootCircle.Visible = state end)
    getgenv().ToggleUpdaters["AdvanceTackleUI"] = addToggle(UI.AdvTackleMenu, "Advance Tackle UI", true, function(state) TackleCircle.Visible = state end)

    UI.AutoPlayMenu = createCFeature(UI.TabLeft, "AUTO TACKLE & DRIBBLE", UI.TabIndex)
    getgenv().ToggleUpdaters["AutoTackleEnabled"] = addToggle(UI.AutoPlayMenu, "Auto tackle", true, function(state) Config.AutoTackleEnabled = state end)
    getgenv().ToggleUpdaters["AutoDribbleEnabled"] = addToggle(UI.AutoPlayMenu, "Auto Dribble (Strict)", true, function(state) Config.AutoDribbleEnabled = state end)
    getgenv().ToggleUpdaters["TackleBoostEnabled"] = addToggle(UI.AutoPlayMenu, "Tackle Boost", true, function(state) Config.TackleBoostEnabled = state end)
    getgenv().SliderUpdaters["TackleBoostPower"] = addSlider(UI.AutoPlayMenu, "Boost Power (10-60)", 10, 60, true, function(val) Config.TackleBoostPower = val / 10 end)

    UI.MovementMenu = createCFeature(UI.TabLeft, "PLAYER MOVEMENT", UI.TabIndex)
    getgenv().ToggleUpdaters["InfinityStaminaEnabled"] = addToggle(UI.MovementMenu, "Infinity Stamina", true, function(state) 
        Config.InfinityStaminaEnabled = state 
        local char = player.Character
        if state then
            if char and char:FindFirstChild("Animate") then
                local walkAnim = char.Animate:FindFirstChild("walk") and char.Animate.walk:FindFirstChild("WalkAnim")
                local runAnim = char.Animate:FindFirstChild("run") and char.Animate.run:FindFirstChild("RunAnim")
                if walkAnim and runAnim then
                    originalWalkAnimId = walkAnim.AnimationId
                    walkAnim.AnimationId = runAnim.AnimationId
                end
            end
        else
            if char and char:FindFirstChild("Animate") then
                local walkAnim = char.Animate:FindFirstChild("walk") and char.Animate.walk:FindFirstChild("WalkAnim")
                if walkAnim and originalWalkAnimId ~= "" then
                    walkAnim.AnimationId = originalWalkAnimId
                end
            end
            Config.InfinityStaminaEnabled = false
            if adjustRunAnimationSpeed then adjustRunAnimationSpeed() end
        end
    end)
    getgenv().ToggleUpdaters["SafeSpeedEnabled"] = addToggle(UI.MovementMenu, "Safe Speed", true, function(state) Config.SafeSpeedEnabled = state end)
    getgenv().SliderUpdaters["SpeedPower"] = addSlider(UI.MovementMenu, "Extra Speed Power", 5, 60, true, function(val) Config.SpeedPower = val end)

    UI.CurveMenu = createCFeature(UI.TabRight, "CURVE SYSTEM", UI.TabIndex)
    getgenv().ToggleUpdaters["AutoCurveEnabled"] = addToggle(UI.CurveMenu, "Auto curve", true, function(state) Config.AutoCurveEnabled = state end)
    getgenv().SliderUpdaters["CurveRate"] = addSlider(UI.CurveMenu, "Curve Power (%)", 5, 50, true, function(val) Config.CurveRate = val end) 

    UI.HitboxMenu = createCFeature(UI.TabRight, "HITBOX & REACH", UI.TabIndex)
    getgenv().ToggleUpdaters["ReachEnabled"] = addToggle(UI.HitboxMenu, "Enable Hitbox Reach", function(state) Config.ReachEnabled = state end)
    getgenv().ToggleUpdaters["ReachVisualizer"] = addToggle(UI.HitboxMenu, "Hitbox Visualizer", function(state) Config.ReachVisualizer = state end)
    getgenv().SliderUpdaters["ReachX"] = addSlider(UI.HitboxMenu, "Reach X (Width)", 5, 50, function(val) Config.ReachX = val end)
    getgenv().SliderUpdaters["ReachY"] = addSlider(UI.HitboxMenu, "Reach Y (Height)", 5, 50, function(val) Config.ReachY = val end)
    getgenv().SliderUpdaters["ReachZ"] = addSlider(UI.HitboxMenu, "Reach Z (Length)", 5, 50, function(val) Config.ReachZ = val end)
end

-- 📑 [TAB 2: ABOUT]
do
    local UI = {}
    UI.AboutTabMain, UI.AboutTabIndex = createTabAndPage("ABOUT", 130713395923743, true) 

    local mainLayout = UI.AboutTabMain:FindFirstChildOfClass("UIListLayout")
    if mainLayout then
        mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    UI.CreditLabel = Instance.new("TextLabel", UI.AboutTabMain)
    UI.CreditLabel.Name = "01_Credit"
    UI.CreditLabel.LayoutOrder = 1 
    UI.CreditLabel.Size = UDim2.new(1, 0, 0, 25)
    UI.CreditLabel.BackgroundTransparency = 1
    UI.CreditLabel.Text = "CREATED BY RAFSAN HUB"
    UI.CreditLabel.TextColor3 = Color_BrightGold
    UI.CreditLabel.Font = Enum.Font.GothamBlack
    UI.CreditLabel.TextSize = 22
    UI.CreditLabel.TextXAlignment = Enum.TextXAlignment.Center

    UI.InfoBox = Instance.new("Frame", UI.AboutTabMain)
    UI.InfoBox.Name = "02_InfoBox"
    UI.InfoBox.LayoutOrder = 2
    UI.InfoBox.Size = UDim2.new(1, 0, 0, 125) 
    UI.InfoBox.BackgroundColor3 = Color_BgLighter
    Instance.new("UICorner", UI.InfoBox).CornerRadius = UDim.new(0, 6)
    UI.InfoStroke = Instance.new("UIStroke", UI.InfoBox)
    UI.InfoStroke.Color = Color_PrimaryGold
    UI.InfoStroke.Thickness = 1
    
    UI.InfoTopBar = Instance.new("Frame", UI.InfoBox)
    UI.InfoTopBar.Size = UDim2.new(1, 0, 0, 32)
    UI.InfoTopBar.BackgroundTransparency = 1

    UI.SpecialInfoTitle = Instance.new("TextLabel", UI.InfoTopBar)
    UI.SpecialInfoTitle.Size = UDim2.new(1, 0, 1, 0)
    UI.SpecialInfoTitle.BackgroundTransparency = 1
    UI.SpecialInfoTitle.Text = "SPECIAL INFO"
    UI.SpecialInfoTitle.TextColor3 = Color_BrightGold
    UI.SpecialInfoTitle.Font = Enum.Font.GothamBold
    UI.SpecialInfoTitle.TextSize = 13
    UI.SpecialInfoTitle.TextXAlignment = Enum.TextXAlignment.Center
    UI.SpecialInfoTitle.TextYAlignment = Enum.TextYAlignment.Center

    UI.HeaderDivider = Instance.new("Frame", UI.InfoBox)
    UI.HeaderDivider.Size = UDim2.new(1, -20, 0, 1)
    UI.HeaderDivider.Position = UDim2.new(0, 10, 0, 32)
    UI.HeaderDivider.BackgroundColor3 = Color_PrimaryGold
    UI.HeaderDivider.BackgroundTransparency = 0.5
    UI.HeaderDivider.BorderSizePixel = 0

    UI.GridContainer = Instance.new("Frame", UI.InfoBox)
    UI.GridContainer.Size = UDim2.new(1, 0, 1, -33)
    UI.GridContainer.Position = UDim2.new(0, 0, 0, 33)
    UI.GridContainer.BackgroundTransparency = 1
    
    UI.InfoPad = Instance.new("UIPadding", UI.GridContainer)
    UI.InfoPad.PaddingTop, UI.InfoPad.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8)
    UI.InfoPad.PaddingLeft, UI.InfoPad.PaddingRight = UDim.new(0, 15), UDim.new(0, 10)

    UI.InfoGrid = Instance.new("UIGridLayout", UI.GridContainer)
    UI.InfoGrid.CellSize = UDim2.new(0.5, -10, 0, 16) 
    UI.InfoGrid.CellPadding = UDim2.new(0, 5, 0, 4)
    UI.InfoGrid.SortOrder = Enum.SortOrder.LayoutOrder

    local function createInfoLine(prefix, defaultText, layoutOrder)
        local lbl = Instance.new("TextLabel", UI.GridContainer)
        lbl.BackgroundTransparency = 1
        lbl.Text = prefix .. defaultText
        lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = layoutOrder
        return lbl
    end

    UI.StatusInfoLabel = createInfoLine("STATUS: ", getgenv().IsVIP and CurrentPlan or "FREE", 1)
    createInfoLine("USER: ", (player and player.Name or "Unknown"), 2)
    createInfoLine("GAME: ", "REALISTIC STREET SOCCER", 3)
    UI.TeamInfoLabel = createInfoLine("TEAM: ", "CALCULATING...", 4)
    UI.FpsLabel = createInfoLine("FPS: ", "CALCULATING...", 5)
    UI.PingLabel = createInfoLine("PING: ", "CALCULATING...", 6)
    UI.CoordLabel = createInfoLine("POS: ", "X:0 Y:0 Z:0", 7)
    
    local deviceType = UserInputService.TouchEnabled and "MOBILE" or "PC"
    createInfoLine("DEVICE: ", deviceType, 8)

    local frames = 0
    RunService.RenderStepped:Connect(function() frames = frames + 1 end)
    task.spawn(function()
        while task.wait(1) do
            UI.StatusInfoLabel.Text = "STATUS: " .. (getgenv().IsVIP and CurrentPlan or "FREE")
            UI.StatusInfoLabel.TextColor3 = getgenv().IsVIP and Color_PrimaryGold or Color3.fromRGB(220, 220, 220)
            UI.FpsLabel.Text = "FPS: " .. tostring(frames)
            frames = 0
            local successPing, pingValue = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if successPing and pingValue then UI.PingLabel.Text = "PING: " .. tostring(math.floor(pingValue)) .. " ms" end
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = player.Character.HumanoidRootPart.Position
                UI.CoordLabel.Text = string.format("POS: %d, %d, %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
            end
            local successTeam, currentTeam = pcall(function() return GetMyTeam() end)
            UI.TeamInfoLabel.Text = "TEAM: " .. ((successTeam and currentTeam) and currentTeam or "NONE")
        end
    end)

    local function createWarningCard(parent, name, layoutOrder, color, text, alignment, textSize)
        local Card = Instance.new("Frame", parent)
        Card.Name = name
        Card.LayoutOrder = layoutOrder
        Card.Size = UDim2.new(1, 0, 0, 0)
        Card.AutomaticSize = Enum.AutomaticSize.Y
        Card.BackgroundColor3 = Color3.new(color.R * 0.15, color.G * 0.15, color.B * 0.15) 
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
        
        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = color
        Stroke.Thickness = 1
        Stroke.Transparency = 0.4

        local Pad = Instance.new("UIPadding", Card)
        Pad.PaddingTop, Pad.PaddingBottom = UDim.new(0, 10), UDim.new(0, 10)
        Pad.PaddingLeft, Pad.PaddingRight = UDim.new(0, 12), UDim.new(0, 12)

        local Txt = Instance.new("TextLabel", Card)
        Txt.Size = UDim2.new(1, 0, 0, 0)
        Txt.AutomaticSize = Enum.AutomaticSize.Y
        Txt.BackgroundTransparency = 1
        Txt.Text = text
        Txt.TextColor3 = color
        Txt.Font = Enum.Font.GothamMedium
        Txt.TextSize = textSize or 12
        Txt.TextWrapped = true
        Txt.TextXAlignment = alignment or Enum.TextXAlignment.Left

        return Card
    end

    local Spacer = Instance.new("Frame", UI.AboutTabMain)
    Spacer.Name = "03_Spacer"
    Spacer.LayoutOrder = 3
    Spacer.Size = UDim2.new(1, 0, 0, 2)
    Spacer.BackgroundTransparency = 1

    createWarningCard(UI.AboutTabMain, "04_RedCard", 4, Color3.fromRGB(255, 75, 75), "Dear User, this is a premium VIP script. As part of our initial launch, we are offering this version for free for a limited time. Please note that starting from Version 2, this will become a strictly paid script. Any attempt to distribute or use cracked versions of the paid script for free will result in a permanent blacklist. Please beware of scammers.", Enum.TextXAlignment.Left, 12)

    createWarningCard(UI.AboutTabMain, "05_GreenCard", 5, Color3.fromRGB(80, 220, 100), "🌟 MODULE INSTRUCTIONS & WARNINGS 🌟\n\n• Advance Shoot & Tackle: Highly stable and working perfectly.\n• Auto Tackle & Dribble: Works effectively but might trigger executor kicks.\n• Safe Speed Boost: Do not overuse! Excessive speed can flag the anti-cheat.\n• Auto Curve System: Bending physics can act unpredictably.\n\n⚠️ SECURITY NOTICE: This script is not 100% anti-ban. Use a paid executor for max safety.", Enum.TextXAlignment.Center, 13)
end

-- 📑 [TAB 3: PREMIUM]
do
    local UI = {}
    UI.PremiumTabMain, UI.PremiumTabIndex = createTabAndPage("PREMIUM", 93767678702544, true)

    local function createPremiumCard(planName, priceText, isProMax, benefitsList, layoutOrder)
        local MainColor, HoverColor = Color_PrimaryGold, Color_BrightGold
        local isActivePlan = (CurrentPlan == planName)

        local PremBox = Instance.new("Frame", UI.PremiumTabMain)
        PremBox.LayoutOrder, PremBox.Size, PremBox.BackgroundColor3, PremBox.ClipsDescendants = layoutOrder, UDim2.new(1,0,0,85), Color_BgLighter, true
        Instance.new("UICorner", PremBox).CornerRadius = UDim.new(0, 12) 

        if isProMax then local BoxGrad = Instance.new("UIGradient", PremBox) BoxGrad.Color, BoxGrad.Rotation = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45,35,15)), ColorSequenceKeypoint.new(1, Color_BgLighter)}), 45 end

        local PremStroke = Instance.new("UIStroke", PremBox)
        PremStroke.Color, PremStroke.Thickness, PremStroke.Transparency = MainColor, isProMax and 2 or 1.5, 0.2

        local TopBar = Instance.new("TextButton", PremBox)
        TopBar.Size, TopBar.BackgroundTransparency, TopBar.Text = UDim2.new(1,0,0,85), 1, ""

        local CrownIcon = Instance.new("ImageLabel", TopBar)
        CrownIcon.Size, CrownIcon.Position, CrownIcon.BackgroundTransparency, CrownIcon.Image, CrownIcon.ImageColor3 = UDim2.new(0,22,0,22), UDim2.new(0,15,0,12), 1, "rbxassetid://10729792019", isProMax and Color3.fromRGB(255,220,100) or HoverColor
        task.spawn(function() while true do TweenService:Create(CrownIcon, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0,15,0,9)}):Play() task.wait(1.2) TweenService:Create(CrownIcon, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0,15,0,15)}):Play() task.wait(1.2) end end)

        local CardTitle = Instance.new("TextLabel", TopBar)
        CardTitle.Size, CardTitle.Position, CardTitle.BackgroundTransparency, CardTitle.Text, CardTitle.TextColor3, CardTitle.Font, CardTitle.TextSize, CardTitle.TextXAlignment = UDim2.new(0,160,0,24), UDim2.new(0,45,0,12), 1, planName, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 20, Enum.TextXAlignment.Left
        
        local TitleGradColors = isProMax and {ColorSequenceKeypoint.new(0, Color3.fromRGB(255,230,100)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,200,50))} or {ColorSequenceKeypoint.new(0, MainColor), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, MainColor)}
        local TitleGrad = Instance.new("UIGradient", CardTitle) TitleGrad.Color = ColorSequence.new(TitleGradColors)
        task.spawn(function() local offset = -1 while true do offset = offset + (task.wait()*1.5) if offset > 1 then offset = -1 end TitleGrad.Offset = Vector2.new(offset, 0) end end)

        local PriceCont = Instance.new("Frame", TopBar)
        PriceCont.Size, PriceCont.Position, PriceCont.BackgroundTransparency = UDim2.new(0, 200, 0, 35), UDim2.new(0, 15, 0, 38), 1
        local PriceLayout = Instance.new("UIListLayout", PriceCont) PriceLayout.FillDirection, PriceLayout.SortOrder, PriceLayout.VerticalAlignment, PriceLayout.Padding = Enum.FillDirection.Horizontal, Enum.SortOrder.LayoutOrder, Enum.VerticalAlignment.Bottom, UDim.new(0, 4)

        local Dollar = Instance.new("TextLabel", PriceCont) Dollar.LayoutOrder, Dollar.Size, Dollar.AutomaticSize, Dollar.BackgroundTransparency, Dollar.Text, Dollar.TextColor3, Dollar.Font, Dollar.TextSize = 1, UDim2.new(0,0,0,26), Enum.AutomaticSize.X, 1, "$", isProMax and Color3.fromRGB(255,220,80) or MainColor, Enum.Font.GothamBold, 20
        local PriceText = Instance.new("TextLabel", PriceCont) PriceText.LayoutOrder, PriceText.Size, PriceText.AutomaticSize, PriceText.BackgroundTransparency, PriceText.Text, PriceText.TextColor3, PriceText.Font, PriceText.TextSize = 2, UDim2.new(0,0,0,32), Enum.AutomaticSize.X, 1, priceText, Color3.fromRGB(255,255,255), Enum.Font.GothamBlack, 36
        local UnlimText = Instance.new("TextLabel", PriceCont) UnlimText.LayoutOrder, UnlimText.Size, UnlimText.AutomaticSize, UnlimText.BackgroundTransparency, UnlimText.Text, UnlimText.TextColor3, UnlimText.Font, UnlimText.TextSize = 3, UDim2.new(0,0,0,22), Enum.AutomaticSize.X, 1, isProMax and "/Quarter" or "/Month", Color3.fromRGB(150,150,150), Enum.Font.GothamMedium, 13

        if isActivePlan then
            local ActiveTag = Instance.new("Frame", TopBar) ActiveTag.Size, ActiveTag.AnchorPoint, ActiveTag.Position, ActiveTag.BackgroundColor3 = UDim2.new(0, 80, 0, 22), Vector2.new(1, 0.5), UDim2.new(1, -60, 0.5, 0), Color3.fromRGB(45, 180, 75)
            Instance.new("UICorner", ActiveTag).CornerRadius = UDim.new(0, 4)
            local ActiveText = Instance.new("TextLabel", ActiveTag) ActiveText.Size, ActiveText.BackgroundTransparency, ActiveText.Text, ActiveText.TextColor3, ActiveText.Font, ActiveText.TextSize = UDim2.new(1, 0, 1, 0), 1, "ACTIVATED", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11
        elseif isProMax then
            local TagBg = Instance.new("Frame", TopBar) TagBg.Size, TagBg.AnchorPoint, TagBg.Position, TagBg.BackgroundColor3 = UDim2.new(0, 80, 0, 22), Vector2.new(1, 0.5), UDim2.new(1, -60, 0.5, 0), Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", TagBg).CornerRadius = UDim.new(0, 4)
            local TagGrad = Instance.new("UIGradient", TagBg) TagGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,200,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200,140,0))})
            local TagText = Instance.new("TextLabel", TagBg) TagText.Size, TagText.BackgroundTransparency, TagText.Text, TagText.TextColor3, TagText.Font, TagText.TextSize = UDim2.new(1,0,1,0), 1, "BEST VALUE", Color_BgDark, Enum.Font.GothamBold, 11
        end

        local PremArrow = Instance.new("ImageLabel", TopBar)
        PremArrow.Size, PremArrow.Position, PremArrow.BackgroundTransparency, PremArrow.Image, PremArrow.ImageColor3 = UDim2.new(0,20,0,20), UDim2.new(1,-30,0.5,-10), 1, "rbxassetid://6031091004", MainColor

        TopBar.MouseEnter:Connect(function() TweenService:Create(PremStroke, TweenInfo.new(0.3), {Transparency = 0, Thickness = isProMax and 2.5 or 2, Color = HoverColor}):Play() TweenService:Create(PremBox, TweenInfo.new(0.3), {BackgroundColor3 = Color_Hover}):Play() end)
        TopBar.MouseLeave:Connect(function() TweenService:Create(PremStroke, TweenInfo.new(0.3), {Transparency = 0.2, Thickness = isProMax and 2 or 1.5, Color = MainColor}):Play() TweenService:Create(PremBox, TweenInfo.new(0.3), {BackgroundColor3 = Color_BgLighter}):Play() end)

        local PremContent = Instance.new("Frame", PremBox)
        PremContent.Size, PremContent.Position, PremContent.BackgroundTransparency, PremContent.Visible = UDim2.new(1,0,1,-85), UDim2.new(0,0,0,85), 1, false

        local PremDivider = Instance.new("Frame", PremContent)
        PremDivider.Size, PremDivider.Position, PremDivider.BackgroundColor3, PremDivider.BorderSizePixel, PremDivider.BackgroundTransparency = UDim2.new(1,-30,0,1), UDim2.new(0,15,0,0), MainColor, 0, 0.5

        local PremList = Instance.new("UIListLayout", PremContent) PremList.Padding, PremList.SortOrder, PremList.HorizontalAlignment = UDim.new(0,4), Enum.SortOrder.LayoutOrder, Enum.HorizontalAlignment.Center
        local PremPad = Instance.new("UIPadding", PremContent) PremPad.PaddingTop, PremPad.PaddingBottom = UDim.new(0,15), UDim.new(0,10)

        local BenTitle = Instance.new("TextLabel", PremContent)
        BenTitle.Size, BenTitle.BackgroundTransparency, BenTitle.Text, BenTitle.TextColor3, BenTitle.Font, BenTitle.TextSize, BenTitle.TextXAlignment = UDim2.new(1,-40,0,22), 1, "Benefits Includes:", MainColor, Enum.Font.GothamBold, 14, Enum.TextXAlignment.Left

        for _, txt in ipairs(benefitsList) do
            local ItemFrame = Instance.new("Frame", PremContent) ItemFrame.Size, ItemFrame.BackgroundTransparency = UDim2.new(1,-40,0,18), 1
            local TickImage = Instance.new("ImageLabel", ItemFrame) TickImage.Size, TickImage.Position, TickImage.BackgroundTransparency, TickImage.Image, TickImage.ImageColor3 = UDim2.new(0,14,0,14), UDim2.new(0,0,0.5,-7), 1, "rbxassetid://103955809566890", Color3.fromRGB(255,255,255)
            local bText = Instance.new("TextLabel", ItemFrame) bText.Size, bText.Position, bText.BackgroundTransparency, bText.Text, bText.TextColor3, bText.Font, bText.TextSize, bText.TextXAlignment = UDim2.new(1,-20,1,0), UDim2.new(0,20,0,0), 1, txt, Color3.fromRGB(230,230,230), Enum.Font.GothamMedium, 12, Enum.TextXAlignment.Left
        end

        local Spacer = Instance.new("Frame", PremContent) Spacer.Size, Spacer.BackgroundTransparency = UDim2.new(1,0,0,7), 1
        local GetPremBtn = Instance.new("TextButton", PremContent) GetPremBtn.Size, GetPremBtn.BackgroundColor3, GetPremBtn.Text, GetPremBtn.TextColor3, GetPremBtn.Font, GetPremBtn.TextSize, GetPremBtn.ClipsDescendants = UDim2.new(1,-60,0,38), MainColor, "GET PREMIUM", Color_BgDark, Enum.Font.GothamBold, 14, true 
        Instance.new("UICorner", GetPremBtn).CornerRadius = UDim.new(0, 6)

        if isActivePlan then Spacer.Visible = false GetPremBtn.Visible = false end

        local isPremOpen = false
        local function updatePremSize()
            if isPremOpen then PremContent.Visible = true TweenService:Create(PremBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,0, 85 + PremList.AbsoluteContentSize.Y + 25)}):Play() TweenService:Create(PremArrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else local closeT = TweenService:Create(PremBox, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1,0,0,85)}) closeT:Play() TweenService:Create(PremArrow, TweenInfo.new(0.3), {Rotation = 0}):Play() closeT.Completed:Connect(function() if not isPremOpen then PremContent.Visible = false end end) end
        end

        TopBar.MouseButton1Click:Connect(function() isPremOpen = not isPremOpen updatePremSize() end)
        PremList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if isPremOpen then PremBox.Size = UDim2.new(1,0,0, 85 + PremList.AbsoluteContentSize.Y + 25) end end)
        GetPremBtn.MouseButton1Click:Connect(function() if isActivePlan then return end local discordLink = "https://discord.gg/your_discord_invite" if setclipboard then setclipboard(discordLink) elseif toclipboard then toclipboard(discordLink) end local oldText = GetPremBtn.Text GetPremBtn.Text = "LINK COPIED!" task.wait(2) if not isActivePlan then GetPremBtn.Text = oldText end end)

        return PremBox
    end

    local ProCard = createPremiumCard("PRO", "5.00", false, {"ALL VIP FEATURES UNLOCKED", "NO ADS / NO KEY SYSTEM", "HIGH PRIORITY SUPPORT", "30 DAYS VALIDITY"}, 1)
    local ProMaxCard = createPremiumCard("PRO MAX", "12.00", true, {"EVERYTHING IN PRO VERSION", "UNLIMITED AI ASSISTANCE QUOTA", "1x FREE HWID RESET TOKEN", "EARLY ACCESS TO NEW FEATURES", "3 MONTHS VALIDITY (90 DAYS)"}, 2)

    if CurrentPlan == "PRO MAX" then ProCard.Visible = false end
end

-- 🔍 [SEARCH ENGINE] 
local activeStrokes, activeHighlightedUIs = {}, {}

local function clearHighlights()
    for _, stroke in ipairs(activeStrokes) do
        if stroke and stroke.Parent then TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play() task.delay(0.3, function() if stroke and stroke.Parent then stroke:Destroy() end end) end
    end
    for _, ui in ipairs(activeHighlightedUIs) do if ui then TweenService:Create(ui, TweenInfo.new(0.3), {BackgroundTransparency = 1, BackgroundColor3 = Color_Hover}):Play() end end
    activeStrokes, activeHighlightedUIs = {}, {}
end

SearchView:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.gsub(string.lower(SearchView.Text), "^%s*(.-)%s*$", "%1") 
    local matchedUIs, firstMatchedPage = {}, nil
    clearHighlights() 

    for tabIndex, isSearchable in pairs(tabsWithSearch) do
        if isSearchable and allPages[tabIndex] then
            local page = allPages[tabIndex]
            for _, obj in ipairs(page:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Font == Enum.Font.PermanentMarker then
                    local mainCont = obj.Parent and obj.Parent.Parent
                    if mainCont and mainCont:IsA("Frame") then
                        local contentFrame, arrowIcon, highlightStroke = nil, obj.Parent:FindFirstChildOfClass("ImageLabel"), mainCont:FindFirstChildOfClass("UIStroke")
                        for _, child in ipairs(mainCont:GetChildren()) do if child:IsA("Frame") then contentFrame = child break end end
                        if contentFrame then
                            local hasMatch = false
                            for _, featureUI in ipairs(contentFrame:GetChildren()) do
                                if featureUI:IsA("GuiObject") and not featureUI:IsA("UIListLayout") and not featureUI:IsA("UIPadding") then
                                    local featureLabel = nil
                                    for _, desc in ipairs(featureUI:GetDescendants()) do if desc:IsA("TextLabel") and desc.Font == Enum.Font.GothamMedium then featureLabel = desc break end end
                                    if featureLabel then
                                        if query == "" then featureUI.Visible, featureUI.BackgroundTransparency = true, 1 else
                                            if string.find(string.lower(featureLabel.Text), query, 1, true) then
                                                featureUI.Visible, hasMatch = true, true
                                                table.insert(matchedUIs, featureUI) if not firstMatchedPage then firstMatchedPage = page end
                                            else featureUI.Visible = false end
                                        end
                                    end
                                end
                            end
                            if query == "" then
                                mainCont.Visible, contentFrame.Visible = true, false
                                if arrowIcon then arrowIcon.Rotation = 0 end if highlightStroke then highlightStroke.Transparency = 1 end
                                mainCont.Size = UDim2.new(1, 0, 0, 30)
                            else
                                mainCont.Visible = hasMatch
                                if hasMatch then
                                    contentFrame.Visible = true if arrowIcon then arrowIcon.Rotation = 180 end if highlightStroke then highlightStroke.Transparency = 0.2 end
                                    local listLayout = contentFrame:FindFirstChildOfClass("UIListLayout")
                                    if listLayout then mainCont.Size = UDim2.new(1, 0, 0, 30 + listLayout.AbsoluteContentSize.Y + 9) end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if query ~= "" and #matchedUIs > 0 then
        task.delay(0.05, function() if firstMatchedPage and matchedUIs[1] then TweenService:Create(firstMatchedPage, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {CanvasPosition = Vector2.new(0, math.max(0, matchedUIs[1].AbsolutePosition.Y - firstMatchedPage.AbsolutePosition.Y + firstMatchedPage.CanvasPosition.Y - 40))}):Play() end end)
        
        for _, matchedUI in ipairs(matchedUIs) do
            local flashStroke = Instance.new("UIStroke", matchedUI) 
            flashStroke.Color, flashStroke.Thickness, flashStroke.Transparency = Color_PrimaryGold, 1.5, 1
            table.insert(activeStrokes, flashStroke) table.insert(activeHighlightedUIs, matchedUI)
            
            TweenService:Create(matchedUI, TweenInfo.new(0.3), {BackgroundTransparency = 0.6, BackgroundColor3 = Color_PrimaryGold}):Play()
            TweenService:Create(flashStroke, TweenInfo.new(0.3), {Transparency = 0.2}):Play()
            
            task.delay(1.5, function()
                if matchedUI and matchedUI.Parent then TweenService:Create(matchedUI, TweenInfo.new(0.5), {BackgroundTransparency = 1, BackgroundColor3 = Color_Hover}):Play() end
                if flashStroke and flashStroke.Parent then TweenService:Create(flashStroke, TweenInfo.new(0.5), {Transparency = 1}):Play() end
            end)
        end
        
        local currentQuery = query
        task.delay(2.2, function() if string.lower(string.gsub(SearchView.Text, "^%s*(.-)%s*$", "%1")) == currentQuery then clearHighlights() end end)
    end
end)

switchTab(1)
