# Weather forecaster

Hello dear readers, and welcome.

## Please note the following guidelines for reviewing this project

I use in git commit messages over comments 95% of the time. If you have a question about something, please read the commit message.

Given that this is a backend position I am using an API as the UI. If you are wondering how to use it, I utilize the spec/features directory for user acceptance tests.

I am going to keep this close to bog standard Rails as possible. If you want to see cool things, go check out my github profile.

I am going to do one thing you have never seen before to mock out a remote weather service.

I do test driven design starting with the http interface. It is okay to say that the app is the unit and everything under that is private. If I believe that the test suite will benefit from tests for lower level interfaces I will do that.

I hope whoever is reading this is a Sandi Metz fan.

Again, I cannot stress this enough check the git commits if you have questions.

## How to setup

`bin/setup`

## How to run the server

`bin/rails server`

## How to run the tests

`bin/rspec`
