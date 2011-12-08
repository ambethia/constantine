# Constantine

``` ruby
module Support
  class Ticket
  end
end

> Constantine.constantize("SupportTicket")
=> Support::Ticket 
```

## Caveat Emptor!

A railtie exists for patching ActiveSupport's implementation:

``` ruby
"SupportTicket".constantize
```

The idea was to allow more implicit definitions in a Rails app with a lot of
namespace modules:

``` ruby
has_many :support_tickets
```

instead of

``` ruby
has_many :support_tickets, :class_name => "Support::Ticket"
```

It seems to break too much auto-loading to be useful, so I honestly can't
actually recommend using this for anything right now. It's just an experiment.

# Copyright

Copyright (c) 2011 Jason L Perry. See LICENSE for details.
