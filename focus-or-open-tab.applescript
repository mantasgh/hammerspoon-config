tell application id "{{BUNDLE_ID}}"
	activate
	set targetURL to "{{URL}}"
	
	try
		repeat with windowIndex from 1 to count of windows
			set currentWindow to window windowIndex
			set windowTabs to tabs of currentWindow
			
			repeat with tabIndex from 1 to count of windowTabs
				set currentTab to item tabIndex of windowTabs
				
				set tabURL to ""
				try
					set tabURL to URL of currentTab
				on error
					set tabURL to ""
				end try
				
				if tabURL starts with targetURL then
					set active tab index of currentWindow to tabIndex
					set index of currentWindow to 1
					return "FOUND"
				end if
			end repeat
		end repeat
		
		if (count of windows) = 0 then make new window
		
		tell front window
			make new tab with properties {URL:targetURL}
			set active tab index to (count of tabs)
			set index to 1
		end tell
		
		return "CREATED"
		
	on error errorMessage
		return "ERROR: " & errorMessage
	end try
end tell
