--[[
function tower(x, y, towerType, testAry)
	local newTower = {pos = vec2(x, y)}
	magun.log('tower function' .. x .. y)
	if towerType == 'single' then
		newTower.attack = function()
			magun.log('singleAttack: ' .. testAry[0] .. ',' .. testAry[2])
		end
	elseif towerType == 'multi' then
		newTower.attack = function()
			magun.log('multiAttack: ' .. x .. ',' .. y)
		end
	end
	return newTower
end
]]
towerValue = require('scripts/towerValue')

--towerType을 받아 타워 생성 후 tower 테이블에 넣음 towerPos는 vec2, frameInfo = {frame = , slot = } 의 형태, towers는 main에서의 self:towers
--self.towers = addTower('SingleTarget', vec2(magun.screenWidth / 2, magun.screenHeight / 2), {frame = self.towerFrame[0], slot = 1}, self.towers)의 형태로 사용

function addTower(newTowerType, towerPos, frameInfo, towers)
	local newTower = {towerType = newTowerType, pos = towerPos, frame = frameInfo.frame, slot = frameInfo.slot, level = '1', angle = 0, coolDown = 0}
	if newTowerType == 'SingleTarget' then
		newTower.render = magun.rendering.loadTexture(towerValue.SingleTarget.level1.resource)
		newTower.size = vec2(newTower.render.width, newTower.render.height)
		newTower.color = c4(255, 255, 255, 255)
		newTower.maxCoolDown = towerValue.SingleTarget.level1.maxCoolDown

		newTower.attackTarget = nil
		newTower.targetNum = towerValue.SingleTarget.level1.targetNum
		newTower.damage = towerValue.SingleTarget.level1.damage

		newTower.range = towerValue.SingleTarget.level1.range
		newTower.rangeRender = magun.rendering.loadTexture('Resources/range.png')
		newTower.rangeSize = vec2(
								newTower.rangeRender.width * newTower.range * 2 / resource.range.width, 
								newTower.rangeRender.height * newTower.range * 2 / resource.range.height)

		newTower.effect = towerValue.SingleTarget.level1.effect

		newTower.textureCenterDiff = 13
	elseif newTowerType == 'MultiTarget' then
		newTower.render = magun.rendering.loadTexture(towerValue.MultiTarget.level1.resource)
		newTower.size = vec2(newTower.render.width, newTower.render.height)
		newTower.color = c4(255, 255, 255, 255)
		newTower.maxCoolDown = towerValue.MultiTarget.level1.maxCoolDown

		newTower.attackTarget = nil
		newTower.targetNum = towerValue.MultiTarget.level1.targetNum
		newTower.damage = towerValue.MultiTarget.level1.damage
		newTower.splashDamage = towerValue.MultiTarget.level1.splashDamage
		newTower.splashRange = towerValue.MultiTarget.level1.splashRange

		newTower.range = towerValue.MultiTarget.level1.range
		newTower.rangeRender = magun.rendering.loadTexture('Resources/range.png')
		newTower.rangeSize = vec2(
								newTower.rangeRender.width * newTower.range * 2 / resource.range.width, 
								newTower.rangeRender.height * newTower.range * 2 / resource.range.height)

		newTower.effect = towerValue.MultiTarget.level1.effect

		newTower.textureCenterDiff = 13
	end
	towers[frameInfo.slot] = newTower
	--insertElement(towers, newTower)
	return towers
end

--towers 내 특정 index의 타워가 공격 가능 타겟이 여전히 범위 안에 있는지 감지하고 공격
function attackTarget(towerIndex, towers, bullets)
	if towers[towerIndex].towerType == 'SingleTarget' then
		if vec2Distance(towers[towerIndex].pos, towers[towerIndex].attackTarget.pos) > towers[towerIndex].range then
			towers[towerIndex].attackTarget = nil
		else
			local curTarget = towers[towerIndex].attackTarget
			towers[towerIndex].angle = math.atan2(curTarget.pos.y - towers[towerIndex].pos.y, curTarget.pos.x - towers[towerIndex].pos.x) -- 타워가 몹을 바라보도록 각도 설정
			if towers[towerIndex].coolDown == 0 then
				towers, bullets = shootBullet(towerIndex, towers, bullets) -- 탄 발사
				towers[towerIndex].coolDown = towers[towerIndex].maxCoolDown
			end
		end
	elseif towers[towerIndex].towerType == 'MultiTarget' then
		if vec2Distance(towers[towerIndex].pos, towers[towerIndex].attackTarget.pos) > towers[towerIndex].range then
			towers[towerIndex].attackTarget = nil
		else
			local curTarget = towers[towerIndex].attackTarget
			towers[towerIndex].angle = math.atan2(curTarget.pos.y - towers[towerIndex].pos.y, curTarget.pos.x - towers[towerIndex].pos.x) -- 타워가 몹을 바라보도록 각도 설정
			if towers[towerIndex].coolDown == 0 then
				towers, bullets = shootBullet(towerIndex, towers, bullets) -- 탄 발사
				towers[towerIndex].coolDown = towers[towerIndex].maxCoolDown
			end
		end
	end
	return towers, bullets
end

--towers 내 특정 index의 타워가 공격 가능 타겟이 있는지 감지
function searchTarget(towerIndex, towers, mobs)
	local towerAryIndex = existTowerSlot(towers)
	local mobAryLength = arrayLength(mobs)
	local closeMobAry = {[0] = 0}
	local newDistance
	for i = (mobAryLength - 1), 0, -1 do
		newDistance = vec2Distance(towers[towerIndex].pos, mobs[i].pos)
		if newDistance <= towers[towerIndex].range and mobs[i].exist == true then
			insertElement(closeMobAry, {index = i, distance = newDistance})
		end
	end
	if closeMobAry[0] == 0 then
		return towers
	end
	closeMobAry = sortByDistance(closeMobAry)
	if towers[towerIndex].towerType == 'SingleTarget' then
		towers[towerIndex].attackTarget = mobs[closeMobAry[0].index]
	elseif towers[towerIndex].towerType == 'MultiTarget' then
		towers[towerIndex].attackTarget = mobs[closeMobAry[0].index]
	end
	return towers
end

--타워 제거 후 tower 테이블에서 뺌
function removeTower(towerSlot, towers)
	towers[towerSlot].render:dispose()
	towers[towerSlot].rangeRender:dispose()
	--removeElement(self.towers, towerIndex)
	towers[towerSlot] = 0
	return towers
end

--타워슬롯중 타워가 존재하는 슬롯의 table을 반환
function existTowerSlot(towers)
	local aryLength = arrayLength(towers)
	local existSlot = {}
	for i = (aryLength - 1), 0, -1 do
		if towers[i] ~= 0 then
			table.insert(existSlot, i)
		end
	end
	return existSlot
end