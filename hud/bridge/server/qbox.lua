if Framework ~= 'qbox' then return end

local QBCore = exports['qbx_core']:GetCoreObject()

-- Get Player
function Bridge.GetPlayer(source)
  local Player = QBCore.Functions.GetPlayer(source)
  if not Player then return nil end

  return {
    source = source,
    _player = Player,

    GetMoney = function(self, moneyType)
      return self._player.PlayerData.money[moneyType] or 0
    end,

    GetJob = function(self)
      return {
        name = self._player.PlayerData.job.name,
        type = self._player.PlayerData.job.type,
        label = self._player.PlayerData.job.label,
        grade = self._player.PlayerData.job.grade and self._player.PlayerData.job.grade.level or 0,
      }
    end,

    GetMeta = function(self, key)
      if key then
        return self._player.PlayerData.metadata[key]
      end
      return self._player.PlayerData.metadata
    end,

    SetMeta = function(self, key, value)
      self._player.Functions.SetMetaData(key, value)
    end,
  }
end

-- Commands
function Bridge.RegisterCommand(name, help, args, restricted, handler, permission)
  QBCore.Commands.Add(name, help, args, restricted, handler, permission)
end

-- Server Callbacks
function Bridge.CreateCallback(name, handler)
  if lib and lib.callback then
    lib.callback.register(name, function(source, ...)
      local result
      handler(source, function(data)
        result = data
      end, ...)
      return result
    end)
  else
    QBCore.Functions.CreateCallback(name, handler)
  end
end
