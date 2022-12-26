PROGRAM Program
    VAR
        c : Counter;
    END_VAR

    c.Increase();
END_PROGRAM

FUNCTION_BLOCK Counter
    VAR
        Counter : DINT := 0;
    END_VAR

    METHOD Increase
        Counter := Counter + 1;
    END_METHOD
END_FUNCTION_BLOCK