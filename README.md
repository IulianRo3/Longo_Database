This is an imaginary database, created for a college project, which took place over a period of about a year.
Story of the database:
Our role is to create a fluid organization in the company, where each employee has their own truck, to keep track of our customers 
(company of origin, contact phone, name, etc.) and the orders they give. , which requires extra attention not to have, for example, 
two orders from two different customers in two different corners of the country with the same truck or driver in a short time, so as 
to avoid delays and have satisfied customers.

Tabela camioane:      (Trucks Table)                   Tabela clientilor:   (Customers Table)
-Codul Camionului;    (Trucks ID)                      -Id Client;          (Customer ID)
-Marca;               (Brand)                          -Nume                (Customer Surname)
-Modelul;             (Type)                           -Prenume             (Customer Name)
-Masa totala admisa;  (Total mass allowed)             -Telefon             (Phone Number)
-Puterea in cai putere;(HorsePower)                    -Firma               (Company)
-Kilometrajul;        (Tachometer)                     -Sex                 (Gender)
-Id Angajat;          (Employer ID)
-An;                  (Year)

Tabela angajatilor:  (Employee Table)                   Tabela comenzilor:  (Orders Table)
-Id Sofer;           (Driver ID)                        -Nr. Comenzii;      (Order Number)
-Nume;               (Employer Surname)                 -Data;              (Date)
-Prenume;            (Employer Name)                    -Cod_Camion;        (Truck ID)
-Email;              (Email)                            -Incarcatura;       (Loading)
-Id Functie;         (Employee Function)                -Id Client;         (Customer ID)
-Salariul;           (Salary)                           -Id Angajati;       (Employer ID)
-Id Manager;         (Manager ID)                       -Destinatia;        (Destination)
-An angajare;        (Year of Employment)                   


![WhatsApp Image 2021-08-16 at 12 45 50](https://user-images.githubusercontent.com/61887287/129544640-2d885ea8-9ecc-4392-aca6-3f837bd34b78.jpeg)
