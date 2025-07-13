+++
title = 'Canonical Urls on Fly.io'
date = 2024-04-25T08:26:13+02:00
tags = ['fly.io', 'dev', 'blog', 'docker']
draft = false
summary = "How to configure your static site to use your canonical url - dropping the `www` and redirecting traffic to your apex domain name on Fly.io."
+++

{{<lead>}}
How to configure your static site to use your canonical URL, dropping the "www" and redirecting traffic to your apex domain name, on Fly.io.
{{</lead>}}

## Canonical URLs

### Canonical?
Canonical for our purposes just simply means "primary source." For reasons ([Google has outlined a few](https://developers.google.com/search/docs/crawling-indexing/canonicalization) ) we do not want to split our traffic between "www" and our apex domain. For example: `www.blog.dev` and `blog.dev` are basically 2 different websites and less than optimal for some analytics and google search results.

What we really want is for anyone (using our previous example) typing in `www.blog.dev` to be redirected to `blog.dev` without the "www" in front. Fly.io has rightly decided not make this a configuration option when deploying our site (they do handle our "http to https" redirects perfectly though). So when searching for how to do this on Fly.io, we get recommendations like, "just configure your app to that."

## Just configure your app to do that

Fly.io has pushed the responsibility to of redirecting our traffic back to us. The good news is that we won't need to set up any [volumes](https://fly.io/docs/machines/api/volumes-resource/#main-content-start) or create any [secrets](https://fly.io/docs/js/the-basics/secrets/#main-content-start). We do need 2 things though:

1. Make sure our web server can handle redirects, and
2. Add a configuration file to our Dockerfile.

### 1. Web servers and Redirects

In my [Up and Running With Hugo](/posts/up-and-running-hugo/) post I walked you through setting up your blog with the [goStatic web server](https://github.com/PierreZ/goStatic) which is an amazingly fast and lightweight choice. Unfortunately there is no way to configure goStatic to handle our URL redirects. We need a new web server. The good news is that is not a problem in our modern world of containers.

There are a lot of options to choose from, but for this example we are going to set things up with SWS ([static-web-server](https://github.com/static-web-server/static-web-server) ) a super fast, pretty small web server with some great configuration options. And yes, naming things is hard ;).

### 2. Configuration

#### Create our toml file
We want to create a local configuration file that will be available when we deploy our server. Let's create a file `config.toml` in the root of our project. Likely your config.toml file will grow over time. You can see the documented options from their [configuration site page](https://static-web-server.net/configuration/config-file/).

_config.toml_
```toml
[advanced]
[[advanced.redirects]]
host = "www.blog-name.com"
source = "/{*}"
destination = "https://blog-name.com/$1"
kind = 30
```

Just replace `blog-name` with your domain name. Once that is created we just need to make the file accessible when we deploy!


#### Create our Dockerfile

Assuming you have your static files in a directory named `pubic/` and your `config.toml` file in the root of your project, your Dockerfile will look like this.

_Dockerfile_
```Dockerfile
FROM joseluisq/static-web-server:2-alpine
COPY ./config.toml ./config.toml
COPY ./public/ /public
```

#### Update Fly.toml

We just need to make sure our `fly.toml` file is aligned with the new web server default ports. Make sure your `internal_port` is set to `80`. Your fly.toml should look something like this with your `app` and `primary_region` configured differently for your application.

_fly.toml_
```toml
app = 'blog-name'
primary_region = 'waw'

[build]

[http_service]
  internal_port = 80
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1
  processes = ['app']

[[vm]]
  memory = '1gb'
  cpu_kind = 'shared'
  cpus =
```

## Fly Away!

Once all of the configuration is complete you are ready to deploy on Fly.io.

```console
$ fly deploy
```

 Make sure your are not getting any errors. Assuming all went well it is time to test your hard work.

 Just type "www.your-blog-name.com" in the browser and you should be redirected (although it's hard to see) to "https://your-blog-name.com"

 Now you can rest in the knowledge that all of your visitors will politely be directed to the correct and canonical URL.

 ## Feedback

 I hope you found this post helpful. Feel free to [DM on Twitter @mkumm](https://twitter.com/mkumm) email me at [mike @ mkumm.com](mailto:mike@mkumm.com) with any feedback or questions.

 ## Endnotes

 - (1) The ASCII art at the top of this post is (kind of) a hidden graphic from the Fly.io site. If you open up developer tools in Chrome while on [Fly.io](https://fly.io) you will see the ASCII art in the console output.

 ```txt
 # console output from fly.io
       _-.:.-_
    .'-/_:-:_\-'.
   /_'/__ |__'._'\
  '__(___.)___ )_ '
  (__(___ )___ )__)
  .__(___.(__  )_ .
   \__\__ )__ /__/
    -__\ _(_ )__-
     \ _\_)./_ /
       \_.|_./
        |_|_|
          |
         [_]

      Let's Fly
```
