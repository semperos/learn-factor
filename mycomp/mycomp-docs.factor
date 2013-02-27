USING: arrays help.markup help.syntax kernel math ;
IN: mycomp

HELP: eval1
{ $values
  { "a" tuple }
  { "a" object }
}
{ $description
  "Interprets elements of mycomp language, which always boil down to an integer or array when evaluated"
}
{ $examples
  { $example
    "USE: mycomp"
    "5 <lit> eval1 ."
    "5"
  }
  { $example
    "USE: mycomp"
    "5 <lit> <inc> eval1 ."
    "6"
  }
  { $example
    "USE: mycomp"
    "5 <lit> dup <inc> <pair> eval1 ."
    "{ 5 6 }"
  }
}
;

ARTICLE: "mycomp" "Simple Compiler"
"This is the main article for a toy interpreter/compiler written by Chris Double" ;

ABOUT: "mycomp"