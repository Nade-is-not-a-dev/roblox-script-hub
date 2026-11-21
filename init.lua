-- init.lua
-- File pertama yang di-loadstring hub.
-- Welcome screen -> loading palsu ~2 detik -> cek PlaceId -> load script game.
-- Semua komentar Bahasa Indonesia. Tanpa Enum.Font (pernah error di Delta).

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local me = Players.LocalPlayer

local G = (type(getgenv) == "function" and getgenv()) or _G

-- URL dasar repo. Boleh di-override sebelum loadstring:
-- getgenv().HUB_BASE_URL = "https://raw.githubusercontent.com/user/repo/main/"
local BASE_URL = tostring(G.HUB_BASE_URL or "https://raw.githubusercontent.com/Nade-is-not-a-dev/roblox-script-hub/master/")
if BASE_URL:sub(-1) ~= "/" then BASE_URL = BASE_URL .. "/" end

-- Daftar game yang didukung. Tambah entri di sini untuk game berikutnya.
local REGISTRY = {
	[107430170196919] = "games/107430170196919.lua",
}

local HUB_VERSION = "v1.0"
local FAKE_LOAD_SECONDS = 2.0

if G.HUB_LOADED then return end
G.HUB_LOADED = true

-- Bersihkan loader lama kalau script dijalankan ulang.
for _, obj in ipairs(me.PlayerGui:GetChildren()) do
	if obj:IsA("ScreenGui") and obj.Name == "ScriptHubLoader" then
		obj:Destroy()
	end
end

-- Palet: arang gelap + satu aksen teal, sama semangat dengan panel autoaim.
local C = {
	bg      = Color3.fromRGB(13, 16, 21),
	panel   = Color3.fromRGB(21, 26, 33),
	stroke  = Color3.fromRGB(42, 50, 61),
	text    = Color3.fromRGB(232, 237, 242),
	muted   = Color3.fromRGB(138, 151, 166),
	accent  = Color3.fromRGB(47, 211, 181),
	dim     = Color3.fromRGB(34, 74, 68),
	track   = Color3.fromRGB(34, 42, 52),
	bad     = Color3.fromRGB(224, 108, 108),
	warn    = Color3.fromRGB(224, 166, 74),
	ink     = Color3.fromRGB(9, 20, 17),
}

-- Lebar adaptif supaya tidak melewati tepi di HP kecil.
local view = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
local panelW = math.clamp(view.X - 32, 280, 380)
local panelH = 232

local gui = Instance.new("ScreenGui")
gui.Name = "ScriptHubLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = me.PlayerGui

local function corner(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
	return c
end

local function stroke(o, col, tr)
	local s = Instance.new("UIStroke")
	s.Color = col or C.stroke
	s.Thickness = 1
	s.Transparency = tr or 0
	s.Parent = o
	return s
end

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, panelW, 0, panelH)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = C.panel
panel.BorderSizePixel = 0
panel.Parent = gui
corner(panel, 16)
stroke(panel, C.stroke, 0.25)

local title = Instance.new("TextLabel")
title.Text = "SCRIPT HUB"
title.Size = UDim2.new(1, -110, 0, 26)
title.Position = UDim2.new(0, 20, 0, 14)
title.BackgroundTransparency = 1
title.TextColor3 = C.text
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local ver = Instance.new("TextLabel")
ver.Text = HUB_VERSION
ver.Size = UDim2.new(0, 46, 0, 26)
ver.Position = UDim2.new(1, -96, 0, 14)
ver.BackgroundTransparency = 1
ver.TextColor3 = C.muted
ver.TextSize = 11
ver.TextXAlignment = Enum.TextXAlignment.Right
ver.Parent = panel

local xBtn = Instance.new("TextButton")
xBtn.Text = "X"
xBtn.Size = UDim2.new(0, 30, 0, 30)
xBtn.Position = UDim2.new(1, -46, 0, 12)
xBtn.BackgroundColor3 = C.bg
xBtn.BorderSizePixel = 0
xBtn.TextColor3 = C.muted
xBtn.TextSize = 13
xBtn.Parent = panel
corner(xBtn, 9)
stroke(xBtn, C.stroke, 0.4)

xBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -40, 0, 1)
divider.Position = UDim2.new(0, 20, 0, 48)
divider.BackgroundColor3 = C.stroke
divider.BorderSizePixel = 0
divider.Parent = panel

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 7, 0, 7)
dot.Position = UDim2.new(0, 23, 0, 78)
dot.BackgroundColor3 = C.accent
dot.BorderSizePixel = 0
dot.Parent = panel
corner(dot, 4)

local status = Instance.new("TextLabel")
status.Text = "Menyiapkan..."
status.Size = UDim2.new(1, -58, 0, 46)
status.Position = UDim2.new(0, 38, 0, 58)
status.BackgroundTransparency = 1
status.TextColor3 = C.text
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Center
status.TextWrapped = true
status.Parent = panel

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -40, 0, 10)
barBg.Position = UDim2.new(0, 20, 0, 116)
barBg.BackgroundColor3 = C.track
barBg.BorderSizePixel = 0
barBg.Parent = panel
corner(barBg, 5)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = C.accent
barFill.BorderSizePixel = 0
barFill.Parent = barBg
corner(barFill, 5)

local placeLbl = Instance.new("TextLabel")
placeLbl.Text = "PlaceId " .. tostring(game.PlaceId)
placeLbl.Size = UDim2.new(1, -40, 0, 20)
placeLbl.Position = UDim2.new(0, 20, 0, 134)
placeLbl.BackgroundTransparency = 1
placeLbl.TextColor3 = C.muted
placeLbl.TextSize = 11
placeLbl.TextXAlignment = Enum.TextXAlignment.Left
placeLbl.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "TUTUP"
closeBtn.Size = UDim2.new(1, -40, 0, 44)
closeBtn.Position = UDim2.new(0, 20, 0, 172)
closeBtn.BackgroundColor3 = C.dim
closeBtn.BorderSizePixel = 0
closeBtn.TextColor3 = C.text
closeBtn.TextSize = 14
closeBtn.Visible = false
closeBtn.Parent = panel
corner(closeBtn, 11)
local closeStroke = stroke(closeBtn, C.accent, 0.55)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Status + dot dengan transisi warna halus.
local function setStatus(text, tone)
	status.Text = tostring(text)
	local col = C.accent
	if tone == "bad" then
		col = C.bad
	elseif tone == "warn" then
		col = C.warn
	elseif tone == "idle" then
		col = C.muted
	end
	TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = col,
	}):Play()
end

-- Progress bar di-tween, tidak lompat kasar.
local function setProgress(p)
	p = math.clamp(p, 0, 1)
	TweenService:Create(barFill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(p, 0, 1, 0),
	}):Play()
end

local function showMessage(judul, isi, tone)
	title.Text = judul
	status.Text = isi
	barBg.Visible = false
	closeBtn.Visible = true
	if tone == "bad" then
		closeBtn.BackgroundColor3 = C.bad
		closeBtn.TextColor3 = Color3.fromRGB(20, 8, 8)
		closeStroke.Color = C.bad
	end
	setStatus(isi, tone or "bad")
end

local function fakeLoad()
	local steps = 40
	for i = 1, steps do
		task.wait(FAKE_LOAD_SECONDS / steps)
		setProgress(i / steps)
		if i < 14 then
			setStatus("Menyiapkan...", "idle")
		elseif i < 28 then
			setStatus("Menghubungi repositori...", "idle")
		else
			setStatus("Mendaftarkan game...", "idle")
		end
	end
end

local function runGameScript(path)
	setStatus("Mengunduh script game...", "idle")
	local src, dlErr
	local ok = pcall(function()
		src = game:HttpGet(BASE_URL .. path, true)
	end)
	if not ok then dlErr = src end
	if not ok or type(src) ~= "string" or #src < 200 then
		local detail = tostring(dlErr or "respons kosong")
		showMessage("Gagal memuat", "Script game tidak bisa diunduh dari repo.\n" .. detail, "bad")
		return
	end

	setStatus("Menjalankan script game...", "idle")
	task.wait(0.2)

	local loader = rawget(G, "loadstring")
	if type(loader) ~= "function" then loader = loadstring end
	if type(loader) ~= "function" then
		showMessage("Gagal memuat", "Executor tidak menyediakan loadstring.", "bad")
		return
	end

	local fn, err = loader(src, path)
	if type(fn) ~= "function" then
		showMessage("Gagal memuat", "Script game bermasalah:\n" .. tostring(err), "bad")
		return
	end

	-- GUI hub dibuang dulu, baru script game dijalankan.
	gui:Destroy()
	local started, runErr = pcall(fn)
	if not started then
		warn("[hub] gagal menjalankan " .. path .. ": " .. tostring(runErr))
	end
end

local function start()
	fakeLoad()
	setStatus("Mengecek PlaceId...", "idle")
	task.wait(0.15)

	local id = game.PlaceId
	local path = REGISTRY[id]
	if not path then
		showMessage("Game belum didukung",
			"PlaceId " .. tostring(id) .. " belum terdaftar di hub.\nScript game tidak dijalankan.", "warn")
		return
	end

	runGameScript(path)
end

task.spawn(start)
