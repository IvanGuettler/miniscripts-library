function [ H,p_value ] = MannKendall( input,alpha );

%there should be no autocorrelation in residuals

%IG
ivan=isnan(input); input(ivan)=[];

N=length(input);
input=reshape(input,N,1);
alpha=alpha/2;

i=0; j=0; S=0;
for i=1:N-1
    for j=i+1:N
        S=S+sign( input(j)-input(i) );
    end
end
%no ties
stdS=sqrt((N*(N-1)*(2*N+5))/18);

if (S>0)
    Z=((S-1)/stdS);
elseif (S==0)
    Z=0;
elseif (S<0)
    Z=(S+1)/stdS;
end

%two-tailed test
p_value=2*(1-normcdf(abs(Z),0,1));
pz=norminv(1-alpha,0,1);
H=abs(Z)>pz;
return

