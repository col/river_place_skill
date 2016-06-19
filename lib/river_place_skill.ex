defmodule RiverPlaceSkill do
  use Alexa.Skill, app_id: Application.get_env(:river_place_skill, :app_id)
  alias RiverPlace.TimeSlot
  alias RiverPlaceSkill.Booking
  alias Alexa.{Request, Response}

  @river_place_api Application.get_env(:river_place_skill, :river_place_api)

  def handle_intent("Login", request, response) do
    username = Request.slot_value(request, "username")
    password = Request.slot_value(request, "password")
    case @river_place_api.login(username, password) do
      :ok ->
        response |> say("Hello") |> should_end_session(true)
      :error ->
        response |> say("Sorry, your login failed.") |> should_end_session(true)
    end
  end

  def handle_intent("Logout", request, response) do
    @river_place_api.logout
    response
      |> say("Good bye")
      |> should_end_session(true)
  end

  def handle_intent("CreateBooking", request, response) do
    booking(request) |> create_booking(response)
  end

  defp create_booking(booking = %{date: nil, time: nil}, response) do
    response
      |> say("Ok. When would you like to play?")
      |> should_end_session(false)
  end

  defp create_booking(booking = %{date: date, time: nil}, response) do
    response
      |> say("What time would you like to play?")
      |> Response.set_attribute("date", booking.date)
      |> should_end_session(false)
  end

  defp create_booking(booking = %{date: nil, time: time}, response) do
    response
      |> say("What day would you like to play?")
      |> Response.set_attribute("time", booking.time)
      |> should_end_session(false)
  end

  defp create_booking(booking = %{time: time, available: []}, response) do
    response
      |> say_ssml("Sorry. #{say_time(time)} is not available")
      |> reprompt("Would you like to choose a different time?")
      |> Response.set_attribute("date", booking.date)
      |> Response.set_attribute("time", booking.time)
      |> should_end_session(false)
  end

  defp create_booking(booking = %{date: date, time: time, available: [first|_]}, response) do
    case @river_place_api.create_booking(date, first) do
      :ok ->
        response
          |> say_ssml("OK, I've booked #{first.facility_name} for you at #{say_time(time)}")
          |> should_end_session(true)
      :error ->
        response
          |> say("An error occurred while booking your court. Please try again later.")
          |> should_end_session(true)
    end
  end

  defp request_attributes(request) do
    attribs = Request.attributes(request)
    Request.slot_attributes(request)
      |> Map.update("time", nil, fn(t) -> to_12hr_time(t) end)
      |> Map.put_new("date", Map.get(attribs, "date"))
      |> Map.put_new("time", Map.get(attribs, "time"))
  end

  defp booking(request) do
    attribs = request_attributes(request)
    date = Map.get(attribs, "date", nil)
    time = Map.get(attribs, "time", nil)
    %Booking{
      date: date,
      time: time,
      available: available_time_slots(date, time)
    }
  end

  defp available_time_slots(nil, nil) do
    []
  end

  defp available_time_slots(date, nil) do
    []
  end

  defp available_time_slots(nil, time) do
    []
  end

  defp available_time_slots(date, time) do
    @river_place_api.time_slots(date)
      |> TimeSlot.available
      |> TimeSlot.for_time(time)
  end

  defp to_12hr_time(time) do
    hours = String.split(time, ":") |> List.first |> String.to_integer
    suffix = if hours > 12, do: "PM", else: "AM"
    hours = if hours > 12, do: hours = hours - 12, else: hours
    "#{String.rjust("#{hours}", 2, ?0)}:00 #{suffix}"
  end

  # defp to_24hr_time(time) do
  #   hours = String.split(time, ":") |> List.first |> String.to_integer
  #   if String.contains?(time, "PM"), do: hours + 12
  #   "#{String.rjust("#{hours}", 2, ?0)}:00"
  # end

  def say_time(time, format \\ "hms12") do
    "<say-as interpret-as=\"time\" format=\"#{format}\">#{time}</say-as>"
  end

end
