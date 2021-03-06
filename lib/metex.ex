defmodule Metex do
	def temperatures_of(cities) do
		coordinator_pid = 
			spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])

		Enum.each(cities, fn city ->  
			worker_pid = spawn(Metex.Worker, :loop, [])
			send(worker_pid, {coordinator_pid, city})
		end)
	end
end