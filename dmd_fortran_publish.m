 function dmd_fortran_publish

% Version 2.0
dt=0.1;  % Timestep-size


% A, Qx, Qy, Gx are obtianed from Nek5000 simulation
A=importdata('A.dat');
Qx=importdata('Qx.dat');
Qy=importdata('Qy.dat');
Gx=importdata('Gx.dat');

A_size=size(A);
Qx_size=size(Qx);
Qy_size=size(Qy);
Gx_size=size(Gx);

snap_commenc=importdata('istep_commenc.dat'); %istep_commenc is the timestep at which the DMD begins
Ktilde = Qx' * Qy * A * pinv(Gx);
[evecK, evals] = eig(Ktilde);
evals = diag(evals);              
modes = Qx * evecK;
 
%% Now we shall reconstruct the velocities from modes and evals
str="istep_";
count=0;
for n=1:15       % from timestep 100,000 to 140,000 
count=count+1;
append_x=sprintf('%6.0f',n*100000);
for i=1:length(append_x)
    if append_x(i)==" "
        append_x(i)="0";
    end
end
str_x=insertAfter(str,"istep_",append_x)
snap=importdata(str_x);   % imports the true velocities as per the Nek5000 simulation

time=(count-1)*1000*dt;
omega_k=log(evals)./dt;
%b=pinv(phi)*X(:,1);
b=modes\snap_commenc;
p=omega_k*time;
p=exp(p);
omega=diag(p);
modes_size=size(modes);
omega_size=size(omega);
amplitude_size=size(b);
x=modes*omega*b;
approx_x=real(x(:));
exact_x=snap;         %Answers match  

residual=approx_x-exact_x;      % Difference between the DMD prediction and the Nek5000 solution
residual=norm(residual)/norm(exact_x);

% store_exact(:,count)=snap;
% store_dmd(:,count)=approx_x;     % This matrix is saved in the last section of the program
store_res(count)=residual;
end

%% Saving some of the variables
save store_res.mat store_res
save modes.mat modes
save evals.mat evals
save b.mat b