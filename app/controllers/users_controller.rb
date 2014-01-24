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
    @user=User.find(params[:id])
    @usertimes=@user.user_times.map{|e| e.arrival_time.localtime}
    a=@usertimes.map{|e| e.strftime("%H:%M")}
      
    average_time(a)
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
 def average_time(*args)
  begin
     
      a = *args
      a=a.flatten
       puts "#{a}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      s=a.size
      avg_min=0
      a.each do |x|
        hour,minute=x.split(',')
        puts "#{hour}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#{minute}"
        total_min=(hour.to_i*60 + minute.to_i)
        puts "total  minutes= #{total_min}"
        
        avg_min=avg_min+total_min
      end  
      avg_min=avg_min/s
       #puts avg_min
      @avg_time=avg_min.to_f/60
      #puts "#{@avg_time}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      #avg_time = Time.parse(avg_time.to_s)
      return @avg_time
    rescue  ZeroDivisionError
      redirect_to users_path, :notice => "no user logged in yet"
    end
 end

  def analytic
    
      time_range=Time.now.midnight..Time.now.end_of_day
      @usertimes=UserTime.where(:arrival_time=>time_range)
      @u=@usertimes.map{|e| e.arrival_time.localtime}
      a=@u.map{|e| e.strftime("%H:%M")}
      average_time(a)
    #   puts a
    #   s=a.size
    #   avg_min=0
    #   a.map do |x|
    #     hour,minute=x.split(':')
    #     puts "#{hour}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#{minute}"
    #     total_min=(hour.to_i*60 + minute.to_i)
    #     puts "total  minutes= #{total_min}"
        
    #     avg_min=avg_min+total_min
    #   end  
    #   avg_min=avg_min/s
    #    #puts avg_min
    #   @avg_time=avg_min.to_f/60
    #   #puts "#{@avg_time}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    #   #avg_time = Time.parse(avg_time.to_s)
    #   return @avg_time
    # rescue  ZeroDivisionError
    #   redirect_to users_path, :notice => "no users arrived yet"
    # end

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
