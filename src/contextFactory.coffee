# Temporarily not in use
#
# define 'contextFactory', ['store', 'jasmine', 'privateStore'], (_Store_, _Jasmine_, _Context_)->
#   (prop, Store = _Store_, Jasmine = _Jasmine_, Context = _Context_)->
#     return {} unless Jasmine.defined()

#     @is = (fn)->
#       return unless fn?
#       @defined    = true
#       Store[prop] = fn

#       Jasmine.instance.beforeEach.call Context.get(), ->
#         this[prop] = fn.call this
#         eval("#{prop} = this.#{prop};")

#       Jasmine.instance.afterEach.call Context.get(), ->
#         delete Store[prop]
#         eval "delete #{prop};"

#     @value = -> Store[prop]

#     @defined = false

#     this
