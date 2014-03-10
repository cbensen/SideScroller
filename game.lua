-- requires 

local physics = require "physics"
physics.start()

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

-- background

function scene:createScene(event)

    local screenGroup = self.view

    local background = display.newImage("bg.png")
    screenGroup:insert(background)
    background.width = display.contentWidth
    background.height = display.contentHeight
    background.xScale = 2
    background.yScale = 2

    ceiling = display.newImage("invisibleTile.png")
    ceiling.anchorX = 0
    ceiling.anchorY = display.contentHeight
    ceiling.x = 0
    ceiling.y = 0
    physics.addBody(ceiling, "static", {density=.1, bounce=0.1, friction=.2})
    screenGroup:insert(ceiling)
    
    theFloor = display.newImage("invisibleTile.png")
    theFloor.anchorX = 0
    theFloor.anchorY = display.contentHeight
    theFloor.x = 0
    theFloor.y = 340
    physics.addBody(theFloor, "static", {density=.1, bounce=0.1, friction=.2})
    screenGroup:insert(theFloor)
    
    
    city1 = display.newImage("city1.png")
    city1.anchorX = 0
    city1.anchorY = display.contentHeight
    city1.x = 0
    city1.y = 320
    city1.speed = 1
    screenGroup:insert(city1)

    city2 = display.newImage("city1.png")
    city2.anchorX = 0
    city2.anchorY = display.contentHeight
    city2.x = 480
    city2.y = 320
    city2.speed = 1
    screenGroup:insert(city2)

    city3 = display.newImage("city2.png")
    city3.anchorX = 0
    city3.anchorY = display.contentHeight
    city3.x = 0
    city3.y = 320
    city3.speed = 2
    screenGroup:insert(city3)

    city4 = display.newImage("city2.png")
    city4.anchorX = 0
    city4.anchorY = display.contentHeight
    city4.x = 480
    city4.y = 320
    city4.speed = 2
    screenGroup:insert(city4)
    
    local jetOptions = {
       width = 50,
       height = 17,
       numFrames = 4
    }
    local jetSpriteSheet = graphics.newImageSheet( "jet.png", jetOptions )
    local jetSequenceData = {
        name="jets",
        frames= { 1, 2, 3, 4},
        time = 240,
        loopCount = 0
    }
    jet = display.newSprite(jetSpriteSheet, jetSequenceData )
    jet.x = -80
    jet.y = 100
    jet:play()
    jet.collided = false
    physics.addBody(jet, "static", {density=.1, bounce=0.1, friction=.2, radius=12})
    screenGroup:insert(jet)
    jetIntro = transition.to(jet,{time=2000, x=100, onComplete=jetReady})
	
    
    local explosionOptions = {
       width = 24,
       height = 23,
       numFrames = 8
    }
    local explosionSpriteSheet = graphics.newImageSheet( "explosion.png", explosionOptions )
    local explosionSequenceData = {
        name="boom",
        frames= { 1, 2, 3, 4, 5, 6, 7, 8},
        time = 800,
        loopCount = 1
    }
    explosion = display.newSprite(explosionSpriteSheet, explosionSequenceData )
    explosion.x = 100
    explosion.y = 100
    explosion.isVisible = false
    screenGroup:insert(explosion)
	
    mine1 = display.newImage("mine.png")
    mine1.x = 500
    mine1.y = 100
    mine1.speed = math.random(2,6)
    mine1.initY = mine1.y
    mine1.amp = math.random(20,100)
    mine1.angle = math.random(1,360)
    physics.addBody(mine1, "static", {density=.1, bounce=0.1, friction=.2, radius=12})
    screenGroup:insert(mine1)
	
    mine2 = display.newImage("mine.png")
    mine2.x = 500
    mine2.y = 100
    mine2.speed = math.random(2,6)
    mine2.initY = mine2.y
    mine2.amp = math.random(20,100)
    mine2.angle = math.random(1,360)
    physics.addBody(mine2, "static", {density=.1, bounce=0.1, friction=.2, radius=12})
    screenGroup:insert(mine2)
	
    mine3 = display.newImage("mine.png")
    mine3.x = 500
    mine3.y = 100
    mine3.speed = math.random(2,6)
    mine3.initY = mine3.y
    mine3.amp = math.random(20,100)
    mine3.angle = math.random(1,360)
    physics.addBody(mine3, "static", {density=.1, bounce=0.1, friction=.2, radius=12})
    screenGroup:insert(mine3)
end


function ScrollLevel(self,event)
    if self.x < -477 then
        self.x = 480
    else 
        self.x = self.x - self.speed
    end
end

function MoveCharacters(self,event)
    if self.x < -50 then
        self.x = 500
        self.y = math.random(90,220)
        self.speed = math.random(2,6)
        self.amp = math.random(20,100)
        self.angle = math.random(1,360)
    else 
        self.x = self.x - self.speed
        self.angle = self.angle + .1
        self.y = self.amp*math.sin(self.angle)+self.initY
    end
end


function jetReady()
    jet.bodyType = "dynamic"
end

function activateJets(self,event)
    self:applyForce(0, -1.5, self.x, self.y)
    print("run")
end

function touchScreen(event)
    print("touch")
    if event.phase == "began" then
          jet.enterFrame = activateJets
          Runtime:addEventListener("enterFrame", jet)
    end

    if event.phase == "ended" then
          Runtime:removeEventListener("enterFrame", jet)
    end
end

function gameOver()
   storyboard.gotoScene("restart", "fade", 400)
end

function explode()
    explosion.x = jet.x
    explosion.y = jet.y
    explosion.isVisible = true
    explosion:play()
    jet.isVisible = false
    timer.performWithDelay(3000, gameOver, 1)
end


function onCollision(event)
    if event.phase == "began" then
      if jet.collided == false then 
        jet.collided = true
        jet.bodyType = "static"
        explode()
      end
    end
end

function scene:enterScene(event)
    storyboard.purgeScene("start")
    storyboard.purgeScene("restart")

    Runtime:addEventListener("touch", touchScreen)

    city1.enterFrame = ScrollLevel
    Runtime:addEventListener("enterFrame", city1)

    city2.enterFrame = ScrollLevel
    Runtime:addEventListener("enterFrame", city2)

    city3.enterFrame = ScrollLevel
    Runtime:addEventListener("enterFrame", city3)

    city4.enterFrame = ScrollLevel
    Runtime:addEventListener("enterFrame", city4)
    
    mine1.enterFrame = MoveCharacters
    Runtime:addEventListener("enterFrame", mine1)
    
    mine2.enterFrame = MoveCharacters
    Runtime:addEventListener("enterFrame", mine2)
    
    mine3.enterFrame = MoveCharacters
    Runtime:addEventListener("enterFrame", mine3)
    
    Runtime:addEventListener("collision", onCollision)
end

function scene:exitScene(event)
    Runtime:removeEventListener("touch", touchScreen)
    Runtime:removeEventListener("enterFrame", city1)
    Runtime:removeEventListener("enterFrame", city2)
    Runtime:removeEventListener("enterFrame", city3)
    Runtime:removeEventListener("enterFrame", city4)
    Runtime:removeEventListener("enterFrame", mine1)
    Runtime:removeEventListener("enterFrame", mine2)
    Runtime:removeEventListener("enterFrame", mine3)
    Runtime:removeEventListener("collision", onCollision)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene













