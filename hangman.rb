require 'yaml'
save_file_name = "save.txt"

class GameState
    attr_reader :guessed_letters
    def initialize(word_array =  nil, guessed_letters = [], wrong_guesses = 0)
        @word_array = word_array
        
        @guessed_letters = guessed_letters
        @wrong_guesses = wrong_guesses
    end

    def to_yaml
        YAML.dump({
            :word_array => @word_array,
            :guessed_letters => @guessed_letters,
            :wrong_guesses => @wrong_guesses
        })
    end
    def self.from_yaml(string)
        data = YAML.load string
        self.new(data[:word_array], data[:guessed_letters], data[:wrong_guesses])
    end

    def new_game()
        words_file_name = "words-list.txt"
        words_file = File.open(words_file_name, "r")
        viable_words = words_file.readlines.map {|line| line.chomp}
        words_file.close()
        words = viable_words.select {|word| word.length > 4 && word.length < 13}
        word = words.sample()
        @guessed_letters = []
        @word_array = word.split("")
    end
    def show_word
        @word_array.each do |letter|
            if @guessed_letters.include?(letter)
                print letter
            else
                print " _ "
            end
        end
        print "\n"
    end

    def new_guess(letter)
        if(@guessed_letters.include?(letter))
            puts "You already guessed that one"
        end
        if(@word_array.include?(letter))
            puts "Correct"
        else
            puts "Wrong"
            @wrong_guesses += 1
        end
        @guessed_letters << letter
    end

    def is_solved?
        @word_array.all? { |letter| @guessed_letters.include?(letter) }
   
    end
end

game = GameState.new()


if File.exists?(save_file_name)
    puts "You have a saved game, would you like to load it? (y/n)"
    option = gets[0].downcase
    if(option == "y")
        save_file = File.open(save_file_name, "r")
        game = GameState.from_yaml(save_file.read)
        save_file.close()
        puts "Game successfuly loaded!"
    else
        
        game.new_game
    end
else
    game.new_game
end


while true do
    game.show_word

    puts "\nWhat letter will you guess?"
    input = gets.chomp
    if input == "save"
        f = File.open(save_file_name, "w")
        f.print(game.to_yaml)
        f.close()
        puts "Game successfully saved"
        break
    else
        new_letter = input[0].downcase
        game.new_guess(new_letter)
    end
    if game.is_solved?
        puts "You win"
        break
    end
end




