require 'spec_helper'

require_relative '../lib/weapons/weapon.rb'
require_relative '../lib/weapons/axe.rb'
require_relative '../lib/weapons/bow.rb'
require_relative '../lib/viking.rb'

describe Viking do
	let(:axe){Axe.new}
	let(:bow){Bow.new}
	let(:fists){Fists.new}
	let(:viking){Viking.new('Fred', 75)}
	let(:viking_axe){Viking.new('Joe', 100, 10, axe)}
	let(:viking_bow){Viking.new('Bill', 100, 10, bow)}

	before do
		[axe, bow, fists, viking, viking_axe, viking_bow].each do |o|
			allow(o).to receive(:puts)
		end
	end

	describe '#initialize' do
		it 'allows a name attribute to be set' do
			expect(viking.name).to eq('Fred')
		end

		it 'allows a health attribute to be set' do
			expect(viking.health).to eq(75)
		end
	end

	describe '#health' do
		it 'is not writable' do
			expect {viking.health = 1234}.to raise_error(NoMethodError)
		end
	end

	describe '#weapon' do
		it 'defaults to nil' do
			expect(viking.weapon).to eq(nil)
		end
	end

	describe '#pick_up_weapon' do
		it 'sets the weapon to the given weapon' do
			viking.pick_up_weapon(bow)
			expect(viking.weapon).to eq(bow)
		end

		it 'raises an error when the weapon is invalid' do
			expect {viking.pick_up_weapon('Not a weapon')}.to raise_error("Can't pick up that thing")
		end

		it 'overwrites the old weapon' do
			viking_bow.pick_up_weapon(axe)
			expect(viking_bow.weapon).to eq(axe)
		end
	end

	describe '#drop_weapon' do
		it 'sets weapon to nil' do
			viking_bow.drop_weapon
			expect(viking_bow.weapon).to be_nil
		end
	end

	describe '#receive_attack' do
		it 'reduces the health by the given amount' do
			health = viking.health
			viking.receive_attack(10)
			expect(viking.health).to eq(health - 10)
		end

		it 'calls the take_damage method' do
			expect(viking).to receive(:take_damage).with(10)
			viking.receive_attack(10)
		end
	end

	describe '#attack' do
		context 'target is another Viking' do
			it 'causes the recipient\'s health to drop' do
				health = viking_axe.health
				viking_bow.attack(viking_axe)
				expect(viking_axe.health).to be < health
			end

			it 'calls that Viking\'s take_damage method' do
				expect(viking_axe).to receive(:take_damage)
				viking_bow.attack(viking_axe)
			end
		end

		context 'called on viking with no weapons' do
			it 'runs damage_with_fists' do
				allow(viking).to receive(:damage_with_fists).and_return(65)
				expect(viking).to receive(:damage_with_fists)
				viking.attack(viking_axe)
			end

			it 'deals Fists multiplier times strength damage' do
				multiplier = 0.25
				strength = viking.strength
				health = viking_axe.health
				viking.attack(viking_axe)
				difference = health - viking_axe.health
				product = multiplier * strength
				expect(difference).to eq(product)
			end
		end

		context 'called on viking with weapons' do
			it 'runs damage_with_weapon' do
				allow(viking_axe).to receive(:damage_with_weapon).and_return(65)
				expect(viking_axe).to receive(:damage_with_weapon)
				viking_axe.attack(viking)
			end

			it 'deals damage equal to the Viking\'s strength times that Weapon\'s multiplier' do
				multiplier = 1
				strength = viking_axe.strength
				health = viking.health
				viking_axe.attack(viking)
				difference = health - viking.health
				product = multiplier * strength
				expect(difference).to eq(product)
			end
		end

		context 'called when weapon is bow without enough arrows' do
			it 'uses Fists instead when using a Bow without enough arrows' do
				10.times {bow.use}
				viking.pick_up_weapon(bow)
				expect(viking_axe).to_not receive(:damage_with_fists)
				viking.attack(viking_axe)
			end
		end
	end
	describe '#check_death' do
		context 'has no health' do
			it 'raises an error' do
				expect do
					100.times {viking_axe.attack(viking)}
				end.to raise_error('Fred has Died...')
			end
		end
	end
end
