-- Auto-Execute / Teleport Desteği
pcall(function()
    local queueteleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if queueteleport and identifyexecutor then
        local success, err = pcall(function()
            queueteleport([[
                task.wait(2)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/"))()
            ]])
        end)
    end
end)

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local coreGui = game:GetService("CoreGui")
local virtualUser = game:GetService("VirtualUser")
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")

local lp = players.LocalPlayer
local remotes = replicatedStorage:WaitForChild("Remotes", 5)
local punch = remotes and remotes:WaitForChild("Punch", 5)
local areas = workspace:WaitForChild("Areas", 5)

-- Executor Tespiti
local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        executorName = identifyexecutor()
    elseif getexecutorname then
        executorName = getexecutorname()
    elseif syn then
        executorName = "Synapse X"
    elseif KRNL_LOADED then
        executorName = "Krnl"
    elseif Fluxus then
        executorName = "Fluxus"
    elseif Solara then
        executorName = "Solara"
    end
end)

local rebirthRemote = replicatedStorage:FindFirstChild("Remotes") and replicatedStorage.Remotes:FindFirstChild("Rebirth") 
                      or replicatedStorage:FindFirstChild("Rebirth")

-- Sabit Renk Paleti (Koyu Antrasit / Yeşil Tema)
local Theme = {
    Primary = Color3.fromRGB(46, 204, 113),
    Stroke = Color3.fromRGB(80, 220, 100),
    MainBg = Color3.fromRGB(18, 18, 20),
    SecondaryBg = Color3.fromRGB(26, 26, 30),
    SidebarBg = Color3.fromRGB(22, 22, 25),
    TitleBg = Color3.fromRGB(14, 14, 16),
    BorderStroke = Color3.fromRGB(45, 45, 50),
    TextPrimary = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(160, 160, 170)
}

local Config = {
    Killaura = false,
    BossFarm = false,
    TokenFarm = false,
    KillauraRange = 750,
    AutoRebirth = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    InfJump = false,
    ToggleKey = Enum.KeyCode.LeftControl
}

-- Kaydedilen Özel Token Koordinatı (Başlangıçta varsayılan senin verdiğin değer)
local savedTokenCFrame = CFrame.new(
    -2399.50146, 1698.86572, -584.165466,
    -0.595246196, 6.3557998e-08, 0.803543389,
    1.14369652e-08, 1, -7.0624921e-08,
    -0.803543389, -3.2849119e-08, -0.595246196
) + (CFrame.new(
    -2399.50146, 1698.86572, -584.165466,
    -0.595246196, 6.3557998e-08, 0.803543389,
    1.14369652e-08, 1, -7.0624921e-08,
    -0.803543389, -3.2849119e-08, -0.595246196
).LookVector * 18)

-- Anti-AFK
task.spawn(function()
    while true do
        task.wait(60)
        pcall(function()
            virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

lp.Idled:Connect(function()
    pcall(function()
        virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- UI Tasarımı
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MegaNoobHubElite"
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Theme.MainBg
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainFrame.Size = UDim2.new(0, 450, 0, 320)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.BorderStroke
mainStroke.Thickness = 1.8
mainStroke.Parent = mainFrame

-- Başlık Çubuğu
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Theme.TitleBg
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 50)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleCover = Instance.new("Frame")
titleCover.Parent = titleBar
titleCover.BackgroundColor3 = Theme.TitleBg
titleCover.BorderSizePixel = 0
titleCover.Position = UDim2.new(0, 0, 0.5, 0)
titleCover.Size = UDim2.new(1, 0, 0.5, 0)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 18, 0, 0)
titleText.Size = UDim2.new(1, -18, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ MEGA NOOB SIMULATOR HUB"
titleText.TextColor3 = Theme.TextPrimary
titleText.TextSize = 13.5
titleText.TextXAlignment = Enum.TextXAlignment.Left

local statusDot = Instance.new("Frame")
statusDot.Parent = titleBar
statusDot.BackgroundColor3 = Theme.Primary
statusDot.Position = UDim2.new(1, -35, 0.5, -6)
statusDot.Size = UDim2.new(0, 12, 0, 12)
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local dotStroke = Instance.new("UIStroke")
dotStroke.Color = Color3.fromRGB(255, 255, 255)
dotStroke.Thickness = 1.5
dotStroke.Parent = statusDot

-- Sürüklenebilirlik
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sol Sekme Paneli
local sidebar = Instance.new("ScrollingFrame")
sidebar.Parent = mainFrame
sidebar.BackgroundColor3 = Theme.SidebarBg
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.CanvasSize = UDim2.new(0, 0, 0, 250)
sidebar.ScrollBarThickness = 2

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 14)
sidebarCorner.Parent = sidebar

local sidebarCover = Instance.new("Frame")
sidebarCover.Parent = sidebar
sidebarCover.BackgroundColor3 = Theme.SidebarBg
sidebarCover.BorderSizePixel = 0
sidebarCover.Size = UDim2.new(0.5, 0, 1, 0)
sidebarCover.Position = UDim2.new(0.5, 0, 0, 0)

-- Sol Alt Görsel / Buton
local menuImageLogo = Instance.new("ImageButton")
menuImageLogo.Parent = sidebar
menuImageLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuImageLogo.BackgroundTransparency = 1
menuImageLogo.Position = UDim2.new(0, 15, 1, -45)
menuImageLogo.Size = UDim2.new(0, 32, 0, 32)
menuImageLogo.Image = "rbxassetid://109860189892062"
menuImageLogo.AutoButtonColor = false

local imageCorner = Instance.new("UICorner")
imageCorner.CornerRadius = UDim.new(0, 6)
imageCorner.Parent = menuImageLogo

-- Not Defteri (Patrick Jane Bilgi Penceresi)
local noteFrame = Instance.new("Frame")
noteFrame.Parent = screenGui
noteFrame.BackgroundColor3 = Theme.MainBg
noteFrame.BorderSizePixel = 0
noteFrame.Position = UDim2.new(0.5, -210, 0.5, -185)
noteFrame.Size = UDim2.new(0, 420, 0, 370)
noteFrame.Visible = false
noteFrame.ZIndex = 10

local noteCorner = Instance.new("UICorner")
noteCorner.CornerRadius = UDim.new(0, 14)
noteCorner.Parent = noteFrame

local noteStroke = Instance.new("UIStroke")
noteStroke.Color = Theme.Primary
noteStroke.Thickness = 2
noteStroke.Parent = noteFrame

local noteTitleBar = Instance.new("Frame")
noteTitleBar.Parent = noteFrame
noteTitleBar.BackgroundColor3 = Theme.TitleBg
noteTitleBar.BorderSizePixel = 0
noteTitleBar.Size = UDim2.new(1, 0, 0, 40)
noteTitleBar.ZIndex = 11

local noteTitleCorner = Instance.new("UICorner")
noteTitleCorner.CornerRadius = UDim.new(0, 14)
noteTitleCorner.Parent = noteTitleBar

local noteTitleCover = Instance.new("Frame")
noteTitleCover.Parent = noteTitleBar
noteTitleCover.BackgroundColor3 = Theme.TitleBg
noteTitleCover.BorderSizePixel = 0
noteTitleCover.Position = UDim2.new(0, 0, 0.5, 0)
noteTitleCover.Size = UDim2.new(1, 0, 0.5, 0)

local noteTitleText = Instance.new("TextLabel")
noteTitleText.Parent = noteTitleBar
noteTitleText.BackgroundTransparency = 1
noteTitleText.Position = UDim2.new(0, 15, 0, 0)
noteTitleText.Size = UDim2.new(0.8, 0, 1, 0)
noteTitleText.Font = Enum.Font.GothamBold
noteTitleText.Text = "📖 Patrick Jane - Detaylı Dosya"
noteTitleText.TextColor3 = Theme.TextPrimary
noteTitleText.TextSize = 13
noteTitleText.TextXAlignment = Enum.TextXAlignment.Left
noteTitleText.ZIndex = 12

local closeNoteBtn = Instance.new("TextButton")
closeNoteBtn.Parent = noteTitleBar
closeNoteBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeNoteBtn.Position = UDim2.new(1, -32, 0.5, -12)
closeNoteBtn.Size = UDim2.new(0, 24, 0, 24)
closeNoteBtn.Font = Enum.Font.GothamBold
closeNoteBtn.Text = "✕"
closeNoteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeNoteBtn.TextSize = 12
closeNoteBtn.ZIndex = 12

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeNoteBtn

closeNoteBtn.MouseButton1Click:Connect(function()
    noteFrame.Visible = false
end)

menuImageLogo.MouseButton1Click:Connect(function()
    noteFrame.Visible = not noteFrame.Visible
end)

local noteScroll = Instance.new("ScrollingFrame")
noteScroll.Parent = noteFrame
noteScroll.BackgroundTransparency = 1
noteScroll.Position = UDim2.new(0, 12, 0, 48)
noteScroll.Size = UDim2.new(1, -24, 1, -58)
noteScroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
noteScroll.ScrollBarThickness = 3
noteScroll.ZIndex = 11

local currentYPos = 0

local function addSection(titleTr, titleEn, contentTr, contentEn, needsSpoiler)
    local header = Instance.new("TextLabel")
    header.Parent = noteScroll
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 0, 0, currentYPos)
    header.Size = UDim2.new(1, 0, 0, 26)
    header.Font = Enum.Font.GothamBold
    header.Text = "🔹 " .. titleTr .. " / " .. titleEn
    header.TextColor3 = Color3.fromRGB(46, 204, 113)
    header.TextSize = 14
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.ZIndex = 11
    currentYPos = currentYPos + 30

    local textHolder = Instance.new("Frame")
    textHolder.Parent = noteScroll
    textHolder.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    textHolder.Position = UDim2.new(0, 0, 0, currentYPos)
    textHolder.Size = UDim2.new(1, 0, 0, 115)
    textHolder.ZIndex = 11

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 8)
    tCorner.Parent = textHolder

    local desc = Instance.new("TextLabel")
    desc.Parent = textHolder
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0, 10, 0, 8)
    desc.Size = UDim2.new(1, -20, 1, -16)
    desc.Font = Enum.Font.Gotham
    desc.Text = "TR:\n" .. contentTr .. "\n\nEN:\n" .. contentEn
    desc.TextColor3 = Color3.fromRGB(255, 255, 255)
    desc.TextSize = 12
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.ZIndex = 11

    if needsSpoiler then
        local spoilerBtn = Instance.new("TextButton")
        spoilerBtn.Parent = textHolder
        spoilerBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        spoilerBtn.Size = UDim2.new(1, 0, 1, 0)
        spoilerBtn.Font = Enum.Font.GothamBold
        spoilerBtn.Text = "SPOILER"
        spoilerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        spoilerBtn.TextSize = 16
        spoilerBtn.ZIndex = 15
        spoilerBtn.AutoButtonColor = false

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 8)
        sCorner.Parent = spoilerBtn

        local sStroke = Instance.new("UIStroke")
        sStroke.Color = Color3.fromRGB(46, 204, 113)
        sStroke.Thickness = 1.5
        sStroke.Parent = spoilerBtn

        spoilerBtn.MouseButton1Click:Connect(function()
            spoilerBtn:Destroy()
        end)
    end

    currentYPos = currentYPos + 125
end

addSection(
    "Karakter Özeti", "Character Overview",
    "Patrick Jane, CBI bünyesinde çalışan üstün zekalı, gözlem ve mentalizm ustası danışmandır. Ailesinin Red John tarafından öldürülmesinin ardından intikam peşine düşmüştür.",
    "Patrick Jane is a brilliant consultant and master of mentalism at the CBI. Following the murder of his family by Red John, he dedicates his life to seeking vengeance.",
    false
)

addSection(
    "Arkadaşlar ve Dostlar", "Friends & Allies",
    "Teresa Lisbon (en güvendiği amiri ve dostu), Cho, Rigsby ve Van Pelt (sadık CBI ekip arkadaşları).",
    "Teresa Lisbon (his most trusted boss and close ally), Cho, Rigsby, and Van Pelt (loyal CBI team members).",
    true
)

addSection(
    "Sevgililer ve Romantik İlişkiler", "Romance & Lovers",
    "Dizinin sonunda Teresa Lisbon ile evlenmiştir (karısı Angela'yı kaybettikten sonraki ilk gerçek aşkı). Geçmişte sahte medyumken veya vakalar sırasında flörtöz anları olmuştur.",
    "He ultimately marries Teresa Lisbon at the end of the series (his first true love after losing his late wife Angela). He occasionally had flirty moments with others.",
    true
)

addSection(
    "Ondan Hoşlananlar", "Admirers / Crush",
    "Erica Flynn (Jane'e hayranlık duyan zeki suçlu), Lorelei Martins (Red John'un takipçisi ancak Jane'e karşı hisleri olan biri) ve mesleği boyunca etkilediği çeşitli kadınlar.",
    "Erica Flynn (intelligent criminal fascinated by him), Lorelei Martins (Red John's follower with complex feelings for him), and various women he charmed throughout cases.",
    true
)

addSection(
    "Düşmanlar", "Enemies",
    "Red John (baş düşmanı ve ailesinin katili), Tommy Volker, Bret Stiles (Visualize tarikatının lideri) ve CBI'ı sabote eden yolsuzluk şebekeleri.",
    "Red John (arch-nemesis and family killer), Tommy Volker, Bret Stiles (leader of Visualize), and corrupt networks sabotaging the CBI.",
    true
)

addSection(
    "Ona Benzeyen Karakterler", "Similar Characters",
    "Sherlock Holmes (keskin gözlem), Adrian Monk (detay takıntısı ve travmatik geçmiş), Shawn Spencer (Psych - benzer zihinsel oyunlar).",
    "Sherlock Holmes (sharp observation), Adrian Monk (obsessive attention to detail and trauma), Shawn Spencer (Psych - similar mentalist tricks).",
    true
)

-- Sayfa Alanları
local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Parent = mainFrame
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 132, 0, 62)
    page.Size = UDim2.new(0, 305, 1, -74)
    page.CanvasSize = UDim2.new(0, 0, 0, 360)
    page.ScrollBarThickness = 3
    page.Visible = false
    return page
end

local mainPage = createPage()
mainPage.Visible = true
local movementsPage = createPage()
local settingsPage = createPage()
local infoPage = createPage()

local tabButtons = {}
local activeTabBtn = nil

local function createTab(name, posY, pageToOpen)
    local btn = Instance.new("TextButton")
    btn.Parent = sidebar
    btn.BackgroundColor3 = Theme.SecondaryBg
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Size = UDim2.new(0, 100, 0, 36)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = Theme.TextSecondary
    btn.TextSize = 12

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        mainPage.Visible = false
        movementsPage.Visible = false
        settingsPage.Visible = false
        infoPage.Visible = false
        pageToOpen.Visible = true
        
        activeTabBtn = btn
        for _, otherBtn in pairs(tabButtons) do
            if otherBtn ~= btn then
                tweenService:Create(otherBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondaryBg, TextColor3 = Theme.TextSecondary}):Play()
            end
        end
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    table.insert(tabButtons, btn)
    return btn
end

local mainTabBtn = createTab("Main", 12, mainPage)
activeTabBtn = mainTabBtn
mainTabBtn.BackgroundColor3 = Theme.Primary
mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createTab("Movements", 54, movementsPage)
createTab("Settings", 96, settingsPage)
createTab("Info", 138, infoPage)

local rainbowLabels = {}

local function createInfoBox(parent, title, desc, posY, isRainbow)
    local holder = Instance.new("Frame")
    holder.Parent = parent
    holder.BackgroundColor3 = Theme.SecondaryBg
    holder.Position = UDim2.new(0, 0, 0, posY)
    holder.Size = UDim2.new(0, 290, 0, 38)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = holder
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.BorderStroke
    stroke.Thickness = 1
    stroke.Parent = holder

    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = holder
    tLabel.BackgroundTransparency = 1
    tLabel.Position = UDim2.new(0, 15, 0, 0)
    tLabel.Size = UDim2.new(0.4, 0, 1, 0)
    tLabel.Font = Enum.Font.GothamSemibold
    tLabel.Text = title
    tLabel.TextColor3 = Theme.TextSecondary
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = holder
    dLabel.BackgroundTransparency = 1
    dLabel.Position = UDim2.new(0.4, 0, 0, 0)
    dLabel.Size = UDim2.new(0.6, -15, 1, 0)
    dLabel.Font = Enum.Font.GothamBold
    dLabel.Text = desc
    dLabel.TextColor3 = Theme.TextPrimary
    dLabel.TextSize = 12
    dLabel.TextXAlignment = Enum.TextXAlignment.Right

    if isRainbow then
        table.insert(rainbowLabels, dLabel)
    end
end

createInfoBox(infoPage, "Script Owner", "PatrickJane", 0, true)
createInfoBox(infoPage, "Discord", "nawb3__", 44, false)
createInfoBox(infoPage, "ScriptHelper", "Gemini AI", 88, true)
createInfoBox(infoPage, "Executor", executorName, 132, false)
infoPage.CanvasSize = UDim2.new(0, 0, 0, 180)

task.spawn(function()
    while true do
        local hue = tick() % 5 / 5
        local rainbowColor = Color3.fromHSV(hue, 0.9, 1)
        for i = 1, #rainbowLabels do
            pcall(function()
                rainbowLabels[i].TextColor3 = rainbowColor
            end)
        end
        task.wait(0.03)
    end
end)

local function createButton(parent, name, posY, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = defaultState and Theme.Primary or Theme.SecondaryBg
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.Size = UDim2.new(0, 290, 0, 44)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = ""

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = defaultState and Theme.Stroke or Theme.BorderStroke
    btnStroke.Thickness = 1.2
    btnStroke.Parent = btn

    local labelName = Instance.new("TextLabel")
    labelName.Parent = btn
    labelName.BackgroundTransparency = 1
    labelName.Position = UDim2.new(0, 15, 0, 0)
    labelName.Size = UDim2.new(0.65, 0, 1, 0)
    labelName.Font = Enum.Font.GothamSemibold
    labelName.Text = name
    labelName.TextColor3 = Theme.TextPrimary
    labelName.TextSize = 13
    labelName.TextXAlignment = Enum.TextXAlignment.Left

    local statusIndicator = Instance.new("TextLabel")
    statusIndicator.Parent = btn
    statusIndicator.BackgroundTransparency = 1
    statusIndicator.Position = UDim2.new(0.65, 0, 0, 0)
    statusIndicator.Size = UDim2.new(0.35, -15, 1, 0)
    statusIndicator.Font = Enum.Font.GothamBold
    statusIndicator.Text = defaultState and "AÇIK" or "KAPALI"
    statusIndicator.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary
    statusIndicator.TextSize = 12
    statusIndicator.TextXAlignment = Enum.TextXAlignment.Right

    btn.MouseButton1Click:Connect(function()
        local state = callback()
        local targetColor = state and Theme.Primary or Theme.SecondaryBg
        local strokeColor = state and Theme.Stroke or Theme.BorderStroke
        local textColor = state and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary
        
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        tweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = strokeColor}):Play()
        statusIndicator.Text = state and "AÇIK" or "KAPALI"
        statusIndicator.TextColor3 = textColor
    end)
end

createButton(mainPage, "Killaura", 0, Config.Killaura, function()
    Config.Killaura = not Config.Killaura
    return Config.Killaura
end)

createButton(mainPage, "Boss Farm (Tüm Bosslar)", 54, Config.BossFarm, function()
    Config.BossFarm = not Config.BossFarm
    return Config.BossFarm
end)

createButton(mainPage, "Token Farm", 108, Config.TokenFarm, function()
    Config.TokenFarm = not Config.TokenFarm
    return Config.TokenFarm
end)

createButton(mainPage, "Auto Rebirth", 162, Config.AutoRebirth, function()
    Config.AutoRebirth = not Config.AutoRebirth
    return Config.AutoRebirth
end)

mainPage.CanvasSize = UDim2.new(0, 0, 0, 220)

local keybindBtn = Instance.new("TextButton")
keybindBtn.Parent = settingsPage
keybindBtn.BackgroundColor3 = Theme.SecondaryBg
keybindBtn.Position = UDim2.new(0, 0, 0, 0)
keybindBtn.Size = UDim2.new(0, 290, 0, 38)
keybindBtn.AutoButtonColor = false
keybindBtn.Font = Enum.Font.GothamSemibold
keybindBtn.Text = ""

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 10)
kbCorner.Parent = keybindBtn

local kbStroke = Instance.new("UIStroke")
kbStroke.Color = Theme.BorderStroke
kbStroke.Thickness = 1.2
kbStroke.Parent = keybindBtn

local kbLabel = Instance.new("TextLabel")
kbLabel.Parent = keybindBtn
kbLabel.BackgroundTransparency = 1
kbLabel.Position = UDim2.new(0, 15, 0, 0)
kbLabel.Size = UDim2.new(0.5, 0, 1, 0)
kbLabel.Font = Enum.Font.GothamSemibold
kbLabel.Text = "Menu Keybind"
kbLabel.TextColor3 = Theme.TextPrimary
kbLabel.TextSize = 12.5
kbLabel.TextXAlignment = Enum.TextXAlignment.Left

local kbValue = Instance.new("TextLabel")
kbValue.Parent = keybindBtn
kbValue.BackgroundTransparency = 1
kbValue.Position = UDim2.new(0.5, 0, 0, 0)
kbValue.Size = UDim2.new(0.5, -15, 1, 0)
kbValue.Font = Enum.Font.GothamBold
kbValue.Text = tostring(Config.ToggleKey.Name)
kbValue.TextColor3 = Theme.TextSecondary
kbValue.TextSize = 12.5
kbValue.TextXAlignment = Enum.TextXAlignment.Right

local listeningForMenuKey = false
keybindBtn.MouseButton1Click:Connect(function()
    listeningForMenuKey = true
    kbValue.Text = "..."
end)

-- Yeni Eklenen: Koordinatımı Göster / Kaydet Tuşu
local saveCoordBtn = Instance.new("TextButton")
saveCoordBtn.Parent = settingsPage
saveCoordBtn.BackgroundColor3 = Theme.SecondaryBg
saveCoordBtn.Position = UDim2.new(0, 0, 0, 46)
saveCoordBtn.Size = UDim2.new(0, 290, 0, 38)
saveCoordBtn.AutoButtonColor = false
saveCoordBtn.Font = Enum.Font.GothamSemibold
saveCoordBtn.Text = ""

local scCorner = Instance.new("UICorner")
scCorner.CornerRadius = UDim.new(0, 10)
scCorner.Parent = saveCoordBtn

local scStroke = Instance.new("UIStroke")
scStroke.Color = Theme.BorderStroke
scStroke.Thickness = 1.2
scStroke.Parent = saveCoordBtn

local scLabel = Instance.new("TextLabel")
scLabel.Parent = saveCoordBtn
scLabel.BackgroundTransparency = 1
scLabel.Position = UDim2.new(0, 15, 0, 0)
scLabel.Size = UDim2.new(0.6, 0, 1, 0)
scLabel.Font = Enum.Font.GothamSemibold
scLabel.Text = "Koordinatımı Göster"
scLabel.TextColor3 = Theme.TextPrimary
scLabel.TextSize = 12.5
scLabel.TextXAlignment = Enum.TextXAlignment.Left

local scAction = Instance.new("TextLabel")
scAction.Parent = saveCoordBtn
scAction.BackgroundTransparency = 1
scAction.Position = UDim2.new(0.6, 0, 0, 0)
scAction.Size = UDim2.new(0.4, -15, 1, 0)
scAction.Font = Enum.Font.GothamBold
scAction.Text = "KAYDET"
scAction.TextColor3 = Theme.TextSecondary
scAction.TextSize = 12
scAction.TextXAlignment = Enum.TextXAlignment.Right

saveCoordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = lp.Character
        if char then
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                -- Mevcut konumu ve yönü (LookVector * 18 ekleyerek) günceller
                savedTokenCFrame = rootPart.CFrame + (rootPart.CFrame.LookVector * 18)
                scAction.Text = "KAYDEDİLDİ!"
                task.delay(2, function()
                    scAction.Text = "KAYDET"
                end)
            end
        end
    end)
end)

local rjBtn = Instance.new("TextButton")
rjBtn.Parent = settingsPage
rjBtn.BackgroundColor3 = Theme.SecondaryBg
rjBtn.Position = UDim2.new(0, 0, 0, 92)
rjBtn.Size = UDim2.new(0, 290, 0, 38)
rjBtn.AutoButtonColor = false
rjBtn.Font = Enum.Font.GothamSemibold
rjBtn.Text = ""

local rjCorner = Instance.new("UICorner")
rjCorner.CornerRadius = UDim.new(0, 10)
rjCorner.Parent = rjBtn

local rjStroke = Instance.new("UIStroke")
rjStroke.Color = Theme.BorderStroke
rjStroke.Thickness = 1.2
rjStroke.Parent = rjBtn

local rjLabel = Instance.new("TextLabel")
rjLabel.Parent = rjBtn
rjLabel.BackgroundTransparency = 1
rjLabel.Position = UDim2.new(0, 15, 0, 0)
rjLabel.Size = UDim2.new(0.7, 0, 1, 0)
rjLabel.Font = Enum.Font.GothamSemibold
rjLabel.Text = "Rejoin Server"
rjLabel.TextColor3 = Theme.TextPrimary
rjLabel.TextSize = 12.5
rjLabel.TextXAlignment = Enum.TextXAlignment.Left

local rjAction = Instance.new("TextLabel")
rjAction.Parent = rjBtn
rjAction.BackgroundTransparency = 1
rjAction.Position = UDim2.new(0.7, 0, 0, 0)
rjAction.Size = UDim2.new(0.3, -15, 1, 0)
rjAction.Font = Enum.Font.GothamBold
rjAction.Text = "BAĞLAN"
rjAction.TextColor3 = Theme.TextSecondary
rjAction.TextSize = 12
rjAction.TextXAlignment = Enum.TextXAlignment.Right

rjBtn.MouseButton1Click:Connect(function()
    rjAction.Text = "Yeniden..."
    pcall(function()
        teleportService:Teleport(game.PlaceId, lp)
    end)
end)

local shBtn = Instance.new("TextButton")
shBtn.Parent = settingsPage
shBtn.BackgroundColor3 = Theme.SecondaryBg
shBtn.Position = UDim2.new(0, 0, 0, 138)
shBtn.Size = UDim2.new(0, 290, 0, 38)
shBtn.AutoButtonColor = false
shBtn.Font = Enum.Font.GothamSemibold
shBtn.Text = ""

local shCorner = Instance.new("UICorner")
shCorner.CornerRadius = UDim.new(0, 10)
shCorner.Parent = shBtn

local shStroke = Instance.new("UIStroke")
shStroke.Color = Theme.BorderStroke
shStroke.Thickness = 1.2
shStroke.Parent = shBtn

local shLabel = Instance.new("TextLabel")
shLabel.Parent = shBtn
shLabel.BackgroundTransparency = 1
shLabel.Position = UDim2.new(0, 15, 0, 0)
shLabel.Size = UDim2.new(0.7, 0, 1, 0)
shLabel.Font = Enum.Font.GothamSemibold
shLabel.Text = "Server Hop"
shLabel.TextColor3 = Theme.TextPrimary
shLabel.TextSize = 12.5
shLabel.TextXAlignment = Enum.TextXAlignment.Left

local shAction = Instance.new("TextLabel")
shAction.Parent = shBtn
shAction.BackgroundTransparency = 1
shAction.Position = UDim2.new(0.7, 0, 0, 0)
shAction.Size = UDim2.new(0.3, -15, 1, 0)
shAction.Font = Enum.Font.GothamBold
shAction.Text = "DEĞİŞ"
shAction.TextColor3 = Theme.TextSecondary
shAction.TextSize = 12
shAction.TextXAlignment = Enum.TextXAlignment.Right

shBtn.MouseButton1Click:Connect(function()
    shAction.Text = "Aranıyor..."
    task.spawn(function()
        local success, servers = pcall(function()
            return httpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and servers and servers.data then
            for _, s in pairs(servers.data) do
                if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                    shAction.Text = "Geçiliyor"
                    teleportService:TeleportToPlaceInstance(game.PlaceId, s.id, lp)
                    break
                end
            end
        end
        shAction.Text = "Bulunamadı"
        task.wait(2)
        shAction.Text = "DEĞİŞ"
    end)
end)

local iyBtn = Instance.new("TextButton")
iyBtn.Parent = settingsPage
iyBtn.BackgroundColor3 = Theme.SecondaryBg
iyBtn.Position = UDim2.new(0, 0, 0, 184)
iyBtn.Size = UDim2.new(0, 290, 0, 38)
iyBtn.AutoButtonColor = false
iyBtn.Font = Enum.Font.GothamSemibold
iyBtn.Text = ""

local iyCorner = Instance.new("UICorner")
iyCorner.CornerRadius = UDim.new(0, 10)
iyCorner.Parent = iyBtn

local iyStroke = Instance.new("UIStroke")
iyStroke.Color = Theme.BorderStroke
iyStroke.Thickness = 1.2
iyStroke.Parent = iyBtn

local iyLabel = Instance.new("TextLabel")
iyLabel.Parent = iyBtn
iyLabel.BackgroundTransparency = 1
iyLabel.Position = UDim2.new(0, 15, 0, 0)
iyLabel.Size = UDim2.new(0.7, 0, 1, 0)
iyLabel.Font = Enum.Font.GothamSemibold
iyLabel.Text = "Infinite Yield"
iyLabel.TextColor3 = Theme.TextPrimary
iyLabel.TextSize = 12.5
iyLabel.TextXAlignment = Enum.TextXAlignment.Left

local iyAction = Instance.new("TextLabel")
iyAction.Parent = iyBtn
iyAction.BackgroundTransparency = 1
iyAction.Position = UDim2.new(0.7, 0, 0, 0)
iyAction.Size = UDim2.new(0.3, -15, 1, 0)
iyAction.Font = Enum.Font.GothamBold
iyAction.Text = "YÜKLE"
iyAction.TextColor3 = Theme.TextSecondary
iyAction.TextSize = 12
iyAction.TextXAlignment = Enum.TextXAlignment.Right

iyBtn.MouseButton1Click:Connect(function()
    iyAction.Text = "YÜKLENDİ"
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
    task.delay(2.5, function()
        iyAction.Text = "YÜKLE"
    end)
end)

local fpsBtn = Instance.new("TextButton")
fpsBtn.Parent = settingsPage
fpsBtn.BackgroundColor3 = Theme.SecondaryBg
fpsBtn.Position = UDim2.new(0, 0, 0, 230)
fpsBtn.Size = UDim2.new(0, 290, 0, 38)
fpsBtn.AutoButtonColor = false
fpsBtn.Font = Enum.Font.GothamSemibold
fpsBtn.Text = ""

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 10)
fpsCorner.Parent = fpsBtn

local fpsStroke = Instance.new("UIStroke")
fpsStroke.Color = Theme.BorderStroke
fpsStroke.Thickness = 1.2
fpsStroke.Parent = fpsBtn

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = fpsBtn
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.new(0, 15, 0, 0)
fpsLabel.Size = UDim2.new(0.7, 0, 1, 0)
fpsLabel.Font = Enum.Font.GothamSemibold
fpsLabel.Text = "FPS Booster"
fpsLabel.TextColor3 = Theme.TextPrimary
fpsLabel.TextSize = 12.5
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local fpsAction = Instance.new("TextLabel")
fpsAction.Parent = fpsBtn
fpsAction.BackgroundTransparency = 1
fpsAction.Position = UDim2.new(0.7, 0, 0, 0)
fpsAction.Size = UDim2.new(0.3, -15, 1, 0)
fpsAction.Font = Enum.Font.GothamBold
fpsAction.Text = "ÇALIŞTIR"
fpsAction.TextColor3 = Theme.TextSecondary
fpsAction.TextSize = 12
fpsAction.TextXAlignment = Enum.TextXAlignment.Right

fpsBtn.MouseButton1Click:Connect(function()
    fpsAction.Text = "AKTİF"
    pcall(function()
        _G.Settings = {
            Players = { ["Ignore Me"] = true, ["Ignore Others"] = true },
            Meshes = { ["Destroy"] = false, ["LowDetail"] = true },
            Images = { ["Invisible"] = true, ["LowDetail"] = false, ["Destroy"] = false },
            Other = { ["No Particles"] = true, ["No Camera Effects"] = true, ["No Explosions"] = true, ["No Clothes"] = true, ["Low Water Graphics"] = true, ["No Shadows"] = true, ["Low Rendering"] = true, ["Low Quality Parts"] = true }
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
    end)
    task.delay(2.5, function()
        fpsAction.Text = "ÇALIŞTIR"
    end)
end)

settingsPage.CanvasSize = UDim2.new(0, 0, 0, 280)

local wsHolder = Instance.new("Frame")
wsHolder.Parent = movementsPage
wsHolder.BackgroundColor3 = Theme.SecondaryBg
wsHolder.Position = UDim2.new(0, 0, 0, 0)
wsHolder.Size = UDim2.new(0, 290, 0, 48)

local wsCorner = Instance.new("UICorner")
wsCorner.CornerRadius = UDim.new(0, 10)
wsCorner.Parent = wsHolder

local wsStroke = Instance.new("UIStroke")
wsStroke.Color = Theme.BorderStroke
wsStroke.Thickness = 1.2
wsStroke.Parent = wsHolder

local wsLabel = Instance.new("TextLabel")
wsLabel.Parent = wsHolder
wsLabel.BackgroundTransparency = 1
wsLabel.Position = UDim2.new(0, 15, 0, 5)
wsLabel.Size = UDim2.new(0.7, 0, 0, 18)
wsLabel.Font = Enum.Font.GothamSemibold
wsLabel.Text = "WalkSpeed"
wsLabel.TextColor3 = Theme.TextPrimary
wsLabel.TextSize = 12.5
wsLabel.TextXAlignment = Enum.TextXAlignment.Left

local wsValLabel = Instance.new("TextLabel")
wsValLabel.Parent = wsHolder
wsValLabel.BackgroundTransparency = 1
wsValLabel.Position = UDim2.new(0.7, 0, 0, 5)
wsValLabel.Size = UDim2.new(0.3, -15, 0, 18)
wsValLabel.Font = Enum.Font.GothamBold
wsValLabel.Text = "16"
wsValLabel.TextColor3 = Theme.TextSecondary
wsValLabel.TextSize = 12.5
wsValLabel.TextXAlignment = Enum.TextXAlignment.Right

local sliderBar = Instance.new("Frame")
sliderBar.Parent = wsHolder
sliderBar.BackgroundColor3 = Theme.SidebarBg
sliderBar.BorderSizePixel = 0
sliderBar.Position = UDim2.new(0, 15, 0, 30)
sliderBar.Size = UDim2.new(0, 260, 0, 6)

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(1, 0)
sbCorner.Parent = sliderBar

local sliderFill = Instance.new("Frame")
sliderFill.Parent = sliderBar
sliderFill.BackgroundColor3 = Theme.Primary
sliderFill.BorderSizePixel = 0
sliderFill.Size = UDim2.new(0, 0, 1, 0)

local sfCorner = Instance.new("UICorner")
sfCorner.CornerRadius = UDim.new(1, 0)
sfCorner.Parent = sliderFill

local sliderBtn = Instance.new("TextButton")
sliderBtn.Parent = sliderBar
sliderBtn.BackgroundTransparency = 1
sliderBtn.Position = UDim2.new(0, -5, 0, -8)
sliderBtn.Size = UDim2.new(1, 10, 0, 22)
sliderBtn.Text = ""

local minSpeed = 16
local maxSpeed = 300
local slidingWS = false

sliderBtn.MouseButton1Down:Connect(function() slidingWS = true end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingWS = false
    end
end)

uis.InputChanged:Connect(function(input)
    if slidingWS and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local speedVal = math.floor(minSpeed + (pos * (maxSpeed - minSpeed)))
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        wsValLabel.Text = tostring(speedVal)
        Config.WalkSpeed = speedVal
        
        pcall(function()
            if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedVal
            end
        end)
    end
end)

local jpHolder = Instance.new("Frame")
jpHolder.Parent = movementsPage
jpHolder.BackgroundColor3 = Theme.SecondaryBg
jpHolder.Position = UDim2.new(0, 0, 0, 56)
jpHolder.Size = UDim2.new(0, 290, 0, 48)

local jpCorner = Instance.new("UICorner")
jpCorner.CornerRadius = UDim.new(0, 10)
jpCorner.Parent = jpHolder

local jpStroke = Instance.new("UIStroke")
jpStroke.Color = Theme.BorderStroke
jpStroke.Thickness = 1.2
jpStroke.Parent = jpHolder

local jpLabel = Instance.new("TextLabel")
jpLabel.Parent = jpHolder
jpLabel.BackgroundTransparency = 1
jpLabel.Position = UDim2.new(0, 15, 0, 5)
jpLabel.Size = UDim2.new(0.7, 0, 0, 18)
jpLabel.Font = Enum.Font.GothamSemibold
jpLabel.Text = "JumpPower"
jpLabel.TextColor3 = Theme.TextPrimary
jpLabel.TextSize = 12.5
jpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jpValLabel = Instance.new("TextLabel")
jpValLabel.Parent = jpHolder
jpValLabel.BackgroundTransparency = 1
jpValLabel.Position = UDim2.new(0.7, 0, 0, 5)
jpValLabel.Size = UDim2.new(0.3, -15, 0, 18)
jpValLabel.Font = Enum.Font.GothamBold
jpValLabel.Text = "50"
jpValLabel.TextColor3 = Theme.TextSecondary
jpValLabel.TextSize = 12.5
jpValLabel.TextXAlignment = Enum.TextXAlignment.Right

local jpSliderBar = Instance.new("Frame")
jpSliderBar.Parent = jpHolder
jpSliderBar.BackgroundColor3 = Theme.SidebarBg
jpSliderBar.BorderSizePixel = 0
jpSliderBar.Position = UDim2.new(0, 15, 0, 30)
jpSliderBar.Size = UDim2.new(0, 260, 0, 6)

local jpsbCorner = Instance.new("UICorner")
jpsbCorner.CornerRadius = UDim.new(1, 0)
jpsbCorner.Parent = jpSliderBar

local jpSliderFill = Instance.new("Frame")
jpSliderFill.Parent = jpSliderBar
jpSliderFill.BackgroundColor3 = Theme.Primary
jpSliderFill.BorderSizePixel = 0
jpSliderFill.Size = UDim2.new(0, 0, 1, 0)

local jpSfCorner = Instance.new("UICorner")
jpSfCorner.CornerRadius = UDim.new(1, 0)
jpSfCorner.Parent = jpSliderFill

local jpSliderBtn = Instance.new("TextButton")
jpSliderBtn.Parent = jpSliderBar
jpSliderBtn.BackgroundTransparency = 1
jpSliderBtn.Position = UDim2.new(0, -5, 0, -8)
jpSliderBtn.Size = UDim2.new(1, 10, 0, 22)
jpSliderBtn.Text = ""

local minJump = 50
local maxJump = 300
local slidingJP = false

jpSliderBtn.MouseButton1Down:Connect(function() slidingJP = true end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slidingJP = false
    end
end)

uis.InputChanged:Connect(function(input)
    if slidingJP and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - jpSliderBar.AbsolutePosition.X) / jpSliderBar.AbsoluteSize.X, 0, 1)
        local jumpVal = math.floor(minJump + (pos * (maxJump - minJump)))
        jpSliderFill.Size = UDim2.new(pos, 0, 1, 0)
        jpValLabel.Text = tostring(jumpVal)
        Config.JumpPower = jumpVal
        
        pcall(function()
            if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                hum.UseJumpPower = true
                hum.JumpPower = jumpVal
            end
        end)
    end
end)

local function createSettingsButton(parent, name, posY, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = defaultState and Theme.Primary or Theme.SecondaryBg
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.Size = UDim2.new(0, 290, 0, 38)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = ""

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = defaultState and Theme.Stroke or Theme.BorderStroke
    btnStroke.Thickness = 1.2
    btnStroke.Parent = btn

    local labelName = Instance.new("TextLabel")
    labelName.Parent = btn
    labelName.BackgroundTransparency = 1
    labelName.Position = UDim2.new(0, 15, 0, 0)
    labelName.Size = UDim2.new(0.65, 0, 1, 0)
    labelName.Font = Enum.Font.GothamSemibold
    labelName.Text = name
    labelName.TextColor3 = Theme.TextPrimary
    labelName.TextSize = 12.5
    labelName.TextXAlignment = Enum.TextXAlignment.Left

    local statusIndicator = Instance.new("TextLabel")
    statusIndicator.Parent = btn
    statusIndicator.BackgroundTransparency = 1
    statusIndicator.Position = UDim2.new(0.65, 0, 0, 0)
    statusIndicator.Size = UDim2.new(0.35, -15, 1, 0)
    statusIndicator.Font = Enum.Font.GothamBold
    statusIndicator.Text = defaultState and "AÇIK" or "KAPALI"
    statusIndicator.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary
    statusIndicator.TextSize = 12
    statusIndicator.TextXAlignment = Enum.TextXAlignment.Right

    btn.MouseButton1Click:Connect(function()
        local state = callback()
        local targetColor = state and Theme.Primary or Theme.SecondaryBg
        local strokeColor = state and Theme.Stroke or Theme.BorderStroke
        local textColor = state and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary
        
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        tweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = strokeColor}):Play()
        statusIndicator.Text = state and "AÇIK" or "KAPALI"
        statusIndicator.TextColor3 = textColor
    end)
end

createSettingsButton(movementsPage, "Noclip", 112, Config.Noclip, function()
    Config.Noclip = not Config.Noclip
    return Config.Noclip
end)

createSettingsButton(movementsPage, "Infinite Jump", 156, Config.InfJump, function()
    Config.InfJump = not Config.InfJump
    return Config.InfJump
end)

uis.InputBegan:Connect(function(input, gameProcessed)
    if listeningForMenuKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Config.ToggleKey = input.KeyCode
            kbValue.Text = tostring(input.KeyCode.Name)
            listeningForMenuKey = false
        end
    else
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Config.ToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end
end)

local function getMultipleEnemies(char)
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return {} end
    local targets = {}
    
    for _, area in pairs(areas:GetChildren()) do
        local holder = area:FindFirstChild("EnemyHolder")
        if holder then
            local children = holder:GetChildren()
            for i = 1, #children do
                local enemy = children[i]
                local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Head")
                
                if root and humanoid and humanoid.Health > 0 then
                    local dist = (rootPart.Position - root.Position).Magnitude
                    if dist <= Config.KillauraRange then
                        table.insert(targets, enemy)
                    end
                end
            end
        end
    end
    return targets
end

local function getClosestBoss(char)
    local children = workspace:GetChildren()
    for i = 1, #children do
        local obj = children[i]
        if obj:IsA("Model") and obj ~= char then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
            
            if humanoid and root and humanoid.Health > 0 then
                local isPlayer = false
                local playersList = players:GetPlayers()
                for j = 1, #playersList do
                    if playersList[j].Character == obj then isPlayer = true break end
                end
                
                if not isPlayer and (humanoid.MaxHealth > 1000 or string.find(string.lower(obj.Name), "boss") or obj.Name == "Laser Bacon") then
                    return obj
                end
            end
        end
    end
    return nil
end

-- 30 Saniyede Bir Işınlanma Döngüsü (Token Farm - Kaydedilen Koordinatı Kullanır)
task.spawn(function()
    while true do
        if Config.TokenFarm then
            pcall(function()
                local char = lp.Character
                if char then
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = savedTokenCFrame
                    end
                end
            end)
            task.wait(40)
        else
            task.wait(1)
        end
    end
end)

-- Diğer Farm ve Killaura Döngüsü
task.spawn(function()
    while true do
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if humanoid.Health > 0 and rootPart then
                if Config.BossFarm then
                    local boss = getClosestBoss(char)
                    if boss then pcall(function() punch:FireServer(boss) end) end
                elseif Config.Killaura then
                    local enemies = getMultipleEnemies(char)
                    for i = 1, #enemies do
                        local enemy = enemies[i]
                        task.spawn(function()
                            pcall(function()
                                punch:FireServer(enemy)
                            end)
                        end)
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

runService.Stepped:Connect(function()
    if Config.Noclip and lp.Character then
        local descendants = lp.Character:GetDescendants()
        for i = 1, #descendants do
            local part = descendants[i]
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if Config.InfJump and lp.Character then
        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

task.spawn(function()
    while true do
        if Config.AutoRebirth and rebirthRemote then
            pcall(function() rebirthRemote:FireServer() end)
        end
        task.wait(1)
    end
end)