# frozen_string_literal: true

require 'rspec'

require_relative '../lib/game'

RSpec.describe Game do
  context 'when using the default initialization' do
    subject(:default_init) { described_class.new }

    describe '#initialize' do
      describe 'board' do
        let(:board) { default_init.board }

        it 'is an array' do
          expect(board).to be_an(Array)
        end

        it 'has 7 rows' do
          expect(board.size).to eq(7)
        end

        it 'has rows of size 6' do
          board.each { |row| expect(row.size).to eq(6) }
        end
      end

      describe 'current_player' do
        let(:current_player) { default_init.current_player }

        it 'should be Y' do
          expect(current_player).to eq('Y')
        end
      end
    end
  end

  describe '#place_chip' do
    context 'when in a new empty game' do
      subject(:empty_game) { described_class.new }
      let(:current_player) { empty_game.current_player }
      let(:column) { 0 }

      it 'drops the chip all the way down' do
        expect { empty_game.place_chip(column) }.to change { empty_game.board[column].first }.to(current_player)
      end

      it 'does nothing if column is out of bounds' do
        out_of_bounds = empty_game.board.size
        expect { empty_game.place_chip(out_of_bounds) }.not_to change { empty_game.board }
      end

      it 'switches current player' do
        next_player = 'R'
        expect { empty_game.place_chip(column) }.to change { empty_game.current_player }.to(next_player)
      end
    end

    context 'when in an existing game' do
      context 'when one column is full' do
        let(:one_col_full) { [
          ['Y', 'R', 'Y', 'R', 'Y', 'R'], # First column is full
          [nil, nil, nil, nil, nil, nil], # Second column
          [nil, nil, nil, nil, nil, nil], # Third column
          [nil, nil, nil, nil, nil, nil], # Fourth column
          [nil, nil, nil, nil, nil, nil], # Fifth column
          [nil, nil, nil, nil, nil, nil], # Sixth column
          [nil, nil, nil, nil, nil, nil]  # Seventh column
        ] }
        subject(:game) { described_class.new(one_col_full) }

        it 'should not change the board' do
          expect { game.place_chip(0) }.not_to change { game.board }
        end

        it 'should not update current player' do
          expect { game.place_chip(0) }.not_to change { game.current_player }
        end
      end
    end

    context 'when placing a winning move' do
      context 'when winning in a column' do
        let(:board) { [
          ['Y', 'Y', 'Y', nil, nil, nil], # First column: one move away from 'Y' winning
          ['R', 'R', 'R', nil, nil, nil], # Second column
          [nil, nil, nil, nil, nil, nil], # Third column
          [nil, nil, nil, nil, nil, nil], # Fourth column
          [nil, nil, nil, nil, nil, nil], # Fifth column
          [nil, nil, nil, nil, nil, nil], # Sixth column
          [nil, nil, nil, nil, nil, nil]  # Seventh column
        ]}
        subject(:game) { described_class.new(board, 'Y') }
        it 'should update winner to Y' do
          expect { game.place_chip(0) }.to change { game.winner }.to('Y')
        end
      end

      context 'when winning in a row' do
        let(:board) { [
          ['Y', nil, nil, nil, nil, nil], # First column
          ['Y', nil, nil, nil, nil, nil], # Second column
          ['Y', nil, nil, nil, nil, nil], # Third column
          [nil, nil, nil, nil, nil, nil], # Fourth column: one move away from 'Y' winning
          ['R', nil, nil, nil, nil, nil], # Fifth column
          ['R', nil, nil, nil, nil, nil], # Sixth column
          ['R', nil, nil, nil, nil, nil]  # Seventh column
        ]}
        subject(:game) { described_class.new(board, 'Y') }
        it 'should update winner to Y' do
          expect { game.place_chip(3) }.to change { game.winner }.to('Y')
        end
      end

      context 'when winning in a diagonal ltr' do
        let(:board) { [
          ['Y', nil, nil, nil, nil, nil],        # First column
          ['R', 'Y', nil, nil, nil, nil],        # Second column
          ['R', 'R', 'Y', nil, nil, nil],        # Third column
          ['R', 'R', 'R', nil, nil, nil],        # Fourth column, one move away from 'Y' winning diagonally
          [nil, nil, nil, nil, nil, nil],        # Fifth column
          [nil, nil, nil, nil, nil, nil],        # Sixth column
          [nil, nil, nil, nil, nil, nil]         # Seventh column
        ]}
        subject(:game) { described_class.new(board, 'Y') }
        it 'should update winner to Y' do
          expect { game.place_chip(3) }.to change { game.winner }.to('Y')
        end
      end

      context 'when winning in a diagonal rtl' do
        let(:board) { [
          [nil, nil, nil, nil, nil, nil],        # First column
          [nil, nil, nil, nil, nil, nil],        # Second column
          [nil, nil, nil, nil, nil, nil],        # Third column
          ['R', 'R', 'R', nil, nil, nil],        # Fourth column, one move away from 'Y' winning diagonally
          ['R', 'R', 'Y', nil, nil, nil],        # Fifth column
          ['R', 'Y', nil, nil, nil, nil],        # Sixth column
          ['Y', nil, nil, nil, nil, nil]         # Seventh column
        ]}
        subject(:game) { described_class.new(board, 'Y') }
        it 'should update winner to Y' do
          expect { game.place_chip(3) }.to change { game.winner }.to('Y')
        end
      end
    end

    context 'when the game ends in a tie' do
      let(:board) { [
        ['Y', 'R', 'Y', 'R', 'Y', 'R'], # First column
        ['R', 'Y', 'R', 'Y', 'R', 'Y'], # Second column
        ['Y', 'R', 'Y', 'R', 'Y', 'R'], # Third column
        ['R', 'Y', 'R', 'Y', 'R', 'Y'], # Fourth column
        ['Y', 'R', 'Y', 'R', 'Y', 'R'], # Fifth column
        ['R', 'Y', 'R', 'Y', 'R', 'Y'], # Sixth column
        ['Y', 'R', 'Y', 'R', 'Y', nil]  # Seventh column, one slot left
      ]}
      subject(:game) { described_class.new(board, 'Y') }

      it 'should update winner to T for a tie' do
        expect { game.place_chip(6) }.to change { game.winner }.to('T')
      end
    end
  end
end
