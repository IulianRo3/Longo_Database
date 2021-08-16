This is an imaginary database, created for a college project, which took place over a period of about a year.
Story of the database:
Our role is to create a fluid organization in the company, where each employee has their own truck, to keep track of our customers 
(company of origin, contact phone, name, etc.) and the orders they give. , which requires extra attention not to have, for example, 
two orders from two different customers in two different corners of the country with the same truck or driver in a short time, so as 
to avoid delays and have satisfied customers.

Tabela camioane:      (Trucks Table)                  
-Codul Camionului;    (Trucks ID)                     
-Marca;               (Brand)                        
-Modelul;             (Type)                          
-Masa totala admisa;  (Total mass allowed)            
-Puterea in cai putere;(HorsePower)                  
-Kilometrajul;        (Tachometer)                     
-Id Angajat;          (Employer ID)
-An;                  (Year)

Tabela angajatilor:  (Employee Table)                   
-Id Sofer;           (Driver ID)                        
-Nume;               (Employer Surname)                 
-Prenume;            (Employer Name)                    
-Email;              (Email)                            
-Id Functie;         (Employee Function)                
-Salariul;           (Salary)                          
-Id Manager;         (Manager ID)                       
-An angajare;        (Year of Employment)                   

Tabela clientilor:   (Customers Table)
-Id Client;          (Customer ID)
-Nume                (Customer Surname)
-Prenume             (Customer Name)
-Telefon             (Phone Number)
-Firma               (Company)
-Sex                 (Gender)

Tabela comenzilor:  (Orders Table)
-Nr. Comenzii;      (Order Number)
-Data;              (Date)
-Cod_Camion;        (Truck ID)
-Incarcatura;       (Loading)
-Id Client;         (Customer ID)
-Id Angajati;       (Employer ID)
-Destinatia;        (Destination)

![WhatsApp Image 2021-08-16 at 12 45 50](https://user-images.githubusercontent.com/61887287/129544640-2d885ea8-9ecc-4392-aca6-3f837bd34b78.jpeg)
