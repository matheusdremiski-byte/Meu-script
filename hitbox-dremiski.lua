--[[
    ═══════════════════════════════════════════════════════════════
       DREMISKI HITBOX EXPANDER v1.1
       ▸ Intro "DREMISKI THE BEST"
       ▸ Aumenta hitbox dos players (head/body)
       ▸ UI bonita com botões de tamanho
    ═══════════════════════════════════════════════════════════════
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ░░░░ CONFIG ░░░░
local CONFIG = {
    ACCENT      = Color3.fromRGB(0, 170, 255),
    BG_DARK     = Color3.fromRGB(16, 16, 20),
    BG_PANEL    = Color3.fromRGB(26, 26, 32),
    BG_BTN      = Color3.fromRGB(36, 36, 44),
    BG_INPUT    = Color3.fromRGB(20, 20, 26),
    TEXT        = Color3.fromRGB(240, 240, 245),
    TEXT_MUTED  = Color3.fromRGB(150, 150, 160),

    EXPAND_SIZE = 3,
    MIN_SIZE    = 1,
    MAX_SIZE    = 10,
    TEAM_CHECK  = true,
}

-- ░░░░ ESTADO ░░░░
local State = {
    Enabled = false,
    Size = CONFIG.EXPAND_SIZE,
}

local OriginalSizes = {}

-- ░░░░ PARENT SEGURO ░░░░
local function getSafeParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    if RunService:IsStudio() then
        return LocalPlayer:WaitForChild("PlayerGui")
    end
    return CoreGui
end
local safeParent = getSafeParent()

-- ═══════════════════════════════════════════════════════════
-- ░░ 0. INTRO ANIMADA — "DREMISKI THE BEST" ░░
-- ═══════════════════════════════════════════════════════════
local function showIntro()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "DremiskiIntro"
    introGui.ResetOnSpawn = false
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 9999
    introGui.Parent = safeParent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.BackgroundTransparency = 1
    bg.Parent = introGui

    local lineTop = Instance.new("Frame")
    lineTop.Size = UDim2.new(0, 0, 0, 3)
    lineTop.Position = UDim2.new(0.5, 0, 0.5, -80)
    lineTop.AnchorPoint = Vector2.new(0.5, 0.5)
    lineTop.BackgroundColor3 = Color3.fromRGB(255, 20, 20)
    lineTop.BorderSizePixel = 0
    lineTop.Parent = bg

    local lineBottom = Instance.new("Frame")
    lineBottom.Size = UDim2.new(0, 0, 0, 3)
    lineBottom.Position = UDim2.new(0.5, 0, 0.5, 80)
    lineBottom.AnchorPoint = Vector2.new(0.5, 0.5)
    lineBottom.BackgroundColor3 = Color3.fromRGB(255, 20, 20)
    lineBottom.BorderSizePixel = 0
    lineBottom.Parent = bg

    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.fromOffset(600, 600)
    glow.Position = UDim2.fromScale(0.5, 0.5)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
    glow.ImageTransparency = 1
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.ZIndex = 0
    glow.Parent = bg

    local titleShadow = Instance.new("TextLabel")
    titleShadow.Size = UDim2.new(1, 0, 0, 100)
    titleShadow.Position = UDim2.new(0.5, 4, 0.5, 4)
    titleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    titleShadow.BackgroundTransparency = 1
    titleShadow.Text = "DREMISKI"
    titleShadow.TextColor3 = Color3.fromRGB(255, 0, 0)
    titleShadow.TextSize = 60
    titleShadow.Font = Enum.Font.GothamBlack
    titleShadow.TextTransparency = 1
    titleShadow.ZIndex = 1
    titleShadow.Parent = bg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 100)
    title.Position = UDim2.fromScale(0.5, 0.5)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Text = "DREMISKI"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 60
    title.Font = Enum.Font.GothamBlack
    title.TextTransparency = 1
    title.ZIndex = 2
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 40)
    sub.Position = UDim2.new(0.5, 0, 0.5, 55)
    sub.AnchorPoint = Vector2.new(0.5, 0.5)
    sub.BackgroundTransparency = 1
    sub.Text = "THE BEST"
    sub.TextColor3 = Color3.fromRGB(255, 30, 30)
    sub.TextSize = 28
    sub.Font = Enum.Font.GothamBold
    sub.TextTransparency = 1
    sub.ZIndex = 2
    sub.Parent = bg

    TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    task.wait(0.4)
    TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()
    TweenService:Create(lineTop, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0.7, 0, 0, 3)
    }):Play()
    TweenService:Create(lineBottom, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0.7, 0, 0, 3)
    }):Play()

    title.TextTransparency = 0
    titleShadow.TextTransparency = 0
    sub.TextTransparency = 0
    title.TextSize = 30
    titleShadow.TextSize = 30
    TweenService:Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = 60
    }):Play()
    TweenService:Create(titleShadow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = 60
    }):Play()

    task.spawn(function()
        for i = 1, 3 do
            TweenService:Create(title, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            task.wait(0.15)
            TweenService:Create(title, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            task.wait(0.15)
        end
    end)

    task.wait(2.0)

    TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(titleShadow, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(lineTop, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(lineBottom, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(glow, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()

    task.wait(0.7)
    introGui:Destroy()
end

-- Mostra a intro
showIntro()

-- ═══════════════════════════════════════════════════════════
-- ░░ 1. UI PRINCIPAL ░░
-- ═══════════════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "DremiskiHitbox"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = safeParent

local W, H = 240, 220

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(W, H)
main.Position = UDim2.new(0, 20, 0.5, -H/2)
main.BackgroundColor3 = CONFIG.BG_DARK
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = CONFIG.ACCENT
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.4

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = CONFIG.BG_PANEL
titleBar.BorderSizePixel = 0
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleMask = Instance.new("Frame")
titleMask.Size = UDim2.new(1, 0, 0, 12)
titleMask.Position = UDim2.new(0, 0, 1, -12)
titleMask.BackgroundColor3 = CONFIG.BG_PANEL
titleMask.BorderSizePixel = 0
titleMask.Parent = titleBar

local logoDot = Instance.new("Frame")
logoDot.Size = UDim2.fromOffset(10, 10)
logoDot.Position = UDim2.new(0, 12, 0.5, -5)
logoDot.BackgroundColor3 = CONFIG.ACCENT
logoDot.BorderSizePixel = 0
logoDot.Parent = titleBar
Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -50, 1, 0)
titleLbl.Position = UDim2.new(0, 30, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "HITBOX EXPANDER"
titleLbl.TextColor3 = CONFIG.TEXT
titleLbl.TextSize = 12
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = titleBar

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.fromOffset(26, 26)
btnClose.Position = UDim2.new(1, -32, 0.5, -13)
btnClose.BackgroundColor3 = CONFIG.BG_BTN
btnClose.Text = "✕"
btnClose.TextColor3 = CONFIG.TEXT
btnClose.TextSize = 13
btnClose.Font = Enum.Font.GothamBold
btnClose.Parent = titleBar
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 7)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 42)
toggleBtn.Position = UDim2.new(0, 10, 0, 52)
toggleBtn.BackgroundColor3 = CONFIG.BG_PANEL
toggleBtn.Text = "🎯 ATIVAR HITBOX"
toggleBtn.TextColor3 = CONFIG.TEXT
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = main
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = CONFIG.ACCENT
toggleStroke.Thickness = 1.2
toggleStroke.Transparency = 0.6

local sizeLbl = Instance.new("TextLabel")
sizeLbl.Size = UDim2.new(1, -20, 0, 16)
sizeLbl.Position = UDim2.new(0, 10, 0, 106)
sizeLbl.BackgroundTransparency = 1
sizeLbl.Text = "📏 TAMANHO (1x - 10x)"
sizeLbl.TextColor3 = CONFIG.TEXT_MUTED
sizeLbl.TextSize = 10
sizeLbl.Font = Enum.Font.GothamBold
sizeLbl.TextXAlignment = Enum.TextXAlignment.Left
sizeLbl.Parent = main

local sizeFrame = Instance.new("Frame")
sizeFrame.Size = UDim2.new(1, -20, 0, 30)
sizeFrame.Position = UDim2.new(0, 10, 0, 124)
sizeFrame.BackgroundTransparency = 1
sizeFrame.Parent = main

local sizeLayout = Instance.new("UIListLayout", sizeFrame)
sizeLayout.FillDirection = Enum.FillDirection.Horizontal
sizeLayout.Padding = UDim.new(0, 4)
sizeLayout.SortOrder = Enum.SortOrder.LayoutOrder

local statusLbl  -- forward declare

local sizeBtns = {}
local function makeSizeBtn(text, value, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(40, 30)
    b.BackgroundColor3 = CONFIG.BG_PANEL
    b.Text = text
    b.TextColor3 = CONFIG.TEXT
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.LayoutOrder = order
    b.Parent = sizeFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        State.Size = value
        CONFIG.EXPAND_SIZE = value
        for _, btn in ipairs(sizeBtns) do
            btn.BackgroundColor3 = CONFIG.BG_PANEL
        end
        b.BackgroundColor3 = CONFIG.ACCENT
        if statusLbl then
            statusLbl.Text = "● Tamanho: " .. value .. "x"
        end
    end)

    table.insert(sizeBtns, b)
    return b
end

makeSizeBtn("2x", 2, 1)
makeSizeBtn("3x", 3, 2)
makeSizeBtn("5x", 5, 3)
makeSizeBtn("10x", 10, 4)

if sizeBtns[2] then sizeBtns[2].BackgroundColor3 = CONFIG.ACCENT end

statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -20, 0, 20)
statusLbl.Position = UDim2.new(0, 10, 0, 162)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "● Desligado | Tamanho: 3x"
statusLbl.TextColor3 = CONFIG.TEXT_MUTED
statusLbl.TextSize = 10
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = main

local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1, -20, 0, 26)
infoLbl.Position = UDim2.new(0, 10, 0, 184)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "Aumenta hitbox dos adversários\n(team check ativo)"
infoLbl.TextColor3 = CONFIG.TEXT_MUTED
infoLbl.TextSize = 9
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Top
infoLbl.Parent = main

-- ═══════════════════════════════════════════════════════════
-- ░░ 2. LÓGICA DO HITBOX ░░
-- ═══════════════════════════════════════════════════════════
local function sameTeam(player)
    if not CONFIG.TEAM_CHECK then return false end
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function expandCharacter(char)
    if not char then return end
    if not OriginalSizes[char] then OriginalSizes[char] = {} end

    for _, partName in ipairs({"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            if not OriginalSizes[char][partName] then
                OriginalSizes[char][partName] = part.Size
            end
            local orig = OriginalSizes[char][partName]
            part.Size = orig * State.Size
            part.Massless = true
            part.CanCollide = false
        end
    end
end

local function restoreCharacter(char)
    if not char then return end
    local saved = OriginalSizes[char]
    if not saved then return end

    for partName, origSize in pairs(saved) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Size = origSize
            part.CanCollide = true
        end
    end
    OriginalSizes[char] = nil
end

local function expandAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if sameTeam(player) then continue end
        if player.Character then expandCharacter(player.Character) end
    end
end

local function restoreAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then restoreCharacter(player.Character) end
    end
end

RunService.Heartbeat:Connect(function()
    if not State.Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if sameTeam(player) then continue end
        if player.Character then expandCharacter(player.Character) end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if State.Enabled and not sameTeam(player) then
            task.wait(0.5)
            expandCharacter(char)
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function()
    if State.Enabled then
        task.wait(1)
        expandAll()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        OriginalSizes[player.Character] = nil
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ░░ 3. CONTROLES ░░
-- ═══════════════════════════════════════════════════════════
toggleBtn.MouseButton1Click:Connect(function()
    State.Enabled = not State.Enabled
    if State.Enabled then
        toggleBtn.Text = "🎯 HITBOX ATIVA"
        toggleBtn.BackgroundColor3 = CONFIG.ACCENT
        toggleStroke.Transparency = 0.2
        statusLbl.Text = "● Ativo | Tamanho: " .. State.Size .. "x"
        statusLbl.TextColor3 = CONFIG.ACCENT
        expandAll()
    else
        toggleBtn.Text = "🎯 ATIVAR HITBOX"
        toggleBtn.BackgroundColor3 = CONFIG.BG_PANEL
        toggleStroke.Transparency = 0.6
        statusLbl.Text = "● Desligado | Tamanho: " .. State.Size .. "x"
        statusLbl.TextColor3 = CONFIG.TEXT_MUTED
        restoreAll()
    end
end)

btnClose.MouseButton1Click:Connect(function()
    State.Enabled = false
    restoreAll()
    gui:Destroy()
    print("[DREMISKI] Hitbox Expander encerrado.")
end)

print("╔════════════════════════════════════════╗")
print("║   DREMISKI HITBOX EXPANDER v1.1        ║")
print("╚════════════════════════════════════════╝")
