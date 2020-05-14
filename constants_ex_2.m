function [n_links, n_states, constants] = constants_ex_2()

% Number of links and states
n_links = 2; 
n_states = 2;

% q
q1 = 0.1;
q2 = 0.9;
q = [q1, q2];

% vb, vp
vb = 0.4;
vp = 0.6;

% alpha
a11 = 2;
a12 = 1;
a21 = 1;
a22 = 1;
a = [a11, a12; a21, a22];

% beta
b11 = 1;
b12 = 1;
b21 = 1;
b22 = 1;
b = [b11, b12; b21, b22];

% Constant
constants = {q, vb, vp, a, b};