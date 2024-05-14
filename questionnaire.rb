# Require PStore:- This line imports the PStore library, which provides a simple way to store data.
require 'pstore'

# Define the Survey Class:- The Survey class encapsulates the functionality for conducting a survey.

class Survey

  # Initialize Method:- This method is for initial state of a Survey object. It initializes instance variables for the survey questions, responses, and the PStore database.

  def initialize
    @questions = [
      "Question first: Did you enjoy the survey?",
      "Question second: Did you find it helpful?",
      "Question third: Would you recommend it to a friend?"
    ]
    @responses = []
    @database = PStore.new("survey_responses.pstore")
  end

  # Run Method:- run method runs the survey. It iterates over each question, prompts the user for a response, validates the response, collects the responses, calculates the rating for this run, and calculates the average rating across all runs.


  def run
    @questions.each do |question|
      puts question
      answer = gets.chomp.downcase
      until ['yes', 'no', 'y', 'n'].include?(answer)
        puts "Invalid answer. Please enter 'Yes' or 'No'."
        answer = gets.chomp.downcase
      end
      @responses << (answer == 'yes' || answer == 'y')
    end

    calculate_the_rating
    calculate_average_rating
  end

  private

  # Calculate Rating Method:- This method calculates the rating for the current run of the survey. It counts the number of 'yes' responses, calculates the rating as a percentage, and prints it to the console.


  def calculate_the_rating
    num_yes = @responses.count(true)
    rating = (num_yes.to_f / @questions.length) * 100
    puts "Rating for this run: #{rating.round(2)}%"
  end

  # Calculate Average Rating Method:- This method calculates the average rating across all runs of the survey. It retrieves the total number of 'yes' responses and total number of questions from the PStore database, updates them with the current run's data, calculates the average rating, and prints it to the console.


  def calculate_average_rating
    total_yes = @database.transaction { @database.fetch(:total_yes, 0) }
    total_questions = @database.transaction { @database.fetch(:total_questions, 0) }

    total_yes += @responses.count(true)
    total_questions += @questions.length

    @database.transaction do
      @database[:total_yes] = total_yes
      @database[:total_questions] = total_questions
    end

    average_rating = (total_yes.to_f / total_questions) * 100
    puts "Average rating across all runs: #{average_rating.round(2)}%"
  end
end

# Create Object for Survey class and Run Survey:- This code creates a new Survey object and runs the survey using the run method.


survey = Survey.new
survey.run
