(class
  name: [(constant) (scope_resolution)] @name
  (#set! "kind" "Class")
  ) @type

(method
  name: (_) @name
  (#set! "kind" "Method")
  ) @type

(call
  (identifier) @scope_switch
  (#any-of? @scope_switch "private" "protected")

  (argument_list
    (method
      name: (_) @name
      (#set! "kind" "Method")
      (#set! "scope" "private")
      ) @type
    )
  )

(body_statement
  (identifier) @scope @later_scope
  (#any-of? @scope "private" "protected")
  .
  [
   (_)
   ((identifier) @later_scope (#not-eq? @later_scope "public"))
   ]*
  .
  (method
    name: (_) @name
    (#set! "kind" "Method")
    (#set! "scope" "private")
    ) @type
  )

(singleton_method
  object: [(constant) (self) (identifier)] @receiver
  (["." "::"] @separator)?
  name: [(operator) (identifier)] @name
  (#set! "kind" "Method")
  ) @type

(singleton_class
  value: (_) @name
  (#set! "kind" "Class")
  ) @type

(module
  name: [(constant) (scope_resolution)] @name
  (#set! "kind" "Module")
  ) @type

; For Rspec, Rake, and Shoulda
(call
  method: (identifier) @method @name
  (#any-of? @method
   "describe" "it" "before" "after" ; Rspec
   "namespace" "task" "multitask" "file" ; Rake
   "setup" "teardown" "should" "should_not" "should_eventually" "context") ; Shoulda
  arguments: (argument_list
    [(string
      (string_content) @name)
     (simple_symbol) @name
     (pair
        key: [(string (string_content) @name) (hash_key_symbol) @name])
     (call) @name
    ])?
  (#set! "kind" "Method")
) @type @selection
