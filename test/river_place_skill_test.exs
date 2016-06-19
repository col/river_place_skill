defmodule RiverPlaceSkillTest do
  use Pavlov.Case, async: true
  import Alexa.Response
  alias RiverPlaceSkill.Booking
  alias Alexa.Request
  doctest RiverPlaceSkill
  require RiverPlaceMock

  @app_id "test-app-id"

  def create_request(intent_name, slot_values \\ %{}, attributes \\ %{}) do
    Request.intent_request("test-app-id", intent_name, nil, slot_values, attributes)
  end

  context "when not logged in" do
    describe "successfull login" do
      let :request, do: RiverPlaceSkillTest.create_request("Login", %{ "username" => "foo", "password" => "bar" })
      subject do: Alexa.handle_request(request)

      it "should respond with greeting" do
        assert "Hello" = say(subject)
      end
    end

    describe "unsuccessfull login" do
      let :request, do: RiverPlaceSkillTest.create_request("Login", %{ "username" => "", "password" => "" })
      subject do: Alexa.handle_request(request)

      it "should tell the user the login failed" do
        assert "Sorry, your login failed." = say(subject)
      end
    end
  end

  context "when logged in" do
    describe "successfull logout" do
      let :request, do: RiverPlaceSkillTest.create_request("Logout")
      subject do: Alexa.handle_request(request)

      it "should respond with good bye" do
        assert "Good bye" = say(subject)
      end
    end
  end

  context "with no existing booking" do
    describe "launching the skill" do
      let :request, do: RiverPlaceSkillTest.create_request("CreateBooking")
      subject do: Alexa.handle_request(request)

      it "should respond with a greating" do
        assert "Ok. When would you like to play?" = say(subject)
      end
      it "should leave the session open" do
        refute should_end_session(subject)
      end
    end

    describe "setting a date" do
      let :request, do: RiverPlaceSkillTest.create_request("CreateBooking", %{"date" => "2016-01-01"})
      subject do: Alexa.handle_request(request)

      it "should add the date to the session" do
        assert "2016-01-01" = attribute(subject, "date")
      end
      it "should ask for the time of the booking" do
        assert "What time would you like to play?" = say(subject)
      end
      it "should leave the session open" do
        refute should_end_session(subject)
      end
    end

    describe "setting a time" do
      let :request, do: RiverPlaceSkillTest.create_request("CreateBooking", %{"time" => "18:00"})
      subject do: Alexa.handle_request(request)

      it "should add the time to the session" do
        assert "06:00 PM" = attribute(subject, "time")
      end
      it "should ask for the time of the booking" do
        assert "What day would you like to play?" = say(subject)
      end
      it "should leave the session open" do
        refute should_end_session(subject)
      end
    end

    describe "setting a time and day" do
      let :request, do: RiverPlaceSkillTest.create_request("CreateBooking", %{"date" => "2016-01-01", "time" => "07:00"})
      subject do: Alexa.handle_request(request)

      it "should ask for the time of the booking" do
        assert "OK, I've booked Court 1 for you at <say-as interpret-as=\"time\" format=\"hms12\">07:00 AM</say-as>" = say_ssml(subject)
      end
      it "should leave the session open" do
        assert should_end_session(subject)
      end
    end

  end

end
