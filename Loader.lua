repeat
    task.wait()
until game:IsLoaded()

local library
do
    local folder = "CannonCFG"
    local services = setmetatable({}, {
        __index = function(_, service)
            if service == "InputService" then
                return game:GetService("UserInputService")
            end

            return game:GetService(service)
        end
    })

    local utility = {}

    function utility.randomstring(length)
        local str = ""
        local chars = string.split("abcdefghijklmnopqrstuvwxyz1234567890", "")

        for i = 1, length do
            local i = math.random(1, #chars)

            if not tonumber(chars[i]) then
                local uppercase = math.random(1, 2) == 2 and true or false
                str = str .. (uppercase and chars[i]:upper() or chars[i])
            else
                str = str .. chars[i]
            end
        end

        return str
    end

    function utility.create(class, properties)
        local obj = Instance.new(class)

        local forced = {
            AutoButtonColor = false
        }

        for prop, v in next, properties do
            obj[prop] = v
        end

        for prop, v in next, forced do
            pcall(function()
                obj[prop] = v
            end)
        end

        obj.Name = utility.randomstring(16)

        return obj
    end

    function utility.dragify(object, speed)
        local start, objectPosition, dragging
        speed = speed or 0
        object.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = input.Position
                objectPosition = object.Position
            end
        end)

        object.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        services.InputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and dragging then
                utility.tween(object, { speed }, { Position = UDim2.new(objectPosition.X.Scale, objectPosition.X.Offset + (input.Position - start).X, objectPosition.Y.Scale, objectPosition.Y.Offset + (input.Position - start).Y) })
            end
        end)
    end

    function utility.getrgb(color)
        local r = math.floor(color.r * 255)
        local g = math.floor(color.g * 255)
        local b = math.floor(color.b * 255)

        return r, g, b
    end

    function utility.getcenter(sizeX, sizeY)
        return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
    end

    function utility.table(tbl)
        tbl = tbl or {}

        local newtbl = {}

        for i, v in next, tbl do
            if type(i) == "string" then
                newtbl[i:lower()] = v
            end
        end

        return setmetatable({}, {
            __newindex = function(_, k, v)
                rawset(newtbl, k:lower(), v)
            end,

            __index = function(_, k)
                return newtbl[k:lower()]
            end
        })
    end

    function utility.tween(obj, info, properties, callback)
        local anim = services.TweenService:Create(obj, TweenInfo.new(unpack(info)), properties)
        anim:Play()

        if callback then
            anim.Completed:Connect(callback)
        end

        return anim
    end

    function utility.makevisible(obj, bool)
        if bool == false then
            local tween

            if not obj.ClassName:find("UI") then
                if obj.ClassName:find("Text") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1, TextTransparency = obj.TextTransparency + 1, TextStrokeTransparency = obj.TextStrokeTransparency + 1 })
                elseif obj.ClassName:find("Image") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1, ImageTransparency = obj.ImageTransparency + 1 })
                elseif obj.ClassName:find("Scrolling") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1, ScrollBarImageTransparency = obj.ScrollBarImageTransparency + 1 })
                else
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1 })
                end
            end

            tween.Completed:Connect(function()
                obj.Visible = false
            end)

            for _, descendant in next, obj:GetDescendants() do
                if not descendant.ClassName:find("UI") then
                    if descendant.ClassName:find("Text") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1, TextTransparency = descendant.TextTransparency + 1, TextStrokeTransparency = descendant.TextStrokeTransparency + 1 })
                    elseif descendant.ClassName:find("Image") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1, ImageTransparency = descendant.ImageTransparency + 1 })
                    elseif descendant.ClassName:find("Scrolling") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1, ScrollBarImageTransparency = descendant.ScrollBarImageTransparency + 1 })
                    else
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1 })
                    end
                end
            end

            return tween
        elseif bool == true then
            local tween

            if not obj.ClassName:find("UI") then
                obj.Visible = true

                if obj.ClassName:find("Text") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1, TextTransparency = obj.TextTransparency - 1, TextStrokeTransparency = obj.TextStrokeTransparency - 1 })
                elseif obj.ClassName:find("Image") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1, ImageTransparency = obj.ImageTransparency - 1 })
                elseif obj.ClassName:find("Scrolling") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1, ScrollBarImageTransparency = obj.ScrollBarImageTransparency - 1 })
                else
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1 })
                end
            end

            for _, descendant in next, obj:GetDescendants() do
                if not descendant.ClassName:find("UI") then
                    if descendant.ClassName:find("Text") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1, TextTransparency = descendant.TextTransparency - 1, TextStrokeTransparency = descendant.TextStrokeTransparency - 1 })
                    elseif descendant.ClassName:find("Image") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1, ImageTransparency = descendant.ImageTransparency - 1 })
                    elseif descendant.ClassName:find("Scrolling") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1, ScrollBarImageTransparency = descendant.ScrollBarImageTransparency - 1 })
                    else
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1 })
                    end
                end
            end

            return tween
        end
    end

    function utility.updatescrolling(scrolling, list)
        return list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
        end)
    end

    function utility.changecolor(color, amount)
        local r, g, b = utility.getrgb(color)
        r = math.clamp(r + amount, 0, 255)
        g = math.clamp(g + amount, 0, 255)
        b = math.clamp(b + amount, 0, 255)

        return Color3.fromRGB(r, g, b)
    end

    function utility.gradient(colors)
        local colortbl = {}

        for i, color in next, colors do
            table.insert(colortbl, ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color))
        end

        return ColorSequence.new(colortbl)
    end

    library = utility.table {
        flags = {},
        toggled = true,
        accent = Color3.fromRGB(0,0,139),
        outline = { Color3.fromRGB(121, 66, 254), Color3.fromRGB(128,0,128) },
        keybind = Enum.KeyCode.RightShift
    }

    local accentobjects = { gradient = {}, bg = {}, text = {} }

    function library:ChangeAccent(accent)
        library.accent = accent

        for obj, color in next, accentobjects.gradient do
            obj.Color = color(accent)
        end

        for _, obj in next, accentobjects.bg do
            obj.BackgroundColor3 = accent
        end

        for _, obj in next, accentobjects.text do
            obj.TextColor3 = accent
        end
    end

    local outlineobjs = {}

    function library:ChangeOutline(colors)
        for _, obj in next, outlineobjs do
            obj.Color = utility.gradient(colors)
        end
    end

    local gui = utility.create("ScreenGui", {})

    local flags = {}

    function library:SaveConfig(name, universal)
        local configtbl = {}
        local placeid = universal and "universal" or game.PlaceId

        for flag, _ in next, flags do
            local value = library.flags[flag]
            if typeof(value) == "EnumItem" then
                configtbl[flag] = tostring(value)
            elseif typeof(value) == "Color3" then
                configtbl[flag] = { math.floor(value.R * 255), math.floor(value.G * 255), math.floor(value.B * 255) }
            else
                configtbl[flag] = value
            end
        end

        local config = services.HttpService:JSONEncode(configtbl)
        local folderpath = string.format("%s//%s", folder, placeid)

        if not isfolder(folderpath) then
            makefolder(folderpath)
        end

        local filepath = string.format("%s//%s.json", folderpath, name)
        writefile(filepath, config)
    end

    function library:DeleteConfig(name, universal)
        local placeid = universal and "universal" or game.PlaceId

        local folderpath = string.format("%s//%s", folder, placeid)

        if isfolder(folderpath) then
            local folderpath = string.format("%s//%s", folder, placeid)
            local filepath = string.format("%s//%s.json", folderpath, name)

            delfile(filepath)
        end
    end

    function library:LoadConfig(name)
        local placeidfolder = string.format("%s//%s", folder, game.PlaceId)
        local placeidfile = string.format("%s//%s.json", placeidfolder, name)

        local filepath
        do
            if isfolder(placeidfolder) and isfile(placeidfile) then
                filepath = placeidfile
            else
                filepath = string.format("%s//universal//%s.json", folder, name)
            end
        end

        local file = readfile(filepath)
        local config = services.HttpService:JSONDecode(file)

        for flag, v in next, config do
            local func = flags[flag]
            func(v)
        end
    end

    function library:ListConfigs(universal)
        local configs = {}
        local placeidfolder = string.format("%s//%s", folder, game.PlaceId)
        local universalfolder = folder .. "//universal"

        for _, config in next, (isfolder(placeidfolder) and listfiles(placeidfolder) or {}) do
            local name = config:gsub(placeidfolder .. "\\", ""):gsub(".json", "")
            table.insert(configs, name)
        end

        if universal and isfolder(universalfolder) then
            for _, config in next, (isfolder(placeidfolder) and listfiles(placeidfolder) or {}) do
                configs[config:gsub(universalfolder .. "\\", "")] = readfile(config)
            end
        end
        return configs
    end


    function library:New(options)
        options = utility.table(options)
        local name = options.name
        local accent = options.accent or library.accent
        local outlinecolor = options.outline or { accent, utility.changecolor(accent, -100) }
        local sizeX = options.sizeX or 550
        local sizeY = options.sizeY or 350

        library.accent = accent
        library.outline = outlinecolor

        local holder = utility.create("Frame", {
            Size = UDim2.new(0, sizeX, 0, 24),
            BackgroundTransparency = 1,
            Position = utility.getcenter(sizeX, sizeY),
            Parent = gui
        })

        local toggling = false
        function library:Toggle()
            if not toggling then
                toggling = true

                library.toggled = not library.toggled
                local tween = utility.makevisible(holder, library.toggled)
                tween.Completed:Wait()

                toggling = false
            end
        end

        utility.dragify(holder)

        local title = utility.create("TextLabel", {
            ZIndex = 5,
            Size = UDim2.new(0, 0, 1, -2),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            FontSize = Enum.FontSize.Size14,
            TextStrokeTransparency = 0,
            TextSize = 14,
            TextColor3 = library.accent,
            Text = name,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = holder
        })

        table.insert(accentobjects.text, title)

        local main = utility.create("Frame", {
            ZIndex = 2,
            Size = UDim2.new(1, 0, 0, sizeY),
            BorderColor3 = Color3.fromRGB(27, 42, 53),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Parent = holder
        })

        local outline = utility.create("Frame", {
            Size = UDim2.new(1, 2, 1, 2),
            BorderColor3 = Color3.fromRGB(45, 45, 45),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = main
        })

        local outlinegradient = utility.create("UIGradient", {
            Rotation = 45,
            Color = utility.gradient(library.outline),
            Parent = outline
        })

        table.insert(outlineobjs, outlinegradient)

        local border = utility.create("Frame", {
            ZIndex = 0,
            Size = UDim2.new(1, 2, 1, 2),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Parent = outline
        })

        local tabs = utility.create("Frame", {
            ZIndex = 4,
            Size = UDim2.new(1, -16, 1, -30),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            Position = UDim2.new(0, 8, 0, 22),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = main
        })

        utility.create("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(20, 20, 20)),
            Parent = tabs
        })

        utility.create("Frame", {
            ZIndex = 3,
            Size = UDim2.new(1, 2, 1, 2),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Parent = tabs
        })

        local tabtoggles = utility.create("Frame", {
            Size = UDim2.new(0, 395, 0, 22),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = tabs
        })

        utility.create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = tabtoggles
        })

        local tabframes = utility.create("Frame", {
            ZIndex = 5,
            Size = UDim2.new(1, -12, 1, -35),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            Position = UDim2.new(0, 6, 0, 29),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Parent = tabs
        })

        local tabholder = utility.create("Frame", {
            Size = UDim2.new(1, -16, 1, -16),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = tabframes
        })

        local windowtypes = utility.table()

        local pagetoggles = {}

        local switchingtabs = false

        local firsttab
        local currenttab

        function windowtypes:Page(options)
            options = utility.table(options)
            local name = options.name

            local first = #tabtoggles:GetChildren() == 1

            local togglesizeX = math.clamp(services.TextService:GetTextSize(name, 14, Enum.Font.Code, Vector2.new(1000, 1000)).X, 25, math.huge)

            local tabtoggle = utility.create("TextButton", {
                Size = UDim2.new(0, togglesizeX + 18, 1, 0),
                BackgroundTransparency = 1,
                FontSize = Enum.FontSize.Size14,
                TextSize = 14,
                Parent = tabtoggles
            })

            local antiborder = utility.create("Frame", {
                ZIndex = 6,
                Visible = first,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Parent = tabtoggle
            })

            local selectedglow = utility.create("Frame", {
                ZIndex = 6,
                Size = UDim2.new(1, 0, 0, 1),
                Visible = first,
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                BackgroundColor3 = library.accent,
                Parent = tabtoggle
            })

            table.insert(accentobjects.bg, selectedglow)

            utility.create("Frame", {
                ZIndex = 7,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Parent = selectedglow
            })

            local titleholder = utility.create("Frame", {
                ZIndex = 6,
                Size = UDim2.new(1, 0, 1, first and -1 or -4),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                Position = UDim2.new(0, 0, 0, first and 1 or 4),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tabtoggle
            })

            local title = utility.create("TextLabel", {
                ZIndex = 7,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                FontSize = Enum.FontSize.Size14,
                TextStrokeTransparency = 0,
                TextSize = 14,
                TextColor3 = first and library.accent or Color3.fromRGB(110, 110, 110),
                Text = name,
                Font = Enum.Font.Code,
                Parent = titleholder
            })

            if first then
                table.insert(accentobjects.text, title)
            end

            local tabglowgradient = utility.create("UIGradient", {
                Rotation = 90,
                Color = first and utility.gradient { utility.changecolor(library.accent, -30), Color3.fromRGB(30, 30, 30) } or utility.gradient { Color3.fromRGB(22, 22, 22), Color3.fromRGB(22, 22, 22) },
                Offset = Vector2.new(0, -0.55),
                Parent = titleholder
            })

            if first then
                accentobjects.gradient[tabglowgradient] = function(color)
                    return utility.gradient { utility.changecolor(color, -30), Color3.fromRGB(30, 30, 30) }
                end
            end

            local tabtoggleborder = utility.create("Frame", {
                ZIndex = 5,
                Size = UDim2.new(1, 2, 1, 2),
                Position = UDim2.new(0, -1, 0, -1),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Parent = title
            })

            pagetoggles[tabtoggle] = {}
            pagetoggles[tabtoggle] = function()
                utility.tween(antiborder, { 0.2 }, { BackgroundTransparency = 1 }, function()
                    antiborder.Visible = false
                end)

                utility.tween(selectedglow, { 0.2 }, { BackgroundTransparency = 1 }, function()
                    selectedglow.Visible = false
                end)

                utility.tween(titleholder, { 0.2 }, { Size = UDim2.new(1, 0, 1, -4), Position = UDim2.new(0, 0, 0, 4) })

                utility.tween(title, { 0.2 }, { TextColor3 = Color3.fromRGB(110, 110, 110) })
                if table.find(accentobjects.text, title) then
                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                end

                tabglowgradient.Color = utility.gradient { Color3.fromRGB(22, 22, 22), Color3.fromRGB(22, 22, 22) }

                if accentobjects.gradient[tabglowgradient] then
                    accentobjects.gradient[tabglowgradient] = function() end
                end
            end

            local tab = utility.create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = first and 1 or 2,
                Visible = first,
                Parent = tabholder
            })

            if first then
                currenttab = tab
                firsttab = tab
            end

            tab.DescendantAdded:Connect(function(descendant)
                if tab ~= currenttab then
                    task.wait()
                    if not descendant.ClassName:find("UI") then
                        if descendant.ClassName:find("Text") then
                            descendant.TextTransparency = descendant.TextTransparency + 1
                            descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                        end

                        if descendant.ClassName:find("Scrolling") then
                            descendant.ScrollBarImageTransparency = descendant.ScrollBarImageTransparency + 1
                        end

                        descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                    end
                end
            end)

            local column1 = utility.create("ScrollingFrame", {
                Size = UDim2.new(0.5, -5, 1, 0),
                BackgroundTransparency = 1,
                Active = true,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 123),
                ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                ScrollBarThickness = 0,
                Parent = tab
            })

            local column1list = utility.create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = column1
            })

            utility.updatescrolling(column1, column1list)

            local column2 = utility.create("ScrollingFrame", {
                Size = UDim2.new(0.5, -5, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 7, 0, 0),
                Active = true,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                ScrollBarThickness = 0,
                Parent = tab
            })

            local column2list = utility.create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = column2
            })

            utility.updatescrolling(column2, column2list)

            local function opentab()
                if not switchingtabs then
                    switchingtabs = true

                    currenttab = tab

                    for toggle, close in next, pagetoggles do
                        if toggle ~= tabtoggle then
                            close()
                        end
                    end

                    for _, obj in next, tabholder:GetChildren() do
                        if obj ~= tab and obj.BackgroundTransparency <= 1 then
                            utility.makevisible(obj, false)
                        end
                    end

                    antiborder.Visible = true
                    utility.tween(antiborder, { 0.2 }, { BackgroundTransparency = 0 })

                    selectedglow.Visible = true
                    utility.tween(selectedglow, { 0.2 }, { BackgroundTransparency = 0 })

                    utility.tween(titleholder, { 0.2 }, { Size = UDim2.new(1, 0, 1, -1), Position = UDim2.new(0, 0, 0, 1) })

                    utility.tween(title, { 0.2 }, { TextColor3 = library.accent })

                    table.insert(accentobjects.text, title)

                    tabglowgradient.Color = utility.gradient { utility.changecolor(library.accent, -30), Color3.fromRGB(30, 30, 30) }

                    accentobjects.gradient[tabglowgradient] = function(color)
                        return utility.gradient { utility.changecolor(color, -30), Color3.fromRGB(30, 30, 30) }
                    end

                    tab.Visible = true
                    if tab.BackgroundTransparency > 1 then
                        task.wait(0.2)

                        local tween = utility.makevisible(tab, true)
                        tween.Completed:Wait()
                    end

                    switchingtabs = false
                end
            end

            tabtoggle.MouseButton1Click:Connect(opentab)

            local pagetypes = utility.table()

            function pagetypes:Section(options)
                options = utility.table(options)
                local name = options.name
                local side = options.side or "left"
                local max = options.max or math.huge
                local column = (side:lower() == "left" and column1) or (side:lower() == "right" and column2)

                local sectionholder = utility.create("Frame", {
                    Size = UDim2.new(1, -1, 0, 28),
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = column
                })

                local section = utility.create("Frame", {
                    ZIndex = 6,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderColor3 = Color3.fromRGB(50, 50, 50),
                    Position = UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                    Parent = sectionholder
                })

                local title = utility.create("TextLabel", {
                    ZIndex = 8,
                    Size = UDim2.new(0, 0, 0, 14),
                    BorderColor3 = Color3.fromRGB(50, 50, 50),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 3),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    FontSize = Enum.FontSize.Size14,
                    TextStrokeTransparency = 0,
                    TextSize = 14,
                    TextColor3 = library.accent,
                    Text = name,
                    Font = Enum.Font.Code,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = section
                })

                table.insert(accentobjects.text, title)

                local glow = utility.create("Frame", {
                    ZIndex = 8,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderColor3 = Color3.fromRGB(50, 50, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = library.accent,
                    Parent = section
                })

                table.insert(accentobjects.bg, glow)

                utility.create("Frame", {
                    ZIndex = 9,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    Parent = glow
                })

                local fade = utility.create("Frame", {
                    ZIndex = 7,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = glow
                })

                local fadegradient = utility.create("UIGradient", {
                    Rotation = 90,
                    Color = utility.gradient { utility.changecolor(library.accent, -30), Color3.fromRGB(22, 22, 22) },
                    Offset = Vector2.new(0, -0.55),
                    Parent = fade
                })

                accentobjects.gradient[fadegradient] = function(color)
                    return utility.gradient { utility.changecolor(color, -30), Color3.fromRGB(22, 22, 22) }
                end

                local sectioncontent = utility.create("ScrollingFrame", {
                    ZIndex = 7,
                    Size = UDim2.new(1, -7, 1, -26),
                    BorderColor3 = Color3.fromRGB(27, 42, 53),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 20),
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    CanvasSize = UDim2.new(0, 0, 0, 1),
                    ScrollBarThickness = 2,
                    Parent = section
                })

                local sectionlist = utility.create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = sectioncontent
                })

                utility.updatescrolling(sectioncontent, sectionlist)

                local sectiontypes = utility.table()

                function sectiontypes:Label(options)
                    options = utility.table(options)
                    local name = options.name

                    utility.create("TextLabel", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 0, 0, 13),
                        BorderColor3 = Color3.fromRGB(50, 50, 50),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 6, 0, 3),
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = sectioncontent
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end
                end

                function sectiontypes:Button(options)
                    options = utility.table(options)
                    local name = options.name
                    local callback = options.callback

                    local buttonholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 17),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    local button = utility.create("TextButton", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 1, -4),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 2),
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        AutoButtonColor = false,
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        Parent = buttonholder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = button
                    })

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = bg
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = button
                    })

                    local blackborder = utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    button.MouseButton1Click:Connect(callback)

                    button.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            bggradient.Color = utility.gradient { Color3.fromRGB(45, 45, 45), Color3.fromRGB(35, 35, 35) }
                        end
                    end)

                    button.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            bggradient.Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) }
                        end
                    end)

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end
                end

                function sectiontypes:Toggle(options)
                    options = utility.table(options)
                    local name = options.name
                    local default = options.default
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local toggleholder = utility.create("TextButton", {
                        Size = UDim2.new(1, -5, 0, 14),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 14,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = sectioncontent
                    })

                    local togglething = utility.create("TextButton", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 0, 14),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        TextTransparency = 1,
                        Parent = toggleholder
                    })

                    local icon = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(0, 10, 0, 10),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        Position = UDim2.new(0, 2, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = toggleholder
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = icon
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local icongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = icon
                    })

                    local enablediconholder = utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = icon
                    })

                    local enabledicongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                        Parent = enablediconholder
                    })

                    accentobjects.gradient[enabledicongradient] = function(color)
                        return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                    end

                    local title = utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 20, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = toggleholder
                    })

                    local toggled = false

                    if flag then
                        library.flags[flag] = toggled
                    end

                    local function toggle()
                        if not switchingtabs then
                            toggled = not toggled

                            if flag then
                                library.flags[flag] = toggled
                            end

                            callback(toggled)

                            local enabledtransparency = toggled and 0 or 1
                            utility.tween(enablediconholder, { 0.2 }, { Transparency = enabledtransparency })

                            local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                            utility.tween(title, { 0.2 }, { TextColor3 = textcolor })

                            if toggled then
                                table.insert(accentobjects.text, title)
                            elseif table.find(accentobjects.text, title) then
                                table.remove(accentobjects.text, table.find(accentobjects.text, title))
                            end
                        end
                    end

                    togglething.MouseButton1Click:Connect(toggle)

                    local function set(bool)
                        if type(bool) == "boolean" and toggled ~= bool then
                            toggle()
                        end
                    end

                    if default then
                        set(default)
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local toggletypes = utility.table()

                    function toggletypes:Toggle(bool)
                        set(bool)
                    end

                    function toggletypes:Colorpicker(newoptions)
                        newoptions = utility.table(newoptions)
                        local name = newoptions.name
                        local default = newoptions.default or Color3.fromRGB(255, 255, 255)
                        local colorpickertype = newoptions.mode
                        local toggleflag = colorpickertype and colorpickertype:lower() == "toggle" and newoptions.togglepointer
                        local togglecallback = colorpickertype and colorpickertype:lower() == "toggle" and newoptions.togglecallback or function() end
                        local flag = newoptions.pointer
                        local callback = newoptions.callback or function() end

                        local colorpickerframe = utility.create("Frame", {
                            ZIndex = 9,
                            Size = UDim2.new(1, -70, 0, 148),
                            Position = UDim2.new(1, -168, 0, 18),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Visible = false,
                            Parent = toggleholder
                        })

                        colorpickerframe.DescendantAdded:Connect(function(descendant)
                            if not opened then
                                task.wait()
                                if not descendant.ClassName:find("UI") then
                                    if descendant.ClassName:find("Text") then
                                        descendant.TextTransparency = descendant.TextTransparency + 1
                                        descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                                    end

                                    if descendant.ClassName:find("Image") then
                                        descendant.ImageTransparency = descendant.ImageTransparency + 1
                                    end

                                    descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                                end
                            end
                        end)

                        local bggradient = utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                            Parent = colorpickerframe
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 8,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            Parent = colorpickerframe
                        })

                        local blackborder = utility.create("Frame", {
                            ZIndex = 7,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local saturationframe = utility.create("ImageLabel", {
                            ZIndex = 12,
                            Size = UDim2.new(0, 128, 0, 100),
                            BorderColor3 = Color3.fromRGB(50, 50, 50),
                            Position = UDim2.new(0, 6, 0, 6),
                            BorderSizePixel = 0,
                            BackgroundColor3 = default,
                            Image = "http://www.roblox.com/asset/?id=8630797271",
                            Parent = colorpickerframe
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            Parent = saturationframe
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local saturationpicker = utility.create("Frame", {
                            ZIndex = 13,
                            Size = UDim2.new(0, 2, 0, 2),
                            BorderColor3 = Color3.fromRGB(10, 10, 10),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = saturationframe
                        })

                        local hueframe = utility.create("ImageLabel", {
                            ZIndex = 12,
                            Size = UDim2.new(0, 14, 0, 100),
                            Position = UDim2.new(1, -20, 0, 6),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 193, 49),
                            ScaleType = Enum.ScaleType.Crop,
                            Image = "http://www.roblox.com/asset/?id=8630799159",
                            Parent = colorpickerframe
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            Parent = hueframe
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local huepicker = utility.create("Frame", {
                            ZIndex = 13,
                            Size = UDim2.new(1, 0, 0, 1),
                            BorderColor3 = Color3.fromRGB(10, 10, 10),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = hueframe
                        })

                        local boxholder = utility.create("Frame", {
                            Size = UDim2.new(1, -8, 0, 17),
                            ClipsDescendants = true,
                            Position = UDim2.new(0, 4, 0, 110),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = colorpickerframe
                        })

                        local box = utility.create("TextBox", {
                            ZIndex = 13,
                            Size = UDim2.new(1, -4, 1, -4),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 2, 0, 2),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextStrokeTransparency = 0,
                            TextSize = 13,
                            TextColor3 = Color3.fromRGB(210, 210, 210),
                            Text = table.concat({ utility.getrgb(default) }, ", "),
                            PlaceholderText = "R, G, B",
                            Font = Enum.Font.Code,
                            Parent = boxholder
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            Parent = box
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local bg = utility.create("Frame", {
                            ZIndex = 12,
                            Size = UDim2.new(1, 0, 1, 0),
                            BorderColor3 = Color3.fromRGB(40, 40, 40),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = box
                        })

                        utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                            Parent = bg
                        })

                        local rainbowtoggleholder = utility.create("TextButton", {
                            Size = UDim2.new(1, -8, 0, 14),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 4, 0, 130),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextSize = 14,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            Font = Enum.Font.SourceSans,
                            Parent = colorpickerframe
                        })

                        local toggleicon = utility.create("Frame", {
                            ZIndex = 12,
                            Size = UDim2.new(0, 10, 0, 10),
                            BorderColor3 = Color3.fromRGB(40, 40, 40),
                            Position = UDim2.new(0, 2, 0, 2),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = rainbowtoggleholder
                        })

                        local enablediconholder = utility.create("Frame", {
                            ZIndex = 13,
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = toggleicon
                        })

                        local enabledicongradient = utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                            Parent = enablediconholder
                        })

                        accentobjects.gradient[enabledicongradient] = function(color)
                            return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                        end

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            Parent = toggleicon
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                            Parent = toggleicon
                        })

                        local rainbowtxt = utility.create("TextLabel", {
                            ZIndex = 10,
                            Size = UDim2.new(0, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 20, 0, 0),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextStrokeTransparency = 0,
                            TextSize = 13,
                            TextColor3 = Color3.fromRGB(180, 180, 180),
                            Text = "Rainbow",
                            Font = Enum.Font.Code,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = rainbowtoggleholder
                        })

                        local colorpicker = utility.create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 14),
                            BackgroundTransparency = 1,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextSize = 14,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            Font = Enum.Font.SourceSans,
                            Parent = toggleholder
                        })

                        local icon = utility.create("TextButton", {
                            ZIndex = 9,
                            Size = UDim2.new(0, 18, 0, 10),
                            BorderColor3 = Color3.fromRGB(40, 40, 40),
                            Position = UDim2.new(1, -20, 0, 2),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = colorpicker,
                            Text = ""
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 8,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            Parent = icon
                        })

                        utility.create("Frame", {
                            ZIndex = 7,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local icongradient = utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { default, utility.changecolor(default, -200) },
                            Parent = icon
                        })

                        if #sectioncontent:GetChildren() - 1 <= max then
                            sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                        end

                        local colorpickertypes = utility.table()

                        local opened = false
                        local opening = false

                        local function opencolorpicker()
                            if not opening then
                                opening = true

                                opened = not opened

                                if opened then
                                    utility.tween(toggleholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 168) })
                                end

                                local tween = utility.makevisible(colorpickerframe, opened)

                                tween.Completed:Wait()

                                if not opened then
                                    local tween = utility.tween(toggleholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 16) })
                                    tween.Completed:Wait()
                                end

                                opening = false
                            end
                        end

                        icon.MouseButton1Click:Connect(opencolorpicker)

                        local hue, sat, val = default:ToHSV()

                        local slidinghue = false
                        local slidingsaturation = false

                        local hsv = Color3.fromHSV(hue, sat, val)

                        if flag then
                            library.flags[flag] = default
                        end

                        local function updatehue(input)
                            local sizeY = 1 - math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
                            local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y, 0, hueframe.AbsoluteSize.Y - 2)
                            huepicker.Position = UDim2.new(0, 0, 0, posY)

                            hue = sizeY
                            hsv = Color3.fromHSV(sizeY, sat, val)

                            box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                            saturationframe.BackgroundColor3 = hsv
                            icon.BackgroundColor3 = hsv

                            if flag then
                                library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                            end

                            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                        end

                        hueframe.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidinghue = true
                                updatehue(input)
                            end
                        end)

                        hueframe.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidinghue = false
                            end
                        end)

                        services.InputService.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                if slidinghue then
                                    updatehue(input)
                                end
                            end
                        end)

                        local function updatesatval(input)
                            local sizeX = math.clamp((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X, 0, 1)
                            local sizeY = 1 - math.clamp((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y, 0, 1)
                            local posY = math.clamp(((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)
                            local posX = math.clamp(((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X) * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)

                            saturationpicker.Position = UDim2.new(0, posX, 0, posY)

                            sat = sizeX
                            val = sizeY
                            hsv = Color3.fromHSV(hue, sizeX, sizeY)

                            box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                            saturationframe.BackgroundColor3 = hsv
                            icon.BackgroundColor3 = hsv

                            if flag then
                                library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                            end

                            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                        end

                        saturationframe.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidingsaturation = true
                                updatesatval(input)
                            end
                        end)

                        saturationframe.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidingsaturation = false
                            end
                        end)

                        services.InputService.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                if slidingsaturation then
                                    updatesatval(input)
                                end
                            end
                        end)

                        local function set(color)
                            if type(color) == "table" then
                                color = Color3.fromRGB(unpack(color))
                            end

                            hue, sat, val = color:ToHSV()
                            hsv = Color3.fromHSV(hue, sat, val)

                            saturationframe.BackgroundColor3 = hsv
                            icon.BackgroundColor3 = hsv
                            saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)), 0, (math.clamp((1 - val) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)))
                            huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4))

                            box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                            if flag then
                                library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                            end

                            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                        end

                        local toggled = false

                        local function toggle()
                            if not switchingtabs then
                                toggled = not toggled

                                if toggled then
                                    task.spawn(function()
                                        while toggled do
                                            for i = 0, 1, 0.0015 do
                                                if not toggled then
                                                    return
                                                end

                                                local color = Color3.fromHSV(i, 1, 1)
                                                set(color)

                                                task.wait()
                                            end
                                        end
                                    end)
                                end

                                local enabledtransparency = toggled and 0 or 1
                                utility.tween(enablediconholder, { 0.2 }, { BackgroundTransparency = enabledtransparency })

                                local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                                utility.tween(rainbowtxt, { 0.2 }, { TextColor3 = textcolor })

                                if toggled then
                                    table.insert(accentobjects.text, title)
                                elseif table.find(accentobjects.text, title) then
                                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                                end
                            end
                        end

                        rainbowtoggleholder.MouseButton1Click:Connect(toggle)

                        box.FocusLost:Connect(function()
                            local _, amount = box.Text:gsub(", ", "")

                            if amount == 2 then
                                local values = box.Text:split(", ")
                                local r, g, b = math.clamp(values[1], 0, 255), math.clamp(values[2], 0, 255), math.clamp(values[3], 0, 255)
                                set(Color3.fromRGB(r, g, b))
                            else
                                rgb.Text = math.floor((hsv.r * 255) + 0.5) .. ", " .. math.floor((hsv.g * 255) + 0.5) .. ", " .. math.floor((hsv.b * 255) + 0.5)
                            end
                        end)

                        if default then
                            set(default)
                        end

                        if flag then
                            flags[flag] = set
                        end

                        local colorpickertypes = utility.table()

                        function colorpickertypes:Set(color)
                            set(color)
                        end
                    end

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    return toggletypes
                end

                function sectiontypes:Box(options)
                    options = utility.table(options)
                    local name = options.name
                    local placeholder = options.placeholder or ""
                    local default = options.default
                    local boxtype = options.type or "string"
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local boxholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 32),
                        ClipsDescendants = true,
                        BorderColor3 = Color3.fromRGB(27, 42, 53),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = boxholder
                    })

                    local box = utility.create("TextBox", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 17),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = "",
                        PlaceholderText = placeholder,
                        Font = Enum.Font.Code,
                        Parent = boxholder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = box
                    })

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = bg
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = box
                    })

                    local blackborder = utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    if flag then
                        library.flags[flag] = default or ""
                    end

                    local function set(str)
                        if boxtype:lower() == "number" then
                            str = str:gsub("%D+", "")
                        end

                        box.Text = str

                        if flag then
                            library.flags[flag] = str
                        end

                        callback(str)
                    end

                    if default then
                        set(default)
                    end

                    if boxtype:lower() == "number" then
                        box:GetPropertyChangedSignal("Text"):Connect(function()
                            box.Text = box.Text:gsub("%D+", "")
                        end)
                    end

                    box.FocusLost:Connect(function()
                        set(box.Text)
                    end)

                    if flag then
                        flags[flag] = set
                    end

                    local boxtypes = utility.table()

                    function boxtypes:Set(str)
                        set(str)
                    end

                    return boxtypes
                end

                function sectiontypes:Slider(options)
                    options = utility.table(options)
                    local name = options.name
                    local min = options.minimum or 0
                    local slidermax = options.maximum or 100
                    local valuetext = options.value or "[value]/" .. slidermax
                    local increment = options.decimals or 0.5
                    local default = options.default and math.clamp(options.default, min, slidermax) or min
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local sliderholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 28),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    local slider = utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 0, 9),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 1, -11),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sliderholder
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = slider
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = slider
                    })

                    utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = bg
                    })

                    local fill = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new((default - min) / (slidermax - min), 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = slider
                    })

                    local fillgradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                        Parent = fill
                    })

                    accentobjects.gradient[fillgradient] = function(color)
                        return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                    end

                    local valuelabel = utility.create("TextLabel", {
                        ZIndex = 12,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = valuetext:gsub("%[value%]", tostring(default)),
                        Font = Enum.Font.Code,
                        Parent = slider
                    })

                    utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = sliderholder
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local sliding = false

                    local function slide(input)
                        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local newincrement = (slidermax / ((slidermax - min) / (increment * 4)))
                        local newsizeX = math.floor(sizeX * (((slidermax - min) / newincrement) * 4)) / (((slidermax - min) / newincrement) * 4)

                        utility.tween(fill, { newincrement / 80 }, { Size = UDim2.new(newsizeX, 0, 1, 0) })

                        local value = math.floor((newsizeX * (slidermax - min) + min) * 20) / 20
                        valuelabel.Text = valuetext:gsub("%[value%]", tostring(value))

                        if flag then
                            library.flags[flag] = value
                        end

                        callback(value)
                    end

                    slider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = true
                            slide(input)
                        end
                    end)

                    slider.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = false
                        end
                    end)

                    services.InputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            if sliding then
                                slide(input)
                            end
                        end
                    end)

                    local function set(value)
                        value = math.clamp(value, min, slidermax)

                        local sizeX = ((value - min)) / (slidermax - min)
                        local newincrement = (slidermax / ((slidermax - min) / (increment * 4)))

                        local newsizeX = math.floor(sizeX * (((slidermax - min) / newincrement) * 4)) / (((slidermax - min) / newincrement) * 4)
                        value = math.floor((newsizeX * (slidermax - min) + min) * 20) / 20

                        fill.Size = UDim2.new(newsizeX, 0, 1, 0)
                        valuelabel.Text = valuetext:gsub("%[value%]", tostring(value))

                        if flag then
                            library.flags[flag] = value
                        end

                        callback(value)
                    end

                    if default then
                        set(default)
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local slidertypes = utility.table()

                    function slidertypes:Set(value)
                        set(value)
                    end

                    return slidertypes
                end

                function sectiontypes:Dropdown(options)
                    options = utility.table(options)
                    local name = options.name
                    local content = options["options"]
                    local maxoptions = options.maximum and (options.maximum > 1 and options.maximum)
                    local default = options.default or maxoptions and {}
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    if maxoptions then
                        for i, def in next, default do
                            if not table.find(content, def) then
                                table.remove(default, i)
                            end
                        end
                    else
                        if not table.find(content, default) then
                            default = nil
                        end
                    end

                    local defaulttext = default and ((type(default) == "table" and table.concat(default, ", ")) or default)

                    local opened = false

                    local dropdownholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 32),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    local dropdown = utility.create("TextButton", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 0, 13),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 17),
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        AutoButtonColor = false,
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = default and (defaulttext ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(120, 120, 120)) or Color3.fromRGB(120, 120, 120),
                        Text = default and (defaulttext ~= "" and defaulttext or "NONE") or "NONE",
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = dropdownholder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 6, 1, 0),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        Position = UDim2.new(0, -6, 0, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = dropdown
                    })

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = bg
                    })

                    local textpadding = utility.create("UIPadding", {
                        PaddingLeft = UDim.new(0, 6),
                        Parent = dropdown
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 8, 1, 2),
                        Position = UDim2.new(0, -7, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = dropdown
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local icon = utility.create("TextLabel", {
                        ZIndex = 11,
                        Size = UDim2.new(0, 13, 1, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -13, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size12,
                        TextStrokeTransparency = 0,
                        TextSize = 12,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = "+",
                        Font = Enum.Font.Gotham,
                        Parent = dropdown
                    })

                    utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = dropdownholder
                    })

                    local contentframe = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, -4, 1, -38),
                        Position = UDim2.new(0, 2, 0, 36),
                        BorderSizePixel = 0,
                        Visible = false,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = dropdownholder
                    })

                    local opened = false
                    contentframe.DescendantAdded:Connect(function(descendant)
                        if not opened then
                            task.wait()
                            if not descendant.ClassName:find("UI") then
                                if descendant.ClassName:find("Text") then
                                    descendant.TextTransparency = descendant.TextTransparency + 1
                                    descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                                end

                                descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                            end
                        end
                    end)

                    local contentframegradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = contentframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = contentframe
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local dropdowncontent = utility.create("Frame", {
                        Size = UDim2.new(1, -2, 1, -2),
                        Position = UDim2.new(0, 1, 0, 1),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = contentframe
                    })

                    local dropdowncontentlist = utility.create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 2),
                        Parent = dropdowncontent
                    })

                    local option = utility.create("TextButton", {
                        ZIndex = 12,
                        Size = UDim2.new(1, 0, 0, 16),
                        BorderColor3 = Color3.fromRGB(50, 50, 50),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        AutoButtonColor = false,
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                        Text = "",
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })

                    utility.create("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = option
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local opening = false

                    local function opendropdown()
                        if not opening then
                            opening = true

                            opened = not opened

                            utility.tween(icon, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                icon.Text = opened and "-" or "+"
                            end)

                            if opened then
                                utility.tween(dropdownholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, dropdowncontentlist.AbsoluteContentSize.Y + 40) })
                            end

                            local tween = utility.makevisible(contentframe, opened)

                            tween.Completed:Wait()

                            if not opened then
                                local tween = utility.tween(dropdownholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 32) })
                                tween.Completed:Wait()
                            end

                            utility.tween(icon, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0 })

                            opening = false
                        end
                    end

                    dropdown.MouseButton1Click:Connect(opendropdown)

                    local chosen = maxoptions and {}
                    local choseninstances = {}
                    local optioninstances = {}

                    if flag then
                        library.flags[flag] = default
                    end

                    for _, opt in next, content do
                        if not maxoptions then
                            local optionbtn = option:Clone()
                            optionbtn.Parent = dropdowncontent
                            optionbtn.Text = opt

                            optioninstances[opt] = optionbtn

                            if default == opt then
                                chosen = opt
                                optionbtn.BackgroundTransparency = 0
                                optionbtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                            end

                            optionbtn.MouseButton1Click:Connect(function()
                                if chosen ~= opt then
                                    for _, optbtn in next, dropdowncontent:GetChildren() do
                                        if optbtn ~= optionbtn and optbtn:IsA("TextButton") then
                                            utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                        end
                                    end

                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = opt
                                    end)

                                    chosen = opt

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    if flag then
                                        library.flags[flag] = opt
                                    end

                                    callback(opt)
                                else
                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = "NONE"
                                    end)

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                    chosen = nil

                                    if flag then
                                        library.flags[flag] = nil
                                    end

                                    callback(nil)
                                end
                            end)
                        else
                            local optionbtn = option:Clone()
                            optionbtn.Parent = dropdowncontent
                            optionbtn.Text = opt

                            optioninstances[opt] = optionbtn

                            if table.find(default, opt) then
                                chosen = opt
                                optionbtn.BackgroundTransparency = 0
                                optionbtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                            end

                            optionbtn.MouseButton1Click:Connect(function()
                                if not table.find(chosen, opt) then
                                    if #chosen >= maxoptions then
                                        table.remove(chosen, 1)
                                        utility.tween(choseninstances[1], { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                        table.remove(choseninstances, 1)
                                    end

                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    table.insert(chosen, opt)
                                    table.insert(choseninstances, optionbtn)

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = table.concat(chosen, ", ")
                                    end)

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    if flag then
                                        library.flags[flag] = chosen
                                    end

                                    callback(chosen)
                                else
                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                    table.remove(chosen, table.find(chosen, opt))
                                    table.remove(choseninstances, table.find(choseninstances, optionbtn))

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = table.concat(chosen, ", ") ~= "" and table.concat(chosen, ", ") or "NONE"
                                    end)

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = table.concat(chosen, ", ") ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(150, 150, 150) })

                                    if flag then
                                        library.flags[flag] = chosen
                                    end

                                    callback(chosen)
                                end
                            end)
                        end
                    end

                    local function set(opt)
                        if not maxoptions then
                            if optioninstances[opt] then
                                for _, optbtn in next, dropdowncontent:GetChildren() do
                                    if optbtn ~= optioninstances[opt] and optbtn:IsA("TextButton") then
                                        utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                    end
                                end

                                utility.tween(optioninstances[opt], { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                    dropdown.Text = opt
                                end)

                                chosen = opt

                                tween.Completed:Wait()

                                utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                if flag then
                                    library.flags[flag] = opt
                                end

                                callback(opt)
                            else
                                for _, optbtn in next, dropdowncontent:GetChildren() do
                                    if optbtn:IsA("TextButton") then
                                        utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                    end
                                end

                                local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                    dropdown.Text = "NONE"
                                end)

                                tween.Completed:Wait()

                                utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                chosen = nil

                                if flag then
                                    library.flags[flag] = nil
                                end

                                callback(nil)
                            end
                        else
                            table.clear(chosen)
                            table.clear(choseninstances)

                            if not opt then
                                local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                    dropdown.Text = table.concat(chosen, ", ") ~= "" and table.concat(chosen, ", ") or "NONE"
                                end)

                                tween.Completed:Wait()

                                utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = table.concat(chosen, ", ") ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(150, 150, 150) })

                                if flag then
                                    library.flags[flag] = chosen
                                end

                                callback(chosen)
                            else
                                for _, opti in next, opt do
                                    if optioninstances[opti] then
                                        if #chosen >= maxoptions then
                                            table.remove(chosen, 1)
                                            utility.tween(choseninstances[1], { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                            table.remove(choseninstances, 1)
                                        end

                                        utility.tween(optioninstances[opti], { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if not table.find(chosen, opti) then
                                            table.insert(chosen, opti)
                                        end

                                        if not table.find(choseninstances, opti) then
                                            table.insert(choseninstances, optioninstances[opti])
                                        end

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = table.concat(chosen, ", ")
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if flag then
                                            library.flags[flag] = chosen
                                        end

                                        callback(chosen)
                                    end
                                end
                            end
                        end
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local dropdowntypes = utility.table()

                    function dropdowntypes:Set(option)
                        set(option)
                    end

                    function dropdowntypes:Refresh(content)
                        if maxoptions then
                            table.clear(chosen)
                        end

                        table.clear(choseninstances)
                        table.clear(optioninstances)

                        for _, optbtn in next, dropdowncontent:GetChildren() do
                            if optbtn:IsA("TextButton") then
                                optbtn:Destroy()
                            end
                        end

                        set()

                        for _, opt in next, content do
                            if not maxoptions then
                                local optionbtn = option:Clone()
                                optionbtn.Parent = dropdowncontent
                                optionbtn.BackgroundTransparency = 2
                                optionbtn.Text = opt
                                optionbtn.TextTransparency = 1
                                optionbtn.TextStrokeTransparency = 1

                                optioninstances[opt] = optionbtn

                                optionbtn.MouseButton1Click:Connect(function()
                                    if chosen ~= opt then
                                        for _, optbtn in next, dropdowncontent:GetChildren() do
                                            if optbtn ~= optionbtn and optbtn:IsA("TextButton") then
                                                utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                            end
                                        end

                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = opt
                                        end)

                                        chosen = opt

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if flag then
                                            library.flags[flag] = opt
                                        end

                                        callback(opt)
                                    else
                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = "NONE"
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                        chosen = nil

                                        if flag then
                                            library.flags[flag] = nil
                                        end

                                        callback(nil)
                                    end
                                end)
                            else
                                local optionbtn = option:Clone()
                                optionbtn.Parent = dropdowncontent
                                optionbtn.Text = opt

                                optioninstances[opt] = optionbtn

                                if table.find(default, opt) then
                                    chosen = opt
                                    optionbtn.BackgroundTransparency = 0
                                    optionbtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                                end

                                optionbtn.MouseButton1Click:Connect(function()
                                    if not table.find(chosen, opt) then
                                        if #chosen >= maxoptions then
                                            table.remove(chosen, 1)
                                            utility.tween(choseninstances[1], { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                            table.remove(choseninstances, 1)
                                        end

                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        table.insert(chosen, opt)
                                        table.insert(choseninstances, optionbtn)

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = table.concat(chosen, ", ")
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if flag then
                                            library.flags[flag] = chosen
                                        end

                                        callback(chosen)
                                    else
                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                        table.remove(chosen, table.find(chosen, opt))
                                        table.remove(choseninstances, table.find(choseninstances, optionbtn))

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = table.concat(chosen, ", ") ~= "" and table.concat(chosen, ", ") or "NONE"
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = table.concat(chosen, ", ") ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(150, 150, 150) })

                                        if flag then
                                            library.flags[flag] = chosen
                                        end

                                        callback(chosen)
                                    end
                                end)
                            end
                        end
                    end

                    return dropdowntypes
                end

                function sectiontypes:Multibox(options)
                    local newoptions = {}
                    for i, v in next, options do
                        newoptions[i:lower()] = v
                    end

                    newoptions.maximum = newoptions.maximum or math.huge
                    return sectiontypes:Dropdown(newoptions)
                end

                function sectiontypes:Keybind(options)
                    options = utility.table(options)
                    local name = options.name
                    local keybindtype = options.mode
                    local default = options.default
                    local toggledefault = keybindtype and keybindtype:lower() == "toggle" and options.toggledefault
                    local toggleflag = keybindtype and keybindtype:lower() == "toggle" and options.togglepointer
                    local togglecallback = keybindtype and keybindtype:lower() == "toggle" and options.togglecallback or function() end
                    local holdflag = keybindtype and keybindtype:lower() == "hold" and options.holdflag
                    local holdcallback = keybindtype and keybindtype:lower() == "hold" and options.holdcallback or function() end
                    local blacklist = options.blacklist or {}
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    table.insert(blacklist, Enum.UserInputType.Focus)

                    local keybindholder = utility.create("TextButton", {
                        Size = UDim2.new(1, -5, 0, 14),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 14,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = sectioncontent
                    })

                    local icon, grayborder, enablediconholder
                    do
                        if keybindtype and keybindtype:lower() == "toggle" then
                            icon = utility.create("Frame", {
                                ZIndex = 9,
                                Size = UDim2.new(0, 10, 0, 10),
                                BorderColor3 = Color3.fromRGB(40, 40, 40),
                                Position = UDim2.new(0, 2, 0, 2),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = keybindholder
                            })

                            grayborder = utility.create("Frame", {
                                ZIndex = 8,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                                Parent = icon
                            })

                            utility.create("UIGradient", {
                                Rotation = 90,
                                Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                                Parent = icon
                            })

                            utility.create("Frame", {
                                ZIndex = 7,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                                Parent = grayborder
                            })

                            enablediconholder = utility.create("Frame", {
                                ZIndex = 10,
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = icon
                            })

                            local enabledicongradient = utility.create("UIGradient", {
                                Rotation = 90,
                                Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                                Parent = enablediconholder
                            })

                            accentobjects.gradient[enabledicongradient] = function(color)
                                return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                            end
                        end
                    end

                    local title = utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Position = keybindtype and keybindtype:lower() == "toggle" and UDim2.new(0, 20, 0, 0) or UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = (keybindtype and keybindtype:lower() == "toggle" and Color3.fromRGB(180, 180, 180)) or Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = keybindholder
                    })

                    local keytext = utility.create(keybindtype and keybindtype:lower() == "toggle" and "TextButton" or "TextLabel", {
                        ZIndex = 7,
                        Size = keybindtype and keybindtype:lower() == "toggle" and UDim2.new(0, 45, 1, 0) or UDim2.new(0, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Position = keybindtype and keybindtype:lower() == "toggle" and UDim2.new(1, -45, 0, 0) or UDim2.new(1, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                        Text = "[NONE]",
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Parent = keybindholder
                    })

                    utility.create("UIPadding", {
                        PaddingBottom = UDim.new(0, 1),
                        Parent = keytext
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local keys = {
                        [Enum.KeyCode.LeftShift] = "L-SHIFT",
                        [Enum.KeyCode.RightShift] = "R-SHIFT",
                        [Enum.KeyCode.LeftControl] = "L-CTRL",
                        [Enum.KeyCode.RightControl] = "R-CTRL",
                        [Enum.KeyCode.LeftAlt] = "L-ALT",
                        [Enum.KeyCode.RightAlt] = "R-ALT",
                        [Enum.KeyCode.CapsLock] = "CAPSLOCK",
                        [Enum.KeyCode.One] = "1",
                        [Enum.KeyCode.Two] = "2",
                        [Enum.KeyCode.Three] = "3",
                        [Enum.KeyCode.Four] = "4",
                        [Enum.KeyCode.Five] = "5",
                        [Enum.KeyCode.Six] = "6",
                        [Enum.KeyCode.Seven] = "7",
                        [Enum.KeyCode.Eight] = "8",
                        [Enum.KeyCode.Nine] = "9",
                        [Enum.KeyCode.Zero] = "0",
                        [Enum.KeyCode.KeypadOne] = "NUM-1",
                        [Enum.KeyCode.KeypadTwo] = "NUM-2",
                        [Enum.KeyCode.KeypadThree] = "NUM-3",
                        [Enum.KeyCode.KeypadFour] = "NUM-4",
                        [Enum.KeyCode.KeypadFive] = "NUM-5",
                        [Enum.KeyCode.KeypadSix] = "NUM-6",
                        [Enum.KeyCode.KeypadSeven] = "NUM-7",
                        [Enum.KeyCode.KeypadEight] = "NUM-8",
                        [Enum.KeyCode.KeypadNine] = "NUM-9",
                        [Enum.KeyCode.KeypadZero] = "NUM-0",
                        [Enum.KeyCode.Minus] = "-",
                        [Enum.KeyCode.Equals] = "=",
                        [Enum.KeyCode.Tilde] = "~",
                        [Enum.KeyCode.LeftBracket] = "[",
                        [Enum.KeyCode.RightBracket] = "]",
                        [Enum.KeyCode.RightParenthesis] = ")",
                        [Enum.KeyCode.LeftParenthesis] = "(",
                        [Enum.KeyCode.Semicolon] = ",",
                        [Enum.KeyCode.Quote] = "'",
                        [Enum.KeyCode.BackSlash] = "\\",
                        [Enum.KeyCode.Comma] = ",",
                        [Enum.KeyCode.Period] = ".",
                        [Enum.KeyCode.Slash] = "/",
                        [Enum.KeyCode.Asterisk] = "*",
                        [Enum.KeyCode.Plus] = "+",
                        [Enum.KeyCode.Period] = ".",
                        [Enum.KeyCode.Backquote] = "`",
                        [Enum.UserInputType.MouseButton1] = "MOUSE-1",
                        [Enum.UserInputType.MouseButton2] = "MOUSE-2",
                        [Enum.UserInputType.MouseButton3] = "MOUSE-3"
                    }

                    local keychosen
                    local isbinding = false

                    local function startbinding()
                        isbinding = true
                        keytext.Text = "[...]"
                        keytext.TextColor3 = Color3.fromRGB(210, 210, 210)

                        local binding
                        binding = services.InputService.InputBegan:Connect(function(input)
                            local key = keys[input.KeyCode] or keys[input.UserInputType]
                            keytext.Text = "[" .. (key or tostring(input.KeyCode):gsub("Enum.KeyCode.", "")) .. "]"
                            keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                            keytext.Size = UDim2.new(0, keytext.TextBounds.X, 1, 0)
                            keytext.Position = UDim2.new(1, -keytext.TextBounds.X, 0, 0)

                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                task.wait()
                                if not table.find(blacklist, input.KeyCode) then
                                    keychosen = input.KeyCode

                                    if flag then
                                        library.flags[flag] = input.KeyCode
                                    end

                                    binding:Disconnect()
                                else
                                    keychosen = nil
                                    keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                                    keytext.Text = "NONE"

                                    if flag then
                                        library.flags[flag] = nil
                                    end

                                    binding:Disconnect()
                                end
                            else
                                if not table.find(blacklist, input.UserInputType) then
                                    keychosen = input.UserInputType

                                    if flag then
                                        library.flags[flag] = input.UserInputType
                                    end

                                    binding:Disconnect()
                                else
                                    keychosen = nil
                                    keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                                    keytext.Text = "[NONE]"

                                    keytext.Size = UDim2.new(0, keytext.TextBounds.X, 1, 0)
                                    keytext.Position = UDim2.new(1, -keytext.TextBounds.X, 0, 0)

                                    if flag then
                                        library.flags[flag] = nil
                                    end

                                    binding:Disconnect()
                                end
                            end
                        end)
                    end

                    if not keybindtype or keybindtype:lower() == "hold" then
                        keybindholder.MouseButton1Click:Connect(startbinding)
                    else
                        keytext.MouseButton1Click:Connect(startbinding)
                    end

                    local keybindtypes = utility.table()

                    if keybindtype and keybindtype:lower() == "toggle" then
                        local toggled = false

                        if toggleflag then
                            library.flags[toggleflag] = toggled
                        end

                        local function toggle()
                            if not switchingtabs then
                                toggled = not toggled

                                if toggleflag then
                                    library.flags[toggleflag] = toggled
                                end

                                togglecallback(toggled)

                                local enabledtransparency = toggled and 0 or 1
                                utility.tween(enablediconholder, { 0.2 }, { Transparency = enabledtransparency })

                                local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                                utility.tween(title, { 0.2 }, { TextColor3 = textcolor })

                                if toggled then
                                    table.insert(accentobjects.text, title)
                                elseif table.find(accentobjects.text, title) then
                                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                                end
                            end
                        end

                        keybindholder.MouseButton1Click:Connect(toggle)

                        local function set(bool)
                            if type(bool) == "boolean" and toggled ~= bool then
                                toggle()
                            end
                        end

                        function keybindtypes:Toggle(bool)
                            set(bool)
                        end

                        if toggledefault then
                            set(toggledefault)
                        end

                        if toggleflag then
                            flags[toggleflag] = set
                        end

                        services.InputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    toggle()
                                    callback(keychosen)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    toggle()
                                    callback(keychosen)
                                end
                            end
                        end)
                    end

                    if keybindtype and keybindtype:lower() == "hold" then
                        services.InputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    callback(keychosen)
                                    holdcallback(true)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    callback(keychosen)
                                    holdcallback(true)
                                end
                            end
                        end)

                        services.InputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    holdcallback(false)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    holdcallback(false)
                                end
                            end
                        end)
                    end

                    if not keybindtype then
                        services.InputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    callback(keychosen)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    callback(keychosen)
                                end
                            end
                        end)
                    end

                    local function setkey(newkey)
                        if tostring(newkey):find("Enum.KeyCode.") then
                            newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                        else
                            newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                        end

                        if not table.find(blacklist, newkey) then
                            local key = keys[newkey]
                            local text = "[" .. (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", "")) .. "]"
                            local sizeX = services.TextService:GetTextSize(text, 8, Enum.Font.Code, Vector2.new(1000, 1000)).X

                            keytext.Text = text
                            keytext.Size = UDim2.new(0, sizeX, 1, 0)
                            keytext.Position = UDim2.new(1, -sizeX, 0, 0)

                            keytext.TextColor3 = Color3.fromRGB(180, 180, 180)

                            keychosen = newkey

                            if flag then
                                library.flags[flag] = newkey
                            end

                            callback(newkey, true)
                        else
                            keychosen = nil
                            keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                            keytext.Text = "[NONE]"
                            keytext.Size = UDim2.new(0, keytext.TextBounds.X, 1, 0)
                            keytext.Position = UDim2.new(1, -keytext.TextBounds.X, 0, 0)

                            if flag then
                                library.flags[flag] = nil
                            end

                            callback(newkey, true)
                        end
                    end

                    if default then
                        task.wait()
                        setkey(default)
                    end

                    if flag then
                        flags[flag] = setkey
                    end

                    function keybindtypes:Set(newkey)
                        setkey(newkey)
                    end

                    return keybindtypes
                end

                function sectiontypes:ColorPicker(options)
                    options = utility.table(options)
                    local name = options.name
                    local default = options.default or Color3.fromRGB(255, 255, 255)
                    local colorpickertype = options.mode
                    local toggleflag = colorpickertype and colorpickertype:lower() == "toggle" and options.togglepointer
                    local togglecallback = colorpickertype and colorpickertype:lower() == "toggle" and options.togglecallback or function() end
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local colorpickerholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 0),
                        Parent = sectioncontent
                    })

                    local enabledcpiconholder
                    do
                        if colorpickertype and colorpickertype:lower() == "toggle" then
                            local togglecpicon = utility.create("Frame", {
                                ZIndex = 9,
                                Size = UDim2.new(0, 10, 0, 10),
                                BorderColor3 = Color3.fromRGB(40, 40, 40),
                                Position = UDim2.new(0, 2, 0, 2),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = colorpickerholder
                            })

                            local grayborder = utility.create("Frame", {
                                ZIndex = 8,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                                Parent = togglecpicon
                            })

                            utility.create("UIGradient", {
                                Rotation = 90,
                                Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                                Parent = togglecpicon
                            })

                            utility.create("Frame", {
                                ZIndex = 7,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                                Parent = grayborder
                            })

                            enabledcpiconholder = utility.create("Frame", {
                                ZIndex = 10,
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = togglecpicon
                            })

                            local enabledicongradient = utility.create("UIGradient", {
                                Rotation = 90,
                                Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                                Parent = enabledcpiconholder
                            })

                            accentobjects.gradient[enabledicongradient] = function(color)
                                return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                            end
                        end
                    end

                    local colorpickerframe = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, -70, 0, 148),
                        Position = UDim2.new(1, -168, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Visible = false,
                        Parent = colorpickerholder
                    })

                    colorpickerframe.DescendantAdded:Connect(function(descendant)
                        if not opened then
                            task.wait()
                            if not descendant.ClassName:find("UI") then
                                if descendant.ClassName:find("Text") then
                                    descendant.TextTransparency = descendant.TextTransparency + 1
                                    descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                                end

                                if descendant.ClassName:find("Image") then
                                    descendant.ImageTransparency = descendant.ImageTransparency + 1
                                end

                                descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                            end
                        end
                    end)

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = colorpickerframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = colorpickerframe
                    })

                    local blackborder = utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local saturationframe = utility.create("ImageLabel", {
                        ZIndex = 12,
                        Size = UDim2.new(0, 128, 0, 100),
                        BorderColor3 = Color3.fromRGB(50, 50, 50),
                        Position = UDim2.new(0, 6, 0, 6),
                        BorderSizePixel = 0,
                        BackgroundColor3 = default,
                        Image = "http://www.roblox.com/asset/?id=8630797271",
                        Parent = colorpickerframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = saturationframe
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local saturationpicker = utility.create("Frame", {
                        ZIndex = 13,
                        Size = UDim2.new(0, 2, 0, 2),
                        BorderColor3 = Color3.fromRGB(10, 10, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = saturationframe
                    })

                    local hueframe = utility.create("ImageLabel", {
                        ZIndex = 12,
                        Size = UDim2.new(0, 14, 0, 100),
                        Position = UDim2.new(1, -20, 0, 6),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 193, 49),
                        ScaleType = Enum.ScaleType.Crop,
                        Image = "http://www.roblox.com/asset/?id=8630799159",
                        Parent = colorpickerframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = hueframe
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local huepicker = utility.create("Frame", {
                        ZIndex = 13,
                        Size = UDim2.new(1, 0, 0, 1),
                        BorderColor3 = Color3.fromRGB(10, 10, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = hueframe
                    })

                    local boxholder = utility.create("Frame", {
                        Size = UDim2.new(1, -8, 0, 17),
                        ClipsDescendants = true,
                        Position = UDim2.new(0, 4, 0, 110),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = colorpickerframe
                    })

                    local box = utility.create("TextBox", {
                        ZIndex = 13,
                        Size = UDim2.new(1, -4, 1, -4),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 2),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = table.concat({ utility.getrgb(default) }, ", "),
                        PlaceholderText = "R, G, B",
                        Font = Enum.Font.Code,
                        Parent = boxholder
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = box
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 12,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = box
                    })

                    utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = bg
                    })

                    local toggleholder = utility.create("TextButton", {
                        Size = UDim2.new(1, -8, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 4, 0, 130),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 14,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = colorpickerframe
                    })

                    local toggleicon = utility.create("Frame", {
                        ZIndex = 12,
                        Size = UDim2.new(0, 10, 0, 10),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        Position = UDim2.new(0, 2, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = toggleholder
                    })

                    local enablediconholder = utility.create("Frame", {
                        ZIndex = 13,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = toggleicon
                    })

                    local enabledicongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                        Parent = enablediconholder
                    })

                    accentobjects.gradient[enabledicongradient] = function(color)
                        return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                    end

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = toggleicon
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = toggleicon
                    })

                    local rainbowtxt = utility.create("TextLabel", {
                        ZIndex = 10,
                        Size = UDim2.new(0, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 20, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                        Text = "Rainbow",
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = toggleholder
                    })

                    local colorpicker = utility.create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 14),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 14,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = colorpickerholder
                    })

                    local icon = utility.create(colorpickertype and colorpickertype:lower() == "toggle" and "TextButton" or "Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(0, 18, 0, 10),
                        BorderColor3 = Color3.fromRGB(40, 40, 40),
                        Position = UDim2.new(1, -20, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = colorpicker
                    })

                    if colorpickertype and colorpickertype:lower() == "toggle" then
                        icon.Text = ""
                    end

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Parent = icon
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local icongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { default, utility.changecolor(default, -200) },
                        Parent = icon
                    })

                    local title = utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Position = colorpickertype and colorpickertype:lower() == "toggle" and UDim2.new(0, 20, 0, 0) or UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = colorpicker
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local colorpickertypes = utility.table()

                    if colorpickertype and colorpickertype:lower() == "toggle" then
                        local toggled = false

                        if toggleflag then
                            library.flags[toggleflag] = toggled
                        end

                        local function toggle()
                            if not switchingtabs then
                                toggled = not toggled

                                if toggleflag then
                                    library.flags[toggleflag] = toggled
                                end

                                togglecallback(toggled)

                                local enabledtransparency = toggled and 0 or 1
                                utility.tween(enabledcpiconholder, { 0.2 }, { BackgroundTransparency = enabledtransparency })

                                local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                                utility.tween(title, { 0.2 }, { TextColor3 = textcolor })

                                if toggled then
                                    table.insert(accentobjects.text, title)
                                elseif table.find(accentobjects.text, title) then
                                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                                end
                            end
                        end

                        colorpicker.MouseButton1Click:Connect(toggle)

                        local function set(bool)
                            if type(bool) == "boolean" and toggled ~= bool then
                                toggle()
                            end
                        end

                        function colorpickertypes:Toggle(bool)
                            set(bool)
                        end

                        if toggledefault then
                            set(toggledefault)
                        end

                        if toggleflag then
                            flags[toggleflag] = set
                        end
                    end

                    local opened = false
                    local opening = false

                    local function opencolorpicker()
                        if not opening then
                            opening = true

                            opened = not opened

                            if opened then
                                utility.tween(colorpickerholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 168) })
                            end

                            local tween = utility.makevisible(colorpickerframe, opened)

                            tween.Completed:Wait()

                            if not opened then
                                local tween = utility.tween(colorpickerholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 16) })
                                tween.Completed:Wait()
                            end

                            opening = false
                        end
                    end

                    if colorpickertype and colorpickertype:lower() == "toggle" then
                        icon.MouseButton1Click:Connect(opencolorpicker)
                    else
                        colorpicker.MouseButton1Click:Connect(opencolorpicker)
                    end

                    local hue, sat, val = default:ToHSV()

                    local slidinghue = false
                    local slidingsaturation = false

                    local hsv = Color3.fromHSV(hue, sat, val)

                    if flag then
                        library.flags[flag] = default
                    end

                    local function updatehue(input)
                        local sizeY = 1 - math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
                        local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y, 0, hueframe.AbsoluteSize.Y - 2)
                        huepicker.Position = UDim2.new(0, 0, 0, posY)

                        hue = sizeY
                        hsv = Color3.fromHSV(sizeY, sat, val)

                        box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                        saturationframe.BackgroundColor3 = hsv
                        icon.BackgroundColor3 = hsv

                        if flag then
                            library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                        end

                        callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                    end

                    hueframe.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidinghue = true
                            updatehue(input)
                        end
                    end)

                    hueframe.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidinghue = false
                        end
                    end)

                    services.InputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if slidinghue then
                                updatehue(input)
                            end
                        end
                    end)

                    local function updatesatval(input)
                        local sizeX = math.clamp((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X, 0, 1)
                        local sizeY = 1 - math.clamp((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y, 0, 1)
                        local posY = math.clamp(((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)
                        local posX = math.clamp(((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X) * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)

                        saturationpicker.Position = UDim2.new(0, posX, 0, posY)

                        sat = sizeX
                        val = sizeY
                        hsv = Color3.fromHSV(hue, sizeX, sizeY)

                        box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                        saturationframe.BackgroundColor3 = hsv
                        icon.BackgroundColor3 = hsv

                        if flag then
                            library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                        end

                        callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                    end

                    saturationframe.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidingsaturation = true
                            updatesatval(input)
                        end
                    end)

                    saturationframe.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidingsaturation = false
                        end
                    end)

                    services.InputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if slidingsaturation then
                                updatesatval(input)
                            end
                        end
                    end)

                    local function set(color)
                        if type(color) == "table" then
                            color = Color3.fromRGB(unpack(color))
                        end

                        hue, sat, val = color:ToHSV()
                        hsv = Color3.fromHSV(hue, sat, val)

                        saturationframe.BackgroundColor3 = hsv
                        icon.BackgroundColor3 = hsv
                        saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)), 0, (math.clamp((1 - val) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)))
                        huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4))

                        box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                        if flag then
                            library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                        end

                        callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                    end

                    local toggled = false

                    local function toggle()
                        if not switchingtabs then
                            toggled = not toggled

                            if toggled then
                                task.spawn(function()
                                    while toggled do
                                        for i = 0, 1, 0.0015 do
                                            if not toggled then
                                                return
                                            end

                                            local color = Color3.fromHSV(i, 1, 1)
                                            set(color)

                                            task.wait()
                                        end
                                    end
                                end)
                            end

                            local enabledtransparency = toggled and 0 or 1
                            utility.tween(enablediconholder, { 0.2 }, { BackgroundTransparency = enabledtransparency })

                            local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                            utility.tween(rainbowtxt, { 0.2 }, { TextColor3 = textcolor })

                            if toggled then
                                table.insert(accentobjects.text, title)
                            elseif table.find(accentobjects.text, title) then
                                table.remove(accentobjects.text, table.find(accentobjects.text, title))
                            end
                        end
                    end

                    toggleholder.MouseButton1Click:Connect(toggle)

                    box.FocusLost:Connect(function()
                        local _, amount = box.Text:gsub(", ", "")

                        if amount == 2 then
                            local values = box.Text:split(", ")
                            local r, g, b = math.clamp(values[1], 0, 255), math.clamp(values[2], 0, 255), math.clamp(values[3], 0, 255)
                            set(Color3.fromRGB(r, g, b))
                        else
                            rgb.Text = math.floor((hsv.r * 255) + 0.5) .. ", " .. math.floor((hsv.g * 255) + 0.5) .. ", " .. math.floor((hsv.b * 255) + 0.5)
                        end
                    end)

                    if default then
                        set(default)
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local colorpickertypes = utility.table()

                    function colorpickertypes:Set(color)
                        set(color)
                    end
                end

                return sectiontypes
            end

            return pagetypes
        end

        return windowtypes
    end

    function library:Initialize()
        if gethui then
            gui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = services.CoreGui
        end
    end

    function library:Init()
        library:Initialize()
    end
end

local AnimationModule = {
    Astronaut = {
        "rbxassetid://891621366",
        "rbxassetid://891633237",
        "rbxassetid://891667138",
        "rbxassetid://891636393",
        "rbxassetid://891627522",
        "rbxassetid://891609353",
        "rbxassetid://891617961"
    },
    Bubbly = {
        "rbxassetid://910004836",
        "rbxassetid://910009958",
        "rbxassetid://910034870",
        "rbxassetid://910025107",
        "rbxassetid://910016857",
        "rbxassetid://910001910",
        "rbxassetid://910030921",
        "rbxassetid://910028158"
    },
    Cartoony = {
        "rbxassetid://742637544",
        "rbxassetid://742638445",
        "rbxassetid://742640026",
        "rbxassetid://742638842",
        "rbxassetid://742637942",
        "rbxassetid://742636889",
        "rbxassetid://742637151"
    },
    Confindent = {
        "rbxassetid://1069977950",
        "rbxassetid://1069987858",
        "rbxassetid://1070017263",
        "rbxassetid://1070001516",
        "rbxassetid://1069984524",
        "rbxassetid://1069946257",
        "rbxassetid://1069973677"
    },
    Cowboy = {
        "rbxassetid://1014390418",
        "rbxassetid://1014398616",
        "rbxassetid://1014421541",
        "rbxassetid://1014401683",
        "rbxassetid://1014394726",
        "rbxassetid://1014380606",
        "rbxassetid://1014384571"
    },
    Default = {
        "http://www.roblox.com/asset/?id=507766666",
        "http://www.roblox.com/asset/?id=507766951",
        "http://www.roblox.com/asset/?id=507777826",
        "http://www.roblox.com/asset/?id=507767714",
        "http://www.roblox.com/asset/?id=507765000",
        "http://www.roblox.com/asset/?id=507765644",
        "http://www.roblox.com/asset/?id=507767968"
    },
    Elder = {
        "rbxassetid://845397899",
        "rbxassetid://845400520",
        "rbxassetid://845403856",
        "rbxassetid://845386501",
        "rbxassetid://845398858",
        "rbxassetid://845392038",
        "rbxassetid://845396048"
    },
    Ghost = {
        "rbxassetid://616006778",
        "rbxassetid://616008087",
        "rbxassetid://616013216",
        "rbxassetid://616013216",
        "rbxassetid://616008936",
        "rbxassetid://616005863",
        "rbxassetid://616012453",
        "rbxassetid://616011509"
    },
    Knight = {
        "rbxassetid://657595757",
        "rbxassetid://657568135",
        "rbxassetid://657552124",
        "rbxassetid://657564596",
        "rbxassetid://658409194",
        "rbxassetid://658360781",
        "rbxassetid://657600338"
    },
    Levitation = {
        "rbxassetid://616006778",
        "rbxassetid://616008087",
        "rbxassetid://616013216",
        "rbxassetid://616010382",
        "rbxassetid://616008936",
        "rbxassetid://616003713",
        "rbxassetid://616005863"
    },
    Mage = {
        "rbxassetid://707742142",
        "rbxassetid://707855907",
        "rbxassetid://707897309",
        "rbxassetid://707861613",
        "rbxassetid://707853694",
        "rbxassetid://707826056",
        "rbxassetid://707829716"
    },
    Ninja = {
        "rbxassetid://656117400",
        "rbxassetid://656118341",
        "rbxassetid://656121766",
        "rbxassetid://656118852",
        "rbxassetid://656117878",
        "rbxassetid://656114359",
        "rbxassetid://656115606"
    },
    OldSchool = {
        "rbxassetid://5319828216",
        "rbxassetid://5319831086",
        "rbxassetid://5319847204",
        "rbxassetid://5319844329",
        "rbxassetid://5319841935",
        "rbxassetid://5319839762",
        "rbxassetid://5319852613",
        "rbxassetid://5319850266"
    },
    Patrol = {
        "rbxassetid://1149612882",
        "rbxassetid://1150842221",
        "rbxassetid://1151231493",
        "rbxassetid://1150967949",
        "rbxassetid://1148811837",
        "rbxassetid://1148811837",
        "rbxassetid://1148863382"
    },
    Pirtate = {
        "rbxassetid://750781874",
        "rbxassetid://750782770",
        "rbxassetid://750785693",
        "rbxassetid://750783738",
        "rbxassetid://750782230",
        "rbxassetid://750779899",
        "rbxassetid://750780242"
    },
    Popstar = {
        "rbxassetid://1212900985",
        "rbxassetid://1150842221",
        "rbxassetid://1212980338",
        "rbxassetid://1212980348",
        "rbxassetid://1212954642",
        "rbxassetid://1213044953",
        "rbxassetid://1212900995"
    },
    Princess = {
        "rbxassetid://941003647",
        "rbxassetid://941013098",
        "rbxassetid://941028902",
        "rbxassetid://941015281",
        "rbxassetid://941008832",
        "rbxassetid://940996062",
        "rbxassetid://941000007"
    },
    Robot = {
        "rbxassetid://616088211",
        "rbxassetid://616089559",
        "rbxassetid://616095330",
        "rbxassetid://616091570",
        "rbxassetid://616090535",
        "rbxassetid://616086039",
        "rbxassetid://616087089"
    },
    Rthro = {
        "rbxassetid://2510196951",
        "rbxassetid://2510197257",
        "rbxassetid://2510202577",
        "rbxassetid://2510198475",
        "rbxassetid://2510197830",
        "rbxassetid://2510195892",
        "rbxassetid://02510201162",
        "rbxassetid://2510199791",
        "rbxassetid://2510192778"
    },
    Sneaky = {
        "rbxassetid://1132473842",
        "rbxassetid://1132477671",
        "rbxassetid://1132510133",
        "rbxassetid://1132494274",
        "rbxassetid://1132489853",
        "rbxassetid://1132461372",
        "rbxassetid://1132469004"
    },
    Stylish = {
        "rbxassetid://616136790",
        "rbxassetid://616138447",
        "rbxassetid://616146177",
        "rbxassetid://616140816",
        "rbxassetid://616139451",
        "rbxassetid://616133594",
        "rbxassetid://616134815"
    },
    Superhero = {
        "rbxassetid://782841498",
        "rbxassetid://782845736",
        "rbxassetid://782843345",
        "rbxassetid://782842708",
        "rbxassetid://782847020",
        "rbxassetid://782843869",
        "rbxassetid://782846423"
    },
    Toy = {
        "rbxassetid://782841498",
        "rbxassetid://782845736",
        "rbxassetid://782843345",
        "rbxassetid://782842708",
        "rbxassetid://782847020",
        "rbxassetid://782843869",
        "rbxassetid://782846423"
    },
    Vampire = {
        "rbxassetid://1083445855",
        "rbxassetid://1083450166",
        "rbxassetid://1083473930",
        "rbxassetid://1083462077",
        "rbxassetid://1083455352",
        "rbxassetid://1083439238",
        "rbxassetid://1083443587"
    },
    Werewolf = {
        "rbxassetid://1083195517",
        "rbxassetid://1083214717",
        "rbxassetid://1083178339",
        "rbxassetid://1083216690",
        "rbxassetid://1083218792",
        "rbxassetid://1083182000",
        "rbxassetid://1083189019"
    },
    Zombie = {
        "rbxassetid://616158929",
        "rbxassetid://616160636",
        "rbxassetid://616168032",
        "rbxassetid://616163682",
        "rbxassetid://616161997",
        "rbxassetid://616156119",
        "rbxassetid://616157476"
    }
}

local CursorPath = Instance.new("ScreenGui")
local Swastika = Instance.new("TextLabel")


CursorPath.Name = "CursorPath"
CursorPath.Parent = game.CoreGui
CursorPath.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Swastika.Name = "Swastika"
Swastika.Parent = CursorPath
Swastika.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Swastika.BackgroundTransparency = 1.000
Swastika.BorderSizePixel = 2
Swastika.Position = UDim2.new(0, 0, 0, 0)
Swastika.Size = UDim2.new(0, 93, 0, 84)
Swastika.Font = Enum.Font.SourceSans
Swastika.Text = "卍"
Swastika.TextColor3 = Color3.fromRGB(0, 0, 0)
Swastika.TextSize = 46.000
Swastika.TextTransparency =  0
Swastika.Rotation = 45 
Swastika.Visible = false 

-- Lock
local V3 = Vector3.new
local V2 = Vector2.new
local inf = math.huge
getgenv().Settings = {
    ["WhyIsSheLookingAtMe"] = {
        ["Enabled"] = false,
        ["DOT"] = true,
        ["AIRSHOT"] = false,
        ["Prediction"] = {
            ["Horizontal"] = 0.185,
            ["Vertical"] = 0.1,
        },
        ["CamPrediction"] = {
            ["Prediction"] = {
                ["Horizontal"] = 0.185,
                ["Vertical"] = 0.1,
            },
        },
        ["NOTIF"] = true,
        ["AUTOPRED"] = false,
        ["AdvancedAutoPred"] = false,
        ["FOV"] = inf,
        ["RESOLVER"] = false,
        ["LOCKTYPE"] = "Namecall",
        ["TargetStats"] = false,
        ["Resolver"] = {
              ["Enabled"] = false,
              ["Type"] = "None",
        },
       ["Camera"] = {
        ["Enabled"] = false,
        ["HoodCustomsBypass"] = false,
     },
        ["OnHit"] = {
             ["Enabled"] = true,
             ["Hitchams"] = {
                  ["Enabled"] = false,
                  ["Color"] = Color3.fromRGB(128,0,128),
                  ["Transparency"] = 0,
                  ["Material"] = "ForceField",
             },
            ["Hitsound"] = {
                  ["Enabled"] = false,
                  ["Sound"] = "hitsounds/sparkle.wav",
                  ["Volume"] = 2,
            },
        }
    },
}
getgenv().DistancesMid = 50
getgenv().DistancesClose = 10
getgenv().AimSpeed = 1
getgenv().CAMPREDICTION = 0.185
getgenv().CAMJUMPPREDICTION = 0.1
getgenv().HorizontalSmoothness = 1
getgenv().VerticallSmoothness = 0.5
getgenv().ShakeX = 0
getgenv().ShakeY = 0
getgenv().ShakeZ = 0
getgenv().PREDICTION = 0.185
getgenv().JUMPPREDICTION = 0.1
getgenv().SelectedPart = "HumanoidRootPart" --// LowerTorso, UpperTorso, Head
getgenv().Prediction = "Normal"
getgenv().AutoPredType = "Normal"
getgenv().Resolver = false
local Ranges = {
        Close = 30,
        Mid = 100
}

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
function SendNotification(text)
    Notification:Notify(
        {Title = "Kabu Shitcakes v2", Description = "coolest kid - "..text},
        {OutlineColor = Color3.fromRGB(0,0,139),Time = 3, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(0,0,139)}
    )
end
function calculateVelocity(initialPos, finalPos, timeInterval)
    local displacement = finalPos - initialPos
    local velocity = displacement / timeInterval
    return velocity
    end
    game:GetService('RunService').RenderStepped:connect(function(deltaTime)
    if getgenv().Resolver == true and enabled then 
        local character = Plr.Character[getgenv().SelectedPart]
        local lastPosition = character.Position
            task.wait()
        local currentPosition = character.Position
        local velocity = calculateVelocity(lastPosition, currentPosition, deltaTime)
        character.AssemblyLinearVelocity = velocity
        character.Velocity = velocity
            lastPosition = currentPosition
        end
    end)

--// Change Prediction,  AutoPrediction Must Be Off
    local lplr = game.Players.LocalPlayer
    local AnchorCount = 0
    local MaxAnchor = 50
    local CC = game:GetService"Workspace".CurrentCamera
    local Plr;
    local enabled = false
    local mouse = game.Players.LocalPlayer:GetMouse()
    local placemarker = Instance.new("Part", game.Workspace)
    function makemarker(Parent, Adornee, Color, Size, Size2)
        local e = Instance.new("BillboardGui", Parent)
        e.Name = "PP"
        e.Adornee = Adornee
        e.Size = UDim2.new(Size, Size2, Size, Size2)
        e.AlwaysOnTop = getgenv().Settings.WhyIsSheLookingAtMe.DOT
        local a = Instance.new("Frame", e)
        if getgenv().Settings.WhyIsSheLookingAtMe.DOT == true then
        a.Size = UDim2.new(1, 1, 1, 1)
        else
        a.Size = UDim2.new(0, 0, 0, 0)
        end
        if getgenv().Settings.WhyIsSheLookingAtMe.DOT == true then
        a.Transparency = 0
        a.BackgroundTransparency = 0
        else
        a.Transparency = 1
        a.BackgroundTransparency = 1
        end
        a.BackgroundColor3 = Color
        local g = Instance.new("UICorner", a)
        if getgenv().Settings.WhyIsSheLookingAtMe.DOT == false then
        g.CornerRadius = UDim.new(1, 1)
        else
        g.CornerRadius = UDim.new(1, 1) 
        end
        return(e)
    end
    local data = game.Players:GetPlayers()
    function noob(player)
        local character
        repeat wait() until player.Character
        local handler = makemarker(guimain, player.Character:WaitForChild(SelectedPart), Color3.fromRGB(107, 184, 255), 0.3, 3)
        handler.Name = player.Name
        player.CharacterAdded:connect(function(Char) handler.Adornee = Char:WaitForChild(SelectedPart) end)
 
 
        spawn(function()
            while wait() do
                if player.Character then
                end
            end
        end)
    end
 
    for i = 1, #data do
        if data[i] ~= game.Players.LocalPlayer then
            noob(data[i])
        end
    end
 
    game.Players.PlayerAdded:connect(function(Player)
        noob(Player)
    end)
 
    spawn(function()
        placemarker.Anchored = true
        placemarker.CanCollide = false
        if getgenv().Settings.WhyIsSheLookingAtMe.DOT == true then
        placemarker.Size = V3(0, 0, 0)
        else
        placemarker.Size = V3(0, 0, 0)
        end
        placemarker.Transparency = 0.75
        if getgenv().Settings.WhyIsSheLookingAtMe.DOT then
        makemarker(placemarker, placemarker, Color3.fromRGB(0,0,139), 0.5, 0)
        end
    end)
 local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Lock Tool"
Tool.Parent = game.Players.LocalPlayer.Backpack
local player = game.Players.LocalPlayer
local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end
connectCharacterAdded()
player.CharacterRemoving:Connect(function()
Tool.Parent = game.Players.LocalPlayer.Backpack
end)
function hitsound()
    local Hit = Instance.new("Sound")
    Hit.Parent = game.SoundService
    Hit.SoundId = getcustomasset(getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitsound.Sound)
    Hit.Volume = getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitsound.Volume
    Hit.Looped = false
    Hit:Play()
    Hit.Ended:Connect(function()                                         Hit:Destroy()
        end)
end

Tool.Activated:Connect(function()
if getgenv().Settings.WhyIsSheLookingAtMe.Enabled or getgenv().Settings.WhyIsSheLookingAtMe.Camera.Enabled then
            if enabled == true then
                enabled = false
                    Plr = LockToPlayer()
                if getgenv().Settings.WhyIsSheLookingAtMe.NOTIF == true then 
 SendNotification("Unlocked")
            end
            else
                Plr = LockToPlayer()
                TargetPlayer = tostring(Plr)
                enabled = true
local oldHealt = game.Players[TargetPlayer].Character.Humanoid.Health
                        if getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitsound.Enabled and Plr ~= nil then

                             game.Players[TargetPlayer].Character.Humanoid.HealthChanged:Connect(function(neHealth)                            
if neHealth < oldHealt then
hitsound()
elseif neHealth > oldHealt then
print("nil")
elseif game.Players[TargetPlayer].Character.Humanoid.Health < 0 then
print("nil")
end
oldHealt = neHealth
end)
end                                      
              
if getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitchams.Enabled then
   
        if Plr ~= nil then  game.Players[TargetPlayer].Character.Humanoid.HealthChanged:Connect(function(neHealth)
        local Clone = game.Players[TargetPlayer].Character:Clone()
        if neHealth > oldHealt then
            Clone:Destroy()
        end
        if game.Players[TargetPlayer].Character.Humanoid.Health < 0 then
            Clone:Destroy()
        end
        if neHealth < oldHealt then
            -- Main Hit-Chams --
            game.Players[TargetPlayer].Character.Archivable = true
            for _, Obj in next, Clone:GetDescendants() do
                if Obj.Name == "HumanoidRootPart" or Obj:IsA("Humanoid") or Obj:IsA("LocalScript") or Obj:IsA("Script") or Obj:IsA("Decal") then
                    Obj:Destroy()
                elseif Obj:IsA("BasePart") or Obj:IsA("Meshpart") or Obj:IsA("Part") then
                    if Obj.Transparency == 1 then
                        Obj:Destroy()
                    else
                        Obj.CanCollide = false
                        Obj.Anchored = true
                        Obj.Material = getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitchams.Material
                        Obj.Color = getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitchams.Color
                        Obj.Transparency = getgenv().Settings.WhyIsSheLookingAtMe.OnHit.Hitchams.Transparency
                        Obj.Size = Obj.Size + V3(0.05, 0.05, 0.05)
                    end
                end
           
            end
            Clone.Parent = game.Workspace
            local start = tick()
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if tick() - start >= 3 then
                    connection:Disconnect()
                    Clone:Destroy()
                end
            end)
        end

            oldHealt = neHealth

    end)
    end
end
                if getgenv().Settings.WhyIsSheLookingAtMe.NOTIF == true then
SendNotification("Target: "..Plr.Character.Humanoid.DisplayName)
                end
            end
   else
  SendNotification("Cam/Target not enabled!")
        end
    end)
 
local TargetStats = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local Picture = Instance.new("ImageLabel")
local Top = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local UIGradient_2 = Instance.new("UIGradient")
local HealthBarBackground = Instance.new("Frame")
local UIGradient_3 = Instance.new("UIGradient")
local HealthBar = Instance.new("Frame")
local UIGradient_4 = Instance.new("UIGradient")
local NameOfTarget = Instance.new("TextLabel")

spawn(function()
TargetStats.Name = "TargetStats"
TargetStats.Parent = game.CoreGui
TargetStats.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Background.Name = "Background"
Background.Parent = TargetStats
Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Background.BorderSizePixel = 0
Background.Position = UDim2.new(0.388957828, 0, 0.700122297, 0)
Background.Size = UDim2.new(0, 358, 0, 71)
Background.Visible = false

Picture.Name = "Picture"
Picture.Parent = Background
Picture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Picture.BorderSizePixel = 0
Picture.Position = UDim2.new(0.0279329624, 0, 0.0704225376, 0)
Picture.Size = UDim2.new(0, 59, 0, 59)
Picture.Transparency = 1
Picture.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

Top.Name = "Top"
Top.Parent = Background
Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(0, 0, -0.101449274, 0)
Top.Size = UDim2.new(0, 358, 0, 7)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(100,81,195)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(155,40,0))}
UIGradient.Rotation = 90
UIGradient.Parent = Top

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(52, 52, 52)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
UIGradient_2.Rotation = 90
UIGradient_2.Parent = Background

HealthBarBackground.Name = "HealthBarBackground"
HealthBarBackground.Parent = Background
HealthBarBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HealthBarBackground.BorderSizePixel = 0
HealthBarBackground.Position = UDim2.new(0.215083793, 0, 0.348234326, 0)
HealthBarBackground.Size = UDim2.new(0, 270, 0, 19)
HealthBarBackground.Transparency = 1

UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(58, 58, 58)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))}
UIGradient_3.Rotation = 90
UIGradient_3.Parent = HealthBarBackground

HealthBar.Name = "HealthBar"
HealthBar.Parent = HealthBarBackground
HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HealthBar.BorderSizePixel = 0
HealthBar.Position = UDim2.new(-0.00336122862, 0, 0.164894029, 0)
HealthBar.Size = UDim2.new(0, 130, 0, 19)

UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(184, 159, 227)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(102, 88, 156))}
UIGradient_4.Rotation = 90
UIGradient_4.Parent = HealthBar

NameOfTarget.Name = "NameOfTarget"
NameOfTarget.Parent = Background
NameOfTarget.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameOfTarget.BackgroundTransparency = 1.000
NameOfTarget.Position = UDim2.new(0.220670387, 0, 0.0704225376, 0)
NameOfTarget.Size = UDim2.new(0, 268, 0, 19)
NameOfTarget.Font = Enum.Font.Code
NameOfTarget.TextColor3 = Color3.fromRGB(255, 255, 255)
NameOfTarget.TextScaled = true
NameOfTarget.TextSize = 14.000
NameOfTarget.TextStrokeTransparency = 0.000
NameOfTarget.TextWrapped = true
end)

local IsAlive = function(GetPlayer)
    return GetPlayer and GetPlayer.Character and GetPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and GetPlayer.Character:FindFirstChild("Humanoid") ~= nil and GetPlayer.Character:FindFirstChild("Head") ~= nil and true or false
end

spawn(function()
    while wait() do
        if getgenv().Settings.WhyIsSheLookingAtMe.TargetStats and getgenv().Settings.WhyIsSheLookingAtMe.Enabled and enabled then
            if Plr and IsAlive(Plr) then
                Background.Visible = true
                NameOfTarget.Text = tostring(Plr.Character.Humanoid.DisplayName).." ["..tostring(Plr.Name).."]"
                Picture.Image  = "rbxthumb://type=AvatarHeadShot&id=" ..Plr.UserId.. "&w=420&h=420"
                HealthBar:TweenSize(UDim2.new(Plr.Character.Humanoid.Health / Plr.Character.Humanoid.MaxHealth, 0, 1, 0), "In", "Linear", 0.25)
                spawn(function()
                    if getgenv().Settings.WhyIsSheLookingAtMe.TargetStats == false then
                        Background.Visible = false
                    end
                end)
            end
        else
            Background.Visible = false
        end
    end
end)
    function LockToPlayer()
        local closestPlayer
        local shortestDistance = getgenv().Settings.WhyIsSheLookingAtMe.FOV
        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                local magnitude = (V2(pos.X, pos.Y) - V2(mouse.X, mouse.Y)).magnitude
                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
        return closestPlayer
    end
 
local Stats = game:GetService("Stats")
local function Predict(Velocity)
    return V3(Velocity.X,math.clamp(Velocity.Y,-5,10),Velocity.Z)
end
local function GetLockPrediction(Part)
    return Part.CFrame + (Predict(Part.Velocity) * getgenv().PREDICTION)
end
local function GetCamPrediction(Part)
    return Part.CFrame + Predict(Part.Velocity) * (getgenv().CAMPREDICTION)
end
getgenv().UnlockOnDeath = false
    local pingvalue = nil;
    local split = nil;
    local ping = nil;



   if enabled and getgenv(). Settings.WhyIsSheLookingAtMe.Enabled and Plr.Character ~= nil and Plr.Character:FindFirstChild("HumanoidRootPart") or enabled and getgenv(). Settings.WhyIsSheLookingAtMe.Camera.Enabled and Plr.Character ~= nil and Plr.Character:FindFirstChild("HumanoidRootPart") then
if getgenv().Prediction == "Normal" then
            placemarker.CFrame = CFrame.new(GetLockPrediction(Plr.Character[getgenv().SelectedPart]).Position)         
elseif getgenv().Prediction == "Yun" then
            placemarker.CFrame = CFrame.new(Plr.Character[getgenv().SelectedPart].Position+V3(Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.X*getgenv().PREDICTION/10,Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y*getgenv().JUMPPREDICTION/10,Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Z*getgenv().PREDICTION/10))
end
LocalHL.Parent = Plr.Character
LocalHL.FillTransparency = 0.2
LocalHL.FillColor = Color3.fromRGB(0,0,139)
LocalHL.OutlineColor = Color3.fromRGB(255,255,255)
        else
            placemarker.CFrame = CFrame.new(0, 9999, 0)
        end
pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
split = string.split(pingvalue,'(')
ping = tonumber(split[1])

if getgenv().Settings.WhyIsSheLookingAtMe.AdvancedAutoPred == true and enabled then
    getgenv().CAMJUMPPREDICTION = 0.05
    if ping > 300 then
        getgenv().CAMPREDICTION = 0.434
    elseif ping > 290 then
        getgenv().CAMPREDICTION = 0.422
    elseif ping > 280 then
        getgenv().CAMPREDICTION = 0.44
    elseif ping > 270 then
        getgenv().CAMPREDICTION = 0.4385
    elseif ping > 260 then
        getgenv().CAMPREDICTION = 0.4158
    elseif ping > 250 then
        getgenv().CAMPREDICTION = 0.3148
    elseif ping > 240 then
        getgenv().CAMPREDICTION = 0.34
    elseif ping > 230 then
        getgenv().CAMPREDICTION = 0.33
    elseif ping > 220 then
        getgenv().CAMPREDICTION = 0.30
    elseif ping > 210 then
        getgenv().CAMPREDICTION = 0.295
    elseif ping > 200 then
        getgenv().CAMPREDICTION = 0.2915
    elseif ping > 190 then
        getgenv().CAMPREDICTION = 0.2911
    elseif ping > 180 then
        getgenv().CAMPREDICTION = 0.28291198328
    elseif ping > 180 then
        getgenv().CAMPREDICTION = 0.25291198328
    elseif ping > 170 then
        getgenv().CAMPREDICTION = 0.28
    elseif ping > 160 then
        getgenv().CAMPREDICTION = 0.2754
    elseif ping  >150 then
        getgenv().CAMPREDICTION = 0.271
    elseif ping  >140 then
        getgenv().CAMPREDICTION = 0.25
       elseif ping > 130 then
        getgenv().CAMPREDICTION = 0.12057
    elseif ping > 120 then
        getgenv().CAMPREDICTION = 0.1966
    elseif ping > 110 then
        getgenv().CAMPREDICTION = 0.18642271
    elseif ping > 100 then
        getgenv().CAMPREDICTION = 0.18533
    elseif ping > 90 then
        getgenv().CAMPREDICTION = 0.1749573
    elseif ping > 80 then
        getgenv().CAMPREDICTION = 0.1745
    elseif ping > 70 then
        getgenv().CAMPREDICTION = 0.1642
    elseif ping > 50 then
        getgenv().CAMPREDICTION = 0.14267
    elseif ping > 40 then
        getgenv().CAMPREDICTION = 0.142
    elseif ping > 30 then
        getgenv().CAMPREDICTION = 0.1312
   elseif ping > 20 then
        getgenv().CAMPREDICTION = 0.1312
   elseif ping > 10 then
        getgenv().CAMPREDICTION = 0.1287
   end
end
if getgenv().Settings.WhyIsSheLookingAtMe.AUTOPRED == true then
    if getgenv().AutoPredType == "Normal" then
if ping <200 then
    getgenv().PREDICTION = 0.2198343243234332
    elseif ping < 170 then
        getgenv().PREDICTION = 0.2165713
    elseif ping < 160 then
        getgenv().PREDICTION = 0.18242
    elseif ping < 150 then
        getgenv().PREDICTION = 0.1758041
    elseif ping < 140 then
        getgenv().PREDICTION = 0.175626432
    elseif ping < 130 then
        getgenv().PREDICTION = 0.1743
    elseif ping < 120 then
        getgenv().PREDICTION = 0.173
    elseif ping < 110 then
        getgenv().PREDICTION = 0.1685025
    elseif ping < 100 then
            getgenv().PREDICTION = 0.163
        elseif ping < 90 then
            getgenv().PREDICTION = 0.1610
        elseif ping < 80 then
            getgenv().PREDICTION = 0.1439340
        elseif ping < 70 then
              getgenv().PREDICTION = 0.13868
              elseif ping < 65 then
              getgenv().PREDICTION = 0.1264236
        elseif ping < 50 then
              getgenv().PREDICTION = 0.13544
        elseif ping < 30 then
     getgenv().PREDICTION = 0.11252476
        end
    elseif getgenv().AutoPredType == "Math" then       
 if not Plr or Plr == nil then
      return
   end
        local Distance = (game.Players.LocalPlayer.Character.PrimaryPart.Position - Plr.Character.PrimaryPart.Position).Magnitude
        if Distance <= Ranges.Mid then
                getgenv().PREDICTION = 0.1 + (ping * 0.0005675)
        elseif Distance <= Ranges.Close then
                getgenv().PREDICTION = 0.1 + (ping * 0.0007675)
        else
        getgenv().PREDICTION = 0.1 + (ping * 0.0003975)
        end
  end
end

if getgenv().Settings.WhyIsSheLookingAtMe.Resolver.Enabled then
if getgenv().Settings.WhyIsSheLookingAtMe.Resolver.Type == "Delta Time" then
print("wsg")
end
if getgenv().Settings.WhyIsSheLookingAtMe.Resolver.Type == "Recalculator" then
print("wsg")
end
if getgenv().Settings.WhyIsSheLookingAtMe.Resolver.Type == "No Y Velocity" then
print("wsg")
end
end


game:GetService"RunService".Stepped:connect(function()
    if enabled and getgenv().Settings.WhyIsSheLookingAtMe.Camera.Enabled then
        if Plr ~= nil then
            local shakeOffset = V3(
                math.random(-getgenv().ShakeX, getgenv().ShakeX),
                math.random(-getgenv().ShakeY, getgenv().ShakeY),
                0
            ) * 0.1
local HorizontalLookPosition = CFrame.new(CC.CFrame.p, GetCamPrediction(Plr.Character[getgenv().SelectedPart]).Position+shakeOffset)
      CC.CFrame = CC.CFrame:Lerp(HorizontalLookPosition, getgenv().HorizontalSmoothness)
    end
end
end)
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local vap = {"UpdateMousePos", "GetMousePos", "MousePos", "MOUSE", "MousePosUpdate"}
        if enabled and getnamecallmethod() == "FireServer" and table.find(vap, args[2]) and getgenv().Settings.WhyIsSheLookingAtMe.Enabled and Plr.Character ~= nil and getgenv().Settings.WhyIsSheLookingAtMe.LOCKTYPE == "Namecall" then
            if getgenv().Prediction == "Normal" then
            args[3] = Plr.Character[getgenv().SelectedPart].Position+(V3(Plr.Character.HumanoidRootPart.Velocity.X,math.clamp(Plr.Character.HumanoidRootPart.Velocity.Y,-1,9),Plr.Character.HumanoidRootPart.Velocity.Z)*getgenv().PREDICTION)
            elseif getgenv().Prediction == "Yun" then
            args[3] = Plr.Character[getgenv().SelectedPart].Position+V3(Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.X*getgenv().PREDICTION/10,Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y*getgenv().JUMPPREDICTION/10,Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Z*getgenv().PREDICTION/10)
            else
 
            args[3] = Plr.Character[SelectedPart].Position
 
            end
 
            return old(unpack(args))
        end
        return old(...)
    end)

local Hooks = {}
local Client = game.Players.LocalPlayer

Hooks[1] = hookmetamethod(Client:GetMouse(), "__index", newcclosure(function(self, index)
    if index == "Hit" and getgenv().Settings.WhyIsSheLookingAtMe.LOCKTYPE == "Index" and enabled and Plr.Character ~= nil and getgenv().Settings.WhyIsSheLookingAtMe.Enabled then
            local position = CFrame.new(Plr.Character[getgenv().SelectedPart].Position+(V3(Plr.Character.HumanoidRootPart.Velocity.X,math.clamp(Plr.Character.HumanoidRootPart.Velocity.Y,-1,9),Plr.Character.HumanoidRootPart.Velocity.Z)*getgenv().PREDICTION))
            return position
        
    end
    return Hooks[1](self, index)
end))

getgenv().CFrameDesync = {
           Enabled = false,
           AnglesEnabled = false,
           Type = "Target Strafe",
           Visualize = false,
           VisualizeColor = Color3.fromRGB(0,0,139),
           Random = {
               X = 5,
               Y = 5,
               Z = 5,
               AnglesX = 5,
               AnglesY = 5,
               AnglesZ = 5,
               },
           Custom = {
               X = 5,
               Y = 5,
               Z = 5,
               AnglesX = 5,
               AnglesY = 5,
               AnglesZ = 5,
               },
           TargetStrafe = {
               Speed = 10,
               Height = 10,
               Distance = 7,
               },
}
local straight = {
         Visuals = {},
         Desync = {},
         Hooks = {},
         Connections = {}
}
local RunService = game:GetService("RunService")

task.spawn(function()
straight.Visuals["R6Dummy"] = game:GetObjects("rbxassetid://9474737816")[1]; straight.Visuals["R6Dummy"].Head.Face:Destroy(); for i, v in pairs(straight.Visuals["R6Dummy"]:GetChildren()) do v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70; v.Material = "Neon"; v.Color = Color3.fromRGB(0,0,139); v.CanCollide = false; v.Anchored = false end
end)

local Utility = {}

    function Utility:Connection(connectionType, connectionCallback)
        local connection = connectionType:Connect(connectionCallback)
        straight.Connections[#straight.Connections + 1] = connection
        return connection
    end

Utility:Connection(RunService.PostSimulation, function()
if getgenv().CFrameDesync.AnglesEnabled or getgenv().CFrameDesync.Enabled then
        straight.Desync[1] = lplr.Character.HumanoidRootPart.CFrame
        local cframe = lplr.Character.HumanoidRootPart.CFrame
        if getgenv().CFrameDesync.Enabled then
            if getgenv().CFrameDesync.Type == "Random" then
                cframe = cframe * CFrame.new(math.random(-getgenv().CFrameDesync.Random.X, getgenv().CFrameDesync.Random.X), math.random(-getgenv().CFrameDesync.Random.Y, getgenv().CFrameDesync.Random.Y), math.random(-getgenv().CFrameDesync.Random.Z, getgenv().CFrameDesync.Random.Z))
            elseif getgenv().CFrameDesync.Type == "Custom" then
                cframe = cframe * CFrame.new(getgenv().CFrameDesync.Custom.X, getgenv().CFrameDesync.Custom.Y, getgenv().CFrameDesync.Custom.Z)
            elseif getgenv().CFrameDesync.Type == "Mouse" then
                cframe = CFrame.new(lplr:GetMouse().Hit.Position)
            elseif getgenv().CFrameDesync.Type == "Target Strafe" then
            if enabled and Plr ~= nil then
                local currentTime = tick() 
                cframe = CFrame.new(Plr.Character[getgenv().SelectedPart].Position) * CFrame.Angles(0, 2 * math.pi * currentTime * getgenv().CFrameDesync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, getgenv().CFrameDesync.TargetStrafe.Height, getgenv().CFrameDesync.TargetStrafe.Distance)
            elseif getgenv().CFrameDesync.Type == "Local Strafe" then
                local currentTime = tick() 
                cframe = CFrame.new(lplr.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * currentTime * getgenv().CFrameDesync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, getgenv().CFrameDesync.TargetStrafe.Height, getgenv().CFrameDesync.TargetStrafe.Distance)
                end
      end

        if getgenv().CFrameDesync.Visualize then
            straight.Visuals["R6Dummy"].Parent = workspace
            straight.Visuals["R6Dummy"].HumanoidRootPart.Velocity = Vector3.new()
            straight.Visuals["R6Dummy"]:SetPrimaryPartCFrame(cframe)
            for i, v in pairs(straight.Visuals["R6Dummy"]:GetChildren()) do v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70; v.Material = "Neon"; v.Color = getgenv().CFrameDesync.VisualizeColor; v.CanCollide = false; v.Anchored = false end
        else
            straight.Visuals["R6Dummy"].Parent = nil
        end

        if getgenv().CFrameDesync.AnglesEnabled then
            if getgenv().CFrameDesync.Type == "Random" then
                cframe = cframe * CFrame.Angles(math.rad(math.random(getgenv().CFrameDesync.Random.AnglesX)), math.rad(math.random(getgenv().CFrameDesync.Random.AnglesY)), math.rad(math.random(getgenv().CFrameDesync.Random.AnglesZ)))
            elseif getgenv().CFrameDesync.Type == "Custom" then
                cframe = cframe * CFrame.Angles(math.rad(getgenv().CFrameDesync.Custom.AnglesX), math.rad(getgenv().CFrameDesync.Custom.AnglesY), math.rad(getgenv().CFrameDesync.Custom.AnglesZ))
            end
        end
        lplr.Character.HumanoidRootPart.CFrame = cframe
        RunService.RenderStepped:Wait()
        lplr.Character.HumanoidRootPart.CFrame = straight.Desync[1]
    else
        if straight.Visuals["R6Dummy"].Parent ~= nil then
            straight.Visuals["R6Dummy"].Parent = nil
        end
    end
end
end)

--// Hooks
local MainHookingFunctionsTick = tick()
--
straight.Hooks[1] = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not checkcaller() then
        if key == "CFrame" and straight.Desync[1] and (getgenv().CFrameDesync.AnglesEnabled or getgenv().CFrameDesync.Enabled) and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Humanoid") and lplr.Character:FindFirstChild("Humanoid").Health > 0 then
            if self == lplr.Character.HumanoidRootPart then
                return straight.Desync[1] or CFrame.new()
            elseif self == lplr.Character.Head then
                return straight.Desync[1] and straight.Desync[1] + Vector3.new(0, lplr.Character.HumanoidRootPart.Size / 2 + 0.5, 0) or CFrame.new()
            end
        end
    end
    return straight.Hooks[1](self, key)
end))

local ScriptProperties = {
    ScriptName = "Kabu.shitcakes v2",
    ScriptSizeOne = 700,
    ScriptSizeTwo = 500,
    ScriptAccent = Color3.fromRGB(128,0,128),
    Perms = { 246220626, 2415886442, 2284385613, 2415886442 },
    Owners = { "Jenny’s", "Lion", "rrxvi" },
    Admins = { "nigga", "balls" },

    UserPanel = {
        Status = "Whitelisted"
    }
}



local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Library = library

local Window = Library:New({ Name = ScriptProperties.ScriptName, Accent = Color3.fromRGB(0,0,139) })
--
local parts = {
    "Head",
    "UpperTorso",
    "RightUpperArm",
    "RightLowerArm",
    "RightUpperArm",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftFoot",
    "RightFoot",
    "LowerTorso",
    "LeftHand",
    "RightHand",
    "RightUpperLeg",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "RightLowerLeg"
}
local Pred = 0.14
local Pos = 0
local mouse = game.Players.LocalPlayer:GetMouse()
local Player = game:GetService("Players").LocalPlayer
local runService = game:service("RunService")
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- pages , sections --

    Aiming = Window:Page({ Name = "Main" })
    Rage = Window:Page({ Name = "Rage" })
    Visuals = Window:Page({ Name = "Visuals" })
    Misc = Window:Page({ Name = "Miscellaneous" })
    ConfigSec = Window:Page({ Name = "Configurations" })

local Sections = {
--// Lock
    Aiming = {
        TargetAim = {
            Main = Aiming:Section({ Name = "Target Lock", Side = "Right", Max = 7 }),
            Settings = Aiming:Section({ Name = "Target Lock Settings", Side = "Right", Max = 7 })
        },
        Aimbot = {
            Main = Aiming:Section({ Name = "Camera Lock", Side = "Left", Max = 5 }),
            Settings = Aiming:Section({ Name = "Camera Lock Settings", Side = "Left", Max = 5 })
        },
    Main = Aiming:Section({ Name = "Checks (Cam & Target)", Side = "Right", Max = 5 }),
    },
--// Visuals
    Visuals = {
        MainVisuals = Visuals:Section({ Name = "Esp", Side = "Left", Max = 7 }),
        CrossVisuals = Visuals:Section({ Name = "CrossHair", Side = "Right", Max = 6 }),
        PlayerChams = Visuals:Section({ Name = "Client Visuals", Side = "Left", Max = 7 }),
        CharacterVisuals = Visuals:Section({ Name = "Character Visuals", Side = "right", Max = 5 }),
        BulletTracers = Visuals:Section({ Name = "Bullet Tracers", Side = "Left", Max = 4 }),
        WorldSettings = Visuals:Section({ Name = "World", Side = "right", Max = 7 }),
        OH = Visuals:Section({ Name = "On Hit", Side = "Left" }),
        CGS = Visuals:Section({ Name = "Custom Shoot Sound", Side = "right"}),
        AC = Visuals:Section({ Name = "Animation Changer", Side = "left"}),
        SC = Visuals:Section({ Name = "Skin Changer", Side = "right"}),
   },
--// Rage
    RageSector = {
        Desync = Rage:Section({ Name = "CFrame Desync", Side = "Left", Max = 5 })
    },
--//Misc
    MiscSector = {
        Local = Misc:Section({ Name = "Local Player", Side = "Left" }),
        TT = Misc:Section({ Name = "Trash Talk", Side = "Left" }),
        OP = Misc:Section({ Name = "Other Players", Side = "Left" }),
        Other = Misc:Section({ Name = "Other Stuff", Side = "Right" }),
    },
--//Configs
    Configuations = {
        Configs = ConfigSec:Section({ Name = "Configuration", Side = "Left" }),
        Discord = ConfigSec:Section({ Name = "Discord", Side = "Right" }),
        ScriptStuff = ConfigSec:Section({ Name = "Utilities", Side = "Right" })
    }
}

--// CFrameDesync

CFrameToggle = Sections.RageSector.Desync:Toggle(
            {
            Name = "Enabled",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().CFrameDesync.Enabled = state
            end
        }
)
CFrameVisualToggle = Sections.RageSector.Desync:Toggle(
            {
            Name = "Visualize",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().CFrameDesync.Visualize = state
            end
        }
)
SpeedSlider = Sections.RageSector.Desync:Slider(
        {
        Name = "Speed",
        Minimum = 0,
        Maximum = 100,
        Default = 5,
        Decimals = 0.5,
        Pointer = "57",
        callback = function(E)
        getgenv().CFrameDesync.TargetStrafe.Speed = E
        end
    }
    )
HeightSlider = Sections.RageSector.Desync:Slider(
        {
        Name = "Height",
        Minimum = 0,
        Maximum = 100,
        Default = 5,
        Decimals = 0.5,
        Pointer = "57",
        callback = function(E)
        getgenv().CFrameDesync.TargetStrafe.Height = E
        end
    }
    )
DistanceSlider = Sections.RageSector.Desync:Slider(
        {
        Name = "Distance",
        Minimum = 0,
        Maximum = 100,
        Default = 5,
        Decimals = 0.5,
        Pointer = "57",
        callback = function(E)
        getgenv().CFrameDesync.TargetStrafe.Distance = E
        end
    }
    )

--// Camera Lock

CamlockToggle = Sections.Aiming.Aimbot.Main:Toggle(
            {
            Name = "Enabled",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().Settings.WhyIsSheLookingAtMe.Camera.Enabled = state
            end
        }
)
Sections.Aiming.Aimbot.Settings:Box { Name = "Prediction", Callback = function(text)
        getgenv().CAMPREDICTION = text
end }
Sections.Aiming.Aimbot.Settings:Box { Name = "Smoothness", Callback = function(text)
        getgenv().HorizontalSmoothness = text
end }
AutoooPredThing = Sections.Aiming.Aimbot.Settings:Toggle(
            {
            Name = "Auto Prediction",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().Settings.WhyIsSheLookingAtMe.AdvancedAutoPred = state
            end
        }
)
--// Target Lock
TargetAimToggle = Sections.Aiming.TargetAim.Main:Toggle(
            {
            Name = "Enabled",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().Settings.WhyIsSheLookingAtMe.Enabled = state
            end
        }
)
AimlockMethod = Sections.Aiming.TargetAim.Main:Dropdown(
        {
        Name = "Method",
        Options = { "Namecall", "Index" },
        Default = "Namecall",
        Pointer = "5",
        callback = function(state)
            getgenv().Settings.WhyIsSheLookingAtMe.LOCKTYPE = state
        end
    }
)
Sections.Aiming.TargetAim.Settings:Box { Name = "Prediction", Callback = function(text)
        getgenv().PREDICTION = text
end }
AutoPredThing = Sections.Aiming.TargetAim.Settings:Toggle(
            {
            Name = "Auto Prediction",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().Settings.WhyIsSheLookingAtMe.AUTOPRED = state
            end
        }
)
AutoPredMethod = Sections.Aiming.TargetAim.Settings:Dropdown(
        {
        Name = "AutoPred Type",
        Options = { "Normal", "Math" },
        Default = "Normal",
        Pointer = "5",
        callback = function(state)
        getgenv().AutoPredType = state
        end
    }

)
--// Checks
AimPart = Sections.Aiming.Main:Dropdown(
        {
        Name = "AimPart",
        Options = { "Head",
    "UpperTorso",
    "RightUpperArm",
    "RightLowerArm",
    "RightUpperArm",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftFoot",
    "RightFoot",
    "LowerTorso",
    "LeftHand",
    "RightHand",
    "RightUpperLeg",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "RightLowerLeg" },
        Default = "HumanoidRootPart",
        Pointer = "5",
        callback = function(state)
        getgenv().SelectedPart = state
        end
    }

)
KOCheckToggle = Sections.Aiming.Main:Toggle(
            {
            Name = "KO Check",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().UnlockOnDeath = state
            end
        }
)
WallCheckToggle = Sections.Aiming.Main:Toggle(
            {
            Name = "Wall Check (NOT ADDED YET)",
            Default = false,
            Pointer = "5",
            callback = function(state)
            print(state)
            end
        }
)

--// Player Chams

WeaponEffectsEnabled = false
WeaponEffectsMaterial = "ForceField"
WeaponEffectsColor = Color3.fromRGB(128,0,128)
SelfChamsColor = Color3.fromRGB(128,0,128)
SelfChams = false
SelfChamsMaterial = "ForceField"
CloneMaterial = "ForceField"

function Weld(x,y)
       local W = Instance.new("Weld")
       W.Part0 = x
       W.Part1 = y
       local CJ = CFrame.new(x.Position)
       local C0 = x.CFrame:inverse()*CJ
       local C1 = y.CFrame:inverse()*CJ
       W.C0 = C0
       W.C1 = C1
       W.Parent = x
end

CusCharToggle = Sections.Visuals.PlayerChams:Toggle(
            {
            Name = "Custom Character",
            Default = false,
            Pointer = "5",
            callback = function(state)
    if state then 
        for i,v in pairs(LocalPlayer.Character:GetDescendants()) do 
            if v:IsA("BasePart") or v:IsA("Decal") then 
                v.Transparency = 1 
            end 
        end 
        
getgenv().Custom = LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
fuc:Destroy()
wait(5)
fuc = Instance.new("Part",workspace) 
fuc.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
fuc.CanCollide = false
fuck = Instance.new("SpecialMesh")
fuck.Parent = fuc
fuck.MeshType ="FileMesh"
    
    if getgenv().CharacterType  == "AmongUs" then 
        fuck.Scale=Vector3.new(0.2,0.2,0.2) 
        fuck.TextureId="http://www.roblox.com/asset/?id=6686375937" 
        fuck.MeshId="http://www.roblox.com/asset/?id=6686375902"
    elseif Option == "SpongeBob" then 
        fuck.Scale=Vector3.new(2,2,2) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=5408463358" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=5408463211" -- Mesh Id
      elseif Option  == "Patrick" then 
    fuck.Scale=Vector3.new(0.4,0.4,0.4) 
        fuck.TextureId="http://www.roblox.com/asset/?id=5730253510"
        fuck.MeshId="http://www.roblox.com/asset/?id=5730253467" 
    elseif Option == "MaxWell" then
    fuck.Scale=Vector3.new(0.2,0.2,0.2) 
        fuck.TextureId="http://www.roblox.com/asset/?id=12303996609"
        fuck.MeshId="http://www.roblox.com/asset/?id=12303996327"  
    elseif getgenv().CharacterType  == "Sonic" then 
        fuck.Scale=Vector3.new(0.1,0.1,0.1) 
        fuck.TextureId="http://www.roblox.com/asset/?id=6901422268"
        fuck.MeshId="http://www.roblox.com/asset/?id=6901422170"
    elseif getgenv().CharacterType  == "Chicken" then     
        fuck.Scale=Vector3.new(3,3,3) 
        fuck.TextureId="http://www.roblox.com/asset/?id=2114220248" 
        fuck.MeshId="http://www.roblox.com/asset/?id=2114220154" 
end 

    Weld(LocalPlayer.Character.HumanoidRootPart,fuc)

    for i,v in pairs(LocalPlayer.Character:GetDescendants()) do 
        if v:IsA("BasePart") or v:IsA("Decal") then 
            v.Transparency = 1
        end 
    end 

end)
        
        fuc = Instance.new("Part",workspace) 
        fuc.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        fuc.CanCollide = false
        fuck = Instance.new("SpecialMesh")
        fuck.Parent = fuc
        fuck.MeshType ="FileMesh"

        if getgenv().CharacterType  == "AmongUs" then 
        fuck.Scale=Vector3.new(0.2,0.2,0.2) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=6686375937" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=6686375902" -- Mesh Id
    elseif Option == "SpongeBob" then 
        fuck.Scale=Vector3.new(2,2,2) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=5408463358" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=5408463211" -- Mesh Id
      elseif Option  == "Patrick" then 
    fuck.Scale=Vector3.new(0.4,0.4,0.4) 
        fuck.TextureId="http://www.roblox.com/asset/?id=5730253510"
        fuck.MeshId="http://www.roblox.com/asset/?id=5730253467" 
    elseif Option == "MaxWell" then
    fuck.Scale=Vector3.new(0.2,0.2,0.2) 
        fuck.TextureId="http://www.roblox.com/asset/?id=12303996609"
        fuck.MeshId="http://www.roblox.com/asset/?id=12303996327"  
    elseif getgenv().CharacterType  == "Sonic" then 
        fuck.Scale=Vector3.new(0.1,0.1,0.1) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=6901422268" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=6901422170"
    elseif getgenv().CharacterType  == "Chicken" then     
        fuck.Scale=Vector3.new(3,3,3) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=2114220248" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=2114220154" -- Mesh Id
    end 

        Weld(LocalPlayer.Character.HumanoidRootPart,fuc)
        else 
        fuc:Destroy()
        
        for i,v in pairs(LocalPlayer.Character:GetDescendants()) do 
            if v:IsA("BasePart") or v:IsA("Decal") then 
                v.Transparency = 0 
            end 
        end 
        
        getgenv().Custom:Disconnect()
        
        LocalPlayer.Character.HumanoidRootPart.Transparency = 1
    end 
end 
}
)
CusCharOption= Sections.Visuals.PlayerChams:Dropdown(
        {
        Name = "Morph Selection",
        Options =  {"AmongUs", "SpongeBob", "Patrick", "MaxWell", "Sonic", "Chicken"},
        Default = "N/A",
        Pointer = "54",
        callback = function(Option)
    getgenv().CharacterType = Option
    
    if Option == "AmongUs" then 
        fuck.Scale=Vector3.new(0.2,0.2,0.2) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=6686375937" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=6686375902" -- Mesh Id
    elseif Option == "SpongeBob" then 
        fuck.Scale=Vector3.new(2,2,2) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=5408463358" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=5408463211" -- Mesh Id
      elseif Option  == "Patrick" then 
    fuck.Scale=Vector3.new(0.4,0.4,0.4) 
        fuck.TextureId="http://www.roblox.com/asset/?id=5730253510"
        fuck.MeshId="http://www.roblox.com/asset/?id=5730253467" 
    elseif Option == "MaxWell" then
    fuck.Scale=Vector3.new(0.2,0.2,0.2) 
        fuck.TextureId="http://www.roblox.com/asset/?id=12303996609"
        fuck.MeshId="http://www.roblox.com/asset/?id=12303996327"  
    elseif Option == "Sonic" then 
        fuck.Scale=Vector3.new(0.25,0.25,0.25) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=6901422268" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=6901422170"
    elseif Option == "Chicken" then     
        fuck.Scale=Vector3.new(3,3,3) --sizerbxassetid://6901422268
        fuck.TextureId="http://www.roblox.com/asset/?id=2114220248" --Texture / Skin
        fuck.MeshId="http://www.roblox.com/asset/?id=2114220154" -- Mesh Id
    end 
end }
)

SelfChamToggle = Sections.Visuals.PlayerChams:Toggle(
            {
            Name = "Self Cham",
            Default = false,
            Pointer = "5",
            callback = function(state)
            SelfChams = state
            end
        }
)

SelfChamToggle:Colorpicker(
    {
    Name = "Self Cham Color",
    Info = "Self Cham Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    SelfChamsColor = ztx
    end
}
)

SelfDrop = Sections.Visuals.PlayerChams:Dropdown(
        {
        Name = "Self Cham Material",
        Options = { "ForceField", "Glass", "Neon" },
        Default = "ForceField",
        Pointer = "54",
        callback = function(state)
            SelfChamsMaterial = state
        end
    }
)

WeaponEffectToggle = Sections.Visuals.PlayerChams:Toggle(
            {
            Name = "Weapon Cham",
            Default = false,
            Pointer = "5",
            callback = function(state)
            WeaponEffectsEnabled = state
            end
        }
)

WeaponEffectToggle:Colorpicker(
    {
    Name = "Weapon Cham Color",
    Info = "Weapon Cham Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    WeaponEffectsColor = ztx
    end
}
)

GunDrop = Sections.Visuals.PlayerChams:Dropdown(
        {
        Name = "Weapon Cham Material",
        Options = { "ForceField", "Glass", "Neon" },
        Default = "ForceField",
        Pointer = "5",
        callback = function(state)
            WeaponEffectsMaterial = state
        end
    }
)

PencakSilat = Sections.Visuals.PlayerChams:Toggle(
            {
            Name = "Radio Cham",
            Default = false,
            Pointer = "5",
            callback = function(state)
            while state do 
task.wait()
game.Players.LocalPlayer.Character.Radio.Material = Enum.Material.ForceField
end 
            end
        }
)

PencakSilaaqt = Sections.Visuals.PlayerChams:Toggle(
            {
            Name = "Clone Cham",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CloneCham = state
            end
        }
)

PencakSilaaqt:Colorpicker(
    {
    Name = "Clone Cham Color",
    Info = "Clone Cham Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    CloneColor = ztx
    end
}
)

GunDajaj = Sections.Visuals.PlayerChams:Dropdown(
        {
        Name = "Clone Cham Material",
        Options = { "ForceField", "Glass", "Neon" },
        Default = "ForceField",
        Pointer = "5",
        callback = function(state)
            CloneMaterial = state
        end
    }
)

Sections.Visuals.PlayerChams:Box { Name = "LifeTime", Callback = function(text)
        CloneLifeTime = text
end }

task.spawn(function ()
            while true do
                wait()
                if CloneCham then
                    repeat
                        game.Players.LocalPlayer.Character.Archivable = true
                        local Clone = game.Players.LocalPlayer.Character:Clone()
                        for _,Obj in next, Clone:GetDescendants() do
                        if Obj.Name == "HumanoidRootPart" or Obj:IsA("Humanoid") or Obj:IsA("LocalScript") or Obj:IsA("Script") or Obj:IsA("Decal") then
                            Obj:Destroy()
                        elseif Obj:IsA("BasePart") or Obj:IsA("Meshpart") or Obj:IsA("Part") then
                            if Obj.Transparency == 1 then
                            Obj:Destroy()
                            else
                            Obj.CanCollide = false
                            Obj.Anchored = true
                            Obj.Material = CloneMaterial
                            Obj.Color = CloneColor
                            Obj.Transparency = 0
                            Obj.Size = Obj.Size + Vector3.new(0.03, 0.03, 0.03)   
                        end
                    end
                        pcall(function()
                            Obj.CanCollide = false
                        end)
                    end
                    Clone.Parent = game.Workspace
                    wait(CloneLifeTime)
                    Clone:Destroy()  
                    until CloneCham == false
                end
            end
        end)

TrailColor = Color3.fromRGB(0,0,0)
PencakSilit = Sections.Visuals.PlayerChams:Toggle(
            {
            Name = "Trail",
            Default = false,
            Pointer = "5",
            callback = function(state)
if state then
    local Character = game.Players.LocalPlayer.Character
    for i,v in pairs(Character:GetChildren()) do
         if v:IsA("BasePart") then
    local trail = Instance.new("Trail", v)
    trail.Texture = "rbxassetid://1390780157"
       trail.Parent = v
       trail.Name = "Trail"
       local attachment0 = Instance.new("Attachment", v)
       attachment0.Name = "TrailAttachment0"
       local attachment1 = Instance.new("Attachment",game.Players.LocalPlayer.Character.HumanoidRootPart)
       attachment1.Name = "TrailAttachment1"
       trail.Attachment0 = attachment0
       trail.Attachment1 = attachment1
       trail.Color = TrailColor
         end
    end
end
if not state then
game.Players.LocalPlayer.Character:GetChildren():IsA("BasePart").TrailAttachment0:Destroy()
game.Players.LocalPlayer.Character:GetChildren():IsA("BasePart").TrailAttachment1:Destroy()
game.Players.LocalPlayer.Character:GetChildren():IsA("BasePart").Trail:Destroy()
    end
  end
  }
)
    

PencakSilit:Colorpicker(
    {
    Name = "Trail Color",
    Info = "Trail Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    TrailColor = ztx
    end
}
)

-- // OnHit

DMGIndicator = Sections.Visuals.OH:Toggle(
            {
            Name = "DMG Indicator",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().LionIsHotTBH= state
            end
        }
)

DMage = Sections.Visuals.OH:Dropdown(
        {
        Name = "Blood Image",
        Options = {
        "illuminati",
        "Violet",
        "Asuka",
        "Rem",
        "Astolfo",
          "Blank"
     
    },
        Default = "Blank",
        Pointer = "5",
        callback = function(Option)
if Option == "illuminati" then
          game.ReplicatedStorage.DMGIndicator.Image = "http://www.roblox.com/asset/?id=487518317"
     elseif Option == "Violet" then
          game.ReplicatedStorage.DMGIndicator.Image = "http://www.roblox.com/asset/?id=10025463033" 
     elseif Option == "Asuka" then
          game.ReplicatedStorage.DMGIndicator.Image =  "http://www.roblox.com/asset/?id=10025498995"
     elseif Option == "Rem" then
          game.ReplicatedStorage.DMGIndicator.Image = "http://www.roblox.com/asset/?id=10025524529"
     elseif Option == "Astolfo" then
          game.ReplicatedStorage.DMGIndicator.Image = "http://www.roblox.com/asset/?id=10025538975"
     elseif Option == "Blank" then
          game.ReplicatedStorage.DMGIndicator.Image = "http://www.roblox.com/asset/?id=8968805098"
     end
    end 
}
)

-- // CrossHair

CursorEnabled = Sections.Visuals.CrossVisuals:Toggle(
            {
            Name = "Swastika CrossHair",
            Default = false,
            Pointer = "5",
            callback = function(state)
            Swastika.Visible = state
            end
        }
)


CursorRainbow = Sections.Visuals.CrossVisuals:Toggle(
            {
            Name = "Rainbow Swastika",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CursorRainbow = state
            end
        }
)

CursorSpin = Sections.Visuals.CrossVisuals:Toggle(
            {
            Name = "Spinning Swastika",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CursorSpin = state
            end
        }
)


Sections.Visuals.CrossVisuals:Box { Name = "Spin Speed", Callback = function(text)
 CursorSpinSpeed = text
end }

DHSpin = Sections.Visuals.CrossVisuals:Toggle(
            {
            Name = "DH Crosshair Spin",
            Default = false,
            Pointer = "5",
            callback = function(state)
            SpinningCursor = state
            end
        }
)

Sections.Visuals.CrossVisuals:Box { Name = "Spin Speed", Callback = function(text)
SpinPower = text
end }

-- // Characters

AsTheStrongestOneSay = Sections.Visuals.CharacterVisuals:Toggle(
            {
            Name = "Korblox",
            Default = false,
            Pointer = "5",
            callback = function(first)
            if first then
game.Players.LocalPlayer.Character.RightFoot.MeshId = "http://www.roblox.com/asset/?id=902942093"
			game.Players.LocalPlayer.Character.RightLowerLeg.MeshId = "http://www.roblox.com/asset/?id=902942093"
			game.Players.LocalPlayer.Character.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
			game.Players.LocalPlayer.Character.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
			game.Players.LocalPlayer.Character.RightFoot.Transparency = 1
			game.Players.LocalPlayer.Character.RightLowerLeg.Transparency = 1
		else
			game.Players.LocalPlayer.Character.RightFoot.MeshId = Storage.RightFootMeshID
			game.Players.LocalPlayer.Character.RightLowerLeg.MeshId = Storage.RightLowerLegMeshID
			game.Players.LocalPlayer.Character.RightUpperLeg.MeshId = Storage.RightUpperLegMeshID
			game.Players.LocalPlayer.Character.RightUpperLeg.TextureID = Storage.RightUpperLegMeshID
			game.Players.LocalPlayer.Character.RightFoot.Transparency = Storage.RightFootTransparency
			game.Players.LocalPlayer.Character.RightLowerLeg.Transparency = Storage.RightLowerLegTransparency
		end
            end
        }
)


GojoSenseiSukunaIsStrong = Sections.Visuals.CharacterVisuals:Toggle(
            {
            Name = "Blizzard Beast Mode",
            Default = false,
            Pointer = "5",
            callback = function(first)
            if first then
	pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://209712379"
				end
			)
		else
			pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = Storage.Face
				end
			)
		end
 	end
   }
)

IfUFoughtHim = Sections.Visuals.CharacterVisuals:Toggle(
            {
            Name = "Beast Mode",
            Default = false,
            Pointer = "5",
            callback = function(first)
            if first then
	pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://127959433"
				end
			)
		else
			pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = Storage.Face
				end
			)
		end
	end
   }
)

WouldYouLose = Sections.Visuals.CharacterVisuals:Toggle(
            {
            Name = "SSHF",
            Default = false,
            Pointer = "5",
            callback = function(first)
            if first then
	pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://494290547"
				end
			)
		else
			pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = Storage.Face
				end
			)
		end
	end
   }
)

AndTheGojoatAnsweredNahIdWin = Sections.Visuals.CharacterVisuals:Toggle(
            {
            Name = "Playful Vampire",
            Default = false,
            Pointer = "5",
            callback = function(first)
            if first then
pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://2409281591"
				end
			)
		else
			pcall(
				function()
					game.Players.LocalPlayer.Character.Head.face.Texture = Storage.Face
				end
			)
		end
	end
  }
)

-- // Bullet Tracers

BT = Sections.Visuals.BulletTracers:Toggle(
            {
            Name = "Bullet Tracers",
            Default = false,
            Pointer = "5",
            callback = function(state)
            BulletTracers = state
            end
        }
)

BT:Colorpicker(
    {
    Name = "Bullet Tracers Color",
    Info = "Bullet Tracers Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    BTColor = ztx
    end
}
)

HAHAHAHA = Sections.Visuals.BulletTracers:Toggle(
            {
            Name = "Hide Bullet Rays",
            Default = false,
            Pointer = "5",
            callback = function(state)
            BR = state
            end
        }
)

-- // World

CustomAmbient = false
AmbientColor = Color3.fromRGB(160,32,240)
CustomColorShift = false
ColorShift = Color3.fromRGB(255,255,255)
CustomBrightness = false
BrightnessAmount = 0
CustomExposure = false
ExposureAmount = 0
CustomClockTime = false
ClockTimeNumber = 0
CustomFog = false
FogStart = 0
FogEnd = 0
FogColor = Color3.fromRGB(255,255,255)
CustomSaturtation = false
SaturtationAmount = 0

AreUGay = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Ambient",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomAmbient = state
            end
        }
)

AreUGay:Colorpicker(
    {
    Name = "Ambient Color",
    Info = "Ambient Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(160,32,240),
    Pointer = "63",
    callback = function(ztx)
    AmbientColor = ztx
    end
}
)

AreUKooly = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Color Shift",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomColorShift = state
            end
        }
)

AreUKooly:Colorpicker(
    {
    Name = "Color Shift Color",
    Info = "Color Shift Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    ColorShift = ztx
    end
}
)

AreUBlack = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Brightness",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomBrightness = state
            end
        }
)

MapBrightness = Sections.Visuals.WorldSettings:Slider(
        {
        Name = "Brightness Amount",
        Minimum = 0,
        Maximum = 50,
        Default = 1,

        Decimals = 0.1,
        Pointer = "57",
        callback = function(E)
            BrightnessAmount = E
        end
    }
    )
    
    AreUZaza= Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Saturtation",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomSaturtation = state
            end
        }
)

MapSatur= Sections.Visuals.WorldSettings:Slider(
        {
        Name = "Saturtation Amount",
        Minimum = 0,
        Maximum = 10,
        Default = 0.10000000149012,

        Decimals = 0.1,
        Pointer = "57",
        callback = function(E)
            SaturtationAmount = E
        end
    }
    )
    
    AreUWhite = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Exposure",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomExposure= state
            end
        }
)

MapBrightness = Sections.Visuals.WorldSettings:Slider(
        {
        Name = "Exposure Amount",
        Minimum = -5,
        Maximum = 5,
        Default = 1,

        Decimals = 0.01,
        Pointer = "57",
        callback = function(E)
            ExposureAmount = E
        end
    }
    )
    
    AreURainbow = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Clock Time",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomClockTime= state
            end
        }
)

CockTime = Sections.Visuals.WorldSettings:Slider(
        {
        Name = "Clock Time Number (Hours)",
        Minimum = 0.1,
        Maximum = 24,
        Default = 0,

        Decimals = 0.01,
        Pointer = "57",
        callback = function(E)
            ClockTimeNumber  = E
        end
    }
    )
    
    AreURainbowGaga = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Fog",
            Default = false,
            Pointer = "5",
            callback = function(state)
            CustomFog = state
            end
        }
)

FogStart = Sections.Visuals.WorldSettings:Slider(
        {
        Name = "Fog Start",
        Minimum = 0,
        Maximum = 5000,
        Default = 750,

        Decimals = 0.1,
        Pointer = "57",
        callback = function(E)
            FogStart  = E
        end
    }
    )
    
    FogEnd = Sections.Visuals.WorldSettings:Slider(
        {
        Name = "Fog End",
        Minimum = 0,
        Maximum = 5000,
        Default = 750,

        Decimals = 0.1,
        Pointer = "57",
        callback = function(E)
            FogEnd  = E
        end
    }
    )
    
    AreURainbowGaga:Colorpicker(
    {
    Name = "Fog Color",
    Info = "Fog Color",
    Alpha = 0.5,
    Default = Color3.fromRGB(255,255,255),
    Pointer = "63",
    callback = function(ztx)
    FogColor = ztx
    end
}
)

    
local skybox = Instance.new("Sky")
skybox.Parent = game.Lighting

SkyBobox = Sections.Visuals.WorldSettings:Toggle(
            {
            Name = "Custom Skyboxes",
            Default = false,
            Pointer = "5",
            callback = function(Boolean)
getgenv().Skybox = Boolean
    
    if not getgenv().Skybox then 
        skybox.SkyboxBk = "rbxassetid://600830446" 
        skybox.SkyboxDn = "rbxassetid://600831635" 
        skybox.SkyboxFt = "rbxassetid://600832720" 
        skybox.SkyboxLf = "rbxassetid://600886090" 
        skybox.SkyboxRt = "rbxassetid://600833862" 
        skybox.SkyboxUp = "rbxassetid://600835177" 
    end
   end
 }
)


ImABadGirl = Sections.Visuals.WorldSettings:Dropdown(
        {
        Name = "Skyboxes Option",
        Options = { "Normal", "CatGirl", "DoomSpire", "Vibe", "Blue Aurora"},
        Default = "Normal",
        Pointer = "5",
        callback = function(Option)
getgenv().SkyBoxOption = Option
   
    if getgenv().Skybox then 
        if getgenv().SkyBoxOption == "DoomSpire" then 
        skybox.SkyboxBk = "rbxassetid://6050664592" 
        skybox.SkyboxDn = "rbxassetid://6050648475" 
        skybox.SkyboxFt = "rbxassetid://6050644331" 
        skybox.SkyboxLf = "rbxassetid://6050649245" 
        skybox.SkyboxRt = "rbxassetid://6050649718" 
        skybox.SkyboxUp = "rbxassetid://6050650083" 
        elseif  getgenv().SkyBoxOption == "Normal" then 
        skybox.SkyboxBk = "rbxassetid://600830446" 
        skybox.SkyboxDn = "rbxassetid://600831635" 
        skybox.SkyboxFt = "rbxassetid://600832720" 
        skybox.SkyboxLf = "rbxassetid://600886090" 
        skybox.SkyboxRt = "rbxassetid://600833862" 
        skybox.SkyboxUp = "rbxassetid://600835177" 
        elseif  getgenv().SkyBoxOption == "CatGirl" then 
        skybox.SkyboxBk = "rbxassetid://444167615" 
        skybox.SkyboxDn = "rbxassetid://444167615" 
        skybox.SkyboxFt = "rbxassetid://444167615" 
        skybox.SkyboxLf = "rbxassetid://444167615" 
        skybox.SkyboxRt = "rbxassetid://444167615" 
        skybox.SkyboxUp = "rbxassetid://444167615" 
        elseif  getgenv().SkyBoxOption == "Vibe" then 
        skybox.SkyboxBk = "rbxassetid://1417494030" 
        skybox.SkyboxDn = "rbxassetid://1417494146" 
        skybox.SkyboxFt = "rbxassetid://1417494253" 
        skybox.SkyboxLf = "rbxassetid://1417494402" 
        skybox.SkyboxRt = "rbxassetid://1417494499" 
        skybox.SkyboxUp = "rbxassetid://1417494643" 
        elseif  getgenv().SkyBoxOption == "Blue Aurora" then 
        skybox.SkyboxBk = "rbxassetid://12064107" 
        skybox.SkyboxDn = "rbxassetid://12064152" 
        skybox.SkyboxFt = "rbxassetid://12064121" 
        skybox.SkyboxLf = "rbxassetid://12063984" 
        skybox.SkyboxRt = "rbxassetid://12064115" 
        skybox.SkyboxUp = "rbxassetid://12064131"
        end 
    end
  end
  }
)

Sections.Visuals.BulletTracers:Box { Name = "Bullet Width", Callback = function(text)
BulletWidth = text
end }

-- // Custom Gun SFX
CGSVolume = 5

SCG = Sections.Visuals.CGS:Toggle(
            {
            Name = "Custom Gun SFX",
            Default = false,
            Pointer = "5",
            callback = function(Boolean)
            CustomGunSFX = Boolean
            end
           }
     )

Sections.Visuals.CGS:Box { Name = "ID", Callback = function(Text)
CGSID = Text
end }

Sections.Visuals.CGS:Box { Name = "Volume", Callback = function(text)
CGSVolume = text
end }

Lmoaiisiwi= Sections.Visuals.CGS:Dropdown(
        {
        Name = "Custom Shoot Sound",
        Options = { "BameWare", "Skeet", "Bonk", "Lazer Beam", "Windows XP Error", "TF2 Hitsound", "TF2 Critical", "TF2 Bat", "Bow Hit", "Bow", "OSU", "Minecraft Hit", "Steve", "1nn","Rust","TF2 Pan","Neverlose","Mario", },
        Default = "Nothing",
        Pointer = "5",
        callback = function(Option)
        if Option == "BameWare" then
        CGSID = 3124331820
        elseif Option == "Skeet" then
        CGSID = 4753603610
        elseif Option == "Bonk" then
        CGSID = 3765689841
        elseif Option == "Lazer Beam" then
        CGSID = 130791043
        elseif Option == "Windows XP Error" then
        CGSID = 160715357
        elseif Option == "TF2 Hitsound" then
        CGSID = 3455144981
        elseif Option == "TF2 Critical" then
        CGSID = 296102734
        elseif Option == "TF2 Bat" then
        CGSID = 3333907347
        elseif Option == "Bow Hit" then
        CGSID = 1053296915
        elseif Option == "Bow" then
        CGSID = 3442683707
        elseif Option == "OSU" then
        CGSID = 7147454322
        elseif Option == "Minecraft Hit" then
        CGSID = 4018616850
        elseif Option == "Steve" then
        CGSID = 5869422451
        elseif Option == "1nn" then
        CGSID = 7349055654
        elseif Option == "Rust" then
        CGSID = 3744371091
        elseif Option == "TF2 Pan" then
        CGSID = 3431749479
        elseif Option == "Neverlose" then
        CGSID = 8679627751
        elseif Option == "Mario" then
        CGSID = 5709456554
        end
      end }
    )

-- // Animation Changer
ACaoa = Sections.Visuals.AC:Toggle(
            {
            Name = "Enabled",
            Default = false,
            Pointer = "5",
            callback = function(Boolean)
            Anim = Boolean
            end
          }
    )
    
    ImABadGirla = Sections.Visuals.AC:Dropdown(
        {
        Name = "Idle",
        Options = {
        "Nothing",
        "Astronaut",
        "Bubbly",
        "Cartoony",
        "Confindent",
        "Cowboy",
        "Zombie",
        "Elder",
        "Ghost",
        "Knight",
        "Levitation",
        "Mage",
        "Astronaut",
        "Ninja",
        "OldSchool",
        "Patrol",
        "Pirate",
        "Popstar",
        "Princess",
        "Robot",
        "Rthro",
        "Stylish",
        "Superhero",
        "Toy",
        "Vampire",
        "Werewolf"
    },
        Default = "Rthro",
        Pointer = "5",
        callback = function(Option)
        local ballocks = Option

        if Anim then
            while wait(3) do
                if Anim then
                    LocalPlayer.Character.Animate.idle.Animation1.AnimationId = AnimationModule[ballocks][1]
                    LocalPlayer.Character.Animate.idle.Animation2.AnimationId = AnimationModule[ballocks][2]
                end
            end
        end
     end 
    }
)

LionMyLittleNigga = Sections.Visuals.AC:Dropdown(
        {
        Name = "Walk",
        Options = {
        "Nothing",
        "Astronaut",
        "Bubbly",
        "Cartoony",
        "Confindent",
        "Cowboy",
        "Zombie",
        "Elder",
        "Ghost",
        "Knight",
        "Levitation",
        "Mage",
        "Astronaut",
        "Ninja",
        "OldSchool",
        "Patrol",
        "Pirate",
        "Popstar",
        "Princess",
        "Robot",
        "Rthro",
        "Stylish",
        "Superhero",
        "Toy",
        "Vampire",
        "Werewolf"
    },
        Default = "Rthro",
        Pointer = "5",
        callback = function(Option)
    local ballockss = Option

        if Anim then
            while wait(3) do
                if Anim then
                    LocalPlayer.Character.Animate.walk.WalkAnim.AnimationId = AnimationModule[ballockss][3]
                end
            end
        end
    end
} )

BigGuysExploit = Sections.Visuals.AC:Dropdown(
        {
        Name = "Run",
        Options = {
        "Nothing",
        "Astronaut",
        "Bubbly",
        "Cartoony",
        "Confindent",
        "Cowboy",
        "Zombie",
        "Elder",
        "Ghost",
        "Knight",
        "Levitation",
        "Mage",
        "Astronaut",
        "Ninja",
        "OldSchool",
        "Patrol",
        "Pirate",
        "Popstar",
        "Princess",
        "Robot",
        "Rthro",
        "Stylish",
        "Superhero",
        "Toy",
        "Vampire",
        "Werewolf"
    },
        Default = "Rthro",
        Pointer = "5",
        callback = function(Option)
        local Run = Option

        if Anim then
            while wait(3) do
                if Anim then
                    LocalPlayer.Character.Animate.run.RunAnim.AnimationId = AnimationModule[Run][4]
                end
            end
        end
    end
} )
        
        FourBigGays = Sections.Visuals.AC:Dropdown(
        {
        Name = "Fall",
        Options = {
        "Nothing",
        "Astronaut",
        "Bubbly",
        "Cartoony",
        "Confindent",
        "Cowboy",
        "Zombie",
        "Elder",
        "Ghost",
        "Knight",
        "Levitation",
        "Mage",
        "Astronaut",
        "Ninja",
        "OldSchool",
        "Patrol",
        "Pirate",
        "Popstar",
        "Princess",
        "Robot",
        "Rthro",
        "Stylish",
        "Superhero",
        "Toy",
        "Vampire",
        "Werewolf"
    },
        Default = "Rthro",
        Pointer = "5",
        callback = function(Option)
        local fall = Option

        if Anim then
            while wait(3) do
                if Anim then
                    LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = AnimationModule[fall][7]
                end
            end
        end
    end
})
        ACDisabler = Sections.Visuals.AC:Dropdown(
        {
        Name = "Jump",
        Options = {
        "Nothing",
        "Astronaut",
        "Bubbly",
        "Cartoony",
        "Confindent",
        "Cowboy",
        "Zombie",
        "Elder",
        "Ghost",
        "Knight",
        "Levitation",
        "Mage",
        "Astronaut",
        "Ninja",
        "OldSchool",
        "Patrol",
        "Pirate",
        "Popstar",
        "Princess",
        "Robot",
        "Rthro",
        "Stylish",
        "Superhero",
        "Toy",
        "Vampire",
        "Werewolf"
    },
        Default = "Rthro",
        Pointer = "5",
        callback = function(Option)
    local pooop = Option

        if Anim then
            while wait(3) do
                if Anim then
                    LocalPlayer.Character.Animate.jump.JumpAnim.AnimationId = AnimationModule[pooop][5]
                end
            end
        end
    end
})

-- // Skin Changer

--SOON

--// MISCS

Sections.MiscSector.Local:Button { Name = "Rightclick", Callback = function()
local Player = game.Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Corporations"
ScreenGui.ResetOnSpawn = false -- Keep the GUI after respawn
ScreenGui.Parent = PlayerGui

local TextButton = Instance.new("TextButton")
TextButton.Name = "Moonlight.lua"
TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(128,0,128)
TextButton.BackgroundTransparency = 0.5
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(1, -120, 0, 100) -- Adjusted the position to top right corner
TextButton.Size = UDim2.new(0, 100, 0, 18)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Rightclick"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 18
local UICorner = Instance.new("UICorner")
UICorner.Parent = TextButton

-- Function to send the keybind
local function OnButtonClick()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "ButtonL2", false, game)
end

-- Event connection
TextButton.MouseButton1Click:Connect(OnButtonClick)
end }

Sections.MiscSector.Local:Button { Name = "CFrame Speed", Callback = function()
-- Initial values
getgenv().Speed = false
getgenv().SpeedAmount = 2
-- Create a basic GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Toggle Speed"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(1, -120, 0, 75) -- Adjusted the position to top right corner
ToggleButton.Size = UDim2.new(0, 100, 0, 18)
ToggleButton.BackgroundColor3 = Color3.fromRGB(128,0,128)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local UICorner = Instance.new("UICorner")
UICorner.Parent = ToggleButton
local function onButtonClicked()
    getgenv().Speed = not getgenv().Speed
end
ToggleButton.MouseButton1Click:Connect(onButtonClicked)
-- Your existing code modified for the GUI
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().Speed then
        lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + lplr.Character.Humanoid.MoveDirection * getgenv().SpeedAmount
    end
end)
end }
Sections.MiscSector.Local:Box { Name = "Speed Value", Callback = function(text)
    getgenv().SpeedAmount = text
end 
}

getgenv().BHop = false

BhopToggle = Sections.MiscSector.Local:Toggle(
            {
            Name = "Bhop",
            Default = false,
            Pointer = "5",
            callback = function(state)
            getgenv().BHop = state
            end
        }
)

TTToggle = Sections.MiscSector.TT:Toggle(
            {
            Name = "Trash Talk",
            Default = false,
            Pointer = "5",
            callback = function(state)
            TrashTalk = state
            end
        }
)

Sections.MiscSector.TT:Box { Name = "TrashTalk Delay", Callback = function(text)
NiggaDelay = text
end }

AutoStompToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Auto Stomp",
            Default = false,
            Pointer = "5",
            callback = function(state)
            AutoStomp = state
            end
        }
)

AntiToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Anti Stomp",
            Default = false,
            Pointer = "5",
            callback = function(state)
            AntiStomp= state
            end
        }
)

AntiBagToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Anti Bag",
            Default = false,
            Pointer = "5",
            callback = function(state)
            AntiBag = state
            end
        }
)

AntiFlingToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Anti Fling",
            Default = false,
            Pointer = "5",
            callback = function(state)
            LocalPlayer.Character.HumanoidRootPart.Anchored = state
            end
        }
)

AutoPickUpToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Auto Pick Up Money",
            Default = false,
            Pointer = "5",
            callback = function(state)
            AutoPickUpMoney = state
            end
        }
)

AutoReloadToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Auto Reload",
            Default = false,
            Pointer = "5",
            callback = function(state)
            AutoReload = state
            end
        }
)

RemoveChairToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Remove Chairs",
            Default = false,
            Pointer = "5",
            callback = function(state)
            for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Seat") then
            v.Disabled = state
        end
        end
            end
        }
)

RemoveSnowToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Remove Snow",
            Default = false,
            Pointer = "5",
            callback = function(state)
            LocalPlayer.PlayerGui.MainScreenGui.SNOWBALLFRAME.Visible = first
if state then 
        workspace.Ignored.SnowBlock.Parent = ReplicatedStorage
    else
        if game.ReplicatedStorage:FindFirstChild("SnowBlock") then
        game.ReplicatedStorage.SnowBlock.Parent = workspace.Ignored
        end
    end 
            end
        }
)

InfZoomToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Infinity Zoom",
            Default = false,
            Pointer = "5",
            callback = function(state)
            if state == true then
        LocalPlayer.CameraMaxZoomDistance = math.huge
    else 
        LocalPlayer.CameraMaxZoomDistance = 35
    end
            end
        }
)

ShowChatToggle = Sections.MiscSector.Other:Toggle(
            {
            Name = "Show Chat",
            Default = false,
            Pointer = "5",
            callback = function(state)
            if state == true then
    local chatFrame = LocalPlayer.PlayerGui.Chat.Frame
        chatFrame.ChatChannelParentFrame.Visible = true
        chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
   end

   if state == false then 
    local chatFrame = LocalPlayer.PlayerGui.Chat.Frame
            chatFrame.ChatChannelParentFrame.Visible = false
            chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(0,0,0)
   end
            end
        }
)

--// Configs



local currentconfig = ""
local configname = ""

ConfigStuff = {
    configdropdown = Sections.Configuations.Configs:Dropdown { Name = "Main", Options = Library:ListConfigs(), Callback = function(option)
        currentconfig = option
    end },
    Sections.Configuations.Configs:Box { Name = "", Callback = function(text)
        configname = text
    end },

    Sections.Configuations.Configs:Button { Name = "Save", Callback = function()
        Library:SaveConfig(configname)
        ConfigStuff.configdropdown:Refresh(Library:ListConfigs())
    end }
    ,

    Sections.Configuations.Configs:Button { Name = "Load", Callback = function()
        Library:LoadConfig(currentconfig)
    end },
    Sections.Configuations.Configs:Button { Name = "Delete", Callback = function()
        Library:DeleteConfig(currentconfig)
        ConfigStuff.configdropdown:Refresh(Library:ListConfigs())
    end }


}



SettingsSection = {
    UiToggle = Sections.Configuations.ScriptStuff:Keybind { Name = "Keybind", Default = Enum.KeyCode.RightShift, Blacklist = { Enum.UserInputType.MouseButton1 }, Flag = "CurrentBind", Callback = function(key, fromsetting)
        if not fromsetting then
            library:Toggle()
        end
    end },

    WaterMarkToggle = Sections.Configuations.ScriptStuff:Keybind { Name = "Watermark", Default = Enum.KeyCode.RightShift, Blacklist = { Enum.UserInputType.MouseButton1 }, Flag = "CurrentToggle", Callback = function(key, fromsetting)
        if not fromsetting then
            watermark:Toggle()
        end
    end }
}

game:GetService("RunService").Stepped:Connect(
    function()
    if AutoReload then 
    if game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool") ~= nil then
        if game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Ammo") then
            if game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Ammo").Value <= 0 then
                game:GetService("ReplicatedStorage").MainEvent:FireServer(
                "Reload",
                game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                )
            end
        end
    end
end 
    
    if PickUpMoney then 
    for __,v in pairs(game:GetService("Workspace").Ignored.Drop:GetChildren()) do 
        if v.Name == "MoneyDrop" then 
            if (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 25 then 
                fireclickdetector(v.ClickDetector)
            end 
        end 
    end 
end 
    
    if AntiStomp then 
    if LocalPlayer.Character.Humanoid.Health < 50 then 
        for __,v in pairs(LocalPlayer.Character:GetDescendants()) do 
            if v:IsA("BasePart") then 
                v:Destroy()
            end 
        end 
    end 
end 

  if AutoStomp then 
    game.ReplicatedStorage.MainEvent:FireServer("Stomp")
end 

if AntiBag then
game.Players.LocalPlayer.Character["Christmas_Sock"]:Destroy()
end
    
    if TrashTalk then
		wait(NiggaDelay)
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
		"FROSTBYTE IS GOATED",
		"RAHHHH"
		)
		wait(NiggaDelay)
	end
	
    if Swastika.Visible then 
    CursorPath.Swastika.Position = UDim2.fromOffset(Mouse.X - 43, Mouse.Y - 39)

    if CursorRainbow then 
        CursorPath.Swastika.TextColor3 = Color3.fromHSV(tick() % 6 / 6, 1, 1)
    end 

    if CursorSpin == true then 
        CursorPath.Swastika.Rotation = CursorPath.Swastika.Rotation +  CursorSpinSpeed
    end 
end 
          if getgenv().BHop == true and
                lplr.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
            then
         if lplr.Character.Humanoid.MoveDirection.Magnitude > 0 then
                lplr.Character.Humanoid:ChangeState("Jumping")
            end
    end
    if SpinningCursor then
game:GetService("Players").LocalPlayer.PlayerGui.MainScreenGui.Aim.Rotation = game:GetService("Players").LocalPlayer.PlayerGui.MainScreenGui.Aim.Rotation + SpinPower
end

if BulletTracers then 
    local ColourSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(1,  BTColor),
})
    for _,v in pairs(game:GetService("Workspace").Ignored:GetDescendants()) do 
        if v.Name == "BULLET_RAYS" then 
            v.GunBeam.Texture = "rbxassetid://1390780157"
            v.GunBeam.Width0 = BulletWidth
            v.GunBeam.Width1 = BulletWidth
            v.GunBeam.Color = ColourSequence
        end 
end
end

if CustomAmbient then
            game.Lighting.Ambient = AmbientColor
            game.Lighting.OutdoorAmbient = AmbientColor
        end
        --
        if CustomColorShift then
            game.Lighting.ColorShift_Top = ColorShift
            game.Lighting.ColorShift_Bottom = ColorShift
        end
        --
        if CustomBrightness then
            game.Lighting.Brightness = BrightnessAmount
        end
        --
        if CustomExposure then
            game.Lighting.ExposureCompensation = ExposureAmount
        end
        --
        if CustomClockTime then
            game.Lighting.ClockTime = ClockTimeNumber
        end
        --
        if CustomFog then
            game.Lighting.FogStart = FogStart
            game.Lighting.FogEnd = FogEnd
            game.Lighting.FogColor = FogColor
        end
        --
        if CustomSaturtation then
        game.Lighting.ColorCorrection.Saturation = SaturtationValue
        end

if CustomGunSFX then 
    for i,v in pairs(LocalPlayer.Character:GetDescendants()) do 
        if v:IsA("Sound") and v.Name == "ShootSound" then 
            v.SoundId = "rbxassetid://" .. CGSID
            v.Volume  = CGSVolume
        end 
    end 
end 
    if SelfChams then
        for i, v in pairs(parts) do
            game.Players.LocalPlayer.Character[v].Material = SelfChamsMaterial
            game.Players.LocalPlayer.Character[v].Color = SelfChamsColor
        end
    end
    if SelfChams == false then
        for i, v in pairs(parts) do
            game.Players.LocalPlayer.Character[v].Material = Enum.Material.Glass
        end
    end
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild 'Default' then
        if WeaponEffectsEnabled == true then
            Game.GetService(game, "Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Default.Material = Enum.Material[WeaponEffectsMaterial]
            Game.GetService(game, "Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Default.Color = WeaponEffectsColor
        else
            if tool and tool:FindFirstChild 'Default' then
                if WeaponEffectsEnabled == false then
                    Game.GetService(game, "Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Default.Material = Enum.Material.Glass
                end
            end
        end
    end
end
)
-------------------------------



Library:ChangeAccent(Color3.fromRGB(128,0,128))
Library:ChangeOutline { Color3.fromRGB(128,0,128), Color3.fromRGB(128,0,128) }

Library:Initialize()
