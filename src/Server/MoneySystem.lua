-- Lilmoney Server-Side Money Management System
-- This script handles all money transactions and leaderstats

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local moneyStore = DataStoreService:GetDataStore("PlayerMoney")

-- Configuration
local STARTING_MONEY = 100000
local MAX_MONEY = 999999999

-- Function to create leaderstats for a player
local function createLeaderstats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = STARTING_MONEY
	money.Parent = leaderstats
	
	return money
end

-- Function to add money to player
local function addMoney(player, amount)
	if not player:FindFirstChild("leaderstats") then
		createLeaderstats(player)
	end
	
	local money = player.leaderstats:FindFirstChild("Money")
	if money then
		money.Value = math.min(money.Value + amount, MAX_MONEY)
		return true
	end
	return false
end

-- Function to remove money from player
local function removeMoney(player, amount)
	if not player:FindFirstChild("leaderstats") then
		createLeaderstats(player)
	end
	
	local money = player.leaderstats:FindFirstChild("Money")
	if money and money.Value >= amount then
		money.Value = money.Value - amount
		return true
	end
	return false
end

-- Function to set money for player
local function setMoney(player, amount)
	if not player:FindFirstChild("leaderstats") then
		createLeaderstats(player)
	end
	
	local money = player.leaderstats:FindFirstChild("Money")
	if money then
		money.Value = math.clamp(amount, 0, MAX_MONEY)
		return true
	end
	return false
end

-- Function to get player money
local function getMoney(player)
	if player:FindFirstChild("leaderstats") then
		local money = player.leaderstats:FindFirstChild("Money")
		if money then
			return money.Value
		end
	end
	return 0
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
	print("Player " .. player.Name .. " joined!")
	createLeaderstats(player)
end)

-- Handle player leaving (save data)
Players.PlayerRemoving:Connect(function(player)
	local money = getMoney(player)
	if money > 0 then
		pcall(function()
			moneyStore:SetAsync(player.UserId, money)
		end)
	end
	print("Player " .. player.Name .. " left!")
end)

-- Expose functions via RemoteFunction for client communication
local moneyRemote = Instance.new("RemoteFunction")
moneyRemote.Name = "MoneyRemote"
moneyRemote.Parent = game.ReplicatedStorage

function moneyRemote.OnServerInvoke(player, action, amount)
	if action == "add" then
		return addMoney(player, amount)
	elseif action == "remove" then
		return removeMoney(player, amount)
	elseif action == "set" then
		return setMoney(player, amount)
	elseif action == "get" then
		return getMoney(player)
	end
	return false
end

print("Lilmoney Server System Loaded!")
