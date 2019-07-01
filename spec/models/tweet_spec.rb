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

    context 'reply' do
      let(:parent) { described_class.create user: user, content: "Parent", replies: [subject] }
      let(:replies) { [ (described_class.create user: user, content: "Reply", parent: subject) ] }
      it { should belong_to :parent }
      it { should have_many :replies }
    end

    context 'retweet-with-comment' do
      let(:commentee) { described_class.create user: user, content: "Commentee", commenters: [subject] }
      let(:commenters) { [ (described_class.create user: user, content: "Commenters", commentee: subject) ] }
      it { should belong_to :commentee }
      it { should have_many :commenters }
    end

    context 'retweets' do
      let(:retweeters) { [ (User.create name: "Name2", email: "test2@test.com", password: "password2", retweets: [subject]) ] }
      it { should have_many :retweeters }
    end

    context 'likes' do
      let(:liking_users) { 
        [ 
          user,
          (User.create name: "Name2", email: "test2@test.com", password: "password2", retweets: [subject])
        ] 
      }
      it { should have_many :liking_users }
    end
  end

  context 'scopes' do
    let(:user) { User.create name: "Name", email: "test@test.com", password: "password" }
    subject { described_class.create user: user, content: "Content" }
    context 'replies' do
      let(:reply) { described_class.create user: user, content: "Reply", parent: subject }
      let(:non_reply) { described_class.create user: user, content: "Non Reply" }
      it 'includes only replies' do
        expect(Tweet.replies).to include(reply)
      end

      it 'excludes general tweets' do
        expect(Tweet.replies).not_to include(non_reply)
      end
    end

    context 'tweets' do
      let(:reply) { described_class.create user: user, content: "Reply", parent: subject }
      let(:non_reply) { described_class.create user: user, content: "Non Reply" }
      it 'includes only general tweets (not a reply)' do
        expect(Tweet.tweets).to include(non_reply)
      end

      it 'excludes replies' do
        expect(Tweet.tweets).not_to include(reply)
      end
    end
  end
end
