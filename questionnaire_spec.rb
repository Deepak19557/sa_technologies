require 'rspec'
require_relative 'survey'

RSpec.describe Survey do
  describe '#initialize' do
    it 'creates a new Survey object with empty responses' do
      survey = Survey.new
      expect(survey.instance_variable_get(:@responses)).to eq([])
    end
  end

  describe '#run' do
    let(:input) { StringIO.new("yes\nno\nyes\n") }

    before do
      allow_any_instance_of(Kernel).to receive(:puts)
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*input.readlines.map(&:chomp))
    end

    it 'prompts the user for responses' do
      survey = Survey.new
      survey.run
      expect(survey.instance_variable_get(:@responses)).to eq([true, false, true])
    end

    it 'calculates the rating for the current run' do
      expect_any_instance_of(Survey).to receive(:puts).with(/Rating for this run:/)
      survey = Survey.new
      survey.run
    end

    it 'calculates the average rating across all runs' do
      expect_any_instance_of(Survey).to receive(:puts).with(/Average rating across all runs:/)
      survey = Survey.new
      survey.run
    end
  end
end
