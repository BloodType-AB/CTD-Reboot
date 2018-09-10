--타워의 탄 발사
function shootBullet(towerIndex, towers, bullets)
	local towerType = towers[towerIndex].towerType
	local towerLevel = towers[towerIndex].level
	if towerType == 'SingleTarget'--[[and towerLevel == '1']] then
		towers, bullets = addBullet('normal', towerIndex, towers[towerIndex].attackTarget, towers, bullets)
	elseif towerType == 'MultiTarget'--[[ and towerLevel == '1']] then
		towers, bullets = addBullet('radial', towerIndex, towers[towerIndex].attackTarget, towers, bullets)
	end
	return towers, bullets
end

--타워의 탄 생성 후 bullet 테이블에 추가
function addBullet(newBulletType, towerIndex, newTarget, towers, bullets)
	local newBullet = {bulletType = newBulletType, pos = vec2(towers[towerIndex].pos.x, towers[towerIndex].pos.y), angle = 0}
	local towerLevel = towers[towerIndex].level
	if newBulletType == 'normal' then
		newBullet.render = magun.rendering.loadTexture('Resources/Bullet_normal.png')
		newBullet.size = vec2(newBullet.render.width, newBullet.render.height)

		newBullet.pos.x = newBullet.pos.x + 60 * math.cos(towers[towerIndex].angle)
		newBullet.pos.y = newBullet.pos.y + 60 * math.sin(towers[towerIndex].angle)

		newBullet.vel = 1000 / 60 -- bullet이 1초당 가는 거리
		newBullet.target = newTarget
		newBullet.damage = towers[towerIndex].damage

		newBullet.effect = {[0] = 0}

		newBullet.towerIndex = towerIndex
	elseif newBulletType == 'radial' then
		if towerLevel == '3ab' then -- 2번 터지는 효과 추가
			newBullet.effect = {[0] = 0}
		end
		newBullet.render = magun.rendering.loadTexture('Resources/Bullet_radial.png')
		newBullet.size = vec2(newBullet.render.width, newBullet.render.height)

		newBullet.pos.x = newBullet.pos.x + 60 * math.cos(towers[towerIndex].angle)
		newBullet.pos.y = newBullet.pos.y + 60 * math.sin(towers[towerIndex].angle)

		newBullet.vel = 1000 / 60 -- bullet이 1초당 가는 거리
		newBullet.target = newTarget
		newBullet.damage = towers[towerIndex].damage
		newBullet.splashDamage = towers[towerIndex].splashDamage
		newBullet.splashRange = towers[towerIndex].splashRange

		newBullet.effect = {[0] = 0}

		newBullet.towerIndex = towerIndex
	end
	insertElement(bullets, newBullet)
	return towers, bullets
end

--탄이 몹에 맞았을때의 대미지 처리, 맞춘 newBullet과 bullet 테이블에서의 newBullet의 index를 인자로 넣음
function hitBullet(newBullet, bulletIndex, towers, mobs, bullets)
	--local target = newBullet.target
	local bulletType = newBullet.bulletType

	if newBullet.target.state == 'removed' then
		newBullet.render:dispose()
		removeElement(bullets, bulletIndex)
		--magun.log('removed target')
		return towers, mobs, bullets
	end

	local nearMob
	local nearMobLength

	if bulletType == 'normal' then
		if newBullet.target.exist then
			newBullet.target.HP = newBullet.target.HP - newBullet.damage
		end
		--magun.log('HP: ' .. newBullet.target.HP)
	elseif bulletType == 'radial' then
		if newBullet.target.exist then
			newBullet.target.HP = newBullet.target.HP - newBullet.damage
			--magun.log('attack!' .. newBullet.target.HP)
		end
		nearMob = mobInRange(mobs, newBullet.target, newBullet.splashRange)
		nearMobLength = arrayLength(nearMob)
		--magun.log('nearMob' .. nearMobLength)
		for i = 0, (nearMobLength - 1) do
			if nearMob[i].exist then
				nearMob[i].HP = nearMob[i].HP - newBullet.splashDamage
				--magun.log('splash!' .. nearMob[i].HP)
			end
		end
	end
	
	if bulletType == 'radial' then
		for i = 0, (nearMobLength - 1) do
			if nearMob[i].HP <= 0 and nearMob[i].mobIndex ~= newBullet.target.mobIndex then
				local index = getMobIndex(mobs, nearMob[i].mobIndex)

				local towerAryIndex = existTowerSlot(towers)
				for index, j in ipairs(towerAryIndex) do
					if towers[j].attackTarget ~= nil and towers[j].attackTarget.mobIndex == nearMob[i].mobIndex then
						towers[j].attackTarget = nil
						magun.log('remove splash target')
					end
				end
				local bulletAryLength = arrayLength(bullets)
				for j = 0, (bulletAryLength - 1) do
					if bullets[j].target.mobIndex == nearMob[i].mobIndex then
						bullets[j].target = {mobIndex = bullets[j].target.mobIndex, pos = vec2(bullets[j].target.pos.x, bullets[j].target.pos.y) , state = 'removed'}
					end
				end

				mobs[index].render:dispose()
				mobs[index].HPbar.render:dispose()
				mobs[index].exist = false

				removeElement(mobs, index)
			end
		end
	end

	if newBullet.target.HP <= 0 then
		local index = getMobIndex(mobs, newBullet.target.mobIndex)
		--local target = newBullet.target
		--newBullet.target = nil

		local bulletAryLength = arrayLength(bullets)
		for i = 0, (bulletAryLength - 1) do
			if bullets[i].target.mobIndex == newBullet.target.mobIndex and not compareTable(newBullet, bullets[i]) then
				bullets[i].target = {mobIndex = bullets[i].target.mobIndex, pos = vec2(bullets[i].target.pos.x, bullets[i].target.pos.y) , state = 'removed'}
			end
		end

		
		magun.log('index: ' .. index)
		mobs[index].render:dispose()
		mobs[index].HPbar.render:dispose()
		mobs[index].exist = false

		removeElement(mobs, index)
		towers[newBullet.towerIndex].attackTarget = nil
	end



	newBullet.render:dispose()
	removeElement(bullets, bulletIndex)
	return towers, mobs, bullets
end

--몹 죽울 때 몹의 index를 줄여주던지 해야하나? -> mobs에서 remove시키니 괜찮은 것 같기도 하고