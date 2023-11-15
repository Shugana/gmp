TIMERS = {}

function startTimers()
    TIMERS.npcs = SetTimer("NPCloop", 100, 1);
    TIMERS.crafting = SetTimer("CraftingLoop", 100, 1);
end