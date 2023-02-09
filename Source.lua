local runservice, tweenservice, userinputservice, coregui = game:GetService("RunService"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("CoreGui")

local assets, library_holder = game:GetObjects("rbxassetid://12211969190")[1], coregui:FindFirstChild("plue-lib")
if not library_holder then library_holder = Instance.new("Folder", coregui); library_holder.Name = "plue-lib" end

local notification_holder = library_holder:FindFirstChild("notifications")
if not notification_holder then notification_holder = assets.NotificationHolder:Clone(); notification_holder.Name, notification_holder.Parent = "notifications", library_holder end

-- global functions
local function MakeDraggable(pivot, core)
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
end

-- callback param:
--[[
    table:

    On[event name] = {callback, bypassDebounce}
]]

local function ElementConstructor(element, tweens, callbacks)
    -- variables
    local hovering, mouse_down, locked = false, false, true

    local function ResetTween()
        if mouse_down then
            tweens.Interact(element)
        elseif hovering then
            tweens.Hover(element)
        else
            tweens.Default(element)
        end
    end

    local function OnError(message)
        debounce = false
        element.Text = "Callback Error"
        warn("plue-lib Callback Error:", message)
        tweens.Error(element)
        task.wait(2)
        button.Text = settings.Name
        ResetTween()
        debounce = true
    end

    -- connections
    local function on_mouse_enter()
        hovering = true
        if debounce then
            tweens.Hover(element)
        elseif not callbacks.OnMouseEnter or not callbacks.OnMouseEnter.BypassDebounce then
            return
        end
        callbacks.OnMouseEnter.Callback(SetDebounce, OnError)
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
    -- connections

    element.MouseEnter:Connect(function()
        hovering = true
        if debounce then
            tweens.Hover(element)
        elseif not callbacks.Hover or not callbacks.Hover.BypassDebounce then
            return
        end
        callbacks.Hover.Callback(SetDebounce, OnError)
    end)

    button.MouseLeave:Connect(function()
        hovering = false
        if debounce then
            tweens.Default(element)
        elseif not callbacks.HoverEnded or not callbacks.HoverEnded.BypassDebounce then
            return
        end
        callbacks.HoverEnded.Callback(SetDebounce, OnError)
    end)
    button.InputBegan:Connect(function(input)
        in input.UserInputType == Enum.UserInputType.MouseButton1 then
            mouse_down = true
            if debounce then
                tweens.Interact(element)
            elseif not callbacks.Interact or not callbacks.Interact.BypassDebounce then
                return
            end
            callbacks.InteractBegan.Callback(SetDebounce, OnError)
        end
    end)
    button.InputEnded:Connect(function(input)
        in input.UserInputType == Enum.UserInputType.MouseButton1 then
            mouse_down = false
            if debounce then
                tweens.Interact(element)
            elseif not callbacks.Interact or not callbacks.Interact.BypassDebounce then
                return
            end
            callbacks.InteractEnded.Callback(SetDebounce, OnError)
        end
    end)
end

-- library
local library = {}

-- notification
--[[
    Settings:

    Content = <string>,
    Color = <color3>,
    Duration = <number>,
    SoundId = <number?>
]]
function library.Notify(settings)
    -- variables
    local notification = assets.Notification:Clone(); task.wait()
    local main = notification.Main
    local color_bar = main.Color
    local label = main.Text
    local shadow = notification.Shadow.DropShadow

    -- setup
    color_bar.BackgroundColor3 = settings.Color
    label.Text = settings.Content
    notification.Size = UDim2.fromOffset(1 , notification.Size.Y.Offset)
    notification.Parent = notification_holder

    -- sound
    if settings.SoundId then
        local sound = Instance.new("Sound", notification)
        sound.SoundId = "rbxassetid://" .. settings.SoundId
        sound:Play()
    end

    -- tweens
    local size_tween = tweenservice:Create(notification, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(label.TextBounds.X + 20, notification.Size.Y.Offset)})
    size_tween.Completed:Connect(function()
        task.wait(settings.Duration)
        tweenservice:Create(notification, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(0, notification.Size.Y.Offset)}):Play()
        tweenservice:Create(shadow, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
        task.wait(.3)
        notification:Destroy()
    end)
    size_tween:Play()
end

-- window
function library.CreateWindow(name)
    -- destroy previous window(s) with the same name
    local window_name = "$" .. name
    for _, v in ipairs(library_holder:GetChildren()) do if v.Name == window_name then v:Destroy() end end

    -- variables
    local gui = assets.Window.GUI:Clone()
    local core = gui.Core
    local main = core.Main

    local topbar = main.Bar
    local settings_button = topbar.Stuff.SettingsButton
    local close_button = topbar.Stuff.CloseButton

    local tabholder = main.TabHolder

    local menu = main.Menu
    local tablist = menu.Tabs

    -- securing the gui
    if syn and syn.protect_gui then 
        syn.protect_gui(gui)
    end

    -- scaling
    tablist.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tablist.CanvasSize = UDim2.fromOffset(tablist.UIListLayout.AbsoluteContentSize.X, 0)
    end)

    -- theme, element tweenings ETC.
    local Theme = {
        Element = {
            Hover = Color3.fromRGB(45, 45, 45),
            Default = Color3.fromRGB(36, 36, 36),
            Interact = Color3.fromRGB(125, 125, 125),
            Error = Color3.fromRGB(175, 0, 0),
        },
        SubElement = { 
            Hover = Color3.fromRGB(32,32,32),
            Default = Color3.fromRGB(27,27,27),
            Interact = Color3.fromRGB(75, 75, 75),
            Error = Color3.fromRGB(124, 0, 0),
        },
        Tab = {
            Button = {
                Default = Color3.fromRGB(150, 150, 150),
                Selected = Color3.fromRGB(255, 255, 255)
            }
        },
        Dropdown = {
            OptionCorner = {
                Default = Color3.fromRGB(62, 62, 62),
                Selected = Color3.fromRGB(187, 197, 255)
            },
        },
    }
    
    local Tweens = {
        Element = {
            Default = function(self)
                tweenservice:Create(self, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.Default}):Play()
            end,
            Hover = function(self)
                tweenservice:Create(self, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.Hover}):Play()
            end,
            Interact = function(self)
                tweenservice:Create(self, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.Interact}):Play()
            end,
            Error = function(self)
                tweenservice:Create(self, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.Error}):Play()
            end,
        },
        SubElement = {
            Default = function(self)
                tweenservice:Create(self, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.SubElement.Default}):Play()
            end,
            Hover = function(self)
                tweenservice:Create(self, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.SubElement.Hover}):Play()
            end,
            Interact = function(self)
                tweenservice:Create(self, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.SubElement.Interact}):Play()
            end,
            Error = function(self)
                tweenservice:Create(self, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.SubElement.Error}):Play()
            end,
        },
    }

    -- setup
    MakeDraggable(topbar, core)

    topbar.Stuff.Title.Text = name  
    gui.Name = window_name
    gui.Parent = library_holder

    -- tab changing
    local current_tab , current_tab_button
    local function ChangeTab(tab, button)
        local previous_tab, previous_tab_button = current_tab, current_tab_button
        current_tab, current_tab_button = tab, button
        if previous_tab then
            previous_tab.Visible = false
        end
        if previous_tab_button then
            tweenservice:Create(previous_tab_button, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextColor3 = Theme.Tab.Button.Default}):Play()
        end
        current_tab.Visible = true
        tweenservice:Create(current_tab_button, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextColor3 = Theme.Tab.Button.Selected}):Play()
    end

    -- window methods (functions)
    local window_functions = {}

    -- tab
    function window_functions.CreateTab(name)
        -- variables
        local tab, button = assets.Window.Tab:Clone(), assets.Window.TabButton:Clone() ; task.wait()
        local element_holder = tab.Main

        -- setup
        button.Text = name
        button.Name = name
        button.Parent = tablist
        button.Size = UDim2.fromOffset(button.TextBounds.X, button.Size.Y.Offset)

        tab.Name = name
        tab.Visible = false
        tab.Parent = tabholder

        if not current_tab then
            ChangeTab(tab, button)
        end

        -- connections
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and current_tab ~= tab then
                ChangeTab(tab, button)
            end
        end)

        element_holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            element_holder.CanvasSize = UDim2.fromOffset(0, element_holder.UIListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- tab methods (functions)
        local tab_functions = {}

        function tab_functions.SetAsCurrentTab()
            if current_tab ~= tab then
                ChangeTab(tab, button)
            end
        end

        -- section
        function tab_functions.CreateSection(name)
            -- variables
            local section = assets.Elements.Section:Clone()

            -- setup
            section.Text = name
            section.Parent = element_holder

            -- section methods (functions)
            local section_functions = {}

            function section_functions.Set(name)
                section.Text = name
            end

            function section_functions.Destroy()
                section:Destroy()
            end

            return section_functions
        end

        -- label
        function tab_functions.CreateLabel(text)
            -- variables
            local label = assets.Elements.Label:Clone()

            -- scaling
            label:GetPropertyChangedSignal("TextBounds"):Connect(function()
                label.Size = UDim2.new(label.Size.X, UDim.new(0, label.TextBounds.Y + 10))
            end)

            -- setup
            label.Text = text
            label.Parent = element_holder

            -- label methods (functions)
            local label_functions = {}

            function label_functions.Set(text)
                label.Text = text   
            end

            function label_functions.Destroy()
                label:Destroy()
            end

            return label_functions
        end

        -- warning
        function tab_functions.CreateWarning(text)
            -- variables
            local warning = assets.Elements.Warning:Clone()

            -- scaling
            warning:GetPropertyChangedSignal("TextBounds"):Connect(function()
                warning.Size = UDim2.new(warning.Size.X, UDim.new(0, warning.TextBounds.Y + 10))
            end)

            -- setup
            warning.Text = text
            warning.Parent = element_holder

            -- warning methods (functions)
            local warning_functions = {}

            function warning_functions.Set(text)
                warning.Text = text
            end

            function warning_functions.Destroy()
                warning:Destroy()
            end

            return warning_functions
        end

        -- button
        --[[
            Settings:

            "Name" = <string>
            "Callback" = <function>
        ]]
        function tab_functions.CreateButton(settings)

            -- variables
            local button = assets.Elements.Button:Clone()

            -- setup
            button.Text = settings.Name
            button.Parent = element_holder

            -- state variables
            local hovering, mouse_down, debounce = false, false, true

            local function ResetTween()
                if mouse_down then
                    Tweens.Element.Interact(button)
                elseif hovering then
                    Tweens.Element.Hover(button)
                else
                    Tweens.Element.Default(button)
                end
            end

            -- callback
            local function AttemptCallback()
                local success, message = pcall(settings.Callback)
                if not success then
                    debounce = false
                    button.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    Tweens.Element.Error(button)
                    task.wait(2)
                    button.Text = settings.Name
                    ResetTween()
                    debounce = true
                end
                return success
            end

            -- connections
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

            -- connections

            button.MouseEnter:Connect(function()
                hovering = true
                if debounce then
                    Tweens.Element.Hover(button)
                end
            end)
            button.MouseLeave:Connect(function()
                
            end)
            button.InputBegan:Connect(on_input_began)
            button.InputEnded:Connect(on_input_ended)

            -- functions

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

        -- toggle

        --[[
            Settings:

            "Name" = <string>
            "Callback" = <function>
            "StartValue" = <boolean>
        ]]

        function tab_functions.CreateToggle(settings)

            -- setup

            local toggle = assets.Elements.Toggle:Clone()
            
            task.wait()

            local checkbox = toggle.CheckBox

            checkbox.ImageTransparency = settings.StartValue and 0 or 1

            toggle.Text = settings.Name
            toggle.Parent = element_holder

            -- core

            local hovering, mouse_down, switch, debounce = false, false, settings.StartValue, true

            -- tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(toggle, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.default_color}),
                hover = tweenservice:Create(toggle, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.hover_color}),
                interact = tweenservice:Create(toggle, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.interact_color}),
                error = tweenservice:Create(toggle, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Element.error_color}),
                checkbox = {
                    [true] = tweenservice:Create(checkbox, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {ImageTransparency  = 0}),
                    [false] = tweenservice:Create(checkbox, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {ImageTransparency  = 1}),
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

            -- callback stufff

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

            -- connection callbacks

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

            -- connections

            toggle.MouseEnter:Connect(on_mouse_enter)
            toggle.MouseLeave:Connect(on_mouse_leave)
            toggle.InputBegan:Connect(on_input_began)
            toggle.InputEnded:Connect(on_input_ended)

            -- functions

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

        -- slider

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

            -- setup

            local slider = assets.Elements.Slider:Clone()
            
            task.wait()

            local main = slider.Main

            local bar = main.Bar
            local progress_label = main.Progress

            slider.Text = settings.Name
            slider.Parent = element_holder

            -- core

            local hovering, sliding, progress, range, min_value, max_value, debounce = false, false, math.round(settings.StartValue / settings.Increment) * settings.Increment, math.abs(settings.Range[1] - settings.Range[2]), math.min(unpack(settings.Range)), math.max(unpack(settings.Range)), true

            -- quick seup too

            progress_label.Text = tostring(progress) .. " " .. settings.Suffix or ""

            -- tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(button, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.Element.default_color}),
                error = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.Element.error_color}),
                slider = {
                    default = tweenservice:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.SubElement.default_color}),
                    hover = tweenservice:Create(main, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.SubElement.hover_color}),
                },
            }
            
            -- callback stufff

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

            -- connection callbacks

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

                    -- bla bla stuff right now bro?

                    local last_mouse_x = userinputservice:GetMouseLocation().X

                    do
                        local x_progress = math.clamp(last_mouse_x - bar.AbsolutePosition.X, 0, main.AbsoluteSize.X)
                        tweenservice:Create(bar, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(0, x_progress, 1, 0)}):Play()
    
                        local new_progress = math.clamp(math.round(((x_progress / main.AbsoluteSize.X) * range + .5) / settings.Increment) * settings.Increment, min_value, max_value)
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

                                local new_progress = math.clamp(math.round(((x_progress / main.AbsoluteSize.X) * range +.5) / settings.Increment) * settings.Increment, min_value, max_value)
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

            -- connections

            main.MouseEnter:Connect(on_mouse_enter)
            main.MouseLeave:Connect(on_mouse_leave)
            main.InputBegan:Connect(on_input_began)
            main.InputEnded:Connect(on_input_ended)

            -- functions

            local slider_functions = {}

            function slider_functions.Set(value)
                value = math.clamp(value, min_value, max_value)
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

        -- dropdown

        --[[
            Settings:

            Name = <string>,
            CurrentOption = <string>,
            Options = <array : <string>>,
            Callback = <function>
        ]]

        function tab_functions.CreateDropdown(settings)

            -- setup

            local dropdown = assets.Elements.Dropdown:Clone()

            task.wait()

            local hitbox = dropdown.Hitbox
            local arrow = dropdown.Icon
            local selected_label = dropdown.Selected
            local list = dropdown.List.Holder
            local list_layout = list.UIListLayout

            selected_label.Text = settings.CurrentOption

            dropdown.Text = settings.Name
            dropdown.Parent = element_holder

            -- scaling stuff over here

            list_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list.CanvasSize = UDim2.new(0, 0, 0, list_layout.AbsoluteContentSize.Y + 10)
            end)

            -- core

            local hovering, mouse_down, current_option, current_option_button, open = false, false, settings.CurrentOption, nil, false

            -- tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(dropdown, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.Element.default_color}),
                hover = tweenservice:Create(dropdown, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.Element.hover_color}),
                interact = tweenservice:Create(dropdown, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.Element.interact_color}),
                dropdown = {
                    [true] = tweenservice:Create(dropdown, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(dropdown.Size.X, UDim.new(0, 270))}),
                    [false] = tweenservice:Create(dropdown, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = dropdown.Size}),
                },
                arrow = {
                    [true] = tweenservice:Create(arrow, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Rotation = 180}),
                    [false] = tweenservice:Create(arrow, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Rotation = 0}),
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

            -- callback

            local function attempt_callback()
                local success, message = pcall(settings.Callback, current_option)
                return success, message
            end

            local function set_option(option, button)
                local previous_button = current_option_button
                current_option, current_option_button = option, button
                if previous_button then
                    previous_button.UIStroke.Color = theme.element.dropdown.option_corner.default
                end
                current_option_button.UIStroke.Color = theme.element.dropdown.option_corner.selected
                selected_label.Text = current_option
                return attempt_callback()
            end

            -- connection callbacks

            local function on_mouse_enter()
                hovering = true
                tweens.hover:Play()
            end

            local function on_mouse_leave()
                hovering = false
                if mouse_down then
                    mouse_down = false
                end
                tweens.default:Play()
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouse_down = true
                    tweens.interact:Play()
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and mouse_down then
                    mouse_down = false
                    open = not open
                    tweens.arrow[open]:Play()
                    tweens.dropdown[open]:Play()
                    tweens.hover:Play()
                end
            end

            -- connections

            hitbox.MouseEnter:Connect(on_mouse_enter)
            hitbox.MouseLeave:Connect(on_mouse_leave)
            hitbox.InputBegan:Connect(on_input_began)
            hitbox.InputEnded:Connect(on_input_ended)

            -- CREATING OPTIONS

            local function create_option(option)
                
                local button = assets.Elements.DropdownOption:Clone()

                button.Name = option
                button.Text = option
                button.Parent = list

                -- normal button stuff.

                local hovering, mouse_down, debounce = false, false, true

                -- tween and coloring stuff
    
                local tweens = {
                    default = tweenservice:Create(button, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.sub_element.default_color}),
                    hover = tweenservice:Create(button, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.sub_element.hover_color}),
                    interact = tweenservice:Create(button, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.sub_element.interact_color}),
                    error = tweenservice:Create(button, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.sub_element.error_color}),
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
    
                -- callback stufff
    
                local function choose()
                    local success, message = set_option(option, button)
                    if not success then
                        debounce = false
                        button.Text = "Callback Error"
                        warn("plue-lib Callback Error:", message)
                        tweens.error:Play()
                        task.wait(2)
                        button.Text = option
                        reset_tween()
                        debounce = true
                    end
                    return success
                end
    
                -- connection callbacks
    
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
                            if current_option ~= option then
                                choose()
                            end
                        end
                    end
                end
    
                -- connections
    
                button.MouseEnter:Connect(on_mouse_enter)
                button.MouseLeave:Connect(on_mouse_leave)
                button.InputBegan:Connect(on_input_began)
                button.InputEnded:Connect(on_input_ended)
            end

            -- setting base options
            
            for _, option in ipairs(settings.Options) do
                create_option(option)
            end

            -- some other stuff of course

            do
                local current_button = list:FindFirstChild(current_option)
                if current_button then
                    current_option_button = current_button
                    current_option_button.UIStroke.Color = theme.element.dropdown.option_corner.selected
                end
            end

            -- functions

            local dropdown_functions = {}

            dropdown_functions.Add = create_option

            dropdown_functions.Remove = function(option)
                local button = list:FindFirstChild(option)
                if button then
                    button:Destroy()
                    if current_option == option and current_option_button == button then
                        current_option, current_option_button, selected_label.Text = nil, nil, ""
                    end
                end
            end

            function dropdown_functions.Set(option)
                if current_option ~= option then
                    local button = list:FindFirstChild(option)
                    if button then
                        task.spawn(set_option, option, button)
                    end
                end
            end

            function dropdown_functions.Destroy()
                dropdown:Destroy()
            end

            return dropdown_functions
        end

        -- input

        -- keybind

        --[[
            Settings:

            Name = <string>,
            Callback = <function>,
            CurrentBind = <KeyCode?>
        ]]

        function tab_functions.CreateKeybind(settings)
            
            -- setup

            local keybind = assets.Elements.Keybind:Clone()

            task.wait()

            local holder = keybind.Holder

            do
                if settings.CurrentBind then
                    local bind_string = userinputservice:GetStringForKeyCode(settings.CurrentBind)
                    if bind_string then
                        holder.Text = bind_string
                    else
                        holder.Text = settings.CurrentBind.Name
                    end
                end
            end

            keybind.Text = settings.Name
            keybind.Parent = element_holder

            -- scaling stuff

            holder:GetPropertyChangedSignal("TextBounds"):Connect(function()
                holder.Size = UDim2.fromOffset(holder.TextBounds.X + 20, holder.Size.Y.Offset)
            end)

            -- core

            local hovering, mouse_down, bind, binding, debounce = false, false, settings.CurrentBind, false, true

            -- tween and coloring stuff

            local tweens = {
                default = tweenservice:Create(keybind, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}),
                hover = tweenservice:Create(keybind, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}),
                interact = tweenservice:Create(keybind, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.interact_color}),
                error = tweenservice:Create(keybind, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.error_color}),
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

            -- callback stufff

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

            -- binding stuff

            local function uis_input_began(input, gameProcessedEvent)
                if not gameProcessedEvent then
                    if binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            binding = false
                            bind = input.KeyCode
                            local bind_string = userinputservice:GetStringForKeyCode(bind)
                            if bind_string ~= "" and bind_string:gsub("%s+", ""):len() ~= 0 then
                                holder.Text = bind_string
                            else
                                holder.Text = bind.Name
                            end
                        end
                    elseif input.KeyCode == bind then
                        attempt_callback()
                    end
                end
            end

            -- connection callbacks

            local function on_mouse_enter()
                hovering = true
                tweens.hover:Play()
            end

            local function on_mouse_leave()
                hovering = false
                tweens.default:Play()
                if mouse_down then
                    mouse_down = false
                end
                if binding then
                    binding = false
                    holder.Text = ""
                end
            end

            local function on_input_began(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouse_down = true
                    tweens.interact:Play()
                end
            end

            local function on_input_ended(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and mouse_down then
                    mouse_down = false
                    tweens.hover:Play()

                    binding = true
                    bind = nil
                    holder.Text = "..."
                end
            end

            -- connections

            keybind.MouseEnter:Connect(on_mouse_enter)
            keybind.MouseLeave:Connect(on_mouse_leave)
            keybind.InputBegan:Connect(on_input_began)
            keybind.InputEnded:Connect(on_input_ended)

            local uis_connection = userinputservice.InputBegan:Connect(uis_input_began)

            keybind.Destroying:Connect(function()
                uis_connection:Disconnect()
            end)

            -- functions

            local keybind_functions = {}

            function keybind_functions.Set(value)
                bind = value
            end

            function keybind_functions.GetCurrentKeybind()
                return bind
            end

            function keybind_functions.Destroy()
                keybind:Destroy()
            end

            return keybind_functions
        end

        -- input

        --[[
            Settings:

            Name = <string>,
            CurrentInput = <string>,
            Callback = <function>
        ]]

        function tab_functions.CreateInput(settings)
            
            -- setup

            local input = assets.Elements.Input:Clone()

            task.wait()

            local holder = input.Holder
            local textbox : TextBox = input.TextBox

            input.Text = settings.Name
            input.Parent = element_holder

            -- scaling stuff
            
            textbox:GetPropertyChangedSignal("Text"):Connect(function()
                if textbox:IsFocused() then
                    input.Size = UDim2.new(input.Size.X, UDim.new(0, math.clamp(textbox.TextBounds.Y + 40, 60, math.huge)))
                end
            end)

            if settings.CurrentInput:len() > 24 then
                holder.Text = settings.CurrentInput:sub(1, 24) .. "..."
            else
                holder.Text = settings.CurrentInput
            end

            holder.Size = UDim2.fromOffset(holder.TextBounds.X + 30, holder.Size.Y.Offset)

            --dang

            textbox.Text = settings.CurrentInput

            -- bruh

            local hovering, mouse_down, inputting, current_input, debounce = false, false, false, settings.CurrentInput, true

            -- tweening etc

            local tweens = {
                default = tweenservice:Create(input, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}),
                hover = tweenservice:Create(input, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}),
                interact = tweenservice:Create(input, TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.interact_color}),
                error = tweenservice:Create(input, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.error_color}),
            }

            -- callback stuff

            local function reset_tween()
                if mouse_down then
                    tweens.interact:Play()
                elseif hovering then
                    tweens.hover:Play()
                else
                    tweens.default:Play()
                end
            end

            local function attempt_callback()
                local success, message = pcall(settings.Callback, current_input)
                if not success then
                    debounce = false
                    input.Text = "Callback Error"
                    warn("plue-lib Callback Error:", message)
                    tweens.error:Play()
                    task.wait(2)
                    input.Text = settings.Name
                    reset_tween()
                    debounce = true
                end
                return success
            end
            
            local function set_input(input)
                if input ~= current_input then
                    current_input = input
                    if string.len(input) > 24 then
                        holder.Text = string.sub(input, 1, 24) .. "..."
                    else
                        holder.Text = input
                    end
                    holder.Size = UDim2.fromOffset(holder.TextBounds.X + 30, holder.Size.Y.Offset)
                    attempt_callback()
                end
            end

            -- connections

            -- inpıttin

            textbox.Focused:Connect(function()
                task.wait()
                input.Size = UDim2.new(input.Size.X, UDim.new(0, math.clamp(textbox.TextBounds.Y + 40, 60, math.huge)))
            end)

            textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    set_input(textbox.Text)
                end
                input.Size = UDim2.new(input.Size.X, UDim.new(0, 60))
                textbox.Visible = false
            end)

            -- general stuff

            input.MouseEnter:Connect(function()
                hovering = true
                if debounce then
                    tweens.hover:Play()
                end
            end)

            input.MouseLeave:Connect(function()
                hovering = false
                if debounce then
                    tweens.default:Play()
                end
                if mouse_down then
                    mouse_down = false
                end
                if textbox:IsFocused() then
                    textbox:ReleaseFocus(false)
                    textbox.Text = current_input
                end
            end)

            input.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouse_down = true
                    if debounce then
                        tweens.interact:Play()
                    end
                end
            end)

            input.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and mouse_down then
                    mouse_down = false
                    
                    if debounce then
                        tweens.hover:Play()

                        textbox.Visible = true
                        textbox:CaptureFocus()
                    end
                end
            end)

            local input_functions = {}

            function input_functions.Set(text)
                textbox.Text = text
                task.spawn(set_input, text)
            end

            function input_functions.GetCurrentInput()
                return current_input
            end

            function input_functions.Destroy()
                input:Destroy()
            end

            return input_functions

        end

        -- color picker

        --[[
            Settings:

            CurrentColor = <Color3>,
            Name = <string>,
            Callback = <function>
        ]]

        function tab_functions.CreateColorPicker(settings)

            -- variables

            local color_picker = assets.Elements.ColorPicker:Clone()

            task.wait()

            local hitbox = color_picker.Hitbox
            local color_circle_icon = color_picker.Color
            local holder = color_picker.Holder

            local hue_saturation_slider = holder.HueSaturationSlider
            local value_slider = holder.BrightnessSlider

            local hex_textbox = holder.Hex.Value
            local rgb_frame = holder.RGB.Values

            local value_slider_circle = value_slider.Button
            local hue_saturation_slider_circle = hue_saturation_slider.Button

            -- setup   

            local color = settings.CurrentColor
            local hue, saturation, value = color:ToHSV()
            local r, g, b = color.R * 255, color.G * 255, color.B * 255
            local hex = color:ToHex()

            -- hue / saturation updates

            local function update_hue_slider()
                hue_saturation_slider_circle.Position = UDim2.fromScale(hue, hue_saturation_slider_circle.Position.Y.Scale)
                hue_saturation_slider_circle.BackgroundColor3 = Color3.fromHSV(hue, saturation, 1)
            end

            local function update_saturation_slider()
                hue_saturation_slider_circle.Position = UDim2.fromScale(hue_saturation_slider_circle.Position.X.Scale, 1 - saturation)
                hue_saturation_slider_circle.BackgroundColor3 = Color3.fromHSV(hue, saturation, 1)
            end

            -- value updates

            local function update_value_slider()
                value_slider_circle.Position = UDim2.fromScale(value, 0)
            end

            -- all slider updates

            local function update_sliders()
                update_hue_slider(); update_saturation_slider(); update_value_slider()
            end

            -- rgb updates

            local function update_rgb()
                rgb_frame.R.Text, rgb_frame.G.Text, rgb_frame.B.Text = math.round(r), math.round(g), math.round(b)
            end

            -- hex updates

            local function update_hex()
                hex_textbox.Text = "#" .. tostring(hex)
            end

            -- callback, color

            local attempt_callback

            local function update_color(from : string?)
                if from == "HSV" then
                    color = Color3.fromHSV(hue, saturation, value)
                    hex, r, g, b = color:ToHex(), color.R * 255, color.G * 255, color.B * 255
                    update_hex()
                    update_rgb()
                elseif from == "Hex" then
                    color = Color3.fromHex(hex)
                    r, g, b, hue, saturation, value = color.R * 255, color.G * 255, color.B * 255, color:ToHSV()
                    update_rgb()
                    update_sliders()
                elseif from == "RGB" then
                    color = Color3.fromRGB(r, g, b)
                    hex, hue, saturation, value = color:ToHex(), color:ToHSV()
                    update_hex()
                    update_sliders()
                end

                value_slider_circle.BackgroundColor3 = color
                value_slider.BackgroundColor3 = Color3.fromHSV(hue, saturation, 1)

                color_circle_icon.BackgroundColor3 = color

                attempt_callback()
            end

            -- hue / saturation slider.

            do
                local connection

                local function start_dragging()
                    if not connection then
                        userinputservice.MouseIconEnabled = false
                        connection = runservice.RenderStepped:Connect(function()
                            local current = userinputservice:GetMouseLocation()
                            local change_made = false

                            local new_hue = math.clamp((current.X - hue_saturation_slider.AbsolutePosition.X) / hue_saturation_slider.AbsoluteSize.X, 0, 1)

                            if new_hue ~= hue then
                                hue = new_hue
                                update_hue_slider()
                                change_made = true
                            end

                            local new_saturation = math.clamp((hue_saturation_slider.AbsolutePosition.Y + hue_saturation_slider.AbsoluteSize.Y - current.Y + 36) / hue_saturation_slider.AbsoluteSize.Y, 0, 1)
                            
                            if new_saturation ~= saturation then
                                saturation = new_saturation
                                update_saturation_slider()
                                change_made = true
                            end

                            if change_made then
                                update_color("HSV")
                            end

                        end)
                    end
                end

                local function stop_dragging()
                    if connection then
                        connection:Disconnect()
                        connection = nil
                        userinputservice.MouseIconEnabled = true
                    end
                end

                local function input_began(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        start_dragging()
                    end
                end

                local function input_ended(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        stop_dragging()
                    end
                end

                hue_saturation_slider_circle.InputBegan:Connect(input_began)
                hue_saturation_slider.InputBegan:Connect(input_began)

                hue_saturation_slider_circle.InputEnded:Connect(input_ended)
                hue_saturation_slider.InputEnded:Connect(input_ended)
            end

            -- value slider.

            do
                local connection

                local function start_dragging()
                    if not connection then
                        userinputservice.MouseIconEnabled = false
                        connection = runservice.RenderStepped:Connect(function()
                            local current = userinputservice:GetMouseLocation().X
                            local new_value = math.clamp((current - value_slider.AbsolutePosition.X) / value_slider.AbsoluteSize.X, 0, 1)
                            if new_value ~= value then
                                value = new_value
                                update_value_slider()
                                update_color("HSV")
                            end
                        end)
                    end
                end

                local function stop_dragging()
                    if connection then
                        connection:Disconnect()
                        connection = nil
                        userinputservice.MouseIconEnabled = true
                    end
                end

                local function input_began(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        start_dragging()
                    end
                end

                local function input_ended(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        stop_dragging()
                    end
                end

                value_slider_circle.InputBegan:Connect(input_began)
                value_slider.InputBegan:Connect(input_began)

                value_slider_circle.InputEnded:Connect(input_ended)
                value_slider.InputEnded:Connect(input_ended)
            end

            -- rgb, hex input

            -- scaling, effects

            for _, v in ipairs({rgb_frame["R"], rgb_frame["G"], rgb_frame["B"], hex_textbox}) do

                -- scaling

                v:GetPropertyChangedSignal("Text"):Connect(function()
                    v.Size = UDim2.fromOffset(v.TextBounds.X + 20, v.Size.Y.Offset)
                end)

                -- tweening, effects.

                v.MouseEnter:Connect(function()
                    tweenservice:Create(v, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.sub_element.hover_color}):Play()
                end)

                v.MouseLeave:Connect(function()
                    tweenservice:Create(v, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.sub_element.default_color}):Play()
                end)

            end

            -- rgb input

            rgb_frame["R"].FocusLost:Connect(function()
                local input = tonumber(rgb_frame.R.Text)
                if input then
                    local new_r = math.clamp(input, 0, 255)
                    if new_r ~= r then
                        r = new_r
                        update_color("RGB")
                    end
                end
                rgb_frame.R.Text = math.round(r)
            end)

            rgb_frame["G"].FocusLost:Connect(function()
                local input = tonumber(rgb_frame.G.Text)
                if input then
                    local new_g = math.clamp(input, 0, 255)
                    if new_g ~= g then
                        g = new_g
                        update_color("RGB")
                    end
                end
                rgb_frame.G.Text = math.round(g)
            end)

            rgb_frame["B"].FocusLost:Connect(function()
                local input = tonumber(rgb_frame.B.Text)
                if input then
                    local new_b = math.clamp(input, 0, 255)
                    if new_b ~= b then
                        b = new_b
                        update_color("RGB")
                    end
                end
                rgb_frame.B.Text = math.round(b)
            end)

            -- hex input

            hex_textbox.FocusLost:Connect(function()
                local new_hex = hex_textbox.Text
                if new_hex ~= hex then
                    hex = new_hex
                    update_color("Hex")
                end
                hex_textbox.Text = hex
            end)

            -- startup updates

            update_sliders(); update_hex(); update_rgb()

            -- button

            do
                local hovering, mouse_down, open, debounce = false, false, false, true

                hitbox.MouseEnter:Connect(function()
                    hovering = true
                    if debounce then
                        tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}):Play()
                    end
                end)

                hitbox.MouseLeave:Connect(function()
                    hovering = false
                    if mouse_down then
                        mouse_down = false
                    end
                    if debounce then
                        tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}):Play()
                    end
                end)

                hitbox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        mouse_down = true
                        if debounce then
                            tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.interact_color}):Play()
                        end
                    end
                end)

                -- tweening

                do

                    local size_tweens = {
                        [true] = tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(color_picker.Size.X,UDim.new(0, 350))}),
                        [false] = tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = color_picker.Size})
                    }
                    
                    hitbox.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 and hovering then
                            mouse_down = false
                            if debounce then
                                tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}):Play()
                            end
                            open = not open
                            size_tweens[open]:Play()
                        end
                    end)
                end

                local function reset_tween()
                    if mouse_down then
                        tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.interact_color}):Play()
                    elseif hovering then
                        tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.hover_color}):Play()
                    else
                        tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.default_color}):Play()
                    end
                end

                attempt_callback = function()
                    local success, message = pcall(settings.Callback, color)
                    if not success then
                        debounce = false
                        color_picker.Text = "Callback Error"
                        warn("plue-lib Callback Error:", message)
                        tweenservice:Create(color_picker, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = theme.element.error_color}):Play()
                        task.wait(2)
                        input.Text = settings.Name
                        reset_tween()
                        debounce = true
                    end
                    return success
                end
            end

            color_picker.Text = settings.Name
            color_picker.Parent = element_holder

            color_circle_icon.BackgroundColor3 = color

            -- functions

            local color_picker_functions = {}

            function color_picker_functions.GetCurrentColor()
                return color
            end

            function color_picker_functions.Set(new_color)
                if new_color ~= color then
                    color = new_color
                    update_sliders(); update_hex(); update_rgb()
                    update_color()
                end
            end

            function color_picker_functions.Destroy()
                color_picker:Destroy()
            end

            return color_picker_functions
        end

        -- prompt

        -- destroy

        function tab_functions.Destroy()
            button:Destroy()
            tab:Destroy()
            if current_tab == tab then
                current_tab, current_tab_button = nil, nil
            end
        end

        return tab_functions
    end

    -- settings tab

    local settings_tab = window_functions.CreateTab("window_settings")

    settings_tab.CreateSection("Window Settings")
    local close_keybind = settings_tab.CreateKeybind({
        Name = "UI Keybind",
        CurrentBind = close_keybind,
        Callback = function()
            window_functions.ToggleWindow(not core.Visible)
        end
    })

    tablist["window_settings"]:Destroy()

    settings_button.Activated:Connect(function()
        if current_tab ~= settings_tab then
            ChangeTab(settings_tab)
        end
    end)

    -- buttons

    -- nigga cum

    function window_functions.ToggleWindow(toggle)
        core.Visible = toggle
    end

    close_button.Activated:Connect(function()
        window_functions.ToggleWindow(false)
        local current_bind = close_keybind.GetCurrentKeybind()
        if current_bind then
            library.Notify({
                Color = Color3.fromRGB(0, 110, 255),
                Content = "Window [" .. name .. "] is closed. Press " .. current_bind.Name .. " to open it.",
                Duration = 3
            })
        end
    end)

    -- final product

    function window_functions.Destroy()
        gui:Destroy()
    end

    return window_functions
end

----------------------------------------------------------------------------------------------------------------------------

-- test

local window = library.CreateWindow("cum")
local tab1, tab2, tab3 = window.CreateTab("gay porn"), window.CreateTab("movies"), window.CreateTab("nigger stuff")
tab1.CreateSection("nigger point")
tab1.CreateButton({
    Name = "Cum Activator",
    Callback = function()
        print("You've been cummed!")
    end
}
)
tab1.CreateSection("cum point")
tab1.CreateLabel("abone olun like atın teşekkür ederim ben kaynia emir kaya 10 izleniyorum")
tab1.CreateSlider({
    Name = "Noob Count",
    Suffix = "Noobs",
    Range = {1, 100},
    StartValue = 50,
    Increment = 1,
    Callback = function(value)
        warn("Congrats with your", value, "Noobs Retard")
    end
})

tab2.CreateWarning("Allah bir varmış bir yokmuş, desem günah olurdu ama bu adam türk olsa severdiniz")
tab2.CreateToggle({
    Name = "Cum Mode",
    StartValue = true,
    Callback = function(v)
        warn("Your cum mode is now:", v)
    end
})

tab2.CreateDropdown({
    Name = "En Ucube Olan",
    Options = {
        "Tarico",
        "Efeerderdnesn",
        "Alico",
        "İzabel",
        "plue"
    },
    CurrentOption = "plue",
    Callback = function(option)
        print("orospu cocugu", option)
    end
})

tab2.CreateWarning("Tariconun allahı yok")

tab2.CreateKeybind({
    Name = "print cool",
    CurrentBind = Enum.KeyCode.Q,
    Callback = function()
        print("you are sooooo fucking cool bro!!!!!")
    end
})

tab3.CreateButton({
    Name = "Notify Something Cool",
    Callback = function()
        library.Notify({
            Content = "Very cool stuff right here ma boy!",
            Duration = 5,
            Color = Color3.fromRGB(255, 65, 65),
            SoundId = "6026984224"
        })
    end
})

tab3.CreateInput({
    Name = "Cum Color",
    CurrentInput = "White Of Course nigger ass bitch!",
    Callback = function(input)
        print("Your cum is now:", input, "congrats!")
    end
})

tab3.CreateColorPicker({
    Name = "Cum Color Picker",
    CurrentColor = Color3.new(1, 0, 0),
    Callback = function(color)
    end
})

-- brav

return library