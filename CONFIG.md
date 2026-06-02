# Lilmoney Configuration Guide

## Server Configuration

### Basic Settings

```lua
-- Starting money for new players
local STARTING_MONEY = 100000

-- Maximum money a player can have
local MAX_MONEY = 999999999

-- DataStore name for saving player money
local moneyStore = DataStoreService:GetDataStore("PlayerMoney")
```

## UI Customization

### Money Label Position
```lua
-- Format: UDim2.new(xScale, xOffset, yScale, yOffset)
-- Current: Top-right corner
moneyLabel.Position = UDim2.new(1, -320, 0, 20)

-- Examples:
-- Top-left: UDim2.new(0, 20, 0, 20)
-- Bottom-right: UDim2.new(1, -320, 1, -80)
-- Center: UDim2.new(0.5, -150, 0.5, -25)
```

### Money Label Size
```lua
-- Current size (width 300, height 50)
moneyLabel.Size = UDim2.new(0, 300, 0, 50)

-- Adjust as needed
```

### Button Amounts
```lua
-- Add Money Button
addButton.Text = "Add $1,000"
moneyRemote:InvokeServer("add", 1000)  -- Change 1000 to desired amount

-- Remove Money Button
removeButton.Text = "Remove $500"
moneyRemote:InvokeServer("remove", 500)  -- Change 500 to desired amount
```

## Color Schemes

### RGB Color Values

**Money Label Colors:**
```lua
-- Green (current)
moneyLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Alternatives:
-- Gold: Color3.fromRGB(255, 215, 0)
-- Cyan: Color3.fromRGB(0, 255, 255)
-- White: Color3.fromRGB(255, 255, 255)
-- Yellow: Color3.fromRGB(255, 255, 0)
```

**Background Colors:**
```lua
-- Dark gray (current)
screenGui.BackgroundColor3 = Color3.fromRGB(46, 46, 46)

-- Add Money Button - Green
addButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- Remove Money Button - Red
removeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
```

## Font Styles

Available fonts in Roblox:
- `Enum.Font.GothamBold` (current)
- `Enum.Font.Gotham`
- `Enum.Font.Arial`
- `Enum.Font.ArialBold`
- `Enum.Font.Highway`
- `Enum.Font.GothicGothic`

```lua
moneyLabel.Font = Enum.Font.GothamBold
addButton.Font = Enum.Font.GothamBold
```

## Text Sizes

```lua
-- Money display
moneyLabel.TextSize = 24

-- Button text
addButton.TextSize = 18
removeButton.TextSize = 18
```

## Advanced Configuration

### Disable Test Buttons
To hide the test buttons and only show the money display:

In `src/Client/MoneyUI.lua`, comment out:
```lua
-- addButton.Parent = screenGui
-- removeButton.Parent = screenGui
```

### Custom Functions

Add your own money functions in `src/Server/MoneySystem.lua`:

```lua
function moneyRemote.OnServerInvoke(player, action, amount)
	if action == "add" then
		return addMoney(player, amount)
	elseif action == "remove" then
		return removeMoney(player, amount)
	elseif action == "set" then
		return setMoney(player, amount)
	elseif action == "get" then
		return getMoney(player)
	elseif action == "custom" then
		-- Your custom logic here
		return customFunction(player, amount)
	end
end
```

### Data Persistence

The system uses DataStore. Make sure your game has DataStore enabled:
1. Go to **Game Settings**
2. Enable **API Access** in the **Security** section
3. Make sure your game is published (not just saved locally)

## Troubleshooting

### Money not updating?
- Check that the server script is in ServerScriptService
- Verify the client script is in StarterCharacterScripts or StarterPlayer
- Check console for errors (View → Output)

### Buttons not working?
- Ensure ReplicatedStorage has the MoneyRemote
- Check that both server and client scripts are running
- Try reloading the game

### UI not showing?
- Verify the LocalScript is in the correct location
- Check that ScreenGui was created successfully
- Ensure PlayerGui is accessible

## Best Practices

1. **Always validate on the server** - Never trust client input
2. **Use RemoteFunction for all transactions** - Prevents hacking
3. **Set reasonable MAX_MONEY** - Prevents economy exploitation
4. **Monitor for duplication exploits** - Log all transactions
5. **Save frequently** - Use DataStore properly to prevent data loss

---

For more help, see README.md
