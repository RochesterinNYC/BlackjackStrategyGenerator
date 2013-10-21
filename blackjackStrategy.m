function[houseEdge] = blackjackStrategy(numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations)

end
%------------------------------------------------------------------
%setDeck Function
%Recreates a deck with all cards intact
function[] = setDeck(numDecks)
  decks(:, :) = 4;
  decks(10, :) = 16;
end
%------------------------------------------------------------------
%dealCard Function
%Deals a card that can be specified as by random, random non ace or of a specific value of random suit
%No input arguments is deal random card
%One input argument is nonAce indication (varagin{1} is whether a non ace card is to be randomly dealt)
%Two input arguments is dealing a specific value card of a random suit with varagin{2} indicating the value
function[cardValue] = dealCard(varagin)
  validCardPicked = 0;
  while ~validCardPicked
    suit = floor(rand(1)* 4) + 1;
    %seeking to specific value card
    if length(varagin) == 2
      cardValue = varagin{2};
    %seeking to deal nonace card
    else if length(varagin) == 1 && varagin{1}
      cardValue = floor(rand(1)* 9) + 2;
    %seeking to deal random card
    else
      cardValue = floor(rand(1)* 10) + 1;
    end
    if decks(cardValue, suit) ~= 0
      validCardPicked = 1;
    end
  end
  %remove card from deck since it was dealt
  decks(cardValue, suit) = decks(cardValue, suit) - 1;
end
%------------------------------------------------------------------
%createPlayerHand Function
%Uses number value relationships between the order of the player hand types and the hand/card values desired
function createPlayerHand[playerHand] = createPlayerHand(handType)
  %Regular, non-soft, non-paired hand
  playerHand = [];
  if handType >= 1 && handType < 18
    playerHand[1, end + 1] = deal(1);
    playerHand[1, end + 1] = deal(1, (handType + 4) - sum(playerHand));
  %is Soft Hand (has an ace)
  else if handType >= 18 && handType < 26
    playerHand[1, end + 1] = deal(0, 1);
    playerHand[1, end + 1] = deal(1, handType - 16);
  %is Paired Hand (pairs)
  else if handType >= 26 && handType < 36
    playerHand[1, end + 1] = deal(1, handType - 25);
    playerHand[1, end + 1] = deal(1, handType - 25);
  end
end
%------------------------------------------------------------------
%handSum Function
%Calculates sum of hand (necessary to have function because of special nature of aces)
function[handValue] = handSum(hand) 
  if(min(dealerHand) == 1)
    %number of aces in hand does not matter since only one ace can have a value of 11 instead of 1 (two aces with value of 11 is 22 hand total)
    if sum(hand) + 10 <= 21
      handValue = sum(hand) + 10;
    else
      handValue = sum(hand); 
    end
  else
    handValue = sum(hand);
  end
end