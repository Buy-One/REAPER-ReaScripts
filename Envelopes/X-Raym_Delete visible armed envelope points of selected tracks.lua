--[[
 * ReaScript Name: Delete visible armed envelope points of selected tracks
 * Description: A way to delete multiple points accros different envelopes and tracks.
 * Instructions: Make a selection area. Execute the script.
 * Author: X-Raym
 * Author URl: http://extremraym.com
 * Repository: GitHub > X-Raym > EEL Scripts for Cockos REAPER
 * Repository URl: https://github.com/X-Raym/REAPER-EEL-Scripts
 * File URl: https://github.com/X-Raym/REAPER-EEL-Scripts/scriptName.eel
 * Licence: GPL v3
 * Forum Thread: Script (LUA): Copy points envelopes in time selection and paste them at edit cursor
 * Forum Thread URl: http://forum.cockos.com/showthread.php?p=1497832#post1497832
 * Version: 1.0
 * Version Date: 2015-03-18
 * REAPER: 5.0 pre 15
 * Extensions: 2.6.3 #0
 --]]
 
--[[
 * Changelog:
 * v1.0 (2015-03-18)
	+ Initial release
 --]]

-- ----- DEBUGGING ====>
--[[
local info = debug.getinfo(1,'S');

local full_script_path = info.source

local script_path = full_script_path:sub(2,-5) -- remove "@" and "file extension" from file name

if reaper.GetOS() == "Win64" or reaper.GetOS() == "Win32" then
  package.path = package.path .. ";" .. script_path:match("(.*".."\\"..")") .. "..\\Functions\\?.lua"
else
  package.path = package.path .. ";" .. script_path:match("(.*".."/"..")") .. "../Functions/?.lua"
end

require("X-Raym_Functions - console debug messages")


debug = 1 -- 0 => No console. 1 => Display console messages for debugging.
clean = 1 -- 0 => No console cleaning before every script execution. 1 => Console cleaning before every script execution.

msg_clean()]]
-- <==== DEBUGGING -----

function main() -- local (i, j, item, take, track)

	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

	startLoop, endLoop = reaper.GetSet_LoopTimeRange2(0, false, true, 0, 0, false)

		-- LOOP TRHOUGH SELECTED TRACKS
		selected_tracks_count = reaper.CountSelectedTracks(0)
		for i = 0, selected_tracks_count-1  do
			
			-- GET THE TRACK
			track = reaper.GetSelectedTrack(0, i) -- Get selected track i

			-- LOOP THROUGH ENVELOPES
			env_count = reaper.CountTrackEnvelopes(track)
			for j = 0, env_count-1 do

				-- GET THE ENVELOPE
				env = reaper.GetTrackEnvelope(track, j)

				-- IF VISIBLE
				retval, strNeedBig = reaper.GetEnvelopeStateChunk(env, "", true)
				x, y = string.find(strNeedBig, "VIS 1")
				w, z = string.find(strNeedBig, "ARM 1")

				if x ~= nil and w ~= nil then

					env_points_count = reaper.CountEnvelopePoints(env)

					if env_points_count > 0 then
						
						retval_last, time_last, valueSource_last, shape_last, tension_last, selectedOut_last = reaper.GetEnvelopePoint(env, env_points_count-1)

						reaper.DeleteEnvelopePointRange(env, 0, time_last+1)

						reaper.Envelope_SortPoints(env)
					end
				
				end -- ENFIF visible
				
			end -- ENDLOOP through envelopes

		end -- ENDLOOP through selected tracks

		reaper.Undo_EndBlock("Delete visible armed envelope points of selected tracks", 0) -- End of the undo block. Leave it at the bottom of your main function.

end -- end main()

--msg_start() -- Display characters in the console to show you the begining of the script execution.

--[[ reaper.PreventUIRefresh(1) ]]-- Prevent UI refreshing. Uncomment it only if the script works.
--reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SAVE_CURSOR_POS_SLOT_8"), 0)

main() -- Execute your main function

--[[ reaper.PreventUIRefresh(-1) ]] -- Restore UI Refresh. Uncomment it only if the script works.
--reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_RESTORE_CURSOR_POS_SLOT_8"), 0) -- Restore current position

reaper.UpdateArrange() -- Update the arrangement (often needed)
--msg_end() -- Display characters in the console to show you the end of the script execution.