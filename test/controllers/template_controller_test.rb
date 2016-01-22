require 'test_helper'

class TemplateControllerTest < ActionController::TestCase

  describe 'index' do

    it 'should be mapped to root' do
      assert_routing({method: 'GET', path: '/'}, {controller: 'template', action: 'index'})
    end

    it 'should return the index page' do
      get :index
      assert_response :success
      assert @response.body.include?('ng-view')
    end

  end

  describe 'template' do

    it 'should route to template with or without a module' do
      assert_routing({method: 'GET', path: '/template/someview'}, {controller: 'template', action: 'template', name: 'someview'})
      assert_routing({method: 'GET', path: '/template/somemodule/someview'}, {controller: 'template', action: 'template', module: 'somemodule', name: 'someview'})
    end

    it 'should return the right template' do
      get :template, name: 'home'
      assert_response :success
      get :template, module: 'auth', name: 'login'
      assert_response :success
    end

  end

end
