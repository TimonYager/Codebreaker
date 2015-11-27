require 'spec_helper'

module Codebreaker
  describe Code do
    let(:code) { Code.new('1214') }

    context '#initialize' do 
      it 'takes string as argument' do 
        expect(code.instance_variable_get(:@code)).to be_a(String)
      end

      it 'raises an error if argument is not valid' do 
        expect{ Code.new('3e11')  }.to raise_error(ArgumentError)
        expect{ Code.new(3421)    }.to raise_error(ArgumentError)
        expect{ Code.new('31361') }.to raise_error(ArgumentError)
        expect{ Code.new('3498')  }.to raise_error(ArgumentError)
      end

      it 'saves argument as code' do 
        expect(code.instance_variable_get(:@code)).to eq('1214')
      end
    end

    context '#==' do
      let(:equal_code)     { Code.new('1214') }
      let(:non_equal_code) { Code.new('4421') }

      it 'returns true if codes are equal to each other' do
        expect(code == equal_code ).to eq(true)
      end

      it 'returns false if codes are not equal to each other' do 
        expect(code == non_equal_code).to eq(false)
      end

      it 'raises an error if compared object is not a Code' do 
        expect{ code == 1421 }.to raise_error(ArgumentError)
      end
    end

    context '#[]' do 
      it 'returns right element of code' do 
        expect(code[0]).to eq('1')
      end
    end

    context '#[]=' do 
      let(:code_to_change) { Code.new('6315') }
      before do 
        code_to_change[2] = '5'
      end

      it 'sets value to the right place' do 
        expect(code_to_change.to_s).to eq('6355')
      end
    end

    context '#delete' do 
      let(:code_with_zeros) { Code.new('3125') }
      before do
        code_with_zeros[1] = code_with_zeros[3] = '0'
        code_with_zeros.delete('0')
      end

      it 'deletes all zeros from code' do 
        expect(code_with_zeros.to_s).to eq('32')
      end
    end

    context '#delete_first' do 
      let(:devil_number) { Code.new('6666') }
      before do 
        devil_number.delete_first('6')
      end

      it 'deletes first founded element' do 
        expect(devil_number.to_s).to eq('666')
      end
    end

    context '#each' do 
      sum = 0
      before do 
        code.each { |num| sum += num.to_i }
      end
      
      it 'perform actions in block' do
        expect(sum).to eq(8)
      end

      it 'returns enumerator if method called without block' do 
        expect(code.each).to be_a(Enumerator)
      end
    end

    context '#each_with_index' do 
      index_sum = 0
      before do 
        code.each_with_index { |num, i| index_sum += i }
      end
      
      it 'perform actions in block' do
        expect(index_sum).to eq(6)
      end

      it 'returns enumerator if method called without block' do 
        expect(code.each_with_index).to be_a(Enumerator)
      end
    end

    context '#size' do 
      it 'returns code size' do
        expect(code.size).to eq(4)
      end
    end

    context '#to_s' do
      it 'returns string' do 
        expect(code.to_s).to be_a(String)
      end

      it 'returns right code' do 
        expect(code.to_s). to eq('1214')
      end
    end

    context '#secret_code' do 
      let(:s_code) { Code.new }

      it 'returns string' do 
        expect(s_code.send(:secret_code)).to be_a(String)
      end

      it 'returns code with 4 elements' do 
        expect(s_code.send(:secret_code).size).to eq(4)
      end
    end

    context '#index_converter' do 
      it 'returns argument if it is a Fixnum' do 
        expect(code.send(:index_converter, 2)).to eq(2) 
      end

      it "returns argument's index if argument is a string" do 
        expect(code.send(:index_converter, "2")).to eq(1)
      end

      it 'raises error if index is bigger than code size' do 
        expect{ code.send(:index_converter, 8) }.to raise_error(IndexError)
      end

      it 'raises error if index is less than zero' do 
        expect{ code.send(:index_converter, -2) }.to raise_error(IndexError)
      end
    end
  end
end