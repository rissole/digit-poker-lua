local Hand = require('digitpoker')

assert(Hand.score(Hand.parse('52938')) == (11^4*10 + 11^3*9 + 11^2*6 + 11^1*4 + 11^0*3));

assert(Hand.isFiveOfAKind(Hand.parse('11111')))
assert(Hand.isFiveOfAKind(Hand.parse('11112')) == false)

assert(Hand.isFourOfAKind(Hand.parse('11112')))
assert(Hand.isFourOfAKind(Hand.parse('21111')))
assert(Hand.isFourOfAKind(Hand.parse('11211')))
assert(Hand.isFourOfAKind(Hand.parse('11111')) == false)
assert(Hand.isFourOfAKind(Hand.parse('11122')) == false)

assert(Hand.isFullHouse(Hand.parse('11122')))
assert(Hand.isFullHouse(Hand.parse('51515')))
assert(Hand.isFullHouse(Hand.parse('22121')))
assert(Hand.isFullHouse(Hand.parse('22111')))
assert(Hand.isFullHouse(Hand.parse('11322')) == false)
assert(Hand.isFullHouse(Hand.parse('12222')) == false)
assert(Hand.isFullHouse(Hand.parse('00000')) == false)

assert(Hand.isStraight(Hand.parse('12345')))
assert(Hand.isStraight(Hand.parse('01234')))
assert(Hand.isStraight(Hand.parse('56789')))
assert(Hand.isStraight(Hand.parse('56788')) == false)
assert(Hand.isStraight(Hand.parse('67890')) == false)

assert(Hand.isThreeOfAKind(Hand.parse('02001')))
assert(Hand.isThreeOfAKind(Hand.parse('19099')))
assert(Hand.isThreeOfAKind(Hand.parse('22201')))
assert(Hand.isThreeOfAKind(Hand.parse('00987')) == false)
assert(Hand.isThreeOfAKind(Hand.parse('21111')) == false)
assert(Hand.isThreeOfAKind(Hand.parse('22111')) == false)

assert(Hand.isTwoPair(Hand.parse('00199')))
assert(Hand.isTwoPair(Hand.parse('13139')))
assert(Hand.isTwoPair(Hand.parse('00011')) == false)
assert(Hand.isTwoPair(Hand.parse('12345')) == false)
assert(Hand.isTwoPair(Hand.parse('11345')) == false)
assert(Hand.isTwoPair(Hand.parse('000111')) == false)

assert(Hand.isPair(Hand.parse('00192')))
assert(Hand.isPair(Hand.parse('91231')))
assert(Hand.isPair(Hand.parse('91211')) == false)
assert(Hand.isPair(Hand.parse('99211')) == false)

assert(Hand.score(Hand.parse('00000')) > Hand.score(Hand.parse('99998')))
assert(Hand.score(Hand.parse('11111')) > Hand.score(Hand.parse('00000')))
assert(Hand.score(Hand.parse('11112')) > Hand.score(Hand.parse('11110')))
assert(Hand.score(Hand.parse('10000')) > Hand.score(Hand.parse('99988')))
assert(Hand.score(Hand.parse('65432')) > Hand.score(Hand.parse('33312')))

assert(Hand.score(Hand.parse('88999')) > Hand.score(Hand.parse('88899')))
assert(Hand.score(Hand.parse('11199')) > Hand.score(Hand.parse('11100')))
assert(Hand.score(Hand.parse('11199')) > Hand.score(Hand.parse('99987')))
assert(Hand.score(Hand.parse('99987')) > Hand.score(Hand.parse('88897')))
assert(Hand.score(Hand.parse('11123')) > Hand.score(Hand.parse('00012')))
assert(Hand.score(Hand.parse('99110')) > Hand.score(Hand.parse('88770')))
assert(Hand.score(Hand.parse('99110')) > Hand.score(Hand.parse('99001')))
assert(Hand.score(Hand.parse('11009')) > Hand.score(Hand.parse('11003')))
assert(Hand.score(Hand.parse('11009')) > Hand.score(Hand.parse('11203')))
assert(Hand.score(Hand.parse('11009')) > Hand.score(Hand.parse('11203')))
assert(Hand.score(Hand.parse('11039')) > Hand.score(Hand.parse('11038')))
assert(Hand.score(Hand.parse('11039')) > Hand.score(Hand.parse('00138')))
assert(Hand.score(Hand.parse('00123')) > Hand.score(Hand.parse('98764')))

print(Hand.name(Hand.parse('99999')))
print(Hand.name(Hand.parse('61234')))
print(Hand.name(Hand.parse('00123')))
print(Hand.name(Hand.parse('44661')))
print(Hand.name(Hand.parse('77712')))
print(Hand.name(Hand.parse('00099')))
print(Hand.name(Hand.parse('88881')))
print(Hand.name(Hand.parse('74586')))

-- generate all possible 2 pair hands
local lastHand
for p1=9,0,-1 do
	for p2=9,0,-1 do
		if (p1 <= p2) then goto p2continue end
		for r=9,0,-1 do
			if (p1 == r or p2 == r) then goto rcontinue end
			local hand = {p1, p1, p2, p2, r}
			if (lastHand) then
				assert(Hand.score(hand) < Hand.score(lastHand), Hand.formatHand(hand) .. ' > ' .. Hand.formatHand(lastHand))
			end
			lastHand = hand
			::rcontinue::
		end
		::p2continue::
	end
end

-- generate all possible pair hands
lastHand = nil
for p1=9,0,-1 do
	for r1=9,0,-1 do
		for r2=9,0,-1 do
			for r3=9,0,-1 do
				if (p1 == r1 or p1 == r2 or p1 == r3 or r1 == r2 or r1 == r3 or r1 == r3
					or r1 <= r2 or r2 <= r3) then goto rcontinue end
				local hand = {p1, p1, r1, r2, r3}
				if (lastHand) then
					assert(Hand.score(hand) < Hand.score(lastHand), Hand.formatHand(hand) .. ' > ' .. Hand.formatHand(lastHand))
				end
				lastHand = hand
				::rcontinue::
			end
		end
	end
end