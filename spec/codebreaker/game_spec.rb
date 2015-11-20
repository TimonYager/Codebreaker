require 'spec_helper'

module Codebreaker

	shared_examples 'code' do
		it 'not an empty code' do 
			expect(code).not_to be_empty
		end

		it '4 number code' do 
			expect(code.size).to eq(4)
 		end

		it 'with numbers between 1 and 6' do
			expect(code).to match(/[1-6]+/)				
		end
	end

	describe Game do 
		let(:game) { Game.new }

		before do 
			game.start
		end

		context '#start' do 
			# it_behaves_like 'code'
			it 'calls set_level method'
		end

		context '#check' do 
			it 'returns string'
			it 'has only "+" and "-" symbols'
		end

	end
end 