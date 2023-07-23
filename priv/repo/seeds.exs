# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twitter.Repo.insert!(%Twitter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
popular_languages = [
  "Python",
  "JavaScript",
  "Java",
  "C++",
  "C#",
  "TypeScript",
  "PHP",
  "Swift",
  "Ruby",
  "Go",
  "Kotlin",
  "Rust",
  "MATLAB",
  "R",
  "Perl"
]
Enum.each(popular_languages, fn (language) ->
  Twitter.Forum.create_category(%{name: language})
end
  )
