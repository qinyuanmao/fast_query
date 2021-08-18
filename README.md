# FastQuery

快速创建查询，实现查询统一配置，给前端统一接口，统一生成 scope 查询

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_query'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fast_query

## Usage

```ruby
# config/initializers/fast_query.rb
FastQuery.init_query do
  group :user do
    query :kind, -> (kind, user) do
      where(kind: :manager)
    end
  end
end
```

```yaml
# config/locales/query.zh-CN.yml
zh-CN:
  query:
    member:
      kind:
        label: 用户角色
        hidden: false
        type: radio_button
        condition_type: options/array/search
        conditions:
          # options
          - 'User'
          - 'kind_options'
          # array
          - - 普通用户
            - user
          - - 管理员
            - manager
          # search
          - Role
          - "key = 'aaa'"
          - name
          - id
```

```ruby
class ApplicationController < ActionController::Base
  include FastQuery::LoadQuery
end
```

```ruby
class UsersController < ApplicationController
  load_query :user, only: %w[index]
  
  def index
    @items = @items.where(xxx: :xxxx)
  end
end
```

```ruby
# use
FastQuery.query_set(:user, :kind)
# [{
#   :label=>"用户角色",
#   :hidden=>false,
#   :type=>"radio_button",
#   :condition_type=>"options",
#   :conditions=>[
#       ["普通用户", "user"],
#       ["管理员", "manager"],
#   ],
#   :key=>:kind
# }]
```
