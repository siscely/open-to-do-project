class Api::ItemsController < ApiController
   before_action :authenticated?
 
   def create
       item = Item.new
       list = List.find(params[:list_id])
        if item.save
      item.update_attribute(:list, list)    
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
   
   private
   def item_params
     params.require(:item).permit(:name)
   end
 end