The summary sheets :
R_2
R_5
R_15
R_20

Summarizes the following :

First Column : r value
Second Column : U Errors
Third Column : V Errors
Fourth Column : Corresponding c values

Few Notes :

In MATLAB, SVD of a matrix with even a single dimension terribly large results
in a memory issue. Thus, for V, specifically, after obtaining the B matrix by
selecting rows of A or columns of A' (A transpose), we still have one dimension
which is 10^5 and the dimension corresponding to 10^3 has been reduced to c via
random selection. Thus, still, unlike for U, here 10^5 still exists. 

Even though B takes much less memory than A, (from 10^5 * 10^3 to 10^5 * (~200))
it is clear that still B has a pretty large dimension. In the current HW, it was
only mentioned to pick rows of A to estimate V, thus leading to issues when 
SVD of reduced A that is B was obtained.

Some techniques were seen in literature that could help us overcome these issues 
to a certain extent, they weren't implemented here and what was asked in the HW 
was directly implemented.

To overcome this, MATLAB function SVD with economy was used, which calculates
top eigenvectors corresponding to the input matrices' lower dimension.

The lower dimension was c and we had to estimate r eigenvectors, requiring, due
to this MATLAB caveat that c >= r for all c and r over all ranges/regions

Due to this for lower values of r, we could have gotten smaller c values
than the ones obtained

Reasons for this : c was taken common for all r, over which we obtained
our error estimate

As such we could have avoided this by selecting c according to r, that is
based on r, c is selected keeping the MATLAB constraint locally in mind, and
then for each r, a different c range would be obtained

This wouldn't take more than 1-2 lines of code to implement, however, my
first run time of the code took about 6-7 hours, so I chose not to do that

As such this doesn't affect result much, other than c stagnancy for the lower
two r's

Additional way via which this could've been prevented : By closing loops based
on errors and averaging so obtained c over each trial. This has been discussed
before, would also take around 1-2 more lines of code, but has its own
advantages and disadvantages.

Concluding, we could have performed these tasks in multiple ways, each different
and more or less equally valid, with its own advantages and disadvantages, there
could have also possibly existed some solution for the MATLAB caveat internally or
externally or via an alternate algorithm other than the one used here, however
most of these areas could not be explored primarily due to run time constraints
not due to lacking in theoretical adeptness.

Stagnancy can also be remedied in the current case via 'prediction' over
c values for which iteration wasn't performed, in lieu of performing it again,
due to run time constraints, again