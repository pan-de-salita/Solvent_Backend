# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Challenge, type: :model do
  let!(:challenge) { build :challenge, :with_title, :with_description, :with_start_date, :with_end_date }

  context 'when attributes are valid' do
    it 'creates a Challenge instance' do
      valid_challenge = challenge
      expect(valid_challenge).to be_valid
    end
  end

  context 'when attributes are invalid/missing' do
    it 'rejects a Challenge instance creation attempt when title is not unique' do
      challenge_with_duplicate_title = challenge.dup
      challenge.save
      expect(challenge_with_duplicate_title.title).to eq(challenge.title)
      expect(challenge_with_duplicate_title).to_not be_valid
    end

    it 'rejects a Challenge instance creation attempt when start_date is less than Date.today' do
      challenge.start_date = Date.yesterday
      challenge_with_invalid_start_date = challenge
      expect(challenge_with_invalid_start_date.start_date).to be < Date.today
      expect(challenge_with_invalid_start_date).to_not be_valid
    end

    it 'rejects a Challenge instance creation attempt when end_date is less than or equal_to Date.today' do
      challenge.end_date = Date.today
      challenge_with_invalid_end_date = challenge
      expect(challenge_with_invalid_end_date.end_date).to be == challenge.start_date
      expect(challenge_with_invalid_end_date).to_not be_valid

      challenge.end_date = Date.yesterday
      challenge_with_invalid_end_date = challenge
      expect(challenge_with_invalid_end_date.end_date).to be == Date.yesterday
      expect(challenge_with_invalid_end_date).to_not be_valid
    end
  end
end
