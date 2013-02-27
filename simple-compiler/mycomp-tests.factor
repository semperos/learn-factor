USING: arrays mycomp tools.test ;
IN: mycomp.tests

{ { 24 24 } } [
    42 <lit> 24 <lit> <pair> <snd> eval1
    42 <lit> 24 <lit> <pair> <snd> eval2 2array
] unit-test

{ { 7 8 } } [
    5 <lit> <inc> <inc> <isz>
    6 <lit>
    7 <lit> <iff>
    42 <lit>
    8 <lit> 9 <lit> <pair> <pair>
    <snd> <fst>
    <pair> eval1
] unit-test

{ { 7 8 } } [
    5 <lit> <inc> <inc> <isz>
    6 <lit>
    7 <lit> <iff>
    42 <lit>
    8 <lit> 9 <lit> <pair> <pair>
    <snd> <fst>
    <pair> eval2
] unit-test