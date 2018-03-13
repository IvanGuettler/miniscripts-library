%---
% 2.3.1 Example of use of Gumbel's method from Holmes (2001) Wind loading of structures now
% redefined into GEV
%---
% History
% 2017-10-18 Ivan Guettler (DHMZ): first version of the code
% 2017-10-25 I.G. (DHMZ) syncronize sign of the shape parameter (cf. pg. 15 in "Statistical Analysis of Extreme Values" by Reiss&Thomas

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
	U=data(:,2)';

	pkg load statistics  %Specific for octave.
	params=gevfit(U);    %This function is available in octave "package statistics"
	    k=params(1)*(-1);     %              shape    parameter: change of sign; check 2017-10-25 comment
	alpha=params(2);          %dispersion or scale    parameter
	 beta=params(3);          %      mode or location parameter

%--
% Compute reduced variate
%--
	y=(U-beta)/alpha; %-------------------------> Eq.(2) Palutikof et al. (1999) Meteorol. Appl.

%---
% plot original data vs. reduced variate (irrelevant but for comparison with Holmes_Examples_231.m)
%---

	h=figure(1);
	subplot(2,1,1)
		plot(y,U,'o'); hold on
		xlim([-2 8]); xlabel('reduced variate (GEV)');
		ylim([0 50]); ylabel('Wind speed (m/s)');

%---
% Compute Table 2.3 Prediction of extreme winds for fixed return periods
%---
	R=[10 20 50 100 200 500 1000];
	U_R=beta+alpha/k*(1-(-log(1-1./R)).^(k)); %-> Eq.(3a) Palutikof et al. (1999) Meteorol. Appl.
	[round(R*100)/100; round(U_R*10)/10]'


%---
% Print Table 2.3 (first two columns) on Figure 2.2
%---
	D=length(R);
			text(0.2,22    ,' Return period (years)    Predicted gust speed (m/s) (GEV)');

		for d=[1:D];
			text(0.4,22-d*3,num2str(R(d)));
			text(3.0,22-d*3,num2str(round(U_R(d)*10)/10));
		end
%--
% R vs. U_R graph (return period plot)
%--
	subplot(2,1,2)
	R_c=[10:10:1000];
	U_R_c=beta+alpha/k*(1-(-log(1-1./R_c)).^(k)); %-> Eq.(3a) Palutikof et al. (1999) Meteorol. Appl.
	semilogx(R_c,U_R_c,'r');
		xlabel('R return period (years)'); xlim([min(R) max(R)]);
		ylabel('U_R (m/s)');               ylim([30 47]);

		print(h,'Figure_22_GEVFIT.png')


