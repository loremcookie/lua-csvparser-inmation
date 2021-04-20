--[[
This simple libary is for parsing specifically by exel generated csv data structures and pasrsing them into lua table data structures.
The returned table will look something like this:
{"head1"=[{"1value", "2value"}, {"3value", "4value"}], "head2"=[{"5value", "6value"}, {"7value", "8value"}]}
When given data that looks like this:
head1;;;;
;;;;
1value;2value;;;
3value;4value;;;
;;;;
head2;;;;
;;;;
5value;6value
7value;8value
;;;;
--]]
--[[
TODO:
--Make it work
--]]
lib = {}

--splitString splits a string by a seperator character by default it is set to witespace the return variable is a table which contains the split string in two
function splitString(instr, sep)
	--Check if seperator value was properly set if not assign default value
	if sep == nil then
		sep = "%s"
	end
	--Define table that is returned
	local result = {}
	--Match the seperator to the string and split it by it
	for str in string.gmatch(instr, "([^"..sep.."]+)") do
		--insert the split string into the return table
		table.insert(result, str)
	end
	--Give the result back
	return result
end

--isHeader checks if the line is a header it takes a string and returns a boolean
function isHeader(line)
	--Reverse the string and then compare the 4 first characters if they are 4 semicolons and determit if its a header
	if string.sub(string.reverse(line), 1, 4) == ";;;;" then
		return true
	end
	return false
end

function lib.parse(csvdata)
	--result saves the parsed structur in a table
	local result = {}
	--currentHead is the string that saves the current header the line is under to save the values correctly
	local currentHead = ""
	--nameOfHead is used to save the name of the header to avoid performance issues
	local nameOfHead = ""
	--newHead tracks if a new Header has been reached
	local newHead = false
	--headLineCount counts the number of lines we are under the current header and names the keys accordingly
	local headLineCount = 0
	--loop through lines of the given data
	for line in string.gmatch(csvdata, "[^\n]+") do
	--Check if line is empty and ignore if so
		--if not line == ";;;;" or not line == "" then
		--Check if the current line is a header
			if isHeader(line) == true then
				--Get name of head without seperator
				nameOfHead = line:gsub(";;;;", "")
				--Save empty table under the header name to store the following values under
				result[nameOfHead] = {}
				--Set the variable to know for the next itterations under which header we are currently under
				currentHead = nameOfHead
				--Set newHEad to true to restart count of lines under the head
				newHead = true
			else
				--Reset headLineCounter if a newHeader has been reached
				if newHead == true then
					headLineCount = 0
				end
				--Add 1 to the head count to know which line we are under the head
				headLineCount = headLineCount +1
				
				--Split line by semicolon and write the line with the correct key name for the line into the head table
				result[currentHead][headLineCount] = splitString(line:gsub(";;;", ""),";")
				--Reset the newHead variable to not loose track of the cycles and prevent reseting it every time
				newHead = false
				if true then return result end
			end
		--end
	end
end

return lib
