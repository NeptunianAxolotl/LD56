-- Pentatonic polyrhythm generator
-------------------------------------

-- General theory:
-- Pitch collection of N notes, drawn from the harmonic series (i.e. the fundamental, then the first harmonic, second, etc.)
-- Ten rhythm generators: one at a base (defined) BPM, and each at an indexed multiple of that tempo (so 2 times tempo, 3 times etc. through to 10)
-- Each rhythm generator has continuously variable volume from 0.0 to 1.0

-- Process - executed once per tick of the slowest rhythm generator:
-- 1. Histogram the input value (to be determined) from the entities in the game (since the last tick of the slowest rhythm generator).
--    The histogram is to have N buckets, divided across a predefined range.
-- 2. Assign each bucket to each one of the rhythm generators, lowest to highest.
-- 3. Scale the value of all buckets such that the highest bucket has a value of 1.0.  Assign these values as the volumes of the rhythm generators.
-- 4. Assign notes to the rhythm generators, lowest to highest, SKIPPING BUCKETS WITH ZERO VOLUME. (This may result in higher pitches not occuring and is expected.)
-- 5. Schedule timers to play all the notes until the next tick of the slowest rhythm generator.

local self = {}
local api = {}
local cosmos

local tempo = 30 -- BPM of the slowest rhythm generator
local rhythmGeneratorCount = 16 -- how many rhythm generators to define
local tuningConstant = 1.0 -- Multiplier for the base sample to set it to the correct pitch
local noteEvents = {} -- Table to store cued note events
local soundSources = {} -- Sound sources at particular harmonics

local notePath = "resources/sounds/music/marimba-note-a#.ogg" -- Path to the note sound effect

local musicTimer = -1

function api.computePolyrhythm(newTempo, newCount)
  -- Reconfigure the rhythm generator
  tempo = newTempo or tempo
  rhythmGeneratorCount = newCount or rhythmGeneratorCount
  
  -- TODO: HISTOGRAM CALCULATION - HARDCODED FOR NOW - SHOULD BE SENSITIVE TO RHYTHMGENERATORCOUNT AND GAME VALUES
  local histogram = {
      [1] = 10,
      [2] = 5,
      [3] = 7,
      [4] = 1,
      [5] = 5,
      [6] = 0,
      [7] = 0,
      [8] = 0,
      [9] = 0,
      [10] = 0,
      [11] = 0,
      [12] = 0,
      [13] = 0,
      [14] = 0,
      [15] = 0,
      [16] = 0
    }
    
  local maxKey = 0
  local maxValue = 0
  
  for k,v in pairs(histogram) do
    if v > maxValue then
      maxKey = k
      maxValue = v
      end
    end
    
    local scalingFactor = 1 / maxValue
    
    for k,v in pairs(histogram) do
      histogram[k] = v * scalingFactor
      end
  
  -- Completely reinitialize the sequencer
  noteEvents = {}
  musicTimer = tempo / 60
  
  local harmonic = 0 -- Initial value - we would never truly use a "zeroth" harmonic
  
  -- Plot out all the notes per harmonic
  for k, v in pairs(histogram) do
    -- Do we need to plot a harmonic for this histogram at all?  Only if volume is nonzero.
    if v > 0 then
      harmonic = harmonic + 1
      
      -- Load a sound source for this harmonic if required.
      if soundSources[harmonic] == nil then
        soundSources[harmonic] = love.audio.newSource(notePath,"static")
        soundSources[harmonic]:setPitch(harmonic * tuningConstant) -- set tuning for this source (once-off)
      end
      
      soundSources[harmonic]:setVolume(v) -- set volume as required
      
      -- Set the sound to play N times every tick of the slowest rhythm generator
      for i=1,harmonic,1 do
        local noteEvent = {}
        noteEvent.source = soundSources[harmonic]
        noteEvent.played = false
        noteEvent.delay = musicTimer - ((i-1) * musicTimer / harmonic)
        table.insert(noteEvents,noteEvent)
        end
      end
    end
  
  
end

function api.Update(dt)
  musicTimer = musicTimer - dt
  
  -- Play notes if unplayed and due
  for k,v in pairs(noteEvents) do
      if v.played == false and v.delay <= musicTimer then
        v.source:play()
        noteEvents[k].played = true
    end
  end
  
  if musicTimer <= 0 then
    api.computePolyrhythm(tempo,rhythmGeneratorCount)
  end
end

function api.Initialize(newCosmos)
	self = {}
	cosmos = newCosmos
	api.computePolyrhythm(tempo,rhythmGeneratorCount) -- UNCOMMENT WHEN READY
end

return api
