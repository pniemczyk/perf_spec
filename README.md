# PerfSpec

[![Gem Version](https://badge.fury.io/rb/pref_spec.svg)](http://badge.fury.io/rb/pref_spec)
[![Build Status](https://travis-ci.org/pniemczyk/pref_spec.svg?branch=0.2.0)](https://travis-ci.org/pniemczyk/pref_spec)
[![Dependency Status](https://gemnasium.com/pniemczyk/pref_spec.svg)](https://gemnasium.com/pniemczyk/pref_spec)
[![Coverage Status](https://coveralls.io/repos/pniemczyk/pref_spec/badge.png)](https://coveralls.io/r/pniemczyk/pref_spec)

This gem can help you with performance testing your requests. The matcher `take_less_than` test request time expectations and if test fail generate output with details what takes so long (code, rendering, SQL)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'perf_spec'
```

## Usage
```ruby

RSpec.describe 'ApiCarShow', type: :request do
  it 'request takes less then 10 seconds' do
    expect do
      get api_car_path(@car.id), {}
    end.to take_less_than(0.01)
  end
end
```

when fail it returns:

```
Failures:

  1) ApiCarShow GET /api/cars/:id after authenticated cars speed test
     Failure/Error: expect do
       expected that block take less than 0.01 but takes 0.045884
       Takes controller: controller: 0.040161, view: 0, partial_view: 0, sql: 0.006124, other: 0
       {
         :sql        => [
           [ 0] {
             :duration => 0.0007099999999999999,
             :name     => "Device Load",
             :sql      => "SELECT  \"devices\".* FROM \"devices\"  WHERE \"devices\".\"auth_token\" = 'TEST_AUTH_TOKEN' LIMIT 1",
             :method   => "block in authenticate_token",
             :filename => "/app/controllers/api/base_controller.rb"
           },
           ...
           [10] {
             :duration => 0.000594,
             :name     => "Document Load",
             :sql      => "SELECT \"documents\".* FROM \"documents\" INNER JOIN \"car_multilanguages_documents\" ON \"documents\".\"id\" = \"car_multilanguages_documents\".\"document_id\" WHERE \"car_multilanguages_documents\".\"car_multilanguage_id\" = $1",
             :method   => "block (2 levels) in _app_views_api_cars_show_json_jbuilder__1960233950839888821_70181062760260",
             :filename => "/app/views/api/cars/show.json.jbuilder"
           }
         ],
         :controller => [
           [0] {
             :duration => 0.040161
           }
         ]
       }
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/perf_spec/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
