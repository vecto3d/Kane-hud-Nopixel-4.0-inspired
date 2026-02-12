if Framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()
local PlayerData = {}
local isLoggedIn = false

local function getAccountMoney(accounts, accountName)
  if not accounts then return 0 end
  for _, account in ipairs(accounts) do
    if account.name == accountName then
      return account.money or 0
    end
  end
  return 0
end

local function normalizeItems(inventory)
  local items = {}
  if not inventory then return items end
  for _, item in ipairs(inventory) do
    if item.count and item.count > 0 then
      items[#items + 1] = {
        name = item.name,
        count = item.count,
        label = item.label,
      }
    end
  end
  return items
end

-- Player Data
function Bridge.GetPlayerData()
  return PlayerData
end

function Bridge.SetPlayerData(data)
  PlayerData = data
end

function Bridge.IsLoggedIn()
  return isLoggedIn
end

function Bridge.GetPlayerMeta(key)
  local val = LocalPlayer.state[key]
  if val ~= nil then return val end

  -- Fallback defaults for common metadata
  if key == 'stress' then return 0 end
  if key == 'inlaststand' then return false end
  if key == 'isdead' then return false end
  return nil
end

function Bridge.GetPlayerMoney(moneyType)
  if moneyType == 'cash' then
    return getAccountMoney(PlayerData.accounts, 'money')
  elseif moneyType == 'bank' then
    return getAccountMoney(PlayerData.accounts, 'bank')
  end
  return getAccountMoney(PlayerData.accounts, moneyType)
end

function Bridge.GetPlayerItems()
  return normalizeItems(PlayerData.inventory)
end

function Bridge.GetPlayerJob()
  if PlayerData and PlayerData.job then
    return {
      name = PlayerData.job.name,
      type = PlayerData.job.name,
      label = PlayerData.job.label,
      grade = PlayerData.job.grade or 0,
    }
  end
  return { name = 'unemployed', type = 'unemployed', label = 'Unemployed', grade = 0 }
end

-- Callbacks
function Bridge.TriggerCallback(name, cb, ...)
  ESX.TriggerServerCallback(name, cb, ...)
end

-- Framework Events
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  isLoggedIn = true
  TriggerEvent('hud:bridge:playerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
  PlayerData = {}
  isLoggedIn = false
  TriggerEvent('hud:bridge:playerUnloaded')
end)

RegisterNetEvent('esx:setJob', function(job)
  PlayerData.job = job
  TriggerEvent('hud:bridge:playerDataUpdated', PlayerData)
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
  if PlayerData.accounts then
    for i, acc in ipairs(PlayerData.accounts) do
      if acc.name == account.name then
        PlayerData.accounts[i] = account
        break
      end
    end
  end
  local moneyType = account.name == 'money' and 'cash' or account.name
  TriggerEvent('hud:client:OnMoneyChange', moneyType, account.money, false)
end)

-- Stress statebag listener
AddStateBagChangeHandler('stress', ('player:%s'):format(GetPlayerServerId(PlayerId())), function(_, _, value)
  if value then
    TriggerEvent('hud:client:UpdateStress', value)
  end
end)

-- Initialize player data if resource restarts
CreateThread(function()
  Wait(1000)
  PlayerData = ESX.GetPlayerData()
  if PlayerData and PlayerData.job then
    isLoggedIn = true
  end
end)
