require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    subject { User.new name: "Name", email: "test@test.com", password: "password" }

    it 'is valid with name, email and password' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to be_invalid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to be_invalid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to be_invalid
    end

    it 'is not valid with a name longer than 20' do
      subject.name = "a" * 21
      expect(subject).to be_invalid
    end

    it 'is not valid with blank name' do
      subject.name = ""
      expect(subject).to be_invalid
    end

  end
end
