-- hand = table of 5 digits
-- card = numbers, 0-9.

Hand = {}

function clone(t)
	return {table.unpack(t)}
end

function findKey(t, v)
	for k,v2 in pairs(t) do
		if v == v2 then return k end
	end
	return nil	
end

function tableWithout(t, v)
	local t2 = {}
	for k,v2 in pairs(t) do
		if v ~= v2 then table.insert(t2, v2) end
	end
	return t2
end

function Hand.parse(handString)
	local hand = {}
	for digit in handString:gmatch('%d') do
		table.insert(hand, tonumber(digit))
	end
	table.sort(hand, function(a,b) return a > b end)
	return hand
end

function Hand.score(hand)
	local l = #hand
	hand = clone(hand)
	table.sort(hand, function(a,b) return a > b end)

	local valueHighCard = function(hand)
		local sum = 0
		for i, rank in ipairs(hand) do
			sum = sum + 11^(l-i) * (rank+1)
		end
		return sum
	end

	local valueFourOfAKind = function(hand)
		local c = getCountsTable(hand)
		local fourRank = findKey(c, 4)+1
		local oneRank = findKey(c, 1)+1
		return 11*fourRank + oneRank
	end

	local valueFullHouse = function(hand)
		local c = getCountsTable(hand)
		local threeRank = findKey(c, 3)+1
		local twoRank = findKey(c, 2)+1
		return 11*threeRank + twoRank
	end

	local valueThreeOfAKind = function(hand)
		local c = getCountsTable(hand)
		local threeRank = findKey(c, 3)+1
		local handWithoutThreeRank = tableWithout(hand, threeRank)

		return 11^3*threeRank + valueHighCard(handWithoutThreeRank)
	end

	local valueTwoPair = function(hand)
		local c = getCountsTable(hand)
		local lowPair = findKey(c, 2)+1
		c[lowPair-1] = 0
		local highPair = findKey(c, 2)+1
		local singleRank = findKey(c, 1)+1
		if (lowPair > highPair) then
			local x = lowPair
			lowPair = highPair
			highPair = x
		end

		return 11^3*highPair + 11^2*lowPair + singleRank
	end

	local valuePair = function(hand)
		local c = getCountsTable(hand)
		local pairRank = findKey(c, 2)+1
		local handWithoutPairRank = tableWithout(hand, pairRank)

		return 11^4*pairRank + valueHighCard(handWithoutPairRank)
	end

	local getBaseValue = function(i)
		return 11^(l + 2) * i
	end

	if (Hand.isFiveOfAKind(hand)) then
		return getBaseValue(7) + hand[1]
	elseif (Hand.isFourOfAKind(hand)) then
		return getBaseValue(6) + valueFourOfAKind(hand)
	elseif (Hand.isFullHouse(hand)) then
		return getBaseValue(5) + valueFullHouse(hand)
	elseif (Hand.isStraight(hand)) then
		return getBaseValue(4) + valueHighCard(hand)
	elseif (Hand.isThreeOfAKind(hand)) then
		return getBaseValue(3) + valueThreeOfAKind(hand)
	elseif (Hand.isTwoPair(hand)) then
		return getBaseValue(2) + valueTwoPair(hand)
	elseif (Hand.isPair(hand)) then
		return getBaseValue(1) + valuePair(hand)
	else
		return valueHighCard(hand) 
	end
end

function Hand.name(hand)
	local c = getCountsTable(hand)
	if (Hand.isFiveOfAKind(hand)) then
		return string.format('Five of a kind (%ds)', hand[1])
	elseif (Hand.isFourOfAKind(hand)) then
		local rank = findKey(c, 4)
		return string.format('Four of a kind (%ds)', rank)
	elseif (Hand.isFullHouse(hand)) then
		local threeRank = findKey(c, 3)
		local twoRank = findKey(c, 2)
		return string.format('Full house (%ds on %ds)', threeRank, twoRank)
	elseif (Hand.isStraight(hand)) then
		return string.format('Straight (%d high)', hand[1])
	elseif (Hand.isThreeOfAKind(hand)) then
		local threesRank = findKey(c, 3)
		return string.format('Three of a kind (%d)', threesRank)
	elseif (Hand.isTwoPair(hand)) then
		local lowPair = findKey(c, 2)
		c[lowPair] = 0
		local highPair = findKey(c, 2)
		if (lowPair > highPair) then
			local x = lowPair
			lowPair = highPair
			highPair = x
		end
		return string.format('Two pair (%ds and %ds)', highPair, lowPair)
	elseif (Hand.isPair(hand)) then
		local pairRank = findKey(c, 2)
		return string.format('Pair (%ds)', pairRank)
	else
		return string.format('High card (%d high)', hand[1])
	end
end	

function Hand.isFiveOfAKind(hand)
	return  hand[1] == hand[2] and 
			hand[1] == hand[3] and 
			hand[1] == hand[4] and
			hand[1] == hand[5]
end

function Hand.isFourOfAKind(hand)
	for i=0,9 do
		local c = 0
		for _, v in ipairs(hand) do
			if v == i then
				c = c + 1
			end
		end
		if (c == 4) then
			return true
		end
	end
	return false
end

function getCountsTable(hand)
	local c = {}
	for i=0,9 do
		for _, v in ipairs(hand) do
			if v == i then
				c[i] = c[i] and c[i] + 1 or 1
			end
		end
	end
	return c
end

function Hand.isFullHouse(hand)
	local c = getCountsTable(hand)

	local has3OfAKind = false
	local has2OfAKind = false
	for _, v in pairs(c) do
		if v == 2 then has2OfAKind = true end
		if v == 3 then has3OfAKind = true end
	end

	return has3OfAKind and has2OfAKind and #hand == 5
end

function Hand.isStraight(hand)
	-- should already be sorted
	local hand2 = clone(hand)
	table.sort(hand2)
	for i=2,#hand do
		if hand2[i] ~= hand2[i-1] + 1 then return false end
	end
	return true
end

function Hand.isThreeOfAKind(hand)
	local c = getCountsTable(hand)

	local has3OfAKind = false
	for _, v in pairs(c) do
		if v == 3 then has3OfAKind = true end
	end

	return has3OfAKind and not Hand.isFullHouse(hand)
end

function Hand.isTwoPair(hand)
	local c = getCountsTable(hand)

	local numPairs = 0
	for _, v in pairs(c) do
		if v == 2 then numPairs = numPairs + 1 end
	end

	return numPairs == 2
end

function Hand.isPair(hand)
	local c = getCountsTable(hand)

	local numPairs = 0
	for _, v in pairs(c) do
		if v == 2 then numPairs = numPairs + 1 end
	end

	return numPairs == 1
end

return Hand