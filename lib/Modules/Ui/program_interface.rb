module Ui
  class ProgramInterface
    def run_and_get_input
      welcome_user
      stop_code_from_user
    end

    def output(data)
      puts data
    end

    private

    def welcome_user
      puts 'Welcome to busboard!'
      puts '!!!!!!!Woohoo!!!!!!!'
    end

    def stop_code_from_user
      puts 'Please enter a stop code.'
      gets.chomp
    end
  end
end