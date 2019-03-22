--[[
 * ReaScript Name: Scroll arrange view if mouse reaches screen edges
 * About: A template script for running in background REAPER ReaScript, with toolbar button ON/OFF state.
 * Screenshot: https://i.imgur.com/0npTbEB.gifv
 * Author: X-Raym
 * Author URI: http://extremraym.com
 * Repository: GitHub > X-Raym > REAPER-ReaScripts
 * Repository URI: https://github.com/X-Raym/REAPER-ReaScripts
 * Licence: GPL v3
 * Forum Thread: Scripts: View and Zoom (Various)
 * Forum Thread URI: https://forum.cockos.com/showthread.php?p=1523568#post1523568
 * REAPER: 5.0
 * Extensions: js_extension
 * Version: 1.0
--]]
 
--[[
 * Changelog:
 * v1.0 (2019-03-22)
  + Initial Release
--]]
 
-- TODO:
-- Scroll Only if REAPER is in FOCUS
-- MAJ + Scroll FAST
-- Find on which screen is REAPER
 
 -- Set ToolBar Button State
function SetButtonState( set )
  if not set then set = 0 end
  local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  local state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, set ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
end

function Main()

  mouse_x, mouse_y = reaper.GetMousePosition()
  
  val_x = 0
  val_y = 0
  
  if mouse_x == 0 then
    val_x = -1
    reaper.JS_Mouse_SetCursor( cursor_left )
  end
  
  if mouse_x >= screen_right - 1 then
   val_x = 1
  end
  
  if mouse_y == 0 then
    val_y = -1
    reaper.JS_Mouse_SetCursor( cursor_up )
  end
  
  if mouse_y >= screen_bottom - 1 then
    val_y = 1
  end
  
  if val_x ~= 0 or val_y ~= 0 then
    reaper.CSurf_OnScroll( val_x, val_y )
  end
  
  reaper.defer(Main)
  
end

if not reaper.JS_Window_MonitorFromRect then
  reaper.ShowConsoleMsg('Please Install js_ReaScriptAPI extension.\nhttps://forum.cockos.com/showthread.php?t=212174\n')
else

  screen_left, screen_top, screen_right, screen_bottom = reaper.JS_Window_MonitorFromRect(0, 0, 0, 0, false)
  
  cursor_up = reaper.JS_Mouse_LoadCursor( 32516 )
  cursor_left = reaper.JS_Mouse_LoadCursor( 32644 )
  
  SetButtonState( 1 )
  Main()
  reaper.atexit( SetButtonState )
  
end
