local logger = hs.logger.new("custom", 'verbose')

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

--  function table.val_to_str ( v )
--    if "string" == type( v ) then
--      v = string.gsub( v, "\n", "\\n" )
--      if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
--        return "'" .. v .. "'"
--      end
--      return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
--    else
--      return "table" == type( v ) and table.tostring( v ) or
--        tostring( v )
--    end
--  end

--  function table.key_to_str ( k )
--    if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
--      return k
--    else
--      return "[" .. table.val_to_str( k ) .. "]"
--    end
--  end

--  function table.tostring( tbl )
--    local result, done = {}, {}
--    for k, v in ipairs( tbl ) do
--      table.insert( result, table.val_to_str( v ) )
--      done[ k ] = true
--    end
--    for k, v in pairs( tbl ) do
--      if not done[ k ] then
--        table.insert( result,
--          table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
--      end
--    end
--    return "{" .. table.concat( result, "," ) .. "}"
--  end

-- ShiftIt: https://github.com/peterklijn/hammerspoon-shiftit
hs.loadSpoon("ShiftIt")
spoon.ShiftIt:setWindowCyclingSizes({ 50, 67 }, { 50 })
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
    keyFn[2](spoon.ShiftIt)
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

-- Hyper+,: Cascade frontmost app windows
function cascadeWindows()
  local frontWindow = hs.window.frontmostWindow()
  local screen = frontWindow:screen()
  local app = frontWindow:application()
  local visibleWindows = app:visibleWindows()

  local layoutWindows = {}
  for i, window in ipairs(visibleWindows) do
    if window:isStandard() then
      if window:screen() == screen then
        layoutWindows[#layoutWindows+1] = window
      end
    end
  end

  -- We start just under the menu bar, and advance down and right by the width,
  -- height of the title bar.
  -- The width is just 3/5 of the screen width, while the height depends on
  -- the number of windows (with a minsize just in case)
  local xPos, yPos = 0, 20
  local xOffset, yOffset = 20, 20
  local width = screen:frame().w * 3 / 5
  local height = (screen:frame().h - yPos) - (yOffset * #layoutWindows)
  height = math.max(height, screen:frame().h * 3 / 5)

  local layouts = {}
  for i, window in ipairs(layoutWindows) do
    local windowPosition = {
      app,
      window,
      screen,
      nil,
      hs.geometry.rect(
        xPos + (i - 1) * xOffset,
        yPos + (i - 1) * yOffset,
        width,
        height
      ),
      nil
    }
    layouts[#layouts+1] = windowPosition
  end
  hs.layout.apply(layouts)
end
k:bind({}, ",", nil, function()
  cascadeWindows()
  k.triggered = true
end)

-- Caffeine menubar
caffeine = hs.menubar.new()

-- Always caffeinate on startup.
shouldCaffeinate = false

function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("☕️")
  else
    caffeine:setTitle("💤")
  end
end

function setCaffeine(state)
  hs.caffeinate.set("displayIdle", state, true)
  setCaffeineDisplay(state)
end

function caffeineClicked()
  shouldCaffeinate = not shouldCaffeinate
  setCaffeine(shouldCaffeinate)
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeine(shouldCaffeinate)
end

function enableOrDisableCaffeinateMenuItem(event)
  local pow = hs.caffeinate.watcher
  local name = "?"
  for key,val in pairs(pow) do
    if event == val then name = key end
  end
  logger.f("caffeinate event %d => %s", event, name)
  if event == pow.screensDidUnlock
    or event == pow.screensaverDidStop
  then
    logger.i("Screen awakened!")
    -- Restore Caffeinated state:
    setCaffeine(shouldCaffeinate)
    return
  end
  if event == pow.screensDidLock
    or event == pow.screensaverDidStart
  then
    logger.i("Screen locked.")
    setCaffeine(false)
    return
  end
end


-- Listen for power events
local function caffeinateWatcherCallback(event)
  enableOrDisableCaffeinateMenuItem(event)
  enableKarabinerSculpProfileIfNeeded()
end

hs.caffeinate.watcher.new(caffeinateWatcherCallback):start()
