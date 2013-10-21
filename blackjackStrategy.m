function[houseEdge] = blackjackStrategy(numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations)

end
%------------------------------------------------------------------
%setDeck Function
%Recreates a deck with all cards intact
function[] = setDeck(numDecks)
  decks(:, :) = 4;
  decks(10, :) = 16;
end