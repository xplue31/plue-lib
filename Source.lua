local wait = task.wait
local runservice = game:GetService("RunService")
local coregui = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local assets = game:GetObjects("rbxassetid://12552643516")[1]; wait()
local gui_template = assets.Gui
local tab_template = assets.Tab
local color_picker_panel = assets.ColorPickerPanel
local element_templates = assets.BasicElements
local button_template = element_templates.Button
local dropdown_template = element_templates.Dropdown
local slider_template = element_templates.Slider
local label_template = element_templates.Label
local dropdown_button_template = element_templates.DropdownButton
local multi_element_templates = assets.MultiElements
local multi_element_frame_template = multi_element_templates.MultiElement
local input_box_template = multi_element_templates.InputBox
local color_picker_box_template = multi_element_templates.ColorPickerBox
local keybind_box_template = multi_element_templates.KeybindBox
local toggle_box_template = multi_element_templates.ToggleBox
local label_multi_element_version_template = multi_element_templates.Label
local theme_update_callbacks = {}
local function better_get_string_for_keycode(keycode)
    if typeof(keycode) ~= "EnumItem" then return "" end
    local fkdfkkkdfjgkdfjgjdf = uis:GetStringForKeyCode(keycode)
    if fkdfkkkdfjgkdfjgjdf ~= "" and fkdfkkkdfjgkdfjgjdf:gsub("%s+", "") ~= "" then
        return fkdfkkkdfjgkdfjgjdf
    else
        return keycode.Name
    end
end
local function attempt_callback(callback, ...)
    local s, m = pcall(callback, ...)
    if not s then
        warn("callback error with the following arguments:", ..., "and the message:", m)
    end
    return s
end
return function(name, default_keybind)
    for _, v in ipairs(coregui:GetChildren()) do
        if v.Name == "iciciikmhkmjutygh" then
            v:Destroy()
        end
    end
    local gui = gui_template:Clone(); wait()
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
    gui.NameLabel.Text = name
    gui.Name, gui.Parent = "iciciikmhkmjutygh", coregui
    local gui_keybind_label = gui.KeybindLabel
    local gui_keybind_template_text = "press %s to toggle gui"
    gui_keybind_label.Text = gui_keybind_template_text:format(better_get_string_for_keycode(default_keybind))
    local function create_tab(name, image_id)
        local tab = tab_template:Clone(); wait()
        local bar = tab.Bar
        local close_button = bar.Close
        local icon = bar.Icon
        local tab_name_label = bar.TabName
        local element_holder = tab.ElementHolder
        if image_id then
            icon.Image = "rbxassetid://" .. image_id
        else
            icon.Image = nil
        end
        do
            local function kbbkgbjgjbg(cvjfg)
                cvjfg:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    local vjfjvf = cvjfg.AbsoluteSize.X 
                    if vjfjvf > tab.AbsoluteSize.X then
                        tab.Size = UDim2.fromOffset(vjfjvf, tab.Size.Y.Offset)
                    end
                end)
            end
            kbbkgbjgjbg(element_holder)
            kbbkgbjgjbg(bar)
        end
        do
            local ckkdfj = Instance.new("UISizeConstraint")
            local function k()
                local y = gui.AbsoluteSize.Y
                ckkdfj.MaxSize = Vector2.new(math.huge, y - y * .02 - 40)
            end
            gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(k)
            k()
            ckkdfj.Parent = element_holder
        end
        tab.Size = UDim2.fromOffset(300, 25)
        close_button.MouseButton1Click:Connect(function()
            element_holder.Visible = not element_holder.Visible
        end)
        tab_name_label.Text = name
        return {
            Label = function (content)
                local label = label_template:Clone()
                label.Text = content
                label.Parent = element_holder
            end, Button = function(name, callback)
                local button = button_template:Clone()
                button.Label.Text = name
                button.MouseButton1Click:Connect(function()
                    attempt_callback(callback)
                end)
                button.Parent = element_holder
            end, Slider = function(name, start_value, min_value, max_value, increment, suffix, callback)
                local slider = slider_template:Clone(); wait()
                local box = slider.Box
                local fill = box.Fill
                local value_label = box.Value
                slider.Label.Text = name
                local range = max_value - min_value
                local function vlofdkdf()
                    fill.Size = UDim2.fromScale(start_value / range, 1)
                    value_label.Text = start_value .. suffix
                end
                vlofdkdf()
                local function kgjgfkjfdfdgbvcbvcnfghgf(kfghj)
                    kfghj = math.clamp(kfghj, 0, 1)
                    fill.Size = UDim2.fromScale(kfghj, 1)
                    local ksdkak = kfghj * range
                    local opso = min_value + math.floor(ksdkak / increment + .5) * increment
                    if start_value ~= opso then
                        start_value = opso
                        value_label.Text = start_value .. suffix
                        attempt_callback(callback, start_value)
                    end
                end
                local con
                box.MouseButton1Down:Connect(function()
                    if con == nil then
                        con = runservice.RenderStepped:Connect(function()
                            local m_x = uis:GetMouseLocation().X
                            local d_x = m_x - fill.AbsolutePosition.X
                            kgjgfkjfdfdgbvcbvcnfghgf(d_x / box.AbsoluteSize.X)
                        end)
                    end
                end)
                box.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and con then
                        con:Disconnect()
                        con = nil
                    end
                end)
                slider.Parent = element_holder
                return {
                    Set = function (value)
                        start_value = value
                        vlofdkdf()
                    end, GetValue = function()
                        return start_value
                    end
                }
            end, Dropdown = function(name, start_options, options, callback, min_selected_option_count, max_selected_option_count)
                local dropdown = dropdown_template:Clone(); wait()
                local list = dropdown.List
                local box = dropdown.Box
                local arrow = box.Arrow
                local value_label = box.Value
                value_label.Text = table.concat(start_options, ", ")
                dropdown.Label.Text = name
                local option_buttons = {}
                local y_size = 50
                local open = false
                local function update()
                    value_label.Text = table.concat(start_options, ", ")
                    y_size = list.AbsoluteSize.Y + 50
                    if open then
                        dropdown.Size = UDim2.new(dropdown.Size.X, UDim.new(0, y_size))
                    end
                    attempt_callback(callback, start_options)
                end
                box.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        dropdown.Size = UDim2.new(dropdown.Size.X, UDim.new(0, y_size))
                        arrow.Rotation = 180
                    else
                        dropdown.Size = UDim2.new(dropdown.Size.X, UDim.new(0, 50))
                        arrow.Rotation = 0
                    end
                    list.Visible = open
                end)
                local function add_option(option)
                    if option_buttons[option] then return end
                    local button = dropdown_button_template:Clone(); wait()
                    option_buttons[option] = button
                    button.Value.Text = option
                    button.MouseButton1Click:Connect(function()
                        local i = table.find(start_options, option)
                        if i then
                            if #start_options <= min_selected_option_count then return end
                            table.remove(start_options, i)
                            update()
                        else
                            if #start_options >= max_selected_option_count then return end
                            table.insert(start_options, option)
                            update()
                        end
                    end)
                end
                local function remove_option(option)
                    local button = option_buttons[option]
                    if button then
                        button:Destroy()
                        option_buttons[option] = nil
                    end
                    local i = table.find(start_options, option)
                    if i then
                        table.remove(start_options, i)
                        update()
                    end
                end
                for _, option in ipairs(options) do
                    add_option(option)
                end
                for _, selected_option in ipairs(start_options) do
                    local button = option_buttons[selected_option]
                    if button then
                        
                    end
                end
                update()
                return {
                AddOption = add_option, RemoveOption = remove_option, 
                Refresh = function(options, selected_options)
                        for _, button in pairs(option_buttons) do
                            button:Destroy()
                        end
                        table.clear(option_buttons)
                        start_options = selected_options
                        for _, option in ipairs(options) do
                            add_option(option)
                        end
                        update()
                    end, GetSelected = function()
                        return start_options
                    end
                }
            end,
            MultiElement = function()
                local multi_element = multi_element_frame_template:Clone()
                multi_element.Parent = element_holder
                return {Label = function (content) -- multi element label
                    local label = label_multi_element_version_template:Clone()
                    label.Text = content
                    label.Parent = multi_element
                end, Toggle = function (start_value, callback) -- toggle
                    local toggle = toggle_box_template:Clone(); wait()
                    local fill = toggle.Fill
                    fill.Visible = start_value
                    local function switch(v)
                        start_value = v
                        fill.Visible = start_value
                        attempt_callback(callback, start_value)
                    end
                    toggle.MouseButton1Click:Connect(function()
                        switch(not start_value)
                    end)
                    toggle.Parent = multi_element
                    return {
                        Set = switch, GetValue = function()
                            return start_value
                        end
                    }
                end, Keybind = function(start_bind, callback, keybind_changed_callback) -- keybind
                    local keybind = keybind_box_template:Clone(); wait()
                    local label = keybind.Label
                    label.Text = better_get_string_for_keycode(start_bind)
                    local binding, hovering, cache = false, false, ""
                    local function bind(keycode)
                        if keycode ~= start_bind then
                            start_bind = keycode
                            cache = better_get_string_for_keycode(start_bind)
                            label.Text = cache
                            if keybind_changed_callback then
                                attempt_callback(keybind_changed_callback, start_bind)
                            end
                        end
                    end
                    keybind.HoverBegan:Connect(function()
                        hovering = true
                    end)
                    keybind.MouseButton1Click:Connect(function()
                        if hovering then
                            binding = true
                            label.Text = "..."
                        end
                    end)
                    keybind.HoverEnded:Connect(function()
                        hovering = false
                        if binding then
                            binding = false
                            label.Text = cache
                        end
                    end)
                    uis.InputBegan:Connect(function(input)
                        if binding then
                            binding = false
                            bind(input.KeyCode)
                        elseif input.KeyCode == start_bind then
                            attempt_callback(callback)
                        end
                    end)
                    keybind.Parent = multi_element
                    return {
                        Set = bind, GetKeybind = function()
                            return start_bind
                        end
                    }
                end, Input = function (start_input, callback)
                    local input = input_box_template:Clone(); wait()
                    local textbox = input.TextBox
                    local function u(t)
                        if start_input ~= t then
                            start_input = t
                            attempt_callback(callback, start_input)
                        end
                    end
                    textbox.FocusLost:Connect(function()
                        local text = textbox.Text
                        if text:len() > 24 then
                            textbox.Text = text:sub(1, 24) .. "..."
                        end
                        u(text)
                    end)
                    textbox.Focused:Connect(function()
                        textbox.Text = start_input
                    end)
                    local function v(t)
                        return #t > 24 and t:sub(1, 24) .. "..." or t
                    end
                    textbox.Text = v(start_input)
                    input.Parent = multi_element
                    return {
                        Set = function (t)
                            textbox.Text = v(t)
                            u(t)
                        end, GetInput = function()
                            return start_input
                        end
                    }
                end, ColorPicker = function (start_color, callback)
                    local color_picker = color_picker_box_template:Clone() ; local panel = color_picker_panel:Clone() ; wait()
                    local rgb_hex_frame = panel.RGBHEX
                    local rgb_textboxex = rgb_hex_frame.RGB
                    local r_textbox = rgb_textboxex.R
                    local g_textbox = rgb_textboxex.G
                    local b_textbox = rgb_textboxex.B
                    local hex_textbox = rgb_hex_frame.Hex
                    local hue_slider = panel.H
                    local saturation_value_slider = panel.SV
                    local s_v_slider_circle = saturation_value_slider.Circle
                    local h_slider_pointer = hue_slider.Arrow
                    local h, s, v = start_color:ToHSV()
                    local r, g, b = math.floor(start_color.R * 255), math.floor(start_color.G * 255), math.floor(start_color.B * 255)
                    local hex = start_color:ToHex()
                    local function hex_set()
                        hex = start_color:ToHex()
                        hex_textbox.Text = hex
                    end
                    local function rgb_set()
                        r, g, b = math.floor(start_color.R * 255), math.floor(start_color.G * 255), math.floor(start_color.B * 255)
                        r_textbox.Text, g_textbox.Text, b_textbox.Text = r,g, b
                    end
                    local saturation_frame = saturation_value_slider.Saturation
                    local function hs_color_set()
                        saturation_frame.BackgroundColor3 = Color3.fromHSV(h, 0, 1)
                    end
                    local function hsv_set()
                        local h, s, v = start_color:ToHSV()
                        s_v_slider_circle.Position = UDim2.fromScale(s, v)
                        h_slider_pointer.Position = UDim2.fromScale(0, 1 - h)
                        hs_color_set()
                    end
                    local setter = {
                        ["Hex"] = function()
                            start_color = Color3.fromHex(hex)
                            rgb_set()
                            hsv_set()
                            hs_color_set()
                        end,
                        ["RGB"] = function()
                            start_color = Color3.fromRGB(r, g , b)
                            hex_set()
                            hsv_set()
                        end,
                        ["SV"] = function()
                            start_color = Color3.fromHSV(h, s, v)
                            rgb_set()
                            hex_set()
                        end,
                        ["H"] = function()
                            start_color = Color3.fromHSV(h, s, v)
                            hs_color_set()
                            hex_set()
                            rgb_set()
                        end,
                        ["All"] = function()
                            hsv_set()
                            rgb_set()
                            hex_set()
                        end
                    }
                    local function set(x)
                        setter[x]()
                        color_picker.BackgroundColor3 = start_color
                        attempt_callback(callback, start_color)
                    end
                    r_textbox.FocusLost:Connect(function()
                        local input = tonumber(r_textbox.Text)
                        if input then
                            local new_value = math.clamp(math.floor(input), 0, 255)
                            if new_value ~= r then
                                r = new_value
                                r_textbox.Text = r
                                set("RGB")
                                return
                            end
                        end
                        r_textbox.Text = r
                    end)
                    g_textbox.FocusLost:Connect(function()
                        local input = tonumber(g_textbox.Text)
                        if input then
                            local new_value = math.clamp(math.floor(input), 0, 255)
                            if new_value ~= g then
                                g = new_value
                                g_textbox.Text = g
                                set("RGB")
                                return
                            end
                        end
                        g_textbox.Text = g
                    end)
                    b_textbox.FocusLost:Connect(function()
                        local input = tonumber(b_textbox.Text)
                        if input then
                            local new_value = math.clamp(math.floor(input), 0, 255)
                            if new_value ~= b then
                                b = new_value
                                b_textbox.Text = b
                                set("RGB")
                                return
                            end
                        end
                        b_textbox.Text = b
                    end)
                    hex_textbox.FocusLost:Connect(function()
                        local input = hex_textbox.Text
                        local len = input:len()
                        if len == 7 and input:sub(1,1) == "#" then
                            input = tonumber(input:sub(2, -1), 16)
                        elseif len == 6 then    
                            input = tonumber(input, 16)
                        else
                            input = nil
                        end
                        if input ~= nil then
                            input = math.clamp(input, 0, 0xffffff)
                            if input ~= hex then
                                hex = input
                                hex_textbox.Text = "#" .. string.format("%x", hex)
                                set("Hex")  
                                return
                            end
                        end
                        hex_textbox.Text = "#" .. string.format("%x", hex)
                    end)
                    do
                        local con
                        local p = hue_slider.AbsoluteSize.Y
                        hue_slider.MouseButton1Down:Connect(function()
                            if con == nil then
                                con = runservice.RenderStepped:Connect(function()
                                    local c = math.clamp((uis:GetMouseLocation().Y - hue_slider.AbsolutePosition.Y) / p, 0, 1)
                                    local sdf = 1 - c
                                    if sdf ~= h then
                                        h = sdf
                                        h_slider_pointer.Position = UDim2.fromScale(0, c)
                                        set("H")
                                    end
                                end)
                            end
                        end)
                        hue_slider.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 and con then
                                con:Disconnect()
                                con = nil
                            end
                        end)
                    end
                    do
                        local con
                        local s = saturation_value_slider.AbsoluteSize
                        saturation_value_slider.MouseButton1Down:Connect(function()
                            if con == nil then
                                con = runservice.RenderStepped:Connect(function()
                                    local m = uis:GetMouseLocation()
                                    local objspac = m - saturation_value_slider.AbsolutePosition
                                    local p_s, p_v = math.clamp(objspac.X / s.X, 0, 1), math.clamp(objspac.X / s.X, 0, 1)
                                    local kys, now = 1 - p_s, 1 - p_v
                                    local k = kys ~= s
                                    local y = now ~= v
                                    if k then
                                        s = kys
                                        s_v_slider_circle.Position = UDim2.fromScale(p_s, s_v_slider_circle.Position.Y.Scale)
                                    end
                                    if y then
                                        v = now
                                        s_v_slider_circle.Position = UDim2.fromScale(s_v_slider_circle.Position.X.Scale, p_v)
                                    end
                                    if k or y then
                                        set("SV")
                                    end
                                end)
                            end
                        end)
                        hue_slider.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 and con then
                                con:Disconnect()
                                con = nil
                            end
                        end)
                    end
                    color_picker.MouseButton1Click:Connect(function()
                        local x  = uis:GetMouseLocation()
                        panel.Position = UDim2.fromOffset(x.X, x.Y + 36)
                        panel.Visible = true
                    end)
                    panel.HoverEnded:Connect(function()
                        panel.Visible = false
                    end)
                    setter["All"]()
                    color_picker.Parent = multi_element
                    panel.Parent = gui
                    return {
                        Set = function (color)
                            if start_color ~= color then
                                start_color = color
                                set("All")
                            end
                        end, GetColor = function()
                            return start_color
                        end
                    }
                end
            }
            end
        }
    end
    return {
        Tab = create_tab, 
        CreateUISettings = function()
            local ui_settings_tab = create_tab("UI Settings", "7059346373")
            local sadk = ui_settings_tab.MultiElement()
            sadk.Label("UI Keybind"); sadk.Keybind(default_keybind, function()
                gui.Enabled = not gui.Enabled
            end, function(keybind)
                gui_keybind_label.Text = better_get_string_for_keycode(keybind)
            end)
        end
    }
end
