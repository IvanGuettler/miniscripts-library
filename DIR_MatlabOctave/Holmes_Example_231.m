%---
% 2.3.1 Example of use of Gumbel's method from Holmes (2001) Wind loading of structures
%---
% History
% 2017-10-13 Ivan Guettler (DHMZ): first version of the code
% 2017-10-18 Ivan Guettler (DHMZ): code checked. Some comments fixed. R vs. U_R graph added

%---
% Initialize
%---
	close all; clear all; clc


%---
% Read data
%---

	data=load('./Holmes_Table21.txt');

%--
% Sort data
%--
	U=sort(data(:,2))';
	N=length(U);
	m=[1:1:N];

%---
% Compute the probability of non-exceedence p
%---
	p=m./(N+1);

%---
% Compute a reduced variate y
%---
	y=-log(-log(p));

%---
% plot original data vs. reduced variate
%---

	h=figure(1);
	subplot(2,1,1)
		plot(y,U,'o'); hold on
		xlim([-2 8]); xlabel('reduced variate (Gumbel)');
		ylim([0 50]); ylabel('Wind speed (m/s)');
%---
% Compute linear regression U=x0+x1*y (aka Graphical Solution)
%--
	coefs=polyfit(y,U,1);
	y_FIT=[-1.5:0.1:7];
	U_FIT=coefs(2)+coefs(1)*y_FIT;
		plot(y_FIT,U_FIT,'r');
		legend(['original data'],['y=',num2str(coefs(1)),'x+',num2str(coefs(2))]);

%---
% Compute Table 2.3 Prediction of extreme winds for fixed return periods
%---
	R=[10 20 50 100 200 500 1000];
	u=coefs(2);
	a=1/coefs(1);
	U_R=u+1/a*log(R);
	[round(R*100)/100; round(U_R*10)/10]'


%---
% Print Table 2.3 (first two columns) on Figure 2.2
%---
	D=length(R);
			text(0.2,22    ,' Return period (years)    Predicted gust speed (m/s) (Gumbel)');

		for d=[1:D];
			text(0.4,22-d*3,num2str(R(d)));
			text(3.0,22-d*3,num2str(round(U_R(d)*10)/10));
		end

%--
% R vs. U_R graph (return period plot)
%--
        subplot(2,1,2)
        R_c=[10:10:1000];
	beta=u;
	alpha=1/a;
	        U_R_c=beta-alpha*log(-log(1-1./R_c)); %-> Eq.(3b) Palutikof et al. (1999) Meteorol. Appl. / Eq.(2.6) Holmes (2001)
	        semilogx(R_c,U_R_c,'r');
	                xlabel('R return period (years)'); xlim([min(R) max(R)]);
	                ylabel('U_R (m/s)');               ylim([30 47]);

		print(h,'Figure_22.png')

