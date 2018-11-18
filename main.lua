Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if (IsPlayerDrivingVehicle()) then
      local playerCoords = GetEntityCoords(PlayerPedId())
      local streetHash = GetStreetNameAtCoord(table.unpack(playerCoords))
      local streetName = GetStreetNameFromHashKey(streetHash)
      local streetLimit = SpeedLimits[tostring(streetHash)]

      if (streetLimit) then
        RenderHud(streetLimit)
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

function RenderHud(limit)
  SetTextCentre(true)
  SetTextColour(0,0,0,255)
  SetTextFont(2)
  SetTextScale(0, 0.275)
  SetTextEntry("STRING")
  AddTextComponentString("SPEED")
  DrawText(0.145, 0.921)

  SetTextCentre(true)
  SetTextColour(0, 0, 0, 255)
  SetTextFont(2)
  SetTextScale(0, 0.6)
  SetTextEntry("STRING")
  AddTextComponentString(limit)
  DrawText(0.145, 0.9315)

  DrawRect(
    0.145,
    0.945,
    0.021,
    0.0425,
    255,
    255,
    255,
    150
  )
end
