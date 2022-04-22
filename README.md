# boathook

Rake tasks for managing an application's Docker images

## Quick Start

### Installation

In your `Gemfile`:

```ruby
gem 'boathook', git: 'https://github.com/umd-lib/boathook'
```

Then run `bundle install`.

### Usage

In your `Rakefile` or `*.rake` task file:

```ruby
require 'boathook'

namespace :docker do
  Boathook::DockerTasks.new do |t|
    t.version = 'app-version'
    t.image_specs = [
      {
        name: 'image-name',
        dockerfile: 'path/to/Dockerfile',  # defaults to 'Dockerfile'
        context: 'path/to/context/dir'     # defaults to '.'
      }
      # if your project has multiple Docker images to build, you can add
      # additional image specs here
    ]
  end
end
```

Now there are three tasks added to your project:

* `docker:tags` shows you the full Docker name:tag value for each image it will build
* `docker:build` builds the Docker images
* `docker:push` push the images to a remote repository

## Tags and Labels

If the `version` includes the string "dev", the tag will be "latest". Otherwise, it will be the value of `version`.

In addition to tagging the image with the version, `docker:build` also applies the following labels to the newly created image:

* `org.opencontainer.images.version` is the version as given in the constructor block
* `org.opencontainer.images.revision` is the current git revision of the project, as determined by running `git rev-parse HEAD` in the working directory

If you have [jq] installed, you can easily verify these labels by running:

```bash
docker image inspect image-name:tag | jq '.[].Config.Labels'
```

## The Name

This library is built on top of [Mattock], which itself is built on top of [Rake]. Combine these with the fact that Docker is already heavily nautically themed, and you get: [Boathook]!

## License

See the [LICENSE](LICENSE) file for license rights and limitations (Apache 2.0).

[jq]: https://stedolan.github.io/jq/
[Mattock]: https://rubygems.org/gems/mattock
[Rake]: https://ruby.github.io/rake/
[Boathook]: https://github.com/umd-lib/boathook
