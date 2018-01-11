class Api::UsersController < ApiController
 # #4
   before_action :authenticated?
 
   def index
      render json: users, each_serializer: UserSerializer
   end

 end