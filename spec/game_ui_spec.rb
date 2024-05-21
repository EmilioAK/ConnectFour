# spec/game_ui_spec.rb
require 'rspec'
require_relative '../lib/game'
require_relative '../lib/game_ui'

RSpec.describe GameUI do
  let(:game_class) { class_double("Game") }
  let(:game_instance) { instance_double("Game") }
  let(:game_ui) { GameUI.new(game_class) }

  before do
    allow(game_class).to receive(:new).and_return(game_instance)
    allow(game_instance).to receive(:winner).and_return(nil, 'R')
    allow(game_instance).to receive(:current_player).and_return('R')
    allow(game_instance).to receive(:board).and_return([
                                                         [nil, nil, nil, nil, nil, nil, nil],
                                                         [nil, nil, nil, nil, nil, nil, nil],
                                                         [nil, nil, nil, nil, nil, nil, nil],
                                                         [nil, nil, nil, nil, nil, nil, nil],
                                                         [nil, nil, nil, nil, nil, nil, nil],
                                                         [nil, nil, nil, nil, nil, nil, nil]
                                                       ])
  end

  describe '#play' do
    before do
      allow(game_ui).to receive(:display_board)
      allow(game_ui).to receive(:puts)
      allow(game_ui).to receive(:get_column).and_return(3)
      allow(game_instance).to receive(:place_chip)
    end

    it 'displays the board' do
      expect(game_ui).to receive(:display_board).at_least(:once)
      game_ui.play
    end

    it 'displays the current player' do
      expect(game_ui).to receive(:puts).with("Current player: R")
      game_ui.play
    end

    it 'gets a column and places a chip' do
      expect(game_ui).to receive(:get_column).and_return(3)
      expect(game_instance).to receive(:place_chip).with(3)
      game_ui.play
    end

    it 'announces the game result' do
      allow(game_instance).to receive(:winner).and_return('R')
      expect(game_ui).to receive(:puts).with("Red wins!")
      game_ui.play
    end
  end

  describe '#valid_column?' do
    it 'returns true for valid column numbers' do
      expect(game_ui.send(:valid_column?, '3')).to be true
      expect(game_ui.send(:valid_column?, '0')).to be true
      expect(game_ui.send(:valid_column?, '6')). to be true
    end

    it 'returns false for invalid column numbers' do
      expect(game_ui.send(:valid_column?, '7')).to be false
      expect(game_ui.send(:valid_column?, '-1')).to be false
      expect(game_ui.send(:valid_column?, 'a')).to be false
    end
  end

  describe '#rotate_board' do
    it 'rotates the board correctly' do
      board = [
        [nil, 'R', nil, nil, nil, nil, nil],
        [nil, 'Y', nil, nil, nil, nil, nil],
        [nil, 'R', nil, nil, nil, nil, nil],
        [nil, 'Y', nil, nil, nil, nil, nil],
        [nil, 'R', nil, nil, nil, nil, nil],
        [nil, 'Y', nil, nil, nil, nil, nil]
      ]
      rotated_board = game_ui.send(:rotate_board, board)
      expect(rotated_board).to eq([
                                    [nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil],
                                    ['R', 'Y', 'R', 'Y', 'R', 'Y'],
                                    [nil, nil, nil, nil, nil, nil]
                                  ])
    end
  end
end