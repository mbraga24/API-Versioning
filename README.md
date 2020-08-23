# API Versioning - _Highlights_

### Create A Versioned Directory For Our Controllers

```
// First we create the api directory
mkdir my-dope-api/app/controllers/api

// Followed by the v1 directory
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
// This command will create the migration, the model files, and all the boilerplate code.
rails g model product name:string brand:string price:string description:string --no-helper --no-assets --no-template-engine --no-test-framework
```

### Create Database And Run Migrations

```
// Create the database
rake db:create

// Run the migration files
rake db:migrate
```

### Add Code To The Products Controller

_Now we can put some time into the code that will allow us to persist and read data from our database._

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

### Add Test Data

_We can run rails c or rails console to start a development environment._

```
// The IRB should look something like this:
irb(main):001:0>

// To add a product run:
irb(main):001:0> p = Product.new(name: "PS4", brand: "Sony", price: "$400.00 USD", description: "NextGen Gaming Console")
```
*__Your output should look like this:__*

```
// Output
=> #<Product id: nil, name: "PS4", brand: "Sony", price: "$400.00 USD", description: "NextGen Gaming Console", created_at: nil, updated_at: nil>

// Since we have a product value assigned to a variable we can call save on our variable and see if it works.
irb(main):002:0> p.save
```

*__Now when you call p in the IRB you should see that our first product now has an id.__*

```
irb(main):003:0> p
=> #<Product id: 1, name: "PS4", brand: "Sony", price: "$400.00 USD", description: "NextGen Gaming Console", created_at: "2020-08-03 00:00:34", updated_at: "2020-08-03 00:00:34">
```
_Now exit the irb by typing exit into your terminal._

### Add Seed Data

_In the db directory, Rails includes a seeds.rb file which we will use to add our seed data._

```
Product.destroy_all

# Creates an array of 8 elements from 1 - 8
product_numbers = [*1..8]

# Creates 8 products
product_numbers.each do |num|
  Product.create(
    name: "Product name_#{num}",
    brand: "Product brand_#{num}",
    price: "$#{num}00.00",
    description: "Product description_#{num}"
  )
end
```

*__Now we just need to run the command rails db:seed and then run our Rails server again.__*

```
// Run the Rails server
rails s
// Open a browser window and go to 
http://localhost:3000/api/v1/products/
```

_You should be able to see all the products._

## Article source: ##

_The steps shown here were taken from this [article](https://medium.com/swlh/how-to-build-an-api-with-ruby-on-rails-28e27d47455a) for personal documentation and to be revisited when needed_
