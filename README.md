# Fflux

## Description

Fflux is a dead simple and super fast InfluxDB UDP writer

## Installation

**Install the Gem**

Add to your `Gemfile`

```
gem "fflux"
```

**Configure**

```
Fflux.setup do |config|
  config.host = '127.0.0.1'
  config.port = 4444
end
```

## Usage

There is a single class method `write` that does everything supported right now

```
# Write a simple measurement

Fflux.write("cpu", { value: 100 })

# Write multiple values

Fflux.write("memory", { free: 100, allocated: 800 })

# Measurements with values

Fflux.write("event", { message: "Something happened" }, { environment: "test" })
```

__Do note that this implements the post 0.9.3 Line Protocol so integers are followed by `i`__

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
