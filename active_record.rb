# frozen_string_literal: true

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  gem 'rails'
  # If you want to test against edge Rails replace the previous line with this:
  # gem "rails", github: "rails/rails", branch: "main"

  gem 'sqlite3', '~> 1.4'
end

require 'active_record'
require 'minitest/autorun'
require 'logger'

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :animals, force: true do |t|
    t.string :name
  end

  create_table :toys, force: true do |t|
    t.string :name
  end

  add_reference :toys, :animals, foreign_key: true
end

class Animal < ActiveRecord::Base
  has_many :toys
end

class Toy < ActiveRecord::Base
  belongs_to :animal
end

class BugTest < Minitest::Test
  def test_association_stuff
    animal = Post.create!(name: 'Cat')
    animal.toys << Toy.create!(name: 'mouse', animal: animal)

    assert_equal 1, animal.toys.count
    assert_equal 1, Toy.count
    assert_equal animal.id, Toy.first.animal.id
  end
end
