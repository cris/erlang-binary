Ideas:
------
* Map all lists module to binary and provide several API-s with ability
  to select how to iterate in different ways. For example, we can iterate over
  binaries as byte, integer or utf8/utf16. 
* Maybe this will require some meta-generation, because current Erlang
  implementation has no ability to dynamicly construct term for binary
  expressions.
* Provide function, which allow to create binary from some magic-function with
  presetted length. It's suitable for uuid-generation and maybe in other
  cases. I don't know similar functionality in lists-module.
* Provide edoc documentation for each module function.
* Create eunit test suite.
