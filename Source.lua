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

--# white ass cum

local function make_draggable(pivot, core)
    pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		pivot.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				MousePos = Input.Position
				FramePos = core.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		pivot.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		userinputservice.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				tweenservice:Create(core, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
			end
		end)
	end)
end

--# purple cum maybe

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

--# bruh

local library = {}

--# orange ass cum

function library.CreateWindow(name)

    --# clear stuff

    for _, v in ipairs(library_holder:GetChildren()) do
        if v.Name == name then
            v:Destroy()
        end
    end

    --# setup stuff

    local gui = assets.Window.GUI:Clone()
    local core = gui.Core
    local main = core.Main

    local topbar = main.Bar
    local settings_button = topbar.Stuff.SettingsButton
    local close_button = topbar.Stuff.CloseButton

    local tabholder = main.TabHolder

    local menu = main.Menu
    local tablist = menu.Tabs

    --# other shit

    gui.Name = name
    gui.Parent = library_holder

    topbar.Stuff.Title.Text = name

    pcall(make_draggable, topbar, core)

    --# general buttons [TODO]

    --# cool seperator

    local current_tab , current_tab_button

    local function change_tab(tab, button)
        local previous_tab, previous_tab_button = current_tab, current_tab_button
        current_tab, current_tab_button = tab, button
        if previous_tab then
            previous_tab.Visible = false
        end
        if previous_tab_button then
            tweenservice:Create(previous_tab_button, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextColor3 = theme.tab.button_default}):Play()
        end
        current_tab.Visible = true
        tweenservice:Create(current_tab_button, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextColor3 = theme.tab.button_selected}):Play()
    end

    --# nigga cum

    local window_functions = {}

    function window_functions.CreateTab(name)

        --# setup

        local tab = assets.Window.Tab:Clone()
        local element_holder = tab.Main
        local list_layout : UIListLayout = element_holder.UIListLayout

        local button = assets.Window.TabButton:Clone()

        button.Text = name
        button.Name = name
        button.Parent = tablist

        tab.Name = name
        tab.Visible = false
        tab.Parent = tabholder

        element_holder.CanvasSize = UDim2.fromOffset(0, list_layout.AbsoluteContentSize)

        --# check if a tab exist

        if not current_tab then
            change_tab(tab, button)
        end

        --# changing tabs

        button.Activated:Connect(function()
            if current_tab ~= tab then
                change_tab(tab, button)
            end
        end)

        --# some scaling stuff

        list_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            element_holder.CanvasSize = UDim2.fromOffset(0, list_layout.AbsoluteContentSize)
        end)
        
        --# functions

        local tab_functions = {}

        --# [elements]

        --# section

        function tab_functions.CreateSection(name)
            local section = assets.Elements.Section:Clone()

            section.Text = name
            section.Parent = element_holder

            local section_functions = {}

            function section_functions.Set(name)
                section.Text = name
            end

            function section_functions.Destroy()
                section:Destroy()
            end

            return section_functions
        end

        --# label

        function tab_functions.CreateLabel(text)
            local label = assets.Elements.Label:Clone()

            label.Text = text
            label.Size = UDim2.new(label.Size.X, UDim.new(0, label.TextBounds.Y))
            label.Parent = element_holder

            local label_functions = {}

            function label_functions.Set(text)
                label.Text = text
                label.Size = UDim2.new(label.Size.X, UDim.new(0, label.TextBounds.Y))
            end

            function label_functions.Destroy()
                label:Destroy()
            end

            return label_functions
        end

        --# warning

        function tab_functions.CreateWarning(text)
            local warning = assets.Elements.Warning:Clone()

            warning.Text = text
            warning.Size = UDim2.new(warning.Size.X, UDim.new(0, warning.TextBounds.Y))
            warning.Parent = element_holder

            local warning_functions = {}

            function warning_functions.Set(text)
                warning.Text = text
                warning.Size = UDim2.new(warning.Size.X, UDim.new(0, warning.TextBounds.Y))
            end

            function warning_functions.Destroy()
                warning:Destroy()
            end

            return warning_functions
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

            button.Text = settings.Name
            button.Parent = element_holder

            --# core

            local hovering, mouse_down, debounce = false, false, true

            --# tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(button, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}),
                hover = tweenservice:Create(button, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}),
                interact = tweenservice:Create(button, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.interact_color}),
                error = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.error_color}),
            }

            local function reset_tween()
                if mouse_down then
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
                    reset_tween()
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
                if mouse_down then
                    mouse_down = false
                end
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouse_down = true
                    if debounce then
                        tweens.interact:Play()
                    end
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and mouse_down then
                    mouse_down = false
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
                if debounce then
                    task.spawn(attempt_callback)
                end
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

            toggle.Text = settings.Name
            toggle.Parent = element_holder

            --# core

            local hovering, mouse_down, switch, debounce = false, false, settings.StartValue, true

            --# tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(toggle, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}),
                hover = tweenservice:Create(toggle, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}),
                interact = tweenservice:Create(toggle, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.interact_color}),
                error = tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.error_color}),
                checkbox = {
                    [true] = tweenservice:Create(checkbox, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}),
                    [false] = tweenservice:Create(checkbox, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}),
                },
            }

            local function reset_tween()
                if mouse_down then
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
                    reset_tween()
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
                if mouse_down then
                    mouse_down = false
                end
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                    mouse_down = true
                    if debounce then
                        tweens.interact:Play()
                    end
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and mouse_down then
                    mouse_down = false
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

            slider.Text = settings.Name
            slider.Parent = element_holder

            --# core

            local hovering, sliding, progress, range, min_value, max_value, debounce = false, false, math.floor(settings.StartValue / settings.Increment) * settings.Increment, math.abs(settings.Range[1] - settings.Range[2]), math.min(unpack(settings.Range)), math.max(unpack(settings.Range)), true

            --# tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(button, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}),
                error = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.error_color}),
                slider = {
                    default = tweenservice:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.slider.default_color}),
                    hover = tweenservice:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.slider.hover_color}),
                },
            }
            
            --# callback stufff

            local function attempt_callback()
                local success, message = pcall(settings.Callback, progress)
                if not success then
                    debounce = false
                    if sliding then
                        sliding = false
                    end
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

            local function update_progress(value)
                if value ~= progress then
                    progress = value
                    progress_label.Text = tostring(progress) .. " " .. settings.Suffix or ""
                    return attempt_callback()
                end
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
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and debounce then
                    sliding = true

                    --# bla bla stuff right now bro?

                    local last_mouse_x = userinputservice:GetMouseLocation().X

                    do
                        local x_progress = math.clamp(last_mouse_x - bar.AbsolutePosition.X, 0, main.AbsoluteSize.X)
                        tweenservice:Create(bar, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(0, x_progress, 1, 0)}):Play()
    
                        local new_progress = math.floor(((x_progress / main.AbsoluteSize.X) * range) / settings.Increment) * settings.Increment
                        update_progress(new_progress)
                    end

                    local connection; connection = runservice.RenderStepped:Connect(function()
                        if sliding then
                            local current_mouse_x = userinputservice:GetMouseLocation().X
                            local mouse_x_delta = (current_mouse_x - last_mouse_x)
                            if mouse_x_delta ~= 0 then
                                last_mouse_x = current_mouse_x

                                local x_progress = math.clamp(current_mouse_x - bar.AbsolutePosition.X, 0, main.AbsoluteSize.X)
                                tweenservice:Create(bar, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(0, x_progress, 1, 0)}):Play()

                                local new_progress = math.floor(((x_progress / main.AbsoluteSize.X) * range) / settings.Increment) * settings.Increment
                                update_progress(new_progress)
                            end
                        else
                            connection:Disconnect()
                        end
                    end)
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and sliding then
                    sliding = false
                end
            end

            --# connections

            main.MouseEnter:Connect(on_mouse_enter)
            main.MouseLeave:Connect(on_mouse_leave)
            main.InputBegan:Connect(on_input_began)
            main.InputEnded:Connect(on_input_ended)

            --# functions

            local slider_functions = {}

            function slider_functions.Set(value)
                local x_progress = (value / range) * main.AbsoluteSize.X
                tweenservice:Create(bar, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(0, x_progress, 1, 0)}):Play()
                update_progress(value)
            end

            function slider_functions.Destroy()
                if sliding then
                    sliding = false
                end
                slider:Destroy()
            end

            return slider_functions
        end

        --# dropdown
        
        --# notification

        --# prompt

        --# destroy

        function tab_functions.Destroy()
            button:Destroy()
            tab:Destroy()
            if current_tab == tab then
                current_tab, current_tab_button = nil, nil
                local all_tabs = tabholder:GetChildren()
                local random_tab = all_tabs[math.random(#all_tabs)]
                if random_tab then
                    local random_tab_button = tablist:FindFirstChild(random_tab.Name)
                    if random_tab_button then
                        change_tab(random_tab, random_tab_button)
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

return library