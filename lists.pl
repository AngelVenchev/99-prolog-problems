% P01 (*) Find the last element of a list.
my_last(Last, [Last]).
my_last(Last, [_|Tail]):- my_last(Last, Tail).

% P02 (*) Find the last but one element of a list.
my_last_but_one(BeforeLast, [BeforeLast, _]).
my_last_but_one(BeforeLast, [_|Tail]):- my_last_but_one(BeforeLast, Tail).

% P03 (*) Find the K'th element of a list.
element_at(Element, [Element|_], 1).
element_at(Element, [_|Tail], Position):- 
	element_at(Element, Tail, LowerPosition), 
	Position is LowerPosition + 1.

% P04 (*) Find the number of elements of a list.
count([], 0).
count([_|Tail],Count):- 
	count(Tail,SubCount), 
	Count is SubCount + 1.

% P05 (*) Reverse a list.
my_reverse([], []).
my_reverse([Head|Tail], Result):- 
	my_reverse(Tail, ReversedTail), 
	my_append(ReversedTail, [Head], Result).

% P06 (*) Find out whether a list is a palindrome.
my_palindrome(List):- my_reverse(List, List).

% P07 (**) Flatten a nested list structure.
my_flatten([], []).
my_flatten(Head, [Head]):- not(is_list(Head)).
my_flatten([Head|Tail], Result):- 
	my_flatten(Head, FlatHead), 
	my_flatten(Tail, FlatTail), 
	my_append(FlatHead, FlatTail, Result).

% P08 (**) Eliminate consecutive duplicates of list elements.
compress([], []).
compress([Head|Tail], Result):- compress([Head|Tail], Head, Result).

compress([], Current, [Current]).
compress([Head|Tail], Head, Result):- compress(Tail, Head, Result).
compress([Head|Tail], Current, Result):- 
	Head \= Current, 
	compress(Tail, Head, SubResult), 
	my_append([Current], SubResult, Result).

% P09 (**) Pack consecutive duplicates of list elements into sublists.
my_pack([], []).
my_pack([Head|Tail], Result):- my_pack(Tail, [Head], Result).

my_pack([], List, [List]).
my_pack([Head|Tail], [Head|PackedTail], Result):- my_pack(Tail, [Head, Head|PackedTail], Result).
my_pack([Head|Tail], [PackedHead|PackedTail], Result):- 
	Head \= PackedHead, 
	my_pack(Tail, [Head], SubResult), 
	my_append([[PackedHead|PackedTail]],SubResult,Result).

% P10 (*) Run-length encoding of a list.
encode(List,Result):- 
	my_pack(List,PackedList), 
	encode_help(PackedList,Result).

encode_help([],[]).
encode_help([[Head|Duplicates]|Tail], Result):- 
	count([Head|Duplicates],Count), 
	encode_help(Tail,SubResult), 
	my_append([[Count,Head]],SubResult,Result).

% P11 (*) Modified run-length encoding.
encode_modified(List,Result):- 
	encode(List,EncodedList), 
	encode_modified_help(EncodedList,Result).

encode_modified_help([],[]).
encode_modified_help([[Count,Element]|Tail],Result):- 
	Count =:= 1, 
	encode_modified_help(Tail,SubResult), 
	my_append([[Element]],SubResult,Result).
encode_modified_help([[Count,Element]|Tail],Result):- 
	Count \= 1, 
	encode_modified_help(Tail,SubResult), 
	my_append([[Count,Element]],SubResult,Result).

% P12 (**) Decode a run-length encoded list.
decode([],[]).
decode([[Count,Element]|Tail],Result):- 
	decode(Tail,SubResult),
	inject(Element,Count,SubList),
	my_append(SubList,SubResult,Result).


% P13 (**) Run-length encoding of a list (direct solution).
encode_direct(List,Result):- my_pack(List,PackedList), encode_direct_help(PackedList,Result).

encode_direct_help([],[]).
encode_direct_help([[Head|Duplicates]|Tail], Result):- 
	count([Head|Duplicates],Count), 
	Count =:= 1, 
	encode_direct_help(Tail,SubResult), 
	my_append([[Head]],SubResult,Result).
encode_direct_help([[Head|Duplicates]|Tail], Result):- 
	count([Head|Duplicates],Count), 
	Count \= 1, 
	encode_direct_help(Tail,SubResult), 
	my_append([[Count,Head]],SubResult,Result).

% Helpers

my_append([], B, B).
my_append([H|T], B, [H|C]):- my_append(T, B, C).

is_list([]).
is_list([_|_]).

inject(Element,1,[Element]).
inject(Element,Times,Result):- 
	Times > 1,
	OneLess is Times - 1,
	inject(Element, OneLess, SubResult),
 	my_append([Element],SubResult,Result).