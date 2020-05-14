function [phi, objective, fb, const_phi, const_icc, const_bwep] ...
    = algo(phi0, precision, n_states, n_links, constants, tol_eq, tol_ineq, options)

% This algorithm attemps at solving the optimization problem presented in
% the paper by Zhu and Savla (2018) "On the stability of optimal bayesian
% persuasion strategy under a mistrust dynamics in routing games".
%
% Since the non-convex problem is the union of convex sets, a brute force
% method is used.
%
%
%
%                INPUTS
%       phi0       -->     Initial guess
%       precision  -->     Number of possible f_b sets
%       n_states   -->     Number of states
%       n_links    -->     Number of links
%       constants  -->     It is a 1x5 cell containing {q, vb, vp, a, b}
%       tol_eq     -->     Tolerance for equality constraints
%       tol_ineq   -->     Tolerance for inequality constraints
%       options    -->     Options for the solver fmincon.m
%
%                OUTPUTS
%       phi        -->    1x2 cell with feasible and non feasible solutions
%                         the first entry contains the feasible solutions
%                         and the second entry the non feasible solutions
%       objective  -->    1x2 cell similar to phi, feasible solutions in
%                         the first entry and non feasible in the second
%       fb         -->    Feasible pairs of fb related to each solution
%       const_phi  -->    1x2 cell containing the values of the first
%                         constraint. First entry are the feasible values
%                         and second entry are the non feasible values
%       const_icc  -->    1x2 cell containing the values of the second
%                         constraint. First entry are the feasible values
%                         and second entry are the non feasible values
%       const_bwep -->    1x2 cell containing the values of the third
%                         constraint. First entry are the feasible values
%                         and second entry are the non feasible values
%
%       This function also outputs some graphes.
%       For more info see myplots.m

% ALGORITHM
% Assign constants
[~, vb, ~, ~, ~] = constants{:};

% Define upper and lower bound for fmincon.m
lb = 0 * ones(n_states, n_links);
ub = 1 * ones(n_states, n_links);

% Create all possibilities of fb
if vb == 0
    fb = zeros(1,n_links);
else
    step_size = vb/precision;
    f = 0:step_size:vb;
    f = permn(f,n_links);
    fb = f(sum(f,2)==vb,:);
end

% Solve for each set of fb --> brute force method
n = size(fb,1);
k = 0;

phi_opt = cell(1,n);
phi_no_opt = cell(1,n);

obj_opt = NaN(1,n);
obj_no_opt = NaN(1,n);

c = cell(1,n);
ceq = cell(1,n);

% Setting up wait bar
h = waitbar(0,'Please wait ...','Name','Calculating Solutions',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

setappdata(h,'canceling',0);

for i = 1:n
    % Check for clicked Cancel button
    if getappdata(h,'canceling')
        break
    end
    waitbar(i/n, h);
    
    % Assign functions
    obj_fun = @(phi) obj(phi, fb(i,:), constants);
    nlcon_fun = @(phi) nlcon(phi, fb(i,:), n_links, n_states, constants);
    
    % Find optimal set phi
    phi_opt{i} = fmincon(obj_fun, phi0, [], [], [], [], lb, ub, ...
        nlcon_fun, options);
    phi_no_opt{i} = NaN(n_states, n_links);
    
    % Find objective optimal
    obj_opt(i) = obj(phi_opt{i}, fb(i,:), constants);
    obj_no_opt(i) = NaN;
    
    % Check if phi stays within lb and ub %DELETE LATER
    lb_ub_feasible = 0;
    phi_lb_ub = phi_opt{i};
    if any(phi_lb_ub(:) < 0) || any(phi_lb_ub(:) > 1)
        lb_ub_feasible = 1;
    end
    
    % Collect feasible and non feasible solutions with objective
    [c_opt, ceq_opt] = nlcon(phi_opt{i}, fb(i,:), n_links, n_states, ...
        constants);
    if any(c_opt > tol_ineq) || any(abs(ceq_opt) > tol_eq)
        obj_no_opt(i) = obj_opt(i);
        obj_opt(i) = NaN;
        
        phi_no_opt{i} = phi_opt{i};
        phi_opt{i} = NaN(n_states, n_links);
    else
        k = k + 1;
        phi0 = phi_opt{i};
    end
    
    % Collect the values of constraints
    c{i} = c_opt;
    ceq{i} = ceq_opt;
    
end
delete(h);

% Transform c and ceq into matrix form for plotting
% If cell has only one entry
if length(c) ==  1
    c = c{1};
    ceq = ceq{1}';
else
    c = padcat(c{:});
    ceq = padcat(ceq{:})';
end

% Save the feasible and non feasible solutions
phi = {phi_opt, phi_no_opt};

% Save the feasible and non feasible objectives
objective = {obj_opt, obj_no_opt};

% Save the feasible and non feasible constraints
c_yes = c;
c_no = c;
c_yes(c_yes > tol_ineq) = NaN;
c_no(c_no <= tol_ineq) = NaN;

ceq_yes = ceq;
ceq_no = ceq;
ceq_yes(abs(ceq_yes) > tol_eq) = NaN;
ceq_no(abs(ceq_no) <= tol_eq) = NaN;

% Constraint 1: Phi
ceq_const_1_yes = ceq_yes(:, 1:n_states);
ceq_const_1_no = ceq_no(:, 1:n_states);

const_phi = {ceq_const_1_yes, ceq_const_1_no};

% Constraint 2: I.C.C.
n_const_2 = factorial(n_links)/(factorial(n_links - 2));
c_const_2_yes = c_yes(:, 1:n_const_2);
c_const_2_no = c_no(:, 1:n_const_2);

const_icc = {c_const_2_yes, c_const_2_no};

% Constraint 3: BWE-P
ceq_const_3_yes = ceq_yes(:, n_states+1:end);
ceq_const_3_no = ceq_no(:, n_states+1:end);

c_const_3_yes = c_yes(:, n_const_2+1:end);
c_const_3_no = c_no(:, n_const_2+1:end);

const_bwep = {ceq_const_3_yes, ceq_const_3_no, c_const_3_yes, c_const_3_no};

% Plot results
myplots(phi, fb, objective, const_phi, const_icc, const_bwep, ...
    n, k, n_links, n_states);
