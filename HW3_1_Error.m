% Once the .csv files of error vectors have been written, we scan through
% them to choose corresponding c

% NOTE : The runtimes are quite large. Owing to this reason, we've chosen a
% set of c values over a few run times with different choice of vector c.
% Ideally the following approach should've been adopted : For each epsilon,
% or error, we should find out c, then over 10 trials average this c value
% and convert it to an integer. There are a few reasons why this approach
% wasn't preferred, even though using it would've only required a few very
% minor modifications in code - 

% Reason 1 : For each error value selected, the scale of c values over
% which a 'check' should be performed to obtain the 'best possible' value
% of c that just satisfies the error bound, would have obviously been
% drastically different. This is predominantly seen in the .csv files we've
% exported and in the different runtimes that were performed using a host
% of c values, that for each c, calculated average error over 10 trials.
% Thus due to this 'c scale' being different for each error, it would've
% been difficult to iterate over a 'pre-selected c'

% Reason 2 : The most prominent reason however was that to iterate over all
% possible values of c, that is for c = {1,2,.......,1000} would've been
% extremely time consuming. Additionally c for columns could take values
% till 10^5. Again, obviously convergence is expected much earlier, however
% an additional issue is that even if convergence is expected for small c
% values it is still costly to iterate over 50-100 values of c. Again c
% range isn't uniform for each error, and for each error iterating with
% small changes in c is extremely time consuming (iterating over 20 values
% of c, for 10 trials in each c, took about 1.5 hours)

% Reason 3 : Picking the best c by averaging doesn't let us see how c value
% affects the errors. Thus even if run times are neglected, we don't 'see'
% the full behaviour of randomized SVD over a host of c values

% Owing to all the above reasons, iteration over an appropriately spaced
% set of 15 c values was performed, based on our experience with c = 100
% obtained a priori

% For each c, over 10 trials, errors for U and V were averages and exported
% to .csv. From this .csv, for our errors given, we'll extract the c that
% is closest to this error. Additionally we can even see the behaviour of
% errors against different c values. Thus an algorithm that 'only picked c'
% corresponding to all the errors could've been performed with minor
% modifications in the loops, with the same 'for loop complexity'. 

% THUS, rather than picking c for an error over 10 trials and then
% averaging over those c's for each error, we've obtained average error
% over 10 trials over each c for a host of 'optimally spaced c-values'

% Also there will be very minor changes in obtained errors for different
% runs, as such due to averaging this will be small

% Now we'll search for c from our .csv files for each error

U_err = readmatrix('U_Errors.csv');
V_err = readmatrix('V_Errors.csv');
c = readmatrix('C_Values.csv');
disp(U_err)
disp(V_err)
disp(c)

% These have been stored after extraction in previous file

errors = [0.01 0.05 0.1];

summ_U = zeros(3,3);

summ_V = zeros(3,3);



for i = 1:3
    
    del = zeros(length(c),1);
    
    for j = 1:length(c)
        del(j,1) = abs(errors(i) -  U_err(j,1)); % Note : abs is taken, thus even if obtained error is a bit larger than error bound, if it is absolutely the closest, then c smallest is closer to that corresponding c value, maybe a bit larger to reduce mildly the error
    end                                        % This thus implies that more preference has been given to making c as small as possible, again, this doesn't make much difference even if abs wasn't taken and actual 'comparison' was done
    
    [minimum, location] = min(del);
    
    summ_U(i,1) = errors(i);
    summ_U(i,2) = c(location);
    summ_U(i,3) = minimum;
    
    
end

disp('The matrix containing errors in column 1, corresponding c optimals in column 2 and  absolute distance of the error corresponding to that c optimal from the given error in column 3, for U, is as follows : ')
disp(summ_U)
writematrix(summ_U,'U_Summary.csv')



for i = 1:3
    
    del = zeros(length(c),1);
    
    for j = 1:length(c)
        del(j,1) = abs(errors(i) -  V_err(j,1)); 
    end                                        
    
    [minimum, location] = min(del);
    
    summ_V(i,1) = errors(i);
    summ_V(i,2) = c(location);
    summ_V(i,3) = minimum;
    
    
end

disp('The matrix containing errors in column 1, corresponding c optimals in column 2 and absolute distance of the error corresponding to that c optimal from the given error in column 3, for V, is as follows : ')
disp(summ_V)
writematrix(summ_V,'V_Summary.csv')






















