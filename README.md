
     ,-----.,--.                  ,--. ,---.   ,--.,------.  ,------.
    '  .--./|  | ,---. ,--.,--. ,-|  || o   \  |  ||  .-.  \ |  .---'
    |  |    |  || .-. ||  ||  |' .-. |`..'  |  |  ||  |  \  :|  `--, 
    '  '--'\|  |' '-' ''  ''  '\ `-' | .'  /   |  ||  '--'  /|  `---.
     `-----'`--' `---'  `----'  `---'  `--'    `--'`-------' `------'
    ----------------------------------------------------------------- 


Welcome to your Rails project on Cloud9 IDE!

To get started, just do the following:

1. Run the project with the "Run Project" button in the menu bar on top of the IDE.
2. Preview your new app by clicking on the URL that appears in the Run panel below (https://HOSTNAME/).

Happy coding!
The Cloud9 IDE team


## Support & Documentation

Visit http://docs.c9.io for support, or to learn more about using Cloud9 IDE. 
To watch some training videos, visit http://www.youtube.com/user/c9ide


## Description
Open-To-Do

Build an externally usable API for a basic to-do list application. This API will allow users to modify user accounts and to-do items from the command line.

## Tools
Cloud9

## Generate a New Rails App
In your command line, cd into your work directory, create a new Rails app, new-rails-project is our example. Then, cd into the new-rails-project directory. 

## Configure Git and GitHub
Sign into your GitHub account and create a new repository, we'll name ours “new-rails-project.” Initialize a git repo in your project directory with this command:
```
~/path/to/work/directory/new-rails-project/
$ git init
```
To push commits to GitHub, we have to specify the remote repository with git remote add origin.
```
~/path/to/work/directory/new-rails-project/
$ git remote add origin https://github.com/<user name>/new-rails-project.git
```
Your project is configured to use Git and GitHub.

## Add Default Gems
Replace the contents of your Gemfile with the following:

Gemfile
 source 'https://rubygems.org'
 
 # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
 ```
 gem 'rails', '4.2.5'
 
 group :production do
   gem 'pg'
   gem 'rails_12factor'
 end
 
 group :development do
   gem 'sqlite3'
   gem 'web-console', '~> 2.0'
 end
 
 gem 'sass-rails', '~> 5.0'
 gem 'uglifier', '>= 1.3.0'
 gem 'coffee-rails', '~> 4.1.0'
 gem 'jquery-rails'
 gem 'turbolinks'
 gem 'bootstrap'
 gem 'figaro'

 group :development, :test do
   gem 'byebug'
   gem 'spring'
   gem 'rspec-rails'
   gem 'shoulda'
   gem 'faker'
   gem 'factory_girl_rails'
   gem 'pry-rails'
 end
 ```
 ## Rails Serializers
 As the Open To-do API, I want to return JSON representations of users, lists, and items

### Generate Models
Open To-do API requires three models: a User, a List and an Item. A user model represents a user, an item is a single to-do item, and a list belongs to a user, has several items, and a private attribute. Generate these three models with basic attributes.

### Generate Serializers
The Open To-do API must return formatted responses that users can read, and machines can generate and parse. The standard for most modern web APIs is JSON, which stands for JavaScript Object Notation. JSON is a lightweight data-interchange format.

Converting a Rails object into a JSON representation is called serializing. Open To-do API will need to serialize users, lists, and items. Read our guide to Rails Serializers to turn your Rails objects into JSON.

Generate UserSerializer, ListSerializer, and ItemSerializer using the Rails Serializers guide.

### Test your code
1. From the Rails console, insert at least one user, list, and item.
1. From the Rails console, confirm that  puts JSON.pretty_generate(UserSerializer.new(User.first).as_json) outputs the JSON representation of a User.
1. From the Rails console, confirm that  puts JSON.pretty_generate(ListSerializer.new(List.first).as_json) outputs the JSON representation of a List.
1. From the Rails console, confirm that  puts JSON.pretty_generate(ItemSerializer.new(Item.first).as_json) outputs the JSON representation of an Item.
1. Validate the JSON output for each Serializer using JSONLint.

## User Authentication
As a user, I want to authenticate myself from the command line, using a username and password

### Generate a Base Controller
Create an ApiController from which the user, list, and items API controllers will inherent:
```
app/controllers/api_controller.rb
 class ApiController < ApplicationController
   skip_before_action :verify_authenticity_token
  end
```

Create a private method named authenticated?. Other API controllers will use  authenticated? to ensure users are authorized:

```
app/controllers/api_controller.rb
 class ApiController < ApplicationController
   skip_before_action :verify_authenticity_token
   private
   def authenticated?
 
     authenticate_or_request_with_http_basic {|username, password| User.where( username: username, password: password).present? }
   end
 end
```

Please note that using authenticate_or_request_with_http_basic would require your password to be stored as plaintext. In a production environment, you would want to implement hashing to "hash" your credentials. Alternatively, we could use the Devise valid_password? method if you are using Devise for authentication.

To test authenticated?, you will need an API route that requires authentication.

Edit routes.rb to provide API routes:

app/config/routes.rb
 ```
   namespace :api, defaults: { format: :json } do
     resources :users
   end
   ```
### Generate a Users Controller
Create UsersController to match the API routes. Make a new directory in  app/controllers named api. Create the new controller in that directory:

app/controllers/api/users_controller.rb
 ```
 class Api::UsersController < ApiController
 
   before_action :authenticated?
 
   def index
   end

 end
```
Write index to return a UserSerializer-generated JSON representation of all users. The final line of the index method will look like:

app/controllers/api/users_controller.rb
```
   def index
     ...
     render json: users, each_serializer: UserSerializer
   end
  ```
### Test Your Code
1. Create users via the Rails console.
1. From the command line, retrieve all the users via a curl request. Replace  username and password with a valid username and password:

Terminal
$ curl -u username:password http://localhost:3000/api/users/
Try to retrieve all users using an invalid username and password combination, verify the request fails.

## Create From the Command Line
As a user, I want to create new users, lists, and items from the command line

Edit Routes
Edit routes.rb to provide the API routes for Lists and Items:

app/config/routes.rb
```
   namespace :api, defaults: { format: :json } do
     resources :users
     resources :users do
       resources :lists
     end

     resources :lists, only: [] do
       resources :items, only: [:create]
     end

     resources :items, only: [:destroy]
   end
   ```
### Create List and Item Controllers
Create ListsController and ItemsController to match the API routes:

app/controllers/api/lists_controller.rb
```
 class Api::ListsController < ApiController
   before_action :authenticated?
 
   def create
   end
 
 end
 ```
app/controllers/api/items_controller.rb
```
 class Api::ItemsController < ApiController
   before_action :authenticated?
 
   def create
   end

 end
 ```
In UsersController, add a create method and a private users_params method. User only requires username and password parameters:

app/controllers/api/users_controller.rb
```
 class Api::UsersController < ApiController
   ...
   def create
   end

   private
   def user_params
     params.require(:user).permit(:username, :password)
   end
 end
 ```
Use user_params in create to create and save a new User:

app/controllers/api/users_controller.rb
```
 class Api::UsersController < ApiController
 ...
   def create
     user = User.new(user_params)
     if user.save
       render json: user
     else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
     end
   end
   ```
## Test From Command Line
Test create from the command line:

Terminal
$ curl -u username:password -d "user[username]=Sterling" -d "user[password]=Archer" http://localhost:3000/api/users/
Once user creation is working, implement list creation. To test list creation, use curl from the command line to create a new list for the first user:

Terminal
$ curl -u username:password -d "list[name]=Things to do today" -d "list[permissions]=private" http://localhost:3000/api/users/1/lists
Once list creation is working, implement item creation. To test item creation, use curl from the command line to create a new item for the first list:

Terminal
$ curl -u username:password -d "item[description]=Dance if you want to" http://localhost:3000/api/lists/1/items
Test Your Code
Modify the curl request for creating users to send a request without a password. Confirm an error message is returned, and a user is not created.
Modify the curl request for creating users to send a request without a username. Confirm an error message is returned, and a user is not created.
Modify the curl request for creating lists to send a request without a name. Confirm an error message is returned, and a list is not created.
Modify the curl request for creating items to send a request without a description. Confirm an error message is returned, and an item is not created.

## Destroy Lists
As a user, I want to remove users and lists from the command line

### Modify the Users Controller
Add a destroy method to UsersController:

app/controllers/api/users_controller.rb
```
 class Api::UsersController < ApiController
   ...
   def destroy
     begin
       user = User.find(params[:id])
       user.destroy
       render json: {}, status: :no_content
     rescue ActiveRecord::RecordNotFound
       render :json => {}, :status => :not_found
     end
   end
   ...
 end
```
Implement list deletion as well.

### Test Your Code
Test User deletion from the command line:

Terminal
$ curl -u username:password -X DELETE http://localhost:3000/api/users/1/
Test List deletion from the command line:

Terminal
$ curl -u username:password -X DELETE http://localhost:3000/api/users/1/lists/1

## Update Lists and Items
As a user, I want to update list and item attributes from the command line

### Controllers
Allow users to change a list's private attribute from the command line. Add an  update method to ListsController:

app/controllers/api/lists_controller.rb
```
 class Api::ListsController < ApiController
 ...
 def update
   list = List.find(params[:id])
   if list.update(list_params)
     render json: list
   else
     render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
   end
 end
 ```
Add the ability to update items and mark them as complete to ItemsController.

### Test Your Code
Test list permission updates from the command line:

Terminal
$ curl -X PUT -u username:password -d "list[private]=true" http://localhost:3000/api/lists/1
Test item completion from the command line:

Terminal
$ curl -X PUT -u username:password -d "item[completed]=true" http://localhost:3000
