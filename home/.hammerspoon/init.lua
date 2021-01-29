
-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- HYPER+L: lock the screen
k:bind({}, "l", function()
  hs.caffeinate.startScreensaver()
  k.triggered = true
end)

-- HYPER+V: Cmd+Alt+Shift+Ctrl+v
k:bind({}, "v", nil, function()
  hs.eventtap.keyStroke({'cmd', 'alt', 'shift', 'ctrl'}, 'v')
  k.triggered = true
end)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Experiments

-- function table.val_to_str ( v )
--   if "string" == type( v ) then
--     v = string.gsub( v, "\n", "\\n" )
--     if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
--       return "'" .. v .. "'"
--     end
--     return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
--   else
--     return "table" == type( v ) and table.tostring( v ) or
--       tostring( v )
--   end
-- end
--
-- function table.key_to_str ( k )
--   if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
--     return k
--   else
--     return "[" .. table.val_to_str( k ) .. "]"
--   end
-- end
--
-- function table.tostring( tbl )
--   local result, done = {}, {}
--   for k, v in ipairs( tbl ) do
--     table.insert( result, table.val_to_str( v ) )
--     done[ k ] = true
--   end
--   for k, v in pairs( tbl ) do
--     if not done[ k ] then
--       table.insert( result,
--         table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
--     end
--   end
--   return "{" .. table.concat( result, "," ) .. "}"
-- end

function karabinerSetProfile(profile_name)
  os.execute("\"/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli\" --select-profile \"" .. profile_name .. "\"")
end

function usbDeviceCallback(data)
  -- hs.alert.show(table.tostring(data))
  if (data['vendorName'] == 'Microsoft' and data['vendorID'] == 1118 and data['productID'] == 1957) then
    if (data['eventType'] == 'added') then
      -- enable the Sculp profile
      hs.console.printStyledtext('Enabling Sculpt profile')
      karabinerSetProfile('With Microsoft Sculp Keyboard')
    elseif data['eventType'] == 'removed' then
      -- disable the Sculp profile
      hs.console.printStyledtext('Disabling Sculpt profile')
      karabinerSetProfile('With Internal Keyboard')
    end
  end
end

local usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

-- ShiftIt: https://github.com/peterklijn/hammerspoon-shiftit
hs.loadSpoon("ShiftIt")
shiftItBindings = {
  {'left',  spoon.ShiftIt.left},
  {'right', spoon.ShiftIt.right},
  {'up',    spoon.ShiftIt.up},
  {'down',  spoon.ShiftIt.down},
  {'=',     spoon.ShiftIt.resizeOut},
  {'-',     spoon.ShiftIt.resizeIn},
  {'n',     spoon.ShiftIt.nextScreen},
  {'p',     spoon.ShiftIt.previousScreen},
  {'z',     spoon.ShiftIt.maximum}
}
for _, keyFn in pairs(shiftItBindings) do
  k:bind({}, keyFn[1], nil, function()
    keyFn[2]()
    k.triggered = true
  end)
end


-- Recover F1 ... F12 keys when pressing Hyper
functionBindings = {
  {'1', 'F1'},
  {'2', 'F2'},
  {'3', 'F3'},
  {'4', 'F4'},
  {'5', 'F5'},
  {'6', 'F6'},
  {'7', 'F7'},
  {'8', 'F8'},
  {'9', 'F9'},
  {'0', 'F10'},
--  {70, 'F11'},
--  {71, 'F12'},
}
for _, keyFn in pairs(functionBindings) do
  k:bind({}, keyFn[1], nil, function()
    hs.eventtap.keyStroke({}, keyFn[2])
    k.triggered = true
  end)
end