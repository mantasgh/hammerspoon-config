local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
  hyper:enter()
end

hyper.released = function()
  hyper:exit()
end

hs.hotkey.bind({}, 'f19', hyper.pressed, hyper.released)

local function fireKeyEvent(key)
  hs.eventtap.event.newKeyEvent(key, true):post()
  hs.eventtap.event.newKeyEvent(key, false):post()
end

hyper:bind({}, 'h', function() fireKeyEvent("left") end, nil, function() fireKeyEvent("left") end)
hyper:bind({}, 'j', function() fireKeyEvent("down") end, nil, function() fireKeyEvent("down") end)
hyper:bind({}, 'k', function() fireKeyEvent("up") end, nil, function() fireKeyEvent("up") end)
hyper:bind({}, 'l', function() fireKeyEvent("right") end, nil, function() fireKeyEvent("right") end)

hyper:bind({}, 'f', function() hs.application.launchOrFocusByBundleID("com.brave.Browser") end)
hyper:bind({}, 'd', function() hs.application.launchOrFocusByBundleID("com.microsoft.VSCode") end)