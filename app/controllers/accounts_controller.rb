class AccountsController < ApplicationController
  verify :session => :credentials, :only => %w(new create), :redirect_to => :new_sessions_path

  def new
    @rubyist = Rubyist.new
  end

  def create
    @rubyist = Rubyist.new(params[:rubyist]) do |r|
      r.twitter_user_id, r.identity_url = session[:credentials].values_at(:twitter_user_id, :identity_url)
    end

    if @rubyist.save
      self.user = @rubyist
      session.delete(:credentials)

      redirect_to session.delete(:return_to) || root_path
    else
      render :new
    end
  end

  before_filter :login_required, :only => %w(edit update)

  def edit
    @rubyist = user
  end

  def update
    if user.update_attributes(params[:rubyist])
      flash[:notice] = 'Your settings have been saved.'
      redirect_to edit_account_path
    else
      @rubyist = user
      render :edit
    end
  end
end
