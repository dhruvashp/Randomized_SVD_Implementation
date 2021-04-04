X = orth(randn(1000,1000));
Y = orth(randn(100000,1000));
D = zeros(1000,1000);
r_set = [2 5 15 20];

r_2 = zeros(8,4);  % 8 rows as c_range has length 8, 4 columns, 1 for r, 2 for U errors, 3 for V errors, 4 for c values
r_5 = zeros(8,4);  % 8 rows as c_range has length 8, 4 columns, 1 for r, 2 for U errors, 3 for V errors, 4 for c values
r_15 = zeros(8,4); % 8 rows as c_range has length 8, 4 columns, 1 for r, 2 for U errors, 3 for V errors, 4 for c values
r_20 = zeros(8,4); % 8 rows as c_range has length 8, 4 columns, 1 for r, 2 for U errors, 3 for V errors, 4 for c values
% needs to be changed when c_range is changed, important



% These r's can be combined in a larger matrix for generalized analysis,
% not needed here as only 4 values of r

for f = 1:4 
    r = r_set(f);
    for i = 1:1000
        if i <= r
            D(i,i) = r - i + 1;
        else
            D(i,i) = 4*(10^(-3));
        end
    end



    A = X*D*(transpose(Y));
    A_l = A*transpose(A);
    fro_A = norm(A,'fro');
    A1 = transpose(A);
    fro_A1 = norm(A1,'fro');
    error_power = 0.00001;
    error_power_U = 0.00001;

    c_range = [20,25,30,35,40,45,50,55];% Referencing previous results for error = 0.05, Note : Here again, similar to previous questions due to constraints on run time looping over a set 'c range' is done, for which errors will be obtained    
                                       % Fixing an incremental range of c
                                       % over an error, along with its
                                       % range will thus be difficult, in
                                       % general
                                     
    err_U = zeros(length(c_range),1);
    err_V = zeros(length(c_range),1);

    for j = 1:length(c_range)

        err_U_local = zeros(10,1);
        err_V_local = zeros(10,1);
        c = c_range(j);

        for trial = 1:10   % Trial number stays fixed at 10


            col_selected = zeros(c,1);
            unif_selected = rand(c,1);
            p = 0;

            for i = 1:100000
              p_low = p;
              p = (((norm(A(:,i)))^2)/((fro_A)^2)) + p;
              col_selected(((unif_selected > p_low) & (unif_selected <= (p)))) = i;
            end



            B = zeros(1000,c);

            for i = 1:c
               prob = (((norm(A(:,col_selected(i,1))))^2)/((fro_A)^2));
               B(:,i) = ((A(:,col_selected(i,1)))/((c*prob)^0.5));
            end



            U_r_e = zeros(1000,r);
            [U_B,S_B,V_B] = svd(B); %#ok<*ASGLU>
            U_r_e(:,1:r) = U_B(:,1:r);



            Q = rand(1000,r);
            U_l = A_l*Q;  
            [Q,R] = qr(U_l,0);
            Q_old = zeros(1000,r);
            while norm(Q - Q_old) > error_power_U  
                Q_old = Q;
                U_l = A_l*Q;
                [Q,R] = qr(U_l,0);
            end

            U_r_a = Q; 

            U_error = (U_r_e*(transpose(U_r_e))) - (U_r_a*(transpose(U_r_a)));
            U_power = (U_error)*(U_error);

            error_power = 0.00001;

            v = rand(1000,1);
            z = U_power*v;
            v = z/norm(z);
            lambda = transpose(v)*U_power*v;
            lambda_old = 0;
            while abs(lambda - lambda_old) > error_power
                lambda_old = lambda;
                z = U_power*v;
                v = z/norm(z);
                lambda = transpose(v)*U_power*v;
            end

            spectral_norm_error_U = (lambda^0.5);
            err_U_local(trial,1) = spectral_norm_error_U;









           %-----------------------------------------------------------------------------

           % For V










            col_selected = zeros(c,1);
            unif_selected = rand(c,1);
            p = 0;

            for i = 1:1000
              p_low = p;
              p = (((norm(A1(:,i)))^2)/((fro_A1)^2)) + p;
              col_selected(((unif_selected > p_low) & (unif_selected <= (p)))) = i;
            end


            B = zeros(100000,c);

            for i = 1:c
               prob = (((norm(A1(:,col_selected(i,1))))^2)/((fro_A1)^2));
               B(:,i) = ((A1(:,col_selected(i,1)))/((c*prob)^0.5));
            end



            V_r_e = zeros(100000,r);
            [U_B,S_B,V_B] = svd(B,'econ');
            V_r_e(:,1:r) = U_B(:,1:r);


            V_r_a = zeros(100000,r);
            [U_A1,S_A1,V_A1] = svd(A1,'econ');
            V_r_a(:,1:r) = U_A1(:,1:r);


            v = rand(100000,1);
            mat_vec = (V_r_e)*(transpose(V_r_e)*v) - (V_r_a)*(transpose(V_r_a)*v);
            z = (V_r_e)*(transpose(V_r_e)*mat_vec) - (V_r_a)*(transpose(V_r_a)*mat_vec);
            v = z/norm(z);
            lambda = transpose(v)*z;
            lambda_old = 0;
            while abs(lambda - lambda_old) > error_power
                lambda_old = lambda;
                mat_vec = (V_r_e)*(transpose(V_r_e)*v) - (V_r_a)*(transpose(V_r_a)*v);
                z = (V_r_e)*(transpose(V_r_e)*mat_vec) - (V_r_a)*(transpose(V_r_a)*mat_vec);
                v = z/norm(z);
                lambda = transpose(v)*z;
            end

            spectral_norm_error_V = (lambda^0.5);
            err_V_local(trial,1) = spectral_norm_error_V;







        end


        err_U(j,1) = mean(err_U_local);
        err_V(j,1) = mean(err_V_local);



    end
    
    
    if f == 1
        r_2(:,1) = [2;2;2;2;2;2;2;2];
        r_2(:,2) = err_U(:,1);
        r_2(:,3) = err_V(:,1);
        r_2(:,4) = c_range(1,:);
    elseif f == 2
        r_5(:,1) = [5;5;5;5;5;5;5;5];
        r_5(:,2) = err_U(:,1);
        r_5(:,3) = err_V(:,1);
        r_5(:,4) = c_range(1,:);
        
    elseif f == 3
        r_15(:,1) = [15;15;15;15;15;15;15;15];
        r_15(:,2) = err_U(:,1);
        r_15(:,3) = err_V(:,1);
        r_15(:,4) = c_range(1,:);
    else
        r_20(:,1) = [20;20;20;20;20;20;20;20];
        r_20(:,2) = err_U(:,1);
        r_20(:,3) = err_V(:,1);
        r_20(:,4) = c_range(1,:);
    end
    

end


writematrix(r_2,'Summary_r_2.csv')            % Exporting summary results to .csv for further analysis, to save subsequent run times
writematrix(r_5,'Summary_r_5.csv')            % Exporting summary results to .csv for further analysis, to save subsequent run times
writematrix(r_15,'Summary_r_15.csv')          % Exporting summary results to .csv for further analysis, to save subsequent run times
writematrix(r_20,'Summary_r_20.csv')          % Exporting summary results to .csv for further analysis, to save subsequent run times


disp('Summary for r=2, with r, U, V errors and c values is :')
disp(r_2)

disp('Summary for r=5, with r, U, V errors and c values is :')
disp(r_5)

disp('Summary for r=15, with r, U, V errors and c values is :')
disp(r_15)

disp('Summary for r=20, with r, U, V errors and c values is :')
disp(r_20)




