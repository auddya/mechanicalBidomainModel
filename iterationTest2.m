tic
close all
clear all
N = 100;
L = 0.005; %0.005m
g = 100000; %100000; %100000 Pa/m
mu_zero = 1000; %1000 Pa
nu = 1000; %1000 Pa
K = 50000000000; %50GPa/m2
T = 200; %200Paextracellular displacement
w = zeros(N,1); %Extracellular displacement
u = zeros(N,1); %Intracellular displacement
x = zeros(N,1); %x position, useful when plotting
delta = (2*L)/(N-1); %Spacing along x direction
iterations = 100;
for i = 1:N
    x(i) = L*(2*(i-1)/(N-1)-1); 
    mu(i) = mu_zero + g*x(i);
end
%e = zeros(101,1);
p = 0; %Counter for Computation Time Array
for over = 1:0.01:1.99
  tic
  for k = 1:iterations
    for i = 2:(N-1)
        a(i) = 4*mu(i)*(w(i+1)+w(i-1))+(mu(i+1)-mu(i-1))*(w(i+1)-w(i-1));
        b(i) = 4*nu*(u(i+1)+u(i-1));
        A(i) = 8*mu(i) + K*delta*delta;
        C = 8*nu + K*delta*delta;
        B = K*delta*delta;
        resi_u(i) = (a(i)*B + A(i)*b(i))/(A(i)*C - B*B);
        u(i) = u(i) + over*(resi_u(i) - u(i));
        resi_w(i) = (a(i)/A(i)) + (B/A(i))*((a(i)*B + A(i)*b(i))/(A(i)*C - B*B));
        w(i) = w(i) + over*(resi_w(i) - w(i)); 
    end
    %Apply Boundary Conditions
    u(1) = u(2) + (T*delta/(4*nu));
    w(1) = w(2);
    u(N) = u(N-1) - (T*delta/(4*nu));
    w(N) = w(N-1);
  end 
  p = p + 1;
  et(p) = toc; %Stores the time for each step
end
[val,idx] = min(et) %Outputs minimum value and index of et
for i = 1:N
    h(i) = u(i)-w(i);
end 
plot(x,h)  % if you want plot with x in mm, use plot(x*1000,h)?
xlabel('x');
ylabel('u-w');
title('Difference between u and w');
toc