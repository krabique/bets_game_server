# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'includes MoneyHelper module' do
    expect(ApplicationHelper.included_modules.include?(MoneyHelpers)).to be true
  end
end
