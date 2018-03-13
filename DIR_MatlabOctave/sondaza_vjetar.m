%Klimatologija 1., Obrada podataka dobivenih sondazom, Ivan Güttler

%Program je testiran za sondaze u Zagreb-Maksimir (128 m) za termin od 
%00Z 01 Jul 2005 do 00Z 15 Jul 2000. U ovom slucaju su pravilne izmjene 
%sondaza u dva termina po UTC-u tijekom dana. 

%Ukoliko ulazna datoteka sadri podatke u drugom obliku (npr. druga postaja,
%ili nedostajanje pojedinih sondaza), moguce je izvrsiti sitne
%promjene u kodu ove skripte.

%--------------------------------------------------------------------------
ulazna_datoteka=input('Unesi ime puno ime datoteke : ','s'); 


        % Unosi se ime datoteke u kojoj se 
        % nalaze podaci od sondazi, npr. ulaz.txt.

id_ulaz=fopen(ulazna_datoteka,'r');

        % Kada MATLAB bude trebao citati iz ulazne datoteke, 
        % id_ulaz ce biti veza na nju.

set   =0;  
redmax=0;
visina=nan(100,50);
smjer =nan(100,50);
brzina=nan(100,50);
        % Svaka sondaza u 00UTC i 12UTC predstavlja jedan set podataka. 
        % Ovdje se samo definiraju maximalni broj clanova
        % matrice u pojedinoj dimenziji, te je podlozno promijeni. Npr. 50
        % sondaza i u svakoj 100 mjerenja po vertikali

%**************************************************************************
%Uzimanje podataka iz pocetne datoteke
disp('------> Ucitavanje podataka')
%**************************************************************************
while (1)
    
    %----------------------------------------------------------------------    
    line=fgetl(id_ulaz);    

    while (length(line)==0)
       line=fgetl(id_ulaz);
    end
        % Preskacemo prazne linije. Vazno, linija mora biti potpuno prazna,
        % bez razmaka. Iako editor teksta pokazuje prazan red, MATLAB i
        % obican razmak tretira kao znak.
   
    
    if(line==-1)
        break
    end % od if 
        % Cita se red po red. Kada MATLAB dodje do kraja datoteke,
        % vrijednost varijable (line) ce biti (-1) i citanje prestaje.

    %----------------------------------------------------------------------
   
 
    %----------------------------------------------------------------------
    if (line(12:14)=='128')
       
        set     =set+1;
        disp(['------> Ucitava se sondaza: ',num2str(set)])
        provjera=0;
                  
        % Kada se 128 pojavljuje u datoteci, to znaci da slijedi novi niz 
        % podataka. Nadmorska visina Zagreba je upravo 128 m-
        % Moguce je uzeti i neku drugu referentnu rijec ili broj.
        
        % Iz ulazne datoteke ce se uzeti samo podaci koji su potrebni
        % (nadmorska visina u metrima, smjer vjetra, brzina vjetra 
        % u cvorovima), s time da se podaci iz sondaze uzimaju do 
        % maksimalne visine od 10km.
       

        
        
        %------------------------------------------------------------------
        red=0;
        while (provjera ~= 1)
            
            red=red+1;

            
            visina(red,set)=str2num(line(10:14));        %[m]
            smjer(red,set) =str2num(line(47:49));        %[°]
            brzina(red,set)=str2num(line(55:56))*0.514;  %[knt]-->[ms^-1]
            
            if (str2num(line(10:14))>=10000)
                provjera=1;
                break 
            end
            
            % Cita se do prve visine iznad 10 km.
            
            line=fgetl(id_ulaz);
        end % od while 2
        
        if (red>redmax)
            redmax=red;
        end
        %------------------------------------------------------------------
    end % od if 
    %----------------------------------------------------------------------
    
    
end % od while 1
%--------------------------------------------------------------------------

fclose(id_ulaz);

%**************************************************************************
% Uzimanje samo podataka iz termina u 00UTC ili 12UTC
%**************************************************************************

visina=visina(1:redmax,1:2:set);
smjer =smjer(1:redmax,1:2:set);
brzina=brzina(1:redmax,1:2:set);
disp('------> Uzimanje samo potrebnih sondaza')


%**************************************************************************
% Rastavljanje na komponente
%**************************************************************************
disp('------> Rastavljanje na komponente')   
for i=1:1:round(set/2);
    brzina_x(:,i)=-brzina(:,i).*sind(smjer(:,i)); 
    brzina_y(:,i)=-brzina(:,i).*cosd(smjer(:,i)); 
end

%**************************************************************************
% Interpolacija
%**************************************************************************
disp('------> Interpolacija brzine na nivoe 200m, 300m, ... 10 000m')   
% Zelimo dobiti podatke interpolirane na visine 200,300,400,...,10000 m. 
% Ukoliko radimo sa sondazama sa postaje koja je na nekoj drugoj 
% nadmorskoj visini, onda ce pocetni nivo biti prva visina od nadmorske
% visine djeljiva sa 100. Za Zagreb (128 m) je stoga prva visina 200 m.

brzina_x_lin=nan(99,round(set/2));
brzina_y_lin=nan(99,round(set/2));
            % komponente brzine na svakih 100 m
            
for i=1:round(set/2); % za svaku sondazu 
   
    a=0;      % pomocna varijabla koja ce oznacavati redoslijed podataka 
              % u novom interpoliranom nizu
              
    for j=1:redmax-1
        
        if (isnan(visina(j+1,i)==1))
            break
        end
        
        m=fix(visina(j+1,i)/100); 
        n=fix(visina(j,i)/100);
                
              % Prvo u podacima trazimo dva nivoa izmedju kojih ce se
              % interpolirati. 
              % Npr.(1) Ako je visina(j+1)=275 m, a visina(j)=128 m, trazit
              % cemo samo interpoliranu vrijednost na 200 m.
              % Npr.(2) Ako je visina(j+1)=375 m, a visina(j)=128 m, trazit
              % cemo interpoliranu vrijednost na 200 i 300 m.
              % Npr.(3) Ako je visina(j+1)=275 m, a visina(j)=210 m, necemo
              % traziti interpoliranu vrijednost
              % Npr.(4) Ako su visina(1)=180m, visina(2)=210m,
              % visina(3)=280m, visina(4)=315m, onda program interpolira na
              % slijedeci nacin: na 200 m interpoliramo pomocu 
              % visine(1) i visine (2), na 300 m interpoliramo pomocu 
              % visine(3) i visine (4). 
              % Npr. (5) Ako je visina(j+1)=10 650m, a visina(j)=850m, onda
              % interpoliramo samo na visine 900m i 10 000m
        
        koef_u	=(brzina_x(j+1,i)-brzina_x(j,i))/(visina(j+1,i)-visina(j,i));

		koef_v	=(brzina_y(j+1,i)-brzina_y(j,i))/(visina(j+1,i)-visina(j,i));     
              % koeficijenti nagiba izmedju dva susjedna nivoa
        
       
        for k=n+1:1:m       
          
            a=a+1;   
            if (a>99) 
                break
            end
               % Potrebne su nam samo vrijednosti do 10 000m.

			brzina_x_lin(a,i)	=koef_u*k*100-koef_u*visina(j,i)+brzina_x(j,i);
			brzina_y_lin(a,i)	=koef_v*k*100-koef_v*visina(j,i)+brzina_y(j,i);

        end % od k              
    end % od j    
end % od i

%**************************************************************************
% Usrednjavanje po svim sondazama
%**************************************************************************
disp('------> Usrednjavanje po svim sondazama') 
%sumiranje za svaku visinu posebno 


    sum_brzina_x_lin=sum(brzina_x_lin')/15;
    sum_brzina_y_lin=sum(brzina_y_lin')/15;


%usrednjen iznos brzine vjetra po svim sondazama, za svaku pojedinu visinu
brzina_sred=sqrt((sum_brzina_x_lin).^2+(sum_brzina_y_lin).^2);

%**************************************************************************
% Racunanje azimuta iz usrednjenih iznosa brzine
%**************************************************************************
disp('------> Racunanje azimuta') 
for i=1:99
    
    if ((sum_brzina_x_lin(i)>0)&(sum_brzina_y_lin(i)>0)) 

        %prva verzija
        %kt_sred(i)=atand(sum_brzina_y_lin(i)/sum_brzina_x_lin(i))+180;
        
        %19.lipanj.2007.
        kt_sred(i)=atand(sum_brzina_x_lin(i)/sum_brzina_y_lin(i))+180;
        
	elseif ((sum_brzina_x_lin(i)>0)&(sum_brzina_y_lin(i)<0)) 

        kt_sred(i)=atand(-sum_brzina_y_lin(i)/sum_brzina_x_lin(i))+270;
        
        %19.lipanj.2007.
        %OK

	elseif ((sum_brzina_x_lin(i)<0)&(sum_brzina_y_lin(i)>0)) 
        
        %prva verzija
        %kt_sred(i)=atand(-sum_brzina_x_lin(i)/sum_brzina_y_lin(i))+90;
        
        %19.lipanj.2007.
        kt_sred(i)=atand(sum_brzina_y_lin(i)/-sum_brzina_x_lin(i))+90;

	elseif ((sum_brzina_x_lin(i)<0)&(sum_brzina_y_lin(i)<0)) 

        kt_sred(i)=atand(-sum_brzina_x_lin(i)/-sum_brzina_y_lin(i));
        
        %19.lipanj.2007.
        %OK

	elseif ((sum_brzina_x_lin(i)>0)&(sum_brzina_y_lin(i)==0)) 

        kt_sred(i)=270;
        
        %19.lipanj.2007.
        %OK

	elseif ((sum_brzina_x_lin(i)<0)&(sum_brzina_y_lin(i)==0)) 

        kt_sred(i)=90;
        
        %19.lipanj.2007.
        %OK


	elseif ((sum_brzina_x_lin(i)==0)&(sum_brzina_y_lin(i)>0)) 

        kt_sred(i)=180;

	elseif ((sum_brzina_x_lin(i)==0)&(sum_brzina_y_lin(i)<0)) 

        kt_sred(i)=360;

    else

        kt_sred(i)=0

    end % od if
end % od i
%**************************************************************************
% Ispis i grafovi
%**************************************************************************
disp('')
disp('Visina[m] Azimut[°] Brzina[m s^{-1}]')
for i=1:99
    fprintf(['%7i \t', '%6.2f \t','%6.2f \n'],(i+1)*100 ,kt_sred(i), brzina_sred(i))
end

figure(1)
visina_lin=[200:100:10000];
title('Vertikalni profil vjetra')

subplot(1,2,1)
    plot(kt_sred,visina_lin)
    xlabel('Usrednjen azimut [°]','FontSize',12)
    ylabel('Visina [m]','FontSize',12)
    xlim([0 360])
    title('Vertikalni profil azimuta vjetra')

subplot(1,2,2)
    plot(brzina_sred,visina_lin)
    xlabel('Usrednjena brzina [m s^{-1}]','FontSize',12)
    ylabel('Visina [m]','FontSize',12)
    title('Vertikalni profil brzine vjetra')

%**************************************************************************
% 3D pogled
%**************************************************************************
% Oznacene su osi x i y, te je moguce provjeriti poklapanje podataka u 2D i
% 3D prikazu

x_crtaj=repmat(nan,1,3*99);
y_crtaj=repmat(nan,1,3*99);
z_crtaj=repmat(nan,1,3*99);

for i=1:99
    % priprema podataka za crtanje
    
    z_crtaj(3*(i-1)+1)=visina_lin(i);
    z_crtaj(3*(i-1)+2)=visina_lin(i);
    z_crtaj(3*(i-1)+3)=visina_lin(i);
    
    x_crtaj(3*(i-1)+1)=0;
    x_crtaj(3*(i-1)+2)=-sum_brzina_x_lin(i);
    x_crtaj(3*(i-1)+3)=NaN;
    
    y_crtaj(3*(i-1)+1)=0;
    y_crtaj(3*(i-1)+2)=-sum_brzina_y_lin(i);
    y_crtaj(3*(i-1)+3)=NaN;
end
    %Negativne vrijedosti komponente brzine su uzete kako bismo smjestili
    %liniju kojom oznavamo ukupan iznos brzine u pogodan kvadrant.
    
    %Duljina plave linije na 3D grafu je jednaka ukupnom iznosu usrednjene
    %brzine.

figure(2)
    plot3(x_crtaj,y_crtaj,z_crtaj)
    grid on
    axis square
    xlim([-10 10])
    ylim([-10 10])
    xlabel('-u_{srednje}','FontSize',12)
    ylabel('-v_{srednje}','FontSize',12)
    zlabel('Visina [m]','FontSize',12)