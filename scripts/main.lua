local main = {}

constant = require('scripts/constant')
resource = require('scripts/resource')

function main:init()
	-- magun.debug.printAll()

	magun.screenWidth = 1600
	magun.screenHeight = 900
	magun.title = 'ROTATING NEOGUL NEOGUL'

	magun.rendering.backgroundColor = c4(177, 217, 59, 255)
	magun.log('neogulman loaded!')

	self.towers = {[0] = 0}
	self:addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2))

	self.mobs = {[0] = 0}
	self.mobs[0] = {pos = vec2(magun.mouse.x, magun.mouse.y)}
	self.mobs[1] = {pos = vec2(magun.mouse.x + 100, magun.mouse.y)}

	self.bullet ={}
	self.bullet.render = magun.rendering.loadTexture('Resources/bullet.png')
	self.bullet.x = magun.screenWidth / 2
	self.bullet.y = magun.screenHeight / 2

	self.vx = 500
	self.vy = 500

	self.camera = magun.rendering.createOrtho(0, magun.screenWidth, 0, magun.screenHeight, -1, 1)

	self.camera.x = magun.screenWidth / 2
	self.camera.y = magun.screenHeight / 2

end

function main:update(dt) 
	
	--[[if magun.keyboard.press.w then
		self.towers.SingleTarget.y = self.towers.SingleTarget.y + self.vy * dt
	end]]

	self:towerManager()

	self:mobManager()

	if magun.keyboard.press.escape then
		self:dispose()
		os.exit()
	end
end

function main:render(dt) 
	self.camera:start()
	self:renderTower()
	self.camera:renderSprite(self.bullet.render, 
		vec3(self.bullet.x, self.bullet.y, constant.layer.bullet), 
		vec2(self.bullet.render.width, self.bullet.render.height),
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
		if self.towers[i].attackTarget ~= nil then
			self:attackTarget(i)
		end
		if self.towers[i].attackTarget == nil then
			self:searchTarget(i)
		end
	end
	if magun.mouse.press.left then
		for i = 0, (towerAryLength - 1) do
			--self.towers[i].angle = math.atan2(magun.mouse.y - self.towers[i].pos.y, magun.mouse.x - self.towers[i].pos.x)
		end
		self.bullet.x = magun.mouse.x + 100
		self.bullet.y = magun.mouse.y
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
		if newDistance <= self.towers[towerIndex].range then
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

--update에서 mob들의 동작 실행
function main:mobManager()
	local mobAryLength = arrayLength(self.mobs)
	for i = 0, (mobAryLength - 1) do
		self.mobs[i].pos = vec2(magun.mouse.x + i * 100, magun.mouse.y)
	end
end

--render에서 tower들의 렌더링
function main:renderTower()
	if arrayLength(self.towers) == 0 then
		return
	end
	local towerAryLength = arrayLength(self.towers)
	local rangeColor
	for i = 0, (towerAryLength - 1) do
		self.camera:renderSprite(self.towers[i].render, 
			vec3(
				self.towers[i].pos.x + self.towers[i].textureCenterDiff * math.cos(self.towers[i].angle),
				self.towers[i].pos.y + self.towers[i].textureCenterDiff * math.sin(self.towers[i].angle), 
				constant.layer.towers), 
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
function main:addTower(newTowerType, towerPos)
	local newTower = {towerType = newTowerType, pos = towerPos, level = '1', angle = 0, coolDown = 0}
	if newTowerType == 'SingleTarget' then
		newTower.render = magun.rendering.loadTexture('Resources/Tower_SingleTarget_1.png')
		newTower.size = vec2(newTower.render.width, newTower.render.height)
		newTower.maxCoolDown = 180
		newTower.attackTarget = nil

		newTower.range = 150
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






return main