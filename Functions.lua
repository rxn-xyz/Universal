-- New
getgenv().New = (New or {})
-- New | Instance
function New:Instance(Class, Parent, Properties)
	local Instance = Instance.new(Class, Parent) Properties = (Properties or {})
	for Property, Value in Properties do
		pcall(function() Instance[Property] = Value end)
	end
	return Instance
end
-- New | Drawing
function New:Drawing(Class, Properties)
	local Drawing = Drawing.new(Class) Properties = (Properties or {})
	for Property, Value in Properties do
		pcall(function() Drawing[Property] = Value end)
	end
	return Drawing
end
-- Properties
getgenv().Properties = (Properties or {})
-- Properties | Cache
Properties.Cache = (Properties.Cache or {})
-- Properties | Bypass
Properties.Bypass = (Properties.Bypass or hookmetamethod(game, "__index", newcclosure(function(Self, Index)
	if not checkcaller() and Properties.Cache[Self] and Properties.Cache[Self][Index] then
		return Properties.Cache[Self][Index]
	end
	return Properties.Bypass(Self, Index)
end)))
-- Properties | Check
function Properties:Check(Instance, Property)
	local Check = Instance[Property]
end
-- Properties | Change
function Properties:Change(Instance, Properties)
	self.Cache[Instance] = (self.Cache[Instance] or {})
	for Property, Value in Properties do
		local Success = pcall(function() self:Check(Instance, Property) end)
		if Success then
			self.Cache[Instance][Property] = (self.Cache[Instance][Property] or Instance[Property])
			Instance[Property] = Value
		end
	end
end
-- Properties | Revert
function Properties:Revert(Instance)
	if self.Cache[Instance] then
		for Property, Value in self.Cache[Instance] do
			Instance[Property] = Value
		end
	end
	self.Cache[Instance] = nil
end
-- Connections
getgenv().Connections = (Connections or {})
-- Connections | Cache
Connections.Cache = (Connections.Cache or {})
-- Connections
function Connections:Start(Index, Path, Function, Bool)
	self:Stop(Index) 
	if Bool == nil or Bool then
		self.Cache[Index] = Path:Connect(Function) return Index
	end
end
-- Connections
function Connections:Stop(Index)
	if self.Cache[Index] then
		self.Cache[Index]:Disconnect() self.Cache[Index] = nil
	end
end
-- Listener
getgenv().Listener = (Listener or {})
-- Listener | Cache
Listener.Cache = (Listener.Cache or {})
-- Listener | Start
function Listener:Start(Index, Path, Method, Function, Table)
	local Methods = {
		["Child"] = {"GetChildren", "ChildAdded", "ChildRemoved"}, 
		["Descendant"] = {"GetDescendants", "DescendantAdded", "DescendantRemoving"}
	}
	self.Cache[Index] = {Added = (self.Cache[Index].Added or false), Removed = (self.Cache[Index].Removed or false)}
	for _, Instance in Path[Methods[Method][1]](Path) do
		if Function(Instance) then
			table.insert(Table, Instance)
			if self.Cache[Index].Added then self.Cache[Index].Added(Instance) end
		end
	end
	table.insert(self.Cache[Index], Connections:Start(Index.."Added", Path[Methods[Method][2]], function(Instance)
		if Function(Instance) then
			table.insert(Table, Instance)
			if self.Cache[Index].Added then self.Cache[Index].Added(Instance) end
		end
	end))
	table.insert(self.Cache[Index], Connections:Start(Index.."Removed", Path[Methods[Method][3]], function(Instance)
		if table.find(Table, Instance) then
			table.remove(Table, table.find(Table, Instance))
			if self.Cache[Index].Removed then self.Cache[Index].Removed(Instance) end
		end
	end))
end
-- Listener | Stop
function Listener:Stop(Index)
	if self.Cache[Index] then
		for _, Index in self.Cache[Index] do
			Connections:Stop(Index)
		end
		self.Cache[Index] = nil
	end
end
-- Listener | Added
function Listener:Added(Index, Function)
	self.Cache[Index] = (self.Cache[Index] or {Added = false, Removed = false})
	self.Cache[Index].Added = Function
end
-- Listener | Removed
function Listener:Removed(Index, Function)
	self.Cache[Index] = (self.Cache[Index] or {Added = false, Removed = false})
	self.Cache[Index].Removed = Function
end
