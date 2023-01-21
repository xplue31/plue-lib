local runservice = game:GetService("RunService")
local tweenservice = game:GetService("TweenService")
local userinputservice = game:GetService("UserInputService")
local coregui = game:GetService("CoreGui")

local assets = game:GetObjects("rbxassetid://12211969190")[1]

--#white ass cum

local function make_draggable(pivot, core)
    local connection, start
    pivot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local start = userinputservice:GetMouseLocation()
            connection = runservice.RenderStepped:Connect(function()
                local change = (userinputservice:GetMouseLocation() - start)
                if change.Magnitude ~= 0 then
                    local new_position = core.Position + UDim2.fromOffset(change.X, change.Y)
                    tweenservice:Create(core, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Position = new_position}):Play()
                end
            end)
        end
    end)
    pivot.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and connection then
            connection:Disconnect()
            connection = nil
        end
    end)
end

--# purple cum maybe

local library = {}

--# orange ass cum

function library.CreateWindow(name)
    name = tostring(name) or "plue-lib"

    for _, v in ipairs(coregui:GetChildren()) do
        if v.Name == name then
            v:Destroy()
        end
    end

    local gui = assets.Window.GUI:Clone()
    local core = gui.Main
    local window = core.Window
    local topbar = window.Bar
    local menu = window.Menu
    local tablist = menu.Tabs
    local tabholder = window.TabHolder

    gui.Name = name
    topbar.Title.Text = name
    gui.Parent = coregui
    pcall(make_draggable, topbar, core)

    --# nigga cum

    local self = {}

    --# tab

    local current_tab
    local change_tab_debounce = true

    local function change_tab(tab)
        if change_tab_debounce then
            change_tab_debounce = false
            local appear_tween = tweenservice:Create(tab, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {GroupTransparency = 0})
            appear_tween.Completed:Connect(function()
                current_tab = tab
                change_tab_debounce = true
            end)
            if current_tab then
                local disappear_tween = tweenservice:Create(current_tab, TweenInfo.new(.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {GroupTransparency = 1})
                disappear_tween.Completed:Connect(function()
                    current_tab.Visible = false
                    tab.Visible = true
                    appear_tween:Play()
                end)
                disappear_tween:Play()
            else
                tab.Visible = true
                appear_tween:Play()
            end
        end
    end

    function self.CreateTab(title)

        --# create visual

        local tab = assets.Window.Tab:Clone()
        local button = assets.Window.TabButton:Clone()
        button.Text = title
        button.Name = title
        tab.Name = title
        if not current_tab then
            change_tab(tab)
        end
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                change_tab(tab)
            end
        end)
        button.Parent = tablist
        tab.Parent = tabholder
        
        --# self

        local tab_self = {}

        --# section

        function tab_self.CreateSection(name)
            local section = assets.Elements.Section:Clone()
            section.Name = name
            section.Text = name
            section.Parent = tab
            return {
                Destroy = function()
                    section:Destroy()
                end,
            }
        end

        --# button

        --[[
            Settings:

            "Name" = <string>
            "Callback" = <function>
        ]]

        function tab_self.CreateButton(settings)
            local button = assets.Elements.Button:Clone()
            button.Name = settings.Name
            button.Text = settings.Name
            button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local success = pcall(settings.Callback)
                    if not success then
                        button.Text = "Callback Error"
                        task.wait(2)
                        button.Text = settings.Name
                    end
                end
            end)
            return {
                Destroy = function()
                    button:Destroy()
                end,
            }
        end

        --# slider

        --[[
            Settings:

            "Name" = <string>
            "StartValue" = <number>
            "Range" = <array>, {min, max}
            "Suffix" = <string>
            "Callback" = <function>
        ]]

        function tab_self.CreateSlider(setttings)
            
        end
        
    end

    return self
end

--# end of cum

return {}