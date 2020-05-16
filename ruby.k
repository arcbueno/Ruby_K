module HOPPER-SYNTAX 
    import DOMAINS

    syntax Skip ::= "Skip"

    syntax Block ::=  Stmt "end" 
                | Stmt
    
    
    // syntax Stmt ::= "if" BExp Block [strict(1)]
    //             | "if" BExp  Block ElseIfStmt [strict(1)]
    //             | BExp "?" Block ":" Block [strict(1)]
    //             | "while" "(" BExp ")" Block
    //             | "do" Block "while" "(" BExp ")"
    //             | "for" "(" Type UniqueIdAssigner ";" BExp ";" AExpMod ")" Block
    //             | Foreach
    //             | AExp
    //             | DecVar ";"
    //             | FuncDec
    //             | FuncCall ";"
    //             | Assigner
    //             | AExpMod
    //             | Skip
    //             | Stmt Stmt [left]

    // syntax ElseIfStmt ::= "elsif" "(" BExp ")" Block
    //                     | "else" Block
    //                     | "elsif" "(" BExp ")" Block ElseIfStmt
 
endmodule

module RUBY
    import DOMAINS
    import RUBY-SYNTAX

    syntax KResult ::= Int | Bool
endmodule