## app_report-ruby  
  
[![Gem Version](https://badge.fury.io/rb/app_report.png)](https://rubygems.org/gems/app_report)  
  
Ruby client to [AppReport API](http://reports.simpleservic.es/), the AppReport API allows you to generate pdf reports based on Jasper library in a really simple way. 

### installation  
```console
# add to Gemfile
gem 'app_report'  

# and run the install command 
bundle install
```

### use

* First, draw your jasper report using your prefered tool, like [i-report designer](http://community.jaspersoft.com/project/ireport-designer), a powerfull opensource tool to design reports.  

* After, upload the .jrxml file to [AppReport site](http://reports.simpleservic.es/), as a "report template". 

* And then, just connect your app to AppReport API using this gem:

  ```ruby  
  # config/initializers/app_report.rb
  AppReport.configure do |config|
    config.app_name   = '...'
    config.access_key = '...'
    config.secret_key = '...'
  end

  # your_script.rb:
  xml_data_source = File.open('data_source.xml').read

  # or, if you are using Rails, you can render a view, eg:
  xml_data_source = render 'products/data_source.xml.erb'

  report_options = {  
    :template_name    => 'products',
    :data_type        => 'xml',
    :data             => xml_data_source,
    :xpath_expression => '/products/product',
    :args             => { :key => 'value' }
  }

  api    = AppReport::API::Jasper.new
  report = AppReport::Report::Jasper.new report_options

  pdf_raw = api.build! report
  File.open("./report.pdf", 'w') { |f| f.write(pdf_raw) }
    
  ```  

<b>Just it!</b> AppReport is a really simple, no complex configurations or boring installations are required, just connect to AppReport API and start generating reports!