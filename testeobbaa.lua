local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =========================================================
-- CONFIGURAÇÃO
-- =========================================================

local atravessar = false
local selecionando = false
local invisivel = false
local fling = false
local espAtivo = false
local rgbAtivo = true
local minimizado = false

local paredes = {}
local selectedHighlights = {}
local invisibilityOriginals = {}
local espHighlights = {}

local flingCharacterConnection

-- =========================================================
-- GUI PRINCIPAL
-- =========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "ObjectToolsUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local janela = Instance.new("Frame")
janela.Name = "Janela"
janela.Size = UDim2.fromOffset(460, 430)
janela.Position = UDim2.new(0.5, -230, 0.5, -215)
janela.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
janela.BorderSizePixel = 0
janela.Parent = gui

local janelaCorner = Instance.new("UICorner")
janelaCorner.CornerRadius = UDim.new(0, 14)
janelaCorner.Parent = janela

local janelaStroke = Instance.new("UIStroke")
janelaStroke.Color = Color3.fromRGB(55, 59, 72)
janelaStroke.Thickness = 1
janelaStroke.Transparency = 0.15
janelaStroke.Parent = janela

local barra = Instance.new("Frame")
barra.Name = "Barra"
barra.Size = UDim2.new(1, 0, 0, 50)
barra.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
barra.BorderSizePixel = 0
barra.Parent = janela

local barraCorner = Instance.new("UICorner")
barraCorner.CornerRadius = UDim.new(0, 14)
barraCorner.Parent = barra

local barraMask = Instance.new("Frame")
barraMask.Size = UDim2.new(1, 0, 0, 14)
barraMask.Position = UDim2.new(0, 0, 1, -14)
barraMask.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
barraMask.BorderSizePixel = 0
barraMask.Parent = barra

local titulo = Instance.new("TextLabel")
titulo.BackgroundTransparency = 1
titulo.Position = UDim2.fromOffset(18, 7)
titulo.Size = UDim2.new(1, -150, 0, 22)
titulo.Font = Enum.Font.GothamBold
titulo.Text = "HACKER TOOLS"
titulo.TextColor3 = Color3.fromRGB(245, 246, 250)
titulo.TextSize = 17
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = barra

local subtitulo = Instance.new("TextLabel")
subtitulo.BackgroundTransparency = 1
subtitulo.Position = UDim2.fromOffset(18, 28)
subtitulo.Size = UDim2.new(1, -150, 0, 16)
subtitulo.Font = Enum.Font.Gotham
subtitulo.Text = "Ferramentas do seu jogo"
subtitulo.TextColor3 = Color3.fromRGB(135, 141, 156)
subtitulo.TextSize = 10
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.Parent = barra

local minimizar = Instance.new("TextButton")
minimizar.Name = "Minimizar"
minimizar.Size = UDim2.fromOffset(34, 34)
minimizar.Position = UDim2.new(1, -78, 0, 8)
minimizar.BackgroundColor3 = Color3.fromRGB(38, 42, 53)
minimizar.BorderSizePixel = 0
minimizar.AutoButtonColor = false
minimizar.Font = Enum.Font.GothamBold
minimizar.Text = "—"
minimizar.TextColor3 = Color3.fromRGB(220, 223, 230)
minimizar.TextSize = 16
minimizar.Parent = barra

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 9)
minCorner.Parent = minimizar

local fechar = Instance.new("TextButton")
fechar.Name = "Fechar"
fechar.Size = UDim2.fromOffset(34, 34)
fechar.Position = UDim2.new(1, -40, 0, 8)
fechar.BackgroundColor3 = Color3.fromRGB(38, 42, 53)
fechar.BorderSizePixel = 0
fechar.AutoButtonColor = false
fechar.Font = Enum.Font.GothamBold
fechar.Text = "×"
fechar.TextColor3 = Color3.fromRGB(220, 223, 230)
fechar.TextSize = 20
fechar.Parent = barra

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = fechar

-- =========================================================
-- ÁREA DE ABAS
-- =========================================================

local abas = Instance.new("Frame")
abas.Name = "Abas"
abas.BackgroundTransparency = 1
abas.Position = UDim2.fromOffset(14, 58)
abas.Size = UDim2.new(1, -28, 0, 38)
abas.Parent = janela

local abaObjetos = Instance.new("TextButton")
local abaPlayer = Instance.new("TextButton")
local abaVisual = Instance.new("TextButton")
local abaConfig = Instance.new("TextButton")
local abaFun = Instance.new("TextButton")

local function configurarAba(botao, nome)
	botao.Size = UDim2.new(0.2, -4, 1, 0)
	botao.BackgroundColor3 = Color3.fromRGB(29, 33, 43)
	botao.BorderSizePixel = 0
	botao.AutoButtonColor = false
	botao.Font = Enum.Font.GothamMedium
	botao.Text = nome
	botao.TextColor3 = Color3.fromRGB(170, 175, 188)
	botao.TextSize = 11
	botao.Parent = abas

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = botao

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(51, 55, 67)
	stroke.Transparency = 0.25
	stroke.Parent = botao
end

configurarAba(abaObjetos, "OBJETOS")
configurarAba(abaPlayer, "PLAYER")
configurarAba(abaVisual, "VISUAL")
configurarAba(abaConfig, "CONFIG")
configurarAba(abaFun, "FUN")

abaObjetos.Position = UDim2.new(0, 0, 0, 0)
abaPlayer.Position = UDim2.new(0.2, 2, 0, 0)
abaVisual.Position = UDim2.new(0.4, 2, 0, 0)
abaConfig.Position = UDim2.new(0.6, 2, 0, 0)
abaFun.Position = UDim2.new(0.8, 2, 0, 0)

local conteudo = Instance.new("Frame")
conteudo.Name = "Conteudo"
conteudo.BackgroundTransparency = 1
conteudo.Position = UDim2.fromOffset(14, 104)
conteudo.Size = UDim2.new(1, -28, 1, -118)
conteudo.Parent = janela

local function criarPagina(nome)
	local pagina = Instance.new("Frame")
	pagina.Name = nome
	pagina.Size = UDim2.fromScale(1, 1)
	pagina.BackgroundTransparency = 1
	pagina.Visible = false
	pagina.Parent = conteudo
	return pagina
end

local paginaObjetos = criarPagina("Objetos")
local paginaPlayer = criarPagina("Player")
local paginaVisual = criarPagina("Visual")
local paginaConfig = criarPagina("Config")
local paginaFun = criarPagina("Fun")

local paginaAtiva = paginaObjetos

local function criarBotao(pagina, nome, texto, y)
	local botao = Instance.new("TextButton")
	botao.Name = nome
	botao.Size = UDim2.new(1, 0, 0, 44)
	botao.Position = UDim2.fromOffset(0, y)
	botao.BackgroundColor3 = Color3.fromRGB(29, 33, 43)
	botao.BorderSizePixel = 0
	botao.AutoButtonColor = false
	botao.Font = Enum.Font.GothamMedium
	botao.Text = texto
	botao.TextColor3 = Color3.fromRGB(226, 229, 236)
	botao.TextSize = 12
	botao.TextXAlignment = Enum.TextXAlignment.Left
	botao.Parent = pagina

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 15)
	padding.Parent = botao

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = botao

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(51, 55, 67)
	stroke.Thickness = 1
	stroke.Transparency = 0.25
	stroke.Parent = botao

	botao.MouseEnter:Connect(function()
		local alvo = botao:GetAttribute("Ativo") and Color3.fromRGB(48, 43, 67) or Color3.fromRGB(38, 43, 55)
		TweenService:Create(
			botao,
			TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = alvo}
		):Play()
	end)

	botao.MouseLeave:Connect(function()
		local alvo = botao:GetAttribute("Ativo") and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)
		TweenService:Create(
			botao,
			TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = alvo}
		):Play()
	end)

	return botao
end

local contador = Instance.new("TextLabel")
contador.BackgroundTransparency = 1
contador.Position = UDim2.fromOffset(4, 0)
contador.Size = UDim2.new(1, -8, 0, 22)
contador.Font = Enum.Font.GothamMedium
contador.Text = "Objetos selecionados: 0"
contador.TextColor3 = Color3.fromRGB(165, 170, 183)
contador.TextSize = 12
contador.TextXAlignment = Enum.TextXAlignment.Left
contador.Parent = paginaObjetos

-- =========================================================
-- BOTÕES
-- =========================================================

local selecionarBotao = criarBotao(paginaObjetos, "Selecionar", "◉   Selecionar objetos", 48)
local atravessarBotao = criarBotao(paginaObjetos, "Atravessar", "→   Atravessar paredes: OFF", 98)
local resetarBotao = criarBotao(paginaObjetos, "Resetar", "↺   Resetar paredes", 148)

local invisibilidadeBotao = criarBotao(paginaPlayer, "Invisibilidade", "◌   Invisibilidade: OFF", 8)
local flingBotao = criarBotao(paginaFun, "Fling", "✦   Fling: OFF", 8)

local velocidadeTitulo = Instance.new("TextLabel")
velocidadeTitulo.BackgroundTransparency = 1
velocidadeTitulo.Position = UDim2.fromOffset(4, 70)
velocidadeTitulo.Size = UDim2.new(1, -8, 0, 22)
velocidadeTitulo.Font = Enum.Font.GothamMedium
velocidadeTitulo.Text = "Velocidade: 16"
velocidadeTitulo.TextColor3 = Color3.fromRGB(226, 229, 236)
velocidadeTitulo.TextSize = 12
velocidadeTitulo.TextXAlignment = Enum.TextXAlignment.Left
velocidadeTitulo.Parent = paginaFun

local velocidadeBarra = Instance.new("Frame")
velocidadeBarra.Size = UDim2.new(1, 0, 0, 8)
velocidadeBarra.Position = UDim2.fromOffset(0, 101)
velocidadeBarra.BackgroundColor3 = Color3.fromRGB(45, 49, 61)
velocidadeBarra.BorderSizePixel = 0
velocidadeBarra.Parent = paginaFun
local velocidadeBarraCorner = Instance.new("UICorner")
velocidadeBarraCorner.CornerRadius = UDim.new(1, 0)
velocidadeBarraCorner.Parent = velocidadeBarra

local velocidadeFill = Instance.new("Frame")
velocidadeFill.Size = UDim2.new(0, 0, 1, 0)
velocidadeFill.BackgroundColor3 = Color3.fromRGB(90, 82, 150)
velocidadeFill.BorderSizePixel = 0
velocidadeFill.Parent = velocidadeBarra
local velocidadeFillCorner = Instance.new("UICorner")
velocidadeFillCorner.CornerRadius = UDim.new(1, 0)
velocidadeFillCorner.Parent = velocidadeFill

local velocidadeKnob = Instance.new("TextButton")
velocidadeKnob.Size = UDim2.fromOffset(18, 18)
velocidadeKnob.Position = UDim2.new(0, -9, 0.5, -9)
velocidadeKnob.BackgroundColor3 = Color3.fromRGB(235, 232, 255)
velocidadeKnob.BorderSizePixel = 0
velocidadeKnob.Text = ""
velocidadeKnob.AutoButtonColor = false
velocidadeKnob.Parent = velocidadeBarra
local velocidadeKnobCorner = Instance.new("UICorner")
velocidadeKnobCorner.CornerRadius = UDim.new(1, 0)
velocidadeKnobCorner.Parent = velocidadeKnob

local velocidade = 16
local velocidadeMin = 1
local velocidadeMax = 100
local arrastandoVelocidade = false

local function aplicarVelocidade(valor)
    velocidade = math.clamp(math.round(valor), velocidadeMin, velocidadeMax)
    velocidadeTitulo.Text = "Velocidade: " .. velocidade
    local percentual = (velocidade - velocidadeMin) / (velocidadeMax - velocidadeMin)
    velocidadeFill.Size = UDim2.new(percentual, 0, 1, 0)
    velocidadeKnob.Position = UDim2.new(percentual, -9, 0.5, -9)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = velocidade
    end
end

local function atualizarVelocidadePorMouse()
    local x = UserInputService:GetMouseLocation().X
    local esquerda = velocidadeBarra.AbsolutePosition.X
    local largura = velocidadeBarra.AbsoluteSize.X
    if largura > 0 then
        local percentual = math.clamp((x - esquerda) / largura, 0, 1)
        aplicarVelocidade(velocidadeMin + percentual * (velocidadeMax - velocidadeMin))
    end
end

velocidadeKnob.MouseButton1Down:Connect(function()
    arrastandoVelocidade = true
end)
velocidadeBarra.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastandoVelocidade = true
        atualizarVelocidadePorMouse()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastandoVelocidade = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if arrastandoVelocidade and input.UserInputType == Enum.UserInputType.MouseMovement then
        atualizarVelocidadePorMouse()
    end
end)

aplicarVelocidade(16)

local espBotao = criarBotao(paginaVisual, "ESP", "◎   ESP inimigos: OFF", 8)

local rgbBotao = criarBotao(paginaConfig, "RGB", "◇   RGB do seletor: ON", 8)
local resetTudoBotao = criarBotao(paginaConfig, "ResetTudo", "↺   Restaurar ferramentas", 58)

local info = Instance.new("TextLabel")
info.BackgroundTransparency = 1
info.Position = UDim2.fromOffset(4, 116)
info.Size = UDim2.new(1, -8, 0, 90)
info.Font = Enum.Font.Gotham
info.Text = "HACKER TOOLS\n\nMenu dividido por categorias para manter as ferramentas organizadas.\nA aba FUN reúne ferramentas experimentais para testes."
info.TextColor3 = Color3.fromRGB(125, 131, 145)
info.TextSize = 11
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Parent = paginaConfig

-- =========================================================
-- ABAS
-- =========================================================

local function ativarAba(pagina, botao)
	paginaAtiva.Visible = false
	pagina.Visible = true
	paginaAtiva = pagina

	for _, aba in ipairs({abaObjetos, abaPlayer, abaVisual, abaConfig, abaFun}) do
		TweenService:Create(
			aba,
			TweenInfo.new(0.12),
			{BackgroundColor3 = Color3.fromRGB(29, 33, 43)}
		):Play()
		aba.TextColor3 = Color3.fromRGB(170, 175, 188)
	end

	TweenService:Create(
		botao,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(43, 39, 61)}
	):Play()
	botao.TextColor3 = Color3.fromRGB(235, 232, 255)
end

abaObjetos.MouseButton1Click:Connect(function()
	ativarAba(paginaObjetos, abaObjetos)
end)

abaPlayer.MouseButton1Click:Connect(function()
	ativarAba(paginaPlayer, abaPlayer)
end)

abaVisual.MouseButton1Click:Connect(function()
	ativarAba(paginaVisual, abaVisual)
end)

abaConfig.MouseButton1Click:Connect(function()
	ativarAba(paginaConfig, abaConfig)
end)

abaFun.MouseButton1Click:Connect(function()
	ativarAba(paginaFun, abaFun)
end)

ativarAba(paginaObjetos, abaObjetos)

-- =========================================================
-- OBJETOS / SELEÇÃO
-- =========================================================

local function atualizarContador()
	local quantidade = 0

	for part in pairs(paredes) do
		if part and part.Parent then
			quantidade += 1
		end
	end

	contador.Text = "Objetos selecionados: " .. quantidade
end

local function criarHighlightSelecionado(part)
	if selectedHighlights[part] then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "SelectedObjectHighlight"
	highlight.Adornee = part
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = Color3.fromRGB(60, 220, 175)
	highlight.FillTransparency = 0.88
	highlight.OutlineColor = Color3.fromRGB(60, 220, 175)
	highlight.OutlineTransparency = 0
	highlight.Parent = gui

	selectedHighlights[part] = highlight
end

local function removerHighlightSelecionado(part)
	local highlight = selectedHighlights[part]

	if highlight then
		highlight:Destroy()
		selectedHighlights[part] = nil
	end
end

local function selecionarPart(part)
	if not part or not part:IsA("BasePart") then
		return
	end

	if part:IsDescendantOf(player.Character or nil) then
		return
	end

	if paredes[part] then
		if atravessar then
			part.CanCollide = paredes[part].CanCollide
		end

		paredes[part] = nil
		removerHighlightSelecionado(part)
		atualizarContador()
		return
	end

	paredes[part] = {
		CanCollide = part.CanCollide,
		Transparency = part.Transparency
	}

	if atravessar then
		part.CanCollide = false
	end

	criarHighlightSelecionado(part)
	atualizarContador()
end

local function alternarAtravessar()
	atravessar = not atravessar

	atravessarBotao.Text = atravessar
		and "→   Atravessar paredes: ON"
		or "→   Atravessar paredes: OFF"

	atravessarBotao:SetAttribute("Ativo", atravessar)

	TweenService:Create(
		atravessarBotao,
		TweenInfo.new(0.15),
		{BackgroundColor3 = atravessar and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)}
	):Play()

	for part, dados in pairs(paredes) do
		if part and part.Parent then
			if atravessar then
				part.CanCollide = false
			else
				part.CanCollide = dados.CanCollide
			end
		else
			paredes[part] = nil
			removerHighlightSelecionado(part)
		end
	end

	atualizarContador()
end

local function resetarParedes()
	for part, dados in pairs(paredes) do
		if part and part.Parent then
			part.CanCollide = dados.CanCollide
			part.Transparency = dados.Transparency
		end

		removerHighlightSelecionado(part)
	end

	table.clear(paredes)

	if atravessar then
		atravessar = false
		atravessarBotao.Text = "→   Atravessar paredes: OFF"
		atravessarBotao:SetAttribute("Ativo", false)

		TweenService:Create(
			atravessarBotao,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(29, 33, 43)}
		):Play()
	end

	atualizarContador()
end

selecionarBotao.MouseButton1Click:Connect(function()
	selecionando = not selecionando

	selecionarBotao.Text = selecionando
		and "◉   Seleção: ATIVA"
		or "◉   Selecionar objetos"

	selecionarBotao:SetAttribute("Ativo", selecionando)

	TweenService:Create(
		selecionarBotao,
		TweenInfo.new(0.15),
		{BackgroundColor3 = selecionando and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)}
	):Play()
end)

atravessarBotao.MouseButton1Click:Connect(alternarAtravessar)
resetarBotao.MouseButton1Click:Connect(resetarParedes)

-- =========================================================
-- RGB DO SELETOR
-- =========================================================

local hoverHighlight = Instance.new("Highlight")
hoverHighlight.Name = "RGBHoverHighlight"
hoverHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hoverHighlight.FillTransparency = 0.9
hoverHighlight.OutlineTransparency = 0
hoverHighlight.Enabled = false
hoverHighlight.Parent = gui

local rgbHue = 0

-- =========================================================
-- INVISIBILIDADE
-- =========================================================

local function lembrar(objeto, propriedade, valor)
	invisibilityOriginals[objeto] = invisibilityOriginals[objeto] or {}

	if invisibilityOriginals[objeto][propriedade] == nil then
		invisibilityOriginals[objeto][propriedade] = valor
	end
end

local function aplicarInvisibilidade()
	local character = player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		lembrar(humanoid, "DisplayDistanceType", humanoid.DisplayDistanceType)
		lembrar(humanoid, "HealthDisplayType", humanoid.HealthDisplayType)
		lembrar(humanoid, "NameDisplayDistance", humanoid.NameDisplayDistance)
		lembrar(humanoid, "HealthDisplayDistance", humanoid.HealthDisplayDistance)

		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		humanoid.NameDisplayDistance = 0
		humanoid.HealthDisplayDistance = 0
	end

	for _, objeto in ipairs(character:GetDescendants()) do
		if objeto:IsA("BasePart") then
			lembrar(objeto, "LocalTransparencyModifier", objeto.LocalTransparencyModifier)
			objeto.LocalTransparencyModifier = 1

		elseif objeto:IsA("Decal") or objeto:IsA("Texture") then
			lembrar(objeto, "Transparency", objeto.Transparency)
			objeto.Transparency = 1

		elseif objeto:IsA("BillboardGui") then
			lembrar(objeto, "Enabled", objeto.Enabled)
			objeto.Enabled = false

		elseif objeto:IsA("ParticleEmitter") or objeto:IsA("Trail") or objeto:IsA("Beam") then
			lembrar(objeto, "Enabled", objeto.Enabled)
			objeto.Enabled = false
		end
	end
end

local function restaurarInvisibilidade()
	for objeto, propriedades in pairs(invisibilityOriginals) do
		if objeto and objeto.Parent then
			for propriedade, valor in pairs(propriedades) do
				pcall(function()
					objeto[propriedade] = valor
				end)
			end
		end
	end

	table.clear(invisibilityOriginals)
end

local function alternarInvisibilidade()
	invisivel = not invisivel

	invisibilidadeBotao.Text = invisivel
		and "◌   Invisibilidade: ON"
		or "◌   Invisibilidade: OFF"

	invisibilidadeBotao:SetAttribute("Ativo", invisivel)

	TweenService:Create(
		invisibilidadeBotao,
		TweenInfo.new(0.15),
		{BackgroundColor3 = invisivel and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)}
	):Play()

	if invisivel then
		aplicarInvisibilidade()
	else
		restaurarInvisibilidade()
	end
end

invisibilidadeBotao.MouseButton1Click:Connect(alternarInvisibilidade)

-- =========================================================
-- FLING
-- =========================================================

local hiddenfling = false
local flingThread

local function flingLoop()
    local movel = 0.1

    while hiddenfling do
        RunService.Heartbeat:Wait()
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if hrp then
            local vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

local function desativarFling()
    hiddenfling = false
end

local function alternarFling()
    fling = not fling
    hiddenfling = fling

    flingBotao.Text = fling
        and "✦   Fling: ON"
        or "✦   Fling: OFF"

    flingBotao:SetAttribute("Ativo", fling)

    TweenService:Create(
        flingBotao,
        TweenInfo.new(0.15),
        {BackgroundColor3 = fling and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)}
    ):Play()

    if fling then
        flingThread = coroutine.create(flingLoop)
        coroutine.resume(flingThread)
    else
        desativarFling()
    end
end

flingBotao.MouseButton1Click:Connect(alternarFling)

flingCharacterConnection = player.CharacterAdded:Connect(function()
    task.wait(0.25)

    if invisivel then
        aplicarInvisibilidade()
    end

    local novoHumanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if novoHumanoid then
        novoHumanoid.WalkSpeed = velocidade
    end

    if fling then
        hiddenfling = true
        flingThread = coroutine.create(flingLoop)
        coroutine.resume(flingThread)
    end
end)

-- =========================================================
-- ESP
-- =========================================================

local function limparESP()
	for jogador, highlight in pairs(espHighlights) do
		if highlight then
			highlight:Destroy()
		end
		espHighlights[jogador] = nil
	end
end

local function ehInimigo(jogador)
	if jogador == player then
		return false
	end

	if player.Team == nil then
		return true
	end

	if jogador.Team == nil then
		return true
	end

	return jogador.Team ~= player.Team
end

local function atualizarESP()
	if not espAtivo then
		limparESP()
		return
	end

	for _, jogador in ipairs(Players:GetPlayers()) do
		if jogador ~= player and jogador.Character and ehInimigo(jogador) then
			if not espHighlights[jogador] then
				local highlight = Instance.new("Highlight")
				highlight.Name = "EnemyESP"
				highlight.Adornee = jogador.Character
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = Color3.fromRGB(235, 70, 80)
				highlight.FillTransparency = 0.78
				highlight.OutlineColor = Color3.fromRGB(255, 90, 100)
				highlight.OutlineTransparency = 0
				highlight.Parent = gui
				espHighlights[jogador] = highlight
			else
				espHighlights[jogador].Adornee = jogador.Character
			end
		elseif espHighlights[jogador] then
			espHighlights[jogador]:Destroy()
			espHighlights[jogador] = nil
		end
	end
end

local function alternarESP()
	espAtivo = not espAtivo

	espBotao.Text = espAtivo
		and "◎   ESP inimigos: ON"
		or "◎   ESP inimigos: OFF"

	espBotao:SetAttribute("Ativo", espAtivo)

	TweenService:Create(
		espBotao,
		TweenInfo.new(0.15),
		{BackgroundColor3 = espAtivo and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)}
	):Play()

	if not espAtivo then
		limparESP()
	end
end

espBotao.MouseButton1Click:Connect(alternarESP)

Players.PlayerRemoving:Connect(function(jogador)
	if espHighlights[jogador] then
		espHighlights[jogador]:Destroy()
		espHighlights[jogador] = nil
	end
end)

-- =========================================================
-- CONFIGURAÇÕES
-- =========================================================

local function alternarRGB()
	rgbAtivo = not rgbAtivo

	rgbBotao.Text = rgbAtivo
		and "◇   RGB do seletor: ON"
		or "◇   RGB do seletor: OFF"

	rgbBotao:SetAttribute("Ativo", rgbAtivo)

	TweenService:Create(
		rgbBotao,
		TweenInfo.new(0.15),
		{BackgroundColor3 = rgbAtivo and Color3.fromRGB(43, 39, 61) or Color3.fromRGB(29, 33, 43)}
	):Play()

	if not rgbAtivo then
		hoverHighlight.Enabled = false
	end
end

rgbBotao.MouseButton1Click:Connect(alternarRGB)

local function resetarTudo()
	resetarParedes()

	if invisivel then
		invisivel = false
		invisibilidadeBotao.Text = "◌   Invisibilidade: OFF"
		invisibilidadeBotao:SetAttribute("Ativo", false)
		TweenService:Create(
			invisibilidadeBotao,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(29, 33, 43)}
		):Play()
		restaurarInvisibilidade()
	end

	if fling then
		fling = false
		flingBotao.Text = "✦   Fling: OFF"
		flingBotao:SetAttribute("Ativo", false)
		TweenService:Create(
			flingBotao,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(29, 33, 43)}
		):Play()
		desativarFling()
	end

	if espAtivo then
		espAtivo = false
		espBotao.Text = "◎   ESP inimigos: OFF"
		espBotao:SetAttribute("Ativo", false)
		TweenService:Create(
			espBotao,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(29, 33, 43)}
		):Play()
		limparESP()
	end

	selecionando = false
	selecionarBotao.Text = "◉   Selecionar objetos"
	selecionarBotao:SetAttribute("Ativo", false)

	TweenService:Create(
		selecionarBotao,
		TweenInfo.new(0.15),
		{BackgroundColor3 = Color3.fromRGB(29, 33, 43)}
	):Play()
end

resetTudoBotao.MouseButton1Click:Connect(resetarTudo)

-- =========================================================
-- SELEÇÃO / HOVER
-- =========================================================

-- =========================================================
-- SELEÇÃO ROBUSTA DE PARTS / MESHES
-- =========================================================

local function obterParteSelecionavel(alvo)
	if not alvo then
		return nil
	end

	-- Se o próprio alvo já for uma BasePart, ele é selecionável.
	if alvo:IsA("BasePart") then
		if not alvo:IsDescendantOf(player.Character or nil) then
			return alvo
		end
		return nil
	end

	-- Caso o mouse retorne um objeto dentro de um Model,
	-- procura a BasePart mais próxima na hierarquia.
	local atual = alvo

	while atual and atual ~= workspace do
		if atual:IsA("BasePart") then
			if not atual:IsDescendantOf(player.Character or nil) then
				return atual
			end
			return nil
		end

		atual = atual.Parent
	end

	-- Último recurso: procura uma BasePart dentro do objeto atingido.
	if alvo:IsA("Model") or alvo:IsA("Folder") then
		for _, objeto in ipairs(alvo:GetDescendants()) do
			if objeto:IsA("BasePart") and not objeto:IsDescendantOf(player.Character or nil) then
				return objeto
			end
		end
	end

	return nil
end

local function obterAlvoDoMouse()
	local alvo = mouse.Target
	return obterParteSelecionavel(alvo)
end

local function mouseDentroDaJanela()
	local posicao = UserInputService:GetMouseLocation()
	local posicaoJanela = janela.AbsolutePosition
	local tamanhoJanela = janela.AbsoluteSize

	return posicao.X >= posicaoJanela.X
		and posicao.X <= posicaoJanela.X + tamanhoJanela.X
		and posicao.Y >= posicaoJanela.Y
		and posicao.Y <= posicaoJanela.Y + tamanhoJanela.Y
end

RunService.RenderStepped:Connect(function(deltaTime)
	rgbHue = (rgbHue + deltaTime * 0.35) % 1

	if rgbAtivo then
		hoverHighlight.OutlineColor = Color3.fromHSV(rgbHue, 1, 1)
	end

	if selecionando and rgbAtivo then
		local alvo = obterAlvoDoMouse()

		if alvo then
			hoverHighlight.Adornee = alvo
			hoverHighlight.Enabled = true
		else
			hoverHighlight.Adornee = nil
			hoverHighlight.Enabled = false
		end
	else
		hoverHighlight.Adornee = nil
		hoverHighlight.Enabled = false
	end

	if espAtivo then
		atualizarESP()
	end
end)

mouse.Button1Down:Connect(function()
	if not selecionando then
		return
	end

	if mouseDentroDaJanela() then
		return
	end

	local alvo = obterAlvoDoMouse()

	if alvo then
		selecionarPart(alvo)
	end
end)

-- =========================================================
-- ARRASTAR JANELA
-- =========================================================

local arrastando = false
local inicioMouse
local inicioPosicao

barra.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		arrastando = true
		inicioMouse = input.Position
		inicioPosicao = janela.Position
	end
end)

barra.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		arrastando = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if arrastando and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - inicioMouse

		janela.Position = UDim2.new(
			inicioPosicao.X.Scale,
			inicioPosicao.X.Offset + delta.X,
			inicioPosicao.Y.Scale,
			inicioPosicao.Y.Offset + delta.Y
		)
	end
end)

-- =========================================================
-- MINIMIZAR / FECHAR
-- =========================================================

minimizar.MouseButton1Click:Connect(function()
	minimizado = not minimizado

	if minimizado then
		abas.Visible = false
		conteudo.Visible = false

		TweenService:Create(
			janela,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(460, 50)}
		):Play()

		minimizar.Text = "+"
	else
		TweenService:Create(
			janela,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(460, 430)}
		):Play()

		task.delay(0.12, function()
			if not minimizado and janela.Parent then
				abas.Visible = true
				conteudo.Visible = true
			end
		end)

		minimizar.Text = "—"
	end
end)

fechar.MouseButton1Click:Connect(function()
	if fling then
		fling = false
		desativarFling()
	end

	limparESP()
	restaurarInvisibilidade()
	gui:Destroy()
end)

fechar.MouseEnter:Connect(function()
	TweenService:Create(
		fechar,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(150, 55, 65)}
	):Play()
end)

fechar.MouseLeave:Connect(function()
	TweenService:Create(
		fechar,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(38, 42, 53)}
	):Play()
end)

minimizar.MouseEnter:Connect(function()
	TweenService:Create(
		minimizar,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(55, 59, 72)}
	):Play()
end)

minimizar.MouseLeave:Connect(function()
	TweenService:Create(
		minimizar,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(38, 42, 53)}
	):Play()
end)
