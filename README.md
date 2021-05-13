# Streaming-DMD-integrated-within-NEK5000
All the credits for the algorithm goes to Hemati et al. [1]

Required files to run the Nek5000 simulation:
1. .usr file
2. .par file
3. .re2 file
4. SIZE
5. .his file

**Addition to the core file:
Copy-Paste the code given in the "Addition_to_postpro" file to postpro.f in the core folder

Inputs:
1. List the x-y-z coordinates of all the interested points in the domain in the .his file.
2. "linterpol=ntot" in the SIZE file where ntot is the total number of points in the .his file
3. lhis>linterpol

4. In the .usr file:

  -commenc value in the userchk() specifies the timestep at which the Streaming DMD algorithm begins 
  -termin value  in the userchk() specifies the timestep at which the Streaming DMD will terminate
  -rmax value in the streaming_dmd() subroutine limits the max rank of the DMD modes

Outputs:
1. A, Qx, Qy and Gx matrices
2. istep_n -- Stores the u-v-w velocity data of each point at timestep n in the form of a packed array:
   [ u1
     u2 
     u3
     .
     u_linterpol
     v1
     v2
     v3
     .
     .
     v_interpol
     w1
     w2
     w3
     .
     .
     w_interpol]      
  
     istep file is periodically written at a time interval of 1000 timesteps after commenc.
     Ground truth velocities are stored and saved in istep file so that the DMD predicted velocities can be later compared for accuracy.

 Run the matlab code 'dmd_fortran.m' to finish the last step in the alfgorithm and construct the DMD modes and Eigenvalues. 



[1] Hemati, M. S., Williams, M. O., & Rowley, C. W. (2014). Dynamic mode decomposition for large and streaming datasets. Physics of Fluids, 26(11), 111701. https://doi.org/10.1063/1.4901016

