function [n_links, n_states, constants] = constants_ex_1()

% Number of links and states
n_links = 2; 
n_states = 2;

% q
q1 = 0.1481;
q2 = 0.8519;
q = [q1, q2];

% vb, vp
vb = 0;
vp = 1;

% alpha
a11 = 0.0011;
a12 = 0.0055;
a21 = 0.003;
a22 = 0.0043;
a = [a11, a12; a21, a22];

% beta
b11 = 2.5485;
b12 = 2.1929;
b21 = 1.5363;
b22 = 2.2671;
b = [b11, b12; b21, b22];

% Constant
constants = {q, vb, vp, a, b};