/*Crearea tabelelor necesare și inserarea lor cu date 
Creating the necessary tables and inserting them with data */

/* Company employees 
Id, Surname, Name, Email, Salary, Manager_ID, Date of employment */
create table AngajatiFirma
(Id_Angajat number(3) constraint AF_ID_PK Primary Key,Nume varchar2(25) constraint AF_NUM_NN Not Null,
Prenume varchar2(25) constraint AF_PRE_NN Not Null,Email varchar2(20),Id_Functie varchar2(10) constraint AF_FCT_NN Not Null,
Salariu number(6) constraint AF_SAL_NN Not Null,Id_Manager number(3) ,Data_Angajare date constraint AF_DA_NN Not Null); 

Insert Into ANGAJATIFIRMA 
values(1,'Peter','Roller','PROLL','SOFER',1500, 11,TO_DATE('06.apr.2017','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(2,'Marcel','Stefan','MSTEFF','SOFER',1000,11,TO_DATE('02.mar.2018','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(3,'Pavel','Marian','PAVI','SOFER',6000,11,TO_DATE('30.nov.2012','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(4,'David','Andrei','DAAN','SOFER',3500,11,TO_DATE('19.jan.2015','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(5,'Trestie','Alexandru','TALE','SOFER',2500,11,TO_DATE('20.oct.2016','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(6,'Valentin','Stefan','VAST','SOFER',1000,12,TO_DATE('04.jul.2019','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(7,'Bulgaru','Vasile','BVAS','SOFER',5000,12,TO_DATE('04.apr.2014','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(8,'Petru','Marian','PMAR','SOFER',2000,12,TO_DATE('22.aug.2018','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(9,'Ungureanu','Leonard','ULEO','SOFER',4000,12,TO_DATE('29.dec.2015','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(10,'Sande','Andrei','SAAN','SOFER',3000,12,TO_DATE('30.apr.2016','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(11,'Voiculescu','Teodor','VOTE','MAN',9300,13,TO_DATE('14.nov.2011','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(12,'Marian','Gabriel','MGAB','MAN',12000,13,TO_DATE('18.may.2010','DD/MM/YYYY'));

Insert Into AngajatiFirma
values(13,'Rusu','Bogdan','RBOG','PRES',17500,NULL,TO_DATE('20.apr.2010','DD/MM/YYYY'));

select * from angajatifirma
order by Id_Angajat asc;

/* Trucks 
Truck_ID, Brand, Truck Model, Total kg allowed, HorsePower, Tachometer, Year of Fabrication, Employee ID*/
create table Camioane
(Cod_Camion number(5) constraint cam_cod_pk Primary Key,Marca varchar2(25) constraint cam_mar_NN Not Null,
ModelC varchar2(25) constraint cam_mod_nn Not Null,MasaTotAdmisa_Tone number(3) constraint cam_MTA_NN Not Null,
Putere_CP number(3) constraint cam_CP_NN Not Null,Kilometraj number(7) constraint cam_KM_NN Not Null,An number(4) constraint cam_AN_NN Not Null,
Id_Angajat number(3) constraint cam_ang_fk References AngajatiFirma(Id_Angajat) );

Insert Into Camioane
values(1,'Mercedes','1827LL',18,272,290401,2016,1);

Insert Into Camioane
values(2,'Mercedes','1830LL',18,299,220431,2017,2);

Insert Into Camioane
values(3,'Mercedes','1835LL',18,354,218401,2017,3);

Insert Into Camioane
values(4,'Mercedes','NGT1830LL',18,271,187010,2018,4);

Insert Into Camioane
values(5,'Volvo','FH500',20,500,523600,2015,5);

Insert Into Camioane
values(6,'Volvo','FH500XL',20,500,323600,2017,6);

Insert Into Camioane
values(7,'Volvo','FH460',18,460,353200,2017,7);

Insert Into Camioane
values(8,'Man','TGS35000',35,400,239690,2013,6);

Insert Into Camioane
values(9,'Scania','R124',17,470,851271,2017,9);

Insert Into Camioane
values(10,'Scania','SERIA S',20,370,189432,2017,10);

Insert Into Camioane
values(11,'Scania','R450',17,450,209635,2016,11);

insert into camioane(cod_camion,marca,modelc,masatotadmisa_tone,putere_cp,kilometraj,an)
values(12,'Man','MAN TGS 40.400',25,400,21002,2018);

select * from camioane
order by cod_camion asc;


/* Customers 
Customer_Id, Surname, Name, Number Phone, Company*/
create table Clienti_Firma
(Id_Client number(4) constraint CF_ID_PK Primary Key,Nume varchar(25),Prenume varchar(25),Telefon number(10) constraint 
CF_TF_NN Not Null,Firma varchar2(25) constraint CF_FM_NN Not Null,Sex varchar2(1) );

Insert Into Clienti_Firma
values(103,'Craiu','Alexandra',0322248199,'ITCC','F');

Insert Into Clienti_Firma
values(101,'Constantin','Petru',0742111812,'Trameri','M');

Insert Into Clienti_Firma
values(102,'Petrescu','Gabriela',0322248199,'eAcres','F');

Insert Into Clienti_Firma
values(104,'Marcel','Ioan',0421197140,'Trade_Aux','M');

Insert Into Clienti_Firma
values(105,'Vlad','Ioan',0233348912,'San Builders','M');

Insert Into Clienti_Firma
values(106,'Vrincu','Valentin',0721122491,'Ro Build','M');

Insert Into Clienti_Firma
values(107,'Rosu','Roxana',0244489211,'LKW','F');

Insert Into Clienti_Firma
values(108,'Nelu','Bogdan',0732953999,'NBFC','M');

Insert Into Clienti_Firma
values(109,'Pavel','Valentin',0412371290,'SELL PLAN','M');

Insert Into Clienti_Firma
values(110,'Gabriel','Stefan',0233594210,'FCP','M');


/* Orders 
Order_ID, Date, Loading, Customer_ID, Employe_ID, Truck_ID, Destination*/
create table Comenzi_Clienti
(Nr_Comanda number(5) constraint CC_NRCO_PK Primary Key,Data_Comanda date constraint CC_DATA_NN Not Null,
Incarcatura varchar2(25) constraint CC_INCA_NN Not Null,Id_Client number(4) constraint CC_IDC_FK References 
Clienti_Firma(Id_Client),Id_Angajat number(3) constraint CC_IDA_FK References AngajatiFirma(Id_Angajat),
Cod_Camion number(5) constraint CC_codc_fk References Camioane(Cod_Camion),Destinatia varchar2(25) constraint CC_D_NN Not Null);

Insert into Comenzi_Clienti
values(404,TO_DATE('21.MAY.2021','DD/MM/YYYY'),'Tractor',101,3,3,'Iasi');

Insert into Comenzi_Clienti
values(405,TO_DATE('10.DEC.2020','DD/MM/YYYY'),'Mere',102,4,4,'Bucuresti');

Insert into Comenzi_Clienti
values(406,TO_DATE('04.JAN.2021','DD/MM/YYYY'),'Dulciuri',104,5,5,'Constanta');

Insert into Comenzi_Clienti
values(402,TO_DATE('01.MAR.2021','DD/MM/YYYY'),'Jucarii',107,1,1,'Brasov');

Insert into Comenzi_Clienti
values(403,TO_DATE('17.MAR.2021','DD/MM/YYYY'),'Chimicale',108,2,2,'Sibiu');

Insert into Comenzi_Clienti
values(407,TO_DATE('26.APR.2021','DD/MM/YYYY'),'BOBCAT',101,6,6,'Braila');

Insert into Comenzi_Clienti
values(408,TO_DATE('19.DEC.2020','DD/MM/YYYY'),'BOBCAT',105,7,7,'Timisoara');

Insert into Comenzi_Clienti
values(409,TO_DATE('13.DEC.2020','DD/MM/YYYY'),'Plastic',110,8,8,'Ploiesti');

Insert into Comenzi_Clienti
values(410,TO_DATE('09.FEB.2021','DD/MM/YYYY'),'Jucarii',107,9,9,'Oradea');

Insert into Comenzi_Clienti
values(411,TO_DATE('25.JUN.2021','DD/MM/YYYY'),'Tuburi',103,10,10,'Pitesti');

Insert into Comenzi_Clienti
values(412,TO_DATE('11.APR.2021','DD/MM/YYYY'),'Materiale Contructie',106,4,4,'Constanta');

Insert into Comenzi_Clienti
values(413,TO_DATE('21.FEB.2021','DD/MM/YYYY'),'Jucarii',107,11,11,'Braila');

Insert into Comenzi_Clienti
values(414,TO_DATE('19.MAY.2021','DD/MM/YYYY'),'Plastic',110,2,2,'Pitesti');

insert into comenzi_clienti
values(415,TO_DATE('02.APR.2020','DD/MM/YYYY'),'Mere',102,4,4,'Cluj');

insert into comenzi_clienti
values(416,TO_DATE('25.APR.2020','DD/MM/YYYY'),'Materiale Constructie',106,5,5,'Tulcea');

insert into comenzi_clienti
values(417,TO_DATE('01.MAY.2020','DD/MM/YYYY'),'Tractor',101,10,10,'Suceava');