local main = {}

constant = require('scripts/constant')
resource = require('scripts/resource')
waveInfo = require('scripts/wave')
towerValue = require('scripts/towerValue')
require('scripts/tower')
require('scripts/bullet')

function main:init()



	self.isGameOver = false

	self.rotateGauge = constant.rotateMaxGauge
	self.canRotate = true
	self.rotateGaugeImage = {render = magun.rendering.loadTexture('Resources/rotate_gauge.png')}
	self.rotateGaugeImage.size = vec2(200, 20)
	self.rotateGaugeImage.pos = vec2(470, 50)
	self.rotateGaugeImage.color = constant.color.white

	self.rotateGaugeFrameImage = {render = magun.rendering.loadTexture('Resources/rotate_gaugeFrame.png')}
	self.rotateGaugeFrameImage.size = vec2(200, 20)
	self.rotateGaugeFrameImage.pos = vec2(470, 50)
	self.rotateGaugeFrameImage.color = constant.color.white

	-- magun.debug.printAll()

	--magun.screenWidth = 1280
	--magun.screenHeight = 720
	magun.fullscreen = true
	magun.title = 'CYCLE TOWER DEFENSE'

	magun.rendering.backgroundColor = c4(177, 217, 59, 255)
	magun.log('CTD! CTD!')

	self.towers = {[0] = 0}
	for i = 0, constant.towerSlotNum - 1 do
		self.towers[i] = 0
	end


	self.mobs = {[0] = 0}

	self.bullets ={[0] = 0}

	self.towerFrame = {[0] = {}}
	self.towerFrame[0].render = magun.rendering.loadTexture('Resources/TowerFrame.png')
	self.towerFrame[0].size = vec2(self.towerFrame[0].render.width, self.towerFrame[0].render.height)
	self.towerFrame[0].pos = vec2(magun.screenWidth / 2, magun.screenHeight / 2)
	self.towerFrame[0].angle = 0

	
	self.curWave = 0 -- 현재 웨이브, 0부터 시작

	local waveInfoLength = arrayLength(waveInfo)
	self.wave = {[0] = 0}
	for i = 0, (waveInfoLength - 1) do
		self.wave[i] = {isStart = false, time = waveInfo[i].totalTime}
	end

	self.isInWave = false
	--[[self.wave[0] = {}
	self.wave[0].isStart = false
	self.wave[0].time = waveInfo.totalTime]]

	local newMob
	for wave = 0, (waveInfoLength - 1) do
		self.mobs[wave] = {[0] = 0}
		for i = 0, (arrayLength(waveInfo[wave].mobStat) - 1) do
			newMob = {}
			newMob.mobIndex = i
			newMob.maxHP = waveInfo[wave].mobStat[i].HP
			newMob.HP = waveInfo[wave].mobStat[i].HP
			newMob.speed = waveInfo[wave].mobStat[i].speed
			newMob.start = waveInfo[wave].mobStat[i].start
			newMob.effect = tableCopy(waveInfo[wave].mobStat[i].effect)
			newMob.time = waveInfo[wave].mobStat[i].time

			newMob.pos = vec2(
				self.towerFrame[0].pos.x + math.cos(newMob.start * 90 / 180 * math.pi) * (resource.TowerFrame.width / 2 + 200), 
				self.towerFrame[0].pos.y + math.sin(newMob.start * 90 / 180 * math.pi) * (resource.TowerFrame.height / 2 + 200))
			newMob.vel = vec2(
				-1 * math.cos(newMob.start * 90 / 180 * math.pi) * newMob.speed / 60, 
				-1 * math.sin(newMob.start * 90 / 180 * math.pi) * newMob.speed / 60
				)
			newMob.dir = 'forward' -- forward, clockWise, counterClockWise 존재
			newMob.angle = (newMob.start * 90 + 180) / 180 * math.pi -- 몹이 보는 각도(라디안)

			newMob.distToCenter = resource.TowerFrame.width / 2 + 200 -- 중심까지의 거리
			newMob.angleToCenter = newMob.start * 90 / 180 * math.pi -- 중심에서부터의 각도(라디안)
			newMob.state = 0 -- 0은 처음 forward, 1은 첫 clockWise, 2는 두 번째 forward, 3은 두 번째 clockWise, 4는 세 번째 forward

			newMob.effect = tableCopy(waveInfo[wave].mobStat[i].effect)

			newMob.exist = false

			newMob.texture = waveInfo[wave].mobStat[i].texture
			newMob.HPbar = {render = 0, pos = vec2(0, 0), size = vec2(0, 0)}

			insertElement(self.mobs[wave], tableCopy(newMob))
		end
	end
	--[[for i = 0, (arrayLength(waveInfo) - 1) do
		newMob = {}
		newMob.mobIndex = i
		newMob.maxHP = waveInfo[i].HP
		newMob.HP = waveInfo[i].HP
		newMob.speed = waveInfo[i].speed
		newMob.start = waveInfo[i].start
		newMob.effect = tableCopy(waveInfo[i].effect)
		newMob.time = waveInfo[i].time

		newMob.pos = vec2(
			self.towerFrame[0].pos.x + math.cos(newMob.start * 90 / 180 * math.pi) * (resource.TowerFrame.width / 2 + 200), 
			self.towerFrame[0].pos.y + math.sin(newMob.start * 90 / 180 * math.pi) * (resource.TowerFrame.height / 2 + 200))
		newMob.vel = vec2(
			-1 * math.cos(newMob.start * 90 / 180 * math.pi) * newMob.speed / 60, 
			-1 * math.sin(newMob.start * 90 / 180 * math.pi) * newMob.speed / 60
			)
		newMob.dir = 'forward' -- forward, clockWise, counterClockWise 존재
		newMob.angle = (newMob.start * 90 + 180) / 180 * math.pi -- 몹이 보는 각도(라디안)

		newMob.distToCenter = resource.TowerFrame.width / 2 + 200 -- 중심까지의 거리
		newMob.angleToCenter = newMob.start * 90 / 180 * math.pi -- 중심에서부터의 각도(라디안)
		newMob.state = 0 -- 0은 처음 forward, 1은 첫 clockWise, 2는 두 번째 forward, 3은 두 번째 clockWise, 4는 세 번째 forward

		newMob.exist = false

		newMob.texture = waveInfo[i].texture
		newMob.HPbar = {render = 0, pos = vec2(0, 0), size = vec2(0, 0)}

		insertElement(self.mobs, tableCopy(newMob))
	end]]


	--self.towerSlot = {[0] = 0}

	--self.towers = addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 1}, self.towers)
	--self.towers = addTower('MultiTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 2}, self.towers)

	--self:addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 1})
	--self:addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 2})

	self.vx = 500
	self.vy = 500

	self.camera = magun.rendering.createOrtho(0, magun.screenWidth, 0, magun.screenHeight, -1, 1)

	self.camera.x = magun.screenWidth / 2
	self.camera.y = magun.screenHeight / 2

	self.life = {render = magun.rendering.loadTexture('Resources/life.png'), size = vec2(70, 70)}

	self.route = {render = magun.rendering.loadTexture('Resources/route.png')}
	self.route.size = vec2(self.route.render.width, self.route.render.height)


	self.rotateDir = 1

	--[[
	ttest = {[0] = 2, 3, 4, 5}
	nt = tower(1, 2, 'multi', ttest)
	nt.attack()
	mt = tower(3, 4, 'single', ttest)
	mt.attack()

	ttest[0] = 57
	ttest[2] = 95
	mt.attack()

	table.remove(ttest, 2)
	mt.attack()
	]]
	self.lifeNum = constant.totalLifeNum
	local lifeT = 'Life: ' .. self.lifeNum

	self.btnFont = magun.rendering.loadFont('Arial', 30, 'bold')
	self.normalFont = magun.rendering.loadFont('Arial', 15, 'regular')

	self.leftUI = {background = 0, lifeText = 0, nextStageBtn = 0, curWave = {[0] = 0}}

	self.leftUI.background = {render = magun.rendering.loadTexture('Resources/ui_background.png')}
	self.leftUI.background.size = vec2(self.leftUI.background.render.width, self.leftUI.background.render.height)
	self.leftUI.background.pos = vec2(self.leftUI.background.render.width / 2, self.leftUI.background.render.height / 2)

	self.leftUI.waveArrow = {render = magun.rendering.loadTexture('Resources/waveArrow.png')}
	self.leftUI.waveArrow.size = vec2(self.leftUI.waveArrow.render.width, magun.screenHeight - 400)
	self.leftUI.waveArrow.pos = vec2(30, magun.screenHeight / 2)
	self.leftUI.waveArrow.color = constant.color.white


	self.leftUI.lifeText = {render = self.btnFont:createTexture(lifeT)}
	self.leftUI.lifeText.size = vec2(self.leftUI.lifeText.render.width, self.leftUI.lifeText.render.height)
	self.leftUI.lifeText.pos = vec2(175, magun.screenHeight - 50)

	local waveT = 'Wave: ' .. self.curWave .. ' / ' .. constant.totalWaveNum
	self.leftUI.waveNum = {render = self.btnFont:createTexture(waveT)}
	self.leftUI.waveNum.size = vec2(self.leftUI.waveNum.render.width, self.leftUI.waveNum.render.height)
	self.leftUI.waveNum.pos = vec2(175, magun.screenHeight - 120)
	self.leftUI.waveNum.color = constant.color.black

	self.leftUI.nextStageBtn = {render = self.btnFont:createTexture('Next Wave'), btnImage = {render = magun.rendering.loadTexture('Resources/button.png')}}
	self.leftUI.nextStageBtn.size = vec2(self.leftUI.nextStageBtn.render.width, self.leftUI.nextStageBtn.render.height)
	self.leftUI.nextStageBtn.pos = vec2(175, 50)
	self.leftUI.nextStageBtn.color = constant.color.black

	self.leftUI.nextStageBtn.btnImage.size = vec2(300, 70)
	self.leftUI.nextStageBtn.btnImage.pos = vec2(self.leftUI.nextStageBtn.pos.x, self.leftUI.nextStageBtn.pos.y)
	self.leftUI.nextStageBtn.btnImage.color = constant.color.white

	self.leftUI.rotateDirBtn = {render = magun.rendering.loadTexture('Resources/help1.png')}
	self.leftUI.rotateDirBtn.size = vec2(self.leftUI.rotateDirBtn.render.width / 4, self.leftUI.rotateDirBtn.render.height / 4)
	self.leftUI.rotateDirBtn.pos = vec2(440, magun.screenHeight - 70)
	self.leftUI.rotateDirBtn.color = constant.color.white

	self.leftUI.waveInfo = {[0] = 0}
	local mobGroupNum
	for i = 0, (waveInfoLength - 1) do
		mobGroupNum = arrayLength(waveInfo[i].info)
		self.leftUI.waveInfo[i] = {[0] = 0}
		for j = 0, (mobGroupNum - 1) do
			self.leftUI.waveInfo[i][j] = {render = self.normalFont:createTexture(waveInfo[i].info[j])}
			self.leftUI.waveInfo[i][j].size = vec2(self.leftUI.waveInfo[i][j].render.width, self.leftUI.waveInfo[i][j].render.height)
			self.leftUI.waveInfo[i][j].pos = vec2(175, magun.screenHeight - 200 * j - 250)
			self.leftUI.waveInfo[i][j].color = constant.color.black
		end
	end



	self.rightUIState = constant.rightUIState.normal
	self.curSlot = 0

	self.resource = constant.startResource
	local resourceT = 'Resource: ' .. self.resource .. '$'

	self.rightUI = {background = 0, resourceText = 0, upgradeBtn = {[0] = 0}, towerInfo = {[0] = 0}}

	self.rightUI.background = {render = magun.rendering.loadTexture('Resources/ui_background.png')}
	self.rightUI.background.size = vec2(self.rightUI.background.render.width, self.rightUI.background.render.height)
	self.rightUI.background.pos = vec2(magun.screenWidth - self.rightUI.background.render.width / 2, self.rightUI.background.render.height / 2)

	self.rightUI.resourceText = {render = self.btnFont:createTexture(resourceT)}
	self.rightUI.resourceText.size = vec2(self.rightUI.resourceText.render.width, self.rightUI.resourceText.render.height)
	self.rightUI.resourceText.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 50)



	self.rightUI.towerBuildMenu = {[0] = {}, {}}

	self.rightUI.towerBuildMenu[0].towerImage = {}
	self.rightUI.towerBuildMenu[0].towerImage.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_1.png')
	self.rightUI.towerBuildMenu[0].towerImage.size = vec2(self.rightUI.towerBuildMenu[0].towerImage.render.width * 1.5, self.rightUI.towerBuildMenu[0].towerImage.render.height * 1.5)
	self.rightUI.towerBuildMenu[0].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerBuildMenu[0].towerImage.color = constant.color.white

	self.rightUI.towerBuildMenu[0].towerExplain = {}
	self.rightUI.towerBuildMenu[0].towerExplain.render = 
		self.normalFont:createTexture('Normal Tower\ndmg: ' .. towerValue.SingleTarget.level1.damage .. ', cooldown: ' 
		.. (towerValue.SingleTarget.level1.maxCoolDown / 60) .. 's,\n range: ' .. towerValue.SingleTarget.level1.range)
	self.rightUI.towerBuildMenu[0].towerExplain.size = vec2(self.rightUI.towerBuildMenu[0].towerExplain.render.width, self.rightUI.towerBuildMenu[0].towerExplain.render.height)
	self.rightUI.towerBuildMenu[0].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 300)
	self.rightUI.towerBuildMenu[0].towerExplain.color = constant.color.black

	self.rightUI.towerBuildMenu[0].buildBtn = {}
	self.rightUI.towerBuildMenu[0].buildBtn.render = self.btnFont:createTexture('Build Tower')
	self.rightUI.towerBuildMenu[0].buildBtn.size = vec2(self.rightUI.towerBuildMenu[0].buildBtn.render.width, self.rightUI.towerBuildMenu[0].buildBtn.render.height)
	self.rightUI.towerBuildMenu[0].buildBtn.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerBuildMenu[0].buildBtn.color = constant.color.black
	self.rightUI.towerBuildMenu[0].buildBtn.image = {}
	self.rightUI.towerBuildMenu[0].buildBtn.image.render =  magun.rendering.loadTexture('Resources/button.png')
	self.rightUI.towerBuildMenu[0].buildBtn.image.size = vec2(320, 70)
	self.rightUI.towerBuildMenu[0].buildBtn.image.pos = vec2(self.rightUI.towerBuildMenu[0].buildBtn.pos.x, self.rightUI.towerBuildMenu[0].buildBtn.pos.y)
	self.rightUI.towerBuildMenu[0].buildBtn.image.color = constant.color.white


	self.rightUI.towerBuildMenu[1].towerImage = {}
	self.rightUI.towerBuildMenu[1].towerImage.render = magun.rendering.loadTexture('Resources/Tower_MultiTarget_1.png')
	self.rightUI.towerBuildMenu[1].towerImage.size = vec2(self.rightUI.towerBuildMenu[1].towerImage.render.width * 1.5, self.rightUI.towerBuildMenu[1].towerImage.render.height * 1.5)
	self.rightUI.towerBuildMenu[1].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 580)
	self.rightUI.towerBuildMenu[1].towerImage.color = constant.color.white

	self.rightUI.towerBuildMenu[1].towerExplain = {}
	self.rightUI.towerBuildMenu[1].towerExplain.render = 
		self.normalFont:createTexture('Splash Tower\ndmg: ' .. towerValue.MultiTarget.level1.damage .. ', cooldown: ' 
		.. (towerValue.MultiTarget.level1.maxCoolDown / 60) .. 's,\n range: ' .. towerValue.MultiTarget.level1.range 
		.. '\n' .. towerValue.MultiTarget.level1.splashDamage .. ' dmg of splash attack')
	self.rightUI.towerBuildMenu[1].towerExplain.size = vec2(self.rightUI.towerBuildMenu[1].towerExplain.render.width, self.rightUI.towerBuildMenu[1].towerExplain.render.height)
	self.rightUI.towerBuildMenu[1].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 720)
	self.rightUI.towerBuildMenu[1].towerExplain.color = constant.color.black

	self.rightUI.towerBuildMenu[1].buildBtn = {}
	self.rightUI.towerBuildMenu[1].buildBtn.render = self.btnFont:createTexture('Build Tower')
	self.rightUI.towerBuildMenu[1].buildBtn.size = vec2(self.rightUI.towerBuildMenu[1].buildBtn.render.width, self.rightUI.towerBuildMenu[1].buildBtn.render.height)
	self.rightUI.towerBuildMenu[1].buildBtn.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 850)
	self.rightUI.towerBuildMenu[1].buildBtn.color = constant.color.black
	self.rightUI.towerBuildMenu[1].buildBtn.image = {}
	self.rightUI.towerBuildMenu[1].buildBtn.image.render =  magun.rendering.loadTexture('Resources/button.png')
	self.rightUI.towerBuildMenu[1].buildBtn.image.size = vec2(320, 70)
	self.rightUI.towerBuildMenu[1].buildBtn.image.pos = vec2(self.rightUI.towerBuildMenu[1].buildBtn.pos.x, self.rightUI.towerBuildMenu[1].buildBtn.pos.y)
	self.rightUI.towerBuildMenu[1].buildBtn.image.color = constant.color.white



	self.rightUI.towerUpgradeMenu = {[3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {}}

	self.rightUI.towerUpgradeMenu[3].towerImage = {}
	self.rightUI.towerUpgradeMenu[3].towerImage.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_1.png')
	self.rightUI.towerUpgradeMenu[3].towerImage.size = vec2(self.rightUI.towerUpgradeMenu[3].towerImage.render.width * 1.5, self.rightUI.towerUpgradeMenu[3].towerImage.render.height * 1.5)
	self.rightUI.towerUpgradeMenu[3].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerUpgradeMenu[3].towerImage.color = constant.color.white

	self.rightUI.towerUpgradeMenu[3].towerExplain = {}
	self.rightUI.towerUpgradeMenu[3].towerExplain.render = 
		self.normalFont:createTexture('Normal Tower\n\nlevel: 1\ndmg: ' .. towerValue.SingleTarget.level1.damage .. '\ncooldown: ' 
		.. (towerValue.SingleTarget.level1.maxCoolDown / 60) .. 's\n range: ' .. towerValue.SingleTarget.level1.range .. '\ntarget number: ' .. towerValue.SingleTarget.level1.targetNum)
	self.rightUI.towerUpgradeMenu[3].towerExplain.size = vec2(self.rightUI.towerUpgradeMenu[3].towerExplain.render.width, self.rightUI.towerUpgradeMenu[3].towerExplain.render.height)
	self.rightUI.towerUpgradeMenu[3].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerUpgradeMenu[3].towerExplain.color = constant.color.black

	self.rightUI.towerUpgradeMenu[3].upgradeBtn1 = {}
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.render = self.btnFont:createTexture('Upgrade 2a\ndamage +\ncooldown +')
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.size = vec2(self.rightUI.towerUpgradeMenu[3].upgradeBtn1.render.width, self.rightUI.towerUpgradeMenu[3].upgradeBtn1.render.height)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 650)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.color = constant.color.black
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image = {}
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image.render =  magun.rendering.loadTexture('Resources/button.png')
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image.size = vec2(320, 180)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image.pos = vec2(self.rightUI.towerUpgradeMenu[3].upgradeBtn1.pos.x, self.rightUI.towerUpgradeMenu[3].upgradeBtn1.pos.y)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image.color = constant.color.white

	self.rightUI.towerUpgradeMenu[3].upgradeBtn2 = {}
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.render = self.btnFont:createTexture('Upgrade 2b\ncooldown -')
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.size = vec2(self.rightUI.towerUpgradeMenu[3].upgradeBtn2.render.width, self.rightUI.towerUpgradeMenu[3].upgradeBtn2.render.height)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 900)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.color = constant.color.black
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image = {}
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image.render =  magun.rendering.loadTexture('Resources/button.png')
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image.size = vec2(320, 180)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image.pos = vec2(self.rightUI.towerUpgradeMenu[3].upgradeBtn2.pos.x, self.rightUI.towerUpgradeMenu[3].upgradeBtn2.pos.y)
	self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image.color = constant.color.white


	self.rightUI.towerUpgradeMenu[4].towerImage = {}
	self.rightUI.towerUpgradeMenu[4].towerImage.render = magun.rendering.loadTexture('Resources/Tower_MultiTarget_1.png')
	self.rightUI.towerUpgradeMenu[4].towerImage.size = vec2(self.rightUI.towerUpgradeMenu[3].towerImage.render.width * 1.5, self.rightUI.towerUpgradeMenu[3].towerImage.render.height * 1.5)
	self.rightUI.towerUpgradeMenu[4].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerUpgradeMenu[4].towerImage.color = constant.color.white

	self.rightUI.towerUpgradeMenu[4].towerExplain = {}
	self.rightUI.towerUpgradeMenu[4].towerExplain.render = 
		self.normalFont:createTexture('Splash Tower\n\nlevel: 1\ndmg: ' .. towerValue.MultiTarget.level1.damage .. '\ncooldown: ' 
		.. (towerValue.MultiTarget.level1.maxCoolDown / 60) .. 's\n range: ' .. towerValue.MultiTarget.level1.range .. '\ntarget number: ' .. towerValue.MultiTarget.level1.targetNum 
		.. '\nsplash damage: ' .. towerValue.MultiTarget.level1.splashDamage .. '\nsplash range: ' .. towerValue.MultiTarget.level1.splashRange)
	self.rightUI.towerUpgradeMenu[4].towerExplain.size = vec2(self.rightUI.towerUpgradeMenu[4].towerExplain.render.width, self.rightUI.towerUpgradeMenu[4].towerExplain.render.height)
	self.rightUI.towerUpgradeMenu[4].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerUpgradeMenu[4].towerExplain.color = constant.color.black

	self.rightUI.towerUpgradeMenu[4].upgradeBtn1 = {}
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.render = self.btnFont:createTexture('Upgrade 2a\ndamage +')
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.size = vec2(self.rightUI.towerUpgradeMenu[4].upgradeBtn1.render.width, self.rightUI.towerUpgradeMenu[4].upgradeBtn1.render.height)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 650)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.color = constant.color.black
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image = {}
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image.render =  magun.rendering.loadTexture('Resources/button.png')
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image.size = vec2(320, 180)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image.pos = vec2(self.rightUI.towerUpgradeMenu[4].upgradeBtn1.pos.x, self.rightUI.towerUpgradeMenu[4].upgradeBtn1.pos.y)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image.color = constant.color.white

	self.rightUI.towerUpgradeMenu[4].upgradeBtn2 = {}
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.render = self.btnFont:createTexture('Upgrade 2b\nsplash +\nrange +')
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.size = vec2(self.rightUI.towerUpgradeMenu[4].upgradeBtn2.render.width, self.rightUI.towerUpgradeMenu[4].upgradeBtn2.render.height)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 900)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.color = constant.color.black
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image = {}
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image.render =  magun.rendering.loadTexture('Resources/button.png')
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image.size = vec2(320, 180)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image.pos = vec2(self.rightUI.towerUpgradeMenu[4].upgradeBtn2.pos.x, self.rightUI.towerUpgradeMenu[4].upgradeBtn2.pos.y)
	self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image.color = constant.color.white


	self.rightUI.towerUpgradeMenu[5].towerImage = {}
	self.rightUI.towerUpgradeMenu[5].towerImage.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_2.png')
	self.rightUI.towerUpgradeMenu[5].towerImage.size = vec2(self.rightUI.towerUpgradeMenu[5].towerImage.render.width * 1.5, self.rightUI.towerUpgradeMenu[5].towerImage.render.height * 1.5)
	self.rightUI.towerUpgradeMenu[5].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerUpgradeMenu[5].towerImage.color = constant.color.white

	self.rightUI.towerUpgradeMenu[5].towerExplain = {}
	self.rightUI.towerUpgradeMenu[5].towerExplain.render = 
		self.normalFont:createTexture('Normal Tower\n\nlevel: 2a\ndmg: ' .. towerValue.SingleTarget.level2a.damage .. '\ncooldown: ' 
		.. (towerValue.SingleTarget.level2a.maxCoolDown / 60) .. 's\n range: ' .. towerValue.SingleTarget.level2a.range .. '\ntarget number: ' .. towerValue.SingleTarget.level2a.targetNum)
	self.rightUI.towerUpgradeMenu[5].towerExplain.size = vec2(self.rightUI.towerUpgradeMenu[5].towerExplain.render.width, self.rightUI.towerUpgradeMenu[5].towerExplain.render.height)
	self.rightUI.towerUpgradeMenu[5].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerUpgradeMenu[5].towerExplain.color = constant.color.black


	self.rightUI.towerUpgradeMenu[6].towerImage = {}
	self.rightUI.towerUpgradeMenu[6].towerImage.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_2.png')
	self.rightUI.towerUpgradeMenu[6].towerImage.size = vec2(self.rightUI.towerUpgradeMenu[6].towerImage.render.width * 1.5, self.rightUI.towerUpgradeMenu[6].towerImage.render.height * 1.5)
	self.rightUI.towerUpgradeMenu[6].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerUpgradeMenu[6].towerImage.color = constant.color.white

	self.rightUI.towerUpgradeMenu[6].towerExplain = {}
	self.rightUI.towerUpgradeMenu[6].towerExplain.render = 
		self.normalFont:createTexture('Normal Tower\n\nlevel: 2b\ndmg: ' .. towerValue.SingleTarget.level2b.damage .. '\ncooldown: ' 
		.. (towerValue.SingleTarget.level2b.maxCoolDown / 60) .. 's\n range: ' .. towerValue.SingleTarget.level2b.range .. '\ntarget number: ' .. towerValue.SingleTarget.level2b.targetNum)
	self.rightUI.towerUpgradeMenu[6].towerExplain.size = vec2(self.rightUI.towerUpgradeMenu[6].towerExplain.render.width, self.rightUI.towerUpgradeMenu[6].towerExplain.render.height)
	self.rightUI.towerUpgradeMenu[6].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerUpgradeMenu[6].towerExplain.color = constant.color.black


	self.rightUI.towerUpgradeMenu[7].towerImage = {}
	self.rightUI.towerUpgradeMenu[7].towerImage.render = magun.rendering.loadTexture('Resources/Tower_MultiTarget_1.png')
	self.rightUI.towerUpgradeMenu[7].towerImage.size = vec2(self.rightUI.towerUpgradeMenu[7].towerImage.render.width * 1.5, self.rightUI.towerUpgradeMenu[7].towerImage.render.height * 1.5)
	self.rightUI.towerUpgradeMenu[7].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerUpgradeMenu[7].towerImage.color = constant.color.white

	self.rightUI.towerUpgradeMenu[7].towerExplain = {}
	self.rightUI.towerUpgradeMenu[7].towerExplain.render = 
		self.normalFont:createTexture('Splash Tower\n\nlevel: 2a\ndmg: ' .. towerValue.MultiTarget.level2a.damage .. '\ncooldown: ' 
		.. (towerValue.MultiTarget.level2a.maxCoolDown / 60) .. 's\n range: ' .. towerValue.MultiTarget.level2a.range .. '\ntarget number: ' .. towerValue.MultiTarget.level2a.targetNum 
		.. '\nsplash damage: ' .. towerValue.MultiTarget.level2a.splashDamage .. '\nsplash range: ' .. towerValue.MultiTarget.level2a.splashRange)
	self.rightUI.towerUpgradeMenu[7].towerExplain.size = vec2(self.rightUI.towerUpgradeMenu[7].towerExplain.render.width, self.rightUI.towerUpgradeMenu[7].towerExplain.render.height)
	self.rightUI.towerUpgradeMenu[7].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerUpgradeMenu[7].towerExplain.color = constant.color.black


	self.rightUI.towerUpgradeMenu[8].towerImage = {}
	self.rightUI.towerUpgradeMenu[8].towerImage.render = magun.rendering.loadTexture('Resources/Tower_MultiTarget_1.png')
	self.rightUI.towerUpgradeMenu[8].towerImage.size = vec2(self.rightUI.towerUpgradeMenu[8].towerImage.render.width * 1.5, self.rightUI.towerUpgradeMenu[8].towerImage.render.height * 1.5)
	self.rightUI.towerUpgradeMenu[8].towerImage.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 180)
	self.rightUI.towerUpgradeMenu[8].towerImage.color = constant.color.white

	self.rightUI.towerUpgradeMenu[8].towerExplain = {}
	self.rightUI.towerUpgradeMenu[8].towerExplain.render = 
		self.normalFont:createTexture('Splash Tower\n\nlevel: 2b\ndmg: ' .. towerValue.MultiTarget.level2b.damage .. '\ncooldown: ' 
		.. (towerValue.MultiTarget.level2b.maxCoolDown / 60) .. 's\n range: ' .. towerValue.MultiTarget.level2b.range .. '\ntarget number: ' .. towerValue.MultiTarget.level2b.targetNum 
		.. '\nsplash damage: ' .. towerValue.MultiTarget.level2b.splashDamage .. '\nsplash range: ' .. towerValue.MultiTarget.level2b.splashRange)
	self.rightUI.towerUpgradeMenu[8].towerExplain.size = vec2(self.rightUI.towerUpgradeMenu[8].towerExplain.render.width, self.rightUI.towerUpgradeMenu[8].towerExplain.render.height)
	self.rightUI.towerUpgradeMenu[8].towerExplain.pos = vec2(magun.screenWidth - 175, magun.screenHeight - 400)
	self.rightUI.towerUpgradeMenu[8].towerExplain.color = constant.color.black



	self.leftUICamera = magun.rendering.createOrtho(0, magun.screenWidth, 0, magun.screenHeight, -1, 1)

	self.leftUICamera.x = magun.screenWidth / 2
	self.leftUICamera.y = magun.screenHeight / 2

	self.rightUICamera = magun.rendering.createOrtho(0, magun.screenWidth, 0, magun.screenHeight, -1, 1)

	self.rightUICamera.x = magun.screenWidth / 2
	self.rightUICamera.y = magun.screenHeight / 2
	


end

--towerAddQ = true
--towerAddE = true
function main:update(dt) 
	if self.isGameOver then
		return
	end

	if self.rotateGauge <= 0 then
		self.canRotate = false
	end
	if not self.canRotate and self.rotateGauge == constant.rotateMaxGauge then
		self.canRotate = true
	end
	if self.rotateGauge < constant.rotateMaxGauge then
		self.rotateGauge = self.rotateGauge + 1
	end
	self.rotateGaugeImage.size.x = self.rotateGaugeFrameImage.size.x * (self.rotateGauge / constant.rotateMaxGauge)
	self.rotateGaugeImage.pos.x = self.rotateGaugeFrameImage.pos.x - (self.rotateGaugeFrameImage.size.x - self.rotateGaugeFrameImage.size.x * (self.rotateGauge / constant.rotateMaxGauge)) / 2

	--[[if magun.keyboard.down.q and towerAddQ then
		self.towers = addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 3}, self.towers)
		towerAddQ = false
	elseif magun.keyboard.down.q and not towerAddQ then
		self.towers = removeTower(3, self.towers)
		towerAddQ = true
	end

	if magun.keyboard.down.e and towerAddE then
		self.towers = addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 0}, self.towers)
		towerAddE = false
	elseif magun.keyboard.down.e and not towerAddE then
		self.towers = removeTower(0, self.towers)
		towerAddE = true
	end]]


	self:waveManager()

	self:towerFrameManager()

	self:towerManager()

	self:mobManager()

	self:bulletManager()

	self:mouseManager()

	if magun.keyboard.press.escape then
		self:dispose()
		os.exit()
	end
end

function main:render(dt) 
	self.camera:start()
	self.leftUICamera:start()
	self.rightUICamera:start()

	
	self.camera:renderSprite(self.rotateGaugeImage.render, 
		vec3(
			self.rotateGaugeImage.pos.x,
			self.rotateGaugeImage.pos.y, 
			constant.layer.route), 
		self.rotateGaugeImage.size, 
		0, 
		self.rotateGaugeImage.color)
	self.camera:renderSprite(self.rotateGaugeFrameImage.render, 
		vec3(
			self.rotateGaugeFrameImage.pos.x,
			self.rotateGaugeFrameImage.pos.y, 
			constant.layer.route), 
		self.rotateGaugeFrameImage.size, 
		0, 
		self.rotateGaugeFrameImage.color)


	self:renderTower()

	self:renderTowerFrame()

	self:renderBullet()

	self:renderMob()

	self.camera:renderSprite(self.route.render, 
		vec3(
			magun.screenWidth / 2,
			magun.screenHeight / 2, 
			constant.layer.route), 
		self.route.size, 
		0, 
		constant.color.white)

	self.camera:renderSprite(self.life.render, 
		vec3(
			magun.screenWidth / 2,
			magun.screenHeight / 2, 
			constant.layer.towerFrame), 
		self.life.size, 
		0, 
		constant.color.white)

	--self.camera:renderSprite(self.)
	

	self:renderLeftUI()

	self:renderRightUI()

	

	self.camera:flush()
	self.leftUICamera:flush()
	self.rightUICamera:flush()

	

	

	
end

function main:dispose()
	local towerAryIndex = existTowerSlot(self.towers)
	for index, i in ipairs(towerAryIndex) do
		self.towers[i].render:dispose()
		self.towers[i].rangeRender:dispose()
	end
	self.camera:dispose()
end

-----------------------------------------------------------------------

--update에서 tower들의 동작 실행
function main:towerManager()
	local towerAryIndex = existTowerSlot(self.towers)
	if arrayLength(towerAryIndex) == 0 then
		return
	end
	for index, i in ipairs(towerAryIndex) do
		self.towers[i].pos.x = self.towers[i].frame.pos.x + math.cos(self.towers[i].frame.angle + self.towers[i].slot * 90 / 180 * math.pi) * (resource.TowerFrame.width / 2 - 75)
		self.towers[i].pos.y = self.towers[i].frame.pos.y + math.sin(self.towers[i].frame.angle + self.towers[i].slot * 90 / 180 * math.pi) * (resource.TowerFrame.height / 2 - 75)
		--쿨타임 감소
		if self.towers[i].coolDown > 0 then
			self.towers[i].coolDown = self.towers[i].coolDown - 1
		end
		--타워 공격
		if self.towers[i].attackTarget ~= nil then
			self.towers, self.bullets = attackTarget(i, self.towers, self.bullets)
		end
		--공격대상 감지
		if self.towers[i].attackTarget == nil then
			self.towers = searchTarget(i, self.towers, self.mobs[self.curWave])
		end
	end
	if magun.mouse.press.left then
		for index, i in ipairs(towerAryIndex) do
			--self.towers[i].angle = math.atan2(magun.mouse.y - self.towers[i].pos.y, magun.mouse.x - self.towers[i].pos.x)
		end
		--self.bullets.x = magun.mouse.x
		--self.bullets.y = magun.mouse.y
	end
end

--[[
--towers 내 특정 index의 타워가 공격 가능 타겟이 여전히 범위 안에 있는지 감지하고 공격
function main:attackTarget(towerIndex)
	if self.towers[towerIndex].towerType == 'SingleTarget' then
		if vec2Distance(self.towers[towerIndex].pos, self.towers[towerIndex].attackTarget.pos) > self.towers[towerIndex].range then
			self.towers[towerIndex].attackTarget = nil
		else
			local curTarget = self.towers[towerIndex].attackTarget
			self.towers[towerIndex].angle = math.atan2(curTarget.pos.y - self.towers[towerIndex].pos.y, curTarget.pos.x - self.towers[towerIndex].pos.x)
			if self.towers[towerIndex].coolDown == 0 then
				self:shootBullet(towerIndex)
				self.towers[towerIndex].coolDown = self.towers[towerIndex].maxCoolDown
			end
		end
	elseif self.towers[towerIndex].towerType == 'MultiTarget' then
		magun.log('MultiTarget')
	end
	
end

--towers 내 특정 index의 타워가 공격 가능 타겟이 있는지 감지
function main:searchTarget(towerIndex)
	local towerAryIndex = existTowerSlot(self.towers)
	local mobAryLength = arrayLength(self.mobs)
	local closeMobAry = {[0] = 0}
	local newDistance
	for i = (mobAryLength - 1), 0, -1 do
		newDistance = vec2Distance(self.towers[towerIndex].pos, self.mobs[i].pos)
		if newDistance <= self.towers[towerIndex].range and self.mobs[i].exist == true then
			insertElement(closeMobAry, {index = i, distance = newDistance})
		end
	end
	if closeMobAry[0] == 0 then
		return
	end
	closeMobAry = sortByDistance(closeMobAry)
	if self.towers[towerIndex].towerType == 'SingleTarget' then
		self.towers[towerIndex].attackTarget = self.mobs[closeMobAry[0].index]
	elseif self.towers[towerIndex].towerType == 'MultiTarget' then
		magun.log('MultiTarget Attack')
	end
end
]]

--render에서 tower들의 렌더링
function main:renderTower()
	local towerAryIndex = existTowerSlot(self.towers)
	if arrayLength(towerAryIndex) == 0 then
		return
	end
	local rangeColor
	for index, i in ipairs(towerAryIndex) do
		self.camera:renderSprite(self.towers[i].render, 
			vec3(
				self.towers[i].pos.x + self.towers[i].textureCenterDiff * math.cos(self.towers[i].angle),
				self.towers[i].pos.y + self.towers[i].textureCenterDiff * math.sin(self.towers[i].angle), 
				constant.layer.tower), 
			self.towers[i].size, 
			self.towers[i].angle, 
			self.towers[i].color)

		if self.towers[i].attackTarget == nil then
			rangeColor = constant.color.white_alpha
		else
			rangeColor = constant.color.red_alpha
		end

		self.camera:renderSprite(self.towers[i].rangeRender, 
			vec3(
				self.towers[i].pos.x,
				self.towers[i].pos.y, 
				constant.layer.range), 
			self.towers[i].rangeSize, 
			0, 
			rangeColor)
		
	end
end

--towerType을 받아 타워 생성 후 tower 테이블에 넣음 towerPos는 vec2, frameInfo = {frame = , slot = } 의 형태
--[[function main:addTower(newTowerType, towerPos, frameInfo)
	local newTower = {towerType = newTowerType, pos = towerPos, frame = frameInfo.frame, slot = frameInfo.slot, level = '1', angle = 0, coolDown = 0}
	if newTowerType == 'SingleTarget' then
		newTower.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_1.png')
		newTower.size = vec2(newTower.render.width, newTower.render.height)
		newTower.maxCoolDown = 60

		newTower.attackTarget = nil
		newTower.targetNum = 1
		newTower.damage = 3

		newTower.range = 200
		newTower.rangeRender = magun.rendering.loadTexture('Resources/range.png')
		newTower.rangeSize = vec2(
								newTower.rangeRender.width * newTower.range * 2 / resource.range.width, 
								newTower.rangeRender.height * newTower.range * 2 / resource.range.height)

		newTower.effect = {[0] = 0}

		newTower.textureCenterDiff = 13
	elseif newTowerType == 'MultiTarget' then
		--newTower.render = 
		newTower.effect = {[0] = 0}
	end
	insertElement(self.towers, newTower)
end
]]
--타워 제거 후 tower 테이블에서 뺌
--[[function main:removeTower(towerIndex)
	self.towers[towerIndex].render:dispose()
	self.towers[towerIndex].rangeRender:dispose()
	removeElement(self.towers, towerIndex)
end]]

--update에서 tower frame의 동작 실행
function main:towerFrameManager()
	local rotateVel = math.pi / 180 * constant.rotateVelocity --회전속도
	if magun.keyboard.press.a and self.canRotate then
		self.towerFrame[0].angle = self.towerFrame[0].angle + rotateVel * self.rotateDir
		self.rotateGauge = self.rotateGauge - 3
	elseif magun.keyboard.press.d and self.canRotate then
		self.towerFrame[0].angle = self.towerFrame[0].angle - rotateVel * self.rotateDir
		self.rotateGauge = self.rotateGauge - 3
	end
end

--render에서 tower frame들의 렌더링
function main:renderTowerFrame()
	local frameAryLength = arrayLength(self.towerFrame)
	if frameAryLength == 0 then
		return
	end
	for i = 0, (frameAryLength - 1) do
		local color
		if self.canRotate then
			color = constant.color.white_alpha
		else
			color = constant.color.red_alpha
		end
		self.camera:renderSprite(self.towerFrame[i].render, 
			vec3(
				self.towerFrame[i].pos.x,
				self.towerFrame[i].pos.y, 
				constant.layer.towerFrame), 
			self.towerFrame[i].size, 
			self.towerFrame[i].angle, 
			color)
	end
end

--update에서 wave 동작 실행
function main:waveManager()
	if self.wave[self.curWave].isStart == false then
		return
	end
	if self.wave[self.curWave].time > 0 then
		self.wave[self.curWave].time = self.wave[self.curWave].time - 1
		local mobAryLength = arrayLength(self.mobs[self.curWave])
		for i = 0, (mobAryLength - 1) do
			if self.mobs[self.curWave][i].time == self.wave[self.curWave].time then
				self.mobs[self.curWave][i].render = magun.rendering.loadTexture(self.mobs[self.curWave][i].texture)
				self.mobs[self.curWave][i].size = --[[vec2(self.mobs[self.curWave][i].render.width / 2, self.mobs[self.curWave][i].render.height / 2)]] vec2(50, 50)
				self.mobs[self.curWave][i].exist = true

				self.mobs[self.curWave][i].HPbar.render = magun.rendering.loadTexture('Resources/HPbar.png')
				self.mobs[self.curWave][i].HPbar.size = vec2(self.mobs[self.curWave][i].HPbar.render.width, self.mobs[self.curWave][i].HPbar.render.height)
			end
		end
	elseif self.wave[self.curWave].time == 0 then
		self.wave[self.curWave].time = -1
	end
	--magun.log('mobs remain' .. arrayLength(self.mobs[self.curWave]))
	if arrayLength(self.mobs[self.curWave]) == 0 then
		self.leftUI.nextStageBtn.btnImage.color = constant.color.white
		self.leftUI.nextStageBtn.color = constant.color.black
		self.isInWave = false
		self.curWave = self.curWave + 1
		if self.curWave % 2 == 0 then
			self.resource = self.resource + constant.resourcePerStage
		end
		local resourceT = 'Resource: ' .. self.resource .. '$'
		setText(self.rightUI.resourceText, resourceT, self.btnFont)
	end
end

--update에서 mob들의 동작 실행
function main:mobManager()
	local mobAryLength = arrayLength(self.mobs[self.curWave])
	local centerPos = self.towerFrame[0].pos
	for i = (mobAryLength - 1), 0, -1 do
		if self.mobs[self.curWave][i].exist then
			self.mobs[self.curWave][i].HPbar.size.x = resource.HPbar.width * (self.mobs[self.curWave][i].HP / self.mobs[self.curWave][i].maxHP)
			self.mobs[self.curWave][i].HPbar.pos.x = self.mobs[self.curWave][i].pos.x - (resource.HPbar.width / 2 - self.mobs[self.curWave][i].HPbar.size.x / 2)
			self.mobs[self.curWave][i].HPbar.pos.y = self.mobs[self.curWave][i].pos.y + 20
			if self.mobs[self.curWave][i].dir == 'forward' then
				--self.mobs[i].angle = math.atan2(centerPos.y - self.mobs[i].pos.y, centerPos.x - self.mobs[i].pos.x)
				self.mobs[self.curWave][i].pos.x = self.mobs[self.curWave][i].pos.x + self.mobs[self.curWave][i].vel.x
				self.mobs[self.curWave][i].pos.y = self.mobs[self.curWave][i].pos.y + self.mobs[self.curWave][i].vel.y
				self.mobs[self.curWave][i].distToCenter = self.mobs[self.curWave][i].distToCenter - self.mobs[self.curWave][i].speed / 60
				

				if self.mobs[self.curWave][i].state == 0 and vec2Distance(self.mobs[self.curWave][i].pos, centerPos) <= 450 then
					self.mobs[self.curWave][i].state = 1
					self.mobs[self.curWave][i].dir = 'clockWise'
					self.mobs[self.curWave][i].distToCenter = 450
					self.mobs[self.curWave][i].pos.x = centerPos.x + math.cos(self.mobs[self.curWave][i].angleToCenter) * 450
					self.mobs[self.curWave][i].pos.y = centerPos.y + math.sin(self.mobs[self.curWave][i].angleToCenter) * 450
				elseif self.mobs[self.curWave][i].state == 2 and vec2Distance(self.mobs[self.curWave][i].pos, centerPos) <= 225 then
					self.mobs[self.curWave][i].state = 3
					self.mobs[self.curWave][i].dir = 'clockWise'
					self.mobs[self.curWave][i].distToCenter = 225
					self.mobs[self.curWave][i].pos.x = centerPos.x + math.cos(self.mobs[self.curWave][i].angleToCenter) * 225
					self.mobs[self.curWave][i].pos.y = centerPos.y + math.sin(self.mobs[self.curWave][i].angleToCenter) * 225
				elseif self.mobs[self.curWave][i].state == 4 and vec2Distance(self.mobs[self.curWave][i].pos, centerPos) <= (self.mobs[self.curWave][i].speed / 60) then
					--magun.log('life -1')
					self.lifeNum = self.lifeNum - 1
					if self.mobs[self.curWave][i].effect[0] == 'life -2' then
						self.lifeNum = self.lifeNum - 1
					elseif self.mobs[self.curWave][i].effect[0] == 'life -3' then
						self.lifeNum = self.lifeNum - 2
					elseif self.mobs[self.curWave][i].effect[0] == 'life -4' then
						self.lifeNum = self.lifeNum - 3
					elseif self.mobs[self.curWave][i].effect[0] == 'life -5' then
						self.lifeNum = self.lifeNum - 4
					end
					local lifeT = 'Life: ' .. self.lifeNum
					setText(self.leftUI.lifeText, lifeT, self.btnFont)
					if self.lifeNum <= 0 then
						--self.isGameOver = true
						--return
						setText(self.leftUI.lifeText, 'Game Over', self.btnFont)
					end
					
					local towerAryIndex = existTowerSlot(self.towers)
					for index, j in ipairs(towerAryIndex) do
						if self.towers[j].attackTarget ~= nil and self.towers[j].attackTarget.mobIndex == self.mobs[self.curWave][i].mobIndex then
							self.towers[j].attackTarget = nil
						end
					end

					local bulletAryLength = arrayLength(self.bullets)
					for j = 0, (bulletAryLength - 1) do
						if self.bullets[j].target.mobIndex == self.mobs[self.curWave][i].mobIndex then
							self.bullets[j].target = {mobIndex = self.bullets[j].target.mobIndex, pos = vec2(self.bullets[j].target.pos.x, self.bullets[j].target.pos.y) , state = 'removed'}
						end
					end
					local index = getMobIndex(self.mobs[self.curWave], self.mobs[self.curWave][i].mobIndex)
					self.mobs[self.curWave][index].render:dispose()
					self.mobs[self.curWave][index].HPbar.render:dispose()
					self.mobs[self.curWave][index].exist = false
					removeElement(self.mobs[self.curWave], index)
				end
			elseif self.mobs[self.curWave][i].dir == 'clockWise' then
				local angleVel = self.mobs[self.curWave][i].speed / (60 * self.mobs[self.curWave][i].distToCenter) * 1.2
				
				--[[self.mobs[i].vel = vec2(
					-1 * (math.cos(self.mobs[i].angleToCenter) - math.cos(self.mobs[i].angleToCenter - angleVel)) * self.mobs[i].distToCenter, 
					-1 * (math.sin(self.mobs[i].angleToCenter) - math.sin(self.mobs[i].angleToCenter - angleVel)) * self.mobs[i].distToCenter
					)
				self.mobs[i].pos.x = self.mobs[i].pos.x + self.mobs[i].vel.x
				self.mobs[i].pos.y = self.mobs[i].pos.y + self.mobs[i].vel.y]]

				self.mobs[self.curWave][i].angleToCenter = self.mobs[self.curWave][i].angleToCenter - angleVel
				self.mobs[self.curWave][i].pos.x = centerPos.x + math.cos(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].distToCenter
				self.mobs[self.curWave][i].pos.y = centerPos.y + math.sin(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].distToCenter
				self.mobs[self.curWave][i].angle = math.atan2(centerPos.y - self.mobs[self.curWave][i].pos.y, centerPos.x - self.mobs[self.curWave][i].pos.x) + 90 / 180 * math.pi

				if self.mobs[self.curWave][i].state == 1 and (self.mobs[self.curWave][i].start * 90 - self.mobs[self.curWave][i].angleToCenter / math.pi * 180) >= 30 then
					self.mobs[self.curWave][i].state = 2
					self.mobs[self.curWave][i].dir = 'forward'
					self.mobs[self.curWave][i].angleToCenter = (self.mobs[self.curWave][i].start * 90 - 30) / 180 * math.pi
					self.mobs[self.curWave][i].pos.x = centerPos.x + math.cos(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].distToCenter
					self.mobs[self.curWave][i].pos.y = centerPos.y + math.sin(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].distToCenter
					self.mobs[self.curWave][i].angle = math.atan2(centerPos.y - self.mobs[self.curWave][i].pos.y, centerPos.x - self.mobs[self.curWave][i].pos.x)
					self.mobs[self.curWave][i].vel = vec2(
						-1 * math.cos(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].speed / 60, 
						-1 * math.sin(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].speed / 60
						)
				elseif self.mobs[self.curWave][i].state == 3 and (self.mobs[self.curWave][i].start * 90 - 30 - self.mobs[self.curWave][i].angleToCenter / math.pi * 180) >= 40 then
					self.mobs[self.curWave][i].state = 4
					self.mobs[self.curWave][i].dir = 'forward'
					self.mobs[self.curWave][i].angleToCenter = (self.mobs[self.curWave][i].start * 90 - 70) / 180 * math.pi
					self.mobs[self.curWave][i].pos.x = centerPos.x + math.cos(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].distToCenter
					self.mobs[self.curWave][i].pos.y = centerPos.y + math.sin(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].distToCenter
					self.mobs[self.curWave][i].angle = math.atan2(centerPos.y - self.mobs[self.curWave][i].pos.y, centerPos.x - self.mobs[self.curWave][i].pos.x)
					self.mobs[self.curWave][i].vel = vec2(
						-1 * math.cos(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].speed / 60, 
						-1 * math.sin(self.mobs[self.curWave][i].angleToCenter) * self.mobs[self.curWave][i].speed / 60
						)
				end
			elseif self.mobs[self.curWave][i].dir == 'counterClockWise' then
				magun.log('counterClockWise')
				--아직은 반시계방향 움직이는 것이 없음
			end
			--[[self.mobs[self.curWave][i].HPbar.size.x = resource.HPbar.width * (self.mobs[self.curWave][i].HP / self.mobs[self.curWave][i].maxHP)
			self.mobs[self.curWave][i].HPbar.pos.x = self.mobs[self.curWave][i].pos.x - (resource.HPbar.width / 2 - self.mobs[self.curWave][i].HPbar.size.x / 2)
			self.mobs[self.curWave][i].HPbar.pos.y = self.mobs[self.curWave][i].pos.y + 20]]

		end
		--[[if self.mobs[i].exist then
			self.mobs[i].pos.x = self.mobs[i].pos.x + self.mobs[i].vel.x
			self.mobs[i].pos.y = self.mobs[i].pos.y + self.mobs[i].vel.y
		end]]
		--self.mobs[i].pos = vec2(magun.mouse.x, magun.mouse.y)
	end
end

--render에서 mob들의 렌더링
function main:renderMob()
	local mobAryLength = arrayLength(self.mobs[self.curWave])
	if mobAryLength == 0 then
		return
	end
	for i = (mobAryLength - 1), 0, -1 do
		if self.mobs[self.curWave][i].exist == true then
			self.camera:renderSprite(self.mobs[self.curWave][i].render, 
			vec3(
				self.mobs[self.curWave][i].pos.x,
				self.mobs[self.curWave][i].pos.y, 
				constant.layer.mob), 
			self.mobs[self.curWave][i].size, 
			self.mobs[self.curWave][i].angle, 
			constant.color.white)
			self.camera:renderSprite(self.mobs[self.curWave][i].HPbar.render, 
			vec3(
				self.mobs[self.curWave][i].HPbar.pos.x,
				self.mobs[self.curWave][i].HPbar.pos.y, 
				constant.layer.mobHP), 
			self.mobs[self.curWave][i].HPbar.size, 
			0, 
			constant.color.white)
		end
	end
end

--update에서 bullet들의 동작 실행
function main:bulletManager()
	local bulletAryLength = arrayLength(self.bullets)
	if bulletAryLength == 0 then
		return
	end
	local unitDistance, distance
	local target
	for i = (bulletAryLength - 1), 0, -1 do
		target = self.bullets[i].target
		distance = vec2Distance(self.bullets[i].pos, target.pos)
		unitDistance = vec2((target.pos.x - self.bullets[i].pos.x) / distance, (target.pos.y - self.bullets[i].pos.y) / distance)
		self.bullets[i].pos = vec2(self.bullets[i].pos.x + unitDistance.x * self.bullets[i].vel, self.bullets[i].pos.y + unitDistance.y * self.bullets[i].vel)
		if distance < self.bullets[i].vel then
			self.towers, self.mobs[self.curWave], self.bullets = hitBullet(self.bullets[i], i, self.towers, self.mobs[self.curWave], self.bullets)
		end
	end
end
--[[
--타워의 탄 발사
function main:shootBullet(towerIndex)
	local towerType = self.towers[towerIndex].towerType
	if towerType == 'SingleTarget' then
		self:addBullet('normal', towerIndex, self.towers[towerIndex].attackTarget)
	elseif towerType == 'MultiTarget' then
		magun.log('MultiTarget shoot')
	end
end

--타워의 탄 생성 후 bullet 테이블에 추가
function main:addBullet(newBulletType, towerIndex, newTarget)
	local newBullet = {bulletType = newBulletType, pos = vec2(self.towers[towerIndex].pos.x, self.towers[towerIndex].pos.y), angle = 0}
	if newBulletType == 'normal' then
		newBullet.render = magun.rendering.loadTexture('Resources/Bullet_normal.png')
		newBullet.size = vec2(newBullet.render.width, newBullet.render.height)

		newBullet.pos.x = newBullet.pos.x + 60 * math.cos(self.towers[towerIndex].angle)
		newBullet.pos.y = newBullet.pos.y + 60 * math.sin(self.towers[towerIndex].angle)

		newBullet.vel = 1000 / 60 -- bullet이 1초당 가는 거리
		newBullet.target = newTarget
		newBullet.damage = self.towers[towerIndex].damage

		newBullet.effect = {[0] = 0}

		newBullet.towerIndex = towerIndex
	elseif newBulletType == 'radial' then
		newBullet.effect = {[0] = 0}
	end
	insertElement(self.bullets, newBullet)
end

--탄이 몹에 맞았을때의 대미지 처리, 맞춘 newBullet과 bullet 테이블에서의 newBullet의 index를 인자로 넣음
function main:hitBullet(newBullet, bulletIndex)
	--local target = newBullet.target
	newBullet.target.HP = newBullet.target.HP - self.bullets[bulletIndex].damage
	magun.log('HP: ' .. newBullet.target.HP)
	if newBullet.target.HP < 0 then
		local index = getMobIndex(self.mobs, newBullet.target.mobIndex)
		magun.log('index: ' .. index)
		self.mobs[index].render:dispose()
		self.mobs[index].exist = false

		removeElement(self.mobs, index)
		self.towers[newBullet.towerIndex].attackTarget = nil
	end
	newBullet.render:dispose()
	removeElement(self.bullets, bulletIndex)
end
]]
--render에서 bullet들의 렌더링
function main:renderBullet()
	if arrayLength(self.bullets) == 0 then
		return
	end
	local bulletAryLength = arrayLength(self.bullets)
	for i = 0, (bulletAryLength - 1) do
		self.camera:renderSprite(self.bullets[i].render, 
			vec3(
				self.bullets[i].pos.x,
				self.bullets[i].pos.y, 
				constant.layer.bullet), 
			self.bullets[i].size, 
			self.bullets[i].angle, 
			constant.color.white)
	end
end

--render에서 왼쪽 UI관련 것들의 렌더링
function main:renderLeftUI()
	self.leftUICamera:renderSprite(self.leftUI.waveArrow.render,
			vec3(
			self.leftUI.waveArrow.pos.x,
			self.leftUI.waveArrow.pos.y, 
			constant.layer.UIImage), 
		self.leftUI.waveArrow.size, 
		0, 
		constant.color.white_alpha)

	self.leftUICamera:renderSprite(self.leftUI.background.render,
			vec3(
			self.leftUI.background.pos.x,
			self.leftUI.background.pos.y, 
			constant.layer.UIBackground), 
		self.leftUI.background.size, 
		0, 
		constant.color.white_alpha)
	self.leftUICamera:renderSprite(self.leftUI.lifeText.render,
			vec3(
			self.leftUI.lifeText.pos.x,
			self.leftUI.lifeText.pos.y, 
			constant.layer.UIText), 
		self.leftUI.lifeText.size, 
		0, 
		constant.color.black)
	self.leftUICamera:renderSprite(self.leftUI.waveNum.render,
			vec3(
			self.leftUI.waveNum.pos.x,
			self.leftUI.waveNum.pos.y, 
			constant.layer.UIText), 
		self.leftUI.waveNum.size, 
		0, 
		self.leftUI.waveNum.color)
	self.leftUICamera:renderSprite(self.leftUI.nextStageBtn.render,
			vec3(
			self.leftUI.nextStageBtn.pos.x,
			self.leftUI.nextStageBtn.pos.y, 
			constant.layer.UIText), 
		self.leftUI.nextStageBtn.size, 
		0, 
		self.leftUI.nextStageBtn.color)
	self.leftUICamera:renderSprite(self.leftUI.nextStageBtn.btnImage.render,
			vec3(
			self.leftUI.nextStageBtn.btnImage.pos.x,
			self.leftUI.nextStageBtn.btnImage.pos.y, 
			constant.layer.UIImage), 
		self.leftUI.nextStageBtn.btnImage.size, 
		0, 
		self.leftUI.nextStageBtn.btnImage.color)
	self.leftUICamera:renderSprite(self.leftUI.rotateDirBtn.render,
			vec3(
			self.leftUI.rotateDirBtn.pos.x,
			self.leftUI.rotateDirBtn.pos.y, 
			constant.layer.rotateDirBtn), 
		self.leftUI.rotateDirBtn.size, 
		0, 
		self.leftUI.rotateDirBtn.color)


	for i = 0, (arrayLength(self.leftUI.waveInfo[self.curWave]) - 1) do
		self.leftUICamera:renderSprite(self.leftUI.waveInfo[self.curWave][i].render,
			vec3(
			self.leftUI.waveInfo[self.curWave][i].pos.x,
			self.leftUI.waveInfo[self.curWave][i].pos.y, 
			constant.layer.UIText), 
		self.leftUI.waveInfo[self.curWave][i].size, 
		0, 
		self.leftUI.waveInfo[self.curWave][i].color)
	end

	
end

--render에서 오른쪽 UI관련 것들의 렌더링
function main:renderRightUI()
	self.rightUICamera:renderSprite(self.rightUI.background.render,
			vec3(
			self.rightUI.background.pos.x,
			self.rightUI.background.pos.y, 
			constant.layer.UIBackground), 
		self.rightUI.background.size, 
		0, 
		constant.color.white_alpha)
	self.rightUICamera:renderSprite(self.rightUI.resourceText.render,
			vec3(
			self.rightUI.resourceText.pos.x,
			self.rightUI.resourceText.pos.y, 
			constant.layer.UIText), 
		self.rightUI.resourceText.size, 
		0, 
		constant.color.black)

	local buildMenuLength = arrayLength(self.rightUI.towerBuildMenu)
	if self.rightUIState == constant.rightUIState.towerBuild then
		for i = 0, (buildMenuLength - 1) do
			self.rightUICamera:renderSprite(self.rightUI.towerBuildMenu[i].towerImage.render,
				vec3(
				self.rightUI.towerBuildMenu[i].towerImage.pos.x,
				self.rightUI.towerBuildMenu[i].towerImage.pos.y, 
				constant.layer.UIImage), 
			self.rightUI.towerBuildMenu[i].towerImage.size, 
			0, 
			self.rightUI.towerBuildMenu[i].towerImage.color)
			self.rightUICamera:renderSprite(self.rightUI.towerBuildMenu[i].towerExplain.render,
				vec3(
				self.rightUI.towerBuildMenu[i].towerExplain.pos.x,
				self.rightUI.towerBuildMenu[i].towerExplain.pos.y, 
				constant.layer.UIText), 
			self.rightUI.towerBuildMenu[i].towerExplain.size, 
			0, 
			self.rightUI.towerBuildMenu[i].towerExplain.color)
			self.rightUICamera:renderSprite(self.rightUI.towerBuildMenu[i].buildBtn.render,
				vec3(
				self.rightUI.towerBuildMenu[i].buildBtn.pos.x,
				self.rightUI.towerBuildMenu[i].buildBtn.pos.y, 
				constant.layer.UIText), 
			self.rightUI.towerBuildMenu[i].buildBtn.size, 
			0, 
			self.rightUI.towerBuildMenu[i].buildBtn.color)
			self.rightUICamera:renderSprite(self.rightUI.towerBuildMenu[i].buildBtn.image.render,
				vec3(
				self.rightUI.towerBuildMenu[i].buildBtn.image.pos.x,
				self.rightUI.towerBuildMenu[i].buildBtn.image.pos.y, 
				constant.layer.UIImage), 
			self.rightUI.towerBuildMenu[i].buildBtn.image.size, 
			0, 
			self.rightUI.towerBuildMenu[i].buildBtn.image.color)
		end
	end
	if self.rightUIState > constant.rightUIState.towerUpgrade and self.rightUIState <= constant.rightUIState.towerUpgrade_m1 then
		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.pos.y, 
			constant.layer.UIImage), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.color)

		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.pos.y, 
			constant.layer.UIText), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.color)

		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.pos.y, 
			constant.layer.UIText), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.color)

		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.image.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.image.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.image.pos.y, 
			constant.layer.UIImage), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.image.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn1.image.color)

		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.pos.y, 
			constant.layer.UIText), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.color)

		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.image.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.image.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.image.pos.y, 
			constant.layer.UIImage), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.image.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].upgradeBtn2.image.color)

	elseif self.rightUIState > constant.rightUIState.towerUpgrade_m1 and self.rightUIState <= constant.rightUIState.towerUpgrade_m2b then

		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.pos.y, 
			constant.layer.UIImage), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerImage.color)
		self.rightUICamera:renderSprite(self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.render,
			vec3(
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.pos.x,
			self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.pos.y, 
			constant.layer.UIText), 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.size, 
		0, 
		self.rightUI.towerUpgradeMenu[self.rightUIState].towerExplain.color)
	end
end

--마우스 관련 관리(클릭 등)
function main:mouseManager()
	if magun.mouse.down.left then
		if clickInBtn(magun.mouse, self.leftUI.nextStageBtn.btnImage.pos, self.leftUI.nextStageBtn.btnImage.size) then -- next wave 버튼 클릭 인식
			--magun.log('next wave btn')
			if not self.wave[self.curWave].isStart and not self.isInWave then
				self.isInWave = true
				self.wave[self.curWave].isStart = true
				local waveT = 'Wave: ' .. (self.curWave + 1) .. ' / ' .. constant.totalWaveNum
				self.leftUI.waveNum = setText(self.leftUI.waveNum, waveT, self.btnFont)
				--[[self.leftUI.waveNum.render:dispose()
				self.leftUI.waveNum.render = self.btnFont:createTexture(waveT)
				self.leftUI.waveNum.size = vec2(self.leftUI.waveNum.render.width, self.leftUI.waveNum.render.height)
				self.leftUI.waveNum.pos = vec2(175, magun.screenHeight - 120)
				self.leftUI.waveNum.color = constant.color.black]]
			end
			if isSameColor(self.leftUI.nextStageBtn.btnImage.color, constant.color.white) then
				self.leftUI.nextStageBtn.btnImage.color = constant.color.gray
				self.leftUI.nextStageBtn.color = constant.color.black_alpha
			--[[else
				self.leftUI.nextStageBtn.btnImage.color = constant.color.white
				self.leftUI.nextStageBtn.color = constant.color.black]]
			end
		end

		if clickInBtn(magun.mouse, self.leftUI.rotateDirBtn.pos, self.leftUI.rotateDirBtn.size) then -- 회전방향 바꾸는 버튼 클릭 인식
			if self.rotateDir == 1 then
				self.rotateDir = -1
				self.leftUI.rotateDirBtn = setImage(self.leftUI.rotateDirBtn, 'Resources/help2.png')
				--[[self.leftUI.rotateDirBtn.render:dispose()
				self.leftUI.rotateDirBtn.render = magun.rendering.loadTexture('Resources/help2.png')
				self.leftUI.rotateDirBtn.size = vec2(self.leftUI.rotateDirBtn.render.width / 4, self.leftUI.rotateDirBtn.render.height / 4)
				self.leftUI.rotateDirBtn.pos = vec2(440, magun.screenHeight - 70)
				self.leftUI.rotateDirBtn.color = constant.color.white]]
			elseif self.rotateDir == -1 then
				self.rotateDir = 1
				self.leftUI.rotateDirBtn = setImage(self.leftUI.rotateDirBtn, 'Resources/help1.png')
				--[[self.leftUI.rotateDirBtn.render:dispose()
				self.leftUI.rotateDirBtn.render = magun.rendering.loadTexture('Resources/help1.png')
				self.leftUI.rotateDirBtn.size = vec2(self.leftUI.rotateDirBtn.render.width / 4, self.leftUI.rotateDirBtn.render.height / 4)
				self.leftUI.rotateDirBtn.pos = vec2(440, magun.screenHeight - 70)
				self.leftUI.rotateDirBtn.color = constant.color.white]]
			end
		end

		for i = 0, (constant.towerSlotNum - 1) do
			local centerPos = self.towerFrame[0].pos
			if vec2Distance(magun.mouse, 
				vec2(
					centerPos.x + math.cos(self.towerFrame[0].angle + 2 * math.pi * (i / constant.towerSlotNum)) * (self.towerFrame[0].size.x / 2 - 75), 
					centerPos.y + math.sin(self.towerFrame[0].angle + 2 * math.pi * (i / constant.towerSlotNum)) * (self.towerFrame[0].size.y / 2 - 75)
				)) < 71 then -- 각 타워 슬롯 클릭 인식
				--magun.log(i .. 'slot')
				if self.towers[i] == 0 then
					self.rightUIState = constant.rightUIState.towerBuild
					self.curSlot = i
					--self.towers = addTower('MultiTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 2}, self.towers)
				else
					if self.towers[i].level == '1' then
						if self.towers[i].towerType == 'SingleTarget' then
							self.rightUIState = constant.rightUIState.towerUpgrade_s1
						elseif self.towers[i].towerType == 'MultiTarget' then
							self.rightUIState = constant.rightUIState.towerUpgrade_m1
						end
					elseif self.towers[i].level == '2a' then
						if self.towers[i].towerType == 'SingleTarget' then
							self.rightUIState = constant.rightUIState.towerUpgrade_s2a
						elseif self.towers[i].towerType == 'MultiTarget' then
							self.rightUIState = constant.rightUIState.towerUpgrade_m2a
						end
					elseif self.towers[i].level == '2b' then
						if self.towers[i].towerType == 'SingleTarget' then
							self.rightUIState = constant.rightUIState.towerUpgrade_s2b
						elseif self.towers[i].towerType == 'MultiTarget' then
							self.rightUIState = constant.rightUIState.towerUpgrade_m2b
						end
					end
					self.curSlot = i
				end
			end
		end

		if clickInBtn(magun.mouse, self.rightUI.towerBuildMenu[0].buildBtn.image.pos, self.rightUI.towerBuildMenu[0].buildBtn.image.size) 
			and self.rightUIState == constant.rightUIState.towerBuild and self.towers[self.curSlot] == 0 then
			if self.resource >= 1 and not self.isInWave then
				self.resource = self.resource - 1
				self.towers = addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = self.curSlot}, self.towers)
				local resourceT = 'Resource: ' .. self.resource .. '$'
				setText(self.rightUI.resourceText, resourceT, self.btnFont)
			end
			self.rightUIState = constant.rightUIState.normal
		elseif clickInBtn(magun.mouse, self.rightUI.towerBuildMenu[1].buildBtn.image.pos, self.rightUI.towerBuildMenu[1].buildBtn.image.size) 
			and self.rightUIState == constant.rightUIState.towerBuild and self.towers[self.curSlot] == 0 then
			if self.resource >= 1 and not self.isInWave then
				self.resource = self.resource - 1
				self.towers = addTower('MultiTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = self.curSlot}, self.towers)
				local resourceT = 'Resource: ' .. self.resource .. '$'
				setText(self.rightUI.resourceText, resourceT, self.btnFont)
			end
			self.rightUIState = constant.rightUIState.normal
		end

		if clickInBtn(magun.mouse, self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image.pos, self.rightUI.towerUpgradeMenu[3].upgradeBtn1.image.size) 
			and self.rightUIState == constant.rightUIState.towerUpgrade_s1 and self.towers[self.curSlot] ~= 0 then

			if self.resource >= 1 and not self.isInWave then
				setImage(self.towers[self.curSlot], towerValue.SingleTarget.level2a.resource)
				self.towers[self.curSlot].level = '2a'
				self.towers[self.curSlot].maxCoolDown = towerValue.SingleTarget.level2a.maxCoolDown
				self.towers[self.curSlot].targetNum = towerValue.SingleTarget.level2a.targetNum
				self.towers[self.curSlot].damage = towerValue.SingleTarget.level2a.damage
				self.towers[self.curSlot].range = towerValue.SingleTarget.level2a.range
				self.towers[self.curSlot].rangeSize = vec2(
								self.towers[self.curSlot].rangeRender.width * self.towers[self.curSlot].range * 2 / resource.range.width, 
								self.towers[self.curSlot].rangeRender.height * self.towers[self.curSlot].range * 2 / resource.range.height)
				self.resource = self.resource - 1
				local resourceT = 'Resource: ' .. self.resource .. '$'
				setText(self.rightUI.resourceText, resourceT, self.btnFont)
			end
			self.rightUIState = constant.rightUIState.normal

		elseif clickInBtn(magun.mouse, self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image.pos, self.rightUI.towerUpgradeMenu[3].upgradeBtn2.image.size) 
			and self.rightUIState == constant.rightUIState.towerUpgrade_s1 and self.towers[self.curSlot] ~= 0 then

			if self.resource >= 1 and not self.isInWave then
				setImage(self.towers[self.curSlot], towerValue.SingleTarget.level2b.resource)
				self.towers[self.curSlot].level = '2b'
				self.towers[self.curSlot].maxCoolDown = towerValue.SingleTarget.level2b.maxCoolDown
				self.towers[self.curSlot].targetNum = towerValue.SingleTarget.level2b.targetNum
				self.towers[self.curSlot].damage = towerValue.SingleTarget.level2b.damage
				self.towers[self.curSlot].range = towerValue.SingleTarget.level2b.range
				self.towers[self.curSlot].rangeSize = vec2(
								self.towers[self.curSlot].rangeRender.width * self.towers[self.curSlot].range * 2 / resource.range.width, 
								self.towers[self.curSlot].rangeRender.height * self.towers[self.curSlot].range * 2 / resource.range.height)
				self.resource = self.resource - 1
				local resourceT = 'Resource: ' .. self.resource .. '$'
				setText(self.rightUI.resourceText, resourceT, self.btnFont)
			end
			self.rightUIState = constant.rightUIState.normal

		elseif clickInBtn(magun.mouse, self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image.pos, self.rightUI.towerUpgradeMenu[4].upgradeBtn1.image.size) 
			and self.rightUIState == constant.rightUIState.towerUpgrade_m1 and self.towers[self.curSlot] ~= 0 then

			if self.resource >= 1 and not self.isInWave then
				setImage(self.towers[self.curSlot], towerValue.MultiTarget.level2a.resource)
				self.towers[self.curSlot].level = '2a'
				self.towers[self.curSlot].maxCoolDown = towerValue.MultiTarget.level2a.maxCoolDown
				self.towers[self.curSlot].targetNum = towerValue.MultiTarget.level2a.targetNum
				self.towers[self.curSlot].damage = towerValue.MultiTarget.level2a.damage
				self.towers[self.curSlot].range = towerValue.MultiTarget.level2a.range
				self.towers[self.curSlot].splashDamage = towerValue.MultiTarget.level2a.splashDamage
				self.towers[self.curSlot].splashRange = towerValue.MultiTarget.level2a.splashRange
				self.towers[self.curSlot].rangeSize = vec2(
								self.towers[self.curSlot].rangeRender.width * self.towers[self.curSlot].range * 2 / resource.range.width, 
								self.towers[self.curSlot].rangeRender.height * self.towers[self.curSlot].range * 2 / resource.range.height)
				self.resource = self.resource - 1
				local resourceT = 'Resource: ' .. self.resource .. '$'
				setText(self.rightUI.resourceText, resourceT, self.btnFont)
			end
			self.rightUIState = constant.rightUIState.normal

		elseif clickInBtn(magun.mouse, self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image.pos, self.rightUI.towerUpgradeMenu[4].upgradeBtn2.image.size) 
			and self.rightUIState == constant.rightUIState.towerUpgrade_m1 and self.towers[self.curSlot] ~= 0 then

			if self.resource >= 1 and not self.isInWave then
				setImage(self.towers[self.curSlot], towerValue.MultiTarget.level2b.resource)
				self.towers[self.curSlot].level = '2b'
				self.towers[self.curSlot].maxCoolDown = towerValue.MultiTarget.level2b.maxCoolDown
				self.towers[self.curSlot].targetNum = towerValue.MultiTarget.level2b.targetNum
				self.towers[self.curSlot].damage = towerValue.MultiTarget.level2b.damage
				self.towers[self.curSlot].range = towerValue.MultiTarget.level2b.range
				self.towers[self.curSlot].splashDamage = towerValue.MultiTarget.level2b.splashDamage
				self.towers[self.curSlot].splashRange = towerValue.MultiTarget.level2b.splashRange
				self.towers[self.curSlot].rangeSize = vec2(
								self.towers[self.curSlot].rangeRender.width * self.towers[self.curSlot].range * 2 / resource.range.width, 
								self.towers[self.curSlot].rangeRender.height * self.towers[self.curSlot].range * 2 / resource.range.height)
				self.resource = self.resource - 1
				local resourceT = 'Resource: ' .. self.resource .. '$'
				setText(self.rightUI.resourceText, resourceT, self.btnFont)
			end
			self.rightUIState = constant.rightUIState.normal

		end
		--[[for index, i in ipairs(towerAryIndex) do
			--self.towers[i].angle = math.atan2(magun.mouse.y - self.towers[i].pos.y, magun.mouse.x - self.towers[i].pos.x)
		end
		--self.bullets.x = magun.mouse.x
		--self.bullets.y = magun.mouse.y]]
	end

	--[[if magun.mouse.up.left then
	end]]
	--[[if magun.mouse.press.left then
		if clickInBtn(vec2(magun.mouse.x, magun.mouse.y), self.leftUI.nextStageBtn.btnImage.pos, self.leftUI.nextStageBtn.btnImage.size) then
			self.leftUI.nextStageBtn.btnImage.color = constant.color.gray
		end
	end]]
end



----------------------------------------------------------------------------------------------------------------------------------------------


--몹이나 타워의 배열을 거리 오름차순으로 정렬해서 반환, unitArray는 {index, distance}들로 이루어진 테이블
function sortByDistance(unitArray)
	local temp, tempUnit, tempIndex = nil, nil, nil
	local newArray = tableCopy(unitArray)
	local aryLength = arrayLength(unitArray)
	for i = 0, (aryLength - 2) do
		tempUnit = tableCopy(newArray[i])
		tempIndex = i
		for j = i + 1, (aryLength - 1) do
			if tempUnit.distance > newArray[j].distance then
				tempUnit = tableCopy(newArray[j])
				tempIndex = j
			end
		end
		if i ~= tempIndex then
			temp = tableCopy(tempUnit)
			newArray[tempIndex] = tableCopy(tempUnit)
			newArray[i] = tableCopy(temp)
		end
	end
	return newArray
end

--특정 몹 mob을 중심으로 특정 range안에 있는 몹들 반환, mobs는 전체 몹의 배열(self.mobs), 중심으로 적용된 몹 자신도 포함
function mobInRange(mobs, mob, range)
	local nearMob = {[0] = 0}
	local curPos = mob.pos
	local mobAryLength = arrayLength(mobs)
	for i = 0, (mobAryLength - 1) do
		if vec2Distance(curPos, mobs[i].pos) <= range then
			insertElement(nearMob, mobs[i])
		end
	end
	return nearMob
end

--vec2인 startPos, endPos 사이의 거리를 반환
function vec2Distance(startPos, endPos)
	return math.sqrt((startPos.x - endPos.x) ^ 2 + (startPos.y - endPos.y) ^ 2)
end

--특정 지점이 특정 버튼 안에 있는지 확인(클릭 인식 용도), pos와 size는 vec2
function clickInBtn(clickPos, btnPos, btnSize)
	if clickPos.x >= (btnPos.x - btnSize.x / 2) and clickPos.x <= (btnPos.x + btnSize.x / 2) and clickPos.y >= (btnPos.y - btnSize.y / 2) and clickPos.y <= (btnPos.y + btnSize.y / 2) then
		return true
	else
		return false
	end
end

--두 색이 같은 색인지 검사, c4타입의 색 2개가 인자로 들어옴
function isSameColor(color1, color2)
	if color1.r == color2.r and color1.g == color2.g and color1.b == color2.b and color1.a == color2.a then
		return true
	else
		return false
	end
end

--font인 texture의 글을 text로 바꿔주는 함수
function setText(texture, text, font)
	local curSize = vec2(texture.size.x, texture.size.y)
	local curPos = vec2(texture.pos.x, texture.pos.y)
	local curColor = texture.color
	texture.render:dispose()
	texture.render = font:createTexture(text)
	texture.size = vec2(curSize.x, curSize.y)
	texture.pos = vec2(curPos.x, curPos.y)
	texture.color = curColor
	return texture
end

function setImage(texture, imagePath)
	local curSize = vec2(texture.size.x, texture.size.y)
	local curPos = vec2(texture.pos.x, texture.pos.y)
	local curColor = texture.color
	texture.render:dispose()
	texture.render = magun.rendering.loadTexture(imagePath)
	texture.size = vec2(curSize.x, curSize.y)
	texture.pos = vec2(curPos.x, curPos.y)
	texture.color = curColor
	return texture
end

--테이블 복사
function tableCopy(t)
	local t2 = {}
	for k,v in pairs(t) do
		if type(v) == "table" then
			t2[k] = tableCopy(v)
		else
			t2[k] = v
		end
	end
	return t2
end

--베열처람 관리하는 table 가장 뒤쪽에 원소를 넣음
function insertElement(aryTable, element)
	local aryLength = arrayLength(aryTable)
	if aryLength == 0 and aryTable[0] == 0 then
		aryTable[0] = element
	else
		table.insert(aryTable, element)
	end
end

--배열처럼 관리하는 table의 elementIndex위치에 있는 원소를 제거
function removeElement(aryTable, elementIndex)
	local removedElement
	local aryLength = arrayLength(aryTable)
	if aryLength == 1 then
		removedElement = aryTable[0]
		aryTable[0] = 0
	elseif elementIndex == 0 then
		removedElement = aryTable[0]
		for i = 0, (aryLength - 2) do
			aryTable[i] = aryTable[i + 1]
		end
		table.remove(aryTable)
	else
		removedElement = table.remove(aryTable, elementIndex)
	end
	return removedElement
end

--0부터 시작하는 배열처럼 관리한 table의 크기 반환
function arrayLength(aryTable)
	if #aryTable == 0 and aryTable[0] == 0 then
		return 0
	end
	return #aryTable + 1
end

--0부터 시작하는 배열처럼 관리한 table의 비교 결과 반환
function compareTable(tableA, tableB)
	if arrayLength(tableA) ~= arrayLength(tableB) then
		return false
	end
	local aryLength = arrayLength(tableA)
	for i = 0, (aryLength - 1) do
		if type(tableA[i]) == 'table' and type(tableB[i]) == 'table' then
			if compareTable(tableA[i], tableB[i]) == false then
				return false
			end
		else
			if tableA[i] ~= tableB[i] then
				return false
			end
		end
	end
	return true
end

--0부터 시작하는 배열처럼 관리한 table에서 element의 index 반환
function getIndex(aryTable, element)
	local aryLength = arrayLength(aryTable)
	--magun.log(aryLength)
	for i = 0, (aryLength - 1) do
		if type(aryTable[i]) == 'table' then
			if compareTable(aryTable[i], element) == true then
				return i
			end
		else
			if aryTable[i] == element then
				return i
			end
		end
	end
	return -1
end

--self.mobs 테이블에서 mobIndex로부터 table의 index 반환
function getMobIndex(mobTable, mobIndex)
	local aryLength = arrayLength(mobTable)
	for i = 0, (aryLength - 1) do
		if mobTable[i].mobIndex == mobIndex then
			return i
		end
	end
	return -1
end

--inputstr을 sep로 split하고 그 결과 배열을 반환
function strSplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

--[[
split예제
testSplit = strSplit("1_ _2_  __3_", "_")
for index, i in ipairs(testSplit) do
	magun.log(index .. "," .. i)
end
]]--



return main