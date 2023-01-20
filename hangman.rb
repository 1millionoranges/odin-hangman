
file_name = "words-list.txt"
words_file = File.open(file_name, "r")

viable_words = words_file.readlines.map {|line| line.chomp}
words = viable_words.select {|word| word.length > 4 && word.length < 13}

word = words.sample()

guessed_letters = []
word_array = word.split("")
while true do
    word_array.each do |letter|
        if guessed_letters.include?(letter)
            print letter
        else
            print " _ "
        end
        
    end
    puts "\nWhat letter will you guess?"
    new_letter = gets[0].chomp.downcase
    guessed_letters << new_letter
    if(word_array.all?{|letter| guessed_letters.include?(letter)})
        break
    end
end
p "You win!"