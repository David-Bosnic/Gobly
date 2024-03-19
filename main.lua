function love.load()
    cage = love.graphics.newImage("assets/cage.png")
    background = love.graphics.newImage("assets/background.png")
    dreamDate = love.graphics.newImage("assets/DreamDate.png")
    copiumBar = love.graphics.newImage("assets/CopiumBar.png")
    sound = love.audio.newSource("assets/Bop.mp3", "static")
    love.audio.play(sound)
    love.mouse.setVisible(false)
    io.stdout:setvbuf("no")
    love.window.setMode(1920, 1080, { resizable = true, vsync = 0, minwidth = 400, minheight = 300 })
    local offset = 190
    phone = {
        x = love.graphics.getWidth() / 6 - 260 - offset,
        y = love.graphics.getHeight() / 6 - 100,
        img = love.graphics.newImage("assets/Gobly.png")
    }
    finger = {
        position = {
            x = 0,
            y = 0,
        },
        size = {
            x = 20,
            y = 100,
        },
        img = love.graphics.newImage("assets/finger.png"),
    }
    copium = {
        position = {
            x = love.graphics.getWidth() / 2 - 50 - offset,
            y = love.graphics.getHeight() / 2 - 120,
        },
        size = {
            x = 440,
            y = 40,
        },
        fillAmount = 0.5,
    }
    photo = {
        position = {
            x = love.graphics.getWidth() / 2 - offset,
            y = love.graphics.getHeight() / 2,
        },
        size = {
            x = 200,
            y = 450,
        },
        img = {
            Head = {
                lHair = love.graphics.newImage("assets/Head-1.png"),
                bald  = love.graphics.newImage("assets/Head-2.png"),
                mHair = love.graphics.newImage("assets/Head-3.png"),
            },
            Body = {
                bandit = love.graphics.newImage("assets/Body-1.png"),
                knight = love.graphics.newImage("assets/Body-2.png"),
                darklord = love.graphics.newImage("assets/Body-3.png"),
            },
            Legs = {
                mLeg = love.graphics.newImage("assets/Legs-1.png"),
                sLeg = love.graphics.newImage("assets/Legs-2.png"),
                lLeg = love.graphics.newImage("assets/Legs-3.png"),
            },
        }
    }
    for i = 1, 10, 1 do
        photo.img[i] = i
    end
    stillDown = false
    currentPhoto = love.math.random(10)
    requiredTrait = 0
    newTargetTrait()
end

function love.update(dt)
    finger.position.x, finger.position.y = love.mouse.getPosition()
    finger.position.x = finger.position.x - 250
    finger.position.y = finger.position.y - 120

    copiumSystem(dt)
    if love.keyboard.isScancodeDown("q") then
        love.event.quit()
    end
    swipe()
end

local netChange = 0
local mouseDownPos = 0
local mouseUpPos = 0
local swipeDirection = ""
local stillDown = false
function swipe()
    if love.mouse.isDown(1) and stillDown == false then
        mouseDownPos = love.mouse.getX()
        stillDown = true
    elseif stillDown == true then
        mouseUpPos = love.mouse.getX()
        netChange = mouseDownPos - mouseUpPos
        if netChange >= 1 then
            swipeDirection = "left"
        elseif netChange <= -1 then
            swipeDirection = "right"
        end
        if love.mouse.isDown(1) == false then
            stillDown = false
            netChange = 0
            if swipeDirection == "left" then
                -- copium.fillAmount = copium.fillAmount - 0.05
                currentPhoto = love.math.random(10)
                switchTrait()
            elseif swipeDirection == "right" then
                -- copium.fillAmount = copium.fillAmount + 0.05
                currentPhoto = love.math.random(10)
                checkResult()
                switchTrait()
            end
            swipeDirection = ""
        end
    end
end

local currentTraits = {
    Head = love.math.random(3),
    Body = love.math.random(3),
    Legs = love.math.random(3),
}
-- local desiredTrait = love.math.random(3)
function switchTrait()
    currentTraits.Head = love.math.random(3)
    currentTraits.Body = love.math.random(3)
    currentTraits.Legs = love.math.random(3)
end

local currentTarget = {
    Head = nil,
    Body = nil,
    Legs = nil,
}
function newTargetTrait()
    currentTarget.Head = love.math.random(3)
    currentTarget.Body = love.math.random(3)
    currentTarget.Legs = love.math.random(3)
end

function checkResult()
    if currentTraits.Head == currentTarget.Head then
        -- print("Head is the same")
        copium.fillAmount = copium.fillAmount + 0.03
    else
        -- print("Head is different")
        copium.fillAmount = copium.fillAmount - 0.03
    end
    if currentTraits.Body == currentTarget.Body then
        -- print("Body is the same")
        copium.fillAmount = copium.fillAmount + 0.03
    else
        -- print("Body is different")
        copium.fillAmount = copium.fillAmount - 0.03
    end
    if currentTraits.Legs == currentTarget.Legs then
        -- print("Legs is the same")
        copium.fillAmount = copium.fillAmount + 0.03
    else
        -- print("Legs is different")
        copium.fillAmount = copium.fillAmount - 0.03
    end

    if copium.fillAmount >= 0.5 then
        copium.fillAmount = 0.5
    end
end

local countdownTime = 1
local counter = 0
local endResult = 0
local tick = 1
function copiumSystem(dt)
    countdownTime = countdownTime - dt
    if countdownTime <= 0 then
        copium.fillAmount = copium.fillAmount - (0.01 * tick)
        countdownTime = countdownTime + 1
        counter = counter + 1
        tick = tick * 1.01
    end
    if copium.fillAmount <= 0 and endResult == 0 then
        endResult = counter
    end
end

function love.draw()
    if copium.fillAmount >= 0 then
        --Color Reset
        love.graphics.setColor(1, 1, 1, 1)
        --Background
        love.graphics.draw(background, 0, 0)
        love.graphics.draw(cage, 0, 0)
        love.graphics.draw(phone.img, phone.x, phone.y, 0, 0.8, 0.8)

        --Target
        love.graphics.draw(dreamDate, love.graphics.getWidth() - 700, love.graphics.getHeight() - 1000, 0, 1.5, 1.5)

        if (currentTarget.Body == 1) then
            love.graphics.draw(photo.img.Body.bandit, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0,
                2,
                2)
        elseif (currentTarget.Body == 2) then
            love.graphics.draw(photo.img.Body.knight, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0,
                2,
                2)
        elseif (currentTarget.Body == 3) then
            love.graphics.draw(photo.img.Body.darklord, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900,
                0,
                2,
                2)
        end

        if (currentTarget.Legs == 1) then
            love.graphics.draw(photo.img.Legs.mLeg, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0, 2,
                2)
        elseif (currentTarget.Legs == 2) then
            love.graphics.draw(photo.img.Legs.sLeg, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0, 2,
                2)
        elseif (currentTarget.Legs == 3) then
            love.graphics.draw(photo.img.Legs.lLeg, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0, 2,
                2)
        end
        if (currentTarget.Head == 1) then
            love.graphics.draw(photo.img.Head.lHair, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0,
                2,
                2)
        elseif (currentTarget.Head == 2) then
            love.graphics.draw(photo.img.Head.mHair, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0,
                2,
                2)
        elseif (currentTarget.Head == 3) then
            love.graphics.draw(photo.img.Head.bald, love.graphics.getWidth() - 500, love.graphics.getHeight() - 900, 0, 2,
                2)
        end

        --Make-a-Goblin
        love.graphics.setColor(1, 1, 1, 1 - (netChange * netChange / 7000))
        if (currentTraits.Body == 1) then
            love.graphics.draw(photo.img.Body.bandit, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        elseif (currentTraits.Body == 2) then
            love.graphics.draw(photo.img.Body.knight, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        elseif (currentTraits.Body == 3) then
            love.graphics.draw(photo.img.Body.darklord, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3,
                3)
        end

        if (currentTraits.Legs == 1) then
            love.graphics.draw(photo.img.Legs.mLeg, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        elseif (currentTraits.Legs == 2) then
            love.graphics.draw(photo.img.Legs.sLeg, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        elseif (currentTraits.Legs == 3) then
            love.graphics.draw(photo.img.Legs.lLeg, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        end
        if (currentTraits.Head == 1) then
            love.graphics.draw(photo.img.Head.lHair, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        elseif (currentTraits.Head == 2) then
            love.graphics.draw(photo.img.Head.mHair, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        elseif (currentTraits.Head == 3) then
            love.graphics.draw(photo.img.Head.bald, photo.position.x + 0 - netChange, photo.position.y - 40, 0, 3, 3)
        end

        --Copium Bar
        love.graphics.setColor(255 / 255, 105 / 255, 180 / 255)
        love.graphics.rectangle("fill", copium.position.x + 140, copium.position.y + 55,
            copium.size.x * copium.fillAmount,
            copium.size.y)
        love.graphics.draw(copiumBar, copium.position.x, copium.position.y, 0, 1.2, 1.2)
        --Finger
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(finger.img, finger.position.x, finger.position.y, 0, 0.5, 0.5)
        love.graphics.setColor(0, 1, 0)

        --Photo Swiping
        love.graphics.setColor(1, 0.5, 0, 1 - (netChange * netChange / 700000))
        if swipeDirection ~= nil then
            -- love.graphics.print(currentPhoto, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        end
        --currentTraits
        -- love.graphics.print("Traits", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        -- love.graphics.print(currentTraits.Head, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 20)
        -- love.graphics.print(currentTraits.Body, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 40)
        -- love.graphics.print(currentTraits.Legs, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 60)
        --currentTarget
        -- love.graphics.print("Targets", love.graphics.getWidth() / 2 + 60, love.graphics.getHeight() / 2)
        -- love.graphics.print(currentTarget.Head, love.graphics.getWidth() / 2 + 60, love.graphics.getHeight() / 2 + 20)
        -- love.graphics.print(currentTarget.Body, love.graphics.getWidth() / 2 + 60, love.graphics.getHeight() / 2 + 40)
        -- love.graphics.print(currentTarget.Legs, love.graphics.getWidth() / 2 + 60, love.graphics.getHeight() / 2 + 60)
    else
        love.graphics.setColor(255 / 255, 105 / 255, 180 / 255)
        love.graphics.print("You succumb to the cope...", love.graphics.getWidth() / 2 - 100,
            love.graphics.getHeight() / 2 - 250, 0, 2, 2)

        love.graphics.print("You lived for"
            , love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 - 200, 0, 2, 2)
        love.graphics.print(endResult .. " seconds"
            , love.graphics.getWidth() / 2 + 146,
            love.graphics.getHeight() / 2 - 200, 0, 2, 2)
        love.graphics.print("You got no matches..."
            , love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 - 300, 0, 2, 2)
        love.graphics.print("press q to quit"
            , love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 - 500, 0, 2, 2)
    end
end
