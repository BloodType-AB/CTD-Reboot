local main = {}

constant = require('scripts/constant')
resource = require('scripts/resource')
waveInfo = require('scripts/wave')

function main:init()
	-- magun.debug.printAll()

	magun.screenWidth = 1920
	magun.screenHeight = 1080
	magun.title = 'ROTATING NEOGUL NEOGUL'

	magun.rendering.backgroundColor = c4(177, 217, 59, 255)
	magun.log('neogulman loaded!')

	self.towers = {[0] = 0}
	

	self.mobs = {[0] = 0}

	--self.mobs[0] = {pos = vec2(magun.mouse.x, magun.mouse.y)}
	--self.mobs[1] = {pos = vec2(magun.mouse.x + 100, magun.mouse.y)}
	--self.mobs[2] = {pos = vec2(magun.mouse.x + 200, magun.mouse.y)}

	self.bullets ={[0] = 0}

	--[[self.bullets.render = magun.rendering.loadTexture('Resources/Bullet_normal.png')
	self.bullets.x = magun.screenWidth / 2
	self.bullets.y = magun.screenHeight / 2]]

	self.towerFrame = {[0] = {}}
	self.towerFrame[0].render = magun.rendering.loadTexture('Resources/TowerFrame.png')
	self.towerFrame[0].size = vec2(self.towerFrame[0].render.width, self.towerFrame[0].render.height)
	self.towerFrame[0].pos = vec2(magun.screenWidth / 2, magun.screenHeight / 2)
	self.towerFrame[0].angle = 0

	self.wave = {[0] = 0}
	self.wave[0] = {}
	self.wave[0].isStart = false
	self.wave[0].time = waveInfo.totalTime

	local newMob
	for i = 0, (arrayLength(waveInfo) - 1) do
		newMob = {}
		newMob.HP = waveInfo[i].HP
		newMob.speed = waveInfo[i].speed
		newMob.start = waveInfo[i].start
		newMob.effect = tableCopy(waveInfo[i].effect)
		newMob.time = waveInfo[i].time

		newMob.pos = vec2(
			self.towerFrame[0].pos.x + math.cos(newMob.start * 90 / 180 * math.pi) * (resource.TowerFrame.width / 2 + 100), 
			self.towerFrame[0].pos.y + math.sin(newMob.start * 90 / 180 * math.pi) * (resource.TowerFrame.height / 2 + 100))
		newMob.vel = vec2(
			-1 * math.cos(newMob.start * 90 / 180 * math.pi) * newMob.speed / 60, 
			-1 * math.sin(newMob.start * 90 / 180 * math.pi) * newMob.speed / 60
			)
		newMob.angle = (newMob.start * 90 + 180) / 180 * math.pi

		newMob.exist = false

		insertElement(self.mobs, tableCopy(newMob))
	end


	--self.towerSlot = {[0] = 0}

	self:addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 1})
	self:addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 2})

	self.vx = 500
	self.vy = 500

	self.camera = magun.rendering.createOrtho(0, magun.screenWidth, 0, magun.screenHeight, -1, 1)

	self.camera.x = magun.screenWidth / 2
	self.camera.y = magun.screenHeight / 2

	--a = {[0] = 10, {[0] = 0, 2, 3}, 30, 40, 50, 60}
	--magun.log(getIndex(a, {[0] = 0, 2, 3}))

	self.life = {render = magun.rendering.loadTexture('Resources/life.png'), size = vec2(200, 200)}


end

function main:update(dt) 
	
	if magun.keyboard.press.p then
		self.wave[0].isStart = true
	end

	self:waveManager()

	self:towerFrameManager()

	self:towerManager()

	self:mobManager()

	self:bulletManager()

	if magun.keyboard.press.escape then
		self:dispose()
		os.exit()
	end
end

function main:render(dt) 
	self.camera:start()


	self:renderTower()

	self:renderTowerFrame()

	self:renderBullet()

	self:renderMob()

	self.camera:renderSprite(self.life.render, 
		vec3(
			magun.screenWidth / 2,
			magun.screenHeight / 2, 
			constant.layer.towerFrame), 
		self.life.size, 
		0, 
		constant.color.white)
	

	self.camera:flush()
end

function main:dispose()
	local towerAryLength = arrayLength(self.towers)
	for i = 1, (towerAryLength - 1) do
		self.towers[i].render:dispose()
		self.towers[i].rangeRender:dispose()
	end
	self.camera:dispose()
end

-----------------------------------------------------------------------

--update에서 tower들의 동작 실행
function main:towerManager()
	local towerAryLength = arrayLength(self.towers)
	if towerAryLength == 0 then
		return
	end
	for i = 0, (towerAryLength - 1) do
		self.towers[i].pos.x = self.towers[i].frame.pos.x + math.cos(self.towers[i].frame.angle + self.towers[i].slot * 90 / 180 * math.pi) * (resource.TowerFrame.width / 2 - 75)
		self.towers[i].pos.y = self.towers[i].frame.pos.y + math.sin(self.towers[i].frame.angle + self.towers[i].slot * 90 / 180 * math.pi) * (resource.TowerFrame.height / 2 - 75)
		--쿨타임 감소
		if self.towers[i].coolDown > 0 then
			self.towers[i].coolDown = self.towers[i].coolDown - 1
		end
		--타워 공격
		if self.towers[i].attackTarget ~= nil then
			self:attackTarget(i)
		end
		--공격대상 감지
		if self.towers[i].attackTarget == nil then
			self:searchTarget(i)
		end
	end
	if magun.mouse.press.left then
		for i = 0, (towerAryLength - 1) do
			--self.towers[i].angle = math.atan2(magun.mouse.y - self.towers[i].pos.y, magun.mouse.x - self.towers[i].pos.x)
		end
		--self.bullets.x = magun.mouse.x
		--self.bullets.y = magun.mouse.y
	end
end

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
	local towerAryLength = arrayLength(self.towers)
	local mobAryLength = arrayLength(self.mobs)
	local closeMobAry = {[0] = 0}
	local newDistance
	for i = 0, (mobAryLength - 1) do
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

--render에서 tower들의 렌더링
function main:renderTower()
	local towerAryLength = arrayLength(self.towers)
	if towerAryLength == 0 then
		return
	end
	local rangeColor
	for i = 0, (towerAryLength - 1) do
		self.camera:renderSprite(self.towers[i].render, 
			vec3(
				self.towers[i].pos.x + self.towers[i].textureCenterDiff * math.cos(self.towers[i].angle),
				self.towers[i].pos.y + self.towers[i].textureCenterDiff * math.sin(self.towers[i].angle), 
				constant.layer.tower), 
			self.towers[i].size, 
			self.towers[i].angle, 
			constant.color.white)

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

--타워 생성 후 tower 테이블에 넣음
function main:addTower(newTowerType, towerPos, frameInfo)
	local newTower = {towerType = newTowerType, pos = towerPos, frame = frameInfo.frame, slot = frameInfo.slot, level = '1', angle = 0, coolDown = 0}
	if newTowerType == 'SingleTarget' then
		newTower.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_1.png')
		newTower.size = vec2(newTower.render.width, newTower.render.height)
		newTower.maxCoolDown = 60

		newTower.attackTarget = nil
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

--타워 제거 후 tower 테이블에서 뺌
function main:removeTower(towerIndex)
	self.towers[towerIndex].render:dispose()
	self.towers[towerIndex].rangeRender:dispose()
	removeElement(self.towers, towerIndex)
end

--update에서 tower frame의 동작 실행
function main:towerFrameManager()
	local rotateVel = math.pi / 90
	if magun.keyboard.press.a then
		self.towerFrame[0].angle = self.towerFrame[0].angle + rotateVel * constant.config.rotate
	elseif magun.keyboard.press.d then
		self.towerFrame[0].angle = self.towerFrame[0].angle - rotateVel * constant.config.rotate
	end
end

--render에서 tower frame들의 렌더링
function main:renderTowerFrame()
	local frameAryLength = arrayLength(self.towerFrame)
	if frameAryLength == 0 then
		return
	end
	for i = 0, (frameAryLength - 1) do
		self.camera:renderSprite(self.towerFrame[i].render, 
			vec3(
				self.towerFrame[i].pos.x,
				self.towerFrame[i].pos.y, 
				constant.layer.towerFrame), 
			self.towerFrame[i].size, 
			self.towerFrame[i].angle, 
			constant.color.white)
	end
end

--update에서 wave 동작 실행
function main:waveManager()
	if self.wave[0].isStart == false then
		return
	end
	if self.wave[0].time > 0 then
		self.wave[0].time = self.wave[0].time - 1
		local mobAryLength = arrayLength(self.mobs)
		for i = 0, (mobAryLength - 1) do
			if self.mobs[i].time == self.wave[0].time then
				self.mobs[i].render = magun.rendering.loadTexture('Resources/mob.png')
				self.mobs[i].size = vec2(self.mobs[i].render.width, self.mobs[i].render.height)
				self.mobs[i].exist = true
			end
		end
	elseif self.wave[0].time == 0 then
		self.wave[0].time = -1
	end
end

--update에서 mob들의 동작 실행
function main:mobManager()
	local mobAryLength = arrayLength(self.mobs)
	for i = (mobAryLength - 1), 0, -1 do
		if self.mobs[i].exist == true then
			self.mobs[i].pos.x = self.mobs[i].pos.x + self.mobs[i].vel.x
			self.mobs[i].pos.y = self.mobs[i].pos.y + self.mobs[i].vel.y
		end
		--self.mobs[i].pos = vec2(magun.mouse.x, magun.mouse.y)
	end
end

--render에서 mob들의 렌더링
function main:renderMob()
	local mobAryLength = arrayLength(self.mobs)
	if mobAryLength == 0 then
		return
	end
	for i = (mobAryLength - 1), 0, -1 do
		if self.mobs[i].exist == true then
			self.camera:renderSprite(self.mobs[i].render, 
			vec3(
				self.mobs[i].pos.x,
				self.mobs[i].pos.y, 
				constant.layer.mob), 
			self.mobs[i].size, 
			self.mobs[i].angle, 
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
			self:bulletDamage(self.bullets[i], i, self.bullets[i].towerIndex)
		end
	end
end

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

		newBullet.vel = 1000 / 60
		newBullet.target = newTarget
		newBullet.damage = self.towers[towerIndex].damage

		newBullet.effect = {[0] = 0}

		newBullet.towerIndex = towerIndex
	end
	insertElement(self.bullets, newBullet)
end

function main:bulletDamage(newBullet, bulletIndex, towerIndex)
	local target = newBullet.target
	newBullet.target.HP = newBullet.target.HP - self.bullets[bulletIndex].damage
	if newBullet.target.HP < 0 then
		local index = getIndex(self.mobs, self.towers[newBullet.towerIndex].attackTarget)
		magun.log(index)
		self.towers[newBullet.towerIndex].attackTarget.exist = false
		self.towers[newBullet.towerIndex].attackTarget.render:dispose()
		--magun.log(getIndex(self.mobs, self.towers[newBullet.towerIndex].attackTarget))
		removeElement(self.mobs, index)
		self.towers[newBullet.towerIndex].attackTarget = nil
	end
	removeElement(self.bullets, bulletIndex)
	newBullet.render:dispose()
end

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

--vec2인 startPos, endPos 사이의 거리를 반환
function vec2Distance(startPos, endPos)
	return math.sqrt((startPos.x - endPos.x) ^ 2 + (startPos.y - endPos.y) ^ 2)
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






return main