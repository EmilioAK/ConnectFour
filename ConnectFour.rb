# frozen_string_literal: true
require_relative 'lib/game'
require_relative 'lib/game_ui'

def main
  GameUI.new(Game).play
end

main if __FILE__ == $0