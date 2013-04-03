## What?

Provides [GitHub status notifications](https://github.com/blog/1227-commit-status-api) when running tests through [Tddium](http://tddium.com).

## How?

Add `tddium-status-github` to your Gemfile.

And, in your Rakefile make sure to include:

```ruby
require 'tddium-status-github'
```

### Or

Add the following to your `tddium.yml` configuration:
```yaml
:tddium:
  # Existing configuration...
  :boot_hook: >
    /usr/bin/env sh -c "gem install --user-install --no-rdoc --no-ri tddium-status-github &&
    echo '$:.concat(Dir.glob(File.join(Gem.user_dir, \"gems\", \"*\", \"lib\"))); require \"tddium-status-github\"' >> Rakefile"
```

## Copyright and license

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
