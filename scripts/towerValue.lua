return {
	SingleTarget = {
		level1 = {
			maxCoolDown = 60, targetNum = 1, damage = 5, range = 200, effect = {[0] = 0}, 
			explain = 'Single Target Tower', resource = 'Resources/Tower_SingleTarget_1.png'
		}, 
		level2a = { -- 느리고 강한 공격
			maxCoolDown = 90, targetNum = 1, damage = 20, range = 240, effect = {[0] = 0}, 
			explain = 'Single Target Tower', resource = 'Resources/Tower_SingleTarget_2.png'
		}, 
		level2b = { -- 공속 빨라진 대신 dps 2a보다 낮아짐
			maxCoolDown = 30, targetNum = 1, damage = 4, range = 250, effect = {[0] = 0}, 
			explain = 'Single Target Tower', resource = 'Resources/Tower_SingleTarget_2.png'
		}
	}, 
	MultiTarget = {
		level1 = {
			maxCoolDown = 60, targetNum = 1, damage = 2, range = 200, splashDamage = 1, splashRange = 70, effect = {[0] = 0}, 
			explain = 'Shoot Splash Attack', resource = 'Resources/Tower_MultiTarget_1.png'
		}, 
		level2a = { -- 범위는 그대로고 대미지 상승
			maxCoolDown = 75, targetNum = 1, damage = 4, range = 220, splashDamage = 2, splashRange = 70, effect = {[0] = 0}, 
			explain = 'Shoot Splash Attack', resource = 'Resources/Tower_MultiTarget_2.png'
		}, 
		level2b = { -- 메인 대미지는 그대로, 스플래시 대미지, 범위 상승
			maxCoolDown = 60, targetNum = 1, damage = 2, range = 250, splashDamage = 2, splashRange = 120, effect = {[0] = 0}, 
			explain = 'Shoot Splash Attack', resource = 'Resources/Tower_MultiTarget_2.png'
		}
	}
}