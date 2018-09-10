return {
	towerSlotNum = 4, -- 타워 슬롯의 개수
	color = {
		transparent = c4(255, 255, 255, 0), 
		white = c4(255, 255, 255, 255), 
		white_alpha = c4(255, 255, 255, 140), 
		red_alpha = c4(255, 50, 50, 140), 
		gray = c4(150, 150, 180, 255), 
		black = c4(0, 0, 0, 255), 
		black_alpha = c4(0, 0, 0, 140)
	},
	layer = { -- 값이 클수록 위쪽 레이어
		route = 0.1, 
		towerFrame = 0.27, 
		towerSlot = 0.28, 
		tower = 0.5, 
		bullet = 0.4, 
		range = 0.3, 
		mob = 0.25, 
		mobHP = 0.251, 
		UIBackground = 0.7, 
		UIImage = 0.71, 
		UIText = 0.72, 
		rotateDirBtn = 0.1
	}, 
	config = {
		rotate = 1 -- 반시계/시계방향 회전 설정
	}, 
	rotateVelocity = 2, -- 타워 틀 회전속도
	rotateMaxGauge = 180, -- 타워 이동 게이지 최대치
	totalLifeNum = 25, --전체 라이프 수
	totalWaveNum = 10, -- 전체 웨이브 수
	resourcePerStage = 1, -- 한 웨이브가 끝났을 때 들어오는 자원
	startResource = 1, 
	rightUIState = { -- 오른쪽 UI가 어떤 상황인지
		normal = 1, 
		towerBuild = 2, 
		towerUpgrade = 2.5,
		towerUpgrade_s1 = 3, 
		towerUpgrade_m1 = 4, 
		towerUpgrade_s2a = 5, 
		towerUpgrade_s2b = 6, 
		towerUpgrade_m2a = 7, 
		towerUpgrade_m2b = 8
	}
}