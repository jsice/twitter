require 'rails_helper'

RSpec.describe Tweet, type: :model do
  context 'validations' do
    let(:user) { User.create name: "Name", email: "test@test.com", password: "password" }
    subject { described_class.new user: user, content: "Content" }

    it 'is valid with a user and content' do
      expect(subject).to be_valid
    end

    it 'is not valid without a user' do
      subject.user = nil
      expect(subject).to be_invalid
    end

    it 'is not valid without a content' do
      subject.content = nil
      expect(subject).to be_invalid
    end

    it 'is not valid with a content longer than 256' do
      subject.content = "a" * 257
      expect(subject).to be_invalid
    end

    it 'is not valid with blank content' do
      subject.content = ""
      expect(subject).to be_invalid
    end

  end

  context 'associations' do
    let(:user) { User.create name: "Name", email: "test@test.com", password: "password" }
    subject { described_class.create user: user, content: "Content" }

    it { should belong_to :user }
  end
end
