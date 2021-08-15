/* Unii angajati si-au scris gresit EMAIL-ul astfel va trebui sa facem cateva UPDATE-uri in baza de date pentru a le modifica 
Some employees have mistyped their EMAIL so we will have to do some UPDATE in the database to change*/

Update AngajatiFirma                             
set EMAIL = 'TRAL'              
where id_angajat = 5;                                  

Update AngajatiFirma
set EMAIL = 'MAST'
where id_angajat = 2;

/*Vom mai folosii UPDATE-ul pentru marirea salariului angajatilor care-l au mai mic de 3000 de euro cu 500 si scaderea celor care-l au mai mare de 10000 
We will also use the UPDATE to increase the salary of employees who have less than 3,000 euros by 500 and decrease those who have more than 10,000*/

Update AngajatiFirma                                                 
set Salariu = Salariu + 500                                             
where Salariu < 3000;                                                    
 
Update AngajatiFirma
set Salariu = Salariu - 500
where Salariu > 10000;

/*Vom sterge comenzile din 2018 deoarece nu mai sunt de folos 
We will delete the orders from 2018 because they are no longer useful*/

delete from Comenzi_Clienti                             
where Data_Comanda < '01.JAN.2019'; 

/*Vom fi nevoiti sa dam afara un angajat si in acelasi timp dupa concedierea acestuia sa vindem camionul respectiv 
We will have to fire an employee and at the same time after his dismissal we will sell the respective truck*/

delete from Camioane
where cod_camion = 1; 

delete from AngajatiFirma                                  
where id_angajat = 1;

/*Am sters din greseala camionul incorect 
I accidentally deleted the wrong truck*/

delete from Camioane where cod_camion = 3;

/*Si am folosit comanda “rollback” pentru a-l “readuce”
And I used the "rollback" command to "bring it back": */

rollback; 

/*Am sters tabela Comenzi_Clienti incurcand-o cu o tabela cu nume asemanator.Am reusit sa o readuc inapoi prin comanda flashback
I deleted the Clients_Commands table by confusing it with a table with a similar name. I managed to bring it back with the flashback command */

FLASHBACK TABLE comenzi_clienti           
TO BEFORE DROP;

insert into comenzi_clienti
values(415,TO_DATE('02.APR.2020','DD/MM/YYYY'),'Mere',102,4,4,'Cluj');
insert into comenzi_clienti
values(416,TO_DATE('25.APR.2020','DD/MM/YYYY'),'Materiale Constructie',106,5,5,'Tulcea');
insert into comenzi_clienti
values(417,TO_DATE('01.MAY.2020','DD/MM/YYYY'),'Tractor',101,10,10,'Suceava');

/* Exemple de interogari variate(SELECT) 
Examples of miscellaneous queries (SELECT)

Inner Join*/

select nr_comanda,incarcatura,a.id_client,nume
from clienti_firma a inner join comenzi_clienti b
on a.id_client = b.id_client
order by id_client ASC;

/* Right Join*/

select cod_camion,a.id_angajat,Nume
from angajatifirma a right join camioane b
on a.id_angajat = b.id_angajat;

/* Left Join */

select cod_camion,a.id_angajat,Nume
from angajatifirma a left join camioane b
on a.id_angajat = b.id_angajat;

/* Full Outer Join */

select cod_camion,a.id_angajat,Nume
from angajatifirma a full outer join camioane b
on a.id_angajat = b.id_angajat;                                                                                                      

/* Self Join */

select a.nume || ' lucreaza pentru ' || m.nume Cine_lucreaza_pentru_cine
from angajatifirma a,angajatifirma m
where a.id_manager = m.id_angajat
order by a.nume;

/* Functii de grup 
Group Functions

 MAX */
 
select MAX(salariu) Cel_mai_mare_salariu,Nume,Prenume,data_angajare
from angajatifirma
where data_angajare > '01.jan.2015'
group by(Nume,Prenume,data_angajare)
order by data_angajare asc;

/* MIN */

select MIN(data_angajare)Prima_Angajare,MAX(salariu) Cel_mai_mare_salariu,
MAX(data_angajare)Ultima_Angajare,MIN(salariu) Cel_mai_mic_salariu,COUNT(salariu)
from angajati_firma
where id_angajat < 11;

/* CASE */

select id_angajat,nume,prenume,salariu,salariu+(CASE id_angajat
when 4 then 500
ELSE 0
END) majorare_salariu
from angajatifirma;

select id_angajat,nume,prenume,salariu,case
when salariu > 10000 then 'salariu f mare'
when salariu > 9000 then 'salariu mare'
when salariu between 5000 and 7000 then 'salariu mediu'
when salariu between 3500 and 4999 then 'salariu grad 1'
else 'salariu grad 0'
end Categorizare_Salarii
from angajatifirma
order by salariu asc;

/* DECODE */

select id_angajat,nume,prenume,salariu+(decode(id_angajat,4,500))majorare_salariu
from angajatifirma;

/* FUNCTII PREDEFINITE */

select id_angajat,nume,prenume,lower(substr(nume,1,2) || substr(prenume,1,2) || substr(id_functie,1,2) ||'@yahoo.ro' )Mail_Firma,
upper(substr(prenume,1,2)) || lower(substr(nume,1,3)) Parola
from angajatifirma;

select id_angajat,nume,prenume,level,id_manager,connect_by_root(nume)
from angajatifirma
connect by prior id_angajat= id_manager
order by id_angajat ASC;

select nr_comanda,incarcatura,id_client,add_months(data_comanda,1)
from comenzi_clienti
where nr_comanda = 403;

/* CERERI IERARHICE
HIERARCHICAL REQUESTS */

select id_angajat,nume,prenume,level,id_manager,connect_by_root(nume)
from angajatifirma
connect by prior id_angajat= id_manager
order by id_angajat ASC;

select id_angajat,nume,prenume,level,id_manager,connect_by_root(nume)
from angajatifirma
connect by  id_angajat=prior id_manager
order by id_angajat ASC;

/* CERERI IMBRICATE(SUBCERERI)
NESTED QUERIES (SUBQUERY) */

SELECT * 
FROM angajatifirma 
WHERE id_angajat IN (SELECT id_angajat 
FROM angajati_firma
WHERE salariu > 5000) ;

SELECT * 
FROM camioane 
WHERE kilometraj IN (SELECT kilometraj 
FROM camioane
WHERE kilometraj >432102 ) ;

/* SINONIME
SYNONYMY */

create synonym AF                                                                                                       
for angajati_firma;

create synonym CF
for Clienti_firma;

create synonym CC
for comenzi_clienti;

drop synonym AF/CC/CF.

/* TABELE VIRTUALE
VIRTUAL TABLES */

create view ang as select * from AF
where id_angajat <11;

update ang
set salariu = 3000
where salariu < 3000;

select *
from ang
where salariu > 4000;

drop view ang;
