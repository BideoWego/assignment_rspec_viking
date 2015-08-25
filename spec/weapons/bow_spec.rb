require 'spec_helper'

require_relative '../../lib/weapons/bow.rb'

describe Bow do
	let(:bow){Bow.new}
	let(:bow_100){Bow.new(100)}

	describe '#arrows' do
		it 'is readable' do
			expect {bow.arrows}.to_not raise_error
		end

		it 'defaults to 10' do
			expect(bow.arrows).to eq(10)
		end

		it 'defaults to a specified number' do
			expect(bow_100.arrows).to eq(100)
		end
	end

	describe '#use' do
		before do
			allow(bow).to receive(:puts)
		end

		it 'decreases arrows by 1' do
			bow.use
			expect(bow.arrows).to eq(9)
		end

		it 'raises an error when out of arrows' do
			expect do
				20.times {bow.use}
			end.to raise_error("Out of arrows")
		end
	end
end
