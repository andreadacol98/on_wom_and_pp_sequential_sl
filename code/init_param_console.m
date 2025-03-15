function param_console = init_param_console()
    % param = from_console() sets parameters from console
    %
    % param: struct with following fields
    % .m: number of filters
    % .k: number of time steps of simulation
    
    %% PROGRAM STARTS
    fprintf("[PROGRAM STARTS] SLOW CONVERGENCE OF SOCIAL LEARNING\n\n");
    fprintf("INSERT THE FOLLOWING PARAMETERS FROM KEYBOARD:\n");

    prompt_m = "    Number of filters: ";
    prompt_k = "    Number of time-steps: ";
    
    %% SET PARAMETERS
    param_console = struct;

    param_console.to_debug = false;
    param_console.m = input(prompt_m);
    param_console.k = input(prompt_k);

end