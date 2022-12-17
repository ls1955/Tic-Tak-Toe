# frozen_string_literal: false

require_relative '../tic_tac_toe.rb'

describe Game do
  describe '#run' do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:intro).and_return(nil)
      allow(game).to receive(:round).and_return(nil)
      allow(game).to receive(:outro).and_return(nil)
    end

    it 'sent message to intro at beginning of game' do
      expect(game).to receive(:intro).once

      game.run
    end

    it 'sent message to round during the game' do
      expect(game).to receive(:round)

      game.run
    end

    it 'sent message to outro at the end of game' do
      expect(game).to receive(:outro).once

      game.run
    end
  end

  describe '#game_over?' do
    subject(:game) { described_class.new }

    it 'is game over when top row equals to "X" "X" "X"' do
      game.board.layout[0].map! { 'X' }

      expect(game).to be_game_over
    end

    it 'is game over when top row equals to "O" "O" "O"' do
      game.board.layout[0].map! { 'O' }

      expect(game).to be_game_over
    end

    it 'is game over when first column equals to "X" "X" "X"' do
      game.board.layout.length.times do |row|
        game.board.layout[row][0] = 'X'
      end

      expect(game).to be_game_over
    end

    it 'is game over when last column equals to "O" "O" "O"' do
      game.board.layout.length.times do |row|
        game.board.layout[row][-1] = 'O'
      end

      expect(game).to be_game_over
    end
  end
end