
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

-- HYPER+L: Open news.google.com in the default browser
-- lfun = function()
--   news = "app = Application.currentApplication(); app.includeStandardAdditions = true; app.doShellScript('open http://news.google.com')"
--   hs.osascript.javascript(news)
--   k.triggered = true
-- end
-- k:bind('', 'l', nil, lfun)

-- HYPER+M: Call a pre-defined trigger in Alfred 3
-- mfun = function()
--   cmd = "tell application \"Alfred 3\" to run trigger \"emoj\" in workflow \"com.sindresorhus.emoj\" with argument \"\""
--   hs.osascript.applescript(cmd)
--   k.triggered = true
-- end
-- k:bind({}, 'm', nil, mfun)

-- HYPER+E: Act like ⌃e and move to end of line.
-- efun = function()
--   hs.eventtap.keyStroke({'⌃'}, 'e')
--   k.triggered = true
-- end
-- k:bind({}, 'e', nil, efun)

-- HYPER+A: Act like ⌃a and move to beginning of line.
-- afun = function()
--   hs.eventtap.keyStroke({'⌃'}, 'a')
--   k.triggered = true
-- end
-- k:bind({}, 'a', nil, afun)

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
