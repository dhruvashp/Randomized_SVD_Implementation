R_2 = readmatrix('Summary_r_2.csv');
R_5 = readmatrix('Summary_r_5.csv');
R_15 = readmatrix('Summary_r_15.csv');
R_20 = readmatrix('Summary_r_20.csv');

U_summ_r = zeros(4,3);
V_summ_r = zeros(4,3);


disp(R_2)
disp(R_5)
disp(R_15)
disp(R_20)

% Using similar approaches, c optimal for each r for U and V for error =
% 0.05 is obtained thus

r = [2,5,15,20];
c = [20,25,30,35,40,45,50,55];

U_summ_r(:,1) = r(1,:);
V_summ_r(:,1) = r(1,:);


U_2 = R_2(:,2);
V_2 = R_2(:,3);

U_5 = R_5(:,2);
V_5 = R_5(:,3);

U_15 = R_15(:,2);
V_15 = R_15(:,3);

U_20 = R_20(:,2);
V_20 = R_20(:,3);

U_del_2 = abs(0.05 -  U_2);
V_del_2 = abs(0.05 - V_2);

U_del_5 = abs(0.05 -  U_5);
V_del_5 = abs(0.05 - V_5);

U_del_15 = abs(0.05 -  U_15);
V_del_15 = abs(0.05 - V_15);

U_del_20 = abs(0.05 -  U_20);
V_del_20 = abs(0.05 - V_20);

[min1,ind1] = min(U_del_2);
U_summ_r(1,2) = c(ind1);
U_summ_r(1,3) = min1;

[min2,ind2] = min(U_del_5);
U_summ_r(2,2) = c(ind2);
U_summ_r(2,3) = min2;

[min3,ind3] = min(U_del_15);
U_summ_r(3,2) = c(ind3);
U_summ_r(3,3) = min3;

[min4,ind4] = min(U_del_20);
U_summ_r(4,2) = c(ind4);
U_summ_r(4,3) = min4;


[min5,ind5] = min(V_del_2);
V_summ_r(1,2) = c(ind5);
V_summ_r(1,3) = min5;

[min6,ind6] = min(V_del_5);
V_summ_r(2,2) = c(ind6);
V_summ_r(2,3) = min6;

[min7,ind7] = min(V_del_15);
V_summ_r(3,2) = c(ind7);
V_summ_r(3,3) = min7;

[min8,ind8] = min(V_del_20);
V_summ_r(4,2) = c(ind8);
V_summ_r(4,3) = min8;


disp('The r, c optimal, absolute distance to error = 0.05, for U, is : ')
disp(U_summ_r)

disp('The r, c optimal, absolute distance to error = 0.05, for V, is : ')
disp(V_summ_r)

writematrix(U_summ_r,'U_summary_r_ii.csv')

writematrix(V_summ_r,'V_summary_r_ii.csv')






