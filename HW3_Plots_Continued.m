% Continued Plots for Visualization

% Plots of r, c, error FOR U

R_2 = readmatrix('Summary_r_2.csv');
R_5 = readmatrix('Summary_r_5.csv');
R_15 = readmatrix('Summary_r_15.csv');
R_20 = readmatrix('Summary_r_20.csv');

plot(R_2(:,4),R_2(:,2),'g--o',R_5(:,4),R_5(:,2),'b--o',R_15(:,4),R_15(:,2),'y--o',R_20(:,4),R_20(:,2),'r--o')
xlabel('c')
ylabel('U errors, green r=2, blue r=5, yellow r=15, red r=20')
