require 'spec_helper'

require_relative '../lib/warmup.rb'

describe Warmup do
	let(:warmup){Warmup.new}

	describe '#gets_shout' do
		it 'receives #gets' do
			expect(warmup).to receive(:gets).and_return('asdf')
			warmup.gets_shout
		end

		it 'receives #puts' do
			expect(warmup).to receive(:gets).and_return('asdf')
			expect(warmup).to receive(:puts)
			warmup.gets_shout
		end

		it 'shouts a given string' do
			allow(warmup).to receive(:gets).and_return('hello world!')
			allow(warmup).to receive(:puts)
			expect(warmup.gets_shout).to eq('HELLO WORLD!')
		end
	end

	describe '#triple_size' do
		it 'returns triple the size of the given array' do
			array = double(:size => 10)
			expect(warmup.triple_size(array)).to eq(30)
		end
	end

	describe '#calls_some_methods' do
		let(:str){"hello"}

		it 'calls #upcase! on the given string' do
			expect(str).to receive(:upcase!).and_return('HELLO')
			warmup.calls_some_methods(str)
		end

		it 'calls #reverse! on the given string' do
			expect(str).to receive(:reverse!).and_return('OLLEH')
			warmup.calls_some_methods(str)
		end

		it 'returns an unrelated string' do
			original = str.dup
			expect(warmup.calls_some_methods(str)).to_not eq(original.upcase.reverse)
		end
	end
end