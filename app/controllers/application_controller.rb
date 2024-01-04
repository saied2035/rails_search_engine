class ApplicationController < ActionController::Base

    def current_user
        user = User.find_by(ip_address: request.remote_ip)
        return user.present? ? user :  User.create(ip_address: request.remote_ip) 
    end    
end
