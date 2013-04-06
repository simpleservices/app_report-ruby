## app_report-ruby  
  
[![Gem Version](https://badge.fury.io/rb/app_report.png)](https://rubygems.org/gems/app_report)  
  
app_report-ruby is a Ruby client to [AppReport API](http://reports.simpleservic.es/), it allows you to generate pdf reports based on Jasper library in a simple way. 

### installation  
```console
# add to Gemfile
gem 'app_report', '~> 0.0.2'  

# and run the install command 
bundle install
```

### Try it now

* This example assumes that you already drawn your report using some tool like [i-report designer](http://community.jaspersoft.com/project/ireport-designer) and uploaded the .jrxml file to the [AppReport site](http://reports.simpleservic.es/), as a "report template",  
    
  to make the things easy, we did it for you :) yay donuts for us.

  ```ruby  
  # config/initializers/app_report.rb
  AppReport.configure do |config|
    config.app_name   = shop
    config.access_key = udPONmbmD01MnxzMVgiL
    config.secret_key = ExINJLBR1I6Au6Hu0gQQoQmTMXAZuHk1Tkx3N19V
  end

  # app/your_script.rb:  
  xml_data = File.open('data_source.xml').read

  # or, if you are on Rails, you can render a xml view, eg:
  xml_data = render_to_string 'datasource.xml.builder'

  report_options = {  
    :template_name    => 'products',
    :data_type        => 'xml',
    :data             => xml_data,
    :xpath_expression => '/products/product',
    :args             => { :key => 'value' }
  }

  api     = AppReport::API::Jasper.new
  report  = AppReport::Report::Jasper.new report_options
  pdf_raw = api.build! report
    
  # store the result
  File.open("./report.pdf", 'w') { |f| f.write(pdf_raw) }
  
  # or, if you are on Rails, you can send the result, eg:
  send_data pdf_raw, :type => 'application/pdf', :disposition => 'inline', :filename => 'report.pdf'
  ```  

<b>Just it!</b> AppReport is a really simple, no complex configurations or boring installations are required, just connect to AppReport API and start generating reports!