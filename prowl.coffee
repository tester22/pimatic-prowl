# #Prowl Plugin

# This is an plugin to send push notifications via prowl

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  util = env.require 'util'
  M = env.matcher
  # Require the [node-prowl](https://github.com/arnklint/node-prowl) library
  Prowl = require 'prowler'
 

  # ###Prowl class
  class ProwlPlugin extends env.plugins.Plugin

    # ####init()
    init: (app, @framework, config) =>
      Promise.promisifyAll(Prowl)
      
      @framework.ruleManager.addActionProvider(new ProwlActionProvider @framework, config)
  
  # Create a instance of my plugin
  plugin = new ProwlPlugin()

  class ProwlActionProvider extends env.actions.ActionProvider
  
    constructor: (@framework, @config) ->

    parseAction: (input, context) =>

      # Helper to convert 'some text' to [ '"some teyt"' ]
      strToTokens = (str) => ["\"#{str}\""]

      m = M(input, context)
        .match('send ', optional: yes)
        .match(['prowl'])

      options = ["apikey", "application", "event", "message", "url", "priority"]
      optionsTokens = {}

      for opt in options
        do (opt) =>
          optionsTokens[opt] = strToTokens @config[opt]
          next = m.match(" #{opt}:").matchStringWithVars( (m, tokens) =>
            optionsTokens[opt] = tokens
          )
          if next.hadMatch() then m = next

      if m.hadMatch()
        match = m.getFullMatch()
        return {
          token: match
          nextInput: input.substring(match.length)
          actionHandler: new ProwlActionHandler(
            @framework, optionsTokens
          )
        }
      else
        return null            

  class ProwlActionHandler extends env.actions.ActionHandler 

    constructor: (@framework, @optionsTokens) ->

    executeAction: (simulate, context) ->
      prowlOptions = {}
      awaiting = []
      for name, tokens of @optionsTokens
        do (name, tokens) => 
          p = @framework.variableManager.evaluateStringExpression(tokens).then( (value) =>
            prowlOptions[name] = value
          )
          awaiting.push p
      Promise.all(awaiting).then( =>
        if simulate
          # just return a promise fulfilled with a description about what we would do.
          return __(
            "would send push message \"%s\" with event \"%s\"", 
            prowlOptions.message, prowlOptions.event)
        else
        
          prowlService = new Prowl.connection(prowlOptions.apikey);
          prowlService.send
            application: prowlOptions.application
            event: prowlOptions.event
            description: prowlOptions.message
            priority: prowlOptions.priority
            url: prowlOptions.url, (err, info) ->
             if err
              return __("Failed to send message")
           return __("Message sent")
      )     

  module.exports.ProwlActionHandler = ProwlActionHandler

  # and return it to the framework.
  return plugin   
