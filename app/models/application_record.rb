# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Find me in lib/common_helpers.rb
  extend MoneyHelper
end
