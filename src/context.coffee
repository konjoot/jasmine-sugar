define 'context', ->
  ->
    private_context = {}

    @defineProperty = (prop)->
      private_context[prop] = (prop)->
        letBe: -> console.log "#{prop} defined"

      true

    @properties = private_context

    this

