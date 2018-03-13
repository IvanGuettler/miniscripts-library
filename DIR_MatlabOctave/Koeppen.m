%>>>>>>>>>>>>>>>>>>>>>>> Zadtak 9. Köppenova klasifikacija klime. Ivan
%>>>>>>>>>>>>>>>>>>>>>>> Güttler

clear all
close all
clc

%>>>>>>>>>>>>>>>>>>>>>>> unos

load('ulaz.txt')

for i=0:4
    
    temp(:,i+1)=ulaz(:,2*i+1); %temperatura  za svih pet gradova
    obor(:,i+1)=ulaz(:,2*i+2); %oborina za svih pet gradova
    
end

    hemisfera=[1 1 1 0 1]; %1 oznaèava sjevernu hemisferu, a 0 južnu
            
%>>>>>>>>>>>>>>>>>>>>>> minimalna i maksimalna srednja mjeseèna
%>>>>>>>>>>>>>>>>>>>>>> temperatura,te srednja godišnja temperatura

for i=1:5
   
    t_info(1,i)=min(temp(:,i));
    t_info(2,i)=max(temp(:,i));
    t_info(3,i)=mean(temp(:,i));
    
end



%>>>>>>>>>>>>>>>>>>>>>> podjela godine u dva djela. Prvi dio su
%>>>>>>>>>>>>>>>>>>>>>> 4.,5.,6.,7.,8. i 9. mjesece, a drugi dio 
%>>>>>>>>>>>>>>>>>>>>>> su 1.,2.,3.,10.,11. i 12. mjesec

for i=1:5
   
    obor_prvi(:,i)=obor(4:9,i);
    obor_drug(:,i)=obor([1 2 3 10 11 12],i);
    
end

%>>>>>>>>>>>>>>>>>>>>>> na južnoj hemisferi vrijedi obrnuta podjela na
%>>>>>>>>>>>>>>>>>>>>>> topli i hladni dio godine (tj.prvi i drugi) 
%>>>>>>>>>>>>>>>>>>>>>> pa se radi zamjena
temp_prvi([1:6],1)=0;
temp_drug([1:6],1)=0;
for i=1:5
  
    if (hemisfera(i)==0)
        
        temp_prvi(:,1)=obor_prvi(:,i);
        temp_drug(:,1)=obor_drug(:,i);
        
        obor_prvi(:,i)=temp_drug(:,1);
        obor_drug(:,i)=temp_prvi(:,1);
        
    end    
    
    
    
end

%>>>>>>>>>>>>>>>>>>>>>> ukupno oborine u pojedinom djelu godine

for i=1:5
   
    ukupno_obor_prvi(i)=sum(obor_prvi(:,i));
    ukupno_obor_drug(i)=sum(obor_drug(:,i));
    ukupno_obor(i)     =sum(obor(:,i));
    
end


%>>>>>>>>>>>>>>>>>>>>>> brojanje mjeseci sa >18°C, <-3°C i >10°C
t_stat(1:3,1:5)=0;

for i=1:5
    
    for j=1:12
       
        if (temp(j,i)<18)
            
            t_stat(1,i)=t_stat(1,i)+1;
            
        end
            
        if (temp(j,i)<-3)
            
            t_stat(2,i)=t_stat(2,i)+1;
            
        end
            
        if (temp(j,i)>10)
            
            t_stat(3,i)=t_stat(3,i)+1;
            
        end
        
    end % od j
    
end % od i

%>>>>>>>>>>>>>>>>>>>>>> testiranje

prvo(1:5,1) ='/';
drugo(1:5,1)='/';
trece(1:5,1)='/';

ukupno_obor_prvi=ukupno_obor_prvi./10; % mm -> cm
ukupno_obor_drug=ukupno_obor_drug./10;
ukupno_obor     =ukupno_obor./10;

for i=1:5 

    korak_1=1;
    korak_2=1;
    korak_3=1;
    
        %>>>>>>>>>>>>>>>>>>>>>>>>> je li prvo slovo E?
        if (t_info(2,i)<10)
        
            prvo(i,1)='E';
            korak_1=0;
            
            %>>>>>>>>>>>>>>>>>>>>> odabir treceg slova
            %>>>>>>>>>>>>>>>>>>>>> koliko ima mjeseci temp ispod 0°C?
            
            if (korak_1==0)
                
            temp_E=0;
            for j=1:12
                
                if (temp(j,i)<0)
                    
                    temp_E=temp_E+1;
                    
                end
                
            
            end
             
            %>>>>>>>>>>>>>>>>>>>>>
            
            if (temp_E==0)
                
                trece(i,1)='F';
                
            else
                
                trece(i,1)='T';
                
            end %od odabira treceg slova za E
            
            end
            
        end %od testiranja na E
        
        %>>>>>>>>>>>>>>>>>>>>>>>>> je li prvo slovo B?
        if (korak_1==1)
        
            if (ukupno_obor_drug(i)>=0.7*ukupno_obor(i))
        
                prvo(i,1)='B';
            
                if ((ukupno_obor(i)>t_info(3,i))&(ukupno_obor(i)<2*t_info(3,i)))
                
                    drugo(i,1)='S';
                    korak_2=0;
                
                elseif (ukupno_obor(i)<t_info(3,i))
                
                    drugo(i,1)='W';
                    korak_2=0;
            
                end
        
        %>>>>>>>>>>>>>>>>>>>>>>> za topli dio godine
        
            elseif (ukupno_obor_prvi(i)>=0.7*ukupno_obor(i))
            
                prvo(i,1)='B';
               
                
                if ((ukupno_obor(i))>(t_info(3,i)+14))&((ukupno_obor(i)<2*(t_info(3,i)+14)))
                
                    drugo(i,1)='S';
                    korak_2=0;
                
                elseif (ukupno_obor(i)<(t_info(3,i)+14))
                
                    drugo(i,1)='W';
                    korak_2=0;
            
                end
        
        %>>>>>>>>>>>>>>>>>>>>>> niti topli niti hladni
        
            else
            
                prvo(i,1)='B';
                
  
                if ((ukupno_obor(i)>(t_info(3,i)+7))&(ukupno_obor(i)<2*(t_info(3,i)+7)))
                
                    drugo(i,1)='S';
                    korak_2=0;
                
                elseif (ukupno_obor(i)<(t_info(3,i)+7))
                
                    drugo(i,1)='W';
                    korak_2=0;
            
                end  
                 
            end %od testiranja B
            
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> odreðivanje treceg slova kod B
            if (prvo(i,1)=='B')
                
                if (mean(temp(:,i))>18)
            
                    trece(i,1)='h';
            
                elseif ((mean(temp(:,i))<18)&(max(temp(:,i))>18))
            
                    trece(i,1)='k';
        
                elseif ((mean(temp(:,i))<18)&(max(temp(:,i))<18))
            
                    trece(i,1)='K';
 
                end % odreðivanje treceg slova kod B
              
            end
        
        end %od korak_1
        
        
        if ((korak_1==1)&(korak_2==1))
            
            %>>>>>>>>>>>>>>>>>>>>>>>>> je li prvo slovo A?
            if (t_info(1,i)>18)
                
                prvo(i,1)='A';
                korak_3=0;
                
                %>>>>>>>>>>>>>>>>>>>>> provjera je li svaki mjesec ima
                %>>>>>>>>>>>>>>>>>>>>> minimalno 6 cm
                temp_1=0;
                for j=1:12
                    
                    if (obor(j,i)>6)
                        
                        temp=temp+1;
                    end
                    
                end
                
                %>>>>>>>>>>>>>>>>>>>> odreðivanje drugog slova uz A
                
                temp_2=250-25*min(obor(:,i));
                
                if (temp_1==12)
                    
                    drugo(i,1)='f';
                
                elseif (ukupno_obor(i)>temp_2)
                    
                    drugo(i,1)='m';
                    
                elseif (ukupno_obor(i)<temp_2)
                    
                drugo(i,1)='w';
                
                end %od drugog slova uz A
                
                %>>>>>>>>>>>>>>>>>>> odreðivanje treæeg slova uz A
     
            end
            
            if ((max(temp(:,i))-min(temp(:,i)))<5)
                    
               trece(i,1)='i';
                 
            end %od treceg slova uz A
            
        end %od testiranja A
        
        if ((korak_1==1)&(korak_2==1)&(korak_3==1))
            
            
            if ((t_stat(1,i)~=0)&(t_stat(2,i)==0)&(t_stat(3,i)~=0))
                
                prvo(i,1)='C';
                
            else ((t_stat(1,i)~=0)&(t_stat(2,i)~=0)&(t_stat(3,i)~=0))
                
                prvo(i,1)='D';
                
            end %od testiranja na C i D
            
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>> test za drugo slovo za C i D je
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>> jednak
            max_zima=max(obor_drug(:,i));
            min_zima=min(obor_drug(:,i));
            max_ljeto=max(obor_prvi(:,i));
            min_ljeto=min(obor_prvi(:,i));
            
            if ((min_ljeto<(max_zima/3))&(min_ljeto<4))
                
                drugo(i,1)='s';
            
            elseif ((min_zima<(max_ljeto/3))&(min_ljeto<4))
                
                drugo(i,1)='w';
            
            else
                
                drugo(i,1)='f';
                
            end %test drugog slova za C i D
            
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> test za trece slovo C i D
            
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> brojanje koliko mjeseci ima
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> temp veæu od 10°C
            temp_CD=0;
            for j=1:12
               
                if (temp(j,i)>10)
                    
                    temp_CD=temp_CD+1;
                    
                end    
                
            end
            
            %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
            
            if (max(temp(:,i))>22)
                
                trece(i,1)='a';
                
            elseif ((max(temp(:,i))<22)&(temp_CD>=4))
                
                trece(i,1)='b';
                
            else ((max(temp(:,i))<22)&(temp_CD<4))
                
                trece(i,1)='c';
                
            end
            
         %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> D ima jos jedan dodatni
         %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> simbol za trece slovo
         if ((prvo(i,1)=='D')&(min(temp(:,i))<-38))
                
                trece(i,1)='d';
            
        end 

        end %od korak_3
       
        
         
         
end %od petlje i=1:5

clc


%>>>>>>>>>>>>>>>>>>>>>>>>>>> ispis
gradovi(:,1)=prvo(:,1);
gradovi(:,2)=drugo(:,1);
gradovi(:,3)=trece(:,1);
   
disp('Köppenova klasifikacija klime za zadane gradove')
gradovi


