class UsersController < ApplicationController

  before_filter :authorize_user, :only => [:edit, :update, :destroy]
   
  def authorize_user
    @user = User.find(params[:id])
    if @user.id != session[:user_id]
      redirect_to root_url, notice: "Nice Try"
    end
  end

  def check_out
    @user = User.find(session[:user_id])
    logger.info @user.id
    @user.update_attributes(:check_in_id => nil)
    respond_to do |format|
      format.html { redirect_to events_path }
      format.json { render json: @user, notice: 'User has been successfully checked out.' } 
    end
  end

  def index
    # @visible = User.visible

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @visible }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @event_id = nil
    if @user.check_in_id.present?
      @event_id = CheckIn.find_by_id(@user.check_in_id).event_id
      # TODO give events a name
    end

    @is_user = false
    if @user.id == session[:user_id]
      @is_user = true
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @orientation = [
        "Bisexual",
        "Straight",
        "Gay"
    ]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new( params[:user] )
    if params["gender"].eql? "F"
      @user.visible = true
    else
      
    end

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
