module Avg
  def average_time(*args)
    begin
       
        a = *args
        a=a.flatten
        # puts "#{a}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        s=a.size
        avg_min=0
        a.each do |x|
          hour,minute=x.split(':')
          puts "#{hour}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#{minute}"
          total_min=(hour.to_i*60 + minute.to_i)
          #puts "total  minutes= #{total_min}"
          
          avg_min=avg_min+total_min
        end  
        avg_min=avg_min/s
         #puts avg_min
        @avg_time=avg_min.to_f/60
        #puts "#{@avg_time}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        #avg_time = Time.parse(avg_time.to_s)
        return @avg_time
      rescue  ZeroDivisionError
       return "not logged in yet"
      end
   end
 end