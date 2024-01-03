TIMERS = {}

function startTimers()
    TIMERS.npcs = SetTimer("NPCLoop", 100, 1);
    TIMERS.crafting = SetTimer("CraftingLoop", 100, 1);
    TIMERS.buffs = SetTimer("BuffsLoop", 100, 1);
    TIMERS.itemrespawn = SetTimer("ItemRespawnLoop", 1000, 1);
    TIMERS.hpupdate = SetTimer("HPLoop", 100, 1);
end