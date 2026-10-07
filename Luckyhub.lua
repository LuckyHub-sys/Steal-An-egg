--========================================================
-- LUCKY HUB
-- VERSION 2.0.0
-- DARK GREEN UI
-- MOBILE + PC
--========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer

if not Player then
	return
end

local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIG
--========================================================

local VERSION = "2.0.0"

local MIN_SPEED = 16
local MAX_SPEED = 850
local SPEED = 350

local RETURN_HEIGHT = 2

local TEMPLE_NAME = "Titan Temple"
local SAFEZONE_NAME = "SafeZone"

local TEMPLE_EGG_RADIUS = 180
local EGG_DISTANCE = 5
local SAFEZONE_DISTANCE = 8

local MOVE_TIMEOUT = 25

--========================================================
-- SETTINGS
--========================================================

local AUTO_STEAL = false
local AUTO_PLACE = false
local AUTO_HATCH = false
local AUTO_TREADMILL = false
local AUTO_SELL = false
local AUTO_FAVOURITE = false

local AUTO_RETURN = false
local GOD_MODE = false
local NOCLIP = false
local ANTI_TRAP = false

--========================================================
-- CHARACTER
--========================================================

local Character
local Humanoid
local HRP

local function setupCharacter(character)

	Character = character

	Humanoid =
		character:WaitForChild(
			"Humanoid",
			10
		)

	HRP =
		character:WaitForChild(
			"HumanoidRootPart",
			10
		)

	if Humanoid then

		pcall(function()

			Humanoid.BreakJointsOnDeath =
				false

			Humanoid.RequiresNeck =
				false
		end)
	end
end

if Player.Character then

	task.spawn(function()
		setupCharacter(
			Player.Character
		)
	end)
end

--========================================================
-- STATES
--========================================================

local moving = false
local missionRunning = false

local currentEgg = nil

local connectedPrompts = {}

--========================================================
-- GOD MODE DATA
--========================================================

local godConnections = {}

local godDamageTaken = false
local godLastHealth = nil

--========================================================
-- NOCLIP DATA
--========================================================

local savedCollision = {}

--========================================================
-- ANTI TRAP DATA
--========================================================

local trapParts = {}
local trapOriginalCanTouch = {}

--========================================================
-- OLD UI
--========================================================

local oldGui =
	PlayerGui:FindFirstChild(
		"LuckyHubUI"
	)

if oldGui then
	oldGui:Destroy()
end

--========================================================
-- SCREEN GUI
--========================================================

local ScreenGui =
	Instance.new("ScreenGui")

ScreenGui.Name =
	"LuckyHubUI"

ScreenGui.ResetOnSpawn =
	false

ScreenGui.IgnoreGuiInset =
	true

ScreenGui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

ScreenGui.DisplayOrder =
	999

ScreenGui.Parent =
	PlayerGui

--========================================================
-- MAIN WINDOW
--========================================================

local Main =
	Instance.new("Frame")

Main.Name =
	"Main"

Main.Size =
	UDim2.new(
		0.92,
		0,
		0.82,
		0
	)

Main.Position =
	UDim2.new(
		0.04,
		0,
		0.09,
		0
	)

Main.BackgroundColor3 =
	Color3.fromRGB(
		12,
		24,
		18
	)

Main.BackgroundTransparency =
	0.08

Main.BorderSizePixel =
	0

Main.Active =
	false

Main.ZIndex =
	10

Main.Parent =
	ScreenGui

local MainCorner =
	Instance.new("UICorner")

MainCorner.CornerRadius =
	UDim.new(
		0,
		18
	)

MainCorner.Parent =
	Main

local MainStroke =
	Instance.new("UIStroke")

MainStroke.Thickness =
	1.5

MainStroke.Color =
	Color3.fromRGB(
		65,
		180,
		105
	)

MainStroke.Transparency =
	0.25

MainStroke.Parent =
	Main

--========================================================
-- TOP BAR
--========================================================

local TopBar =
	Instance.new("Frame")

TopBar.Size =
	UDim2.new(
		1,
		0,
		0,
		62
	)

TopBar.BackgroundTransparency =
	1

TopBar.ZIndex =
	15

TopBar.Parent =
	Main

--========================================================
-- DRAG HANDLE
--========================================================

local DragHandle =
	Instance.new("TextButton")

DragHandle.Size =
	UDim2.new(
		1,
		-170,
		1,
		0
	)

DragHandle.Position =
	UDim2.fromOffset(
		0,
		0
	)

DragHandle.BackgroundTransparency =
	1

DragHandle.Text =
	""

DragHandle.AutoButtonColor =
	false

DragHandle.Active =
	true

DragHandle.ZIndex =
	20

DragHandle.Parent =
	TopBar

--========================================================
-- FPS
--========================================================

local Performance =
	Instance.new("TextLabel")

Performance.Size =
	UDim2.fromOffset(
		150,
		30
	)

Performance.Position =
	UDim2.fromOffset(
		18,
		8
	)

Performance.BackgroundTransparency =
	1

Performance.Text =
	"60 FPS | 0 MS"

Performance.TextSize =
	15

Performance.Font =
	Enum.Font.GothamBold

Performance.TextColor3 =
	Color3.fromRGB(
		225,
		235,
		228
	)

Performance.TextXAlignment =
	Enum.TextXAlignment.Left

Performance.ZIndex =
	20

Performance.Parent =
	TopBar

--========================================================
-- TITLE
--========================================================

local Title =
	Instance.new("TextLabel")

Title.Size =
	UDim2.new(
		0.42,
		0,
		0,
		35
	)

Title.Position =
	UDim2.new(
		0.32,
		0,
		0,
		7
	)

Title.BackgroundTransparency =
	1

Title.Text =
	"LUCKY HUB | Version: "
		.. VERSION

Title.TextSize =
	17

Title.Font =
	Enum.Font.GothamBold

Title.TextColor3 =
	Color3.fromRGB(
		110,
		220,
		140
	)

Title.TextXAlignment =
	Enum.TextXAlignment.Center

Title.ZIndex =
	20

Title.Parent =
	TopBar

--========================================================
-- SETTINGS BUTTON
--========================================================

local SettingsButton =
	Instance.new("TextButton")

SettingsButton.Size =
	UDim2.fromOffset(
		80,
		42
	)

SettingsButton.Position =
	UDim2.new(
		1,
		-165,
		0,
		10
	)

SettingsButton.BackgroundTransparency =
	1

SettingsButton.Text =
	"Settings"

SettingsButton.TextSize =
	14

SettingsButton.Font =
	Enum.Font.GothamBold

SettingsButton.TextColor3 =
	Color3.fromRGB(
		235,
		240,
		235
	)

SettingsButton.Active =
	true

SettingsButton.Selectable =
	true

SettingsButton.ZIndex =
	30

SettingsButton.Parent =
	TopBar

--========================================================
-- MINIMIZE
--========================================================

local Minimize =
	Instance.new("TextButton")

Minimize.Size =
	UDim2.fromOffset(
		42,
		42
	)

Minimize.Position =
	UDim2.new(
		1,
		-105,
		0,
		10
	)

Minimize.BackgroundTransparency =
	1

Minimize.Text =
	"—"

Minimize.TextSize =
	26

Minimize.Font =
	Enum.Font.Gotham

Minimize.TextColor3 =
	Color3.fromRGB(
		230,
		235,
		230
	)

Minimize.Active =
	true

Minimize.ZIndex =
	30

Minimize.Parent =
	TopBar

--========================================================
-- CLOSE
--========================================================

local Close =
	Instance.new("TextButton")

Close.Size =
	UDim2.fromOffset(
		42,
		42
	)

Close.Position =
	UDim2.new(
		1,
		-55,
		0,
		10
	)

Close.BackgroundTransparency =
	1

Close.Text =
	"X"

Close.TextSize =
	20

Close.Font =
	Enum.Font.Gotham

Close.TextColor3 =
	Color3.fromRGB(
		235,
		235,
		235
	)

Close.Active =
	true

Close.ZIndex =
	30

Close.Parent =
	TopBar

--========================================================
-- SIDEBAR
--========================================================

local Sidebar =
	Instance.new("Frame")

Sidebar.Size =
	UDim2.new(
		0,
		175,
		1,
		-72
	)

Sidebar.Position =
	UDim2.fromOffset(
		10,
		65
	)

Sidebar.BackgroundTransparency =
	1

Sidebar.ZIndex =
	15

Sidebar.Parent =
	Main

--========================================================
-- HOME TITLE
--========================================================

local HomeTitle =
	Instance.new("TextLabel")

HomeTitle.Size =
	UDim2.new(
		1,
		-20,
		0,
		35
	)

HomeTitle.Position =
	UDim2.fromOffset(
		12,
		5
	)

HomeTitle.BackgroundTransparency =
	1

HomeTitle.Text =
	"Home"

HomeTitle.TextSize =
	16

HomeTitle.Font =
	Enum.Font.GothamBold

HomeTitle.TextColor3 =
	Color3.fromRGB(
		235,
		240,
		235
	)

HomeTitle.TextXAlignment =
	Enum.TextXAlignment.Left

HomeTitle.ZIndex =
	20

HomeTitle.Parent =
	Sidebar

--========================================================
-- SIDEBAR BUTTON
--========================================================

local sidebarButtons = {}

local function createSidebarButton(
	name,
	text,
	y
)

	local button =
		Instance.new("TextButton")

	button.Name =
		name

	button.Size =
		UDim2.new(
			1,
			-12,
			0,
			48
		)

	button.Position =
		UDim2.fromOffset(
			6,
			y
		)

	button.BackgroundColor3 =
		Color3.fromRGB(
			30,
			52,
			38
		)

	button.BackgroundTransparency =
		0.15

	button.BorderSizePixel =
		0

	button.Text =
		text

	button.TextSize =
		15

	button.Font =
		Enum.Font.GothamBold

	button.TextColor3 =
		Color3.fromRGB(
			225,
			235,
			228
		)

	button.TextXAlignment =
		Enum.TextXAlignment.Left

	button.Active =
		true

	button.Selectable =
		true

	button.ZIndex =
		25

	button.Parent =
		Sidebar

	local padding =
		Instance.new("UIPadding")

	padding.PaddingLeft =
		UDim.new(
			0,
			16
		)

	padding.Parent =
		button

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			9
		)

	corner.Parent =
		button

	sidebarButtons[name] =
		button

	return button
end

local MainSide =
	createSidebarButton(
		"MainSide",
		"▦  Main",
		48
	)

local FarmingSide =
	createSidebarButton(
		"FarmingSide",
		"⌁  Farming",
		102
	)

local PlayerSide =
	createSidebarButton(
		"PlayerSide",
		"○  Player",
		156
	)

--========================================================
-- CONTENT
--========================================================

local Content =
	Instance.new("Frame")

Content.Name =
	"Content"

Content.Size =
	UDim2.new(
		1,
		-205,
		1,
		-72
	)

Content.Position =
	UDim2.fromOffset(
		195,
		65
	)

Content.BackgroundTransparency =
	1

Content.ZIndex =
	15

Content.Parent =
	Main

--========================================================
-- SEARCH
--========================================================

local Search =
	Instance.new("TextBox")

Search.Size =
	UDim2.new(
		1,
		-20,
		0,
		48
	)

Search.Position =
	UDim2.fromOffset(
		10,
		5
	)

Search.BackgroundColor3 =
	Color3.fromRGB(
		20,
		40,
		28
	)

Search.BackgroundTransparency =
	0.08

Search.BorderSizePixel =
	0

Search.PlaceholderText =
	"Search settings..."

Search.Text =
	""

Search.TextSize =
	14

Search.Font =
	Enum.Font.Gotham

Search.TextColor3 =
	Color3.fromRGB(
		235,
		240,
		235
	)

Search.PlaceholderColor3 =
	Color3.fromRGB(
		150,
		170,
		155
	)

Search.ClearTextOnFocus =
	false

Search.ZIndex =
	25

Search.Parent =
	Content

local SearchCorner =
	Instance.new("UICorner")

SearchCorner.CornerRadius =
	UDim.new(
		0,
		10
	)

SearchCorner.Parent =
	Search

local SearchPadding =
	Instance.new("UIPadding")

SearchPadding.PaddingLeft =
	UDim.new(
		0,
		18
	)

SearchPadding.Parent =
	Search

--========================================================
-- LIST
--========================================================

local List =
	Instance.new("ScrollingFrame")

List.Name =
	"List"

List.Size =
	UDim2.new(
		1,
		-20,
		1,
		-65
	)

List.Position =
	UDim2.fromOffset(
		10,
		60
	)

List.BackgroundTransparency =
	1

List.BorderSizePixel =
	0

List.ScrollBarThickness =
	3

List.ScrollBarImageColor3 =
	Color3.fromRGB(
		75,
		180,
		105
	)

List.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		0
	)

List.ZIndex =
	20

List.Parent =
	Content

local ListLayout =
	Instance.new("UIListLayout")

ListLayout.Padding =
	UDim.new(
		0,
		8
	)

ListLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

ListLayout.Parent =
	List

--========================================================
-- STATUS
--========================================================

local Status =
	Instance.new("TextLabel")

Status.Size =
	UDim2.new(
		1,
		-20,
		0,
		24
	)

Status.Position =
	UDim2.new(
		0,
		10,
		1,
		-28
	)

Status.BackgroundTransparency =
	1

Status.Text =
	"Ready"

Status.TextSize =
	11

Status.Font =
	Enum.Font.Gotham

Status.TextColor3 =
	Color3.fromRGB(
		135,
		175,
		145
	)

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.ZIndex =
	25

Status.Parent =
	Content

--========================================================
-- PAGE SYSTEM
--========================================================

local currentPage =
	"Main"

local featureRows = {}

local function clearRows()

	for _, row in ipairs(
		featureRows
	) do

		if row
			and row.Parent then

			row:Destroy()
		end
	end

	table.clear(
		featureRows
	)
end

--========================================================
-- TOGGLE TEXT
--========================================================

local function settingText(
	value
)

	if value then
		return "ON"
	end

	return "OFF"
end

--========================================================
-- FEATURE ROW
--========================================================

local function createFeatureRow(
	name,
	displayName,
	callback,
	getState
)

	local row =
		Instance.new("TextButton")

	row.Name =
		name

	row.Size =
		UDim2.new(
			1,
			-5,
			0,
			58
		)

	row.BackgroundColor3 =
		Color3.fromRGB(
			25,
			48,
			32
		)

	row.BackgroundTransparency =
		0.08

	row.BorderSizePixel =
		0

	row.Text =
		""

	row.AutoButtonColor =
		true

	row.Active =
		true

	row.Selectable =
		true

	row.ZIndex =
		25

	row.Parent =
		List

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			9
		)

	corner.Parent =
		row

	local label =
		Instance.new("TextLabel")

	label.Size =
		UDim2.new(
			1,
			-80,
			1,
			0
		)

	label.Position =
		UDim2.fromOffset(
			20,
			0
		)

	label.BackgroundTransparency =
		1

	label.Text =
		displayName

	label.TextSize =
		14

	label.Font =
		Enum.Font.GothamBold

	label.TextColor3 =
		Color3.fromRGB(
			235,
			240,
			235
		)

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	label.ZIndex =
		27

	label.Parent =
		row

	local state =
		Instance.new("TextLabel")

	state.Size =
		UDim2.fromOffset(
			45,
			25
		)

	state.Position =
		UDim2.new(
			1,
			-65,
			0.5,
			-12
		)

	state.BackgroundTransparency =
		1

	state.Text =
		">"

	state.TextSize =
		23

	state.Font =
		Enum.Font.Gotham

	state.TextColor3 =
		Color3.fromRGB(
			235,
			240,
			235
		)

	state.ZIndex =
		27

	state.Parent =
		row

	local function update()

		if getState then

			local value =
				getState()

			if value then

				row.BackgroundColor3 =
					Color3.fromRGB(
						35,
						78,
						48
					)
			else

				row.BackgroundColor3 =
					Color3.fromRGB(
						25,
						48,
						32
					)
			end
		end
	end

	row.Activated:Connect(
		function()

			callback()

			update()
		end
	)

	table.insert(
		featureRows,
		row
	)

	update()

	return row
end

--========================================================
-- SETTINGS PAGE
--========================================================

local function openFeature(
	titleText,
	description,
	getState,
	toggleFunction
)

	clearRows()

	Search.Visible =
		false

	local back =
		Instance.new("TextButton")

	back.Size =
		UDim2.new(
			1,
			-5,
			0,
			45
		)

	back.BackgroundColor3 =
		Color3.fromRGB(
			25,
			48,
			32
		)

	back.BorderSizePixel =
		0

	back.Text =
		"<  " .. titleText

	back.TextSize =
		15

	back.Font =
		Enum.Font.GothamBold

	back.TextColor3 =
		Color3.fromRGB(
			235,
			240,
			235
		)

	back.TextXAlignment =
		Enum.TextXAlignment.Left

	back.ZIndex =
		30

	back.Parent =
		List

	local backPadding =
		Instance.new("UIPadding")

	backPadding.PaddingLeft =
		UDim.new(
			0,
			15
		)

	backPadding.Parent =
		back

	local backCorner =
		Instance.new("UICorner")

	backCorner.CornerRadius =
		UDim.new(
			0,
			9
		)

	backCorner.Parent =
		back

	table.insert(
		featureRows,
		back
	)

	back.Activated:Connect(
		function()

			currentPage =
				"Main"

			buildMainPage()
		end
	)

	local info =
		Instance.new("TextLabel")

	info.Size =
		UDim2.new(
			1,
			-5,
			0,
			70
		)

	info.BackgroundTransparency =
		1

	info.Text =
		description

	info.TextSize =
		12

	info.Font =
		Enum.Font.Gotham

	info.TextColor3 =
		Color3.fromRGB(
			155,
			180,
			160
		)

	info.TextWrapped =
		true

	info.TextXAlignment =
		Enum.TextXAlignment.Left

	info.ZIndex =
		25

	info.Parent =
		List

	table.insert(
		featureRows,
		info
	)

	local toggle =
		Instance.new("TextButton")

	toggle.Size =
		UDim2.new(
			1,
			-5,
			0,
			55
		)

	toggle.BackgroundColor3 =
		Color3.fromRGB(
			30,
			65,
			40
		)

	toggle.BorderSizePixel =
		0

	toggle.Text =
		""

	toggle.Active =
		true

	toggle.ZIndex =
		30

	toggle.Parent =
		List

	local toggleCorner =
		Instance.new("UICorner")

	toggleCorner.CornerRadius =
		UDim.new(
			0,
			9
		)

	toggleCorner.Parent =
		toggle

	local toggleText =
		Instance.new("TextLabel")

	toggleText.Size =
		UDim2.new(
			1,
			-80,
			1,
			0
		)

	toggleText.Position =
		UDim2.fromOffset(
			18,
			0
		)

	toggleText.BackgroundTransparency =
		1

	toggleText.Text =
		titleText

	toggleText.TextSize =
		14

	toggleText.Font =
		Enum.Font.GothamBold

	toggleText.TextColor3 =
		Color3.fromRGB(
			235,
			240,
			235
		)

	toggleText.TextXAlignment =
		Enum.TextXAlignment.Left

	toggleText.ZIndex =
		32

	toggleText.Parent =
		toggle

	local toggleState =
		Instance.new("TextLabel")

	toggleState.Size =
		UDim2.fromOffset(
			65,
			30
		)

	toggleState.Position =
		UDim2.new(
			1,
			-80,
			0.5,
			-15
		)

	toggleState.BackgroundTransparency =
		1

	toggleState.TextSize =
		12

	toggleState.Font =
		Enum.Font.GothamBold

	toggleState.ZIndex =
		32

	toggleState.Parent =
		toggle

	local function refresh()

		local enabled =
			getState()

		toggleState.Text =
			settingText(
				enabled
			)

		if enabled then

			toggleState.TextColor3 =
				Color3.fromRGB(
					100,
					230,
					135
				)

		else

			toggleState.TextColor3 =
				Color3.fromRGB(
					160,
					170,
					165
				)
		end
	end

	toggle.Activated:Connect(
		function()

			toggleFunction()

			refresh()
		end
	)

	refresh()

	table.insert(
		featureRows,
		toggle
	)

	List.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			ListLayout.AbsoluteContentSize.Y
				+ 10
		)
end

--========================================================
-- MAIN PAGE
--========================================================

function buildMainPage()

	currentPage =
		"Main"

	clearRows()

	Search.Visible =
		true

	createFeatureRow(
		"AutoSteal",
		"Auto Steal",
		function()

			openFeature(
				"Auto Steal",
				"Go to Titan Temple, find an egg and take it automatically.",
				function()
					return AUTO_STEAL
				end,
				function()

					AUTO_STEAL =
						not AUTO_STEAL

					if AUTO_STEAL then

						task.spawn(
							autoStealMission
						)
					else

						missionRunning =
							false

						currentEgg =
							nil

						stopMovement()
					end
				end
			)
		end,
		function()
			return AUTO_STEAL
		end
	)

	createFeatureRow(
		"AutoPlace",
		"Auto Place",
		function()

			openFeature(
				"Auto Place",
				"Find your own cage or plot and automatically use the placement prompt.",
				function()
					return AUTO_PLACE
				end,
				function()

					AUTO_PLACE =
						not AUTO_PLACE
				end
			)
		end,
		function()
			return AUTO_PLACE
		end
	)

	--========================================================
-- PART 2
-- CONTINUE LUCKY HUB
--========================================================

--========================================================
-- OBJECT FINDER
--========================================================

local function findNamedObject(
	name
)

	local exact =
		Workspace:FindFirstChild(
			name,
			true
		)

	if exact then
		return exact
	end

	local wanted =
		string.lower(
			name
		)

	for _, object in ipairs(
		Workspace:GetDescendants()
	) do

		if string.lower(
			object.Name
		) == wanted then

			return object
		end
	end

	return nil
end

local function getPart(
	object
)

	if not object then
		return nil
	end

	if object:IsA(
		"BasePart"
	) then

		return object
	end

	if object:IsA(
		"Model"
	) then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		return object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)
	end

	return nil
end

--========================================================
-- SAFEZONE
--========================================================

local function findSafeZone()

	return getPart(
		findNamedObject(
			SAFEZONE_NAME
		)
	)
end

--========================================================
-- TEMPLE
--========================================================

local function findTemple()

	return getPart(
		findNamedObject(
			TEMPLE_NAME
		)
	)
end

--========================================================
-- PROMPT TEXT
--========================================================

local function getPromptText(
	prompt
)

	if not prompt then
		return ""
	end

	local text =
		(prompt.Name or "")
		.. " "
		.. (prompt.ActionText or "")
		.. " "
		.. (prompt.ObjectText or "")

	if prompt.Parent then

		text =
			text
			.. " "
			.. prompt.Parent.Name
	end

	return string.lower(
		text
	)
end

--========================================================
-- PROMPT POSITION
--========================================================

local function getPromptPosition(
	prompt
)

	if not prompt
		or not prompt.Parent then

		return nil
	end

	local parent =
		prompt.Parent

	if parent:IsA(
		"BasePart"
	) then

		return parent.Position
	end

	if parent:IsA(
		"Attachment"
	) then

		return parent.WorldPosition
	end

	local part =
		getPart(
			parent
		)

	if part then
		return part.Position
	end

	return nil
end

--========================================================
-- FIND PROMPT BY KEYWORD
--========================================================

local function findPromptByKeywords(
	keywords
)

	if not HRP
		or not HRP.Parent then

		return nil
	end

	local closest =
		nil

	local closestDistance =
		math.huge

	for _, object in ipairs(
		Workspace:GetDescendants()
	) do

		if object:IsA(
			"ProximityPrompt"
		) then

			local text =
				getPromptText(
					object
				)

			local matched =
				false

			for _, keyword in ipairs(
				keywords
			) do

				if string.find(
					text,
					string.lower(
						keyword
					),
					1,
					true
				) then

					matched =
						true

					break
				end
			end

			if matched then

				local position =
					getPromptPosition(
						object
					)

				if position then

					local distance =
						(
							position
							- HRP.Position
						).Magnitude

					if distance
						< closestDistance then

						closestDistance =
							distance

						closest =
							object
					end
				end
			end
		end
	end

	return closest
end

--========================================================
-- MOVE
--========================================================

local function stopMovement()

	moving =
		false

	if Humanoid
		and Humanoid.Parent then

		Humanoid:Move(
			Vector3.zero,
			false
		)
	end

	if HRP
		and HRP.Parent then

		local velocity =
			HRP.AssemblyLinearVelocity

		HRP.AssemblyLinearVelocity =
			Vector3.new(
				0,
				velocity.Y,
				0
			)
	end
end

local function moveStraightTo(
	target,
	distanceLimit,
	timeout
)

	if moving then
		return false
	end

	if not HRP
		or not Humanoid
		or not HRP.Parent
		or not Humanoid.Parent then

		return false
	end

	moving =
		true

	local start =
		os.clock()

	local reached =
		false

	while moving
		and HRP
		and HRP.Parent
		and Humanoid
		and Humanoid.Parent
		and os.clock()
			- start
			< timeout do

		local offset =
			target
			- HRP.Position

		local distance =
			offset.Magnitude

		if distance
			<= distanceLimit then

			reached =
				true

			break
		end

		local direction =
			offset.Unit

		Humanoid.WalkSpeed =
			SPEED

		Humanoid:Move(
			direction,
			false
		)

		RunService.Heartbeat:Wait()
	end

	stopMovement()

	return reached
end

--========================================================
-- ACTIVATE PROMPT
--========================================================

local function activatePrompt(
	prompt
)

	if not prompt
		or not prompt.Parent then

		return false
	end

	local success =
		pcall(
			function()

				prompt:InputHoldBegin()

				task.wait(
					math.max(
						prompt.HoldDuration,
						0.05
					)
				)

				prompt:InputHoldEnd()
			end
		)

	return success
end

--========================================================
-- FIND EGG
--========================================================

local function isEggPrompt(
	prompt
)

	local text =
		getPromptText(
			prompt
		)

	return string.find(
		text,
		"egg",
		1,
		true
	) ~= nil
end

local function findEggPrompt()

	if not HRP
		or not HRP.Parent then

		return nil
	end

	local temple =
		findTemple()

	if not temple then
		return nil
	end

	local closest =
		nil

	local closestDistance =
		math.huge

	for _, object in ipairs(
		Workspace:GetDescendants()
	) do

		if object:IsA(
			"ProximityPrompt"
		)
		and isEggPrompt(
			object
		)
		then

			local position =
				getPromptPosition(
					object
				)

			if position then

				local templeDistance =
					(
						position
						- temple.Position
					).Magnitude

				if templeDistance
					<= TEMPLE_EGG_RADIUS then

					local playerDistance =
						(
							position
							- HRP.Position
						).Magnitude

					if playerDistance
						< closestDistance then

						closestDistance =
							playerDistance

						closest =
							object
					end
				end
			end
		end
	end

	return closest
end

--========================================================
-- AUTO STEAL
--========================================================

function autoStealMission()

	if missionRunning then
		return
	end

	if not AUTO_STEAL then
		return
	end

	if not HRP
		or not HRP.Parent then
		return
	end

	missionRunning =
		true

	local temple =
		findTemple()

	if not temple then

		missionRunning =
			false

		Status.Text =
			"Titan Temple not found"

		return
	end

	Status.Text =
		"Going to Titan Temple..."

	moveStraightTo(
		temple.Position,
		8,
		MOVE_TIMEOUT
	)

	if not AUTO_STEAL then

		missionRunning =
			false

		return
	end

	local egg =
		findEggPrompt()

	if not egg then

		missionRunning =
			false

		Status.Text =
			"Egg not found"

		return
	end

	currentEgg =
		egg

	local eggPosition =
		getPromptPosition(
			egg
		)

	if eggPosition then

		Status.Text =
			"Going to egg..."

		moveStraightTo(
			eggPosition,
			EGG_DISTANCE,
			MOVE_TIMEOUT
		)
	end

	if AUTO_STEAL then

		Status.Text =
			"Taking egg..."

		activatePrompt(
			egg
		)
	end

	currentEgg =
		nil

	task.wait(
		0.15
	)

	if AUTO_RETURN
		and AUTO_STEAL then

		local safeZone =
			findSafeZone()

		if safeZone then

			Status.Text =
				"Returning to SafeZone..."

			moveStraightTo(
				safeZone.Position
					+ Vector3.new(
						0,
						RETURN_HEIGHT,
						0
					),
				SAFEZONE_DISTANCE,
				MOVE_TIMEOUT
			)
		end
	end

	missionRunning =
		false
end

--========================================================
-- AUTO TREADMILL
--========================================================

function goToTreadmill()

	if not HRP
		or not HRP.Parent then
		return
	end

	local prompt =
		findPromptByKeywords(
			{
				"treadmill",
				"run",
				"train"
			}
		)

	local treadmill =
		findNamedObject(
			"Treadmill"
		)

	local target =
		nil

	if prompt then

		target =
			getPromptPosition(
				prompt
			)

	elseif treadmill then

		local part =
			getPart(
				treadmill
			)

		if part then
			target =
				part.Position
		end
	end

	if not target then

		Status.Text =
			"Treadmill not found"

		return
	end

	Status.Text =
		"Teleporting to treadmill..."

	-- Direct teleport khusus treadmill.
	if HRP
		and HRP.Parent then

		HRP.CFrame =
			CFrame.new(
				target
					+ Vector3.new(
						0,
						3,
						0
					)
			)
	end

	Status.Text =
		"At treadmill"
end

--========================================================
-- FIND PLAYER PLOT / CAGE
--========================================================

local function isOwnPlot(
	object
)

	if not object then
		return false
	end

	local playerName =
		string.lower(
			Player.Name
		)

	local displayName =
		string.lower(
			Player.DisplayName
		)

	local objectName =
		string.lower(
			object.Name
		)

	-- Name check
	if string.find(
		objectName,
		playerName,
		1,
		true
	) then

		return true
	end

	if string.find(
		objectName,
		displayName,
		1,
		true
	) then

		return true
	end

	-- Attribute check
	local owner =
		object:GetAttribute(
			"Owner"
		)

	if owner then

		if tostring(
			owner
		) == Player.Name
			or tostring(
				owner
			) == Player.UserId
		then

			return true
		end
	end

	local ownerName =
		object:GetAttribute(
			"OwnerName"
		)

	if ownerName then

		if tostring(
			ownerName
		):lower()
			== playerName then

			return true
		end
	end

	return false
end

local function findOwnCage()

	for _, object in ipairs(
		Workspace:GetDescendants()
	) do

		local name =
			string.lower(
				object.Name
			)

		if string.find(
			name,
			"cage",
			1,
			true
		)
		or string.find(
			name,
			"plot",
			1,
			true
		)
		or string.find(
			name,
			"base",
			1,
			true
		)
		then

			if isOwnPlot(
				object
			) then

				return object
			end
		end
	end

	return nil
end

--========================================================
-- AUTO PLACE
--========================================================

local function autoPlaceOnce()

	if not AUTO_PLACE then
		return
	end

	if not HRP
		or not HRP.Parent then
		return
	end

	local cage =
		findOwnCage()

	if not cage then

		Status.Text =
			"Your cage not found"

		return
	end

	local cagePart =
		getPart(
			cage
		)

	if cagePart then

		Status.Text =
			"Going to your cage..."

		moveStraightTo(
			cagePart.Position,
			7,
			MOVE_TIMEOUT
		)
	end

	local prompt =
		findPromptByKeywords(
			{
				"place",
				"put",
				"drop",
				"deposit"
			}
		)

	if prompt then

		Status.Text =
			"Placing..."

		activatePrompt(
			prompt
		)

		Status.Text =
			"Placed"
	else

		Status.Text =
			"Place prompt not found"
	end
end

--========================================================
-- AUTO HATCH
--========================================================

local function autoHatchOnce()

	if not AUTO_HATCH then
		return
	end

	local prompt =
		findPromptByKeywords(
			{
				"hatch",
				"open egg",
				"open",
				"incubate"
			}
		)

	if prompt then

		Status.Text =
			"Hatching..."

		activatePrompt(
			prompt
		)
	end
end

--========================================================
-- AUTO SELL
--========================================================

local function autoSellOnce()

	if not AUTO_SELL then
		return
	end

	local prompt =
		findPromptByKeywords(
			{
				"sell",
				"selling"
			}
		)

	if prompt then

		Status.Text =
			"Selling..."

		activatePrompt(
			prompt
		)
	end
end

--========================================================
-- AUTO FAVOURITE
--========================================================

local function autoFavouriteOnce()

	if not AUTO_FAVOURITE then
		return
	end

	local prompt =
		findPromptByKeywords(
			{
				"favorite",
				"favourite",
				"fav"
			}
		)

	if prompt then

		Status.Text =
			"Favouriting..."

		activatePrompt(
			prompt
		)
	end
end

--========================================================
-- GOD MODE
--========================================================

local function disconnectGod()

	for _, connection in ipairs(
		godConnections
	) do

		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(
		godConnections
	)
end

function enableGodMode()

	disconnectGod()

	if not Humanoid
		or not Humanoid.Parent then
		return
	end

	GOD_MODE =
		true

	godDamageTaken =
		false

	godLastHealth =
		Humanoid.Health

	pcall(function()

		Humanoid.BreakJointsOnDeath =
			false

		Humanoid.RequiresNeck =
			false

		Humanoid:SetStateEnabled(
			Enum.HumanoidStateType.Dead,
			false
		)
	end)

	Humanoid.Health =
		Humanoid.MaxHealth

	local healthConnection =
		Humanoid.HealthChanged:Connect(
			function(health)

				if not GOD_MODE then
					return
				end

				if health <
					(
						godLastHealth
						or Humanoid.MaxHealth
					)
				then

					godDamageTaken =
						true
				end

				godLastHealth =
					health

				if health <= 0 then

					Humanoid.Health =
						Humanoid.MaxHealth
				end
			end
		)

	table.insert(
		godConnections,
		healthConnection
	)

	local heartbeat =
		RunService.Heartbeat:Connect(
			function()

				if not GOD_MODE then
					return
				end

				if not Humanoid
					or not Humanoid.Parent then
					return
				end

				pcall(function()

					Humanoid:SetStateEnabled(
						Enum.HumanoidStateType.Dead,
						false
					)

					Humanoid.BreakJointsOnDeath =
						false

					Humanoid.RequiresNeck =
						false
				end)

				if Humanoid.Health <= 0 then

					Humanoid.Health =
						Humanoid.MaxHealth
				end
			end
		)

	table.insert(
		godConnections,
		heartbeat
	)
end

function disableGodMode()

	GOD_MODE =
		false

	disconnectGod()

	if Humanoid
		and Humanoid.Parent then

		pcall(function()

			Humanoid:SetStateEnabled(
				Enum.HumanoidStateType.Dead,
				true
			)

			Humanoid.BreakJointsOnDeath =
				true

			Humanoid.RequiresNeck =
				true
		end)
	end

	godLastHealth =
		nil

	godDamageTaken =
		false
end

--========================================================
-- NOCLIP
--========================================================

function enableNoClip()

	if not Character
		or not Character.Parent then
		return
	end

	table.clear(
		savedCollision
	)

	for _, object in ipairs(
		Character:GetDescendants()
	) do

		if object:IsA(
			"BasePart"
		) then

			savedCollision[object] =
				object.CanCollide

			object.CanCollide =
				false
		end
	end
end

function disableNoClip()

	for part, oldValue in pairs(
		savedCollision
	) do

		if part
			and part.Parent then

			part.CanCollide =
				oldValue
		end
	end

	table.clear(
		savedCollision
	)
end

RunService.Stepped:Connect(
	function()

		if not NOCLIP then
			return
		end

		if not Character
			or not Character.Parent then
			return
		end

		for _, object in ipairs(
			Character:GetDescendants()
		) do

			if object:IsA(
				"BasePart"
			) then

				object.CanCollide =
					false
			end
		end
	end
)

--========================================================
-- ANTI TRAP
--========================================================

local function isTrapPart(
	object
)

	if not object:IsA(
		"BasePart"
	) then

		return false
	end

	local text =
		string.lower(
			object.Name
			.. " "
			.. (
				object.Parent
				and object.Parent.Name
				or ""
			)
		)

	return string.find(
		text,
		"trap",
		1,
		true
	) ~= nil
	or string.find(
		text,
		"jebakan",
		1,
		true
	) ~= nil
end

local function scanTrapParts()

	if not ANTI_TRAP then
		return
	end

	for _, object in ipairs(
		Workspace:GetDescendants()
	) do

		if isTrapPart(
			object
		) then

			if trapOriginalCanTouch[object]
				== nil then

				trapOriginalCanTouch[object] =
					object.CanTouch
			end

			trapParts[object] =
				true

			pcall(function()

				object.CanTouch =
					false
			end)
		end
	end
end

function enableAntiTrap()

	ANTI_TRAP =
		true

	scanTrapParts()
end

function disableAntiTrap()

	ANTI_TRAP =
		false

	for part, value in pairs(
		trapOriginalCanTouch
	) do

		if part
			and part.Parent then

			pcall(function()

				part.CanTouch =
					value
			end)
		end
	end

	table.clear(
		trapParts
	)

	table.clear(
		trapOriginalCanTouch
	)
end

--========================================================
-- SIDEBAR
--========================================================

MainSide.Activated:Connect(
	function()

		buildMainPage()
	end
)

FarmingSide.Activated:Connect(
	function()

		buildFarmingPage()
	end
)

PlayerSide.Activated:Connect(
	function()

		buildPlayerPage()
	end
)

--========================================================
-- SEARCH
--========================================================

Search:GetPropertyChangedSignal(
	"Text"
):Connect(
	function()

		local query =
			string.lower(
				Search.Text
			)

		for _, row in ipairs(
			featureRows
		) do

			if row:IsA(
				"TextButton"
			) then

				local text =
					string.lower(
						row.Name
					)

				local label =
					row:FindFirstChildWhichIsA(
						"TextLabel"
					)

				if label then

					text =
						text
						.. " "
						.. string.lower(
							label.Text
						)
				end

				row.Visible =
					query == ""
					or string.find(
						text,
						query,
						1,
						true
					) ~= nil
			end
		end
	end
)

--========================================================
-- DRAG
--========================================================

local dragging =
	false

local dragStart =
	nil

local startPosition =
	nil

DragHandle.InputBegan:Connect(
	function(input)

		if input.UserInputType
			== Enum.UserInputType.MouseButton1
			or input.UserInputType
			== Enum.UserInputType.Touch then

			dragging =
				true

			dragStart =
				input.Position

			startPosition =
				Main.Position
		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if not dragging then
			return
		end

		if input.UserInputType
			== Enum.UserInputType.MouseMovement
			or input.UserInputType
			== Enum.UserInputType.Touch then

			local delta =
				input.Position
				- dragStart

			Main.Position =
				UDim2.new(
					startPosition.X.Scale,
					startPosition.X.Offset
						+ delta.X,

					startPosition.Y.Scale,
					startPosition.Y.Offset
						+ delta.Y
				)
		end
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if input.UserInputType
			== Enum.UserInputType.MouseButton1
			or input.UserInputType
			== Enum.UserInputType.Touch then

			dragging =
				false
		end
	end
)

--========================================================
-- MINIMIZE
--========================================================

local Mini =
	Instance.new("TextButton")

Mini.Name =
	"MiniBall"

Mini.Size =
	UDim2.fromOffset(
		58,
		58
	)

Mini.AnchorPoint =
	Vector2.new(
		0,
		0.5
	)

Mini.Position =
	UDim2.new(
		0,
		10,
		0.5,
		0
	)

Mini.BackgroundColor3 =
	Color3.fromRGB(
		20,
		55,
		32
	)

Mini.BorderSizePixel =
	0

Mini.Text =
	"LUCKY"

Mini.TextSize =
	10

Mini.Font =
	Enum.Font.GothamBold

Mini.TextColor3 =
	Color3.fromRGB(
		110,
		235,
		140
	)

Mini.Visible =
	false

Mini.Active =
	true

Mini.ZIndex =
	100

Mini.Parent =
	ScreenGui

local MiniCorner =
	Instance.new("UICorner")

MiniCorner.CornerRadius =
	UDim.new(
		1,
		0
	)

MiniCorner.Parent =
	Mini

local MiniStroke =
	Instance.new("UIStroke")

MiniStroke.Thickness =
	2

MiniStroke.Color =
	Color3.fromRGB(
		70,
		190,
		105
	)

MiniStroke.Parent =
	Mini

Minimize.Activated:Connect(
	function()

		Main.Visible =
			false

		Mini.Visible =
			true
	end
)

Close.Activated:Connect(
	function()

		Main.Visible =
			false

		Mini.Visible =
			true
	end
)

Mini.Activated:Connect(
	function()

		Main.Visible =
			true

		Mini.Visible =
			false
	end
)

--========================================================
-- PERFORMANCE
--========================================================

--==================================================
-- PERFORMANCE
--==================================================

local frameCounter =
	0

local lastUpdate =
	os.clock()

local fps =
	0

RunService.RenderStepped:Connect(
	function()
		frameCounter += 1

		local now =
			os.clock()

		if now - lastUpdate >= 1 then

			fps =
				frameCounter

			frameCounter =
				0

			lastUpdate =
				now

			local ping =
				0

			pcall(
				function()
					ping =
						Stats
							.Network
							.ServerStatsItem
							["Data Ping"]
							:GetValue()
				end
			)

			Performance.Text =
				tostring(fps)
				.. " FPS | "
				.. tostring(
					math.floor(ping)
				)
				.. " MS"
		end
	end
  )
