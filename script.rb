=begin

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

Computer class holds randomly instance variable code. Code is genereted with #make_code instance method.
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
=end

module Mastermind
    COLORS = ['black', 'white', 'red', 'blue', 'green', 'yellow']

    class Player
        attr_accessor :name, :number_of_guesses, :role, :code
        def initialize(name = "Unknown")
            @name = name
            @number_of_guesses = 0
            @role = "guesser"
            @code = []
        end

        def make_code
            4.times do |i| 
                puts ""
                loop do 
                    puts "Select your #{i + 1}. color: "  
                    user_input = gets.chomp
                    if COLORS.include?(user_input) 
                        code.push(user_input)
                        break
                    end
                end
            end

            code
        end

        def to_s
            puts "Player #{name} has #{number_of_guesses} guesses left."
        end
    end

    class Computer
        attr_reader :code 
        attr_accessor :number_of_guesses
        def initialize
            @code = []
            @number_of_guesses = 0
        end

        # generate random code from possible colors. There can be repeats.
        def make_code
            @code = []
            4.times {code.push(COLORS.sample)}
            code
        end

        def to_s
            "#{code[0]} | #{code[1]} | #{code[2]} | #{code[3]}"
        end
    end

    class Board
        attr_reader :board_status
        def initialize
            # Empty array of 12 arrays
            @board_status = Array.new(12) { [] }
        end

        def to_s 
            12.times do |i|
                puts "------------------------------"
                puts "#{board_status[i][0]} | #{board_status[i][1]} | #{board_status[i][2]} | #{board_status[i][3]}"
            end
        end
    end

    class Game
        attr_reader :board, :player, :computer
        attr_accessor :current_guess
        def initialize
            @board = Board.new
            @player = Player.new
            @computer = Computer.new
            @current_guess = ""
        end

        def player_won?
            board.board_status.any? {|guesses| guesses == computer.code} 
        end
            
        def player_over?
            player.number_of_guesses == 12
        end

        def computer_won?
            board.board_status.any? {|guesses| guesses == player.code}
        end

        def computer_over?
            computer.number_of_guesses == 12
        end

        def intro
            puts "Please enter your name: "
            player.name = gets.chomp
            puts "Hello, #{player.name} and welcome to MASTERMIND!"
            puts ""

            user_input = ""
            loop do 
                puts "Select your role: creator or guesser?"  
                user_input = gets.chomp
                if user_input == "creator" || user_input == "guesser"
                    break
                end
            end
            player.role = user_input

            if (player.role == "guesser")
                puts "When prompted, please enter your code. You have these colors at your disposal: "
                puts COLORS.join("  ")
                puts ""
                sleep(1)

                puts "Computer will now randomly select a code..."
                computer.make_code
                puts ""
                sleep(1)
            elsif (player.role == "creator")
                player.make_code
                puts ""
                "Computer will now play the game..."
                puts ""
                sleep(1)
            end

        end

        def check_guess
            # User guess is => board.board_status[player.number_of_guesses - 1]
            # Computer code is => computer.code

            on_target = on_target(computer.code, board.board_status[player.number_of_guesses - 1])
            close = same(computer.code, board.board_status[player.number_of_guesses - 1]) - on_target
            
            puts ""
            puts "#{on_target} ON TARGET"
            puts "#{close} CLOSE"
            puts ""
        end

        def play
            intro

            if player.role == "guesser"
                until player_won? || player_over?
                    puts "Guess #{player.number_of_guesses+1} of 12"
                    escape = false                           # Use this to escape from current iteration of the parent loop
                    4.times do |i|
                        @current_guess = gets.chomp 
                        escape = true unless COLORS.include?(current_guess)
                        if escape
                            puts "Invalid command!!!"
                            puts ""
                            break
                        end
                        board.board_status[player.number_of_guesses][i] = current_guess
                    end
                    if escape
                        next
                    end
                    player.number_of_guesses += 1
                    board.to_s
                    puts ""

                    check_guess
                end

                if player_won?
                    puts "Congratulations #{player.name}, you cracked the code in #{player.number_of_guesses} attempts!"
                elsif player_over?
                    puts "Sorry #{player.name}, you are out of attempts :("
                end    

            elsif player.role == "creator"
                # First computer's guess is completely randomized
                puts "Guess #{computer.number_of_guesses + 1} of 12"
                board.board_status[computer.number_of_guesses] = computer.make_code
                computer.number_of_guesses += 1
                board.to_s
                until computer_won? || computer_over?
                    puts "Guess #{computer.number_of_guesses + 1} of 12"
                    board.board_status[computer.number_of_guesses] = computer.make_code
                    computer.number_of_guesses += 1
                    board.to_s
                    puts ""
                end

                if computer_won?
                    puts "Too bad, computer has managed to crack your code in #{computer.number_of_guesses} attempts!"
                elsif computer_over?
                    puts "Well done, #{player.name}. Your code was unbreakable."
                end
            end
        end
    end

    def on_target(code, guess)
        code.zip(guess).count {|i| i.inject(:eql?)}
    end

    def same(code, guess)
        same = 0
        code_copy = []
        code_copy.replace(code)
        guess.each_with_index do |item, index|
            next unless code_copy.include?(guess[index])
            code_copy.delete_at(code_copy.find_index(item))
            same += 1
        end

        same
    end
end

include Mastermind

game = Game.new
game.play