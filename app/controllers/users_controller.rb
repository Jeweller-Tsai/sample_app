class UsersController < ApplicationController
  before_filter :authenticate ,:except=>[:show ,:new ,:create]
  before_filter :correct_user ,:only=>[:edit ,:update]
  before_filter :admin_user,   :only=>:destroy

  def index
    @title="All users"
    @users=User.order(:name).paginate(:per_page=>20 ,:page=>params[:page])
  end

  def new
    @title="Sign up"
    @user=User.new
  end

  def show
    @user=User.find(params[:id])
    @microposts=@user.microposts.order(:created_at).paginate(:page=>params[:page])
    @title=@user.name
  end

  def create
    @user=User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success]="Welcome to the Sample App,#{@user.name}"
      redirect_to @user
    else
      @title="Sign up"
      render 'new'
    end
  end

  def edit
    @title="Edit user"
  end

  def update
    @user=User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success]="Profile updated"
      redirect_to @user
    else
      @title="Edit user"
      render 'edit'
    end
  end

  def destroy
    target_user=User.find(params[:id])
    target_user.destroy unless target_user.admin?
    #User.find(params[:id]).destroy
    flash[:success]="User destroyed"
    redirect_to users_path
  end

  def following
    @title="Following"
    @user=User.find(params[:id])
    @users=@user.following.order(:created_at).paginate(:page=>params[:page])
    render 'show_follow'
  end

  def followers
    @title="Followers"
    @user=User.find(params[:id])
    @users=@user.followers.order(:created_at).paginate(:page=>params[:page])
    render 'show_follow'
  end

  private
    def correct_user
      @user=User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      if signed_in?
        redirect_to(root_path) unless current_user.admin?
      else
        redirect_to(signin_path)
      end

    end
end
