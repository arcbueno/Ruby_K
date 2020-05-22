module RUBY-SYNTAX 
    import DOMAINS

    syntax Pgm ::= Block

    syntax Ids ::= List{Id, ","}
    
    syntax Skip ::= "Skip"

    syntax Block ::=  Stmt "end" 
                    | Stmt
    
    // Ruby é dinamicamente tipado
    syntax Assigner ::= Id "=" AExp [strict(2)]
                    | Id "=" BExp [strict(2)]
                    | Id "=" SExp [strict(2)]

    // Booleano
    syntax BExp ::= Bool
                    | AExp "==" AExp [strict]
                    | AExp "<" AExp [strict]
                    | AExp "<=" AExp [strict]
                    | AExp ">" AExp [strict]
                    | AExp ">=" AExp [strict]
                    | "(" BExp ")" [bracket]
    
    // String
    syntax SExp ::= String
                    | "(" SExp ")" [bracket]
                    | String "+" SExp [seqstrict,left]
                    | Id

    
    // Aritmético
    syntax AExp ::= Int
                    | Id
                    > left: AExp "*" AExp [seqstrict]
                    > left: AExp "/" AExp [seqstrict]
                    | AExp "-" AExp [seqstrict]
                    | AExp "+" AExp [seqstrict]
                    | "(" AExp ")" [bracket]

    syntax Stmt ::= AExp
                    | BExp
                    | Assigner
                    | Stmt Stmt [left]
                    | Skip
                    | SExp
                    | "print" AExp
                    | "print" BExp
                    | "print" SExp
  
 
    // Regras estuturais/utilização
    rule S1:Stmt S2:Stmt => S1 ~> S2 [structural]
    rule Skip => .

    // Regras para operaçoes aritméticas e booleanas
    rule I1:Int + I2:Int => I1 +Int I2
    rule I1:Int - I2:Int => I1 -Int I2
    rule I1:Int * I2:Int => I1 *Int I2
    rule I1:Int / I2:Int => I1 /Int I2 when I2 =/=Int 0
    rule I1:Int == I2:Int => I1 ==Int I2
    rule I1:Int < I2:Int => I1 <Int I2
    rule I1:Int <= I2:Int => I1 <=Int I2
    rule I1:Int > I2:Int => I1 >Int I2
    rule I1:Int >= I2:Int => I1 >=Int I2

    rule Str1:String + Str2:String => Str1 +String Str2 


    // Caso Ids esteja vazio
    rule .Ids = _:Int => Skip
    rule .Ids = _:String => Skip

    rule <k> I:Id = V:Int => Skip ... </k>
        <env> MEnv:Map => MEnv I |-> L </env>
        <store> MStore:Map => MStore L |-> V </store>
        <loc> L:Int => L +Int 1 </loc>

    rule <k> I:Id = V:Int => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>

    // rule <k> I1:Id = I2:Id => I1 = V ... </k>
    //     <env> ... I2 |-> L ... </env>
    //     <store> ... L |-> V  ... </store>

    rule <k> I:Id => V ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> V ... </store>


    // rule <k> print(P:Printable,AEs => AEs); ...</k>
    //     <out>... .List => ListItem(P) </out> [print]
    
    // context print HOLE:AExp

    // rule <k> print A:AExp => A ...</k>
    //     <out>... AExp => A </out> [print]
    
    //rule puts .AExp => . [structural]


    configuration <T>
        <k> $PGM:Pgm </k>
        <functions color="orange"> 
            <thread multiplicity="*" color="blue" type="Map"> 
                <id> .K </id>
                <scope> .K </scope>
                <params> .K </params>
                <temp> .K </temp>
                <localEnv> .Map </localEnv>
            </thread> 
        </functions>
        <env> .Map </env>
        <store> .Map </store>
        <loc> 1 </loc>
    </T>

endmodule

module RUBY
    import DOMAINS
    import RUBY-SYNTAX

    syntax KResult ::= Int | Bool
endmodule