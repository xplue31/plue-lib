function tab_functions.CreateSlider(settings)
    --# setup
    local slider = assets.Elements.Slider:Clone()
    local main = slider.Main
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
    bar.Size = UDim2.new(0, main.AbsoluteSize.X * (progress / math.abs(settings.Range[2] - settings.Range[1])), 1, 0)
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

    local slider_functions = {}

    function slider_functions.Set(value)
        progress = value
        bar.Size = UDim2.new(0, main.Size.X.Offset * (progress / math.abs(settings.Range[2] - settings.Range[1])), 1, 0)
        progress_label.Text = progress .. " " .. settings.Suffix or ""
        task.defer(call_callback)
    end

    function slider_functions.Destroy()
        slider:Destroy()
    end

    return slider_functions
end