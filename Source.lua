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
        error_color = Color3.fromRGB(175, 0, 0),
        slider = {
            hover_color = Color3.fromRGB(32,32,32),
            default_color = Color3.fromRGB(27,27,27),
        }
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not connection then
            local last_position = userinputservice:GetMouseLocation()
            connection = runservice.RenderStepped:Connect(function()
                local current_position = userinputservice:GetMouseLocation()
                local change = (current_position - last_position)
                if change.Magnitude ~= 0 then
                    last_position = current_position
                    local core_position = core.Position + UDim2.fromOffset(change.X, change.Y)
                    tweenservice:Create(core, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Position = core_position}):Play()
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
    for _, v in ipairs(library_holder:GetChildren()) do
        if v.Name == name then
            v:Destroy()
        end
    end

    local gui = assets.Window.GUI:Clone()
    local core = gui.Core
    local main = core.Main
    local topbar = main.Bar
    local menu = main.Menu
    local tablist = menu.Tabs
    local tabholder = main.TabHolder

    gui.Name = name
    topbar.Title.Text = name
    gui.Parent = library_holder
    pcall(make_draggable, topbar, core)

    --# cool seperator

    local current_tab , current_tab_button , tab_debounce = nil, nil , true

    local function change_tab(tab, button, instant)
        if instant then
            current_tab, current_tab_button = tab, button
            for _, v in ipairs(tabholder:GetChildren()) do
                v.Visible = false
                v.GroupTransparency = 1
            end
            for _, v in ipairs(tablist:GetChildren()) do
                v.TextColor3 = theme.tab.button_default
            end
            tab.Visible = true
            tab.GroupTransparency = 0
            button.TextColor3 = theme.tab.button_selected
        elseif tab_debounce then
            local previous_tab, previous_tab_button = current_tab, current_tab_button
            current_tab, current_tab_button = tab, button
            local appear_tween = tweenservice:Create(tab, TweenInfo.new(.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {GroupTransparency = 0})
            if previous_tab then
                tab_debounce = false
                local disappear_tween = tweenservice:Create(previous_tab, TweenInfo.new(.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {GroupTransparency = 1})
                disappear_tween.Completed:Connect(function()
                    previous_tab.Visible = false
                    tab.Visible = true
                    appear_tween:Play()
                    tab_debounce = true
                end)
                tweenservice:Create(previous_tab, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {TextColor3 = theme.tab.button_default}):Play()
                disappear_tween:Play()
            else
                tab.Visible = true
                appear_tween:Play()
            end
            tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {TextColor3 = theme.tab.button_selected}):Play()
        end
    end

    --# nigga cum

    local window_functions = {}

    function window_functions.CreateTab(name)

        --# setup

        local tab = assets.Window.Tab:Clone()
        local element_holder = tab.Main
        local button = assets.Window.TabButton:Clone()
        button.Text = name
        button.Name = name
        tab.Name = name
        if not current_tab then
            change_tab(tab, button, true)
        end
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and current_tab ~= tab then
                change_tab(tab, button)
            end
        end)
        button.Parent = tablist
        tab.Parent = tabholder
        
        --# functions

        local tab_functions = {}

        --# [elements]

        --# section

        function tab_functions.CreateSection(name)
            local section = assets.Elements.Section:Clone()
            section.Name = name
            section.Text = name
            section.Parent = element_holder

            local section_functions = {}

            function section_functions.Destroy()
                section:Destroy()
            end

            return section_functions
        end

        --# button

        --[[
            Settings:

            "Name" = <string>
            "Callback" = <function>
        ]]

        function tab_functions.CreateButton(settings)

            --# setup

            local button = assets.Elements.Button:Clone()
            button.Parent = element_holder
            button.Name = settings.Name
            button.Text = settings.Name

            --# core

            local hovering, clicking, debounce = false, false, true

            --# tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}),
                hover = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}),
                interact = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.interact_color}),
                error = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}),
            }

            local function reset()
                if clicking then
                    tweens.interact:Play()
                elseif hovering then
                    tweens.hover:Play()
                else
                    tweens.default:Play()
                end
            end

            --# callback stufff

            local function attempt_callback()
                local success, message = pcall(settings.Callback)
                if not success then
                    debounce = false
                    button.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    tweens.error:Play()
                    task.wait(2)
                    button.Text = settings.Name
                    reset()
                    debounce = true
                end
                return success
            end

            --# connection callbacks

            local function on_mouse_enter()
                hovering = true
                if debounce then
                    tweens.hover:Play()
                end
            end

            local function on_mouse_leave()
                hovering = false
                if debounce then
                    tweens.default:Play()
                end
                if clicking then
                    clicking = false
                end
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                    clicking = true
                    if debounce then
                        tweens.interact:Play()
                    end
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                    clicking = false
                    if debounce then
                        tweens.hover:Play()
                        attempt_callback()
                    end
                end
            end

            --# connections

            button.MouseEnter:Connect(on_mouse_enter)
            button.MouseLeave:Connect(on_mouse_leave)
            button.InputBegan:Connect(on_input_began)
            button.InputEnded:Connect(on_input_ended)

            --# functions

            local button_functions = {}

            function button_functions.Click()
                task.spawn(attempt_callback)
            end

            function button_functions.Destroy()
                button:Destroy()
            end

            return button_functions
        end

        --# toggle

        --[[
            Settings:

            "Name" = <string>
            "Callback" = <function>
            "StartValue" = <boolean>
        ]]

        function tab_functions.CreateToggle(settings)

            --# setup

            local toggle = assets.Elements.Toggle:Clone()
            local checkbox = toggle.CheckBox

            checkbox.BackgroundTransparency = settings.StartValue and 0 or 1
            toggle.Parent = element_holder
            toggle.Name = settings.Name
            toggle.Text = settings.Name

            --# core

            local hovering, clicking, switch, debounce = false, false, settings.StartValue, true

            --# tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}),
                hover = tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.hover_color}),
                interact = tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.interact_color}),
                error = tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}),
                checkbox = {
                    [true] = tweenservice:Create(checkbox, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}),
                    [false] = tweenservice:Create(checkbox, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}),
                },
            }

            local function reset()
                if clicking then
                    tweens.interact:Play()
                elseif hovering then
                    tweens.hover:Play()
                else
                    tweens.default:Play()
                end
            end

            --# callback stufff

            local function attempt_callback()
                local success, message = pcall(settings.Callback, switch)
                if not success then
                    debounce = false
                    button.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    tweens.error:Play()
                    task.wait(2)
                    button.Text = settings.Name
                    reset()
                    debounce = true
                end
                return success
            end

            local function set_switch(value)
                switch = value
                tweens.checkbox[switch]:Play()
                return attempt_callback()
            end

            --# connection callbacks

            local function on_mouse_enter()
                hovering = true
                if debounce then
                    tweens.hover:Play()
                end
            end

            local function on_mouse_leave()
                hovering = false
                if debounce then
                    tweens.default:Play()
                end
                if clicking then
                    clicking = false
                end
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                    clicking = true
                    if debounce then
                        tweens.interact:Play()
                    end
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                    clicking = false
                    if debounce then
                        tweens.hover:Play()
                        set_switch(not switch)
                    end
                end
            end

            --# connections

            toggle.MouseEnter:Connect(on_mouse_enter)
            toggle.MouseLeave:Connect(on_mouse_leave)
            toggle.InputBegan:Connect(on_input_began)
            toggle.InputEnded:Connect(on_input_ended)

            --# functions

            local toggle_functions = {}

            function toggle_functions.Set(value)
                if debounce then
                    task.spawn(set_switch, value)
                end
            end

            function toggle_functions.Destroy()
                toggle:Destroy()
            end

            return toggle_functions
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

        function tab_functions.CreateSlider(settings)

            --# setup

            local slider = assets.Elements.Slider:Clone()
            local main = slider.Main
            local bar = main.Bar
            local progress_label = main.Progress

            slider.Parent = element_holder
            slider.Name = settings.Name
            slider.Text = settings.Name

            --# core

            local hovering, sliding, progress, range, min_value, max_value, debounce = false, false, settings.StartValue, math.abs(settings.Range[1] - settings.Range[2]), math.min(unpack(settings.Range)), math.max(unpack(settings.Range)), true

            --# tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.default_color}),
                error = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.error_color}),
                slider = {
                    default = tweenservice:Create(main, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.slider.default_color}),
                    hover = tweenservice:Create(main, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundColor3 = theme.element.slider.hover_color}),
                },
            }

            local function reset()
                if hovering then
                    tweens.slider.hover:Play()
                else
                    tweens.slider.default:Play()
                end
            end

            --# callback stufff

            local function attempt_callback()
                local success, message = pcall(settings.Callback)
                if not success then
                    debounce = false
                    button.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    tweens.error:Play()
                    task.wait(2)
                    button.Text = settings.Name
                    tweens.default:Play()
                    debounce = true
                end
                return success
            end

            --# connection callbacks

            local function on_mouse_enter()
                hovering = true
                if debounce then
                    tweens.slider.hover:Play()
                end
            end

            local function on_mouse_leave()
                hovering = false
                if debounce then
                    tweens.slider.default:Play()
                end
                if sliding then
                    sliding = false
                end
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering and debounce and not sliding then
                    sliding = true

                    --# bla bla stuff right now bro?

                    local start_mouse_x = userinputservice:GetMouseLocation().X
                    local last_mouse_x = start_mouse_x

                    local bar_size = (start_mouse_x - main.AbsolutePosition.X - main.AbsoluteSize.X)

                    local ratio = bar_size / main.AbsoluteSize.X
                    local absolute_progress = (ratio * range)

                    

                    local connection; connection = runservice.RenderStepped:Connect(function()
                        if sliding then
                            local current_mouse_x = userinputservice:GetMouseLocation().X
                            local frame_mouse_x_difference = (current_mouse_x - last_mouse_x)
                            if frame_mouse_x_difference ~= 0 then
                                last_mouse_x = current_mouse_x
                                local total_mouse_x_difference = (current_mouse_x - start_mouse_x)
                            end
                        else
                            connection:Disconnect()
                        end
                    end)

                    while sliding and runservice.RenderStepped:Wait() do
                        local current_mouse_x = userinputservice:GetMouseLocation().X
                        local difference = (current_mouse_x - last_mouse_x)
                        if difference ~= 0 then
                            
                        end
                    end
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                    sliding = false
                    if debounce then
                        tweens.hover:Play()
                    end
                end
            end

            --# connections

            button.MouseEnter:Connect(on_mouse_enter)
            button.MouseLeave:Connect(on_mouse_leave)
            button.InputBegan:Connect(on_input_began)
            button.InputEnded:Connect(on_input_ended)

            --# functions

            local button_functions = {}

            function button_functions.Click()
                task.spawn(attempt_callback)
            end

            function button_functions.Destroy()
                button:Destroy()
            end

            return button_functions
        end

        --# destroy

        function tab_functions.Destroy()
            button:Destroy()
            tab:Destroy()
            if current_tab == tab then
                current_tab = nil
                local all_tabs = tabholder:GetChildren()
                local random_tab = all_tabs[math.random(#all_tabs)]
                if random_tab then
                    local random_tab_button = tablist:FindFirstChild(random_tab.Name)
                    if random_tab_button then
                        change_tab(random_tab, random_tab_button, true)
                    end
                end
            end
        end

        return tab_functions
    end

    function window_functions.Destroy()
        gui:Destroy()
    end

    return window_functions
end

--# end of cum

return {}