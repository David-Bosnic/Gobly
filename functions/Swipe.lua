local netChange = 1
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
                copium.fillAmount = copium.fillAmount - 0.05
            elseif swipeDirection == "right" then
                copium.fillAmount = copium.fillAmount + 0.05
            end
            swipeDirection = ""
        end
    end
end
