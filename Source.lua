--# pinky finger with cum innit

local runservice = game:GetService("RunService")
local tweenservice = game:GetService("TweenService")
local userinputservice = game:GetService("UserInputService")
local coregui = game:GetService("CoreGui")

local library_holder = coregui:FindFirstChild("plue-lib")
if not library_holder then
    library_holder = Instance.new("Folder", coregui)
    library_holder.Name = "plue-lib"
end

local assets = game:GetObjects("rbxassetid://12211969190")[1]

--# color of my cum

local theme = {
    element = {
        hover_color = Color3.fromRGB(45, 45, 45),
        default_color = Color3.fromRGB(36, 36, 36),
        interact_color = Color3.fromRGB(125, 125, 125),
        error_color = Color3.fromRGB(175, 0, 0)
    },
    tab = {
        button_default = Color3.fromRGB(150, 150, 150),
        button_selected = Color3.fromRGB(255, 255, 255)
    }
}

--# white ass cum

local function make_draggable(pivot, core)
    local connection
    pivot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local last_position = userinputservice:GetMouseLocation()
            connection = runservice.RenderStepped:Connect(function()
                local change = (userinputservice:GetMouseLocation() - last_position)
                last_position = userinputservice:GetMouseLocation()
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

    for _, v in ipairs(library_holder:GetChildren()) do
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
    gui.Parent = library_holder
    pcall(make_draggable, topbar, core)

    --# nigga cum

    local self = {}

    --# tab

    local current_tab
    local change_tab_debounce = true

    local function change_tab(tab)
        if change_tab_debounce then
            change_tab_debounce = false
            local previous_tab = current_tab
            current_tab = tab
            local appear_tween = tweenservice:Create(tab, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {GroupTransparency = 0})
            appear_tween.Completed:Connect(function()
                change_tab_debounce = true
            end)
            if previous_tab then
                local disappear_tween = tweenservice:Create(previous_tab, TweenInfo.new(.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {GroupTransparency = 1})
                disappear_tween.Completed:Connect(function()
                    previous_tab.Visible = false
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
            --# setup
            local button = assets.Elements.Button:Clone()
            button.Parent = tab
            button.Name = settings.Name
            button.Text = settings.Name
            --# core
            local hovering, debounce = false, true
            button.MouseEnter:Connect(function()
                hovering = true
                if debounce then
                    tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                end
            end)
            button.MouseLeave:Connect(function()
                hovering = false
                if debounce then
                    tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                end
            end)
            button.InputBegan:Connect(function(input)
                if debounce and hovering and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    tweenservice:Create(button, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.interact_color}):Play()
                end
            end)
            button.InputEnded:Connect(function(input)
                if debounce and hovering and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local success, message = pcall(settings.Callback)
                    if not success then
                        debounce = false
                        button.Text = "Callback Error"
                        warn("plue-lib Callback Error:", message)
                        tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}):Play()
                        task.wait(2)
                        button.Text = settings.Name
                        debounce = true
                    end
                    if hovering then
                        tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                    else
                        tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                    end
                end
            end)
            return {
                Destroy = function()
                    button:Destroy()
                end,
                Click = function()
                    local success, message = pcall(settings.Callback)
                    if not success then
                        debounce = false
                        button.Text = "Callback Error"
                        warn("plue-lib Callback Error:", message)
                        tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}):Play()
                        task.wait(2)
                        button.Text = settings.Name
                        debounce = true
                        if hovering then
                            tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                        else
                            tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                        end
                    end
                end
            }
        end

        --# toggle

        --[[
            Settings:

            "Name" = <string>
            "Callback" = <function>
            "StartValue" = <boolean>
        ]]

        function tab_self.CreateToggle(settings)
            --# setup
            local toggle = assets.Elements.Toggle:Clone()
            local checkbox = toggle.CheckBox
            checkbox.BackgroundTransparency = settings.StartValue and 0 or 1
            toggle.Parent = tab
            toggle.Name = settings.Name
            toggle.Text = settings.Name
            --# core
            local hovering, debounce, switch, clicking = false, true, settings.StartValue, false
            toggle.MouseEnter:Connect(function()
                hovering = true
                if debounce then
                    tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                end
            end)
            toggle.MouseLeave:Connect(function()
                hovering = false
                if debounce then
                    tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                end
            end)
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if debounce and hovering then
                        tweenservice:Create(toggle, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.interact_color}):Play()
                    end
                end
            end)

            --# white cum?

            local function call_callback(value)
                local success, message = pcall(settings.Callback, value)
                if success then
                    switch = value
                    if switch then
                        tweenservice:Create(checkbox, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
                    else
                        tweenservice:Create(checkbox, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
                    end
                else
                    debounce = false
                    toggle.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}):Play()
                    task.wait(2)
                    toggle.Text = settings.Name
                    if hovering then
                        tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                    else
                        tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                    end
                    debounce = true
                end
                return success
            end

            toggle.InputEnded:Connect(function(input)
                if debounce and hovering and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local success = call_callback(not switch)
                    if success then
                        if hovering then
                            tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                        else
                            tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                        end
                    end
                end
            end)

            return {
                Destroy = function()
                    toggle:Destroy()
                end,
                Set = function(value)
                    task.defer(function()
                        local success = call_callback(value)
                        if not success then
                        end
                    end)
                end
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
            "Increment" = <number>
        ]]


        function tab_self.CreateSlider(settings)
            --# setup
            local slider = assets.Elements.Slider:Clone()
            local main : Frame = slider.Main
            local bar = main.Bar
            local progress_label = main.Progress
            slider.Parent = tab
            slider.Name = settings.Name
            slider.Text = settings.Name
            --# core
            local hovering, debounce = false, true
            main.MouseEnter:Connect(function()
                hovering = true
                if debounce then
                    tweenservice:Create(main, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                end
            end)
            main.MouseLeave:Connect(function()
                hovering = false
                if debounce then
                    tweenservice:Create(main, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                end
            end)
            local dragging, progress, connection = false, settings.StartValue, nil
            bar.Size = UDim2.new(0, main.Size.X.Offset * (progress / math.abs(settings.Range[2] - settings.Range[1])), 1, 0)
            progress_label.Text = progress .. " " .. settings.Suffix or ""

            --# nigger

            local function call_callback()
                local success, message = pcall(settings.Callback, progress)
                if not success then
                    debounce = false
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end
                    slider.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    tweenservice:Create(slider, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}):Play()
                    task.wait(2)
                    slider.Text = settings.Name
                    debounce = true
                    if hovering then
                        tweenservice:Create(slider, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}):Play()
                    else
                        tweenservice:Create(slider, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}):Play()
                    end
                end
            end

            --# ok cum
            
            main.InputBegan:Connect(function(input)
                if debounce and hovering and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local last_X = userinputservice:GetMouseLocation().X
                    local start = last_X - (main.AbsolutePosition.X - main.AbsoluteSize.X)
                    tweenservice:Create(bar, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Size = UDim2.new(0, start, 1, 0)}):Play()
                    progress = math.min(unpack(settings.Range)) + ((start / main.AbsoluteSize.X) * math.abs(settings.Range[2] - settings.Range[1]))
                    progress_label.Text = progress .. " " .. settings.Suffix or ""

                    --# renderstep connection nigger ass white pinky cum bitchass

                    connection = runservice.RenderStepped:Connect(function()
                        if dragging and hovering then
                            local current_X = userinputservice:GetMouseLocation().X
                            local difference = (current_X - last_X)
                            if difference ~= 0 then
                                local difference_percentage = (difference / main.AbsoluteSize.X)
                                local increment = difference_percentage * (math.abs(settings.Range[2] - settings.Range[1]))
                                if math.abs(increment) >= settings.Increment then
                                    last_X = current_X
                                    progress += increment
                                    tweenservice:Create(bar, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Size = UDim2.new(0, bar.Size.X.Offset + difference, 1, 0)}):Play()
                                    progress_label.Text = progress .. " " .. settings.Suffix or ""
                                    
                                    --# call the callback cummer juicer nigger

                                    call_callback()
                                end
                            end
                        else
                            connection:Disconnect()
                            connection = nil
                        end
                    end)
                end
            end)
            slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            return {
                Destroy = function()
                    slider:Destroy()
                end,
                Set = function(value)
                    progress = value
                    bar.Size = UDim2.new(0, main.Size.X.Offset * (progress / math.abs(settings.Range[2] - settings.Range[1])), 1, 0)
                    progress_label.Text = progress .. " " .. settings.Suffix or ""
                    task.defer(call_callback)
                end
            }
        end

        --# destroy

        function tab_self.Destroy()
            button:Destroy()
            tab:Destroy()
            if current_tab == tab then
                current_tab = nil
                local random_tab = tabholder:GetChildren()[math.random(#tabholder:GetChildren())]
                if random_tab then
                    change_tab(random_tab)
                end
            end
        end

        return tab_self
    end

    return self
end

--# end of cum

return {}