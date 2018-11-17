Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if (IsPlayerDrivingVehicle()) then
      local limit = Config.defaultLimit
      local playerCoords = GetEntityCoords(PlayerPedId())
      local streetHash = GetStreetNameAtCoord(table.unpack(playerCoords))
      local streetName = GetStreetNameFromHashKey(streetHash)
      local streetLimit = SpeedLimits[tostring(streetHash)]

      if (streetLimit) then
        limit = streetLimit
      end

      SetTextCentre(true)
      renderText(streetName .. ' - ' .. streetHash, { 0.09, 0.7 }, nil, 4, { 0, 0.4 })

      SetTextCentre(true)
      if (streetLimit) then
        renderText(limit .. ' MPH', { 0.09, 0.675 })
      else
        renderText('LIMIT NOT FOUND', { 0.09, 0.675 })
      end
    end
  end
end)

function IsPlayerDrivingVehicle()
  local isDriver = false
  local isInVehicle = false
  local ped = GetPlayerPed(-1)
  local vehicle = {}

  if (IsPedInAnyVehicle(ped)) then
    isInVehicle = true
    vehicle = GetVehiclePedIsIn(ped, false)
    isDriver = GetPedInVehicleSeat(vehicle, -1) == ped
  end

  return isInVehicle and isDriver
end

function renderText(text, pos, color, font, size)
  if (not color) then
    color = { 255, 255, 255, 255 }
  end
  if (not font) then
    font = 2
  end
  if (not size) then
    size = { 0, 0.5 }
  end

  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(table.unpack(size))
  SetTextColour(table.unpack(color))
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(table.unpack(pos))
end
