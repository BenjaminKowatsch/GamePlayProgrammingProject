
-- Table for all global events
Events = {}

-- Global update event
Events.Update = _EventManager:getUpdateEvent()
Events.PostInitialization = _EventManager:getPostInitializationEvent()

function Events.create()
	logMessage("Creating generic event")
	return _EventManager:createGenericEvent()
end
