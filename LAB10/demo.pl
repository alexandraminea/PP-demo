% Disclaimer: explicatiile de la acest demo sunt in romgleza, sorry for that (l-am scris in 2 zile diferite)


% ------------------------------------  FACTS ----------------------------------------

fruit(apple).
fruit(pear).
fruit(orange).

% Mary likes Susie
likes(mary, susie).
% Susie likes Mary
likes(susie, mary).
% Everybody likes chocolate
likes(_, chocolate).
% Mary likes pizza
likes(mary, pizza).
% John likes everybody and everybody likes John
likes(john, _).
likes(_, john).
% John doesnt like pizza
not(likes(john,pizza)).

% John has an adventure book
has(john, book(adventure)).

%  ------------------------------------  RULES ----------------------------------------

% John likes Mary if Mary likes pizza
loves(john, mary) :- not(likes(mary, pizza)).

% X and Y are frients if X likes Y and Y likes X
friends(X,Y) :- likes(X,Y), likes(Y,X).

% X hates Y if X doesn't like Y
hates(X,Y) :- not(likes(X,Y)).

% X and Y are enemies if X doesn't like Y and Y doesn't like X
enemies(X,Y) :- not(likes(X,Y)),not(likes(Y,X)).


% --------------------------------- familiy example ------------------------------------
% Joe is the father of Paul and Mary
father_of(joe,paul).
father_of(joe,mary).
father_of(john,joe).

% Jane is the mother of Paul, Mary and Hope
mother_of(jane,paul).
mother_of(jane,mary).
mother_of(jane,hope).
mother_of(lucy,joe).
mother_of(susie,jane).

% Paul, Joe and Ralph are males
male(paul).
male(joe).
male(ralph).

% Mary and Jane are females
female(mary).
female(jane).

% if X is the father of someone, than X is male
% male(X) :- father_of(X,Y).


% Conjunction logic -> AND (,)

% X is the son of Y, if (Y is the father of X) AND (X is male)
son_of(X,Y) :- father_of(Y,X), male(X).
% X is the son of Y, if (Y is the mother of X) AND (X is male)
son_of(X,Y) :- mother_of(Y,X), male(X).


% Disjunction logic -> OR (;)

% X is the parent of Y if (Y is the father of X) OR (Y the mother of X)
parent_of(X,Y) :- father_of(X, Y); mother_of(X,Y). 
% X is the son of Y, if Y is the parent of X AND (X is female)
daughter_of(X,Y) :- parent_of(X,Y), female(X).

% X is the sibling of Y if X and Y have the same father and X is different from Y
sibling_of(X,Y) :- !,father_of(Z,X),father_of(Z,Y),X\=Y.
% X is the sibling of Y if X and Y have the same mother and X is different from Y
sibling_of(X,Y) :- !,mother_of(Z,X),mother_of(Z,Y),X\=Y.

% X is the grandparent of Y if x is the parent of Z and Z is the parent of Y
grandparent(X,Y) :- parent_of(X,Z), parent_of(Z,Y).

% 23 ?- grandparent(X,Y).
% X = john,
% Y = paul ;
% X = john,
% Y = mary ;
% X = lucy,
% Y = paul ;
% X = lucy,
% Y = mary ;
% X = susie,
% Y = paul ;
% X = susie,
% Y = mary ;
% X = susie,
% Y = hope.

% # left_of(X,Y) :- right_of(Y,X)                     /* Missing a period */
% # likes(X,Y),likes(Y,X) :- friends(X,Y).            /* LHS is not a single literal */
% # not(likes(X,Y)) :- hates(X,Y).                    /* LHS cannot be negated */

% --------------------------------------- LOOPS ----------------------------------------
count_up(L, H) :-
    between(L, H, Y),
    write(Y), nl.
    
count_to_10(X) :-
    X =< 10,
    write(X), nl,
    Y is X + 1,
    count_to_10(Y).

% ?- between(1, 4, Y).
% Y = 1 ;
% Y = 2 ;
% Y = 3 ;
% Y = 4.


% --------------------------------------- DECISION MAKING ----------------------------------------

% If-Then-Else statement

gt(X,Y) :- X >= Y,write('X is greater or equal').
gt(X,Y) :- X < Y,write('X is smaller').

% If-Elif-Else statement

gte(X,Y) :- X > Y,write('X is greater').
gte(X,Y) :- X =:= Y,write('X and Y are same').
gte(X,Y) :- X < Y,write('X is smaller').

% ---------------------------------------------- LISTS -------------------------------------------

% daca X este primul element din lista, atunci X este membru al listei
is_member(X,[X|_]).
% daca X este membru din Tail-ul listei, atunci X este membru al listei
is_member(X,[_|Tail]) :- is_member(X,Tail).

% ?- is_member([b,c],[a,[b,c]]).

% lungimea listei vide este 0
length_of([], 0).
% lungimea listei nevide este N daca lungimea lui Tail este N1 si N = N1 + 1
length_of([_|Tail], N) :- 
    length_of(Tail, N1), 
    N is N1 + 1.

% [trace] 26 ?- length_of([1, 2, 3], X).
%    Call: (10) length_of([1, 2, 3], _1568) ? creep
%    Call: (11) length_of([2, 3], _2798) ? creep
%    Call: (12) length_of([3], _3554) ? creep
%    Call: (13) length_of([], _4310) ? creep
%    Exit: (13) length_of([], 0) ? creep
%    Call: (13) _3554 is 0+1 ? creep
%    Exit: (13) 1 is 0+1 ? creep
%    Exit: (12) length_of([3], 1) ? creep
%    Call: (12) _2798 is 1+1 ? creep
%    Exit: (12) 2 is 1+1 ? creep
%    Exit: (11) length_of([2, 3], 2) ? creep
%    Call: (11) _1568 is 2+1 ? creep
%    Exit: (11) 3 is 2+1 ? creep
%    Exit: (10) length_of([1, 2, 3], 3) ? creep
% X = 3.

% If we put the last statement at the beggining we get the error:
% ERROR: Arguments are not sufficiently instantiated
% this means, at the time of the call, Prolog doesn't know who is N1
wrong_length_of([], 0).
wrong_length_of([_|Tail], N) :- 
    N is N1 + 1,
    wrong_length_of(Tail, N1).

% list_concat(L1, L2, L3) - concatenarea listelor L1 si L2 este L3
% Rezultatul concatenarii unei liste vide cu o lista L este L
list_concat([],L,L).
% Concatenam recursiv tail-ul lui L1 la L2 si salvam rezultatul in L3 (ca in Haskell)
list_concat([X1|T1],L2,[X1|T3]) :- list_concat(T1,L2,T3).

/* 
    Putem vedea o similaritate intre aceasta implementare si cea din Haskell pentru append:
        append []     ys = ys
        append (x:xs) ys = x : (append xs ys)

        append [] L = L
        append (X1:T1) L2 = X1 : (append T1 L2)

        Rezultatul este de forma [X1|T3], unde T3 se obtine din apelul recursiv pe T1 si L2

*/

/*
[trace] 9 ?- list_concat([1, 2], [3, 4], L3).
    Call: (10) list_concat([1, 2], [3, 4], _248) ? creep
    Call: (11) list_concat([2], [3, 4], _1508) ? creep
    Call: (12) list_concat([], [3, 4], _2272) ? creep
    Exit: (12) list_concat([], [3, 4], [3, 4]) ? creep
    Exit: (11) list_concat([2], [3, 4], [2, 3, 4]) ? creep
    Exit: (10) list_concat([1, 2], [3, 4], [1, 2, 3, 4]) ? creep
L3 = [1, 2, 3, 4].

*/

/*
    Daca am in lista numai elementul X, atunci rezultatul este lista vida
    Daca X este primul element din lista, atunci rezultatul este tail
    Daca X nu este primul element din lista, continui recursivitatea 
*/
remove(X, [X], []).
remove(X,[X|T1], T1).
remove(X, [X1|T1], [X1|T2]) :- remove(X,T1,T2).

list_reverse([],[]).
list_reverse([X1|T1], R) :- 
    list_reverse(T1, Res),
    list_concat(Res, [X1], R).


% ------------------------------ FACTORIAL --------------------------------------
factorial(0, 1).
factorial(N, NFact) :-
    N > 0,
    Nminus1 is N - 1,
    factorial(Nminus1, Nminus1Fact),
    NFact is Nminus1Fact * N.

