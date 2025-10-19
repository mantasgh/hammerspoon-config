local function readFile(path)
  if not (type(path) == "string" and #path > 0) then
    hs.printf("invalid path: %s", tostring(path))
    return nil
  end

  local fileHandle = io.open(path, "r")
  if not fileHandle then
    hs.printf("could not open file: %s", path)
    return nil
  end

  local content = fileHandle:read("*a")
  fileHandle:close()
  return content
end

local focusOrOpenTabTemplate = readFile(os.getenv("HOME") .. "/.hammerspoon/focus-or-open-tab.applescript")

local function interpolate(template, variables)
  if type(template) ~= "string" then
    hs.printf("invalid template: %s", tostring(template))
    return ""
  end
  if type(variables) ~= "table" then
    hs.printf("invalid variables table")
    return template
  end
  return (template:gsub("{{(.-)}}", function(key)
    if variables[key] == nil then
      hs.printf("warning: missing variable for key '%s'", key)
    end
    return variables[key] or ""
  end))
end

local function focusOrOpenTab(bundleId, url)
  if not (type(bundleId) == "string" and #bundleId > 0) then
    hs.printf("invalid bundleid: %s", tostring(bundleId))
    return
  end

  if not (type(url) == "string" and #url > 0) then
    hs.printf("invalid url: %s", tostring(url))
    return
  end

  if not focusOrOpenTabTemplate then
    hs.printf("applescript template not loaded")
    return
  end

  local script = interpolate(focusOrOpenTabTemplate, {
    BUNDLE_ID = bundleId,
    URL = url,
  })

  local success, result = hs.osascript.applescript(script)
  if not success then
    hs.printf("failed to run applescript for %s (%s)", bundleId, url)
    return
  end

  if result == "FOUND" then
    hs.printf("switched to existing tab in %s (%s)", bundleId, url)
  elseif result == "CREATED" then
    hs.printf("created new tab in %s (%s)", bundleId, url)
  elseif type(result) == "string" and result:match("^ERROR:") then
    hs.printf("applescript error in %s (%s): %s", bundleId, url, result:gsub("^ERROR:%s*", ""))
  else
    hs.printf("unexpected applescript result in %s (%s): %s", bundleId, url, result or "unknown error")
  end
end

return {
  focusOrOpenTab = focusOrOpenTab
}
