module RUBY-SYNTAX 
    import DOMAINS

    syntax Pgm ::= Block

    syntax Ids ::= List{Id, ","}
    
    syntax Skip ::= "Skip"

    syntax Block ::=  Stmt 
    
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
                    | Id
                    | BExp "and" BExp [seqstrict, left]
                    | BExp "or" BExp [seqstrict, left]
                    | "!" BExp [seqstrict, left]
                    //| BExp BExp [left]
    
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
                    | "if" BExp Block "end" [strict(1)]
                    | "if" BExp Block ElsIfStmt "end" [strict(1)] 
                    //| "unless" BExp Block ElsIfStmt
                    | "while" BExp Block 
                    | BExp
                    | Assigner
                    | Stmt Stmt [left]
                    | Skip
                    | SExp
                    | IfTernary
  
    syntax IfTernary ::= BExp "?" Stmt ":" Stmt

    // elsif para as estruturas de controle
    syntax ElsIfStmt ::= "elsif" BExp Block 
                        | "else" Block 
                        | "elsif" BExp Block ElsIfStmt 



    // Regras estuturais/utilização
    rule S1:Stmt S2:Stmt => S1 ~> S2 [structural]
    rule Skip => .

    // Regras Estruturas de controle
    rule if  true  S:Stmt end => S 
    rule if  false  _  end => Skip
    rule if  true  B S:ElsIfStmt end => B 
    rule if  false  _  S:ElsIfStmt end => S
    rule elsif  B:BExp  S1:Stmt  S2:ElsIfStmt => if  B   S1   S2 end
    rule elsif  B:BExp   S:Stmt => if  B   S end
    rule else  S  => S 

    // Regra de if ternário
    rule B:BExp ? S1:Stmt : S2:Stmt => if B S1 else S2 end
    //rule false ? S1:Stmt : S2:Stmt => S2

    // Regras para operaçes aritméticas e booleanas
    rule I1:Int + I2:Int => I1 +Int I2
    rule I1:Int - I2:Int => I1 -Int I2
    rule I1:Int * I2:Int => I1 *Int I2
    rule I1:Int / I2:Int => I1 /Int I2 when I2 =/=Int 0
    rule I1:Int == I2:Int => I1 ==Int I2
    rule I1:Int < I2:Int => I1 <Int I2
    rule I1:Int <= I2:Int => I1 <=Int I2
    rule I1:Int > I2:Int => I1 >Int I2
    rule I1:Int >= I2:Int => I1 >=Int I2

    // Regras de operação booleana
    rule true or false => true
    rule true or true => true
    rule false or false => false
    rule false or true => true
    rule true and false => false
    rule true and true => true
    rule false and false => false
    rule false and true => false
    rule ! true => false
    rule ! false => true
 
    //regra de ID
    rule <k> I:Id => V ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> V ... </store>


    rule Str1:String + Str2:String => Str1 +String Str2 

   
    rule <k> I:Id = V:Int => Skip ... </k>
        <env> MEnv:Map => MEnv I |-> L </env>
       <store> MStore:Map => MStore L |-> V </store>
       <loc> L:Int => L +Int 1 </loc>
   when notBool I in keys(MEnv) 

    rule <k> I:Id = V:Int => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>
    

    // rule <k> I1:Id = I2:Id => I1 = V ... </k>
    //     <env> ... I2 |-> L ... </env>
    //     <store> ... L |-> V  ... </store>

    //https://github.com/kframework/k/blob/master/k-distribution/tutorial/1_k/4_imp%2B%2B/lesson_8/imp.k  'print' para imprimir as informações



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

