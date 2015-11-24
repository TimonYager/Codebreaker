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
	end
end