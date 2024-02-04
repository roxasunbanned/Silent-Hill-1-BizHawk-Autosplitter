-- Silent Hill 1 AutoSplitter for BizHawk
-- GitHub: https://github.com/BoredOfSpeedruns/Silent-Hill-1-BizHawk-Autosplitter
-- Requires LiveSplit 1.7+
-- Run BizHawk as Admin

local gameAddresses = {
    GAMECODE = 0x9244,
    IGT = 0xBCC84,
    J_IGT = 0xBF1B4,
}

local ntscU = false;

local function init_livesplit()
    pipe_handle = io.open("//./pipe/LiveSplit", "a")

    if not pipe_handle then
        error("\nFailed to open LiveSplit named pipe!\n" ..
              "Please make sure LiveSplit is running and is at least 1.7, " ..
              "then load this script again")
    end

    pipe_handle:write("reset\r\n")
    pipe_handle:flush()
    print("Connected to LiveSplit")

    return pipe_handle
end

local function getIGT()
    local gameID = memory.readbyte(gameAddresses.GAMECODE + 2);
    if(tostring(gameID) == "80") then
        ntscU = false
    else 
        ntscU = true
    end
    if ntscU == true then
        return memory.read_u32_le(gameAddresses.IGT) / 4096
    else
        return memory.read_u32_le(gameAddresses.J_IGT) / 4096
    end
end

local function main()
    print("test");
end

local function sendIGT()
    pipe_handle:write("setgametime " .. getIGT() .. "\r\n")
    pipe_handle:flush()
    return
end

-- Set up our TCP socket to LiveSplit.
pipe_handle = init_livesplit()

memory.usememorydomain("System Bus")

-- Send IGT value to LiveSplit on each frame.
event.onframestart(sendIGT, 0xBCC84)

while true do
    emu.frameadvance()
end