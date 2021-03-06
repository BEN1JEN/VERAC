local mode = {}

function mode.new()
	return setmetatable({stateModules={}, stateClasses={}, state="start"}, {__index=mode})
end

function mode:create(state, ...)
	self.stateClasses[state] = new(state, ...)
end

function mode:switch(state)
	self.state = state
	assert(self.stateClasses[state], "Switched to " .. tostring(state) .. " before it was created.")
end

function mode:update(...)
	self.stateClasses[self.state]:update(...)
end

function mode:draw(...)
	self.stateClasses[self.state]:draw(...)
end

return mode
