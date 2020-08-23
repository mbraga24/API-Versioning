# API Versioning - _Highlights_

### Create A Versioned Directory For Our Controllers

*__First we create the api directory__*
```
mkdir my-dope-api/app/controllers/api
```

*__Followed by the v1 directory__*
```
mkdir my-dope-api/app/controllers/api/v1
```

### Generate Controllers
```
rails g controller api/v1/products index show --no-helper --no-assets --no-template-engine --no-test-framework
```

*__You should see something like this on the terminal:__*

```
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'products/index'
      get 'products/show'
    end
  end
end
```
*__Change your boiler plate routes to this:__*

```
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show, :create]
    end
  end
end
```

### Generate Models And Migrations

```
rails g model product name:string brand:string price:string description:string --no-helper --no-assets --no-template-engine --no-test-framework
```

*__This command will create the migration, the model files, and all the boilerplate code.__*

### Create Database And Run Migrations

*__Create the database__*
```
rake db:create
```
*__Run the migration files__*
```
rake db:migrate
```

### Add Code To The Products Controller

*__Now we can put some time into the code that will allow us to persist and read data from our database.__*

```
class Api::V1::ProductsController < ApplicationController
  # index renders all items in the products table
  def index
    products = Products.all

    render json: products, status: 200
  end

  # As the name implies this action let's us create a new product.
  # If the product saves correctly, we render the json data for the product.
  # If the product does not save correctly we render an error object.
  def create
    product = Product.new(
      name: prod_params[:name],
      brand: prod_params[:brand],
      price: prod_params[:price],
      description: prod_params[:description]
    )

    if product.save
      render json: product, status: 200
    else
      render json: {error: "Error creating review."}
    end
  end
  
  # This method look up the product by the id, if it is found we render the json object.
  # Otherwise we render an error object. 
  def show
    product = Product.find_by(id: params[:id])

    if product 
      render json: product, status: 200
    else
      render json: {error: "Product not found."}
    end
  end

  # This private method is only available to this controller.
  # It uses the built-in methods .require and .permit provided by ActionController.
  private
  def prod_params 
    params.require(:product).permit([
      :name,
      :brand,
      :price,
      :description
    ])
  end 
end
```

_Action Controller Parameters_
> Allows you to choose which attributes should be permitted for mass updating and thus prevent accidentally exposing that which shouldn’t be exposed. Provides two methods for this purpose: require and permit. The former is used to mark parameters as required. The latter is used to set the parameter as permitted and limit which attributes should be allowed for mass updating.