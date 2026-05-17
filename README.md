# DevOps_05_Docker
Repozitoř k 5. lekci

# DevOps Úkol 05: CI/CD Pipeline s Dockerem, GitHub Actions a Terraformem

Tento repozitář obsahuje řešení domácího úkolu zaměřeného na vytvoření plně automatizované CI/CD pipeline pro Python aplikaci. Projekt kombinuje testování kódu, kontejnerizaci, automatizaci infrastruktury a nasazení do AWS cloudu.

## 🎯 Cíle projektu

* **Automatické testování:** Spuštění unit testů v Pythonu při každé změně kódu.
* **Kontejnerizace:** Sestavení optimalizovaného Docker image pomocí `python:3.9-slim`.
* **Ukládání artefaktů:** Automatická tvorba a uložení `.zip` balíčku s aplikací na GitHub.
* **Infrastruktura jako kód:** Vytvoření privátního AWS ECR registru a Lifecycle policy pomocí Terraformu.
* **Automatický CD Deployment:** Bezpečné přihlášení do AWS a push hotového image s unikátním Git tagem přímo z GitHub Actions.
* **Zajištění bezpečnosti:** Správa tajných klíčů přes GitHub Secrets a ignorování citlivých Terraform dat v `.gitignore`.

## 📂 Struktura projektu

Projekt je striktně rozdělen na aplikační část, automatizaci a infrastrukturu:
* **`demoapp/` & `tests/`** – Zdrojový kód kalkulačky a její unit testy.
* **`Dockerfile`** – Instrukce pro sestavení izolovaného a lehkého kontejneru.
* **`.github/workflows/docker-build.yml`** – Hlavní pipeline definující joby `build-and-test` a `deploy-to-ecr`.
* **`terraform/`** – IaC konfigurace pro AWS (`main.tf` s podporou `force_delete`, `variables.tf`, `outputs.tf`).

## 🚀 Návod k použití

### 1. Lokální testování (RHEL / Podman / Docker)

Ověření funkčnosti testů a buildu na lokálním serveru:
```bash
# Sestavení lokálního image
docker build -t python-calculator:latest .

# Interaktivní testování uvnitř kontejneru
docker run -it python-calculator:latest /bin/bash
```

### 2. Manuální správa infrastruktury a push
Vyzkoušení Terraformu a AWS CLI přímo z konzole serveru:

```Bash
# Přesun do složky a inicializace cloudu
cd terraform/
terraform init
terraform apply -auto-approve

# Autentizace Dockeru a ruční vytlačení image do ECR
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 767469526221.dkr.ecr.eu-central-1.amazonaws.com
docker tag python-calculator:latest [767469526221.dkr.ecr.eu-central-1.amazonaws.com/python-calculator:manual-test](https://767469526221.dkr.ecr.eu-central-1.amazonaws.com/python-calculator:manual-test)
docker push [767469526221.dkr.ecr.eu-central-1.amazonaws.com/python-calculator:manual-test](https://767469526221.dkr.ecr.eu-central-1.amazonaws.com/python-calculator:manual-test)

# Ověření nahraných obrázků v cloudu
aws ecr list-images --repository-name python-calculator --region eu-central-1
```

### 3. Automatizovaný CI/CD Běh
Pro spuštění kompletní automatizace stačí nastavit tajné klíče AWS_ACCESS_KEY_ID a AWS_SECRET_ACCESS_KEY v sekci Settings -> Secrets and variables -> Actions na GitHubu a poslat kód do větví:

```Bash
git add .
git commit -m "DevOps 05: Dokončení automatické pipeline"
git push origin main
```

Pipeline automaticky kód otestuje, vytvoří .zip artefakt a nasadí nový image do ECR.

### 4. Úklid infrastruktury (Cleanup)
Pro zamezení zbytečných nákladů v AWS vyčistíme infrastrukturu přímo přes AWS CLI díky vynucenému smazání, které vymaže repozitář i s nahranými obrázky:

```Bash
aws ecr delete-repository --repository-name python-calculator --region eu-central-1 --force
terraform destroy -auto-approve
```

### 🔒 Bezpečnost
Všechny lokální stavové soubory Terraformu (.tfstate), složky .terraform/ a mezipaměti Pythonu (__pycache__) jsou přísně ignorovány v souboru .gitignore, aby se zamezilo jejich úniku do veřejného Git repozitáře.