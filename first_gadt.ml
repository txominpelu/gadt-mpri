open Printf

type zero
type 'a suc = S

type _ glist =
  | Nil : zero glist
  | Cons : int * 'b glist -> 'b suc glist

let hd : 'a glist -> int = function
  | Cons (x, _) -> x

let tail : 'a suc glist -> 'a glist = function
  | Cons (x, l) -> l

let rec string_of_list : type a. a glist -> string = function
  | Nil -> "Nil"
  | Cons (x, l2) -> Printf.sprintf "Cons(%s, %s)" (string_of_int x) (string_of_list l2)

let list = tail (Cons(2, Cons (1, Nil)))
let result = hd (Cons (1, Nil))
