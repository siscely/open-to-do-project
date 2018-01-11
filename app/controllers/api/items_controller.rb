class Api::ItemsController < ApiController
   before_action :authenticated?
 
   def create
       item = Item.new
        if item.save
 
        render json: item
        else
 
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end

   end

 end