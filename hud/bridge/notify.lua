if IsDuplicityVersion() then
  -- SERVER SIDE
  function Bridge.Notify(source, msg, notifType, duration)
    TriggerClientEvent('hud:client:OxNotify', source, msg, notifType, duration)
  end
else
  -- CLIENT SIDE
  function Bridge.Notify(msg, notifType, duration)
    lib.notify({
      title = 'HUD',
      description = msg,
      type = notifType or 'inform',
      duration = duration or 5000,
    })
  end

  RegisterNetEvent('hud:client:OxNotify', function(msg, notifType, duration)
    Bridge.Notify(msg, notifType, duration)
  end)
end
