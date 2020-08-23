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
```rake db:create```
*__Run the migration files__*
```rake db:migrate```