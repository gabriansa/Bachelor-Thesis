function [fig1, fig2] = myplots(phi, fb, objective, const_phi, ...
    const_icc, const_bwep, n, k, n_links, n_states)

% This function is used to plot results obtained by algo.m
%
% Figure 1: this figure contains four different plots
%           Plot 1     : the objective function is plotted for each
%                        possible set of fb
%           Plot 2     : The value of constraint 1 (Phi = 1) is plotted for
%                        each set of fb
%           Plot 3     : The value of constraint 2 (I.C.C) is plotted for
%                        each set of fb
%           Plot 4 & 5 : The value of constraint 3 (BWE-P) is plotted for
%                        each set of fb.
%
% Figure 2: this figure is used to plot the results of phi for each state.
%           This figure is created only for the 2-links and 3-links case

% Setting up wait bar
h = waitbar(0,'Please wait ...','Name','Plotting Graphs');

% FIGURE 1: Objective values and constraints
fig1 = figure('Name','Objective Values & Constraints','NumberTitle', ...
    'off','units','normalized','outerposition',[0 0 1 1], ...
    'DefaultAxesFontSize', 12);

x = 1:n;

[~, idx_opt] = min(objective{1});
[~, idx_no_opt] = min(objective{2});


%%% Plot 1: Objective
obj_opt = objective{1};
obj_no_opt = objective{2};

subplot(6,1,1)
plot(x, obj_opt,'b*')
hold on
plot(x, obj_no_opt,'r*')
hold on
plot(idx_opt, obj_opt(idx_opt),'g*')
hold on
plot(idx_no_opt, obj_no_opt(idx_no_opt),'y*')
xlim([0 n+1])
xlabel("$f_b$ set number"+newline+"   ",'Interpreter','latex')
ylabel('Objective value','Interpreter','latex')
title('\textbf{Optimal Value}','Interpreter','latex')
set(gca,'Color','#DCDCDC')


%%% Plot 2: Constraint 1 --> Phi
const_phi_yes = const_phi{1};
const_phi_no = const_phi{2};

subplot(6,1,2)
plot(x, const_phi_yes,'b*')
hold on
plot(x, const_phi_no,'r*')
hold on
plot(idx_opt, const_phi_yes(idx_opt, :),'g*')
hold on
plot(idx_no_opt, const_phi_no(idx_no_opt, :),'y*')
xlim([0 n+1])
xlabel("$f_b$ set number"+newline+"   ",'Interpreter','latex')
ylabel('Constraint value','Interpreter','latex')
title('\textbf{Constraint 1: Phi per road = 1 (EQUALITY)}', ...
    'Interpreter','latex')
set(gca,'Color','#DCDCDC')


% Plot 3: Constraint 2 --> I.C.C.
const_icc_yes = const_icc{1};
const_icc_no = const_icc{2};

subplot(6,1,3)
plot(x, const_icc_yes,'b*')
hold on
plot(x, const_icc_no,'r*')
hold on
plot(idx_opt, const_icc_yes(idx_opt, :),'g*')
hold on
plot(idx_no_opt, const_icc_no(idx_no_opt, :),'y*')
xlim([0 n+1])
xlabel("$f_b$ set number"+newline+"   ",'Interpreter','latex')
ylabel('Constraint value','Interpreter','latex')
title('\textbf{Constraint 2: I.C.C. (INEQUALITY)}','Interpreter','latex')
set(gca,'Color','#DCDCDC')


% Plot 4 & 5: Constraint 3 --> BWE-P
ceq_const_bwep_yes = const_bwep{1};
ceq_const_bwep_no = const_bwep{2};

c_const_bwep_yes = const_bwep{3};
c_const_bwep_no = const_bwep{4};


% Plot 4
subplot(6,1,4)
plot(x, ceq_const_bwep_yes,'b*')
hold on
plot(x, ceq_const_bwep_no,'r*')
hold on
plot(idx_opt, ceq_const_bwep_yes(idx_opt, :),'g*')
hold on
plot(idx_no_opt, ceq_const_bwep_no(idx_no_opt, :),'y*')
xlim([0 n+1])
xlabel("$f_b$ set number"+newline+"   ",'Interpreter','latex')
ylabel('Constraint value','Interpreter','latex')
title('\textbf{Constraint 3: BWE-P (EQUALITY)}','Interpreter','latex')
set(gca,'Color','#DCDCDC')


% Plot 5
subplot(6,1,5)
plot(x, c_const_bwep_yes,'b*');
hold on;
plot(x, c_const_bwep_no,'r*');
hold on;
plot(idx_opt, c_const_bwep_yes(idx_opt, :),'g*');
hold on;
plot(idx_no_opt, c_const_bwep_no(idx_no_opt, :),'y*');
xlim([0 n+1])
xlabel("$f_b$ set number"+newline+"   ",'Interpreter','latex')
ylabel('Constraint value','Interpreter','latex')
title('\textbf{Constraint 3: BWE-P (INEQUALITY)}','Interpreter','latex')
set(gca,'Color','#DCDCDC')


% Notes Figure 1
subplot(6,1,6);
plot(NaN,NaN,'b*');
hold on;
plot(NaN,NaN,'r*');
hold on;
plot(NaN,NaN,'g*');
hold on;
plot(NaN,NaN,'y*');
hold on;
legend('Feasible objective/constraint', ...
    'Non-feasible objective/constraint', ...
    'Optimal feasible objective/constraint',...
    'Optimal non-fesible objective/constraint');
legend('Location','westoutside', 'Interpreter','latex')
hold on;

if n == k
    fb_opt = mat2str(fb(idx_opt,:),4);
    msg(1) = "All solutions are feasible (n="+n+")";
    msg(2) = "The optimal feasible solution is found at $f_b =$"+ fb_opt;
elseif k == 0
    msg(1) = "There are no feasible solutions";
else
    fb_opt = mat2str(fb(idx_opt,:),4);
    fb_no_opt = mat2str(fb(idx_no_opt,:),4);
    msg(1) = "Out of n = " + n + " solutions k = " + k + " are feasible";
    msg(2) = "The optimal feasible solution is found at $f_b =$"+ fb_opt;
    msg(3) = "The optimal non-feasible solution is found at $f_b=$"+ ...
        fb_no_opt;
end

notes = msg;

set(gca,'XColor', 'none','YColor','none', 'Color', 'none')
text(0,0.5, ['\textbf{Notes:}', notes], 'Interpreter','latex',...
    'FontSize',14)


% FIGURE 2
if n_links == 2
    fig2 = figure('Name','Phi Solutions','NumberTitle','off', ...
        'units','normalized','outerposition',[0 0 0.8 0.8], ...
        'DefaultAxesFontSize', 12);
    
    for j=1:n_states
        for i=1:n
            x_phi_opt(i) = phi{1}{i}(j,1);
            y_phi_opt(i) = phi{1}{i}(j,2);
            
            x_phi_no_opt(i) = phi{2}{i}(j,1);
            y_phi_no_opt(i) = phi{2}{i}(j,2);
        end
        subplot(1,n_states,j)
        plot(x_phi_opt, y_phi_opt, 'b*');
        hold on;
        plot(x_phi_no_opt, y_phi_no_opt, 'r*');
        hold on;
        title(sprintf('\\textbf{State %d: $\\phi^{\\theta_%d}_j$}', j, ...
            j) ,'Interpreter','latex')
        xlabel(sprintf('$\\phi^{\\theta_%d}_1$', j),'Interpreter','latex')
        ylabel(sprintf('$\\phi^{\\theta_%d}_2$', j),'Interpreter','latex')
        set(gca,'Color','#DCDCDC')
    end
    axP = get(gca,'Position');
    legend('Feasible solution', 'Non-feasible solution','Interpreter', ...
        'latex')
    legend('Location','northwestoutside')
    set(gca, 'Position', axP)
    
elseif n_links == 3
    fig2 = figure('Name','Phi Solutions','NumberTitle','off', ...
        'units','normalized','outerposition',[0 0 0.8 0.8], ...
        'DefaultAxesFontSize', 12);
    
    for j=1:n_states
        for i=1:n
            x_phi_opt(i) = phi{1}{i}(j,1);
            y_phi_opt(i) = phi{1}{i}(j,2);
            z_phi_opt(i) = phi{1}{i}(j,3);
            
            x_phi_no_opt(i) = phi{2}{i}(j,1);
            y_phi_no_opt(i) = phi{2}{i}(j,2);
            z_phi_no_opt(i) = phi{2}{i}(j,3);
        end
        subplot(1,n_states,j)
        plot3(x_phi_opt, y_phi_opt, z_phi_opt, 'b*');
        hold on;
        plot3(x_phi_no_opt, y_phi_no_opt, z_phi_no_opt, 'r*');
        hold on;
        title(sprintf('\\textbf{State %d: $\\phi^{\\theta_%d}_j$}', j,...
            j) ,'Interpreter','latex')
        xlabel(sprintf('$\\phi^{\\theta_%d}_1$', j),'Interpreter','latex')
        ylabel(sprintf('$\\phi^{\\theta_%d}_2$', j),'Interpreter','latex')
        zlabel(sprintf('$\\phi^{\\theta_%d}_3$', j),'Interpreter','latex')
        set(gca,'Color','#DCDCDC')
    end
    axP = get(gca,'Position');
    legend('Feasible solution', 'Non-feasible solution','Interpreter', ...
        'latex')
    legend('Location','northwestoutside')
    set(gca, 'Position', axP)
end
delete(h);


