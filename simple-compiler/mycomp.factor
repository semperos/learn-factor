! See http://www.bluishcoder.co.nz/2006/10/compilers-and-interpreters-in-factor.html
USING: accessors arrays kernel make match math sequences ;

IN: mycomp

TUPLE: lit i ;
TUPLE: inc t ;
TUPLE: isz t ;
TUPLE: iff b t e ;
TUPLE: pair a b ;
TUPLE: fst t ;
TUPLE: snd t ;

C: <lit> lit
C: <inc> inc
C: <isz> isz
C: <iff> iff
C: <pair> pair
C: <fst> fst
C: <snd> snd

: 1+ ( n -- n )
    1 + ;

MATCH-VARS: ?a ?b ?e ?i ?t ;
: eval1 ( a -- a )
    {
        ! numbers are the only literals
        { T{ lit f ?i }       [ ?i ] }
        ! inc is like a container, so defer recurisvely
        ! to this eval function to ensure it's a legal value,
        ! then increment it if it's a number
        { T{ inc f ?t }       [ ?t eval1 1 + ] }
        ! isz tests if a value is zero - proxy to Factor
        { T{ isz f ?t }       [ ?t eval1 zero? ] }
        ! iff is if, test boolean and pass it along with
        ! then and else branches as quotations to Factor's if
        { T{ iff f ?b ?t ?e } [ ?b eval1 [ ?t ] [ ?e ] if eval1 ] }
        ! Take two literals, turn it into a Factor array
        { T{ pair f ?a ?b }   [ ?a eval1 ?b eval1 2array ] }
        ! Accessor for pairs, 1st element
        { T{ fst f ?t }       [ ?t eval1 first ] }
        ! Accessor for pairs, 2nd element
        { T{ snd f ?t }       [ ?t eval1 second ] }
    } match-cond ;

GENERIC: eval2 ( a -- a )

M: lit  eval2 ( a -- a ) i>> ;
M: inc  eval2 ( a -- a ) t>> eval2 1 + ;
M: isz  eval2 ( a -- a ) t>> eval2 zero? ;
M: iff  eval2 ( a -- a ) dup b>> eval2 [ t>> ] [ e>> ] if eval2 ;
M: pair eval2 ( a -- a ) dup a>> eval2 swap b>> eval2 2array ;
M: fst  eval2 ( a -- a ) t>> eval2 first ;
M: snd  eval2 ( a -- a ) t>> eval2 second ;

: driver ( -- v )
    5 <lit> <inc> <inc> <isz>
    6 <lit>
    7 <lit> <iff>
    42 <lit>
    8 <lit> 9 <lit> <pair> <pair>
    <snd> <fst>
    <pair> ;

: (compile1) ( a -- )
    {
        { T{ lit f ?i } [ ?i , ] }
        { T{ inc f ?t } [ ?t (compile1) \ 1+ , ] }
        { T{ isz f ?t } [ ?t (compile1) \ zero? , ] }
        { T{ iff f ?b ?t ?e } [ ?b (compile1)
                                [ ?t (compile1) ] [ ] make ,
                                [ ?e (compile1) ] [ ] make ,
                                \ if , ] }
        { T{ pair f ?a ?b } [ ?a (compile1) ?b (compile1) \ 2array , ] }
        { T{ fst f ?t } [ ?t (compile1) \ first , ] }
        { T{ snd f ?t } [ ?t (compile1) \ second , ] }
    } match-cond ;

: compile1 ( a -- quot )
    [ (compile1) ] [ ] make ;