function [constants] = constants_rdm(n_links, n_states)

% q
q = rand(1, n_states);
q = q / sum(q);

% vb, vp
vb = rand(1);
vp = 1 - vb;

% alpha
a = rand(n_states,n_links);

% beta
b = rand(n_states,n_links);

% Constant
constants = {q, vb, vp, a, b};