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

---------------------------------------------------------------------------------------------------------

Computer class holds randomly instance variable code. Code is genereted with #make_code instance method.

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

Instance method intro just prompts user and greets him.

Instance method play plays the game until the user won or missed all attempts.
User has to enter one of the existing colors.
After every acceptable guess, user receives information about his guess.
Message he receives looks something like this: "1 ON TARGET, 2 CLOSE"

---------------------------------------------------------------------------------------------------------
=end

module Mastermind
    COLORS = ['black', 'white', 'red', 'blue', 'green', 'yellow']

    class Player
        attr_accessor :name, :number_of_guesses
        def initialize(name = "Unknown")
            @name = name
            @number_of_guesses = 0
        end

        def to_s
            puts "Player #{name} has #{number_of_guesses} guesses left."
        end
    end

    class Computer
        attr_reader :code
        def initialize
            @code = []
        end

        # generate random code from possible colors. There can be repeats.
        def make_code
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

        def won?
            board.board_status.any? {|guesses| guesses == computer.code} 
        end
            
        def over?
            player.number_of_guesses == 12
        end

        def intro
            puts "Please enter your name: "
            player.name = gets.chomp
            puts "Hello, #{player.name} and welcome to MASTERMIND!"
            puts ""

            puts "Computer will now randomly select a code..."
            computer.make_code
            puts ""
            sleep(1)

            puts "When prompted, please enter your code. You have these colors at your disposal: "
            puts COLORS.join("  ")
            puts ""
            sleep(1)
        end

        def check_guess
            # User guess is => board.board_status[player.number_of_guesses - 1]
            # Computer code is => computer.code

            on_target = on_target(computer.code, board.board_status[player.number_of_guesses - 1])
            close = same(computer.code, board.board_status[player.number_of_guesses - 1]) - on_target
            
            puts computer.code

            puts ""
            puts "#{on_target} ON TARGET"
            puts "#{close} CLOSE"
            puts ""
        end

        def play
            intro

            until won? || over?
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

            if won?
                puts "Congratulations #{player.name}, you cracked the code in #{player.number_of_guesses} attempts!"
            elsif over?
                puts "Sorry #{player.name}, you are out of attempts :("
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