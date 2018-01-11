class Api::ItemsController < ApiController
   before_action :authenticated?
 
   def create
       item = Item.new
        if item.save
 
        render json: item
        else
 
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
        end

   end
   
   def update
       item = Item.find(params[:id])
         if item.update(item_params)
            render json: item
         else
         render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
         end
   end
 end