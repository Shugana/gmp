TIMERS = {}

function startTimers()
    TIMERS.npcs = SetTimer("NPCloop", 100, 1);
    TIMERS.crafting = SetTimer("CraftingLoop", 100, 1);
    TIMERS.buffs = SetTimer("BuffsLoop", 250, 1);
end