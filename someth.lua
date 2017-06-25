	-- return current count of files in declared path
function countDirectory(path, specificName)
	if path and specificName then
		if tostring(path) and tostring(specificName) then
			local path = tostring(path)
			local i = 0
			local docPath = system.pathForFile(path, system.ResourceDirectory)
			if app.debugOutput then
				print("")
				print("~ countDirectory() find: ")
				print("------- FIND FILES -------")
			end
			for file in lfs.dir(docPath) do
				if string.find(file, specificName, 1) then
					i = i + 1
					if app.debugOutput then
						print(file)
					end
				end
			end
			if app.debugOutput then
				print("--------------------------")
			end
			return tonumber(i)
		else
			return false
		end
	else
		return false
	end
end

local breakBackgroundMusic = false
local function multipleBackgroundMusic()
	if not breakBackgroundMusic then
		local dirCount = countDirectory(bgMusic.path, "bg_")
		local x = math.random(1, dirCount)
		local path = bgMusic.path.."bg_"..x..".mp3"
		bgMusic.loadStream = audio.loadStream(path)
		local duration = audio.getDuration(bgMusic.loadStream)
		audio.play(bgMusic.loadStream)
		timer.performWithDelay(duration, multipleBackgroundMusic)

		if app.debugOutput then
			print("")
			print("------------------------------------------------")
			print("Current playing sound: ".."bg_"..x..".mp3")
			print("------------------------------------------------")
		end 
	else
		breakBackgroundMusic = false
	end
end

	-- include or operate background music
function backgroundMusic(impact, specific, loop)
	if (impact=="play") then
		if specific then
			if loop then
				local path = bgMusic.path..""..specific
				bgMusic.loadStream = audio.loadStream(path)
				local duration = audio.getDuration(bgMusic.loadStream)
				audio.play(bgMusic.loadStream, {loops=-1})
			else
				local path = bgMusic.path..""..specific
				bgMusic.loadStream = audio.loadStream(path)
				audio.play(bgMusic.loadStream)
			end
		else
			local dirCount = countDirectory(bgMusic.path, "bg_")
			if dirCount>0 then
				local x = math.random(1, dirCount)
				local path = bgMusic.path.."bg_"..x..".mp3"
				bgMusic.loadStream = audio.loadStream(path)
				local duration = audio.getDuration(bgMusic.loadStream)
				audio.play(bgMusic.loadStream)
				timer.performWithDelay(duration, multipleBackgroundMusic)

				if app.debugOutput then
					print("")
					print("------------------------------------------------")
					print("Current playing sound: ".."bg_"..x..".mp3")
					print("------------------------------------------------")
				end
			else
				print("")
				print("------------------------------------------------")
				print("In directory: sounds/background/ is 0 files.")
				print("------------------------------------------------")
				return false
			end
		end
	elseif (impact=="stop") then
		breakBackgroundMusic = true
	elseif (impact=="allforcestop") then
		breakBackgroundMusic = true
		local result = audio.usedChannels
		if app.debugOutput then
			print("")
			print("------------------------------------------------")
			print("Stopping channels:")
		end
		for i=1,audio.usedChannels do
			audio.stop(i)
			if app.debugOutput then
				print("Channel: "..i)
			end
		end
		if app.debugOutput then
			print("------------------------------------------------")
		end
	elseif (impact=="fixforcestop") then
		audio.stop(1)
	end
end
