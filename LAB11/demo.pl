% -------------------------------------- GENERATING SOLUTIONS -------------------------------------

/* 
    ?X -> X poate fi intrare sau iesire
    +List -> lista este intrare
    is_member(?X,+List)
*/
is_member(X,[X|_]).
is_member(X,[_|T]) :- is_member(X,T).

list_remove(X, [X | T], T).
list_remove(X, [X1 | T1], [X1 | T2]) :- list_remove(X, T1, T2).

list_insert(X,L,R) :- list_remove(X,R,L).

perm([], []).
perm([X | T], P) :- perm(T, P1), list_insert(X, P1, P).

perm2([], []).
perm2(L, [X | P]) :- list_remove(X, L, L1), perm2(L1, P).

% -------------------------------------- CUT EXAMPLE 1 ------------------------------------------

boy(tom).
boy(bob).
girl(alice).
girl(lili).

pay(X,Y) :- boy(X), girl(Y).
pay(john, cindy).

% pay(X,Y) :- !, boy(X), girl(Y).
% pay(X,Y) :- boy(X), !, girl(Y).
% pay(X,Y) :- boy(X), girl(Y), !.

% -------------------------------------- CUT EXAMPLE 2 ------------------------------------------

teaches(dr_fred, history).
teaches(dr_fred, english).
teaches(dr_fred, drama).
teaches(dr_fiona, physics).

studies(alice, english).
studies(angus, english).
studies(amelia, drama).
studies(alex, physics).

% studies_at_dr_fred(Course, Student) :- teaches(dr_fred, Course), studies(Student, Course).
% studies_at_dr_fred(Course, Student) :- !, teaches(dr_fred, Course), studies(Student, Course).
% studies_at_dr_fred(Course, Student) :- teaches(dr_fred, Course), !, studies(Student, Course).
% studies_at_dr_fred(Course, Student) :- teaches(dr_fred, Course), studies(Student, Course), !.

% -------------------------------------- CUT EXAMPLE 3 ------------------------------------------

min1(X, Y, X) :- X =< Y.
min1(X, Y, Y) :- X > Y.

min2(X, Y, X) :- X =< Y.
min2(_X, Y, Y).

% Here we use cut to say: "If the first rule succeeds, don't try the second rule. Otherwise, use the second rule."
min3(X, Y, X) :- X =< Y, !.
min3(_X, Y, Y).


% -------------------------------------- GREEN CUTS ---------------------------------------------

f(X, first_interval) :- X < 3.
f(X, second_interval) :- 3 =< X, X < 6.
f(X, third_interval) :- 6 =< X.

% trace f(1,Interval).

f1(X, first_interval) :- X < 3, !.
f1(X, second_interval) :- 3 =< X, X < 6, !.
f1(X, third_interval) :- 6 =< X.

% trace f1(1,Interval).

/*
    The answer is still the same, we just avoided some useless backtraking
    This is ok to use when you know that the clauses are mutually exclusive (if one succeeds, the others won't)
    i.e. if X is in the first_interval, it can't be in the second one too
*/

% -------------------------------------- RED CUTS ---------------------------------------------

g(X, first_interval)  :- X < 3.
g(X, second_interval) :- X < 6.
g(_X, third_interval).

% g(1, Interval).

g1(X, first_interval)  :- X < 3, !.
g1(X, second_interval) :- X < 6, !.
g1(_X, third_interval).

% g1(1, Interval)

/*
    The answer is not the same => the logic of the predicate changes after adding the cut
    Here, the clauses are not mutually exclusive
*/

% -------------------------------------- NEGATION as FAILURE + FAIL ----------------------------------------------

/*
    We can accomplish some kind of a negation by using the `cut` predicate, together with the `fail` predicate
    In Prolog, the negation  is the so-called 'negation-as-failure', because of the way it is implemented
    The built-in predicate `fail/0` always fails.
*/

nott(P) :- P, !, fail.
nott(_).


/*
    The use of `cut` and `fail` (cut-fail technique) in a clause forces the failure of the whole predicate. 
    It is useful to make a predicate fail when a condition succeeds.
*/

animal(dog).
animal(cat).
animal(elephant).
animal(tiger).
animal(cobra).
animal(python).

snake(cobra).
snake(python).

% Mary likes all animals, but snakes

likes(mary, X) :- snake(X), !, fail.
likes(mary, X) :- animal(X).

diff(X, X) :- !, fail.
diff(_,_).

% Mary likes anything if it is not a snake
liked(mary,X) :- \+ snake(X).


% -------------------------------------- NEGATION by FAILURE problems --------------------------------------------

/*
    `not` predicate doesn't correspond to logical negation!!!
    It is based on success/failure of goals, not the values of truth
*/

even(2).
even(4).
odd(N) :- \+ even(N).

/*
    We can better say that `\+ P` means `P is unprovable`, rather than the oposite value of truth of P (as in logic).
    \+P:
        - succeeds if P fails (we can find no proof for P)
        - fails if we can find any single proof for P

    Negation succeeds if the predicate NEVER holds.
*/

rain(romania).
rain(austria).
rain(germany).

% How can you prove something doesn't generally hold? => we find a counter-example

% This predicate figures out if it rains somewhere(fail) / nowhere(succeed).
% NOT where it doesn't rain.
no_rain(X) :- \+ rain(X).


action(movie1).
action(movie2).
at_cinema(movie1).
at_home(R) :- \+ at_cinema(R).

% action(M), at_home(M). -> M is always instantiated when at_home(M) is executed
% at_home(M), action(M). -> M is not instantiated when at_home(M) is executed


% -------------------------------------------- ESCAPING NEGATION -------------------------------------------------

student(bill).
student(joe).
married(joe).

single_student(X) :- \+ married(X), student(X).

% single_student(joe).
% single_student(bill).
% single_student(X).

/*
    The reason for this is that the call to \+ married(X) is not returning the students which are not married: 
    it is just failing because there is at least a married student.
    So, the 'X' from \+ married(X) is not bound to anything. 
    
    => variables from negations are NOT BOUND! We cannot further use them in the clause!!
*/

% How can we re-write the `single_student` rule to make it work as expected?
% TODO

% The solution is to firstly bind the variable from the negation to something


% ------------------------------------------------- FINDALL ------------------------------------------------------

/*
    findall(+Template, +Goal, -List)

    Collects a list `List` of all the items of the form `Template` that satisfy some goal `Goal`
*/

believes(john, likes(mary, pizza)).
believes(frank, likes(mary, fish)).
believes(john, likes(mary, apples)).

% findall(X, member(X, [1,2,3]), L).
% findall(X/X, member(X, [1,2,3]), L).
% findall(likes(mary, X), believes(_, likes(mary, X)), Bag).
% findall(X, member(X, [1,2,3]), L), length(L, N).


% ------------------------------------------------- FORALL ------------------------------------------------------

/*
    forall(Condition, Action):
        - succeeds if for all alternative bindings of Condition, Action can be proven
        - fails if there is at least one alternative binding of Condition, for which Action can't be proven
*/

% L1 = [1,2,3], L2 = [1,2], forall(member(X,L1), member(X, L2)).

% double negation -> \+ \+ Goal <=> Goal can be proven

edible(apple).
no_fruit_is_edible(X) :- \+ edible(X).
there_is_at_least_one_edible_fruit(X) :- \+ \+ edible(X).

% there_is_at_least_one_edible_fruit(X). 
% -> true = there is at least one edible fruit but Prolog won't tell you which <=> p(X) can be proven

/*
    If we want to ask if two predicates hold simultaneously
*/
q(1).
q(2).
% there is no X for which q(X) holds and member(X, [1,2,3]) holds.
p(X) :- \+ (q(X), member(X, [1,2,3])).

% there is no X for which q(X) holds and member(X, [1,2,3]) doesn't hold.
% for all X for which q(X) holds, member(X, [1,2,3]) holds.
p1(X) :- \+ (q(X), \+ member(X,[1,2,3])).

% There is no instantiation of Cond for which Action can't be proven
foralll(Cond, Action) :- \+ (Cond, \+ Action).


template([1/1/_, 1/2/_, 1/3/_, 2/1/_, 2/2/_, 2/3/_, 3/1/_, 3/2/_, 3/3/_]).

