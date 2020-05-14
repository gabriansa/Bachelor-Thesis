function [c, ceq] = nlcon(phi, fb, n_links, n_states, constants)

% Assign constants
[q, vb, vp, a, b] = constants{:};

%   fp
fp = vp * phi;

%   fs
fs = 1*(fb + fp); %202.6

%   Constraint 1 --> Phi = 1
ceq = 1 - sum(phi,2);

%   Constraint 2 --> I.C.C.
index_c = 0;

for j=1:n_links
    A1 = q * ( a(:,j) .* phi(:,j) .* fs(:,j) );
    A2 = q * ( b(:,j) .* phi(:,j));
    for k=1:n_links
        if k ~= j
            index_c = 1 + index_c;
            B1 = q * ( a(:,k) .* phi(:,j) .* fs(:,k) );
            B2 = q * ( b(:,k) .* phi(:,j));
            
            c(index_c) = (A1 + A2) - (B1 + B2);
        end
    end
end

%   Constraint 3 --> BWE-P
if vb ~=0
    index_ceq = n_states;
    if any(fb==0) %There is some zero fb flow
        %Find index of where fb is zero and non zero
        idx_zero = find(fb==0);
        idx_no_zero = find(fb~=0);
        
        %Calculate how many zeros and non zeros there are in fb
        n_zero = length(idx_zero);
        n_no_zero = length(idx_no_zero);
        if n_no_zero > 1 %If there are at least 2 non zero 
            for i = 1:n_no_zero
                j = idx_no_zero(i);
                
                A1 = q * ( a(:,j) .* fs(:,j) );
                A2 = q * ( b(:,j) );
                for w = 1:n_no_zero
                    k = idx_no_zero(i);
                    if k ~= j && k < j
                        index_ceq = index_ceq + 1;
                        
                        B1 = q * ( a(:,k) .* fs(:,k) );
                        B2 = q * ( b(:,k) );
                        
                        ceq(index_ceq) = (A1 + A2) - (B1 + B2);
                    end
                end
            end
        end
        
        for i = 1:n_no_zero
            j = idx_no_zero(i);
            
            A1 = q * ( a(:,j) .* fs(:,j) );
            A2 = q * ( b(:,j) );
            for w = 1:n_zero
                k = idx_zero(w);
                
                index_c = 1 + index_c;
                
                B1 = q * ( a(:,k) .* fs(:,k) );
                B2 = q * ( b(:,k) );
                
                c(index_c) = (A1 + A2) - (B1 + B2);
            end
        end
        
    else %There is b flow on every road
        for j = 1:n_links
            A1 = q * ( a(:,j) .* fs(:,j) );
            A2 = q * ( b(:,j) );
            for k = 1:n_links
                if j < k
                    index_ceq = 1 + index_ceq;
                    
                    B1 = q * ( a(:,k) .* fs(:,k) );
                    B2 = q * ( b(:,k) );
                    
                    ceq(index_ceq) = (A1 + A2) - (B1 + B2);
                end
            end
        end
    end
end