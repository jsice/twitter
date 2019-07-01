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
      let(:liking_users) { [(User.create name: "Name2", email: "test2@test.com", password: "password2", liked_tweets: [subject])] }
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

    context 'published' do
      let(:published_unset) { described_class.create(user: user, content: "Published At is unset") }
      let(:published) { described_class.create(user: user, content: "Published now", published_at: Time.zone.now - 1.second) }
      let(:unpublished) { described_class.create(user: user, content: "Published Next Day", published_at: Time.current + 1.day) }
      it 'includes only published tweets' do
        # expect(Tweet.published).to include(published_unset)
        expect(Tweet.published).to include(published)
      end

      it 'excludes unpublished tweets' do
        expect(Tweet.published).not_to include(unpublished)
      end
    end

    context 'not_deleted' do
      let(:deleted_unset) { described_class.create(user: user, content: "Deleted At is unset") }
      let(:deleted) { described_class.create(user: user, content: "Deleted now", deleted_at: Time.zone.now - 1.second) }
      let(:undeleted) { described_class.create(user: user, content: "Deleted Next Day", deleted_at: Time.current + 1.day) }
      it 'includes only undeleted tweets' do
        expect(Tweet.not_deleted).to include(deleted_unset)
        expect(Tweet.not_deleted).to include(undeleted)
      end

      it 'excludes deleted tweets' do
        expect(Tweet.not_deleted).not_to include(deleted)
      end
    end

    context 'present' do
      let(:unset) { described_class.create(user: user, content: "Everything is unset") }
      let(:published) { described_class.create(user: user, content: "Published", published_at: Time.zone.now - 1.second) }
      let(:unpublished) { described_class.create(user: user, content: "Unpublished", published_at: Time.zone.now + 1.day) }
      let(:deleted) { described_class.create(user: user, content: "Deleted", deleted_at: Time.zone.now - 1.second) }
      let(:undeleted) { described_class.create(user: user, content: "Undeleted", deleted_at: Time.zone.now + 1.day) }
      let(:published_but_deleted) { described_class.create(user: user, content: "Published but deleted", published_at: Time.zone.now - 1.second, deleted_at: Time.zone.now - 1.second) }
      let(:published_but_undeleted) { described_class.create(user: user, content: "Published but undeleted", published_at: Time.zone.now - 1.second, deleted_at: Time.zone.now + 1.day) }
      let(:unpublished_but_deleted) { described_class.create(user: user, content: "Unpublished but deleted", published_at: Time.zone.now + 1.day, deleted_at: Time.zone.now - 1.second) }
      let(:unpublished_but_undeleted) { described_class.create(user: user, content: "Unpublished and undeleted", published_at: Time.zone.now + 1.day, deleted_at: Time.zone.now + 1.day) }
      it 'includes only published and undeleted tweets' do
        # expect(Tweet.present).to include(unset)
        expect(Tweet.present).to include(published)
        # expect(Tweet.present).to include(undeleted)
        expect(Tweet.present).to include(published_but_undeleted)
      end

      it 'excludes deleted or unpublished tweets' do
        expect(Tweet.present).not_to include(unpublished)
        expect(Tweet.present).not_to include(deleted)
        expect(Tweet.present).not_to include(published_but_deleted)
        expect(Tweet.present).not_to include(unpublished_but_deleted)
        expect(Tweet.present).not_to include(unpublished_but_undeleted)
      end
    end
  end

  context 'search' do
    let(:user) { User.create name: "Name", email: "test@test.com", password: "password" }
    let(:everything) { described_class.create(user: user, content: "Everything") }
    let(:anything) { described_class.create(user: user, content: "Anything") }
    let(:nothing) { described_class.create(user: user, content: "Nothing") }
    let(:all) { described_class.create(user: user, content: "All") }
    it 'should include only tweets with "thing" in its content' do
      expect(Tweet.search "thing").to include(everything)
      expect(Tweet.search "thing").to include(anything)
      expect(Tweet.search "thing").to include(nothing)
    end

    it 'should exclude tweets without "thing" in its content' do
      expect(Tweet.search "thing").not_to include(all)
    end
  end
end
