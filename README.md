# mastermind
Mastermind is a game where you have to guess your opponent’s secret code within a certain number of turns.

Each turn you get some feedback about how good your guess was – 
whether it was exactly correct or just the correct color but in the wrong space.

Game is played from the command line and a player has 12 turns to guess the secret code. 
Same color can be used in a code multiple times and there is no blanks.

---------------------------------------------------------------------------------------------------------

Mastermind module holds all the classes, methods and constants needed for this project.

---------------------------------------------------------------------------------------------------------

Player class holds the player's name and number of guesses left. Initialized number of guesses
is always 12.

It has overriden #to_s method to print some information about the player.
Player can choose between being the creator or the guesser. It's his role.

Player also needs a capability of generating code.

---------------------------------------------------------------------------------------------------------

Computer class holds randomly instance variable code. Code is generated with #make_code instance method.
Computer also holds number of guesses so we can keep track when computer is the one guessing.

It has overriden #to_s method so the code can be eventualy printed.

---------------------------------------------------------------------------------------------------------

Board class holds a board_status instance variable. That is an array of arrays 
(inner arrays representing each round of guesses).

---------------------------------------------------------------------------------------------------------

Game class contains all the logic for the game to be played. User is first prompted for his name 
and welcomed. Then, computer chooses a code for the game and user is prompted to enter his guess
until he guesses correctly or he uses all of his 12 attempts.
After every guess, there is a check and user is told about correctness of his attempts.

Instance method won? checks if the user guessed correctly.

Instance method over? checks if the user wasted all of his attempts

Instance method intro prompts user and greets him. Also, 
it asks user if he's taking on a role of a creator or a guesser.
If user is a guesser, computer will generate a code.

Instance method play plays the game until the user won or missed all attempts.
User has to enter one of the existing colors.
After every acceptable guess, user receives information about his guess.
Message he receives looks something like this: "1 ON TARGET, 2 CLOSE"

If the user accepts creator role, then the computer needs to play the game instead.
Computer randomly guesses 12 times.

---------------------------------------------------------------------------------------------------------