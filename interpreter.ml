
type pattern = { constructor: string; tags : string list }
type 'a clause = { pattern : pattern; body : 'a }

type 'a lambda ={ var: string ; body: 'a }
type 'a app ={ t1 :'a ; t2 : 'a }
type 'a gadt_app = { k : string; terms: 'a list }
type 'a case = { pattern : pattern ; clause: 'a clause }

type term =
   Var of string
   | Lambda of term lambda
   | App of term app
   | Let of term lambda
   | Fix of term lambda
   | GADTApp of term gadt_app
   | Case of term case

let rec is_value = function
   | Lambda _ -> true
   | GADTApp { terms } -> List.for_all (is_value) terms
   | otherwise -> false

let rec subst x v = function
   | Lambda {var; body} -> Lambda { var = var ; body = (subst x v body) }
   | Let {var; body} -> Let { var = var ; body = (subst x v body) }
   | Fix {var; body} -> Fix { var = var ; body = (subst x v body) }
   | otherwise -> otherwise


let rec eval = function
   | Lambda { var; body } as l -> l
   | App { t1; t2} when not (is_value(t1)) ->
        let v1 = eval(t1) in
        eval (App { t1=v1; t2} )
   | App { t1; t2} when not (is_value(t2)) ->
        let v2 = eval(t2) in
        eval (App { t1; t2=v2})
   | App { t1= Lambda{ var; body }; t2} when is_value(t2) -> subst var t2 body
   | otherwise -> otherwise

(*
(E-Context) E [t] -> E ['t] if t -> 't
(E-Beta) (lambda x.t)v -> [x -> v]t
(E-Let) let x = v in t -> [x -> v]t
(E-Fix) mx.t -> [x -> mx.t]t
(E-Match) match K (v1, . . . , vn) with K (x1, . . . , xn) -> t | c -> [x1 ->
  v1]... [xn -> vn]t
(E-NoMatch) match K (v1, . . . , vm) with K (x1, . . . , xn) -> t | c -> match K (v1, . . . , vm) with c if K = 'K

Left hand side of application | E t
Right hand side of application | v E
Left hand side of a let | let x = E in t
Right hand side of a let | let x = v in E
Scrutinee evaluation | match E with c
*)
