%%% START
clear all

%%% STEP 1: Select the constants to use

% Example vb = 0 from the paper by Zhu and Savla (2018) --> convex
% [n_links, n_states, constants] = constants_ex_1(); 

% Example vb ~= 0 from the paper by Zhu and Savla (2018)--> non-convex
% [n_links, n_states, constants] = constants_ex_2();

% Generate random constants by choosing number of links and states
n_links = 4;
n_states = 2;
[constants] = constants_rdm(n_links, n_states);


%%% STEP 2: Generate an initial guess
phi0 = rand(n_states, n_links);


%%% STEP 3: Choose precision of solutions 
%%% (for fast solutions 20 < precision < 60)
precision = 10;


%%% STEP 5: Choose tolerances for constraints
tol_eq = 1e-5;
tol_ineq = 1e-5;


%%% STEP 4: Choose options for fmincon.m
options = optimoptions('fmincon');
options.MaxFunctionEvaluations = 3.0e+06;
options.Display = 'off';
options.Algorithm = 'sqp';
    

%%% STEP 6: Compute solutions
tic
[phi, objective, fb, const_phi, const_icc, const_bwep] ...
    = algo(phi0, precision, n_states, n_links, constants, ...
    tol_eq, tol_ineq, options);
toc
