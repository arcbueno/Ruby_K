module RUBY-SYNTAX 
    import DOMAINS

    syntax Pgm ::= Block

    syntax Ids ::= List{Id, ","}
    syntax AExps ::= List{Printable, ","}

    syntax Printable ::= AExp  
    
    syntax Skip ::= "Skip"

    syntax Block ::= Stmt
                    | Stmt Stmt [left]  
                    
    syntax Assigner ::= Id "=" AExp [strict(2)]
                    | Id "=" BExp [strict(2)]
                    | Id "=" SExp
                    | Id "=" ArrayList

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
    
    // String
    syntax SExp ::= String
                    | SExp "+" SExp [seqstrict, left]
                    | Id
    
    // Aritmético
    syntax AExp ::= Int
                    | Id
                    > left: AExp "*" AExp [seqstrict]
                    > left: AExp "/" AExp [seqstrict]
                    | AExp "-" AExp [seqstrict]
                    | AExp "+" AExp [seqstrict]
                    | "(" AExp ")" [bracket]
                    | AExpIncrement
    
    // Incrementação
    syntax AExpIncrement ::= Id "++"   

    //Types
    syntax Types ::= Id
                    | AExp
                    | BExp
                    | SExp
                    
    //List
    syntax TypeList ::= List{Types, ","}
    syntax ArrayList ::= Id
                        |"[" TypeList "]"
                                      

    syntax Stmt ::= AExp
                    | "if" BExp Block "end" [strict(1)]
                    | "if" BExp Block ElsIfStmt "end" [strict(1)] 
                    | "while" BExp "do" Block "end" 
                    | "for" Id "in" ArrayList Block "end" 
                    | BExp
                    | Assigner
                    | Skip
                    | SExp
                    | IfTernary                  
                    | PrintExp
    
    syntax PrintExp ::= "print" AExps [left]
                        | "puts" AExps [left]
                    
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

    //regras de estrutura de repetição
    rule while B:BExp do S:Stmt end => if  B  S  while B do S end  end [structural]
  
    rule <k>
            for I:Id in [ (V:Types, Vs:TypeList) ] B:Block end
            => B ~> for I in [ Vs:TypeList ] B end
            ... 
        </k>
        <env> MEnv:Map => MEnv I |-> L </env>
        <store> MStore:Map => MStore L |-> V </store>
        <loc> L:Int => L +Int 1 </loc>
        when notBool (I in keys(MEnv))

    rule <k>
            for I:Id in [ (V:Types, Vs:TypeList) ] B:Block end
            => B ~> for I in  [Vs:TypeList]  B end
            ... 
        </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>

    rule for I:Id in  [.TypeList]   B:Block end => Skip

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
   
    rule <k> I:Id = V:AExp => Skip ... </k>
        <env> MEnv:Map => MEnv I |-> L </env>
       <store> MStore:Map => MStore L |-> V </store>
       <loc> L:Int => L +Int 1 </loc>
   when notBool I in keys(MEnv) 

    rule <k> I:Id = V:AExp => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>

    rule <k> I:Id = V:BExp => Skip ... </k>
        <env> MEnv:Map => MEnv I |-> L </env>
       <store> MStore:Map => MStore L |-> V </store>
       <loc> L:Int => L +Int 1 </loc>
   when notBool I in keys(MEnv) 

    rule <k> I:Id = V:BExp => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>

    rule <k> I:Id = V:SExp => Skip ... </k>
        <env> MEnv:Map => MEnv I |-> L </env>
       <store> MStore:Map => MStore L |-> V </store>
       <loc> L:Int => L +Int 1 </loc>
   when notBool I in keys(MEnv) 

    rule <k> I:Id = V:SExp => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>

    rule <k> I:Id = V:ArrayList => Skip ... </k>
        <env> MEnv:Map => MEnv I |-> L </env>
       <store> MStore:Map => MStore L |-> V </store>
       <loc> L:Int => L +Int 1 </loc>
   when notBool I in keys(MEnv) 

    rule <k> I:Id = V:ArrayList => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (_ => V) ... </store>

    // Incrementação             
    rule <k> I:Id ++ => Skip ... </k>
        <env> ... I |-> L ... </env>
        <store> ... L |-> (V => V +Int 1) ... </store>
    context print HOLE:Printable, AEs:AExps
    
    rule <k> print P:Printable,AEs => print AEs ...</k>
       <output>... .List => ListItem(P) </output>  [print]
    
    rule print .AExps => .  [structural]
    
    rule <k> puts P:Printable,AEs:AExps => puts AEs ...</k>
       <output>... .List => ListItem(P) </output>  [print]
    
    rule puts .AExps => .  [structural]

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
        <output color="Orchid" stream="stdout"> .List </output>
    </T>

endmodule

module RUBY
    import DOMAINS
    import RUBY-SYNTAX

    syntax KResult ::= Int | Bool
endmodule

