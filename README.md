# SideProjectTracker [backend]

Backend in Elixir for [SideProjectTracker [frontend]](https://github.com/ardhena/side-project-tracker-frontend).

Backend uses maru library for creating web API. All data is stored in a GenServer/Agent and periodically saved to a file.

## Development

```bash
$ mix deps.get
$ iex -S mix
```
