function love.load()
	text = "Honigkuchen"
	a = 0
	nextA = love.timer.getTime()
end

function love.update()
	if nextA < love.timer.getTime() then
		a += 1
		a += 1
		nextA = love.timer.getTime() + 1.0
	end
end

function love.draw()
	for i = 1, 10 do
		love.graphics.printf(text .. " - " .. tostring(a), 0, i*20, 400)
	end
end