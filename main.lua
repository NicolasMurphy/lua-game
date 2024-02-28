function love.load()
    player = {}
    player.x = 50
    player.y = 480
    player.width = 40
    player.height = 60
    player.acceleration = 800
    player.maxSpeed = 400
    player.currentSpeed = 0
    player.image = love.graphics.newImage("Rolf_transparent.png")
    player.yVelocity = 0
    player.jumpHeight = -750
    player.gravity = -3000
    player.grounded = false

    player.jumpSound = love.audio.newSource("jump.wav", "static")

    platform = {}
    platform.x = 0
    platform.y = love.graphics.getHeight() - 50
    platform.width = love.graphics.getWidth()
    platform.height = 50

    platforms = {}

    table.insert(platforms, {
        x = 0,
        y = love.graphics.getHeight() - 50,
        width = love.graphics.getWidth(),
        height = 50
    })

    table.insert(platforms, {
        x = 100,
        y = 450,
        width = 120,
        height = 20
    })
    table.insert(platforms, {
        x = 350,
        y = 350,
        width = 100,
        height = 20
    })
    table.insert(platforms, {
        x = 590,
        y = 250,
        width = 80,
        height = 20
    })
    table.insert(platforms, {
        x = 350,
        y = 150,
        width = 60,
        height = 20
    })
    table.insert(platforms, {
        x = 130,
        y = 50,
        width = 40,
        height = 20
    })
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        player.currentSpeed = math.max(player.currentSpeed - player.acceleration * dt, -player.maxSpeed)
        player.x = player.x + player.currentSpeed * dt
    elseif love.keyboard.isDown("right") then
        player.currentSpeed = math.min(player.currentSpeed + player.acceleration * dt, player.maxSpeed)
        player.x = player.x + player.currentSpeed * dt
    else
        player.currentSpeed = 0
    end

    if not player.grounded then
        player.yVelocity = player.yVelocity - player.gravity * dt
    end
    player.y = player.y + player.yVelocity * dt

    local wasGrounded = player.grounded
    player.grounded = false
    for _, platform in ipairs(platforms) do
        if player.x + player.width > platform.x and player.x < platform.x + platform.width and player.y + player.height >=
            platform.y and player.y + player.height < platform.y + platform.height + 1 then
            player.grounded = true
            if not wasGrounded then
                player.y = platform.y - player.height
            end
            player.yVelocity = 0
            break
        end
    end

    if love.keyboard.isDown("space") and wasGrounded then
        player.yVelocity = player.jumpHeight
        player.jumpSound:play()
    end
end

function love.draw()
    local scaleX = player.width / player.image:getWidth()
    local scaleY = player.height / player.image:getHeight()

    love.graphics.draw(player.image, player.x, player.y, 0, scaleX, scaleY)

    love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)

    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    end
end

function resetPlayer()
    player.x = 50
    player.y = 490
    -- player.x = 668
    -- player.y = 200
    player.yVelocity = 0
    player.grounded = false
end

function love.keypressed(key)
    if key == "r" then
        resetPlayer()
    end
end
