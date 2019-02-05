close all
clear all
%Initialisation
N = 250;
L = 1.0;
g = 1.0;
mu_zero = 1.0;
nu = 1.0;
K = 1.0;
T = 1.0;
mu = mu_zero + g*zeros(N,1); 
w = zeros(N,1); %Extracellular displacement
u = zeros(N,1); %Intracellular displacement
delta = (2*L)/(N-1); %Spacing along x direction
%Apply Boundary Conditions
u(1) = u(2) + (T*delta/4*nu);
w(1) = w(2);
u(N) = u(N-1) - (T*delta/4*nu);
w(N) = w(N-1);
mu(1) = mu_zero;
iterations = 1000;
%Initialising mu 
for i = 1:N
    mu(i) = mu_zero + (i-1)*delta*g;
end 
%Iterations
for k = 1:iterations
    for i = 2:(N-1)
        a(i) = 4*mu(i)*(w(i+1)+w(i-1))+(mu(i+1)-mu(i-1))*(w(i+1)-w(i-1));
        b(i) = 4*nu*(u(i+1)+u(i-1));
        A(i) = 8*mu(i) + K*delta*delta;
        C = 8*nu + K*delta*delta;
        B = K*delta*delta;
        u(i) = (a(i)*B + A(i)*b(i))/(A(i)*C - B*B);
        w(i) = (a(i)/A(i)) + (B/A(i))*((a(i)*B + A(i)*b(i))/(A(i)*C - B*B));
    end
end 
for i = 1:N
    h(i) = u(i)-w(i);
end 
X = linspace(0,6,N);
plot(X,h)
xlabel('Length of domain (X)');
ylabel('u - w');
title('Difference between extracellular and intracellular displacements');