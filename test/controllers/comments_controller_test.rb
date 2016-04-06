require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  describe 'routing' do
    it 'should be child elements of posts' do
      assert_routing({method:'GET',path:'/posts/1/comments'},{controller:'comments',action:'index',post_id:"1"})
      assert_routing({method:'GET',path:'/posts/1/comments/2'},{controller:'comments',action:'show',post_id:"1",id:"2"})
      assert_routing({method:'POST',path:'/posts/1/comments'},{controller:'comments',action:'create',post_id:"1"})
      assert_routing({method:'PATCH',path:'/posts/1/comments/2'},{controller:'comments',action:'update',post_id:"1",id:"2"})
      assert_routing({method:'DELETE',path:'/posts/1/comments/2'},{controller:'comments',action:'destroy',post_id:"1",id:"2"})
    end
  end

end
