
local trackData = {
	useAsDurationForAllTracks = 'bgm',
	list = {
		'bgm',
	},
	initialTrack = 'bgm',
	WantTrack = function (cosmos, index)
		return (math.floor(cosmos.GetRealTime()/10)%3 + 1) == index
	end,
}

return trackData
