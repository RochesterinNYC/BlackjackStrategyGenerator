function[houseEdge] = blackjackStrategy(numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations)
  %create cell array of every combination (35 rows x 10 columns)
  stratTable = zeros(35, 10)
  [playerHands, dealerCards] = size(stratTable);

  %Create Arrays:
  %playerOptions 1-4 = Respectively Stand, Hit, Double, Split;
  playerOptions = [1, 2, 3, 4]
  playerOptionsWins = zeroes(1, 4);

  %create deck
  %matrix of 10 * 4 (10, J, Q, K are all the same value)
  global decks = zeros(10, 4);
  %creates a big deck of cards that are composed of numDecks decks
  setDeck(numDecks);

  totalWins = 0;

  %Iterate through each combination
  %"Wins" are in terms of money won so winning on a double nets you twice as much money as a regular win would and a blackjack win would net you money equal to blackjack payout rate * what you bet
  for playerHandType = 1:playerHands
    for dealerCard = 1:dealerCards
      playerOptionWins(:, :) = 0;
      for playerOption = 1:playerOptions
        for n = 1:numSimulations
          if playOption == 3 && playRound(playerHandType, dealerCard, playerOption) == 1
            playerOptionWins(playerOption) = playerOptionWins(playerOption) + 2;
          if playRound(playerHandType, dealerCard, playerOption) == 1
            playerOptionWins(playerOption) = playerOptionWins(playerOption) + 1;
          else if playRound(playerHandType, dealerCard, playerOption) == 2
            playerOptionWins(playerOption) = playerOptionWins(playerOption) + blackjackPayout;
          end
        end
      end
      %compareWinFrequencies for player options for the currently matched up scenario
      %and set the appropriate cell matrix equal to the option to choose
      totalWins = totalWins + max(playerOptionWins);
      stratTable(playerHandType, dealerCard)find(playerOptionWins == max(playerOptionWins));
    end
  end

  %generate chart
  houseEdge = totalWins / (numSimulations * 350);
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
%------------------------------------------------------------------
%playRound Function
%Plays a simulated round of blackjack where user has a predefined hand, action to take, and dealer has a faceup card
%Dealer plays as normal 
%playerWon as 0 is loses, 1 is wins, 2 is player blackjack
function[playerWon] = playRound(userHandType, dealerCard, playerAction, standSoft17, doubleAfterSplit)

  playerWon = -1;
  setDeck(numDecks);
  dealerHand = [dealCard(0, dealerCard), dealCard()];
  playerHand = createPlayerHand(userHandType);

  %Both Blackjack (Tie)
  if handSum(userHand) == 21 && handSum(dealerHand) == 21
    playerWon = playRound(userHand, dealerCard, playerAction, standSoft17, doubleAfterSplit);
    return
  end

  %Player Blackjack (Player Win)
  if handSum(userHand) == 21 && handSum(dealerHand) ~= 21
    playerWon = 2;
    return
  end

  %Dealer Blackjack (Player Loss)
  if handSum(userHand) ~= 21 && handSum(dealerHand) == 21
    playerWon = 0;
    return
  end

  %Else play out
  %playerAction == 1, then stand
  if playerAction == 2 || playerAction == 3 %Hit or Double
    playerHand[1, end + 1] = deal();
  end
  if playerAction == 4 %Split
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FIXXXXX
    playerHand[1, end + 1] = deal();
  end

  %tie (push) has no effect on strategic selection or wins vs. loses so play again recursively
  if handSum(userHand) == handSum(dealerHand)
    playerWon = playRound(userHand, dealerCard, playerAction, standSoft17, doubleAfterSplit);
    return
  end

  playerWon = ~(handSum(userHand) > handSum(dealerHand));

end