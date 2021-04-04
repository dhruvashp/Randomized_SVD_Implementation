X = orth(randn(1000,1000));
Y = orth(randn(100000,1000));
D = zeros(1000,1000);
r = 10;
for i = 1:1000
    if i <= r
        D(i,i) = r - i + 1;
    else
        D(i,i) = 4*(10^(-3));
    end
end

% This appropriately fills D up

A = X*D*(transpose(Y));

% Obviously this is a heavy multiplication, eased due to Diagonal D
% Thus it is directly performed without randomized algorithm

% Implementing Randomized SVD 
% A = U W V' where U and V have their usual meanings, and W is the singular
% value matrix (sigma)
% First the Randomized SVD will be performed for U
% For U we need U(r=10) corresponding to the top 10 singular values of A
% This U or U(r) is an m x r matrix, containing top r singular value
% columns of U

% To generate this U(r) an interim matrix B will be created 
% B will contain 'c' columns of A (which has n columns)
% These 'c' columns will be picked at random 
% This will create B, using which U(r=10) will be obtained
% B will me m x c, BB' will be m x m and E(BB') = AA'
% Thus SVD will be done on B instead of A, and then from B's left
% eigenspace the top 10 eigenvectors picked to generate U(r=10)

% Deliberations on V will be done afterwards (after U)



% Probability Distribution Generation

% We need to generate {1,2,3,....,n} with distribution {p1,p2,p3,.....,pn}
% where pi = (norm(Ai)/frobenius norm(A))^2

% Leon Garcia describes a method to generate such a distribution, which
% will be used here

% To get a feel of Randomized SVD, this Part 1 will be performed with 
% c = 100

fro_A = norm(A,'fro');

c = 100;
col_selected = zeros(c,1);
unif_selected = rand(c,1);
p = 0;

for i = 1:100000
  p_low = p;
  p = (((norm(A(:,i)))^2)/((fro_A)^2)) + p;
  col_selected(((unif_selected > p_low) & (unif_selected <= (p)))) = i;
end

% col_selected contains 100 IID RV's sampled, each in {1,2,...,n} with
% probability {p1,p2,......,pn}
% This is done using uniform RV, internally generated by MATLAB, and
% exploiting its CDF, we obtain the required discrete PMF

B = zeros(1000,c);

for i = 1:c
   prob = (((norm(A(:,col_selected(i,1))))^2)/((fro_A)^2));
   B(:,i) = ((A(:,col_selected(i,1)))/((c*prob)^0.5));
end

% B has been generated off of A, as needed

% Now, we will perform SVD on B
% The left eigenspace of this B is observed, and its top 10 eigenvectors
% selected to construct U(r=10)

% We will assumes that singular values of A, the top 10 singular values of
% A, and its estimation is not needed currently. As such we could argue,
% quite easily, a method to obtain those from B, or more accurately,
% estimate those from B in general
% If needed in the future, this will be done. Not right now.

U_r_e = zeros(1000,r);
[U_B,S_B,V_B] = svd(B); %#ok<*ASGLU>
U_r_e(:,1:r) = U_B(:,1:r);

% SVD performed on B, MATLAB arranges singular values automatically in
% decreasing order, and so we pick the first r columns for U_r, here
% obviously r = 10

% Error Calculation : 
% Here, again, we'll only calculate these errors, nothing more, for c = 100
% just to get a feel of the randomized SVD

% Error = spectral norm (UU'|estimate,r - UU'|actual,r)/spectral norm(UU'|actual,r)
% spectral norm (UU'|actual,r) = 1 (UU'|actual,r = I) (given)

% So 
% Error = spectral norm (UU'|estimate,r - UU'|actual,r)

% Define UU'|estimate,r - UU'|actual,r = U|error,r
% We need ||U|error,r|| 
% Obviously ||U|error,r|| = largest singular value of U|error,r

% Power Method
% Power Method, if applied to, U|error,r, will return its largest eigenvalue
% We need its spectral norm, which is square root of largest eigenvalue of
% (U|error,r)*(U|error,r)' 
% Define, (U|error,r)*(U|error,r)' = U_power
% Applying power method on U_power gives largest eigenvalue of (U|error,r)*(U|error,r)'
% Taking its square root, returns square root of largest eigenvalue of
% (U|error,r)*(U|error,r)', which is nothing but ||U|error,r||

% Note : (U|error,r)' = (U|error,r)

% Thus, in conclusion, power method will be applied to (U|error,r)^2
% The square root of the output then, returns spectral norm of
% ||U|error,r||, which is what is needed

% Important : This is why power method will fail if applied directly on
% U|error,r as it will not estimate its largest singular value (spectral
% norm, as needed) but rather it will estimate its largest eigen value. To
% fix this, as it is symmetric, squaring is appropriate due to relationship
% between matrix singular values and left/right eigenvalues


% Obtaining U_r_a by Generalized Power Method
% A few Notes on the Generalized Power Method :
% The generalized power method has quite a few caveats when utilized to
% estimate the top 'k' eigenvalues and corresponding 'k' eigenvectors of an
% arbitrary square matrix A. These caveats are due to various reasons
% corresponding to the type of eigenvalues and eigenvectors that matrix A
% has
% In general, for a rectangular A, when we obtain AA' which is square and
% symmetric, we note that such AA' for real A (complex cases are simple
% extensions; though they aren't discussed here as it isn't needed) are
% positive semi-definite and have properties that allows Generalized Power
% Method to work quite accurately and without any issues.

% We need U_r_a which is the U(r) actual, via the power method to compare
% it to the estimate obtained

% As such, U_r_a can't be obtained by SVD on A as A is extremely heavy

% Thus we'll obtain AA'. Then generalized power method on this AA' will be
% performed to obtain top r eigenvectors of AA', which are the top r
% eigenvectors of U in A = U W V'. Thus generalized power method on AA'
% yields U_r_a. This is done quite simply due to the suitability of the
% 'problem', as discussed above.

error_power_U = 0.00001;

A_l = A*transpose(A);
Q = rand(1000,r);
U_l = A_l*Q;  % top r of AA' is top r of U which is U(r)
[Q,R] = qr(U_l,0);
Q_old = zeros(1000,r);
while norm(Q - Q_old) > error_power_U  % For convergence spectral norm of the difference of successive Q's must be smaller than predefined error
    Q_old = Q;
    U_l = A_l*Q;
    [Q,R] = qr(U_l,0);
end

U_r_a = Q; % Q contains top r eigenvectors of A's left eigenspace, which is U(r)

% Since U(r) can't be actually calculated (from U, from SVD of A, as A is
% too large) we assume that this U(r), which is in itself an estimate is
% the 'true' U(r)


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
fprintf('The spectral norm error for U is : %f\n',spectral_norm_error_U)













%-------------------------------------------------------------------------

% Additional Assumption : We've assumed simultaneity in operations to
% generate U and V for A, corresponding to top r eigenvectors, is, in
% general not needed, as Randomized SVD is sufficiently consistent to give
% results that are consistent even if performed for U and V seperately, in
% general. Excluding this assumption makes the code more cluttered. The
% code doesn't change much, is not more complicated or new, and just
% performs the underneath operations simultaneously. For both U and V.


% For V, Note this is all still for c=100, a single loop

% If A = U W V', A' = V W' U' = U W V'|for A'
% We need V, which is same as U for A'
% Thus everything for V is exactly the same as that for U, but with A
% replaced by A'


% FOR V


A1 = transpose(A);
fro_A1 = norm(A1,'fro');

c = 100;                                            % c for U and V assumed same, as such
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



%{
error_power_V = 0.00001;

B_l = B*transpose(B);
Q = rand(100000,r);
V_l = B_l*Q;  
[Q,R] = qr(V_l,0); %#ok<*ASGLU>
Q_old = zeros(100000,r);
while norm(Q - Q_old) > error_power_V 
    Q_old = Q;
    V_l = B_l*Q;
    [Q,R] = qr(V_l,0);
end

V_r_e = Q; 
%}


%{
error_power_V = 0.00001;

A_l = A1*transpose(A1);
Q = rand(100000,r);
V_l = A_l*Q;  
[Q,R] = qr(V_l,0);
Q_old = zeros(100000,r);
while norm(Q - Q_old) > error_power_V 
    Q_old = Q;
    V_l = A_l*Q;
    [Q,R] = qr(V_l,0);
end

V_r_a = Q;
%}




V_r_a = zeros(100000,r);
[U_A1,S_A1,V_A1] = svd(A1,'econ');
V_r_a(:,1:r) = U_A1(:,1:r);




%{

V_error = (V_r_e*(transpose(V_r_e))) - (V_r_a*(transpose(V_r_a)));
V_power = (V_error)*(V_error);

%}

error_power = 0.00001;

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
fprintf('\nThe spectral norm error for V is : %f\n',spectral_norm_error_V)

