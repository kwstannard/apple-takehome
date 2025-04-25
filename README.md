# Weather Forecaster

Hello dear readers, and welcome!

## Project Review Guidelines

I hope your day is going well.

To understand the development process and rationale behind specific
decisions not mentioned here, please refer to the Git commit
messages, as I've used them extensively for documentation.

It is beneficial to be familiar with Sandi Metz's POODR and
99Bottles. I have found a user focused, outside-in approach to be
better in most cases.

I made a separate route for getting the current temperature because
that is a direct measure and not a forecast, so from a design
viewpoint we will run into fewer problems in the future.

## Design approach

Given that this is for a backend position, I've implemented the UI as
an API. For usage examples, please refer to the user acceptance tests
in the `spec/features` directory. If you'd like to see my frontend
development skills, you can find recent projects, "doggo" and
"test_repo," on my GitHub profile.

As requested, this project follows standard Rails conventions.
Application specific code goes into app/, lib/ is for non-application
code, etc. I put the external service wrappers under app/services
here, but I was 50/50 on using lib/services instead.

To demonstrate my approach to system integration, I've implemented a
unique method for mocking the remote weather and monitoring services.
This pattern has proven effective in previous projects. I hope you
enjoy it.

Please note that the assignment did not require accurate or
real-world forecasts, so the focus was placed on functionality rather
than data accuracy.

## Testing Approach

All tests adhere to the Arrange/Act/Assert pattern. The tests are
designed to minimize the use of mocks and stubs and avoid referencing
internal implementation details, focusing instead on response
properties and external calls.

I used a test-driven design (TDD) approach, starting with the HTTP
interface. In this context, the application can be considered the
unit under test, with underlying components treated as private. I
considered adding tests for the `app/services` classes; Given their
limited, single-location use, I've determined that they can be
treated as private internals of the application. The speed of the
tests allowed for comprehensive testing at the HTTP interface level.

## Running the Server

`bin/rails server`

## Running Tests

`bin/rspec`

## Original Assignment Text:

Coding Assignment

Requirements:
    • Must be done in Ruby on Rails
    • Accept an address as input
    • Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
    • Display the requested forecast details to the user
    • Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.

Assumptions:
    • This project is open to interpretation
    • Functionality is a priority over form
    • If you get stuck, complete as much as you can

Submission:
    • Use a public source code repository (GitHub, etc) to store your code
    • Send us the link to your completed code
