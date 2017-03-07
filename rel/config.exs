# Import all plugins from `rel/plugins`
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :desqer,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"!4K@lR@0[$|X2Nyhc:;ybH)=t>V9%C/2Tm4kkUkBU,78NbF0t(/)G8~??j|2V){e"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"n~=A<88P`44;eYce%mH9}Duz(ItYPP?iPvXcD9)c6XYecGhDzo{w|Ae]n~`0p(gP"
end

release :desqer do
  set version: current_version(:desqer)
end
