class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    
    time_range=Time.now.midnight..Time.now.end_of_day
    @usertimes=UserTime.where(:arrival_time=>time_range)
    @u=@usertimes.map{|e| e.user_id}
    @users=User.find(@u)
    #@users = @users.page(params[:page]).per(5)
    # @users = User.map{|e|e.user_times.where(:arrival_time=>time_range)}.paginate :page=>params[:page], :per_page => 10
    # @products = Product.order("name").page(params[:page]).per(5)

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
      
      session[:user_id]=@user.id
      @user_time=UserTime.new
      @user_time=@user.user_times.create(:arrival_time=>Time.now,:user_id=>@user.id)
      if @user.role == true
          render layout: "admin"
      else
        redirect_to user_path(@user) 
      end
    else
      redirect_to users_url , :notice=>"Invalid User"
    end
  end
 

  def analytic
      @users=User.all
      time_range=Time.now.midnight..Time.now.end_of_day
      @usertimes=UserTime.where(:arrival_time=>time_range)
      if @usertimes.present? 

        @u=@usertimes.map{|e| e.arrival_time.localtime}
        @a=@u.map{|e| e.strftime("%H:%M")}
      else
        redirect_to "/users", :notice => "no user logged in yet"
      end
  end

  def statistic
    
    @users=User.all
    @user_times=UserTime.where(arrival_time: (DateTime.now.beginning_of_month..DateTime.now.end_of_month))
    
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
        format.html { render layout: 'admin', notice: 'User was successfully created.' }
        format.json { render action: 'index', status: :created, location: users_path }
        # @user_time=UserTime.new
        # @user_time=@user.user_times.create(:arrival_time=>Time.now,:user_id=>@user.id)
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
      format.html { render layout: "admin" }
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
