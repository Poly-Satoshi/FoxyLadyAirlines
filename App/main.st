IMPORT "lib.st"
IMPORT "ladder.graph"

CONFIGURATION Config1
    VAR_GLOBAL
        test : BOOL := TRUE;
    END_VAR
    TASK tick1(INTERVAL := TIME#1ms, PRIORITY := 16);
    PROGRAM prog1 WITH tick1 : Program;
END_CONFIGURATION