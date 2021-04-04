% Everything similar from 3_1, only looped through
% Thus comments have been removed for simplicity, all explanations from the
% previous file extends here



X = orth(randn(1000,1000));
Y = orth(randn(100000,1000));
D = zeros(1000,1000);
r = 10;     % This is constant here for this question
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

c_range = [10,12,14,16,18,20,40,60,80,100,120,150,180,210,240];    % A few trial runs gave this set of c_range, which shows that for small c, small changes in c are relevant, for large c, smaller changes don't matter much

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





fprintf('\nThe errors for U, with r = 10, over different values of c, averaged over 10 independent trials are : \n')
disp(err_U)

fprintf('\nThe errors for V, with r = 10, over different values of c, averaged over 10 independent trials are : \n')
disp(err_V)

fprintf('\nThe corresponding c values are : \n')
disp(c_range)

writematrix(err_U,'U_Errors.csv')    % Storing to segment due to runtime

writematrix(err_V,'V_Errors.csv')    % Storing to segment due to runtime

writematrix(c_range,'C_Values.csv')  % Storing to segment due to runtime

% We store these vectors in .csv to use them later on in a segmented
% fashion
% Using these .csv files we will then obtain relevant c for given errors
% Note : Different runtimes may give slightly different results and
% different .csv files, due to randomized nature of the application. Again
% due to averaging the overall difference will be small if any


