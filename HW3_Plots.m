% Quite a few plots will be drawn to visualize the various relations

% Read Me files give an explanation of why various plots appear in a
% certain way


% Plot 1 - For error = 0.05, c vs r

U_summ_r = readmatrix('U_summary_r_ii.csv');
V_summ_r = readmatrix('V_summary_r_ii.csv');

plot(U_summ_r(:,1),U_summ_r(:,2),'g--o',V_summ_r(:,1),V_summ_r(:,2),'b--o');
xlabel('r')
ylabel('c, green = U, blue = V')