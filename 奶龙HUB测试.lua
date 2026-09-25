local function safeNotify(title,text,duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title=title,
            Text=text,
            Duration=duration or 3
        })
    end)
end

local function safeHttpGet(url)
    local ok,res=pcall(function()
        return game:HttpGet(url)
    end)
    if ok then return res end
    return nil
end

local tasklib=task or {}
if not tasklib.wait then
    tasklib.wait=function(t)
        wait(t)
    end
end
if not tasklib.spawn then
    tasklib.spawn=function(f)
        coroutine.wrap(f)()
    end
end
task=tasklib

local ok,err=xpcall(function()

local A=game:GetService("StarterGui")

local finishStartup
local updateStartupProgress
pcall(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local playerGui = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    local oldGui = CoreGui:FindFirstChild("NailongHubStartup")
    if oldGui then oldGui:Destroy() end
    if playerGui then
        local oldPlayerGui = playerGui:FindFirstChild("NailongHubStartup")
        if oldPlayerGui then oldPlayerGui:Destroy() end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NailongHubStartup"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.Parent = playerGui or CoreGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1,1)
    bg.BackgroundColor3 = Color3.fromRGB(8,7,3)
    bg.BackgroundTransparency = 0.12
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local decorLayer = Instance.new("Frame")
    decorLayer.Name = "GoldCircleDecorations"
    decorLayer.AnchorPoint = Vector2.new(0.5,0.5)
    decorLayer.Position = UDim2.fromScale(0.5,0.39)
    decorLayer.Size = UDim2.fromOffset(520,520)
    decorLayer.BackgroundTransparency = 1
    decorLayer.BorderSizePixel = 0
    decorLayer.Parent = bg

    local function addDecorCircle(size,thickness)
        local circle = Instance.new("Frame")
        circle.AnchorPoint = Vector2.new(0.5,0.5)
        circle.Size = UDim2.fromOffset(size,size)
        circle.BackgroundTransparency = 1
        circle.BorderSizePixel = 0
        circle.Parent = decorLayer
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1,0)
        corner.Parent = circle
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = thickness or 2
        stroke.Color = Color3.fromRGB(255,195,0)
        stroke.Transparency = 0.12
        stroke.Parent = circle
        return circle
    end

    local circles = {}
    local circleCount = 18
    for i=1,circleCount do
        local circle = addDecorCircle(12 + (i % 4) * 5, 2)
        circles[i] = {
            object=circle,
            baseSize=12 + (i % 4) * 5,
            angle=(i-1)*(360/circleCount) + (i%2)*8,
            radius=115 + (i%5)*18,
            speed=18 + (i%4)*5,
            phase=(i%6)*0.35
        }
    end

    task.spawn(function()
        local t=0
        while decorLayer and decorLayer.Parent do
            t=t+0.035
            for _,data in ipairs(circles) do
                local obj=data.object
                if obj and obj.Parent then
                    local cycle=(t*data.speed/55 + data.phase)%1
                    local radius=45 + cycle*215
                    local angle=math.rad(data.angle + t*7)
                    local x=260 + math.cos(angle)*radius
                    local y=260 + math.sin(angle)*radius
                    obj.Position=UDim2.fromOffset(x,y)
                    local fade=0.05 + cycle*0.58
                    local stroke=obj:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Transparency=math.clamp(fade,0.05,0.72) end
                    local scale=0.75 + cycle*0.75
                    obj.Size=UDim2.fromOffset(data.baseSize*scale,data.baseSize*scale)
                end
            end
            task.wait(0.035)
        end
    end)

    for _,ringData in ipairs({{size=410,thickness=2,trans=0.72},{size=500,thickness=2,trans=0.82}}) do
        local ring=Instance.new("Frame")
        ring.AnchorPoint=Vector2.new(0.5,0.5)
        ring.Position=UDim2.fromOffset(260,260)
        ring.Size=UDim2.fromOffset(ringData.size,ringData.size)
        ring.BackgroundTransparency=1
        ring.BorderSizePixel=0
        ring.Parent=decorLayer
        Instance.new("UICorner",ring).CornerRadius=UDim.new(1,0)
        local stroke=Instance.new("UIStroke")
        stroke.Thickness=ringData.thickness
        stroke.Color=Color3.fromRGB(255,190,0)
        stroke.Transparency=ringData.trans
        stroke.Parent=ring
    end

    local imageBorder = Instance.new("Frame")
    imageBorder.Name = "GoldSquareBorder"
    imageBorder.AnchorPoint = Vector2.new(0.5,0.5)
    imageBorder.Position = UDim2.fromScale(0.5,0.39)
    imageBorder.Size = UDim2.fromOffset(232,232)
    imageBorder.BackgroundColor3 = Color3.fromRGB(255,195,0)
    imageBorder.BorderSizePixel = 0
    imageBorder.Parent = bg

    local icon = Instance.new("ImageLabel")
    icon.Name = "CenterIcon"
    icon.AnchorPoint = Vector2.new(0.5,0.5)
    icon.Position = UDim2.fromScale(0.5,0.5)
    icon.Size = UDim2.fromOffset(224,224)
    icon.BackgroundColor3 = Color3.fromRGB(8,7,3)
    icon.BackgroundTransparency = 0
    icon.BorderSizePixel = 0
    icon.Image = "rbxassetid://118156660240152"
    icon.ImageTransparency = 1
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = imageBorder

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.fromScale(0.5,0.57)
    title.Size = UDim2.fromOffset(700,68)
    title.BackgroundTransparency = 1
    title.Text = "正在加载 奶龙_HUB"
    title.TextColor3 = Color3.fromRGB(255,220,100)
    title.TextTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 42
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.AnchorPoint = Vector2.new(0.5,0)
    sub.Position = UDim2.fromScale(0.5,0.65)
    sub.Size = UDim2.fromOffset(700,42)
    sub.BackgroundTransparency = 1
    sub.Text = "正在初始化..."
    sub.TextColor3 = Color3.fromRGB(235,220,175)
    sub.TextTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 20
    sub.Parent = bg

    local barBack = Instance.new("Frame")
    barBack.AnchorPoint = Vector2.new(0.5,0)
    barBack.Position = UDim2.fromScale(0.5,0.74)
    barBack.Size = UDim2.fromOffset(440,9)
    barBack.BackgroundColor3 = Color3.fromRGB(65,52,20)
    barBack.BackgroundTransparency = 1
    barBack.BorderSizePixel = 0
    barBack.Parent = bg
    Instance.new("UICorner",barBack).CornerRadius = UDim.new(1,0)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromScale(0.05,1)
    bar.BackgroundColor3 = Color3.fromRGB(255,195,0)
    bar.BackgroundTransparency = 1
    bar.BorderSizePixel = 0
    bar.Parent = barBack
    Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

    local percent = Instance.new("TextLabel")
    percent.AnchorPoint = Vector2.new(0.5,0)
    percent.Position = UDim2.fromScale(0.5,0.775)
    percent.Size = UDim2.fromOffset(200,34)
    percent.BackgroundTransparency = 1
    percent.Text = "5%"
    percent.TextColor3 = Color3.fromRGB(255,210,70)
    percent.TextTransparency = 1
    percent.Font = Enum.Font.GothamBold
    percent.TextSize = 16
    percent.Parent = bg

    local function tw(obj,time,props)
        return TweenService:Create(obj,TweenInfo.new(time,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props)
    end

    tw(icon,0.45,{ImageTransparency=0}):Play()
    tw(title,0.45,{TextTransparency=0}):Play()
    tw(sub,0.45,{TextTransparency=0}):Play()
    tw(barBack,0.35,{BackgroundTransparency=0}):Play()
    tw(bar,0.5,{Size=UDim2.fromScale(0.05,1),BackgroundTransparency=0}):Play()
    tw(percent,0.35,{TextTransparency=0}):Play()

    updateStartupProgress = function(value,text)
        if not gui or not gui.Parent then return end
        value = math.clamp(tonumber(value) or 0,0,100)
        if text then sub.Text = text end
        percent.Text = tostring(math.floor(value)).."%"
        bar.Size = UDim2.fromScale(value/100,1)
    end

    finishStartup = function()
        if not gui or not gui.Parent then return end
        updateStartupProgress(100,"加载完成")
        task.wait(0.35)
        tw(bg,0.45,{BackgroundTransparency=1}):Play()
        tw(icon,0.35,{ImageTransparency=1}):Play()
        tw(title,0.35,{TextTransparency=1}):Play()
        tw(sub,0.35,{TextTransparency=1}):Play()
        tw(barBack,0.3,{BackgroundTransparency=1}):Play()
        tw(percent,0.3,{TextTransparency=1}):Play()
        task.wait(0.5)
        if gui and gui.Parent then gui:Destroy() end
    end
end)

pcall(function()
    local startupSound = Instance.new("Sound")
    startupSound.Name = "奶龙_HUB_StartupSound"
    startupSound.SoundId = "rbxassetid://84267705669861"
    startupSound.Volume = 5
    startupSound.Looped = false
    startupSound.Parent = game:GetService("SoundService")
    startupSound:Play()
    startupSound.Ended:Connect(function()
        startupSound:Destroy()
    end)
end)

if updateStartupProgress then
    updateStartupProgress(10,"正在初始化...")
end

local function gradient(text,startColor,endColor)
    local result=""
    local chars={}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars,uchar) end
    local length=#chars
    for i=1,length do
        local t=(i-1)/math.max(length-1,1)
        local r=startColor.R+(endColor.R-startColor.R)*t
        local g=startColor.G+(endColor.G-startColor.G)*t
        local b=startColor.B+(endColor.B-startColor.B)*t
        result=result..string.format('<font color="rgb(%d,%d,%d)">%s</font>',math.floor(r*255),math.floor(g*255),math.floor(b*255),chars[i])
    end
    return result
end

local B=nil
local winduiUrls = {
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    "https://raw.githubusercontent.com/951357nvjn/dyzs/refs/heads/main/winduiYI.lua"
}

local winduiLastError = "未知错误"

for _,url in ipairs(winduiUrls) do
    local ok, result = pcall(function()
        local code = game:HttpGet(url)
        if type(code) ~= "string" or #code < 100 then
            error("UI库返回内容为空")
        end
        code = code:gsub("Close Window", "确定要关闭我吗QAQ")
        code = code:gsub("Do you want to close this window%? You will not be able to open it again%.", "欢迎你的下次使用(⑉• •⑉)‥♡")
        code = code:gsub("Cancel", "取消")
        local loader = loadstring(code)
        if type(loader) ~= "function" then
            error("loadstring失败")
        end
        return loader()
    end)
    if ok and result then
        B = result
        break
    else
        winduiLastError = tostring(result)
    end
    task.wait(0.25)
end

if updateStartupProgress then updateStartupProgress(65,"正在加载界面...") end

if not B then
    pcall(function()
        A:SetCore("SendNotification",{Title="WindUI加载失败",Text="请检查Delta网络/HttpGet支持",Duration=5})
    end)
    warn("[奶龙_HUB] WindUI加载失败:", winduiLastError)
    return
end

pcall(function() B.Transparency=0.3 end)

pcall(function()
    B:AddTheme({
        Name = "奶龙_Gold",
        Accent = Color3.fromRGB(255, 190, 0),
        Background = Color3.fromRGB(24, 20, 8),
        Outline = Color3.fromRGB(255, 200, 0),
        Text = Color3.fromRGB(255, 225, 130),
        Placeholder = Color3.fromRGB(190, 160, 80),
        Button = Color3.fromRGB(90, 65, 10),
        Icon = Color3.fromRGB(255, 200, 0),
    })
    B:SetTheme("奶龙_Gold")
end)


if updateStartupProgress then updateStartupProgress(82,"正在创建界面...") end

local C=B:CreateWindow({Icon="crown",Title=gradient("奶龙_HUB",Color3.fromRGB(255,235,120),Color3.fromRGB(255,170,0)),Author=gradient("@墨水依旧 司空",Color3.fromRGB(255,235,120),Color3.fromRGB(255,170,0)),Folder="奶龙_HUB",Size=UDim2.fromOffset(520,410),Background="rbxassetid://118156660240152",BackgroundImageTransparency=0.25,Theme="奶龙_Gold",User={Enabled=false},SideBarWidth=160,ScrollBarEnabled=true})
C:EditOpenButton({Title=gradient("奶龙_HUB",Color3.fromRGB(255,235,120),Color3.fromRGB(255,170,0)),Icon="crown",StrokeThickness=2,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,235,120)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,190,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,140,0))}),Draggable=true})

pcall(function()
    local TweenService = game:GetService("TweenService")
    local main = C and (C.UIElements and C.UIElements.Main or C.Frame or C.Gui)
    if not main or not main:IsA("GuiObject") then return end

    local uiScale = main:FindFirstChild("NailongUIAnimationScale")
    if not uiScale then
        uiScale = Instance.new("UIScale")
        uiScale.Name = "NailongUIAnimationScale"
        uiScale.Scale = 1
        uiScale.Parent = main
    end

    local openTween
    local closeTween

    local function playOpenAnimation()
        if not main or not main.Parent then return end
        if openTween then openTween:Cancel() end
        if closeTween then closeTween:Cancel() end
        uiScale.Scale = 0.90
        openTween = TweenService:Create(
            uiScale,
            TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1}
        )
        openTween:Play()
    end

    local function playCloseAnimation()
        if not main or not main.Parent then return end
        if openTween then openTween:Cancel() end
        if closeTween then closeTween:Cancel() end
        closeTween = TweenService:Create(
            uiScale,
            TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = 0.90}
        )
        closeTween:Play()
    end

    if C.OnOpen then
        C:OnOpen(function()
            task.defer(playOpenAnimation)
        end)
    end
    if C.OnClose then
        C:OnClose(function()
            playCloseAnimation()
        end)
    end
end)

local windowFrame=C and (C.UIElements and C.UIElements.Main or C.Frame or C.Gui or C)
if windowFrame then
    local stroke=Instance.new("UIStroke")
    stroke.Name="GoldStroke"
    stroke.Thickness=2
    stroke.Color=Color3.fromRGB(255,190,0)
    stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    stroke.Parent=windowFrame

    local strokeGradient=Instance.new("UIGradient")
    strokeGradient.Name="DynamicGoldGradient"
    strokeGradient.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,170,0)),
        ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,220,80)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,245,160)),
        ColorSequenceKeypoint.new(0.75,Color3.fromRGB(255,200,20)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,170,0))
    })
    strokeGradient.Rotation=0
    strokeGradient.Parent=stroke

    task.spawn(function()
        while stroke and stroke.Parent do
            for rotation=0,360,2 do
                if not stroke or not stroke.Parent or not strokeGradient or not strokeGradient.Parent then
                    break
                end
                strokeGradient.Rotation=rotation
                task.wait(0.015)
            end
        end
    end)
    task.spawn(function()
        local rotationSpeed=40
        while stroke and stroke.Parent do
            task.wait(0.01)
            strokeGradient.Rotation=(strokeGradient.Rotation+rotationSpeed*0.1)%360
        end
    end)
end


pcall(function()
    local mainFrame = C and (C.UIElements and C.UIElements.Main or C.Frame or C.Gui)
    if not mainFrame then return end

    local function addGlow(name, pos, size, colors, transparency)
        local f = mainFrame:FindFirstChild(name)
        if not f then
            f = Instance.new("Frame")
            f.Name = name
            f.Size = size
            f.Position = pos
            f.BackgroundTransparency = 1
            f.BorderSizePixel = 0
            f.ZIndex = 0
            f.Parent = mainFrame
            local g = Instance.new("UIGradient")
            g.Color = ColorSequence.new(colors)
            g.Transparency = NumberSequence.new(transparency)
            g.Rotation = 90
            g.Parent = f
        end
        return f
    end

    addGlow("GoldTopGlow", UDim2.new(0,0,0,0), UDim2.new(1,0,0.30,0), {
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,180,0)),
        ColorSequenceKeypoint.new(0.45,Color3.fromRGB(255,220,80)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(80,50,0)),
    }, {
        NumberSequenceKeypoint.new(0,0.72),
        NumberSequenceKeypoint.new(0.5,0.86),
        NumberSequenceKeypoint.new(1,1),
    })

    addGlow("GoldBottomGlow", UDim2.new(0,0,0.75,0), UDim2.new(1,0,0.25,0), {
        ColorSequenceKeypoint.new(0,Color3.fromRGB(80,50,0)),
        ColorSequenceKeypoint.new(0.45,Color3.fromRGB(255,210,50)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,170,0)),
    }, {
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.5,0.86),
        NumberSequenceKeypoint.new(1,0.90),
    })

    task.spawn(function()
        repeat task.wait(0.1) until C.OpenButtonMain and C.OpenButtonMain.Button
        local button=C.OpenButtonMain.Button
        local stroke=button:FindFirstChildWhichIsA("UIStroke")
        if not stroke then
            stroke=Instance.new("UIStroke")
            stroke.Thickness=2
            stroke.Parent=button
        end
        local grad=stroke:FindFirstChildWhichIsA("UIGradient")
        if not grad then
            grad=Instance.new("UIGradient")
            grad.Parent=stroke
        end
        grad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(255,170,0)),
            ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,220,80)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,245,160)),
            ColorSequenceKeypoint.new(0.75,Color3.fromRGB(255,200,20)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(255,170,0)),
        })
        game:GetService("RunService").Heartbeat:Connect(function()
            if grad and grad.Parent then
                grad.Rotation=(tick()*50)%360
            end
        end)
    end)
end)

local D=C:Section({Title="功能菜单",Opened=true})



local Z = D:Tab({Title="公告", Icon="bell"})
Z:Paragraph({
    Title = "欢迎使用 奶龙_HUB",
    Desc = "作者：墨水依旧和司空\n墨水快手号:zczczczc766\n司空快手号:smalldesikon111和smalldesikon\n开源并公开的4000+\n没惹你就开源的自动给我30年寿命\n公益脚本禁止倒卖\n认准 奶龙_HUB",
    Image = "rbxassetid://84411268070942",
    ImageSize = 100,
})

local infoPlayer = game.Players.LocalPlayer
Z:Paragraph({
    Title = "信息检测",
    Desc = string.format("用户名: %s\n显示名: %s\n用户ID: %d\n账号年龄: %d天",
        infoPlayer.Name, infoPlayer.DisplayName, infoPlayer.UserId, infoPlayer.AccountAge),
    Image = "info",
    ImageSize = 20,
    Color = Color3.fromRGB(255, 195, 0),
})
Z:Button({Title="复制作者QQ", Callback=function() setclipboard("2047955671") A:SetCore("SendNotification",{Title="已复制", Text="作者QQ：2047955671", Duration=2}) end})
Z:Button({Title="复制作者QQ群", Callback=function() setclipboard("1101093219") A:SetCore("SendNotification",{Title="已复制", Text="作者QQ群：1101093219", Duration=2}) end})
Z:Button({Title="复制作者副群", Callback=function() setclipboard("1063828524") A:SetCore("SendNotification",{Title="已复制", Text="作者副群：1063828524", Duration=2}) end})

local E=D:Tab({Title="通用",Icon="settings"})

local LocalPlayer=game.Players.LocalPlayer
local speedEnabled=false
local jumpEnabled=false
local speedValue=16
local jumpValue=50

E:Toggle({Title="启用修改速度",Value=false,Callback=function(s)
    speedEnabled=s
    local char=LocalPlayer.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            if s then hum.WalkSpeed=speedValue else hum.WalkSpeed=16 end
        end
    end
end})

E:Slider({Title="修改速度",Value={Min=16,Max=100,Default=16},Callback=function(v)
    speedValue=v
    if speedEnabled then
        local char=LocalPlayer.Character
        if char then
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed=v end
        end
    end
end})

E:Toggle({Title="启用修改跳跃高度",Value=false,Callback=function(s)
    jumpEnabled=s
    local char=LocalPlayer.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            if s then hum.JumpPower=jumpValue else hum.JumpPower=50 end
        end
    end
end})

E:Slider({Title="修改跳跃高度",Value={Min=20,Max=200,Default=50},Callback=function(v)
    jumpValue=v
    if jumpEnabled then
        local char=LocalPlayer.Character
        if char then
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower=v end
        end
    end
end})

E:Slider({
    Title = "视野",
    Value = { Min = 60, Max = 120, Default = 70 },
    Step = 1,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end
})

local xrayenabled = false
local xraytransparency = 0.6
local originaltransparencies = {}

E:Toggle({
    Title = "X光",
    Value = false,
    Callback = function(v)
        xrayenabled = v
        if v then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
                    originaltransparencies[obj] = obj.Transparency
                    obj.Transparency = xraytransparency
                end
            end
        else
            for obj, t in pairs(originaltransparencies) do
                if obj and obj.Parent then
                    obj.Transparency = t
                end
            end
            originaltransparencies = {}
        end
    end
})

E:Slider({
    Title = "X光透明度",
    Value = { Min = 0, Max = 100, Default = 60 },
    Step = 1,
    Callback = function(v)
        xraytransparency = v / 100
        if xrayenabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) and originaltransparencies[obj] then
                    obj.Transparency = v / 100
                end
            end
        end
    end
})

E:Button({Title="飞行",Callback=function()loadstring(game:HttpGet("https://raw.githubusercontent.com/zczczczc766/NailongHUB/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%AC.lua"))()end})

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed=speedEnabled and speedValue or 16
        hum.JumpPower=jumpEnabled and jumpValue or 50
    end
end)

local noclipEnabled=false
local function applyNoClip(s)
    local char=game.Players.LocalPlayer.Character
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide=not s
        end
    end
end
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if noclipEnabled then
        task.wait(0.1)
        applyNoClip(true)
    end
end)
E:Toggle({Title="穿墙",Value=false,Callback=function(s)noclipEnabled=s applyNoClip(s)end})

local infJumpEnabled = false
local infJumpConnection = nil

E:Toggle({
    Title = "无限跳",
    Value = false,
    Callback = function(v)
        infJumpEnabled = v
        if v then
            infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:ChangeState("Jumping")
                    end
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

local Lighting=game:GetService("Lighting")
local origBright=Lighting.Brightness
E:Toggle({Title="高亮",Value=false,Callback=function(s)
    if s then
        Lighting.Brightness=5
        Lighting.Ambient=Color3.new(1,1,1)
        Lighting.OutdoorAmbient=Color3.new(1,1,1)
    else
        Lighting.Brightness=origBright        Lighting.Ambient=Color3.new(0.5,0.5,0.5)        Lighting.OutdoorAmbient=Color3.new(0.5,0.5,0.5)
    end
end})

local originallighting = {
    FogEnd = game.Lighting.FogEnd,
    FogStart = game.Lighting.FogStart
}
E:Toggle({
    Title = "无雾",
    Value = false,
    Callback = function(v)
        if v then
            game.Lighting.FogEnd = 100000
            game.Lighting.FogStart = 0
        else
            game.Lighting.FogEnd = originallighting.FogEnd
            game.Lighting.FogStart = originallighting.FogStart
        end
    end
})

local originalGlobalShadows = game.Lighting.GlobalShadows
E:Toggle({
    Title = "删除阴影",
    Value = false,
    Callback = function(v)
        if v then
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.GlobalShadows = originalGlobalShadows
        end
    end
})

local savedBlurStates = {}
local dynamicBlurEnabled = false
local function setDynamicBlurDisabled(disabled)
    dynamicBlurEnabled = disabled
    if disabled then
        savedBlurStates = {}
        for _, obj in ipairs(game.Lighting:GetDescendants()) do
            if obj:IsA("BlurEffect") then
                savedBlurStates[obj] = obj.Enabled
                obj.Enabled = false
            end
        end
    else
        for obj, wasEnabled in pairs(savedBlurStates) do
            if obj and obj.Parent then
                obj.Enabled = wasEnabled
            end
        end
        savedBlurStates = {}
    end
end
E:Toggle({
    Title = "关闭动态检测",
    Value = false,
    Callback = function(v)
        setDynamicBlurDisabled(v)
    end
})

E:Button({
    Title = "防甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"))()
    end
})

E:Button({
    Title="点击传送",
    Callback=function()
        local tool=Instance.new("Tool")
        tool.Name="点击传送"
        tool.RequiresHandle=false
        tool.Parent=LocalPlayer.Backpack
        local activated=false
        tool.Activated:Connect(function()
            if activated then return end
            local mouse=LocalPlayer:GetMouse()
            if not mouse or not mouse.Hit then return end
            local char=LocalPlayer.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            activated=true
            hrp.CFrame=CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
            tool:Destroy()
        end)
    end
})

local antiFallEnabled=false
local antiFallConnection=nil
local antiFallVelocity=nil

local function stopAntiFall()
    if antiFallConnection then
        antiFallConnection:Disconnect()
        antiFallConnection=nil
    end
    if antiFallVelocity then
        pcall(function() antiFallVelocity:Destroy() end)
        antiFallVelocity=nil
    end
end

local function startAntiFall()
    stopAntiFall()
    local char=LocalPlayer.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    antiFallVelocity=Instance.new("BodyVelocity")
    antiFallVelocity.Name="AntiFall"
    antiFallVelocity.MaxForce=Vector3.new(0,math.huge,0)
    antiFallVelocity.Velocity=Vector3.new(0,0,0)
    antiFallVelocity.Parent=hrp

    antiFallConnection=game:GetService("RunService").Heartbeat:Connect(function()
        if not antiFallEnabled then return end
        if not hrp or not hrp.Parent then return end
        if hrp.Position.Y < -50 then
            hrp.CFrame=CFrame.new(hrp.Position.X,100,hrp.Position.Z)
        end
    end)
end

E:Toggle({
    Title="防止摔落伤害",
    Value=false,
    Callback=function(v)
        antiFallEnabled=v
        if v then
            startAntiFall()
        else
            stopAntiFall()
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    if antiFallEnabled then
        task.wait(0.15)
        startAntiFall()
    end
end)

E:Button({Title = "祖国人",Callback = function()loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/homelander-by-GioBolqv1-/main/homelander.lua"))()end})

E:Button({Title="无敌少侠飞行",Callback=function()loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()end})

E:Button({Title="无敌少侠大全",Callback=function()loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/invincible-characters-animations-by-GioBolqv1-/refs/heads/main/universal.lua"))()end})

local function forceChatVisible()
    local player=game.Players.LocalPlayer
    local StarterGui=game:GetService("StarterGui")
    local CoreGui=game:GetService("CoreGui")
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true)
    local chatFrame=player.PlayerGui:FindFirstChild("Chat")
    if not chatFrame then chatFrame=CoreGui:FindFirstChild("Chat") end
    if chatFrame and chatFrame:IsA("Frame") then
        chatFrame.Visible=true
        chatFrame.Position=UDim2.new(0,0,0.5,0)
        chatFrame.Size=UDim2.new(0.3,0,0.4,0)
        chatFrame.BackgroundTransparency=0.5
        local function forceVisible(obj)
            if obj:IsA("Frame") or obj:IsA("ScrollingFrame") or obj:IsA("TextBox") or obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                obj.Visible=true
                obj.Position=UDim2.new(0,0,0,0)
                obj.Size=UDim2.new(1,0,1,0)
                obj.BackgroundTransparency=0.3
                obj.TextTransparency=0
                obj.TextColor3=Color3.new(1,1,1)
            end
            for _,child in ipairs(obj:GetChildren()) do forceVisible(child) end
        end
        forceVisible(chatFrame)
    end
    local textChat=game:GetService("TextChatService")
    if textChat then
        pcall(function()
            textChat.ChatWindowConfiguration.Enabled=true
            textChat.ChatInputBarConfiguration.Enabled=true
        end)
        local chatWindows=CoreGui:FindFirstChild("ChatWindow")
        if chatWindows then chatWindows.Visible=true end
    end
end

E:Button({Title="强制显示聊天框",Callback=function()forceChatVisible()end})

E:Button({Title="走路撞人",Callback=function()loadstring(game:HttpGet(('https://raw.githubusercontent.com/0Ben1/fe/main/obf_5wpM7bBcOPspmX7lQ3m75SrYNWqxZ858ai3tJdEAId6jSI05IOUB224FQ0VSAswH.lua.txt'),true))()end})

E:Button({Title="铁拳打人",Callback=function()loadstring(game:HttpGet(('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'),true))()end})

E:Button({
    Title="重进服务器",
    Callback=function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)
    end
})

E:Button({
    Title="离开服务器",
    Callback=function()
        game:Shutdown()
    end
})

local P = D:Tab({Title="透视", Icon="eye"})

local espEnabled = false
local outlineEnabled = false
local tracersEnabled = false
local espconfig = {
    espcolor = Color3.fromRGB(255, 255, 255),
    outlinecolor = Color3.fromRGB(255, 255, 255),
    outlinefillcolor = Color3.fromRGB(255, 255, 255),
    tracercolor = Color3.fromRGB(255, 255, 255),
    espsize = 16,
    tracersize = 2,
    outlinetransparency = 0,
    outlinefilltransparency = 1,
    rainbowesp = false,
    rainbowoutline = false,
    rainbowtracers = false,
    rainbowspeed = 5,
    tracerposition = "Bottom",
    teamcheck = false,
    teamcolor = Color3.fromRGB(255, 0, 0)
}
local rainbowhue = 0
local lastupdate = 0
local espobjects = {}
local playerconnections = {}
local tracerlines = {}
local activehighlights = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function getrainbowcolor()
    local currenttime = tick()
    local speedmultiplier = 11 - espconfig.rainbowspeed
    local increment = 0.001 * speedmultiplier
    if currenttime - lastupdate >= 0.1 then
        rainbowhue = (rainbowhue + increment) % 1
        lastupdate = currenttime
    end
    return Color3.fromHSV(rainbowhue, 1, 1)
end

local function getESPColor(player, normalColor, rainbowEnabled)
    if espconfig.teamcheck and player and player:IsA("Player") and player ~= LocalPlayer then
        if player.Team ~= LocalPlayer.Team then
            return espconfig.teamcolor
        end
    end
    return rainbowEnabled and getrainbowcolor() or normalColor
end

local function getPlayerWeapon(player)
    if not player.Character then return "无" end
    local tool = player.Character:FindFirstChildWhichIsA("Tool")
    if tool then return tool.Name end
    return "无"
end

local function createesp(player)
    if player == LocalPlayer or espobjects[player] then return end
    local nametext = Drawing.new("Text")
    nametext.Size = espconfig.espsize
    nametext.Center = true
    nametext.Outline = true
    nametext.Color = espconfig.espcolor
    nametext.Font = 2
    nametext.Visible = false
    espobjects[player] = { Name = nametext }
end

local function removeesp(player)
    if espobjects[player] then
        espobjects[player].Name:Remove()
        espobjects[player] = nil
    end
end

local function applyhighlighttocharacter(player, character)
    if not character then return end
    local userid = player.UserId
    if activehighlights[userid] then
        activehighlights[userid]:Destroy()
        activehighlights[userid] = nil
    end
    local highlighter = Instance.new("Highlight")
    highlighter.FillTransparency = espconfig.outlinefilltransparency
    highlighter.OutlineTransparency = espconfig.outlinetransparency
    highlighter.OutlineColor = getESPColor(player, espconfig.outlinecolor, espconfig.rainbowoutline)
    highlighter.FillColor = getESPColor(player, espconfig.outlinefillcolor, espconfig.rainbowoutline)
    highlighter.Adornee = character
    highlighter.Parent = character
    activehighlights[userid] = highlighter
end

local function removehighlight(player)
    local userid = player.UserId
    if activehighlights[userid] then
        activehighlights[userid]:Destroy()
        activehighlights[userid] = nil
    end
    if playerconnections[userid] then
        for _, conn in pairs(playerconnections[userid]) do
            if conn then conn:Disconnect() end
        end
        playerconnections[userid] = nil
    end
end

local function setupplayerhighlight(player)
    local userid = player.UserId
    playerconnections[userid] = playerconnections[userid] or {}
    local function oncharacteradded(character)
        if not character then return end
        task.spawn(function()
            local humanoid = character:WaitForChild("Humanoid", 5)
            if not humanoid then return end
            if outlineEnabled then
                applyhighlighttocharacter(player, character)
            end
            table.insert(playerconnections[userid], player:GetPropertyChangedSignal("TeamColor"):Connect(function()
                local highlight = activehighlights[userid]
                if highlight then
                    highlight.OutlineColor = getESPColor(player, espconfig.outlinecolor, espconfig.rainbowoutline)
                    highlight.FillColor = getESPColor(player, espconfig.outlinefillcolor, espconfig.rainbowoutline)
                end
            end))
            table.insert(playerconnections[userid], humanoid.Died:Connect(function()
                removehighlight(player)
            end))
        end)
    end
    local charaddedconn = player.CharacterAdded:Connect(oncharacteradded)
    table.insert(playerconnections[userid], charaddedconn)
    if player.Character then oncharacteradded(player.Character) end
end

local function updateesp()
    for player, esp in pairs(espobjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            local color = getESPColor(player, espconfig.espcolor, espconfig.rainbowesp)
            esp.Name.Color = color
            esp.Name.Size = espconfig.espsize
            if onscreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                local weapon = getPlayerWeapon(player)
                esp.Name.Position = Vector2.new(pos.X, pos.Y - 20)
                esp.Name.Text = player.Name .. " | " .. math.floor(distance) .. " 米 | " .. weapon
                esp.Name.Visible = true
            else
                esp.Name.Visible = false
            end
        else
            esp.Name.Visible = false
        end
    end
    if outlineEnabled then
        for userid, h in pairs(activehighlights) do
            if h then
                local targetPlayer = Players:GetPlayerByUserId(userid)
                if targetPlayer then
                    h.OutlineColor = getESPColor(targetPlayer, espconfig.outlinecolor, espconfig.rainbowoutline)
                    h.FillColor = getESPColor(targetPlayer, espconfig.outlinefillcolor, espconfig.rainbowoutline)
                end
            end
        end
    end
end

local function createtracers()
    tracerlines = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local line = Drawing.new("Line")
            line.Thickness = espconfig.tracersize
            line.Transparency = 1
            line.Visible = false
            tracerlines[player] = line
        end
    end
end

local function updatetracers()
    local screenHeight = Camera.ViewportSize.Y
    local fromY
    if espconfig.tracerposition == "Bottom" then fromY = screenHeight
    elseif espconfig.tracerposition == "Middle" then fromY = screenHeight / 2
    elseif espconfig.tracerposition == "Up" then fromY = 0 end
    for player, line in pairs(tracerlines) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local screenpos, onscreen = Camera:WorldToViewportPoint(root.Position)
            local color = getESPColor(player, espconfig.tracercolor, espconfig.rainbowtracers)
            if onscreen then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, fromY)
                line.To = Vector2.new(screenpos.X, screenpos.Y)
                line.Color = color
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        if espEnabled then createesp(p) end
        if outlineEnabled then
            playerconnections[p.UserId] = {}
            setupplayerhighlight(p)
        end
        if tracersEnabled then
            local line = Drawing.new("Line")
            line.Thickness = espconfig.tracersize
            line.Transparency = 1
            line.Visible = false
            tracerlines[p] = line
        end
        p.CharacterAdded:Connect(function(c)
            if espEnabled then
                task.wait(0.1)
                if not espobjects[p] then createesp(p) end
            end
            if outlineEnabled then
                task.wait(0.1)
                applyhighlighttocharacter(p, c)
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    removeesp(p)
    removehighlight(p)
    if tracerlines[p] then
        tracerlines[p]:Remove()
        tracerlines[p] = nil
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function(c)
            if espEnabled then
                task.wait(0.1)
                if not espobjects[p] then createesp(p) end
            end
            if outlineEnabled then
                task.wait(0.1)
                applyhighlighttocharacter(p, c)
            end
        end)
    end
end

local espGroup = P:Section({ Title = "基础透视", Opened = true })
espGroup:Toggle({
    Title = "透视",
    Value = false,
    Callback = function(v)
        espEnabled = v
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then createesp(p) end
            end
            RunService:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, updateesp)
        else
            for p, _ in pairs(espobjects) do removeesp(p) end
            RunService:UnbindFromRenderStep("ESPUpdate")
        end
    end
})

local npcEspEnabled = false
local npcHighlights = {}
local npcAddedConn = nil
local npcRemovingConn = nil

local function isNPCModel(obj)
    if not obj or not obj:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(obj) then return false end
    local hum = obj:FindFirstChildOfClass("Humanoid")
    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
    return hum ~= nil and root ~= nil
end

local function addNPCESP(obj)
    if not npcEspEnabled or not isNPCModel(obj) or npcHighlights[obj] then return end
    local h = Instance.new("Highlight")
    h.Name = "奶龙_HUB_NPC_ESP"
    h.Adornee = obj
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillTransparency = 0.75
    h.OutlineTransparency = 0
    h.FillColor = Color3.fromRGB(255, 170, 0)
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.Parent = obj
    npcHighlights[obj] = h
end

local function removeNPCESP(obj)
    local h = npcHighlights[obj]
    if h then
        pcall(function() h:Destroy() end)
        npcHighlights[obj] = nil
    end
end

local function clearNPCESP()
    for obj, h in pairs(npcHighlights) do
        if h then pcall(function() h:Destroy() end) end
        npcHighlights[obj] = nil
    end
end

local function setNPCESP(state)
    npcEspEnabled = state
    if npcAddedConn then npcAddedConn:Disconnect(); npcAddedConn = nil end
    if npcRemovingConn then npcRemovingConn:Disconnect(); npcRemovingConn = nil end

    clearNPCESP()
    if not state then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPCModel(obj) then
            addNPCESP(obj)
        end
    end

    npcAddedConn = workspace.DescendantAdded:Connect(function(obj)
        if not npcEspEnabled then return end
        task.defer(function()
            if obj and obj.Parent then
                if isNPCModel(obj) then
                    addNPCESP(obj)
                elseif obj:IsA("Humanoid") and obj.Parent and obj.Parent:IsA("Model") then
                    addNPCESP(obj.Parent)
                end
            end
        end)
    end)

    npcRemovingConn = workspace.DescendantRemoving:Connect(function(obj)
        if npcHighlights[obj] then
            npcHighlights[obj] = nil
        end
    end)
end

espGroup:Toggle({
    Title = "透视NPC",
    Value = false,
    Callback = function(v)
        setNPCESP(v)
    end
})

espGroup:Toggle({
    Title = "队伍检测",
    Value = false,
    Callback = function(v)
        espconfig.teamcheck = v
    end
})
espGroup:Colorpicker({
    Title = "敌对队伍颜色",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(v)
        espconfig.teamcolor = v
    end
})

espGroup:Colorpicker({
    Title = "透视颜色",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v) espconfig.espcolor = v end
})
espGroup:Toggle({
    Title = "轮廓",
    Value = false,
    Callback = function(v)
        outlineEnabled = v
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    if not playerconnections[p.UserId] then
                        playerconnections[p.UserId] = {}
                    end
                    if p.Character then
                        applyhighlighttocharacter(p, p.Character)
                    end
                    setupplayerhighlight(p)
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                removehighlight(p)
            end
        end
    end
})
espGroup:Colorpicker({
    Title = "轮廓颜色",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v)
        espconfig.outlinecolor = v
        if outlineEnabled and not espconfig.rainbowoutline then
            for _, h in pairs(activehighlights) do
                if h then
                    h.OutlineColor = v
                end
            end
        end
    end
})
espGroup:Colorpicker({
    Title = "填充颜色",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v) espconfig.outlinefillcolor = v end
})
espGroup:Toggle({
    Title = "追踪线",
    Value = false,
    Callback = function(v)
        tracersEnabled = v
        if v then
            createtracers()
            RunService:BindToRenderStep("Tracers", Enum.RenderPriority.Camera.Value + 1, updatetracers)
        else
            RunService:UnbindFromRenderStep("Tracers")
            for _, line in pairs(tracerlines) do line:Remove() end
            tracerlines = {}
        end
    end
})
espGroup:Colorpicker({
    Title = "追踪线颜色",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(v) espconfig.tracercolor = v end
})

local configGroup = P:Section({ Title = "高级配置", Opened = false })
configGroup:Toggle({
    Title = "彩虹透视",
    Value = false,
    Callback = function(v) espconfig.rainbowesp = v end
})
configGroup:Toggle({
    Title = "彩虹轮廓",
    Value = false,
    Callback = function(v) espconfig.rainbowoutline = v end
})
configGroup:Toggle({
    Title = "彩虹追踪线",
    Value = false,
    Callback = function(v) espconfig.rainbowtracers = v end
})
configGroup:Slider({
    Title = "透视大小",
    Value = { Min = 16, Max = 48, Default = 16 },
    Step = 1,
    Callback = function(v) espconfig.espsize = v end
})
configGroup:Dropdown({
    Title = "追踪线位置",
    Values = { "底部", "中间", "顶部" },
    Value = "底部",
    Callback = function(v) espconfig.tracerposition = v end
})
configGroup:Slider({
    Title = "轮廓透明度",
    Value = { Min = 0, Max = 100, Default = 0 },
    Step = 1,
    Callback = function(v) espconfig.outlinetransparency = v / 100 end
})
configGroup:Slider({
    Title = "轮廓填充透明度",
    Value = { Min = 0, Max = 100, Default = 50 },
    Step = 1,
    Callback = function(v) espconfig.outlinefilltransparency = v / 100 end
})
configGroup:Slider({
    Title = "彩虹速度",
    Value = { Min = 1, Max = 10, Default = 5 },
    Step = 1,
    Callback = function(v) espconfig.rainbowspeed = v end
})

local AimTab = D:Tab({Title="自瞄", Icon="crosshair"})

local AimbotSettings = {
    Enabled = false,
    TargetPart = "Head",
    TeamCheck = false,
    WallCheck = false,
    CircleEnabled = false,
    CircleRadius = 100,
    CircleThickness = 2,
    CircleColor = "彩色"
}

local Colors = {
    ["红"] = Color3.fromRGB(255,0,0), ["橙"] = Color3.fromRGB(255,150,0), ["黄"] = Color3.fromRGB(255,255,15),
    ["绿"] = Color3.fromRGB(0,255,0), ["青"] = Color3.fromRGB(0,255,219), ["蓝"] = Color3.fromRGB(0,0,255),
    ["紫"] = Color3.fromRGB(183,0,255), ["彩色"] = nil,
}

local Circle = Drawing.new("Circle")
Circle.Filled = false
Circle.Visible = false

local function getCircleColor()
    if AimbotSettings.CircleColor ~= "彩色" and Colors[AimbotSettings.CircleColor] then
        return Colors[AimbotSettings.CircleColor]
    else
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotSettings.CircleEnabled then
        Circle.Visible = true
        Circle.Position = workspace.CurrentCamera.ViewportSize / 2
        Circle.Radius = AimbotSettings.CircleRadius
        Circle.Thickness = AimbotSettings.CircleThickness
        Circle.Color = getCircleColor()
    else
        Circle.Visible = false
    end
end)

local LocalPlayer = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function isValidTarget(player)
    if not player or player == LocalPlayer then return false end
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team then return false end
    local part = player.Character:FindFirstChild(AimbotSettings.TargetPart)
    if not part then return false end
    if AimbotSettings.WallCheck then
        local origin = Camera.CFrame.Position
        local dir = part.Position - origin
        local dist = dir.Magnitude
        if dist < 0.001 then return true end
        dir = dir.Unit * dist

        local params = RaycastParams.new()
        local ignore = { LocalPlayer.Character, player.Character }
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                ignore[#ignore + 1] = plr.Character
            end
        end
        params.FilterDescendantsInstances = ignore
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.IgnoreWater = true

        local result = workspace:Raycast(origin, dir, params)
        if result then
            local hit = result.Instance
            if hit and hit ~= part and not hit:IsDescendantOf(player.Character) then
                return false
            end
        end
    end
    return true
end

local function getClosestInCircle()
    local closest = nil
    local minDist = math.huge
    local center = Camera.ViewportSize / 2
    for _, p in pairs(game.Players:GetPlayers()) do
        if isValidTarget(p) then
            local head = p.Character:FindFirstChild(AimbotSettings.TargetPart)
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if screenDist <= AimbotSettings.CircleRadius and screenDist < minDist then
                        minDist = screenDist
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

game:GetService("RunService").Heartbeat:Connect(function()
    if AimbotSettings.Enabled then
        local target = getClosestInCircle()
        if target then
            local part = target.Character:FindFirstChild(AimbotSettings.TargetPart)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)

AimTab:Toggle({ Title = "开启自瞄", Value = false, Callback = function(s) AimbotSettings.Enabled = s end })
AimTab:Toggle({ Title = "自瞄圆圈", Value = false, Callback = function(s) AimbotSettings.CircleEnabled = s end })
AimTab:Dropdown({ Title = "瞄准部位", Values = { "Head", "HumanoidRootPart" }, Value = "Head", Callback = function(v) AimbotSettings.TargetPart = v end })
AimTab:Toggle({ Title = "队伍验证", Value = false, Callback = function(s) AimbotSettings.TeamCheck = s end })
AimTab:Toggle({ Title = "墙体检测", Value = false, Callback = function(s) AimbotSettings.WallCheck = s end })
AimTab:Slider({ Title = "圆圈大小", Value = { Min = 30, Max = 500, Default = 100 }, Callback = function(v) AimbotSettings.CircleRadius = v end })
AimTab:Slider({ Title = "圆圈厚度", Value = { Min = 1, Max = 10, Default = 2 }, Callback = function(v) AimbotSettings.CircleThickness = v end })
AimTab:Dropdown({ Title = "圆圈颜色", Values = { "红", "橙", "黄", "绿", "青", "蓝", "紫", "彩色" }, Value = "彩色", Callback = function(v) AimbotSettings.CircleColor = v end })

local bulletTrackEnabled = false
local bulletTrackConnection = nil
local originalProps = {}
local bulletTrackSize = 13

local function applyBulletTrack(state)
    if state then
        if bulletTrackConnection then bulletTrackConnection:Disconnect() end
        bulletTrackConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not bulletTrackEnabled then return end
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local char = plr.Character
                    if not originalProps[plr] then
                        originalProps[plr] = {}
                        local parts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}
                        for _, name in pairs(parts) do
                            local part = char:FindFirstChild(name)
                            if part then
                                originalProps[plr][name] = {
                                    CanCollide = part.CanCollide,
                                    Transparency = part.Transparency,
                                    Size = part.Size,
                                    ShowCollision = part.ShowCollision
                                }
                            end
                        end
                    end
                    for _, name in pairs({"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}) do
                        local part = char:FindFirstChild(name)
                        if part then
                            part.CanCollide = false
                            part.Transparency = 0.9
                            part.Size = Vector3.new(bulletTrackSize, bulletTrackSize, bulletTrackSize)
                            part.ShowCollision = false
                        end
                    end
                end
            end
        end)
    else
        if bulletTrackConnection then
            bulletTrackConnection:Disconnect()
            bulletTrackConnection = nil
        end
        for plr, props in pairs(originalProps) do
            if plr.Character then
                for name, prop in pairs(props) do
                    local part = plr.Character:FindFirstChild(name)
                    if part then
                        part.CanCollide = prop.CanCollide
                        part.Transparency = prop.Transparency
                        part.Size = prop.Size
                        part.ShowCollision = prop.ShowCollision
                    end
                end
            end
            originalProps[plr] = nil
        end
    end
end

AimTab:Toggle({
    Title = "碰撞箱扩展",
    Value = false,
    Callback = function(s)
        bulletTrackEnabled = s
        applyBulletTrack(s)
    end
})

AimTab:Slider({
    Title = "碰撞箱大小",
    Value = { Min = 5, Max = 100, Default = 13 },
    Step = 1,
    Callback = function(v)
        bulletTrackSize = v
        if bulletTrackEnabled then
            applyBulletTrack(false)
            task.wait(0.05)
            applyBulletTrack(true)
        end
    end
})

local TransTab=D:Tab({Title="传送",Icon="send"})

local selectedPlayer=nil

local function getPlayerNames()
    local names={}
    for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p~=game.Players.LocalPlayer then
            table.insert(names,p.Name)
        end
    end
    if #names==0 then
        table.insert(names,"无其他玩家")
    end
    return names
end

local playerDropdown=TransTab:Dropdown({Title="选择玩家",Values=getPlayerNames(),Value="无其他玩家",Callback=function(v)selectedPlayer=v end})

TransTab:Button({Title="刷新列表",Callback=function()
    local newNames=getPlayerNames()
    playerDropdown:SetValues(newNames)
    if #newNames>0 then selectedPlayer=newNames[1] end
    A:SetCore("SendNotification",{Title="已刷新",Text="玩家列表已更新",Duration=2})
end})

TransTab:Button({Title="传送",Callback=function()
    if not selectedPlayer or selectedPlayer=="无其他玩家" then
        A:SetCore("SendNotification",{Title="错误",Text="请先选择一名玩家",Duration=2})
        return
    end
    local target=game:GetService("Players"):FindFirstChild(selectedPlayer)
    if not target or not target.Character then
        A:SetCore("SendNotification",{Title="错误",Text="目标玩家不存在或没有角色",Duration=2})
              A:SetCore("SendNotification",{Title="错误",Text="目标玩家不存在或没有角色",Duration=2})
        return
    end
    local targetRoot=target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        A:SetCore("SendNotification",{Title="错误",Text="目标玩家没有HumanoidRootPart",Duration=2})
        return
    end
    local localChar=game.Players.LocalPlayer.Character
    if not localChar then
        A:SetCore("SendNotification",{Title="错误",Text="你没有角色",Duration=2})
        return
    end
    local localRoot=localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then
        A:SetCore("SendNotification",{Title="错误",Text="你没有HumanoidRootPart",Duration=2})
        return
    end
    localRoot.CFrame=targetRoot.CFrame*CFrame.new(0,0,3)
    A:SetCore("SendNotification",{Title="传送成功",Text="已传送到 "..selectedPlayer.." 旁边",Duration=2})
end})

local MusicTab = D:Tab({Title="音乐播放器", Icon="music"})

local currentSound = nil
local currentVolume = 0.5
local currentSpeed = 1
local musicId = ""

MusicTab:Input({
    Title = "音乐ID",
    Placeholder = "请输入音乐ID",
    Callback = function(text)
        musicId = text
    end
})

MusicTab:Input({
    Title = "音量",
    Placeholder = "请输入数字",
    Callback = function(text)
        local val = tonumber(text)
        if val then
            val = math.clamp(val, 0, 10000000000)
            currentVolume = val
            if currentSound then
                currentSound.Volume = currentVolume
            end
        end
    end
})

MusicTab:Input({
    Title = "速度",
    Placeholder = "请输入数字",
    Callback = function(text)
        local val = tonumber(text)
        if val then
            val = math.clamp(val, 0.01, 2)
            currentSpeed = val
            if currentSound then
                currentSound.PlaybackSpeed = currentSpeed
            end
        end
    end
})

MusicTab:Button({
    Title = "播放音乐",
    Callback = function()
        if musicId == "" then
            A:SetCore("SendNotification",{Title="提示", Text="请先输入音乐ID", Duration=2})
            return
        end
        if currentSound then
            currentSound:Destroy()
            currentSound = nil
        end
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. musicId
        sound.Volume = currentVolume
        sound.PlaybackSpeed = currentSpeed
        sound.Looped = true   
        sound.Parent = game.Players.LocalPlayer.Character or workspace
        sound:Play()
        currentSound = sound
        A:SetCore("SendNotification",{Title="播放中", Text="音乐ID: " .. musicId .. "（循环播放）", Duration=2})
    end
})

MusicTab:Button({
    Title = "停止音乐",
    Callback = function()
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
            currentSound = nil
            A:SetCore("SendNotification",{Title="已停止", Text="音乐已停止", Duration=2})
        else
            A:SetCore("SendNotification",{Title="提示", Text="当前没有正在播放的音乐", Duration=2})
        end
    end
})

local BeautifyTab = D:Tab({Title="美化", Icon="sparkles"})

BeautifyTab:Button({
    Title = "加载美化菜单",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zczczczc766/NailongHUB/refs/heads/main/%E7%BE%8E%E5%8C%96.lua"))()
    end
})

local L = D:Tab({Title="FE", Icon="zap"})
L:Button({Title="coolgui", Callback=function() loadstring(game:GetObjects("rbxassetid://8127297852")[1].Source)() end})
L:Button({Title="被遗弃人物", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CyberNinja103/brodwa/refs/heads/main/ForsakationHub"))() end})
L:Button({Title="R15下蹲", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Azizanzz0/Scripts/refs/heads/main/Crouching.txt"))() end})
L:Button({Title="爬行", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_vZDX8j5ggfAf58QhdJ59BVEmF6nmZgq4Mcjt2l8wn16CiStIW2P6EkNc605qv9K4.lua.txt"))() end})
L:Button({Title="免费动作", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))() end})
L:Button({Title="假延迟", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RENZXW/RENZXW-SCRIPTS/main/fakeLAGRENZXW.txt"))() end})
L:Button({Title="假VR(仅自然灾害)", Callback=function() loadstring(game:HttpGet("https://pastefy.app/MvKHpycG/raw"))() end})
L:Button({Title="冲刺", Callback=function() loadstring(game:HttpGet("https://pastefy.app/ZhKVgCK3/raw"))() end})
L:Button({Title="NPC控制", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty13.lua"))() end})
L:Button({Title="击杀NPC", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/GUI-Offical/FileTest/refs/heads/main/Grab%20R6.txt", true))() end})
L:Button({Title="更改动画包+动作", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))() end})
L:Button({Title="更改动画包", Callback=function() loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/PwFrcMysMOIJuWAQ/raw"))() end})

local M=D:Tab({Title="漏洞",Icon="bug"})
M:Button({Title="AC6音乐播放器",Callback=function()loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Ac6-Music-Vulnerability-25536"))()end})
M:Button({Title="后门执行器1",Callback=function()loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-LALOL-hub-without-hint-19587"))()end})
M:Button({Title="后门执行器2",Callback=function()loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Starlight-Scanner-213808"))()end})
M:Button({Title="UnethicalNetworks f3x gui v9",Callback=function()loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-UnethicalNetworks-f3x-gui-v9-124640"))()end})
M:Button({Title="UnethicalNetworks f3x gui v6 v7 v8",Callback=function()loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-UnethicalNetworks-f3x-gui-v6v7v8-121690"))()end})

local N=D:Tab({Title="末日砖块",Icon="target"})
local O=D:Tab({Title="被遗弃",Icon="ghost"})

O:Button({
    Title = "加载角色/皮肤修改器",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zczczczc766/NailongHUB/refs/heads/main/%E8%A2%AB%E9%81%97%E5%BC%83%E8%A7%92%E8%89%B2or%E7%9A%AE%E8%82%A4%E5%88%87%E6%8D%A2%E5%99%A8.lua"))()
    end
})

O:Toggle({Title="改视野",Value=false,Callback=function()
    local player=game.Players.LocalPlayer
    local remote=game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    local fovObject=player:WaitForChild("PlayerData"):WaitForChild("Settings"):WaitForChild("Game"):WaitForChild("FieldOfView")
    local bytes=string.char(0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x5E,0x40)
    remote:FireServer("UpdateSettings",{fovObject,buffer.fromstring(bytes)})
end})

local guestBlockEnabled=false
local guestBlockThread=nil

O:Toggle({Title="访客格挡",Value=false,Callback=function(s)
    guestBlockEnabled=s
    if s then
        if guestBlockThread then task.cancel(guestBlockThread) end
        guestBlockThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while guestBlockEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,5,0,0,0,66,108,111,99,107})})
                task.wait(0.01)
            end
        end)
    else
        if guestBlockThread then task.cancel(guestBlockThread) guestBlockThread=nil end
    end
end})

local guestChargeEnabled=false
local guestChargeThread=nil

O:Toggle({Title="访客大运",Value=false,Callback=function(s)
    guestChargeEnabled=s
    if s then
        if guestChargeThread then task.cancel(guestChargeThread) end
        guestChargeThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while guestChargeEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,6,0,0,0,67,104,97,114,103,101})})
                task.wait(0.01)
            end
        end)
    else
        if guestChargeThread then task.cancel(guestChargeThread) guestChargeThread=nil end
    end
end})

local shedletskySlashEnabled=false
local shedletskySlashThread=nil

O:Toggle({Title="谢德大运",Value=false,Callback=function(s)
    shedletskySlashEnabled=s
    if s then
        if shedletskySlashThread then task.cancel(shedletskySlashThread) end
        shedletskySlashThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while shedletskySlashEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,5,0,0,0,83,108,97,115,104})})
                task.wait(0.01)
            end
        end)
    else
        if shedletskySlashThread then task.cancel(shedletskySlashThread) shedletskySlashThread=nil end
    end
end})

local pizzaThrowEnabled=false
local pizzaThrowThread=nil

O:Toggle({Title="披萨投喂",Value=false,Callback=function(s)
    pizzaThrowEnabled=s
    if s then
        if pizzaThrowThread then task.cancel(pizzaThrowThread) end
        pizzaThrowThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while pizzaThrowEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,10,0,0,0,84,104,114,111,119,80,105,122,122,97})})
                task.wait(0.01)
            end
        end)
    else
        if pizzaThrowThread then task.cancel(pizzaThrowThread) pizzaThrowThread=nil end
    end
end})

local noobDestructionEnabled=false
local noobDestructionThread=nil

O:Toggle({Title="noob破坏世界",Value=false,Callback=function(s)
    noobDestructionEnabled=s
    if s then
        if noobDestructionThread then task.cancel(noobDestructionThread) end
        noobDestructionThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while noobDestructionEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,8,0,0,0,84,105,109,101,115,116,111,112})})
                task.wait(0.01)
            end
        end)
    else
        if noobDestructionThread then task.cancel(noobDestructionThread) noobDestructionThread=nil end
    end
end})

local clone007Enabled=false
local clone007Thread=nil

O:Toggle({Title="007分身",Value=false,Callback=function(s)    clone007Enabled=s
    if s then
        if clone007Thread then task.cancel(clone007Thread) end
        clone007Thread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while clone007Enabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,5,0,0,0,67,108,111,110,101})})
                task.wait(0.01)
            end
        end)
    else
        if clone007Thread then task.cancel(clone007Thread) clone007Thread=nil end
    end
end})

local taphMineEnabled=false
local taphMineThread=nil

O:Toggle({Title="塔夫放雷",Value=false,Callback=function(s)
    taphMineEnabled=s
    if s then
        if taphMineThread then task.cancel(taphMineThread) end
        taphMineThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while taphMineEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,16,0,0,0,83,117,98,115,112,97,99,101,84,114,105,112,109,105,110,101})})
                task.wait(0.01)
            end
        end)
    else
        if taphMineThread then task.cancel(taphMineThread) taphMineThread=nil end
    end
end})

local flashbangEnabled=false
local flashbangThread=nil

O:Toggle({Title="闪光弹",Value=false,Callback=function(s)
    flashbangEnabled=s
    if s then
        if flashbangThread then task.cancel(flashbangThread) end
        flashbangThread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while flashbangEnabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,9,0,0,0,70,108,97,115,104,98,97,110,103})})
                task.wait(0.01)
            end
        end)
    else
        if flashbangThread then task.cancel(flashbangThread) flashbangThread=nil end
    end
end})

local guest666Enabled=false
local guest666Thread=nil

O:Toggle({Title="访客666大运",Value=false,Callback=function(s)
    guest666Enabled=s
    if s then
        if guest666Thread then task.cancel(guest666Thread) end
        guest666Thread=task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent
            while guest666Enabled do
                Event:FireServer("UseActorAbility",{(function(bytes)local b=buffer.create(#bytes)for i=1,#bytes do buffer.writeu8(b,i-1,bytes[i])end return b end)({3,14,0,0,0,68,101,109,111,110,105,99,80,117,114,115,117,105,116})})
                task.wait(0.01)
            end
        end)
    else
        if guest666Thread then task.cancel(guest666Thread) guest666Thread=nil end
    end
end})

local FlashTab = D:Tab({Title="闪光", Icon="sparkles"})

FlashTab:Section({ Title = "角色增强" })

local noVelocityEnabled = false
local noVelocityConnection = nil
FlashTab:Toggle({
    Title = "无流速",
    Value = false,
    Callback = function(v)
        noVelocityEnabled = v
        if v then
            noVelocityConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        else
            if noVelocityConnection then noVelocityConnection:Disconnect(); noVelocityConnection = nil end
        end
    end
})

local bunnyHopEnabled = false
local bunnyHopDelay = 1
local bunnyHopConnection = nil
FlashTab:Toggle({
    Title = "兔子跳",
    Value = false,
    Callback = function(v)
        bunnyHopEnabled = v
        if v then
            bunnyHopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if not char or not char:FindFirstChild("Humanoid") then return end
                local humanoid = char.Humanoid
                if humanoid:GetState() == Enum.HumanoidStateType.Running and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(bunnyHopDelay)
                end
            end)
        else
            if bunnyHopConnection then bunnyHopConnection:Disconnect(); bunnyHopConnection = nil end
        end
    end
})
FlashTab:Slider({
    Title = "兔子跳延迟",
    Value = { Min = 0, Max = 5, Default = 1 },
    Step = 0.1,
    Callback = function(v) bunnyHopDelay = v end
})

FlashTab:Divider()

local autoRespawnEnabled = false
local autoRespawnDelay = 0
local autoRespawnLastFire = 0
FlashTab:Toggle({
    Title = "自动重生",
    Value = false,
    Callback = function(v)
        autoRespawnEnabled = v
        if v then
            task.spawn(function()
                while autoRespawnEnabled do
                    if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name) then
                        if tick() - autoRespawnLastFire >= 1 then
                            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                            if remotes and remotes:FindFirstChild("Command") then
                                remotes.Command:FireServer("Play")
                            end
                            autoRespawnLastFire = tick()
                        end
                    end
                    task.wait(autoRespawnDelay)
                end
            end)
        end
    end
})
FlashTab:Slider({
    Title = "重生延迟",
    Value = { Min = 0, Max = 3, Default = 0 },
    Step = 0.1,
    Callback = function(v) autoRespawnDelay = v end
})

FlashTab:Section({ Title = "游戏功能" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
FlashTab:Button({
    Title = "返回大厅",
    Callback = function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("Command") then
            remotes.Command:FireServer("Lobby")
        end
    end
})
FlashTab:Button({
    Title = "开始游戏",
    Callback = function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("Command") then
            remotes.Command:FireServer("Play")
        end
    end
})

FlashTab:Section({ Title = "近战刀具" })

local knifeCloseEnabled = false
local knifeRange = 10
local showKnifeRange = false
local knifeRangeColor = Color3.fromRGB(255,255,255)
local knifeRangeTransparency = 0.5
local rangeSphere = nil
local knifeConnection = nil
local lastKnifeState = nil
local SwapWeapon = nil

task.spawn(function()
    local signalEvents = ReplicatedStorage:FindFirstChild("SignalManager")
    if signalEvents then
        signalEvents = signalEvents:FindFirstChild("SignalEvents")
        if signalEvents then
            SwapWeapon = signalEvents:FindFirstChild("SwapWeapon")
        end
    end
end)

local function updateKnifeRangeSphere()
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        if rangeSphere then rangeSphere.Transparency = 1 end
        return
    end
    local root = player.Character.HumanoidRootPart
    if showKnifeRange then
        if not rangeSphere then
            rangeSphere = Instance.new("Part")
            rangeSphere.Name = "KnifeRangeSphere"
            rangeSphere.Shape = Enum.PartType.Ball
            rangeSphere.Material = Enum.Material.ForceField
            rangeSphere.CanCollide = false
            rangeSphere.Anchored = true
            rangeSphere.CastShadow = false
            rangeSphere.Parent = game.Workspace
        end
        rangeSphere.Size = Vector3.new(knifeRange*2, knifeRange*2, knifeRange*2)
        rangeSphere.CFrame = root.CFrame
        rangeSphere.Color = knifeRangeColor
        rangeSphere.Transparency = knifeRangeTransparency
    else
        if rangeSphere then rangeSphere:Destroy(); rangeSphere = nil end
    end
end
game:GetService("RunService").RenderStepped:Connect(updateKnifeRangeSphere)

local function anyEnemyInRange()
    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist <= knifeRange then return true end
        end
    end
    return false
end

local function toggleKnifeSwitch()
    if knifeCloseEnabled then
        knifeConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not knifeCloseEnabled then return end
            local inRange = anyEnemyInRange()
            if lastKnifeState == nil or lastKnifeState ~= inRange then
                if SwapWeapon then SwapWeapon:Fire() end
                lastKnifeState = inRange
            end
        end)
    else
        if knifeConnection then knifeConnection:Disconnect(); knifeConnection = nil end
        lastKnifeState = nil
    end
end

FlashTab:Toggle({
    Title = "近战切换刀具",
    Value = false,
    Callback = function(v) knifeCloseEnabled = v; toggleKnifeSwitch() end
})
FlashTab:Slider({
    Title = "刀具范围",
    Value = { Min = 1, Max = 50, Default = 10 },
    Step = 1,
    Callback = function(v) knifeRange = v; updateKnifeRangeSphere() end
})
FlashTab:Toggle({
    Title = "显示刀具范围",
    Value = false,
    Callback = function(v) showKnifeRange = v; updateKnifeRangeSphere() end
})
FlashTab:Colorpicker({
    Title = "范围颜色",
    Default = Color3.fromRGB(255,255,255),
    Transparency = 0.5,
    Callback = function(v, t) knifeRangeColor = v; knifeRangeTransparency = t or 0.5; updateKnifeRangeSphere() end
})

FlashTab:Section({ Title = "开箱" })

local knifeCrateCount = 0
local gunCrateCount = 0
local isOpeningCrates = false
local RollCrate = nil
task.spawn(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then RollCrate = remotes:FindFirstChild("RollCrate") end
end)

local function openKnifeCrates()
    if isOpeningCrates then return end
    isOpeningCrates = true
    for i = 1, knifeCrateCount do
        if RollCrate then RollCrate:FireServer("KnifeCrate") end
        task.wait(0.1)
    end
    isOpeningCrates = false
end
local function openGunCrates()
    if isOpeningCrates then return end
    isOpeningCrates = true
    for i = 1, gunCrateCount do
        if RollCrate then RollCrate:FireServer("GunCrate") end
        task.wait(0.1)
    end
    isOpeningCrates = false
end

FlashTab:Button({
    Title = "批量开刀具箱",
    Callback = openKnifeCrates
})
FlashTab:Slider({
    Title = "刀具箱数量",
    Value = { Min = 0, Max = 25, Default = 0 },
    Step = 1,
    Callback = function(v) knifeCrateCount = math.floor(v) end
})
FlashTab:Button({
    Title = "批量开枪箱",
    Callback = openGunCrates
})
FlashTab:Slider({
    Title = "枪箱数量",
    Value = { Min = 0, Max = 15, Default = 0 },
    Step = 1,
    Callback = function(v) gunCrateCount = math.floor(v) end
})

FlashTab:Section({ Title = "弹道" })

local bulletTrailsEnabled = false
local bulletMissColor = Color3.new(1,0,0)
local bulletHitColor = Color3.new(0,1,0)
local tracers = {}
local TRACER_LIFETIME = 1.5
local TRACER_THICKNESS = 0.06
local BALL_SIZE = 6
local OUTLINE_THICKNESS = 2
local FADE_TIME = 1.2
local HIT_RANGE = 3

local function fadeBeam(part)
    local t = 0
    while t < TRACER_LIFETIME do
        t = t + game:GetService("RunService").RenderStepped:Wait()
        part.Transparency = t / TRACER_LIFETIME
    end
    part:Destroy()
end

local function drawTracerSegment(startPos, endPos)
    if not bulletTrailsEnabled then return end
    local beam = Instance.new("Part")
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = bulletMissColor
    beam.Size = Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, (startPos - endPos).Magnitude)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0,0,-beam.Size.Z/2)
    beam.Transparency = 0
    beam.Parent = game.Workspace
    table.insert(tracers, beam)
    task.spawn(function() fadeBeam(beam) end)
end

local function colorNearestTracer(gibPosition)
    if not bulletTrailsEnabled then return end
    local nearest = nil
    local nearestDist = math.huge
    for _, tracer in ipairs(tracers) do
        if tracer.Parent then
            local dist = (tracer.Position - gibPosition).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = tracer
            end
        end
    end
    if nearest then nearest.Color = bulletHitColor end
end

local function hitPlayer(position)
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    if (part.Position - position).Magnitude <= HIT_RANGE then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function makeImpactBall(part)
    if not bulletTrailsEnabled then return end
    local pos = part.Position
    local green = hitPlayer(pos)
    local outlineColor = green and bulletHitColor or bulletMissColor
    local innerColor = green and bulletHitColor or bulletMissColor
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.fromOffset(BALL_SIZE*2, BALL_SIZE*2)
    billboard.AlwaysOnTop = false
    billboard.LightInfluence = 0
    billboard.Parent = part
    local outline = Instance.new("ImageLabel")
    outline.Size = UDim2.fromScale(1,1)
    outline.BackgroundTransparency = 1
    outline.Image = "rbxassetid://1316045217"
    outline.ImageColor3 = outlineColor
    outline.ImageTransparency = 0
    outline.Parent = billboard
    local inner = Instance.new("ImageLabel")
    inner.Size = UDim2.fromOffset(billboard.Size.X.Offset - OUTLINE_THICKNESS*2, billboard.Size.Y.Offset - OUTLINE_THICKNESS*2)
    inner.Position = UDim2.fromOffset(OUTLINE_THICKNESS, OUTLINE_THICKNESS)
    inner.BackgroundTransparency = 1
    inner.Image = "rbxassetid://1316045217"
    inner.ImageColor3 = innerColor
    inner.ImageTransparency = 0
    inner.Parent = billboard
    task.spawn(function()
        local t = 0
        while t < FADE_TIME do
            t = t + game:GetService("RunService").RenderStepped:Wait()
            local alpha = t / FADE_TIME
            outline.ImageTransparency = alpha
            inner.ImageTransparency = alpha
        end
        billboard:Destroy()
    end)
end

local bulletStorage = game.Workspace:FindFirstChild("bulletStorage") or Instance.new("Folder", game.Workspace)
if bulletStorage.Name ~= "bulletStorage" then bulletStorage.Name = "bulletStorage" end
local hitEffectFolder = game.Workspace:FindFirstChild("HitEffect") or Instance.new("Folder", game.Workspace)
if hitEffectFolder.Name ~= "HitEffect" then hitEffectFolder.Name = "HitEffect" end

bulletStorage.ChildAdded:Connect(function(bullet)
    if not bulletTrailsEnabled then return end
    if not bullet:IsA("BasePart") then return end
    local lastPos = bullet.Position
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if bullet and bullet.Parent then
            local newPos = bullet.Position
            drawTracerSegment(lastPos, newPos)
            lastPos = newPos
        else
            conn:Disconnect()
        end
    end)
end)

hitEffectFolder.ChildAdded:Connect(function(obj)
    if not bulletTrailsEnabled then return end
    if obj:IsA("BasePart") then
        if obj.Name == "Gib_T" then colorNearestTracer(obj.Position) end
        if obj.Name == "Gib_G" then makeImpactBall(obj) end
    end
end)

FlashTab:Toggle({
    Title = "显示弹道",
    Value = false,
    Callback = function(v) bulletTrailsEnabled = v end
})
FlashTab:Colorpicker({
    Title = "未击中颜色",
    Default = Color3.new(1,0,0),
    Callback = function(v) bulletMissColor = v end
})
FlashTab:Colorpicker({
    Title = "击中颜色",
    Default = Color3.new(0,1,0),
    Callback = function(v) bulletHitColor = v end
})
   
local BackstreetTab = D:Tab({Title="后街生存", Icon="map"})

local lastPosition = nil
local function teleportTo(pos)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    lastPosition = hrp.Position
    hrp.CFrame = CFrame.new(pos)
end

BackstreetTab:Section({ Title = "自动功能" })

local toolLoopEnabled = false
local toolLoopConnection = nil
local function startToolLoop()
    if toolLoopConnection then return end
    local RS = game:GetService("ReplicatedStorage")
    local ToolEvent = RS:WaitForChild("Events"):WaitForChild("ToolEvent")
    toolLoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not toolLoopEnabled then return end
        ToolEvent:FireServer("Activated", false)
        task.wait(0.5)
        if not toolLoopEnabled then return end
        ToolEvent:FireServer("Activated", true)
        task.wait(0.5)
    end)
end
local function stopToolLoop()
    toolLoopEnabled = false
    if toolLoopConnection then toolLoopConnection:Disconnect(); toolLoopConnection = nil end
end

BackstreetTab:Toggle({
    Title = "启用自动挖掘",
    Value = false,
    Callback = function(state)
        toolLoopEnabled = state
        if state then startToolLoop() else stopToolLoop() end
    end
})

local stickPickupEnabled = false
local stickPickupConnection = nil
local function startStickPickup()
    if stickPickupConnection then return end
    stickPickupConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not stickPickupEnabled then return end
        local player = game.Players.LocalPlayer
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return end
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:sub(1,5):lower() == "stick" then
                local char = player.Character or workspace:FindFirstChild(player.Name)
                if char then item.Parent = char end
                break
            end
        end
    end)
end
local function stopStickPickup()
    stickPickupEnabled = false
    if stickPickupConnection then stickPickupConnection:Disconnect(); stickPickupConnection = nil end
end

BackstreetTab:Toggle({
    Title = "自动拿起木棍",
    Value = false,
    Callback = function(state)
        stickPickupEnabled = state
        if state then startStickPickup() else stopStickPickup() end
    end
})

BackstreetTab:Section({ Title = "传送" })

BackstreetTab:Button({ Title = "传送到垃圾大师", Callback = function() teleportTo(Vector3.new(-173.27, 3.50, 47.06)) end })
BackstreetTab:Button({ Title = "传送回原位置", Callback = function()
    if not lastPosition then return end
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(lastPosition)
end })

BackstreetTab:Section({ Title = "地点传送" })

BackstreetTab:Button({ Title = "传送到豆子工厂", Callback = function() teleportTo(Vector3.new(-269.05, 3.50, 155.16)) end })
BackstreetTab:Button({ Title = "传送到后街", Callback = function() teleportTo(Vector3.new(-196.88, 3.50, 63.44)) end })
BackstreetTab:Button({ Title = "传送到后街对面", Callback = function() teleportTo(Vector3.new(-184.26, 4.00, -189.72)) end })
BackstreetTab:Button({ Title = "传送到下水道", Callback = function() teleportTo(Vector3.new(-245.42, -22.96, -1349.19)) end })

local NicoTab = D:Tab({Title="nico的下一个机器人", Icon="cpu"})

local bunnyHopEnabled = false
local bunnyHopConnection = nil

NicoTab:Toggle({
    Title = "自动跳跃",
    Value = false,
    Callback = function(v)
        bunnyHopEnabled = v
        if v then
            bunnyHopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not bunnyHopEnabled then return end
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                local humanoid = char:FindFirstChild("Humanoid")
                if not humanoid then return end
                if humanoid:GetState() == Enum.HumanoidStateType.Running and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if bunnyHopConnection then
                bunnyHopConnection:Disconnect()
                bunnyHopConnection = nil
            end
        end
    end
})

local PowerLegendTab = D:Tab({Title="力量传奇", Icon="dumbbell"})

PowerLegendTab:Button({
    Title = "传送到出生点",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(72.74, 3.71, 141.13)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到出生点", Duration=2})
    end
})

PowerLegendTab:Section({ Title = "传送到健身房" })

PowerLegendTab:Button({
    Title = "传送到力量之王健身房",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-8624.00, 13.57, -5871.08)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到力量之王健身房", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到传奇健身房",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-8678.00, 3.15, 2348.04)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到传奇健身房", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到永恒健身房",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(4630.12, 987.90, -3893.76)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到永恒健身房", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到神话健身房",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-6769.98, 3.72, -1287.33)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到神话健身房", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到冰霜健身房",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-2823.86, 3.72, -248.66)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到冰霜健身房", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到小岛",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-32.20, 7.03, 1860.85)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到小岛", Duration=2})
    end
})

PowerLegendTab:Section({ Title = "传送到竞技场" })

PowerLegendTab:Button({
    Title = "传送到熔岩竞技场观战台",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(4460.67, 99.97, -8454.09)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到熔岩竞技场观战台", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到熔岩竞技场内部",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(4421.18, 13.17, -8789.72)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到熔岩竞技场内部", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到拳击擂台观战台",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-1972.65, 99.97, -6010.31)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到拳击擂台观战台", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到拳击擂台内部",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(-1925.47, 13.57, -6337.44)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到拳击擂台内部", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到沙漠擂台观战台",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(938.67, 99.97, -7044.35)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到沙漠擂台观战台", Duration=2})
    end
})

PowerLegendTab:Button({
    Title = "传送到沙漠擂台内部",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if not char then
            A:SetCore("SendNotification",{Title="错误", Text="角色不存在", Duration=2})
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            A:SetCore("SendNotification",{Title="错误", Text="找不到 HumanoidRootPart", Duration=2})
            return
        end
        hrp.CFrame = CFrame.new(736.07, 10.20, -7665.00)
        A:SetCore("SendNotification",{Title="传送成功", Text="已传送到沙漠擂台内部", Duration=2})
    end
})

local FractureTab = D:Tab({Title="骨折模拟器", Icon="bone"})

local function updateStat(...)
    local args = {...}
    pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("Functions")
            :WaitForChild("UpdateStat")
            :InvokeServer(unpack(args))
    end)
end

local STATS = {
    "elasticitylevel",
    "frictionlevel",
    "cooldownlevel",
    "fuellevel",
    "jumplevel",
    "speedlevel",
    "breakslevel",
    "sprainslevel",
    "flightlevel",
    "dislocationslevel",
}

FractureTab:Section({ Title = "属性升级" })

FractureTab:Button({
    Title = "全部属性拉满 x10",
    Callback = function()
        for i = 1, 10 do
            for _, stat in ipairs(STATS) do
                updateStat(stat, 100)
            end
        end
        A:SetCore("SendNotification",{Title="完成", Text="所有属性已设为100", Duration=3})
    end
})

FractureTab:Section({ Title = "单独属性开关" })

for _, stat in ipairs(STATS) do
    local displayName = stat:gsub("^%l", string.upper):gsub("level", "")
    FractureTab:Toggle({
        Title = displayName,
        Value = false,
        Callback = function(state)
            updateStat(stat, state and 100 or 0)
        end
    })
end

FractureTab:Section({ Title = "经济" })

FractureTab:Button({
    Title = "设置金钱 15e14",
    Callback = function()
        updateStat("money", 15e14)
        A:SetCore("SendNotification",{Title="金钱", Text="已设置 money = 15e14", Duration=3})
    end
})

FractureTab:Section({ Title = "Gravity Bubble" })

FractureTab:Toggle({
    Title = "Gravity Bubble 启用",
    Value = false,
    Callback = function(state)
        updateStat("Gravity Bubble", 5, true)
        updateStat("utility", "Gravity Bubble", true)
        A:SetCore("SendNotification",{Title="Gravity Bubble", Text=state and "已启用" or "已禁用", Duration=3})
    end
})

FractureTab:Section({ Title = "传送" })

FractureTab:Button({
    Title = "重新传送到本服",
    Callback = function()
        A:SetCore("SendNotification",{Title="传送中...", Text="即将传送", Duration=2})
        task.wait(0.5)
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end
})

FractureTab:Section({ Title = "一键全部执行" })

FractureTab:Button({
    Title = "执行全部功能",
    Callback = function()
        for i = 1, 10 do
            for _, stat in ipairs(STATS) do
                updateStat(stat, 100)
            end
        end
        updateStat("money", 15e14)
        updateStat("Gravity Bubble", 5, true)
        updateStat("utility", "Gravity Bubble", true)
        task.wait(0.5)
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
        A:SetCore("SendNotification",{Title="完成", Text="全部执行完毕", Duration=3})
    end
})

local CatTab = D:Tab({ Title = "猫入侵者", Icon = "cat" })

local weaponCDEnabled = false
local weaponCDThread = nil

CatTab:Toggle({
    Title = "武器无CD",
    Value = false,
    Callback = function(state)
        if state then
            weaponCDEnabled = true
            _G.StopWeaponCD = false
            weaponCDThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer

                local Weapons = require(ReplicatedStorage.Modules.Storage.Weapons)
                for _, weapon in pairs(Weapons) do
                    if type(weapon) == "table" then
                        weapon.Cooldown = 0
                    end
                end

                local oldGetServerTimeNow = workspace.GetServerTimeNow
                workspace.GetServerTimeNow = function(self, ...)
                    return oldGetServerTimeNow(self, ...) + 999999
                end

                local CooldownEvent = ReplicatedStorage.Events.Cooldown
                for _, conn in ipairs(getconnections(CooldownEvent.Event)) do
                    conn:Disable()
                end

                local WeaponEvent = ReplicatedStorage.Events.WeaponEvent
                _G.WeaponFiring = false

                function startRapidFire()
                    if _G.WeaponFiring then return end
                    _G.WeaponFiring = true
                    task.spawn(function()
                        while _G.WeaponFiring and not _G.StopWeaponCD do
                            local cam = workspace.CurrentCamera
                            local mouse = LocalPlayer:GetMouse()
                            local ray = cam:ViewportPointToRay(mouse.X, mouse.Y)
                            WeaponEvent:FireServer(ray.Direction.Unit, true)
                            task.wait(0.01)
                        end
                        _G.WeaponFiring = false
                    end)
                end

                function stopRapidFire()
                    _G.WeaponFiring = false
                end

                startRapidFire()

                task.spawn(function()
                    while not _G.StopWeaponCD do
                        local char = LocalPlayer.Character
                        if char then
                            for _, tool in ipairs(char:GetChildren()) do
                                if tool:IsA("Tool") then
                                    tool:SetAttribute("LastActivation", 0)
                                    tool:SetAttribute("LastUse", 0)
                                end
                            end
                        end
                        local backpack = LocalPlayer:FindFirstChild("Backpack")
                        if backpack then
                            for _, tool in ipairs(backpack:GetChildren()) do
                                if tool:IsA("Tool") then
                                    tool:SetAttribute("LastActivation", 0)
                                    tool:SetAttribute("LastUse", 0)
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)

                task.spawn(function()
                    while not _G.StopWeaponCD do
                        LocalPlayer:SetAttribute("GlobalHealCooldownEnd", 0)
                        LocalPlayer:SetAttribute("MedicMedkitReadyAt", 0)
                        task.wait(0.1)
                    end
                end)

                while not _G.StopWeaponCD do
                    task.wait(1)
                end
            end)
        else
            weaponCDEnabled = false
            _G.StopWeaponCD = true
            if weaponCDThread then
                task.cancel(weaponCDThread)
                weaponCDThread = nil
            end
            if _G.WeaponFiring then
                _G.WeaponFiring = false
            end
        end
    end
})

local CleanTab = D:Tab({Title="清洁键帽", Icon="sparkles"})

local scrubEnabled = false
local scrubThread = nil
CleanTab:Toggle({
    Title = "快速擦键帽",
    Value = false,
    Callback = function(s)
        if s then
            scrubEnabled = true
            _G.StopScrub = false
            scrubThread = task.spawn(function()
                local RS = game:GetService("ReplicatedStorage")
                local remote = RS:WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent")
                local args = {{{Action = "Scrub"}, "\a"}}
                local multiplier = 99
                while not _G.StopScrub do
                    for i = 1, multiplier do
                        remote:FireServer(unpack(args))
                    end
                    task.wait(0.01)
                end
            end)
        else
            _G.StopScrub = true
            if scrubThread then task.cancel(scrubThread); scrubThread = nil end
        end
    end
})

local spongeEnabled = false
local spongeThread = nil
CleanTab:Toggle({
    Title = "重复拿起海绵",
    Value = false,
    Callback = function(s)
        if s then
            spongeEnabled = true
            _G.StopSponge = false
            spongeThread = task.spawn(function()
                local plr = game.Players.LocalPlayer
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hum = char:WaitForChild("Humanoid")
                while not _G.StopSponge do
                    local sponge = plr.Backpack:FindFirstChild("Sponge") or char:FindFirstChild("Sponge")
                    if sponge then
                        pcall(function()
                            hum:EquipTool(sponge)
                        end)
                    end
                    task.wait(0.01)
                end
            end)
        else
            _G.StopSponge = true
            if spongeThread then task.cancel(spongeThread); spongeThread = nil end
        end
    end
})

local HitTab = D:Tab({Title="击打动作", Icon="zap"})

local hitEnabled = false
local hitThread = nil

HitTab:Toggle({
    Title = "击飞所有人",
    Value = false,
    Callback = function(s)
        if s then
            hitEnabled = true
            _G.StopHit = false
            hitThread = task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                while not _G.StopHit do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local char = player.Character
                            if char then
                                local root = char:FindFirstChild("HumanoidRootPart")
                                if root then
                                    pcall(function()
                                        root.Velocity = Vector3.new(0, 150, 0)
                                    end)
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            _G.StopHit = true
            if hitThread then
                task.cancel(hitThread)
                hitThread = nil
            end
        end
    end
})

local BlockWarTab = D:Tab({Title="方块战争", Icon="pickaxe"})

local mineEnabled = false
local mineThread = nil
local originalMineSeconds = nil
local originalBreakSeconds = nil
local originalBreakSecondsForHP = nil
local originalBrickHPForBought = nil

BlockWarTab:Toggle({
    Title = "稿子秒挖",
    Value = false,
    Callback = function(s)
        if s then
            mineEnabled = true
            _G.StopMine = false
            mineThread = task.spawn(function()
                local RS = game:GetService("ReplicatedStorage")
                while not _G.StopMine do
                    pcall(function()
                        local MineDefs = require(RS.Modules.Configs.MineDefs)
                        if MineDefs and MineDefs.MineSeconds then
                            if not originalMineSeconds then
                                originalMineSeconds = MineDefs.MineSeconds
                            end
                            MineDefs.MineSeconds = function() return 0 end
                        end
                    end)
                    pcall(function()
                        local BBC = require(RS.Modules.Configs.BlockBreakConfig)
                        if BBC.BreakSeconds then
                            if not originalBreakSeconds then
                                originalBreakSeconds = BBC.BreakSeconds
                            end
                            BBC.BreakSeconds = function() return 0 end
                        end
                        if BBC.BreakSecondsForHP then
                            if not originalBreakSecondsForHP then
                                originalBreakSecondsForHP = BBC.BreakSecondsForHP
                            end
                            BBC.BreakSecondsForHP = function() return 0 end
                        end
                    end)
                    pcall(function()
                        local GUC = require(RS.Modules.Configs.GeneratorUpgradeConfig)
                        if GUC and GUC.BrickHPForBought then
                            if not originalBrickHPForBought then
                                originalBrickHPForBought = GUC.BrickHPForBought
                            end
                            GUC.BrickHPForBought = function() return 0 end
                        end
                    end)
                    task.wait(1)
                end
            end)
        else
            _G.StopMine = true
            if mineThread then task.cancel(mineThread); mineThread = nil end
            pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                local MineDefs = require(RS.Modules.Configs.MineDefs)
                if MineDefs and originalMineSeconds then
                    MineDefs.MineSeconds = originalMineSeconds
                end
                local BBC = require(RS.Modules.Configs.BlockBreakConfig)
                if BBC and originalBreakSeconds then
                    BBC.BreakSeconds = originalBreakSeconds
                end
                if BBC and originalBreakSecondsForHP then
                    BBC.BreakSecondsForHP = originalBreakSecondsForHP
                end
                local GUC = require(RS.Modules.Configs.GeneratorUpgradeConfig)
                if GUC and originalBrickHPForBought then
                    GUC.BrickHPForBought = originalBrickHPForBought
                end
            end)
            originalMineSeconds = nil
            originalBreakSeconds = nil
            originalBreakSecondsForHP = nil
            originalBrickHPForBought = nil
        end
    end
})

local weaponEnabled = false
local weaponThread = nil
local weaponConnections = {}
local originalWeaponData = {}

BlockWarTab:Toggle({
    Title = "近战武器无CD",
    Value = false,
    Callback = function(s)
        if s then
            weaponEnabled = true
            _G.StopWeapon = false
            weaponThread = task.spawn(function()
                local RS = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")
                local Run = game:GetService("RunService")
                local LP = Players.LocalPlayer

                pcall(function()
                    local Reg = require(RS.Data.Registries.WeaponRegistry)
                    if Reg and Reg.Entries then
                        for k, v in pairs(Reg.Entries) do
                            if not originalWeaponData[k] then
                                originalWeaponData[k] = {
                                    HitDelay = v.HitDelay,
                                    HitDuration = v.HitDuration,
                                    Cooldown = v.Cooldown,
                                    ComboTimeout = v.ComboTimeout
                                }
                            end
                            v.HitDelay = 0
                            v.HitDuration = 0.05
                            v.Cooldown = 0
                            v.ComboTimeout = 0
                        end
                    end
                end)

                LP:SetAttribute("AttackSpeedMul", 999999)
                local attrConn = LP:GetAttributeChangedSignal("AttackSpeedMul"):Connect(function()
                    if not _G.StopWeapon and LP:GetAttribute("AttackSpeedMul") ~= 999999 then
                        LP:SetAttribute("AttackSpeedMul", 999999)
                    end
                end)
                table.insert(weaponConnections, attrConn)

                LP:SetAttribute("StunEndsAt", 0)
                local stunConn = LP:GetAttributeChangedSignal("StunEndsAt"):Connect(function()
                    if not _G.StopWeapon and (LP:GetAttribute("StunEndsAt") or 0) > workspace:GetServerTimeNow() then
                        LP:SetAttribute("StunEndsAt", 0)
                    end
                end)
                table.insert(weaponConnections, stunConn)

                local heartbeatConn = Run.Heartbeat:Connect(function()
                    if _G.StopWeapon then return end
                    LP:SetAttribute("StunEndsAt", 0)
                    pcall(function()
                        for _, m in ipairs(getloadedmodules and getloadedmodules() or {}) do
                            if m and m.SwingState then
                                m.SwingState.cooldownEndsAt = -1
                                m.SwingState.duration = 0
                            end
                        end
                    end)
                end)
                table.insert(weaponConnections, heartbeatConn)

                local CombatRemotes = RS:WaitForChild("GameEvents"):WaitForChild("CombatRemotes")
                local AtkRemote = CombatRemotes:WaitForChild("Combat_RequestAttack")
                local last = 0

                local atkConn = Run.Heartbeat:Connect(function()
                    if _G.StopWeapon then return end
                    if tick() - last < 0.05 then return end
                    local char = LP.Character
                    local tool = char and char:FindFirstChildWhichIsA("Tool")
                    if tool then
                        local ok, wtype = pcall(function()
                            return require(RS.Data.Registries.WeaponRegistry).GetTypeFromTool(tool)
                        end)
                        if ok and wtype then
                            last = tick()
                            pcall(function()
                                AtkRemote:FireServer(wtype)
                            end)
                        end
                    end
                end)
                table.insert(weaponConnections, atkConn)

                while not _G.StopWeapon do
                    task.wait(1)
                end
            end)
        else
            _G.StopWeapon = true
            if weaponThread then task.cancel(weaponThread); weaponThread = nil end
            for _, conn in ipairs(weaponConnections) do
                pcall(function() conn:Disconnect() end)
            end
            weaponConnections = {}
            pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                local Players = game:GetService("Players")
                local LP = Players.LocalPlayer
                local Reg = require(RS.Data.Registries.WeaponRegistry)
                if Reg and Reg.Entries then
                    for k, v in pairs(Reg.Entries) do
                        if originalWeaponData[k] then
                            v.HitDelay = originalWeaponData[k].HitDelay
                            v.HitDuration = originalWeaponData[k].HitDuration
                            v.Cooldown = originalWeaponData[k].Cooldown
                            v.ComboTimeout = originalWeaponData[k].ComboTimeout
                        end
                    end
                end
                LP:SetAttribute("AttackSpeedMul", 1)
                LP:SetAttribute("StunEndsAt", 0)
            end)
            originalWeaponData = {}
        end
    end
})

local Players=game:GetService("Players")
local player=Players.LocalPlayer
local mouse=player:GetMouse()

local bombState={active=false,thread=nil,fireEvent=nil}
local rocketState={active=false,thread=nil,fireEvent=nil}

local function getBombFire()
    local backpack=player:FindFirstChild("Backpack")
    if not backpack then return nil end
    local timebomb=backpack:FindFirstChild("Timebomb")
    if not timebomb then return nil end
    return timebomb:FindFirstChild("Fire")
end

local function getRocketFire()
    local char=player.Character
    if not char then return nil end
    local launcher=char:FindFirstChild("RocketLauncher")
    if not launcher then return nil end
    return launcher:FindFirstChild("Fire")
end

local function bombLoop()
    local lastRetryTime=0
    while bombState.active do
        local char=player.Character
        if char then
            local rootPart=char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
            if rootPart then
                if not bombState.fireEvent or not bombState.fireEvent.Parent then
                    local now=tick()
                    if now-lastRetryTime>0.2 then
                        lastRetryTime=now
                        bombState.fireEvent=getBombFire()
                    end
                end
                if bombState.fireEvent then
                    bombState.fireEvent:FireServer(rootPart.CFrame)
                end
            end
        end
        task.wait(0.01)
    end
end

local function rocketLoop()
    while rocketState.active do
        if rocketState.fireEvent then
            rocketState.fireEvent:FireServer(mouse.Hit.p)
        end
        task.wait(0.01)
    end
end

N:Toggle({Title="炸弹",Value=false,Callback=function()
    if bombState.active then
        bombState.active=false
        if bombState.thread then
            task.wait(0.02)
            bombState.thread=nil
        end
    end
    bombState.active=true
    bombState.fireEvent=nil
    bombState.thread=task.spawn(bombLoop)
end})

N:Toggle({Title="火箭筒",Value=false,Callback=function(s)
    if s then
        local fire=getRocketFire()
        if not fire then
            warn("火箭筒 Fire 获取失败")
            return
        end
        rocketState.fireEvent=fire
        rocketState.active=true
        rocketState.thread=task.spawn(rocketLoop)
    else
        rocketState.active=false
        if rocketState.thread then
            task.wait(0.02)
            rocketState.thread=nil
        end
        rocketState.fireEvent=nil
    end
end})

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zczczczc766/NailongHUB/refs/heads/main/%E4%BD%9C%E8%80%85%E6%A3%80%E6%B5%8B.lua"))()
    end)
end)

if finishStartup then
    task.spawn(finishStartup)
end

end,function(e)
    if finishStartup then pcall(finishStartup) end
    safeNotify("奶龙_HUB错误",tostring(e):sub(1,100),5)
end)
