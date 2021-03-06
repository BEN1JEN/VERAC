local tileset = {}

function tileset:new()
	return setmetatable({
		uuids = {},
		indexable = {}
	}, {__index=tileset})
end

local tile = {}

function tile:draw(scale, x, y)
	love.graphics.draw(self.texture, x+self.offset.x*scale, y+self.offset.y*scale, 0, scale/8)
end

function tileset:add(uuid, texture, origin, boxCollide, extraCollide, renderRule)
	local texImage = love.graphics.newImage(texture)
	assert(texImage:getWidth() % 8 == 0 and texImage:getHeight() % 8 == 0, "Texture size not a multiple of 8x8.")
	texImage:setFilter("linear", "nearest")
	self.uuids[uuid] = setmetatable({
		uuid = uuid,
		texture = texImage,
		offset = {x=-origin.x, y=-origin.y},
		collide = boxCollide,
		decoCollide = extraCollide,
		renderRule = renderRule,
		width = texImage:getWidth()/8-1,
		height = texImage:getHeight()/8-1,
	}, {__index=tile})
	table.insert(self.indexable, self.uuids[uuid])
end

function tileset:loadAssetPack(pack)
	local packMetadata = require("assets." .. tostring(pack) .. ".metadata")
	for _, v in ipairs(packMetadata) do
		self:add(v.uuid, "assets/" .. tostring(pack) .. v.texture, v.center, v.collisionOnBlock, v.collisionOnExtra, v.renderRule or "")
	end
end

function tileset:draw(uuid, scale, x, y)
	assert(self.uuids[uuid], "Tile UUID does not exist.")
	self.uuids[uuid]:draw(scale, x, y)
end

return tileset
