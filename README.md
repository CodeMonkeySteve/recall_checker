# RecallChecker

This library helps you to check if a vehicle has [NHTSA](http://www.nhtsa.gov/)-registered safety recalls.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recall_checker', git: 'git@github.com:AutoCloud/recall_checker.git'
```

## Usage

### Checking for recalls

Basically, all you need is to create a new object using the car's VIN and make name, and then call `.recalls` to load the recall data. 

```ruby
recalls = RecallChecker.find_by_make_and_vin('Honda', '19XFB2F56EE264518').recalls
```

You can use `RecallChecker.supported?` with a make name to check if the make is supported. Currently, the library supports the following makes: Acura, Alfa Romeo, Audi, BMW, Buick, Cadillac, Chevrolet, Chrysler, Dodge, FIAT, Ford, GMC, Honda, HUMMER, Hyundai, Infiniti, Jaguar, Jeep, Kia, Land Rover, Lexus, Lincoln, Maybach, Mazda, Mercedes-Benz, Mercury, MINI, Mitsubishi, Nissan, Oldsmobile, Pontiac, Porsche, Ram, Saab, Saturn, Scion, Smart, Subaru, Toyota, Volkswagen, Volvo. Please note that the library mostly uses undocumented APIs of the manufacturer sites to obtain the recall data, so we cannot guarantee that it will work properly in the future. However, we'll try to do our best to keep it up-to-date.

The recall data is returned as an array of hashes each of which contains information on an individual recall. If there are no open safety recalls for a certain vehicle, an empty array is returned. 

Each hash includes the following fields: `title`, `nhtsa_id`, `manufacturer_id`, `description`, `risks`, `remedy`, `status`, `notes`, `created_at`, `updated_at`. The last two fields are `Date`, the others are `String`.

Note that Toyota site requires solving captcha to obtain the recall data. You can implement solving the captcha manually or use a captcha-decoding service. The library includes an [interface](https://github.com/AutoCloud/recall_checker/blob/master/lib/recall_checker/captcha_solver/captcha_solver.rb) for the [ExpertDecoders](http://expertdecoders.com/) service; you can register there and just supply the access key before instantiating the RecallChecker objects:

```ruby
RecallChecker::CaptchaSolver.set_access_key("YOUR_SECRET_ACCESS_KEY")
```

### VIN validation

At instantiation, the VIN is checked for correct format (exactly 17 characters; alphanumerics only, except I, O, and Q). Also, it is validated using the [check digit algorithm](https://en.wikibooks.org/wiki/Vehicle_Identification_Numbers_%28VIN_codes%29/Check_digit); the proper check digit (position 9) in the VIN is considered compulsory in USA and is used by most manufacturers worldwide.

Even if you don't need the recall checking functionality, you can use the VIN validation separately; it is provided in [its own class](https://github.com/AutoCloud/recall_checker/tree/master/lib/recall_checker/vin_validator).

### Exceptions

If the supplied VIN doesn't pass the validation or if it isn't found in the manufacturer's database, the `RecallChecker::VinError` exception is raised. Also, the library can raise some other exceptions; you can see the full list [here](https://github.com/AutoCloud/recall_checker/blob/master/lib/recall_checker/exceptions.rb).

### Loading recall initiation data from NHTSA feed

The library also allows you to load information about new recall campaigns from the [NHTSA's RSS feed](http://www-odi.nhtsa.dot.gov/rss/feeds/rss_recalls_V.xml). The RSS data is parsed, and then the information for the corresponding recalls (based on their NHTSA IDs) is automatically loaded using the [official NHTSA web API](http://www.nhtsa.gov/webapi/Default.aspx?Recalls/API/83).

The RSS feed contains data for the last month; by default, the class loads data for the last two weeks, but you can set some other date limit if you need:

```ruby
recalls = RecallChecker::NHTSAFeed.new.recalls
newest_recalls = RecallChecker::NHTSAFeed.new(Date.today - 1).recalls
```

The returned information is pretty similar to the recall checks by VIN; however, this function loads data for certain makes/models rather than individual vehicles. Each hash in the returned array contains the following fields: `make`, `model`, `year`, `component`, `manufacturer`, `created_at`, `nhtsa_id`, `description`, `risks`, `remedy`, `notes`. Please note that the `year` field is an `Integer`.

## Useful links

[Recall look-up by VIN in the NHTSA database](https://vinrcl.safercar.gov/vin/)
[Search for safety issues by make, model, and model year](http://www-odi.nhtsa.dot.gov/owners/SearchSafetyIssues)
[NHTSA WebAPIs](http://www.nhtsa.gov/webapi/Default.aspx)
