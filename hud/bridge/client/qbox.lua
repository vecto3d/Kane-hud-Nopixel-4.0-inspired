if Framework ~= 'qbox' then return end

local QBCore = exports['qbx_core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData() or {}

-- Player Data
function Bridge.GetPlayerData()
  return PlayerData
end

function Bridge.SetPlayerData(data)
  PlayerData = data
end

function Bridge.IsLoggedIn()
  return LocalPlayer.state.isLoggedIn or false
end

function Bridge.GetPlayerMeta(key)
  if PlayerData and PlayerData.metadata then
    return PlayerData.metadata[key]
  end
  return nil
end

function Bridge.GetPlayerMoney(moneyType)
  if PlayerData and PlayerData.money then
    return PlayerData.money[moneyType] or 0
  end
  return 0
end

function Bridge.GetPlayerItems()
  if PlayerData and PlayerData.items then
    return PlayerData.items
  end
  return {}
end

function Bridge.GetPlayerJob()
  if PlayerData and PlayerData.job then
    return {
      name = PlayerData.job.name,
      type = PlayerData.job.type,
      label = PlayerData.job.label,
      grade = PlayerData.job.grade and PlayerData.job.grade.level or 0,
    }
  end
  return { name = 'unemployed', type = 'none', label = 'Unemployed', grade = 0 }
end

-- Callbacks
function Bridge.TriggerCallback(name, cb, ...)
  if lib and lib.callback then
    local result = lib.callback.await(name, false, ...)
    cb(result)
  else
    QBCore.Functions.TriggerCallback(name, cb, ...)
  end
end

-- Framework Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  PlayerData = QBCore.Functions.GetPlayerData()
  TriggerEvent('hud:bridge:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
  PlayerData = {}
  TriggerEvent('hud:bridge:playerUnloaded')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
  PlayerData = val
  TriggerEvent('hud:bridge:playerDataUpdated', val)
end)
