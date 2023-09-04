# Twitter

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## On Windows systems:
1. First download and install Visual Studio. For example, 2022 version.

2. Inside of command line shell, run `cmd /K "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64`, otherwise you might not able to compile some modules.  

For more information, have a look at [this](https://stackoverflow.com/questions/49471198/how-to-fix-could-not-compile-dependency-bcrypt-elixir-error-on-windows) : 

3. Then run `mix.bat setup` and  `iex.bat -S mix.bat phx.server`, for Windows might misunderstand `mix` and `iex` command. 

# How to add avatar

  * Download and save the image in "priv/static/images/" directory
  * Access this image in "localhost:4000/images/" directory

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
