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

  context 'associations' do
    subject { User.create name: "Name", email: "test@test.com", password: "password" }
    let(:tweets) { [(Tweet.create user: subject, content: "Content")] }

    it { should have_many :tweets }

    context 'followers' do
      let(:followings) { described_class.User.create name: "Name2", email: "test2@test.com", password: "password", followers: [subject] }
      let(:followers) { [ (described_class.User.create name: "Name3", email: "test3@test.com", password: "password", followings: [subject]) ] }
      it { should have_many :followings }
      it { should have_many :followers }
    end

    context 'retweets' do
      let(:retweets) { [ (Tweet.create user: subject, content: "Content", retweeters: [subject]) ] }
      it { should have_many :retweets }
    end

    context 'likes' do
      let(:liked_tweets) { [(Tweet.create user: subject, content: "Content", liking_users: [subject])] }
      it { should have_many :liked_tweets }
    end
  end
end
