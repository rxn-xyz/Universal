getgenv().global = getgenv()

function global.declare(self, index, value)
	self[index] = self[index] or value return self[index]
end

declare(declare(global, "Loop", {}), "Cache", {})

function Loop.new(...)
	local index, func = ...; func = (func or index)
	Loop.Cache[index] = {
		["Enabled"] = true,
		["Function"] = func
	}
	return {
		["Remove"] = function()
			Loop.Cache[index] = nil
		end,
		["Enable"] = function()
			Loop.Cache[index].Enabled = true
		end,
		["Disable"] = function()
			Loop.Cache[index].Enabled = false
		end
	}
end

Loop.Connection = get("RunService").RenderStepped:Connect(function()
	for _, loop in Loop.Cache do
		if loop.Enabled then
			loop.Function()
		end
	end
end)
