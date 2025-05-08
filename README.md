#  PROGETTO DI FINE CORSO
          Si vuole implementare un'infrastruttura su Azure
          utilizzando Terraform che consiste in un cluster K3s ad
          alta disponibilità con 3 nodi. Su questo cluster verrà
          deployato un progetto Docker fornito e disponibile al
          seguente indirizzo
          https://github.com/MrMagicalSoftware/docker-k8s/blob/
          main/esercitazione-docker-file.md
##

 Ho creato i miei file all'interno di progetto-finale
![image](https://github.com/user-attachments/assets/488a81e6-8392-4830-adb8-b7f467b23d4f)


         terraform init -> scarica i provider e prepara Terraform.
#
         terraform plan -> Verifica i cambiamenti prima del deploy.
#
         terraform apply -> Applica le modifiche e crea le risorse.

#
Una volta creata la VM e fatto l'apply è andato. 
Mi sono spostata su powershell per avviare la vm utilizzando la chiave ssh

![Screenshot 2025-05-08 065626](https://github.com/user-attachments/assets/30602280-e383-4f05-b2f3-cb4b9c4d976b)

## 

# Configurazione manuale
Procedo alla configurazione manuale
#

Entro nella vm dopo aver fatto il login su azure
![Screenshot 2025-05-08 092914](https://github.com/user-attachments/assets/3bf4efa3-1f6d-44e5-a6b5-bd8c3a36f586)
#

![Screenshot 2025-05-08 093101](https://github.com/user-attachments/assets/532548ee-919c-4971-8722-de4e9066465d)
# 
non avevo i permessi
![Screenshot 2025-05-08 093116](https://github.com/user-attachments/assets/105c0afd-260c-474b-93cd-524f6991acba)

resta bloccato per più di 30 min
![Screenshot 2025-05-08 093123](https://github.com/user-attachments/assets/726241dc-41ca-4097-ad82-222356cb9022)
#
che faccio??

il processo si blocca quindi verifico cosa è andato storto:
mi assicuro che i file ci siano in hello-docker

![Screenshot 2025-05-08 094317](https://github.com/user-attachments/assets/da8db211-b940-42d2-a99f-a713fc3d1a16)

L'immagine mi appare
![Screenshot 2025-05-08 095215](https://github.com/user-attachments/assets/04dbd469-b100-4581-ab5b-276968565e04)

Il Dockerfile non risulta correttamente installato
![Screenshot 2025-05-08 100426](https://github.com/user-attachments/assets/14784c00-ced7-436c-b570-13cfcd10d5f3)

#
quindi faccio una pulizia 

#

![Screenshot 2025-05-08 103902](https://github.com/user-attachments/assets/3743845d-5512-4d18-89a1-553aa902ba28)

#
e riprovo a mandare  sudo docker build -t hello-docker .
![Screenshot 2025-05-08 104948](https://github.com/user-attachments/assets/2a332e6a-4c96-45b0-9274-fb1e9fd13575)

#
Mi autentico su Docker 
![Screenshot 2025-05-08 110637](https://github.com/user-attachments/assets/d1ccf475-6631-4bc3-b808-cb0a74a0001c)

provo a rimandare sudo docker build -t hello-docker .

il processo è bloccato.


## Faccio il destroy e ricomincio, mandando tutti i comandi su setup.sh


