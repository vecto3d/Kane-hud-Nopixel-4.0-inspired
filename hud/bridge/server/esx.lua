if Framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()

-- Stress storage for ESX
local PlayerStress = {}

AddEventHandler('esx:playerDropped', function(playerId)
  PlayerStress[playerId] = nil
end)

-- Get Player
function Bridge.GetPlayer(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return nil end

  return {
    source = source,
    _player = xPlayer,

    GetMoney = function(self, moneyType)
      if moneyType == 'cash' then
        return self._player.getMoney() or 0
      elseif moneyType == 'bank' then
        local account = self._player.getAccount('bank')
        return account and account.money or 0
      end
      local account = self._player.getAccount(moneyType)
      return account and account.money or 0
    end,

    GetJob = function(self)
      local job = self._player.getJob()
      return {
        name = job.name,
        type = job.name,
        label = job.label,
        grade = job.grade or 0,
      }
    end,

    GetMeta = function(self, key)
      if key == 'stress' then
        return PlayerStress[self.source] or 0
      end
      local player = Player(self.source)
      if player and player.state then
        return player.state[key]
      end
      return nil
    end,

    SetMeta = function(self, key, value)
      if key == 'stress' then
        PlayerStress[self.source] = value
        local player = Player(self.source)
        if player and player.state then
          player.state:set(key, value, true)
        end
        return
      end
      local player = Player(self.source)
      if player and player.state then
        player.state:set(key, value, true)
      end
    end,
  }
end

-- Commands
function Bridge.RegisterCommand(name, help, args, restricted, handler, permission)
  RegisterCommand(name, function(source, rawArgs)
    handler(source, rawArgs)
  end, restricted or false)

  -- Add ACE permission if specified
  if permission then
    ExecuteCommand(('add_ace group.%s command.%s allow'):format(permission, name))
  end
end

-- Server Callbacks
function Bridge.CreateCallback(name, handler)
  ESX.RegisterServerCallback(name, handler)
end
