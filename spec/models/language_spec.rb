# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  version    :string
#
require 'rails_helper'

RSpec.describe Language, type: :model do
  let!(:language) { build :language }

  context 'when attributes are valid' do
    it 'creates a Language instance' do
      expect(language).to be_valid
    end
  end

  context 'when name is blank' do
    it 'rejects an instance creation attempt' do
      language.name = nil
      expect(language.name).to be_falsy
      expect(language).to_not be_valid
    end
  end

  context 'when creating a language with an existing name' do
    it 'rejects an instance creation attempt' do
      language_dup = language.dup
      language.save
      expect(language_dup.name).to eq(language.name)
      expect(language_dup).to_not be_valid
    end
  end
end
