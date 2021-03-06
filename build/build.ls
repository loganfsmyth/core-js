require! {'./config': {banner}, fs: {readFile, writeFile, unlink}, browserify, '../': core}
list = <[
  es5
  es6.symbol
  es6.object.assign
  es6.object.is
  es6.object.set-prototype-of
  es6.object.prototype
  es6.object.statics-accept-primitives
  es6.function
  es6.number.constructor
  es6.number.statics
  es6.math
  es6.string.from-code-point
  es6.string.raw
  es6.string.prototype
  es6.array.from
  es6.array.of
  es6.array.species
  es6.array.prototype
  core.iterator
  es6.iterators
  es6.regexp
  es6.promise
  es6.collections
  es6.reflect
  es7.array.includes
  es7.string.at
  es7.regexp.escape
  es7.object.get-own-property-descriptors
  es7.object.to-array
  es7.abstract-refs
  web.immediate
  web.dom.itarable
  web.timers
  core.dict
  core.iter-helpers
  core.$for
  core.delay
  core.binding
  core.object
  core.array.turn
  core.number
  core.string.escape-html
  core.date
  core.global
  core.log
  js.array.statics
]>

exp = <[
  core.iterator
]>

x78 = '*'repeat 78
module.exports = ({modules, blacklist, library}, next)-> let @ = modules.turn ((memo, it)-> memo[it] = on), {}
  if @exp => for exp => @[..] = on
  for ns of @
    if @[ns]
      for name in list
        if name.startsWith("#ns.") and name not in exp
          @[name] = on
  for ns in blacklist
    for name in list
      if name is ns or name.startsWith "#ns."
        @[name] = no
  if library  => @ <<< {-\es6.object.prototype, -\es6.function, -\es6.regexp, -\es6.number.constructor, -\core.iterator}
  PATH = ".#{ if library => '/library' else '' }/src/__tmp__"
  err <-! writeFile "#PATH.js", list.filter(~> @[it]).map(-> "require('./#it');" ).join '\n'
  if err => console.error err
  err, script <-! browserify([PATH]).bundle
  if err => console.error err
  err <-! unlink "#PATH.js"
  if err => console.error err
  next """
    #banner
    !function(undefined){
    var __e = null, __g = null;
    
    #script
    // CommonJS export
    if(typeof module != 'undefined' && module.exports)module.exports = __e;
    // RequireJS export
    else if(typeof define == 'function' && define.amd)define(function(){return __e});
    // Export to global object
    else __g.core = __e;
    }();
    """