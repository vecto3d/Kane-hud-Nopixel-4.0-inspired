Framework = nil -- 'qbcore', 'qbox', or 'esx'
Bridge = {}

local function DetectFramework()
  -- Check config override first
  if Config and Config.Framework and Config.Framework ~= 'auto' then
    Framework = Config.Framework
    print(('[' .. GetCurrentResourceName() .. '] Framework manually set to: %s'):format(Framework))
    return
  end

  -- Auto-detect: check QBox first (since it's a qb-core fork and may have qb-core compatibility)
  local qboxFound = GetResourceState('qbx_core') == 'started'
  local qbFound = GetResourceState('qb-core') == 'started'
  local esxFound = GetResourceState('es_extended') == 'started'

  if qboxFound then
    Framework = 'qbox'
  elseif qbFound then
    Framework = 'qbcore'
  elseif esxFound then
    Framework = 'esx'
  else
    print(('[' .. GetCurrentResourceName() .. '] ^1ERROR: No supported framework detected! Please install qb-core, qbx_core, or es_extended.^0')
      :format(Framework))
    return
  end

  print(('[' .. GetCurrentResourceName() .. '] ^2Framework detected: %s^0'):format(Framework))
end

DetectFramework()
