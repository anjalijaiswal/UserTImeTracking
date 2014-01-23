class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    time_range=Time.now.midnight..Time.now.end_of_day
    @usertimes=UserTime.where(:arrival_time=>time_range)
    @u=@usertimes.map{|e| e.user_id}
    @users=User.find(@u)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def login
    if @user=User.find_by_name(params[:name])
      puts "user logged in"
      session[:user_id]=@user.id
      @user_time=UserTime.new
      @user_time=@user.user_times.create(:arrival_time=>Time.now,:user_id=>@user.id)
      redirect_to @user
     
    else
      redirect_to users_url , :notice=>"Invalid User"
    end
  end

  def analytic
  
  end

  def statistic
  end
    
  
  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
   
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
        @user_time=UserTime.new
        @user_time=@user.user_times.create(:arrival_time=>Time.now,:user_id=>@user.id)
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :role)
    end
end
