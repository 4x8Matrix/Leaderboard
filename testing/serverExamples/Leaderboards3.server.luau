local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local LeaderboardTemplate = ReplicatedStorage:WaitForChild("LeaderboardTemplate");
local Leaderboard = require(ReplicatedStorage:WaitForChild("Leaderboard"));

type TopData = {Leaderboard.TopData};

-- Constants
local Key = "Gold10";
local Leaderboards = {
	-- Test for rolling
	["15MinutesRolling"] = {60 * 15, `15MinutesRolling-{Key}`}, -- 15 minutes rolling leaderboard
	["30MinutesRolling"] = {60 * 30, `30MinutesRolling-{Key}`}, -- 30 minutes rolling leaderboard
};
local GoldLeaderboard = Leaderboard.new(Leaderboards, {
	Automation = true,
	Interval = 120,
	RecordCount = 100, -- You can also do {Daily = 50, Weekly = 50, Monthly = 50, AllTime = 100}
});

local function UpdateBoard(data: TopData, model: Model)
	-- Remove current items
	for _, v in model.BoardPart.UI.List:GetChildren() do
		if (not v:IsA("GuiObject")) then continue end;
		v:Destroy();
	end;

	-- Add new items
	for i, v in data do
		local item = LeaderboardTemplate:Clone();
		item.Name = `Item-${i}`;
		item.Rank.Text = v.Rank;
		item.Username.Text = `{v.Username}`;
		item.LayoutOrder = i
		item["Value"].Text = v.Value;
		item.LayoutOrder = v.Rank;
		item.Parent = model.BoardPart.UI.List;
	end;
end
local function IncrementGoldTest()
	for _, player in Players:GetPlayers() do
		GoldLeaderboard:IncrementValues(Leaderboards, player.UserId, 111);
	end;

	-- Test userIds
	local FakeId1, FakeId2 = 100, 101;
	GoldLeaderboard:IncrementValues(Leaderboards, FakeId1, 100);
	GoldLeaderboard:IncrementValues(Leaderboards, FakeId2, 100);

	-- Larger scale test
	for _ = 1, 10 do
		GoldLeaderboard:IncrementValues(Leaderboards, math.random(1, 10000000), math.random(1, 35345));
	end;
end

GoldLeaderboard.Updated:Connect(function(boards)
	-- Returns us a table of all the boards that were updated
	for _, board in boards do
		print(`[Gold] Updating board {board.Type} - with {#board.Data} items!`);
		UpdateBoard(board.Data, workspace.Test3.Leaderboards[board.Type]);
	end;

	-- Increment
	IncrementGoldTest();
end);
-- GoldLeaderboard.BoardUpdated:Connect(function(board)
-- 	print(board.Type, board.Data);
-- end);