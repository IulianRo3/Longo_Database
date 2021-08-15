/*După ce am terminat de inserat toate datele in tabelele noastre, doresc să observ o oarecare ierarhie în firma(cine este șeful cui).
Pentru a realiza acest lucru voi crea un cursor explicit ce va executa un self-join între toți angajații din tabela AngajațiFirmă.
De asemenea pentru a fi mai ușor de observat vom selecta în plus, pe lângă nume și id_angajat cu id_functie.

After I have finished inserting all the data in our tables, I want to notice a certain hierarchy in the company (who is the boss).
To do this I will create an explicit cursor that will execute a self-join between all employees in the Company Employees table.
Also to make it easier to notice we will select in addition to name and employee_id with function_id. */


DECLARE
CURSOR c IS SELECT a.nume, m.nume,a.id_angajat,m.id_angajat,a.id_functie,m.id_functie
                FROM angajatifirma a,angajatifirma m
                        WHERE a.id_manager = m.id_angajat
                        ORDER BY a.id_functie desc;
v_nume1 varchar(30);
v_nume2 varchar(30);
v_id1 angajatifirma.id_angajat%type;
v_id2 angajatifirma.id_angajat%type;
v_idfunctie1 angajatifirma.id_functie%type;
v_idfunctie2 angajatifirma.id_functie%type;
BEGIN
OPEN c;
    LOOP
    FETCH c INTO v_nume1, v_nume2,v_id1,v_id2,v_idfunctie1,v_idfunctie2;
    EXIT WHEN c%notfound;
    DBMS_OUTPUT.PUT_LINE('Angajatul cu id-ul '|| v_id1 ||' ' ||v_nume1 ||' ,' || v_idfunctie1|| ' lucreaza pentru ' || v_nume2 ||' care are id-ul '|| v_id2 || ' si functia ' || v_idfunctie2 ||'.' );
    END LOOP;
    CLOSE c;
END;
/

/*Dorim să realizăm un bloc PL/SQL ce va afișa fiecare comandă în parte, în detaliu.
Pentru acest lucru vom accesa toate cele 4 tabele pe care le avem pentru a ne lua coloanele ce ne interesează.
De asemenea pentru rezolvarea acestei sarcini se va crea și un cursor explicit ce va conține select-ul cu datele necesare.

We want to make a PL/SQL block that will display each command separately,in detail.
For this we will access all the 4 tables we have to get the columns that interest us.
Also, to solve this task, an explicit cursor will be created that will contain the selection with the necessary data. */

DECLARE
CURSOR c IS SELECT cc.nr_comanda, cc.data_comanda,cc.incarcatura,cc.destinatia,  
            cf.nume || ' ' || cf.prenume, cf.firma,
            c.marca, c.modelc,
            a.nume || ' ' || a.prenume
FROM angajatifirma a, camioane c, clienti_firma cf, comenzi_clienti cc
WHERE cc.id_client = cf.id_client and
    cc.cod_camion = c.cod_camion and
    c.id_angajat = a.id_angajat
ORDER BY cc.data_comanda ASC;
    v_nrCom comenzi_clienti.nr_comanda%type;
    v_dataCom comenzi_clienti.data_comanda%type;
    v_incarcatura comenzi_clienti.incarcatura%type;
    v_destinatie comenzi_clienti.destinatia%type;
    v_numeCl varchar(100);
    v_firma clienti_firma.firma%type;
    v_marca camioane.marca%type;
    v_model camioane.modelc%type;
    v_numeS varchar(100);
    BEGIN
OPEN c;
    LOOP
     FETCH c INTO v_nrCom, v_dataCom, v_incarcatura, v_destinatie, v_numeCl, v_firma, v_marca, v_model, v_numeS;
    EXIT WHEN c%notfound;
    DBMS_OUTPUT.PUT_LINE('Comanda cu numarul ' || v_nrCom ||' va sosi in data de ' ||v_dataCom
    ||' incarcata cu: '|| LOWER(v_incarcatura)||' in orasul: '|| 
    v_destinatie||' pentru clientul cu numele: ' || v_numeCl||
    ' ce apartine de firma: '|| v_firma||'.Camionul '|| v_marca||', '|| v_model||' va fi condus de catre: '|| v_numeS || '.' );
    END LOOP;
   CLOSE c;
    END;
/

/* Firma a primit 2 comenzi noi.Pentru organizarea fluidă a lucrurilor comenzile primesc by default pe angajatul cu id. 1, camion cu id 1 
urmând ca în scurt să fie redirecționate camionului ce are codul 12 și angajatului cu id 8.Vom folosi cursori impliciți 
pentru a vedea daca update-ul nostru a avut succes urmând ca printr-un cursor explicit să afișăm valorile:

The company received 2 new orders. For the fluid organization of things, the orders receive by default the employee with id. 1, truck with id 1
will soon be redirected to the truck with code 12 and the employee with id 8. We will use default cursors
to see if our update was successful, we will display the values with an explicit cursor: */

BEGIN
INSERT INTO comenzi_clienti
VALUES(415,TO_DATE('06.APR.2021','DD/MM/YYYY'),'Mere',102,1,1,'Cluj');
INSERT INTO comenzi_clienti
VALUES(416,TO_DATE('25.APR.2020','DD/MM/YYYY'),'Materiale Constructie',106,1,1,'Tulcea');
Declare
v_nrCom comenzi_clienti.nr_comanda%type;
v_codCam camioane.cod_camion%type;
v_idAng angajatiFirma.id_angajat%type;
CURSOR c IS SELECT nr_comanda,id_angajat,cod_camion
from comenzi_clienti
where nr_comanda = 415 or nr_comanda = 416;
    BEGIN
        UPDATE comenzi_clienti
        SET cod_camion = 12 ,id_angajat = 8
        where nr_comanda > 414;
         IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('S-a produs o eroare inregistrarea comenzilor');
        ELSE
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' comenzi inregistrate.');
        END IF; 
    OPEN c;
    loop
    fetch c into v_nrCom, v_codCam, v_idAng;
    exit when c%notfound;
        DBMS_OUTPUT.PUT_LINE('Nr. comanda: ' || v_nrCom ||' are camionul cu, codul: ' || v_codCam || ' si angajatul cu id: ' || v_idAng);
        end loop;
    close c;
    END;
END;
/ 

/*Cu ocazia sărbatorilor care urmeaza patronul firmei Longo a hotărât ca fiecărui angajat să i se mărească salariul 
în funcție de vechimea pe care o are.Va trebui sa afișăm salariul inițial al angajaților, cel final și folosind o 
structură de control să apară dacă s-a realizat sau nu cum trebuie update-ul(folosind cursori impliciți): 

On the occasion of the following holidays, the owner of Longo decided to increase the salary of each employee.
depending on the seniority he has. We will have to display the initial salary of the employees, the final one and using a
control structure to appear whether or not the update was performed correctly (using default cursors):
*/

DECLARE
cursor c0 is select id_angajat, nume, salariu
from angajatifirma
order by id_angajat asc;
vid_angajat1 angajatifirma.id_angajat%type;
v_nume1 angajatifirma.nume%type;
v_sal1 angajatifirma.salariu%type;
begin
open c0;
loop
fetch c0 into vid_angajat1, v_nume1, v_sal1;
EXIT WHEN c0%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(vid_angajat1 || '.Angajatul cu numele: ' || v_nume1 || ' are la momentul 0 salariul de: ' ||v_sal1);
end loop;
DBMS_OUTPUT.PUT_LINE(chr(10));
close c0;
    DECLARE
        vid_angajat2 angajatifirma.id_angajat%type;
        v_nume2 angajatifirma.nume%type;
        v_sal2 angajatifirma.salariu%type;
    BEGIN
        UPDATE angajatifirma 
        SET salariu =  CASE  
                        WHEN ((SYSDATE-data_angajare)/365) > 9 THEN salariu * 1.2 
                        WHEN ((SYSDATE-data_angajare)/365)  BETWEEN 6 AND 9 THEN  salariu * 1.1 
                        WHEN ((SYSDATE-data_angajare)/365)  BETWEEN 3 AND 5 THEN salariu * 1.05 
                        ELSE salariu * 1.01 
                    END;
        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu s-au modificat salariile!');
        ELSE
            DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' salarii modificate.' || chr(10));
        END IF;
        OPEN c0;
        loop
        fetch c0 into vid_angajat2, v_nume2 ,v_sal2;
EXIT WHEN c0%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vid_angajat2 || '.Angajatul cu numele: ' || v_nume2 ||  ' are la momentul 1 salariul de: ' ||v_sal2);
        end loop;
        close c0;
EXCEPTION
        WHEN    invalid_cursor THEN DBMS_OUTPUT.PUT_LINE('Ai realizat o operatie ilegala asupra cursorului!');
        WHEN cursor_already_open THEN DBMS_OUTPUT.PUT_LINE('Ai deja cursorul deschis!');
    END;
END;

/*Dorim să realizăm un bloc pl/sql ce ne va folosi ca pe un filtru pentru a găsi clienții firmei după 2 criterii de căutare: 
id-ul clientului sau firma de apartenență.Desigur, în timpul executării pot apărea diverse probleme ce vor fi “prinse” de către 
excepțiile implicite folosite și anume: no_data_found când nici id-ul nici numele nu sunt scrise corect, too_many_rows când id-ul 
introdus este corect, numele este corect dar cele două nu corespund una cu cealaltă și others pentru o eroare necunoscută.

We want to make a pl / sql block that will use us as a filter to find the company's customers according to 2 search criteria:
Of course, during the execution, various problems can occur that will be "caught" by the client.
the default exceptions used, namely: no_data_found when neither id nor name is spelled correctly, too_many_rows when id
entered is correct, the name is correct but the two do not correspond to each other and others for an unknown error. */

DECLARE
v_idClient clienti_firma.id_client%type;
v_Firma clienti_firma.firma%type;
v_nume varchar(100);
BEGIN
SELECT id_client, firma, nume || ' ' || prenume
INTO v_idClient, v_Firma, v_nume
FROM clienti_firma
WHERE id_client = :id OR LOWER(firma) = lower(:firma);
dbms_output.put_line('Clientul are id-ul: ' || v_idClient || ' de la firma: ' || v_Firma || ' cu numele: ' || v_nume);
EXCEPTION
WHEN no_data_found THEN dbms_output.put_line('Nu s-a gasit niciun client cu id-ul sau numele firmei folosit');
WHEN too_many_rows then dbms_output.put_line('Eroare - Posbil ai adaugat un id existent ce face parte dintr-o firma existenta dar
diferita de a lui.Poti incerca un cursor pentru mai multe randuri.');
WHEN OTHERS THEN dbms_output.put_line('Eroare necunoscuta');
END;
/

/*Dorim sa configurăm un script ce previzualizeaza comenzile clienților în funcție de destinația aleasă.Probleme ce pot exista:
Orașul scris apare de mai multe ori -> va intra in too_many_rows->se va crea un cursor
Orașul scris nu există în baza de data -> va intra în no_data_found
Cu această ocazie putem descoperi orasele in care avem mai multe comenzi.

We want to configure a script that previews customer orders depending on the chosen destination. Problems that may exist:
The written city appears several times -> will enter too_many_rows-> create a cursor
The written city does not exist in the database -> it will go into no_data_found
On this occasion we can discover the cities where we have more orders. */

DECLARE
v_nrComanda comenzi_clienti.nr_comanda%type;
v_codCam comenzi_clienti.cod_camion%type;
v_marca camioane.marca%type;
v_incarcatura comenzi_clienti.incarcatura%type;
v_destinatie varchar(30) := lower(:destinatie);
CURSOR c IS SELECT nr_comanda, a.cod_camion, marca, incarcatura
from comenzi_clienti a, camioane b
where lower(destinatia) = v_destinatie
and a.cod_camion = b.cod_camion;
BEGIN
select nr_comanda, a.cod_camion, marca, incarcatura into v_nrComanda,v_codCam, v_marca, v_incarcatura
from comenzi_clienti a, camioane b
where lower(destinatia) = v_destinatie
and a.cod_camion = b.cod_camion;
dbms_output.put_line('Numarul comenzii: ' || v_nrComanda || ' preluat de camionul ce are codul: ' 
|| v_codCam || ' cu marca: ' || v_marca || ' si incarcatura: ' || v_incarcatura);
EXCEPTION
WHEN too_many_rows then 
dbms_output.put_line('S-a intrat in EXCEPTIA DE TOO_MANY_ROW, prin urmare pentru a nu exista probleme s-a creat un cursor pentru afisarea datelor necesare!');
OPEN c;
LOOP
FETCH c INTO v_nrComanda, v_codCam, v_marca, v_incarcatura;
EXIT WHEN c%notfound;
dbms_output.put_line('Numarul comenzii: ' || v_nrComanda || ' preluat de camionul ce are codul: ' 
|| v_codCam || ' cu marca: ' || v_marca || ' si incarcatura: ' || v_incarcatura);
END LOOP;
CLOSE c;
WHEN NO_DATA_FOUND THEN dbms_output.put_line('Nu exista acel oras sau nu l-ai scris corect. Mai incearca');
WHEN OTHERS THEN dbms_output.put_line('Ti-a intrat in exceptia others');  END;/


/* Următorul bloc pl/sql ne va ajuta să updatăm comanda unui client.Pentru a realiza acest lucru 
vom avea nevoie de o incarcatura noua, id-ul clientului si nr_comenzii.
Am creat o excepție numită: Update_Err care se va activa în momentul în care update-ul eșuează.

The next block pl / sql will help us to update a customer's order. To do this
we will need a new load, customer id and order number.
We created an exception called: Update_Err which will be activated when the update fails. */

DECLARE
Update_Err EXCEPTION;
vIncarcatura_Noua varchar(40) := :Incarcatura_Noua
vId_Client number := :Id_Client
vNr_comanda number := :nr_comanda;
BEGIN
UPDATE comenzi_clienti
set incarcatura = vIncarcatura_Noua
where id_client = vId_Client and
nr_comanda = vNr_comanda;
IF SQL%NOTFOUND THEN
RAISE Update_Err;
ELSE
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' incarcaturi schimbate');
DBMS_OUTPUT.PUT_LINE('Incarcatura noua: '|| vIncarcatura_Noua || ' pentru comanda cu numarul: ' || vNr_comanda || ' pentru clientul cu id: ' ||vId_Client);
end if;
EXCEPTION
when Update_Err then dbms_output.put_line('Update-ul nu a reusit, va rugam sa reincercati'); 
end;
/

/*O dată pe an se verifică kilometrajul camioanelor pentru a se vedea dacă trebuie duse sau nu la revizie tehnică.Dacă camionul a trecut de 300.000 km,
 acesta va fi dus.În caz contrar mai poate rămâne.
Vom căuta camionul dupa id-ul său.
Dacă inserăm un id ce nu există atunci se va activa excepția  wrong_id creată de noi.
Creăm o excepție numită revizie care dacă se activează, atunci vom ști că, camionul a trecut de 300.000km și trebuie dus la revizie.
Nu, nu am idee la cât timp se fac reviziile la camioane. Numerele sunt aleatorii.

Once a year, the mileage of the trucks is checked to see if they need to be taken for technical inspection or not. If the truck has 
exceeded 300,000 km, it will be taken away. Otherwise it may remain.
We'll look for the truck by its id.
If we insert an id that does not exist then the wrong_id exception created by us will be activated.
We create an exception called overhaul which if activated, then we will know that the truck has passed 300,000km and must be overhauled. 
No, I have no idea how long truck overhauls are done. The numbers are random.*/

DECLARE
revizie EXCEPTION;
wrong_id EXCEPTION;  
PRAGMA EXCEPTION_INIT (wrong_id , 100); 
v_km camioane.kilometraj%type;
v_marca camioane.marca%type;
v_model camioane.modelc%type;
v_an camioane.an%type;
BEGIN
select marca, modelc, kilometraj, an
into v_marca, v_model,v_km, v_an
from camioane
where cod_camion = :cod;
if v_km > 300000 then
    RAISE revizie;
else
    dbms_output.put_line('Camionul '|| v_marca ||' ' || v_model ||
    'din anul: ' || v_an|| ' poate sa mai stea deoarece are: ' || v_km);
end if;
EXCEPTION
when revizie then dbms_output.put_line('Kilometrajul camionului '|| v_marca
|| ' cu modelul ' || v_model|| ' a trecut de 300.000('||v_km|| ') si trebuie dus la o revizie');
when wrong_id  then dbms_output.put_line('Ai introdus un id gresit');
end;
/

/*Dorim să vedem dacă salariul angajaților se corelează sau nu cu vechimea acestora, de asemenea să observăm și marginile superioare/inferioare 
ale vectorului de salarii ale angajaților cât și mijlocul acestuia.Pentru acest lucru ne vom crea procedura statistica_salarii:

We want to see if the employees' salary correlates or not with their seniority, also to observe the upper / lower margins
of the employees' salary vector as well as its middle. For this we will create the statistical procedure_salaries: */

CREATE OR REPLACE PROCEDURE Statistica_salarii
(f_pearson out number, f_min out number , f_max out number, f_med out number)
IS
BEGIN
 select ROUND(((SUM(salariu * ((SYSDATE - data_angajare)/365))
        -(SUM(salariu) * SUM((SYSDATE - data_angajare)/365)) / COUNT(*)
    )
)/
(SQRT(SUM(salariu * salariu)
-(SUM(salariu) * SUM(salariu))/COUNT(*)
 )  *SQRT(SUM((SYSDATE - data_angajare)/365 * (SYSDATE - data_angajare)/365)
 -(SUM((SYSDATE - data_angajare)/365) 
 * SUM(((SYSDATE - data_angajare)/365)))/ COUNT(*)) ),2) into f_pearson
    from angajatifirma;
SELECT ROUND(MIN(salariu)),ROUND(AVG(salariu)),ROUND(MAX(salariu))
into f_min, f_med, f_max
from angajatifirma;
If f_pearson > 0.7 THEN
DBMS_OUTPUT.PUT_LINE('Coeficientul Pearson este mai mare de 0.7: ' || f_pearson || ' deci, putem spune  ca salariile se coreleaza puternic si pozitiv cu vechimea angajatilor, ');
DBMS_OUTPUT.PUT_LINE('prin urmare cu cat ai mai multa vechime in firma cu atat vei castiga mai mult.');
DBMS_OUTPUT.PUT_LINE('De asemenea rangeul salariilor este de la: ' || f_min ||' cel mai mic la: ' || f_max || ' cel mai mare, angajatul "averege" avand salariul aproximativ de' || f_med);
ElsIf f_pearson BETWEEN 0.7 AND 0.4 THEN
DBMS_OUTPUT.PUT_LINE('Coeficientul Pearson este mai curins intre 0.7 si 0.4: ' || f_pearson || ' prin urmare putem spune ca salariile se coreleaza relativ bine si pozitiv cu vechimea angajatilor, ');
DBMS_OUTPUT.PUT_LINE('prin urmare, putem spune cu cat esti mai vechi in firma cu atat vei castiga mai mult.');
DBMS_OUTPUT.PUT_LINE('De asemenea rangeul salariilor este de la: ' || f_min ||' cel mai mic la: ' || f_max || ' cel mai mare, angajatul "averege" avand salariul aproximativ de' || f_med);
ElsIf f_pearson BETWEEN 0.3 and 0 THEN
DBMS_OUTPUT.PUT_LINE('Coeficientul Pearson este mai curins intre 0.3 si 0: ' || f_pearson || ' prin urmare putem spune ca salariile se coreleaza foarte putin sau aproape deloc cu vechimea angajatilor, ');
ELSE 
DBMS_OUTPUT.PUT_LINE('Coeficientul Pearson este cu "-" ce inseamna ca cele doua variabile sunt invers corelate ceea ce inseamna ca daca angajatul e nou atunci salariul creste.');
END IF;
END;

/* Următoarea procedură info_angajat ne va afișa diverse informații despre un angajat anume(luat dupa id), precum vechima, salariul, camionul, etc:
The following procedure info_angajat will show us various information about a specific employee (taken by id), such as seniority, salary, truck, etc: */

CREATE OR REPLACE PROCEDURE info_angajat
(p_id_angajat IN angajatifirma.id_angajat%type,
p_nume OUT angajatifirma.nume%type,
p_salariul OUT angajatifirma.salariu%type,
p_incarcatura OUT number,
p_marca OUT camioane.marca%type,
p_vechime OUT number,
p_sef out varchar)
IS
BEGIN
Select nume, salariu, count(nr_comanda) , marca, vechime_angajat(p_id_angajat),ierarhie(p_id_angajat)
into p_nume, p_salariul, p_incarcatura, p_marca, p_vechime, p_sef
from angajatifirma a , comenzi_clienti cc , camioane c
where a.id_angajat=p_id_angajat and 
cc.id_angajat = a.id_angajat and 
c.cod_camion = cc.cod_camion
group by nume,salariu,marca,ROUND((SYSDATE - data_angajare)/365);
DBMS_OUTPUT.PUT_LINE(' Angajatul '||p_nume||' cu vechimea de '||p_vechime ||' ani, are salariul de: '
||p_salariul||' se afla sub conducerea lui: '||p_sef || ' si are ' || p_incarcatura||' comenzi si conduce un camion de marca: ' || p_marca);
EXCEPTION
when no_data_found then DBMS_OUTPUT.PUT_LINE('Id-ul angajatului ales nu exista sau nu are comenzi.Va rugam sa alegeti alt Id intre 1 si 11.');
END;

/*Pentru vechimea angajatului din procedura de mai sus am creat funcția vechime_angajat ce ne returnează un number ce reprezintă vechimea sa in ani.
For the seniority of the employee in the above procedure, we created the function seniority_employee that returns a number that represents his seniority in years. */

create or replace function vechime_angajat(m_idAng number) return number
is
vechime_angajat number;
begin
select ROUND((sysdate-data_angajare)/365) into vechime_angajat
from angajatifirma where id_angajat = m_idAng;
return vechime_angajat;    
exception
when no_data_found then
return -1;
end;
/


/* Pentru a cunoaște șeful angajatului(variabila p_sef din procedura info_angajati) am creat funcția 
ierarhie care va returna numele managerului angajatului al cărui id este dat
In order to know the boss of the employee (variable p_sef from the procedure info_engajati) we created the function
hierarchy that will return the name of the employee manager whose id is given*/

CREATE OR REPLACE Function ierarhie
(v_id in angajatifirma.id_angajat%type) return varchar2
IS
v_id1 angajatifirma.id_angajat%type;
v_id2 angajatifirma.id_angajat%type;
v_nume2 angajatifirma.nume%type;
BEGIN
select  m.nume,a.id_angajat,m.id_angajat
into    v_nume2,v_id1,v_id2
                from angajatifirma a,angajatifirma m
                        where a.id_manager = m.id_angajat
                        and a.id_angajat = v_id
                        order by a.id_functie desc;
return v_nume2;
EXCEPTION
WHEN no_data_found then DBMS_OUTPUT.PUT_LINE('Va rog sa alegeti un numar intre 1 si 12! Multumesc!');
END;


/* Punerea în practică a procedurilor și funcțiilor create:
Implementation of the procedures and functions created: */

DECLARE
v_nume angajati.nume%type; 
v_salariul angajati.salariul%type;
v_incarcatura number;
v_marca varchar(30);
v_vechime number;
v_sef varchar(30);
v_min number;
v_med number;
v_max number;
v_Pearson number;
v_id number;
BEGIN
DBMS_OUTPUT.PUT_LINE('Statistica salarii: ');
Statistica_salarii(v_Pearson,v_min,v_max,v_med);
DBMS_OUTPUT.PUT_LINE('Informatii angajati: ');
info_angajat(11,v_nume,v_salariul,v_incarcatura,v_marca,v_vechime,v_sef);
info_angajat(7,v_nume,v_salariul,v_incarcatura,v_marca,v_vechime,v_sef);
info_angajat(5,v_nume,v_salariul,v_incarcatura,v_marca,v_vechime,v_sef);
END;

/*În continuare vom crea o procedura ce va afișa informații despre clienții firmei cu un adaos și anume dacă aceștea au sau nu
mai multe comenzi date decât media(vom realiza acest lucru cu ajutorul unei funcții).
Primul pas: crearea unei proceduri ce calculeaza media comenzilor
 
Next we will create a procedure that will display information about the company's customers with an addition, namely whether they have or not
more commands given than average (we will do this with a function).
The first step: creating a procedure that calculates the average of the orders*/

Create or replace PROCEDURE comanda_medie
(v_comM out number)
IS
Begin
select Round(AVG(count(nr_comanda)),1)
into v_comM
from comenzi_clienti
group by id_client;
end;

/* După crearea procedurii comanda_medie urmează crearea funcției comenzi_comparare ce va returna un bool(în funcție dacă numărul dat este sau nu mai mare decât media)
After creating the average_command procedure, the creation of the compare_command function will be returned, 
which will return a bool (depending on whether or not the given number is greater than the average) */

CREATE OR REPLACE FUNCTION comenzi_comparare 
(p_id_client IN comenzi_clienti.id_client%type, p_ComMedie IN number)
RETURN Boolean 
IS
v_comenzi number(4);
v_idCl number(3);
BEGIN
SELECT count(nr_comanda), id_client 
into v_comenzi, v_idCl 
from comenzi_clienti 
where id_client=p_id_client
group by id_client;
IF v_comenzi > p_ComMedie then
return true;
ELSE
return false;
end if;
EXCEPTION
WHEN no_data_found THEN
return NULL;
end;
/

/* În final realizăm procedura info_clienti:
Finally we perform the client_info procedure:*/
CREATE OR REPLACE PROCEDURE info_clienti
(p_idClient in number,
p_id out number,
p_numeCl out varchar,
p_tlf out number,
p_firma out varchar,
p_sex out varchar,
p_nrCom out number
)IS
v_comMedie number;
BEGIN
comanda_medie(v_comMedie);
select c.id_client,nume ||' ' || prenume,telefon,firma,sex,count(nr_comanda)
into p_id, p_numeCl, p_tlf,p_firma,p_sex,p_nrCom
from comenzi_clienti c, clienti_firma cf
where c.id_client = cf.id_client and
c.id_client = p_idClient
group by c.id_client,nume ||' ' || prenume,telefon,firma,sex;

IF(comenzi_comparare(p_idClient,v_comMedie)IS NULL)then
dbms_output.put_line('Client cu id invalid! Va rugam reincercati!');
elsif (comenzi_comparare(p_idClient,v_comMedie)) then
dbms_output.put_line('Clientul are mai multe comenzi decat media!');
dbms_output.put_line('Datele clientului:');
dbms_output.put_line(p_id || ' Clientul cu numele: ' ||p_numeCl ||' telefonul: '||p_tlf || ' ce provine de la firma: ' || p_firma );
dbms_output.put_line(' cu genderul: ' || p_sex || ' are: ' || p_nrCom || ' comenzi.');
else
dbms_output.put_line('Clientul are mai putine comenzi decat media!');
dbms_output.put_line('Datele clientului:');
dbms_output.put_line(p_id || ' Clientul cu numele: ' ||p_numeCl ||' telefonul: '||p_tlf || ' ce provine de la firma: ' || p_firma );
dbms_output.put_line(' cu genderul: ' || p_sex || ' are: ' || p_nrCom || ' comenzi.');
end if;
END;

/* Utilizarea în practică a procedurii(cu funcția) create
The implementation of the procedure (with the function) created*/
10.	Utilizarea în practică a procedurii(cu funcția) create:
DECLARE
v_id  number;
v_numeCl  varchar(30);
v_tlf  number;
v_firma  varchar(30);
v_sex  varchar(30);
v_nrCom  number;
BEGIN
info_clienti(101,v_id,v_numeCl,v_tlf,v_firma,v_sex,v_nrCom);
info_clienti(107,v_id,v_numeCl,v_tlf,v_firma,v_sex,v_nrCom);
info_clienti(105,v_id,v_numeCl,v_tlf,v_firma,v_sex,v_nrCom);
end;
/

