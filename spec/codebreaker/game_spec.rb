require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new } 

    context '#initialize' do 
      it 'sets won as "false"' do 
        expect(game.instance_variable_get(:@won)).to eq(false)
      end
    end

    context '#check' do
      before do 
        game.instance_variable_set(:@secret_code, '1214')
      end
      
      it 'returns string with pluses and minuses' do 
        expect(game.check(Code.new('2345'))).to match(/\+{0,4}|\-{0,4}/)
      end

      { '1111' => '++',   '1234' => '+++',  '5234' => '++',  '3653' => '',
        '1214' => '++++', '2244' => '++',   '1212' => '+++', '4121' => '----',
        '4213' => '++-',  '1421' => '+---', '2456' => '--',  '6611' => '+-',
        '4563' => '-',    '2222' => '+',    '2113' => '+--', '2146' => '---' 
      }.each do |code, answer|

        it "returns #{answer} with #{code} as guess and 1214 as secret code" do 
          expect(game.check(Code.new(code))).to eq(answer)
        end
      end
    end

    context '#count_up_score' do 
      { 10 => 145, 7 => 115,  1 => 55, 
        16 => 205, 13 => 175, 19 => 235 }.each do |chances_left, result_score|

        it "returns #{result_score} if #{chances_left} chances left" do 
          game.instance_variable_set(:@chances, chances_left)
          game.count_up_score
          expect(game.score).to eq (result_score)
        end
      end
    end

    context '#guess' do 
      before do 
        game.start
      end

      it 'sets new guess as code' do 
        code = '4111'
        game.guess(code)
        expect(game.instance_variable_get(:@guess).to_s).to eq(code)
      end

      it 'reduces chances by 1' do 
        expect{ game.guess('4111') }.to change{ game.chances }.by(-1)
      end

      it 'calls check method' do 
        code = '4121'
        expect(game).to receive(:check).with(Code.new(code))
        game.guess(code)
      end

      it 'sets sets won to true if guess equals to secret code' do 
        game.instance_variable_set(:@secret_code, Code.new('1214'))
        game.guess('1214')
        expect(game.instance_variable_get(:@won)).to eq(true)
      end

      it 'returns string' do
        expect(game.guess('3412')).to be_a(String)
      end
    end

    context '#hint' do
      before do 
        game.start
      end 

      it 'returns one of secret code numbers' do 
        expect(game.instance_variable_get(:@secret_code)).to include(game.hint) 
      end
      
      it 'returns the same hint' do 
        game.hint
        expect{ game.hint }.not_to change{ game.instance_variable_get(:@hint) }
      end 

      it 'doesnt set hint variable unless hint method is called' do 
        expect(game.instance_variable_get(:@hint)).to be_nil
      end
    end

    context '#over?' do 
      it 'returns true if player has no chances' do 
        game.instance_variable_set(:@chances, 0)
        expect(game).to be_over
      end

      it 'returns false if chances > 0' do 
        game.start
        expect(game).not_to be_over
      end
    end

    context '#start' do 
      it 'creates secret code' do 
        expect(Code).to receive(:new)
        game.start
      end

      it 'sets code to secret_code variable' do
        expect{ game.start }.to change{ game.instance_variable_get(:@secret_code) }
      end
    end

    context '#won?' do 
      before do 
        game.instance_variable_set(:@secret_code, '1214')
      end

      it 'returns true if @won is true' do 
        expect{ game.instance_variable_set(:@won, true) }.to change{ game.won? }.to(true)
      end

      it 'sets @won to true if player guessed the code' do 
        expect{ game.guess('1214') }.to change{ game.won? }.to(true)
      end

      it 'returns false if game is on' do 
        expect{ game.guess('2154') }.not_to change{ game.won? }
      end
    end

    context '#set_level' do 
      before do
        game.instance_variable_set(:@chances, nil)
      end

      it 'raises an error if argument is not a level' do 
        expect{ game.send(:set_level, 'beer') }.to raise_error(ArgumentError)
      end

      it 'sets chances to 10 if level is hard' do 
        expect{ game.send(:set_level, 'hard') }.to change{ game.chances }.to(10)
      end

      it 'sets chances to 15 if level is medium' do 
        expect{ game.send(:set_level, 'medium') }.to change{ game.chances }.to(15)
      end

      it 'sets chances to 20 if level is easy' do 
        expect{ game.send(:set_level, 'easy') }.to change{ game.chances }.to(20)
      end
    end
  end
end