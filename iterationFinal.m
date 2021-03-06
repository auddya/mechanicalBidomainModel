tic
close all
clear all
N = 100;
L = 0.0005; %0.005m
g = 60000000; %100000 Pa/m
mu_zero = 40000; %1000 Pa
nu = mu_zero; %1000 Pa
K = 200000000000000; %50GPa/m2
T = 200; %200Pa
w = zeros(N,1); %Extracellular displacement
u = zeros(N,1); %Intracellular displacement
x = zeros(N,1); %x position, useful when plotting
delta = (2*L)/(N-1); %Spacing along x direction
for i = 1:N
    x(i) = L*(2*(i-1)/(N-1)-1); 
    mu(i) = mu_zero + g*x(i);
end
overc = 0;
resitol = 1e-12;
for over = 1.00:0.01:1.99
  overc = overc+1;  
  residmax = 1000000000;
  kay = 0;
    while residmax>resitol
      kay = kay+1;
      for i = 2:(N-1)
        a(i) = 4*mu(i)*(w(i+1)+w(i-1))+(mu(i+1)-mu(i-1))*(w(i+1)-w(i-1));
        b(i) = 4*nu*(u(i+1)+u(i-1));
        A(i) = 8*mu(i) + K*delta*delta;
        eixx(i) = (u(i+1)-u(i-1))/(2*delta);
        eexx(i) = (w(i+1)-w(i-1))/(2*delta);
        C = 8*nu + K*delta*delta;
        B = K*delta*delta;
        resi_u(i) = (a(i)*B + A(i)*b(i))/(A(i)*C - B*B) - u(i);
        u(i) = u(i) + over*(resi_u(i));
        resi_w(i) = (a(i)/A(i)) + (B/A(i))*((a(i)*B + A(i)*b(i))/(A(i)*C - B*B)) - w(i);
        w(i) = w(i) + over*(resi_w(i)); 
      end
    %Apply Boundary Conditions
    u(1) = u(2) + (T*delta/(4*nu));
    w(1) = w(2);
    u(N) = u(N-1) - (T*delta/(4*nu));
    w(N) = w(N-1);
    eixx(1) = (u(2)-u(1))/(delta);
    eixx(N) = (u(N)-u(N-1))/(delta);
    eexx(1) = (w(2)-w(1))/(delta);
    eexx(N) = (w(N)-w(N-1))/(delta);
    if(kay>1)
      residmax = max(max(abs(resi_u)),max(abs(resi_w)));
    end
    end
%   kay
%   residmax
%   toc
 ubackup = u;
 wbackup = w;
 eixxbackup = eixx;
 eexxbackup = eexx;
 for i=1:N
     stressexx(i) = 4*mu(i)*eexxbackup(i);
     stressixx(i) = 4*nu*eixxbackup(i);
 end 
 stressebackup = stressexx;
 stressibackup = stressixx;
 u(1:end) = 0.0;
 w(1:end) = 0.0;
 eixx(1:end) = 0.0;
 eexx(1:end) = 0.0;
 stressexx(1:end) = 0.0;
 stressixx(1:end) = 0.0;
 kay_store(overc) = kay;
 residmax_store(overc) = residmax;
 end
 %pcount = 1:1:overc; %Over relaxation Parameter count
 %plot(pcount, kay_store)
 for i = 1:N
 h(i) = ubackup(i)-wbackup(i);
 end
 plot(x,stressebackup)
 hold on
 plot(x,stressibackup)
 legend('intra stress','extra stress');
 overc = 0;
 %hold on
 %legend('tolerance = 1e-16')
 %set(gca,'XTick',[0 10 20 30 40 50 60 70 80 90 100]);
 %set(gca,'XTickLabel',[1 1.09 1.19 1.29 1.39 1.49 1.59 1.69 1.79 1.89]);
 xlabel('Length (in microns)');
 ylabel('\tau_{xx}');
 title('Stress');
 xt = arrayfun(@num2str,get(gca,'xtick')*10^6,'un',0);
 yt = arrayfun(@num2str,get(gca,'ytick'),'un',0);
 set(gca,'xticklabel',xt,'yticklabel',yt)
 %xlim([-0.00002 0.00002]);
 %ylim([-0.0000003 0.0000003]);
 toc