require 'spec_helper'

describe SearchesController do

  describe "GET 'index'" do
    before(:all) do
      ThinkingSphinx::Test.index
      sleep(0.25)
      ThinkingSphinx::Test.start
    end
    after(:all) do
      ThinkingSphinx::Test.stop
    end
    describe "for non-signed-in user" do
      it "should be redirect to signin_path" do
        get 'index'
        response.should redirect_to(signin_path)
      end

      it "should require sign in when searching users" do
        get 'index', :q => "", :model => "User"
        response.should redirect_to(signin_path)
      end

      it "should require sign in when searching microposts" do
        get 'index', :q =>  "", :model => "Micropost"
        response.should redirect_to(signin_path)
      end
    end

    describe 'for signed-in users' do
      before(:each) do
        test_sign_in(Factory(:user))
      end

      it 'should redirect for an invalid model' do
        get :index, :q => "foo", :model => "Bar"
        response.should redirect_to(root_path)
      end

      describe 'searching users' do
        it 'should be successful' do
          get 'index', :q => "", :model => "User"
          response.should be_success
        end

        it 'should return an empty array when query is blank' do
          get 'index', :q =>  " ", :model => "User"
          response.should be_success
          assigns(:results).should == [].paginate
        end

        it 'should redirect_to root path for a nil query' do
          get 'index', :q => nil, :model => "User"
          response.should be_redirect
          response.should redirect_to(root_path)
        end

        it 'should return empty for a wildcard query' do
          get 'index', :q => "*", :model => "User"
          response.should be_success
          assigns(:results).should == [].paginate
        end

        it 'should search by name' do
          user=User.create!(:name => "foobar", :email => "example@abc.com", :password => "123456")
          ThinkingSphinx::Test.index
          sleep(2)
          get 'index', :q => "foobar", :model => "User"
          response.should be_success
          assigns(:results).should == [user].paginate

        end




      end
    end
  end

end

