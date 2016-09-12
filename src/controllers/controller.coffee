{ Router } = require 'express'

# Base `Controller` class, this is a base class and as such, should not be
# called directly.
class Controller
  constructor: (@router = new Router()) ->

# The `route` method must configure all of the class' routes and return a
# `express.Router` object.
  route: -> @router

module.exports = { Controller }