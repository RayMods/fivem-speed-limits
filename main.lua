--[[
  TODO:
    Only show speedometer if distance to road < 15 (play around with this threshold)

]]--


local currentVehicle = {}
local nodeBlip

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if (IsPlayerDrivingVehicle()) then
      local playerCoords = GetEntityCoords(PlayerPedId())
      local streetHash = GetStreetNameAtCoord(table.unpack(playerCoords))
      local streetLimit = SpeedLimits[tostring(streetHash)]
      local foundVehicleNode, closestNodeCoords = GetClosestVehicleNode(playerCoords.x, playerCoords.y, playerCoords.z, 0, 3.0)
      local distanceToNode;
      distanceToNode = GetDistanceBetweenCoords(
        playerCoords.x, playerCoords.y, playerCoords.z,
        closestNodeCoords.x, closestNodeCoords.y, closestNodeCoords.z
      );

      if (streetLimit and foundVehicleNode and distanceToNode <= 20) then
        RenderHud(streetLimit)
      end

      Debug()
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
    currentVehicle = vehicle
  else
    currentVehicle = {}
  end

  return isInVehicle and isDriver
end

function Debug()
  RemoveBlip(nodeBlip)
  local playerCoords = GetEntityCoords(PlayerPedId())
  local vehicleCoords = GetEntityCoords(currentVehicle)

  SetTextScale(0, 0.25)
  SetTextDropShadow(1, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('Player Coords:')
  DrawText(0.005, 0.35)
  SetTextScale(0, 0.25)
  SetTextDropShadow(1, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('x: ' .. playerCoords.x .. ' y: ' .. playerCoords.y .. ' z: ' .. playerCoords.z)
  DrawText(0.01, 0.375)
  SetTextScale(0, 0.25)
  SetTextDropShadow(1, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString(IsPointOnRoad(table.unpack(playerCoords)) and 'On Road' or 'Not On Road')
  DrawText(0.01, 0.4)

  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('Vehicle Coords:')
  DrawText(0.005, 0.43)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('x: ' .. vehicleCoords.x .. ' y: ' .. vehicleCoords.y .. ' z: ' .. vehicleCoords.z)
  DrawText(0.01, 0.455)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString(IsPointOnRoad(table.unpack(vehicleCoords)) and 'On Road' or 'Not On Road')
  DrawText(0.01, 0.48)

  local roadKey = GetStreetNameAtCoord(table.unpack(playerCoords))
  local roadName = GetStreetNameFromHashKey(roadKey)
  local _, roadCoords = GetClosestRoad(table.unpack(playerCoords), 1.0, 1)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('Nearest Road:')
  DrawText(0.005, 0.51)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString(roadName .. ' - ' .. roadKey)
  DrawText(0.01, 0.535)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('x: ' .. roadCoords.x .. ' y: ' .. roadCoords.y .. ' z: ' .. roadCoords.z)
  DrawText(0.01, 0.56)

  local found, nodeCoords = GetClosestVehicleNode(playerCoords.x, playerCoords.y, playerCoords.z, 0, 3.0)
  if (DoesBlipExist(nodeBlip)) then
    SetBlipCoords(nodeBlip, table.unpack(nodeCoords))
  else
    nodeBlip = AddBlipForCoord(table.unpack(nodeCoords))
    SetBlipSprite(nodeBlip, 524)
  end
  -- blip = AddBlipForCoord(table.unpack(nodeCoords))
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('Nearest Vehicle Node:')
  DrawText(0.005, 0.59)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('Found?  ' .. (found and 'Y' or 'N'))
  DrawText(0.01, 0.615)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('x: ' .. nodeCoords.x .. ' y: ' .. nodeCoords.y .. ' z: ' .. nodeCoords.z)
  DrawText(0.01, 0.64)
  SetTextScale(0, 0.25)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEntry("STRING")
  AddTextComponentString('Distance From Player: ' .. GetDistanceBetweenCoords(
    playerCoords.x, playerCoords.y, nodeCoords.z,
    nodeCoords.x, nodeCoords.y, nodeCoords.z
  ))
  DrawText(0.01, 0.665)

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
