# API Versioning - _Highlights_

### Create A Versioned Directory For Our Controllers

__First we create the api directory__
```
mkdir my-dope-api/app/controllers/api
```

__Followed by the v1 directory__
```
mkdir my-dope-api/app/controllers/api/v1
```

### Generate Controllers
```
rails g controller api/v1/products index show --no-helper --no-assets --no-template-engine --no-test-framework
```

__You should see something like this on the terminal:___

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
__Change your boiler plate routes to this:__

```
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show, :create]
    end
  end
end
```