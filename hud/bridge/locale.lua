if Locale then return end -- Don't override if qb-core already loaded it

Locale = {}
Locale.__index = Locale

function Locale:new(data)
  local instance = setmetatable({}, Locale)
  instance.phrases = data.phrases or {}
  instance.warnOnMissing = data.warnOnMissing or false
  return instance
end

function Locale:t(key, ...)
  local parts = {}
  for part in key:gmatch('[^.]+') do
    parts[#parts + 1] = part
  end

  local result = self.phrases
  for _, part in ipairs(parts) do
    if type(result) == 'table' then
      result = result[part]
    else
      result = nil
      break
    end
  end

  if result == nil then
    if self.warnOnMissing then
      print(('[locale] Missing translation for key: %s'):format(key))
    end
    return key
  end

  if type(result) == 'string' and ... then
    return result:format(...)
  end

  return result or key
end
