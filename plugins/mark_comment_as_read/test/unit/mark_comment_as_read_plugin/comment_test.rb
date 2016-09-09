require 'test_helper'

class MarkCommentAsReadPlugin::CommentTest < ActiveSupport::TestCase

  def setup
    @person = create_user('user').person
    @article = TinyMceArticle.create!(:profile => @person, :name => 'An article')
    @comment = Comment.create!(:title => 'title', :body => 'body', :author => @person, :source => @article)
    @external_person = ExternalPerson.create!(identifier: 'externalze',
                                              name: 'External Ze',
                                              source: 'anerenvironment.org',
                                              email: 'external@ze.org',
                                              created_at: Date.yesterday)
  end

  should 'mark comment as read' do
    refute @comment.marked_as_read?(@person)
    @comment.mark_as_read(@person)
    assert @comment.marked_as_read?(@person)
  end

  should 'mark comment as read for external user' do
    refute @comment.marked_as_read?(@external_person)
    @comment.mark_as_read(@external_person)
    assert @comment.marked_as_read?(@external_person)
  end

  should 'do not mark a comment as read again' do
    @comment.mark_as_read(@person)
    assert_raise ActiveRecord::RecordNotUnique do
      @comment.mark_as_read(@person)
    end
  end

  should 'mark comment as not read' do
    @comment.mark_as_read(@person)
    assert @comment.marked_as_read?(@person)
    @comment.mark_as_not_read(@person)
    refute @comment.marked_as_read?(@person)
  end

  should 'mark comment as not read for external_person' do
    @comment.mark_as_read(@external_person)
    assert @comment.marked_as_read?(@external_person)
    @comment.mark_as_not_read(@external_person)
    refute @comment.marked_as_read?(@external_person)
  end

  should 'return comments marked as read for a user' do
    person2 = create_user('user2').person
    @comment.mark_as_read(@person)
    assert_equal [], @article.comments.marked_as_read_for(@person) - [@comment]
    assert_equal [], @article.comments.marked_as_read_for(person2)
  end

  should 'return comments marked as read for an external user' do
    person2 = create_user('user2').person
    @comment.mark_as_read(@external_person)
    assert_equal [], @article.comments.marked_as_read_for(@external_person) - [@comment]
    assert_equal [], @article.comments.marked_as_read_for(person2)
  end

end
