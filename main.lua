--require
local gc = require "plugin.gamecenter"
local json = require("json")
--attributes
local isLogined = false
local leaderboardId = "insert leaderboard id here"
local achievementId = "insert achievement id here"
local myScore = 123456789
local achievementProgress = 50
--objs
local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
background.alpha = .95
local gamecenterIcon = display.newImageRect( "gamecenter.png", 50, 50 )
gamecenterIcon.x, gamecenterIcon.y = display.contentCenterX+70, display.contentCenterY-210
local gamecenterTitle = display.newText( "Gamecenter test", display.contentCenterX-30, display.contentCenterY-210 , native.systemFont, 18 )
gamecenterTitle:setFillColor( 0 )
local loginStatus = display.newText( "Not logined", display.contentCenterX, display.contentCenterY+220, native.systemFont, 16 )
loginStatus:setFillColor( 0 )
local isAvailable = display.newText( "Is available", display.contentCenterX, display.contentCenterY+190, native.systemFont, 16 )
isAvailable:setFillColor( 0 )
local leaderboardShow = display.newText( "Show Leaderboard", display.contentCenterX, display.contentCenterY+160, native.systemFont, 16 )
leaderboardShow:setFillColor( 0 )
local leaderboardLoad = display.newText( "Load Scores", display.contentCenterX, display.contentCenterY+130, native.systemFont, 16 )
leaderboardLoad:setFillColor( 0 )
local leaderboardLoad2 = display.newText( "Load Score", display.contentCenterX, display.contentCenterY+100, native.systemFont, 16 )
leaderboardLoad2:setFillColor( 0 )
local achievementShow = display.newText( "Show Achievement", display.contentCenterX, display.contentCenterY+70, native.systemFont, 16 )
achievementShow:setFillColor( 0 )
local achievementLoadAll = display.newText( "Load Achievements", display.contentCenterX, display.contentCenterY+40, native.systemFont, 16 )
achievementLoadAll:setFillColor( 0 )
local achievementSubmit = display.newText( "Set progress at 50% on achievement", display.contentCenterX, display.contentCenterY-20, native.systemFont, 16 )
achievementSubmit:setFillColor( 0 )
local achievementReset = display.newText( "Reset progress on achievements", display.contentCenterX, display.contentCenterY-50, native.systemFont, 16 )
achievementReset:setFillColor( 0 )
local challengeShow = display.newText( "Show Challenge", display.contentCenterX, display.contentCenterY-80, native.systemFont, 16 )
challengeShow:setFillColor( 0 )
local challengeLoad = display.newText( "Load Challenges", display.contentCenterX, display.contentCenterY-110, native.systemFont, 16 )
challengeLoad:setFillColor( 0 )
local getPlayerData = display.newText( "Get player data", display.contentCenterX, display.contentCenterY-140, native.systemFont, 16 )
getPlayerData:setFillColor( 0 )
--init
gc.init(function(e)
    print("init")
    print("----------")
    print(json.prettify(e))
    print("----------")
    if(e.status == "signed in") then
        isLogined = true
        loginStatus.text = "Logined"
    end
end)
--touch
isAvailable:addEventListener( "tap", function()
    print(gc.isAvailable())
end )
leaderboardShow:addEventListener( "tap", function()
    print(gc.leaderboards.show(leaderboardId))
end )
leaderboardLoad:addEventListener( "tap", function()
    local function lis(e)
        print("loadScores")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end
    gc.leaderboards.loadScores(leaderboardId, lis,{timeScope = "today", playerScope= "friends"})
end )
leaderboardLoad2:addEventListener( "tap", function()
    gc.leaderboards.submit(leaderboardId, myScore, function(e)
        print("submit score")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end)
end )
achievementShow:addEventListener( "tap", function()
    print(gc.achievements.show())
end )
achievementLoadAll:addEventListener( "tap", function()
    gc.achievements.loadAll(function(e)
        print("achievement loadAll")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end)
end )
achievementSubmit:addEventListener( "tap", function()
    gc.achievements.submit(achievementId, achievementProgress, true,function(e)
        print("achievement submit")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end)
end )
achievementReset:addEventListener( "tap", function()
    gc.achievements.reset(function(e)
        print("achievements reset")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end)
end )
challengeShow:addEventListener( "tap", function()
    print(gc.challenges.show())
end )
challengeLoad:addEventListener( "tap", function()
    gc.challenges.load(function(e)
        print("challenges load")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end)
end )
getPlayerData:addEventListener( "tap", function()
    print("player id")
    print("----------")
    print(gc.player.id())
    print("----------")
    print("player name")
    print("----------")
    print(gc.player.name())
    print("----------")
    gc.player.friends(function(e)
        print("player friends")
        print("----------")
        print(json.prettify(e))
        print("----------")
    end)
end )
--[[
--multiplayer sample
local gamecenter = require "plugin.gamecenter"
local json = require "json"
local widget = require "widget"

local gamecenterSignIn = false
gamecenter.init(function (e)
    if e.status == "signed in" then
        gamecenterSignIn = true
    end
end)
gamecenter.multiplayer.setListener(function (e)
    if e.itIsMyTurn == true then
        endTurn.alpha = 1
    else
        endTurn.alpha = 0
    end
end)
local endTurn
local showInvite= widget.newButton( {
    x = display.contentCenterX,
    y = display.contentCenterY-100,
    label = "Show Invite",
    onRelease = function (  )
       gamecenter.multiplayer.invite(2,4,"Come play now", function(e)
            print(json.encode(e))
            if e.itIsMyTurn == true then
                endTurn.alpha = 1
            else
                endTurn.alpha = 0
            end
       end)
    end
} )
endTurn= widget.newButton( {
    x = display.contentCenterX,
    y = display.contentCenterY-50,
    label = "End Turn",
    onRelease = function (  )
       gamecenter.multiplayer.endTurn({someData="hello there"}, 300, function(e)
            
       end) --300 seconds = 5 minutes to make move
    end
} )
endTurn.alpha = 0
]]--

