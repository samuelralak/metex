defmodule Metex.Worker do
	use GenServer

	# def start_link(opts // []) do
	# 	GenServer.start_link(__MODULE__, :ok, opts // [])
	# end
	#
	# def init(:ok) do
	# 	{:ok, %{}}
	# end
	#
	# def loop do
	# 	receive do
	# 		{sender_pid, location} ->
	# 			send(sender_pid, {:ok, temperature_of(location)})
	# 		_ ->
	# 			# send(sender_pid, "Unknown message")
	# 			{:error, "Unknown message"}
	# 	end
	#
	# 	loop()
	# end
	#
	# def temperature_of(location) do
	# 	url_for(location)
	# 	|> HTTPoison.get
	# 	|> parse_response
	# 	|> case  do
	# 		{:ok, temp} ->
	# 			"#{location}: #{temp}°C"
	# 		{:error, message} ->
	# 			message
	# 	end
	# end
	#
	# defp url_for(location) do
	# 	"http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=94aef35b356b0e3c618222e49ddf0423"
	# end
	#
	# defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
	# 	body
	# 	|> JSON.decode!
	# 	|> compute_temperature
	# end
	#
	# defp parse_response(_), do: {:error, "invalid input"}
	#
	# defp compute_temperature(%{"main" => %{"temp" => temp}}) do
	# 	temp = (temp - 273.15) |> Float.round(1)
	# 	{:ok, temp}
	# end
	#
	# defp compute_temperature(%{"cod" => cod, "message" => msg}) do
	# 	{:error, "#{cod}: #{msg}"}
	# end
end
