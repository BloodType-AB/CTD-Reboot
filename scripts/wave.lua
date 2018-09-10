--speed는 1초에 가는 거리, start는 시작점 위치(0이 0도E, 1이 90도N, 2가 180도W, 3이 270도S 위치)
return {
	[0] = {
		mobStat = {
			[0] = 
			{HP = 30, speed = 50, start = 3, effect = {[0] = 0}, time = 30, texture = 'Resources/mob_4angle.png'}, 

			{HP = 2, speed = 70, start = 2, effect = {[0] = 0}, time = 80, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 70, start = 2, effect = {[0] = 0}, time = 90, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 70, start = 2, effect = {[0] = 0}, time = 100, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 70, start = 2, effect = {[0] = 0}, time = 110, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 70, start = 2, effect = {[0] = 0}, time = 120, texture = 'Resources/mob_arrow.png'},
			
			{HP = 3, speed = 150, start = 1, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_arrow.png'},
			{HP = 3, speed = 150, start = 1, effect = {[0] = 0}, time = 260, texture = 'Resources/mob_arrow.png'},

			{HP = 5, speed = 100, start = 0, effect = {[0] = 0}, time = 360, texture = 'Resources/mob_3angle.png'}, 
			{HP = 5, speed = 100, start = 0, effect = {[0] = 0}, time = 420, texture = 'Resources/mob_3angle.png'}, 
			{HP = 5, speed = 100, start = 0, effect = {[0] = 0}, time = 480, texture = 'Resources/mob_3angle.png'}
		},


		totalTime = 600, -- totalTime에서 시작해서 1초당 60씩 감소하며 몹의 time과 같은 수치가 됐을때 등장

		info = {
			[0] = 
			'HP: 5, speed: 100\nnumber: 3\nfrom East\n(normal)', 
			'HP: 3, speed: 150\nnumber: 2\nfrom North\n(high speed)', 
			'HP: 2, speed: 70\nnumber: 5\nfrom South\n(large number)', 
			'HP: 30, speed: 50\nnumber: 1\nfrom West\n(high HP)'
		}
	}, 
	[1] = {
		mobStat = {
			[0] = 
			{HP = 1, speed = 200, start = 2, effect = {[0] = 0}, time = 260, texture = 'Resources/mob_arrow.png'},

			{HP = 5, speed = 70, start = 3, effect = {[0] = 0}, time = 220, texture = 'Resources/mob_arrow.png'},
			{HP = 5, speed = 70, start = 1, effect = {[0] = 0}, time = 220, texture = 'Resources/mob_arrow.png'}, 
			{HP = 5, speed = 70, start = 3, effect = {[0] = 0}, time = 260, texture = 'Resources/mob_arrow.png'},
			{HP = 5, speed = 70, start = 1, effect = {[0] = 0}, time = 260, texture = 'Resources/mob_arrow.png'},

			{HP = 3, speed = 100, start = 0, effect = {[0] = 0}, time = 340, texture = 'Resources/mob_3angle.png'},
			{HP = 3, speed = 100, start = 0, effect = {[0] = 0}, time = 380, texture = 'Resources/mob_3angle.png'}, 
			{HP = 3, speed = 100, start = 0, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_3angle.png'},
			{HP = 3, speed = 100, start = 0, effect = {[0] = 0}, time = 440, texture = 'Resources/mob_3angle.png'},

			{HP = 15, speed = 40, start = 2, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_4angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 15, speed: 40\nnumber: 1\nfrom West\n(high HP)', 
			'HP: 3, speed: 100\nnumber: 4\nfrom East\n(normal)', 
			'HP: 5, speed: 70\nnumber: 4\nfrom South,North\n(two direction)', 
			'HP: 1, speed: 200\nnumber: 1\nfrom West\n(high speed)'
		}
	}, 
	[2] = {
		mobStat = {
			[0] = 
			{HP = 5, speed = 70, start = 0, effect = {[0] = 0}, time = 20, texture = 'Resources/mob_3angle.png'}, 
			{HP = 5, speed = 70, start = 0, effect = {[0] = 0}, time = 60, texture = 'Resources/mob_3angle.png'},
			{HP = 5, speed = 70, start = 0, effect = {[0] = 0}, time = 100, texture = 'Resources/mob_3angle.png'}, 
			{HP = 15, speed = 70, start = 0, effect = {[0] = 'life -2'}, time = 140, texture = 'Resources/mob_4angle.png'}, 
			{HP = 5, speed = 70, start = 0, effect = {[0] = 0}, time = 180, texture = 'Resources/mob_3angle.png'},
			{HP = 5, speed = 70, start = 0, effect = {[0] = 0}, time = 220, texture = 'Resources/mob_3angle.png'},
			{HP = 5, speed = 70, start = 0, effect = {[0] = 0}, time = 260, texture = 'Resources/mob_3angle.png'},
			{HP = 15, speed = 70, start = 0, effect = {[0] = 'life -2'}, time = 300, texture = 'Resources/mob_4angle.png'},  

			--{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 430, texture = 'Resources/mob_arrow.png'}, 
			--{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 440, texture = 'Resources/mob_arrow.png'},
			{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 450, texture = 'Resources/mob_arrow.png'}, 
			{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_arrow.png'}, 
			{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 470, texture = 'Resources/mob_arrow.png'},
			{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 480, texture = 'Resources/mob_arrow.png'},
			{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 490, texture = 'Resources/mob_arrow.png'},
			{HP = 3, speed = 100, start = 1, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_arrow.png'},  

			{HP = 10, speed = 100, start = 3, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_3angle.png'},
			{HP = 10, speed = 100, start = 3, effect = {[0] = 0}, time = 540, texture = 'Resources/mob_3angle.png'}, 
			{HP = 10, speed = 100, start = 3, effect = {[0] = 0}, time = 580, texture = 'Resources/mob_3angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 10, speed: 100\nnumber: 3\nfrom South\n(normal)', 
			'HP: 3, speed: 100\nnumber: 6\nfrom North\n(large number)', 
			'HP: 15, speed: 70\nnumber: 2\nfrom East\n(high HP)\nlife -2', 
			'HP: 5, speed: 70\nnumber: 6\nfrom East\n(normal)'
		}
	}, 
	[3] = {
		mobStat = {
			[0] = 
			{HP = 6, speed = 170, start = 2, effect = {[0] = 0}, time = 120, texture = 'Resources/mob_arrow.png'}, 
			{HP = 6, speed = 170, start = 0, effect = {[0] = 0}, time = 180, texture = 'Resources/mob_arrow.png'}, 
			{HP = 6, speed = 170, start = 1, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_arrow.png'},

			{HP = 10, speed = 50, start = 3, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_4angle.png'}, 
			{HP = 10, speed = 50, start = 2, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_4angle.png'},
			{HP = 10, speed = 50, start = 1, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_4angle.png'}, 
			{HP = 10, speed = 50, start = 0, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_4angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 10, speed: 50\nnumber: 4\nfrom all\n(four direction)', 
			'HP: 6, speed: 170\nnumber: 1\nfrom North\n(high speed)', 
			'HP: 6, speed: 170\nnumber: 1\nfrom East\n(high speed)', 
			'HP: 6, speed: 170\nnumber: 1\nfrom West\n(high speed)'
		}
	}, 
	[4] = {
		mobStat = {
			[0] = 
			{HP = 1, speed = 200, start = 0, effect = {[0] = 0}, time = 20, texture = 'Resources/mob_arrow.png'}, 
			{HP = 1, speed = 200, start = 1, effect = {[0] = 0}, time = 20, texture = 'Resources/mob_arrow.png'},
			{HP = 1, speed = 200, start = 2, effect = {[0] = 0}, time = 20, texture = 'Resources/mob_arrow.png'}, 
			{HP = 1, speed = 200, start = 3, effect = {[0] = 0}, time = 20, texture = 'Resources/mob_arrow.png'},
			{HP = 1, speed = 200, start = 0, effect = {[0] = 0}, time = 70, texture = 'Resources/mob_arrow.png'}, 
			{HP = 1, speed = 200, start = 1, effect = {[0] = 0}, time = 70, texture = 'Resources/mob_arrow.png'},
			{HP = 1, speed = 200, start = 2, effect = {[0] = 0}, time = 70, texture = 'Resources/mob_arrow.png'}, 
			{HP = 1, speed = 200, start = 3, effect = {[0] = 0}, time = 70, texture = 'Resources/mob_arrow.png'},

			{HP = 5, speed = 150, start = 2, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_3angle.png'},
			{HP = 5, speed = 150, start = 0, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_3angle.png'},
			{HP = 5, speed = 150, start = 2, effect = {[0] = 0}, time = 300, texture = 'Resources/mob_3angle.png'},
			{HP = 5, speed = 150, start = 0, effect = {[0] = 0}, time = 300, texture = 'Resources/mob_3angle.png'},

			{HP = 2, speed = 100, start = 1, effect = {[0] = 0}, time = 360, texture = 'Resources/mob_arrow.png'}, 
			{HP = 2, speed = 100, start = 1, effect = {[0] = 0}, time = 380, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 100, start = 1, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 100, start = 1, effect = {[0] = 0}, time = 420, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 100, start = 1, effect = {[0] = 0}, time = 440, texture = 'Resources/mob_arrow.png'},
			{HP = 2, speed = 100, start = 1, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_arrow.png'},

			{HP = 50, speed = 20, start = 3, effect = {[0] = 'life -4'}, time = 590, texture = 'Resources/mob_5angle.png'}, 
			{HP = 50, speed = 20, start = 2, effect = {[0] = 'life -4'}, time = 590, texture = 'Resources/mob_5angle.png'}, 
			{HP = 50, speed = 20, start = 1, effect = {[0] = 'life -4'}, time = 590, texture = 'Resources/mob_5angle.png'}, 
			{HP = 50, speed = 20, start = 0, effect = {[0] = 'life -4'}, time = 590, texture = 'Resources/mob_5angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 50, speed: 20\nnumber: 4\nfrom all\n(boss)\nlife -4', 
			'HP: 2, speed: 100\nnumber: 6\nfrom North\n(large number)', 
			'HP: 5, speed: 150\nnumber: 4\nfrom East, West\n(two direction)', 
			'HP: 1, speed: 200\nnumber: 8\nfrom all\n(four direction)'
		}
	}, 
	[5] = {
		mobStat = {
			[0] = 
			{HP = 12, speed = 70, start = 2, effect = {[0] = 0}, time = 120, texture = 'Resources/mob_3angle.png'},
			{HP = 12, speed = 70, start = 2, effect = {[0] = 0}, time = 160, texture = 'Resources/mob_3angle.png'}, 
			{HP = 12, speed = 70, start = 2, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_3angle.png'},
			{HP = 12, speed = 70, start = 2, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_3angle.png'}, 

			{HP = 5, speed = 200, start = 3, effect = {[0] = 0}, time = 280, texture = 'Resources/mob_arrow.png'}, 
			{HP = 5, speed = 200, start = 3, effect = {[0] = 0}, time = 320, texture = 'Resources/mob_arrow.png'}, 
			{HP = 5, speed = 200, start = 3, effect = {[0] = 0}, time = 360, texture = 'Resources/mob_arrow.png'}, 
			{HP = 5, speed = 200, start = 3, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_arrow.png'}, 

			{HP = 28, speed = 100, start = 0, effect = {[0] = 'life -2'}, time = 400, texture = 'Resources/mob_4angle.png'},
			{HP = 28, speed = 100, start = 0, effect = {[0] = 'life -2'}, time = 440, texture = 'Resources/mob_4angle.png'},

			{HP = 8, speed = 100, start = 1, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_3angle.png'}, 
			{HP = 8, speed = 100, start = 1, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_3angle.png'}, 
			{HP = 8, speed = 100, start = 1, effect = {[0] = 0}, time = 540, texture = 'Resources/mob_3angle.png'}, 
			{HP = 8, speed = 100, start = 1, effect = {[0] = 0}, time = 580, texture = 'Resources/mob_3angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 8, speed: 100\nnumber: 4\nfrom North\n(normal)', 
			'HP: 28, speed: 100\nnumber: 2\nfrom East\n(high HP)\nlife -2', 
			'HP: 5, speed: 200\nnumber: 4\nfrom South\n(high speed)', 
			'HP: 12, speed: 70\nnumber: 4\nfrom West\n(normal)'
		}
	}, 
	[6] = {
		mobStat = {
			[0] = 
			{HP = 8, speed = 70, start = 1, effect = {[0] = 0}, time = 140, texture = 'Resources/mob_4angle.png'}, 
			{HP = 8, speed = 70, start = 1, effect = {[0] = 0}, time = 180, texture = 'Resources/mob_4angle.png'},
			{HP = 35, speed = 60, start = 1, effect = {[0] = 'life -3'}, time = 220, texture = 'Resources/mob_5angle.png'}, 
			{HP = 8, speed = 70, start = 1, effect = {[0] = 0}, time = 260, texture = 'Resources/mob_4angle.png'}, 
			{HP = 8, speed = 70, start = 1, effect = {[0] = 0}, time = 300, texture = 'Resources/mob_4angle.png'}, 
			{HP = 35, speed = 60, start = 1, effect = {[0] = 'life -3'}, time = 340, texture = 'Resources/mob_5angle.png'}, 

			{HP = 8, speed = 70, start = 3, effect = {[0] = 0}, time = 380, texture = 'Resources/mob_4angle.png'}, 
			{HP = 8, speed = 70, start = 3, effect = {[0] = 0}, time = 420, texture = 'Resources/mob_4angle.png'},
			{HP = 35, speed = 60, start = 3, effect = {[0] = 'life -3'}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 8, speed = 70, start = 3, effect = {[0] = 0}, time = 500, texture = 'Resources/mob_4angle.png'}, 
			{HP = 8, speed = 70, start = 3, effect = {[0] = 0}, time = 540, texture = 'Resources/mob_4angle.png'}, 
			{HP = 35, speed = 60, start = 3, effect = {[0] = 'life -3'}, time = 580, texture = 'Resources/mob_5angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 8, speed: 70\nnumber: 4\nfrom South\n(normal)', 
			'HP: 35, speed: 60\nnumber: 2\nfrom South\n(high HP)\nlife -3', 
			'HP: 8, speed: 70\nnumber: 4\nfrom North\n(normal)', 
			'HP: 35, speed: 60\nnumber: 8\nfrom North\n(high HP)\nlife -3'
		}
	}, 
	[7] = {
		mobStat = {
			[0] = 
			{HP = 5, speed = 200, start = 2, effect = {[0] = 0}, time = 150, texture = 'Resources/mob_arrow.png'}, 
			{HP = 5, speed = 200, start = 0, effect = {[0] = 0}, time = 150, texture = 'Resources/mob_arrow.png'},
			{HP = 5, speed = 200, start = 2, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_arrow.png'},
			{HP = 5, speed = 200, start = 0, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_arrow.png'},

			{HP = 30, speed = 70, start = 3, effect = {[0] = 'life -3'}, time = 400, texture = 'Resources/mob_5angle.png'},
			{HP = 30, speed = 70, start = 1, effect = {[0] = 'life -3'}, time = 400, texture = 'Resources/mob_5angle.png'},

			{HP = 10, speed = 180, start = 2, effect = {[0] = 0}, time = 420, texture = 'Resources/mob_3angle.png'},
			{HP = 10, speed = 180, start = 1, effect = {[0] = 0}, time = 440, texture = 'Resources/mob_3angle.png'},
			{HP = 10, speed = 180, start = 2, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_3angle.png'},
			{HP = 10, speed = 180, start = 1, effect = {[0] = 0}, time = 480, texture = 'Resources/mob_3angle.png'},

			{HP = 20, speed = 120, start = 0, effect = {[0] = 'life -2'}, time = 540, texture = 'Resources/mob_4angle.png'}, 
			{HP = 20, speed = 120, start = 3, effect = {[0] = 'life -2'}, time = 540, texture = 'Resources/mob_4angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 20, speed: 120\nnumber: 2\nfrom South, East\n(two direction)\nlife -2', 
			'HP: 10, speed: 180\nnumber: 4\nfrom North, West\n(two direction)', 
			'HP: 30, speed: 70\nnumber: 2\nfrom North, South\n(two direction)\nlife -3', 
			'HP: 5, speed: 200\nnumber: 4\nfrom East, West\n(two direction)'
		}
	},
	[8] = {
		mobStat = {
			[0] = 
			{HP = 8, speed = 200, start = 2, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_arrow.png'},
			{HP = 8, speed = 200, start = 2, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_arrow.png'},
			{HP = 8, speed = 200, start = 2, effect = {[0] = 0}, time = 280, texture = 'Resources/mob_arrow.png'},

			{HP = 20, speed = 100, start = 3, effect = {[0] = 'life -2'}, time = 360, texture = 'Resources/mob_4angle.png'},
			{HP = 20, speed = 100, start = 1, effect = {[0] = 'life -2'}, time = 360, texture = 'Resources/mob_4angle.png'},
			{HP = 20, speed = 100, start = 3, effect = {[0] = 'life -2'}, time = 400, texture = 'Resources/mob_4angle.png'},
			{HP = 20, speed = 100, start = 1, effect = {[0] = 'life -2'}, time = 400, texture = 'Resources/mob_4angle.png'},

			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 440, texture = 'Resources/mob_3angle.png'},
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 480, texture = 'Resources/mob_3angle.png'},
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 520, texture = 'Resources/mob_3angle.png'},
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 560, texture = 'Resources/mob_3angle.png'},

			{HP = 50, speed = 70, start = 0, effect = {[0] = 'life -3'}, time = 540, texture = 'Resources/mob_5angle.png'}, 
			{HP = 50, speed = 70, start = 0, effect = {[0] = 'life -3'}, time = 580, texture = 'Resources/mob_5angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 50, speed: 70\nnumber: 2\nfrom East\n(high HP)\nlife -3', 
			'HP: 15, speed: 120\nnumber: 4\nfrom West\n(normal)', 
			'HP: 20, speed: 100\nnumber: 4\nfrom North, South\n(two direction)\nlife -2', 
			'HP: 8, speed: 200\nnumber: 3\nfrom West\n(high speed)'
		}
	}, 
	[9] = {
		mobStat = {
			[0] = 
			{HP = 1, speed = 320, start = 3, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'}, 
			{HP = 1, speed = 320, start = 2, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'},
			{HP = 1, speed = 320, start = 1, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'},
			{HP = 1, speed = 320, start = 0, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'},

			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 160, texture = 'Resources/mob_4angle.png'},
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_4angle.png'}, 
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_4angle.png'}, 
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 280, texture = 'Resources/mob_4angle.png'}, 
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 320, texture = 'Resources/mob_4angle.png'}, 

			{HP = 20, speed = 100, start = 3, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 2, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 1, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 0, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 3, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 2, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 1, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 0, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 

			{HP = 170, speed = 20, start = 3, effect = {[0] = 'life -5'}, time = 540, texture = 'Resources/mob_6angle.png'}, 
			{HP = 170, speed = 20, start = 3, effect = {[0] = 'life -5'}, time = 580, texture = 'Resources/mob_6angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 170, speed: 20\nnumber: 2\nfrom South\n(boss: life -5)', 
			'HP: 20, speed: 100\nnumber: 8\nfrom all\n(four direction)', 
			'HP: 15, speed: 120\nnumber: 5\nfrom West\n(normal)', 
			'HP: 1, speed: 320\nnumber: 4\nfrom all\n(very fast)'
		}
	}, 
	[10] = {
		mobStat = {
			[0] = 
			{HP = 1, speed = 320, start = 3, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'}, 
			{HP = 1, speed = 320, start = 2, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'},
			{HP = 1, speed = 320, start = 1, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'},
			{HP = 1, speed = 320, start = 0, effect = {[0] = 0}, time = 50, texture = 'Resources/mob_arrow_red.png'},

			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 160, texture = 'Resources/mob_4angle.png'},
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 200, texture = 'Resources/mob_4angle.png'}, 
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 240, texture = 'Resources/mob_4angle.png'}, 
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 280, texture = 'Resources/mob_4angle.png'}, 
			{HP = 15, speed = 120, start = 2, effect = {[0] = 0}, time = 320, texture = 'Resources/mob_4angle.png'}, 

			{HP = 20, speed = 100, start = 3, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 2, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 1, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 0, effect = {[0] = 0}, time = 400, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 3, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 2, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 1, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 
			{HP = 20, speed = 100, start = 0, effect = {[0] = 0}, time = 460, texture = 'Resources/mob_5angle.png'}, 

			{HP = 170, speed = 20, start = 3, effect = {[0] = 'life -5'}, time = 580, texture = 'Resources/mob_6angle.png'}, 
			{HP = 170, speed = 20, start = 3, effect = {[0] = 'life -5'}, time = 580, texture = 'Resources/mob_6angle.png'}
		}, 

		totalTime = 600, 

		info = {
			[0] = 
			'HP: 170, speed: 20\nnumber: 2\nfrom East\n(boss: life -5)', 
			'HP: 20, speed: 100\nnumber: 8\nfrom all\n(four direction)', 
			'HP: 15, speed: 120\nnumber: 5\nfrom West\n(normal)', 
			'HP: 1, speed: 320\nnumber: 4\nfrom all\n(very fast)'
		}
	}
}