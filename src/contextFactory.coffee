define 'contextFactory', ()->
  (prop)->

    @is = (fn)->
      return unless fn?
      @defined = true
      origin   = this
      console.log 'in factory'
      try
        res = fn()
      catch e
        console.log e.name
        console.log e.message
      console.log res
      # console.log collection
      # console.log collection
      # console.log _collection_

      Jasmine.instance.beforeEach ->
        console.log 'in beforeEach'
        eval("#{prop} = res;")
      # Jasmine.instance.afterEach ->

    @value = -> fn()

    @defined = false

    this
