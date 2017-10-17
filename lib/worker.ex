defmodule Metex.Worker do
	@moduledoc """
	Having `use GenServer` makes available all callbacks needed by the GenServer

	These callbacks include:
		• init(args)
		• handle_call(msg, {from, ref}, state}
		• handle_cast(msg, state}
		• handle_info(msg, state)
		• terminate(reason, state)
		• code_change(old_vsn, state, extra)

	"""
	use GenServer

	## Client API

	@doc """
	GenServer.start_link/3 takes in the module name of the GenServer
	implementation where init/1 is defined. It starts the process and also
	links the server process to the parent process.

	This means that if the server process fails for some reason,
	the parent process would be notified.

	The second argument is what is expected as an argument in the init
	function.

	The final argument defines a list of options to be passed to GenServer.start_link/3
	"""
	def start_link(opts \\ []) do
		GenServer.start_link(__MODULE__, :ok, opts)
	end

	def get_temperature(pid, location) do
		GenServer.call(pid, {:location, location})
	end

	def get_current_state(pid) do
		GenServer.call(pid, :get_current_state)
	end

	def reset_state(pid) do
		GenServer.cast(pid, :reset_state)
	end

	## Server Callbacks

	def handle_call({:location, location}, _from, state) do
		case temperature_of(location) do
			{:ok, temp} ->
				new_state = update_stats(state, location)
				{:reply, "#{temp}°C", new_state}
			_ ->
				{:reply, :error, state}
		end
	end

	def handle_call(:get_current_state, _from, state), do: {:reply, state, state}
	def handle_cast(:reset_state, _state), do: {:noreply, %{}}

	@doc """
	Initialise the GenServer implementation. It returns a struct containing
	:ok and and empty Map. The map will be used to keep the frequency of
	requested locations
	"""
	def init(:ok) do
		{:ok, %{}}
	end

	## Helper Functions
	defp temperature_of(location) do
		url_for(location)
		|> HTTPoison.get
		|> parse_response
	end

	defp url_for(location) do
		"http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=94aef35b356b0e3c618222e49ddf0423"
	end

	defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
		body |> JSON.decode! |> compute_temperature
	end
	defp parse_response(_), do: {:error, "invalid input"}

	defp compute_temperature(%{"main" => %{"temp" => temp}}) do
		temp = (temp - 273.15) |> Float.round(1)
		{:ok, temp}
	end
	defp compute_temperature(%{"cod" => cod, "message" => msg}), do: {:error, "#{cod}: #{msg}"}

	defp update_stats(old_stats, location) do
		case Map.has_key?(old_stats, location) do
			true ->
				Map.update!(old_stats, location, &(&1 + 1))
			false ->
				Map.put_new(old_stats, location, 1)
		end
	end
end
