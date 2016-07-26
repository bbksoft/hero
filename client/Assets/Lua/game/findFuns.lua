
local findFuns = {}

function findFuns.min(fun,actor,actors)
	local findValue = 0
	local findActor = nil

	for k,another in pairs(actors) do

		local value = fun(actor,another)
		if (not findActor) or ( value < findValue) then
			findActor = another
			findValue = value
		end

	end

	return findActor
end

function findFuns.max(fun,actor,actors)
	local findValue = 0
	local findActor = nil

	for k,another in pairs(actors) do

		local value = fun(actor,another)
		if (not findActor) or ( value > findValue) then
			findActor = another
			findValue = value
		end

	end

	return findActor
end

function findFuns.less(a,b)
	return (a < b)
end

function findFuns.less_equal(a,b)
	return (a <= b)
end

function findFuns.greater(a,b)
	return (a > b)
end

function findFuns.greater_equal(a,b)
	return (a >= b)
end

function findFuns.equal(a,b)
	return (a == b)
end

function findFuns.not_equal(a,b)
	return (a ~= b)
end

function findFuns.dis(a,b)
	if g and g.player_pos then
		a = g.player_pos
	end

	return dis_pos(a.pos,b.pos) - a.cfg.radius - b.cfg.radius
end

function findFuns.dis_pos(a,b)
	return dis_pos(g.pos,b.pos) - b.cfg.radius
end


function findFuns.hp(a,b)
	return b.attrs.hp
end

function findFuns.hp_per(a,b)
	return b.attrs.hp / b.attrs.max_hp
end



function findFuns.mark(a,b)
	return (g.mark[b.id] or 0)
end

findFuns[">="] = findFuns.greater_equal
findFuns[">"] = findFuns.greater

findFuns["=="] = findFuns.equal
findFuns["="] = findFuns.equal
findFuns["~="] = findFuns.not_equal

findFuns["<="] = findFuns.less_equal
findFuns["<"] = findFuns.less

return findFuns
